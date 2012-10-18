Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab2JRLWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 07:22:21 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:55881 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937Ab2JRLWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 07:22:19 -0400
X-IronPort-AV: E=Sophos;i="4.80,606,1344211200"; 
   d="scan'208";a="15252244"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Oliver Chick <oliver.chick@citrix.com>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC] Persistent grant maps for xen blk drivers
Date: Thu, 18 Oct 2012 13:22:01 +0200
Message-ID: <1350559321-19066-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements persistent grants for the xen-blk{front,back}
mechanism. The effect of this change is to reduce the number of unmap
operations performed, since they cause a (costly) TLB shootdown. This
allows the I/O performance to scale better when a large number of VMs
are performing I/O.

Previously, the blkfront driver was supplied a bvec[] from the request
queue. This was granted to dom0; dom0 performed the I/O and wrote
directly into the grant-mapped memory and unmapped it; blkfront then
removed foreign access for that grant. The cost of unmapping scales
badly with the number of CPUs in Dom0. An experiment showed that when
Dom0 has 24 VCPUs, and guests are performing parallel I/O to a
ramdisk, the IPIs from performing unmap's is a bottleneck at 5 guests
(at which point 650,000 IOPS are being performed in total). If more
than 5 guests are used, the performance declines. By 10 guests, only
400,000 IOPS are being performed.

This patch improves performance by only unmapping when the connection
between blkfront and back is broken.

On startup blkfront notifies blkback that it is using persistent
grants, and blkback will do the same. If blkback is not capable of
persistent mapping, blkfront will still use the same grants, since it
is compatible with the previous protocol, and simplifies the code
complexity in blkfront.

To perform a read, in persistent mode, blkfront uses a separate pool
of pages that it maps to dom0. When a request comes in, blkfront
transmutes the request so that blkback will write into one of these
free pages. Blkback keeps note of which grefs it has already
mapped. When a new ring request comes to blkback, it looks to see if
it has already mapped that page. If so, it will not map it again. If
the page hasn't been previously mapped, it is mapped now, and a record
is kept of this mapping. Blkback proceeds as usual. When blkfront is
notified that blkback has completed a request, it memcpy's from the
shared memory, into the bvec supplied. A record that the {gref, page}
tuple is mapped, and not inflight is kept.

Writes are similar, except that the memcpy is peformed from the
supplied bvecs, into the shared pages, before the request is put onto
the ring.

Blkback stores a mapping of grefs=>{page mapped to by gref} in
a red-black tree. As the grefs are not known apriori, and provide no
guarantees on their ordering, we have to perform a search
through this tree to find the page, for every gref we receive. This
operation takes O(log n) time in the worst case.

The maximum number of grants that blkback will persistenly map is
currently set to RING_SIZE * BLKIF_MAX_SEGMENTS_PER_REQUEST, to
prevent a malicios guest from attempting a DoS, by supplying fresh
grefs, causing the Dom0 kernel to map excessively. If a guest
is using persistent grants and exceeds the maximum number of grants to
map persistenly the newly passed grefs will be mapped and unmaped.
Using this approach, we can have requests that mix persistent and
non-persistent grants, and we need to handle them correctly.
This allows us to set the maximum number of persistent grants to a
lower value than RING_SIZE * BLKIF_MAX_SEGMENTS_PER_REQUEST, although
setting it will lead to unpredictable performance.

In writing this patch, the question arrises as to if the additional
cost of performing memcpys in the guest (to/from the pool of granted
pages) outweigh the gains of not performing TLB shootdowns. The answer
to that question is `no'. There appears to be very little, if any
additional cost to the guest of using persistent grants. There is
perhaps a small saving, from the reduced number of hypercalls
performed in granting, and ending foreign access.

Signed-off-by: Oliver Chick <oliver.chick@citrix.com>
Signed-off-by: Roger Pau Monne <roger.pau@citrix.com>
Cc: <konrad.wilk@oracle.com>
Cc: <linux-kernel@vger.kernel.org>
---
Benchmarks showing the impact of this patch in blk performance can be
found at:

http://xenbits.xensource.com/people/royger/persistent_grants/
---
 drivers/block/xen-blkback/blkback.c |  279 +++++++++++++++++++++++++++++++---
 drivers/block/xen-blkback/common.h  |   17 ++
 drivers/block/xen-blkback/xenbus.c  |   16 ++-
 drivers/block/xen-blkfront.c        |  183 ++++++++++++++++++++----
 4 files changed, 442 insertions(+), 53 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index c6decb9..2b982b2 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -78,6 +78,7 @@ struct pending_req {
 	unsigned short		operation;
 	int			status;
 	struct list_head	free_list;
+	unsigned int		unmap_seg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 };
 
 #define BLKBACK_INVALID_HANDLE (~0)
@@ -98,6 +99,30 @@ struct xen_blkbk {
 static struct xen_blkbk *blkbk;
 
 /*
+ * Maximum number of grant pages that can be mapped in blkback.
+ * BLKIF_MAX_SEGMENTS_PER_REQUEST * RING_SIZE is the maximum number of
+ * pages that blkback will persistently map.
+ */
+static inline unsigned int max_mapped_grant_pages(enum blkif_protocol protocol)
+{
+	switch (protocol) {
+	case BLKIF_PROTOCOL_NATIVE:
+		return __CONST_RING_SIZE(blkif, PAGE_SIZE) *
+			   BLKIF_MAX_SEGMENTS_PER_REQUEST;
+	case BLKIF_PROTOCOL_X86_32:
+		return __CONST_RING_SIZE(blkif_x86_32, PAGE_SIZE) *
+			   BLKIF_MAX_SEGMENTS_PER_REQUEST;
+	case BLKIF_PROTOCOL_X86_64:
+		return __CONST_RING_SIZE(blkif_x86_64, PAGE_SIZE) *
+			   BLKIF_MAX_SEGMENTS_PER_REQUEST;
+	default:
+		BUG();
+	}
+	return 0;
+}
+
+
+/*
  * Little helpful macro to figure out the index and virtual address of the
  * pending_pages[..]. For each 'pending_req' we have have up to
  * BLKIF_MAX_SEGMENTS_PER_REQUEST (11) pages. The seg would be from 0 through
@@ -128,6 +153,57 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 static void make_response(struct xen_blkif *blkif, u64 id,
 			  unsigned short op, int st);
 
+#define foreach_grant(pos, rbtree, node) \
+	for ((pos) = container_of(rb_first((rbtree)), typeof(*(pos)), node); \
+	     &(pos)->node != NULL; \
+	     (pos) = container_of(rb_next(&(pos)->node), typeof(*(pos)), node))
+
+
+static void add_persistent_gnt(struct rb_root *root,
+			       struct persistent_gnt *persistent_gnt)
+{
+	struct rb_node **new = &(root->rb_node), *parent = NULL;
+	struct persistent_gnt *this;
+
+	/* Figure out where to put new node */
+	while (*new) {
+		this = container_of(*new, struct persistent_gnt, node);
+
+		parent = *new;
+		if (persistent_gnt->gnt < this->gnt)
+			new = &((*new)->rb_left);
+		else if (persistent_gnt->gnt > this->gnt)
+			new = &((*new)->rb_right);
+		else {
+			pr_alert(DRV_PFX " trying to add a gref that's already in the tree\n");
+			BUG();
+		}
+	}
+
+	/* Add new node and rebalance tree. */
+	rb_link_node(&(persistent_gnt->node), parent, new);
+	rb_insert_color(&(persistent_gnt->node), root);
+}
+
+static struct persistent_gnt *get_persistent_gnt(struct rb_root *root,
+						 grant_ref_t gref)
+{
+	struct persistent_gnt *data;
+	struct rb_node *node = root->rb_node;
+
+	while (node) {
+		data = container_of(node, struct persistent_gnt, node);
+
+		if (gref < data->gnt)
+			node = node->rb_left;
+		else if (gref > data->gnt)
+			node = node->rb_right;
+		else
+			return data;
+	}
+	return NULL;
+}
+
 /*
  * Retrieve from the 'pending_reqs' a free pending_req structure to be used.
  */
@@ -274,6 +350,11 @@ int xen_blkif_schedule(void *arg)
 {
 	struct xen_blkif *blkif = arg;
 	struct xen_vbd *vbd = &blkif->vbd;
+	struct gnttab_unmap_grant_ref unmap[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct page *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct persistent_gnt *persistent_gnt;
+	int ret = 0;
+	int segs_to_unmap = 0;
 
 	xen_blkif_get(blkif);
 
@@ -301,6 +382,32 @@ int xen_blkif_schedule(void *arg)
 			print_stats(blkif);
 	}
 
+	/* Free all persistent grant pages */
+	foreach_grant(persistent_gnt, &blkif->persistent_gnts, node) {
+		BUG_ON(persistent_gnt->handle == BLKBACK_INVALID_HANDLE);
+		gnttab_set_unmap_op(&unmap[segs_to_unmap],
+		    (unsigned long) pfn_to_kaddr(page_to_pfn(
+			persistent_gnt->page)),
+		    GNTMAP_host_map,
+		    persistent_gnt->handle);
+
+		pages[segs_to_unmap] = persistent_gnt->page;
+		rb_erase(&persistent_gnt->node, &blkif->persistent_gnts);
+		kfree(persistent_gnt);
+		blkif->persistent_gnt_c--;
+
+		if (++segs_to_unmap == BLKIF_MAX_SEGMENTS_PER_REQUEST ||
+			!rb_next(&persistent_gnt->node)) {
+			ret = gnttab_unmap_refs(unmap, NULL, pages,
+						segs_to_unmap);
+			BUG_ON(ret);
+			segs_to_unmap = 0;
+		}
+	}
+
+	BUG_ON(blkif->persistent_gnt_c != 0);
+	BUG_ON(!RB_EMPTY_ROOT(&blkif->persistent_gnts));
+
 	if (log_stats)
 		print_stats(blkif);
 
@@ -327,6 +434,8 @@ static void xen_blkbk_unmap(struct pending_req *req)
 	int ret;
 
 	for (i = 0; i < req->nr_pages; i++) {
+		if (!req->unmap_seg[i])
+			continue;
 		handle = pending_handle(req, i);
 		if (handle == BLKBACK_INVALID_HANDLE)
 			continue;
@@ -343,12 +452,26 @@ static void xen_blkbk_unmap(struct pending_req *req)
 
 static int xen_blkbk_map(struct blkif_request *req,
 			 struct pending_req *pending_req,
-			 struct seg_buf seg[])
+			 struct seg_buf seg[],
+			 struct page *pages[])
 {
 	struct gnttab_map_grant_ref map[BLKIF_MAX_SEGMENTS_PER_REQUEST];
-	int i;
+	struct persistent_gnt *persistent_gnts[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct page *pages_to_gnt[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct persistent_gnt *persistent_gnt = NULL;
+	struct xen_blkif *blkif = pending_req->blkif;
+	phys_addr_t addr = 0;
+	int i, j;
+	int new_map;
 	int nseg = req->u.rw.nr_segments;
+	int segs_to_map = 0;
 	int ret = 0;
+	int use_persistent_gnts;
+
+	use_persistent_gnts = (blkif->vbd.feature_gnt_persistent);
+
+	BUG_ON(blkif->persistent_gnt_c >
+		   max_mapped_grant_pages(pending_req->blkif->blk_protocol));
 
 	/*
 	 * Fill out preq.nr_sects with proper amount of sectors, and setup
@@ -358,36 +481,141 @@ static int xen_blkbk_map(struct blkif_request *req,
 	for (i = 0; i < nseg; i++) {
 		uint32_t flags;
 
-		flags = GNTMAP_host_map;
-		if (pending_req->operation != BLKIF_OP_READ)
-			flags |= GNTMAP_readonly;
-		gnttab_set_map_op(&map[i], vaddr(pending_req, i), flags,
-				  req->u.rw.seg[i].gref,
-				  pending_req->blkif->domid);
+		if (use_persistent_gnts)
+			persistent_gnt = get_persistent_gnt(
+				&blkif->persistent_gnts,
+				req->u.rw.seg[i].gref);
+
+		if (persistent_gnt) {
+			/*
+			 * We are using persistent grants and
+			 * the grant is already mapped
+			 */
+			new_map = 0;
+		} else if (use_persistent_gnts &&
+			   blkif->persistent_gnt_c <
+			   max_mapped_grant_pages(blkif->blk_protocol)) {
+			/*
+			 * We are using persistent grants, the grant is
+			 * not mapped but we have room for it
+			 */
+			new_map = 1;
+			persistent_gnt = kzalloc(
+				sizeof(struct persistent_gnt),
+				GFP_KERNEL);
+			if (!persistent_gnt)
+				return -ENOMEM;
+			persistent_gnt->page = alloc_page(GFP_KERNEL);
+			if (!persistent_gnt->page) {
+				kfree(persistent_gnt);
+				return -ENOMEM;
+			}
+			persistent_gnt->gnt = req->u.rw.seg[i].gref;
+
+			pages_to_gnt[segs_to_map] =
+				persistent_gnt->page;
+			addr = (unsigned long) pfn_to_kaddr(
+				page_to_pfn(persistent_gnt->page));
+
+			add_persistent_gnt(&blkif->persistent_gnts,
+				persistent_gnt);
+			blkif->persistent_gnt_c++;
+			pr_debug(DRV_PFX " grant %u added to the tree of persistent grants, using %u/%u\n",
+				 persistent_gnt->gnt, blkif->persistent_gnt_c,
+				 max_mapped_grant_pages(blkif->blk_protocol));
+		} else {
+			/*
+			 * We are either using persistent grants and
+			 * hit the maximum limit of grants mapped,
+			 * or we are not using persistent grants.
+			 */
+			if (use_persistent_gnts &&
+				!blkif->vbd.overflow_max_grants) {
+				blkif->vbd.overflow_max_grants = 1;
+				pr_alert(DRV_PFX " domain %u, device %#x is using maximum number of persistent grants\n",
+					 blkif->domid, blkif->vbd.handle);
+			}
+			new_map = 1;
+			pages[i] = blkbk->pending_page(pending_req, i);
+			addr = vaddr(pending_req, i);
+			pages_to_gnt[segs_to_map] =
+				blkbk->pending_page(pending_req, i);
+		}
+
+		if (persistent_gnt) {
+			pages[i] = persistent_gnt->page;
+			persistent_gnts[i] = persistent_gnt;
+		} else {
+			persistent_gnts[i] = NULL;
+		}
+
+		if (new_map) {
+			flags = GNTMAP_host_map;
+			if (!persistent_gnt &&
+			    (pending_req->operation != BLKIF_OP_READ))
+				flags |= GNTMAP_readonly;
+			gnttab_set_map_op(&map[segs_to_map++], addr,
+					  flags, req->u.rw.seg[i].gref,
+					  blkif->domid);
+		}
 	}
 
-	ret = gnttab_map_refs(map, NULL, &blkbk->pending_page(pending_req, 0), nseg);
-	BUG_ON(ret);
+	if (segs_to_map) {
+		ret = gnttab_map_refs(map, NULL, pages_to_gnt, segs_to_map);
+		BUG_ON(ret);
+	}
 
 	/*
 	 * Now swizzle the MFN in our domain with the MFN from the other domain
 	 * so that when we access vaddr(pending_req,i) it has the contents of
 	 * the page from the other domain.
 	 */
-	for (i = 0; i < nseg; i++) {
-		if (unlikely(map[i].status != 0)) {
-			pr_debug(DRV_PFX "invalid buffer -- could not remap it\n");
-			map[i].handle = BLKBACK_INVALID_HANDLE;
-			ret |= 1;
+	for (i = 0, j = 0; i < nseg; i++) {
+		if (!persistent_gnts[i] || !persistent_gnts[i]->handle) {
+			/* This is a newly mapped grant */
+			BUG_ON(j >= segs_to_map);
+			if (unlikely(map[j].status != 0)) {
+				pr_debug(DRV_PFX "invalid buffer -- could not remap it\n");
+				map[j].handle = BLKBACK_INVALID_HANDLE;
+				ret |= 1;
+				if (persistent_gnts[i]) {
+					rb_erase(&persistent_gnts[i]->node,
+						 &blkif->persistent_gnts);
+					blkif->persistent_gnt_c--;
+					kfree(persistent_gnts[i]);
+					persistent_gnts[i] = NULL;
+				}
+			}
+		}
+		if (persistent_gnts[i]) {
+			if (!persistent_gnts[i]->handle) {
+				/*
+				 * If this is a new persistent grant
+				 * save the handler
+				 */
+				persistent_gnts[i]->handle = map[j].handle;
+				persistent_gnts[i]->dev_bus_addr =
+					map[j++].dev_bus_addr;
+			}
+			pending_handle(pending_req, i) =
+				persistent_gnts[i]->handle;
+			pending_req->unmap_seg[i] = 0;
+
+			if (ret)
+				continue;
+
+			seg[i].buf = persistent_gnts[i]->dev_bus_addr |
+				(req->u.rw.seg[i].first_sect << 9);
+		} else {
+			pending_handle(pending_req, i) = map[j].handle;
+			pending_req->unmap_seg[i] = 1;
+
+			if (ret)
+				continue;
+
+			seg[i].buf = map[j++].dev_bus_addr |
+				(req->u.rw.seg[i].first_sect << 9);
 		}
-
-		pending_handle(pending_req, i) = map[i].handle;
-
-		if (ret)
-			continue;
-
-		seg[i].buf  = map[i].dev_bus_addr |
-			(req->u.rw.seg[i].first_sect << 9);
 	}
 	return ret;
 }
@@ -590,6 +818,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	int operation;
 	struct blk_plug plug;
 	bool drain = false;
+	struct page *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 
 	switch (req->operation) {
 	case BLKIF_OP_READ:
@@ -676,7 +905,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	 * the hypercall to unmap the grants - that is all done in
 	 * xen_blkbk_unmap.
 	 */
-	if (xen_blkbk_map(req, pending_req, seg))
+	if (xen_blkbk_map(req, pending_req, seg, pages))
 		goto fail_flush;
 
 	/*
@@ -688,7 +917,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	for (i = 0; i < nseg; i++) {
 		while ((bio == NULL) ||
 		       (bio_add_page(bio,
-				     blkbk->pending_page(pending_req, i),
+				     pages[i],
 				     seg[i].nsec << 9,
 				     seg[i].buf & ~PAGE_MASK) == 0)) {
 
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index 9ad3b5e..6c08ee9 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -34,6 +34,7 @@
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
 #include <linux/io.h>
+#include <linux/rbtree.h>
 #include <asm/setup.h>
 #include <asm/pgalloc.h>
 #include <asm/hypervisor.h>
@@ -160,10 +161,22 @@ struct xen_vbd {
 	sector_t		size;
 	bool			flush_support;
 	bool			discard_secure;
+
+	unsigned int		feature_gnt_persistent:1;
+	unsigned int		overflow_max_grants:1;
 };
 
 struct backend_info;
 
+
+struct persistent_gnt {
+	struct page *page;
+	grant_ref_t gnt;
+	grant_handle_t handle;
+	uint64_t dev_bus_addr;
+	struct rb_node node;
+};
+
 struct xen_blkif {
 	/* Unique identifier for this interface. */
 	domid_t			domid;
@@ -190,6 +203,10 @@ struct xen_blkif {
 	struct task_struct	*xenblkd;
 	unsigned int		waiting_reqs;
 
+	/* frontend feature information */
+	struct rb_root		persistent_gnts;
+	unsigned int		persistent_gnt_c;
+
 	/* statistics */
 	unsigned long		st_print;
 	int			st_rd_req;
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 4f66171..9f88b4e 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -118,6 +118,7 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 	atomic_set(&blkif->drain, 0);
 	blkif->st_print = jiffies;
 	init_waitqueue_head(&blkif->waiting_to_free);
+	blkif->persistent_gnts.rb_node = NULL;
 
 	return blkif;
 }
@@ -721,6 +722,7 @@ static int connect_ring(struct backend_info *be)
 	struct xenbus_device *dev = be->dev;
 	unsigned long ring_ref;
 	unsigned int evtchn;
+	unsigned int pers_grants;
 	char protocol[64] = "";
 	int err;
 
@@ -750,8 +752,18 @@ static int connect_ring(struct backend_info *be)
 		xenbus_dev_fatal(dev, err, "unknown fe protocol %s", protocol);
 		return -1;
 	}
-	pr_info(DRV_PFX "ring-ref %ld, event-channel %d, protocol %d (%s)\n",
-		ring_ref, evtchn, be->blkif->blk_protocol, protocol);
+	err = xenbus_gather(XBT_NIL, dev->otherend,
+			    "feature-persistent-grants", "%u",
+			    &pers_grants, NULL);
+	if (err)
+		pers_grants = 0;
+
+	be->blkif->vbd.feature_gnt_persistent = pers_grants;
+	be->blkif->vbd.overflow_max_grants = 0;
+
+	pr_info(DRV_PFX "ring-ref %ld, event-channel %d, protocol %d (%s) persistent %d\n",
+		ring_ref, evtchn, be->blkif->blk_protocol, protocol,
+		pers_grants);
 
 	/* Map the shared frame, irq etc. */
 	err = xen_blkif_map(be->blkif, ring_ref, evtchn);
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 2c2d2e5..206d422 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -44,6 +44,7 @@
 #include <linux/mutex.h>
 #include <linux/scatterlist.h>
 #include <linux/bitmap.h>
+#include <linux/llist.h>
 
 #include <xen/xen.h>
 #include <xen/xenbus.h>
@@ -64,10 +65,17 @@ enum blkif_state {
 	BLKIF_STATE_SUSPENDED,
 };
 
+struct grant {
+	grant_ref_t gref;
+	unsigned long pfn;
+	struct llist_node node;
+};
+
 struct blk_shadow {
 	struct blkif_request req;
 	struct request *request;
 	unsigned long frame[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct grant *grants_used[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 };
 
 static DEFINE_MUTEX(blkfront_mutex);
@@ -97,6 +105,8 @@ struct blkfront_info
 	struct work_struct work;
 	struct gnttab_free_callback callback;
 	struct blk_shadow shadow[BLK_RING_SIZE];
+	struct llist_head persistent_gnts;
+	unsigned int persistent_gnts_c;
 	unsigned long shadow_free;
 	unsigned int feature_flush;
 	unsigned int flush_op;
@@ -287,21 +297,36 @@ static int blkif_queue_request(struct request *req)
 	unsigned long id;
 	unsigned int fsect, lsect;
 	int i, ref;
+
+	/*
+	 * Used to store if we are able to queue the request by just using
+	 * existing persistent grants (0), or if we have to get new grants,
+	 * as there are not sufficiently many free.
+	 */
+	int new_persistent_gnts;
 	grant_ref_t gref_head;
+	struct page *granted_page;
+	struct grant *gnt_list_entry = NULL;
 	struct scatterlist *sg;
 
 	if (unlikely(info->connected != BLKIF_STATE_CONNECTED))
 		return 1;
 
-	if (gnttab_alloc_grant_references(
-		BLKIF_MAX_SEGMENTS_PER_REQUEST, &gref_head) < 0) {
-		gnttab_request_free_callback(
-			&info->callback,
-			blkif_restart_queue_callback,
-			info,
-			BLKIF_MAX_SEGMENTS_PER_REQUEST);
-		return 1;
-	}
+	/* Check if we have enought grants to allocate a requests */
+	if (info->persistent_gnts_c < BLKIF_MAX_SEGMENTS_PER_REQUEST) {
+		new_persistent_gnts = 1;
+		if (gnttab_alloc_grant_references(
+		    BLKIF_MAX_SEGMENTS_PER_REQUEST - info->persistent_gnts_c,
+		    &gref_head) < 0) {
+			gnttab_request_free_callback(
+				&info->callback,
+				blkif_restart_queue_callback,
+				info,
+				BLKIF_MAX_SEGMENTS_PER_REQUEST);
+			return 1;
+		}
+	} else
+		new_persistent_gnts = 0;
 
 	/* Fill out a communications ring structure. */
 	ring_req = RING_GET_REQUEST(&info->ring, info->ring.req_prod_pvt);
@@ -341,18 +366,73 @@ static int blkif_queue_request(struct request *req)
 		       BLKIF_MAX_SEGMENTS_PER_REQUEST);
 
 		for_each_sg(info->sg, sg, ring_req->u.rw.nr_segments, i) {
-			buffer_mfn = pfn_to_mfn(page_to_pfn(sg_page(sg)));
 			fsect = sg->offset >> 9;
 			lsect = fsect + (sg->length >> 9) - 1;
-			/* install a grant reference. */
-			ref = gnttab_claim_grant_reference(&gref_head);
-			BUG_ON(ref == -ENOSPC);
 
-			gnttab_grant_foreign_access_ref(
-					ref,
+			if (info->persistent_gnts_c) {
+				BUG_ON(llist_empty(&info->persistent_gnts));
+				gnt_list_entry = llist_entry(
+					llist_del_first(&info->persistent_gnts),
+					struct grant, node);
+
+				ref = gnt_list_entry->gref;
+				buffer_mfn = pfn_to_mfn(gnt_list_entry->pfn);
+				info->persistent_gnts_c--;
+			} else {
+				ref = gnttab_claim_grant_reference(&gref_head);
+				BUG_ON(ref == -ENOSPC);
+
+				gnt_list_entry =
+					kmalloc(sizeof(struct grant),
+							 GFP_ATOMIC);
+				if (!gnt_list_entry)
+					return -ENOMEM;
+
+				granted_page = alloc_page(GFP_ATOMIC);
+				if (!granted_page) {
+					kfree(gnt_list_entry);
+					return -ENOMEM;
+				}
+
+				gnt_list_entry->pfn =
+					page_to_pfn(granted_page);
+				gnt_list_entry->gref = ref;
+
+				buffer_mfn = pfn_to_mfn(page_to_pfn(
+								granted_page));
+				gnttab_grant_foreign_access_ref(ref,
 					info->xbdev->otherend_id,
-					buffer_mfn,
-					rq_data_dir(req));
+					buffer_mfn, 0);
+			}
+
+			info->shadow[id].grants_used[i] = gnt_list_entry;
+
+			if (rq_data_dir(req)) {
+				char *bvec_data;
+				void *shared_data;
+
+				BUG_ON(sg->offset + sg->length > PAGE_SIZE);
+
+				shared_data = kmap_atomic(
+					pfn_to_page(gnt_list_entry->pfn));
+				bvec_data = kmap_atomic(sg_page(sg));
+
+				/*
+				 * this does not wipe data stored outside the
+				 * range sg->offset..sg->offset+sg->length.
+				 * Therefore, blkback *could* see data from
+				 * previous requests. This is OK as long as
+				 * persistent grants are shared with just one
+				 * domain. It may need refactoring if This
+				 * changes
+				 */
+				memcpy(shared_data + sg->offset,
+				       bvec_data   + sg->offset,
+				       sg->length);
+
+				kunmap_atomic(bvec_data);
+				kunmap_atomic(shared_data);
+			}
 
 			info->shadow[id].frame[i] = mfn_to_pfn(buffer_mfn);
 			ring_req->u.rw.seg[i] =
@@ -368,7 +448,8 @@ static int blkif_queue_request(struct request *req)
 	/* Keep a private copy so we can reissue requests when recovering. */
 	info->shadow[id].req = *ring_req;
 
-	gnttab_free_grant_references(gref_head);
+	if (new_persistent_gnts)
+		gnttab_free_grant_references(gref_head);
 
 	return 0;
 }
@@ -480,7 +561,7 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size)
 static void xlvbd_flush(struct blkfront_info *info)
 {
 	blk_queue_flush(info->rq, info->feature_flush);
-	printk(KERN_INFO "blkfront: %s: %s: %s\n",
+	printk(KERN_INFO "blkfront: %s: %s: %s, using persistent grants\n",
 	       info->gd->disk_name,
 	       info->flush_op == BLKIF_OP_WRITE_BARRIER ?
 		"barrier" : (info->flush_op == BLKIF_OP_FLUSH_DISKCACHE ?
@@ -707,6 +788,9 @@ static void blkif_restart_queue(struct work_struct *work)
 
 static void blkif_free(struct blkfront_info *info, int suspend)
 {
+	struct llist_node *all_gnts;
+	struct grant *persistent_gnt;
+
 	/* Prevent new requests being issued until we fix things up. */
 	spin_lock_irq(&info->io_lock);
 	info->connected = suspend ?
@@ -714,6 +798,17 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 	/* No more blkif_request(). */
 	if (info->rq)
 		blk_stop_queue(info->rq);
+
+	/* Remove all persistent grants */
+	if (info->persistent_gnts_c) {
+		all_gnts = llist_del_all(&info->persistent_gnts);
+		llist_for_each_entry(persistent_gnt, all_gnts, node) {
+			gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
+			kfree(persistent_gnt);
+		}
+		info->persistent_gnts_c = 0;
+	}
+
 	/* No more gnttab callback work. */
 	gnttab_cancel_free_callback(&info->callback);
 	spin_unlock_irq(&info->io_lock);
@@ -734,13 +829,42 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 
 }
 
-static void blkif_completion(struct blk_shadow *s)
+static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
+			     struct blkif_response *bret)
 {
 	int i;
-	/* Do not let BLKIF_OP_DISCARD as nr_segment is in the same place
-	 * flag. */
-	for (i = 0; i < s->req.u.rw.nr_segments; i++)
-		gnttab_end_foreign_access(s->req.u.rw.seg[i].gref, 0, 0UL);
+	struct bio_vec *bvec;
+	struct req_iterator iter;
+	unsigned long flags;
+	char *bvec_data;
+	void *shared_data;
+	unsigned int offset = 0;
+
+	if (bret->operation == BLKIF_OP_READ) {
+		/*
+		 * Copy the data received from the backend into the bvec.
+		 * Since bv_len can be different from PAGE_SIZE, we need to
+		 * be sure we are actually copying the data from the right
+		 * shared page.
+		 */
+		rq_for_each_segment(bvec, s->request, iter) {
+			BUG_ON((bvec->bv_offset + bvec->bv_len) > PAGE_SIZE);
+			i = offset >> PAGE_SHIFT;
+			shared_data = kmap_atomic(
+				pfn_to_page(s->grants_used[i]->pfn));
+			bvec_data = bvec_kmap_irq(bvec, &flags);
+			memcpy(bvec_data, shared_data + bvec->bv_offset,
+				bvec->bv_len);
+			bvec_kunmap_irq(bvec_data, &flags);
+			kunmap_atomic(shared_data);
+			offset += bvec->bv_len;
+		}
+	}
+	/* Add the persistent grant into the list of free grants */
+	for (i = 0; i < s->req.u.rw.nr_segments; i++) {
+		llist_add(&s->grants_used[i]->node, &info->persistent_gnts);
+		info->persistent_gnts_c++;
+	}
 }
 
 static irqreturn_t blkif_interrupt(int irq, void *dev_id)
@@ -783,7 +907,7 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 		req  = info->shadow[id].request;
 
 		if (bret->operation != BLKIF_OP_DISCARD)
-			blkif_completion(&info->shadow[id]);
+			blkif_completion(&info->shadow[id], info, bret);
 
 		if (add_id_to_freelist(info, id)) {
 			WARN(1, "%s: response to %s (id %ld) couldn't be recycled!\n",
@@ -942,6 +1066,11 @@ again:
 		message = "writing protocol";
 		goto abort_transaction;
 	}
+	err = xenbus_printf(xbt, dev->nodename,
+			    "feature-persistent-grants", "%d", 1);
+	if (err)
+		dev_warn(&dev->dev,
+			 "writing persistent grants feature to xenbus");
 
 	err = xenbus_transaction_end(xbt, 0);
 	if (err) {
@@ -1029,6 +1158,8 @@ static int blkfront_probe(struct xenbus_device *dev,
 	spin_lock_init(&info->io_lock);
 	info->xbdev = dev;
 	info->vdevice = vdevice;
+	init_llist_head(&info->persistent_gnts);
+	info->persistent_gnts_c = 0;
 	info->connected = BLKIF_STATE_DISCONNECTED;
 	INIT_WORK(&info->work, blkif_restart_queue);
 
@@ -1093,7 +1224,7 @@ static int blkif_recover(struct blkfront_info *info)
 					req->u.rw.seg[j].gref,
 					info->xbdev->otherend_id,
 					pfn_to_mfn(info->shadow[req->u.rw.id].frame[j]),
-					rq_data_dir(info->shadow[req->u.rw.id].request));
+					0);
 		}
 		info->shadow[req->u.rw.id].req = *req;
 
-- 
1.7.7.5 (Apple Git-26)

