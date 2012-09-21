Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab2IUPwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:52:53 -0400
Received: from smtp.citrix.com ([66.165.176.89]:4603 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173Ab2IUPwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:52:50 -0400
X-IronPort-AV: E=Sophos;i="4.80,463,1344211200"; 
   d="scan'208";a="38742075"
From: Oliver Chick <oliver.chick@citrix.com>
To: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com
CC: Oliver Chick <oliver.chick@citrix.com>
Subject: [PATCH v2] Persistent grant maps for xen blk drivers
Date: Fri, 21 Sep 2012 16:52:47 +0100
Message-ID: <1348242767-23732-1-git-send-email-oliver.chick@citrix.com>
X-Mailer: git-send-email 1.7.9.5
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

On startup, blk{front,back} use xenbus to communicate their ability to
perform 'feature-persistent'. Iff both ends have this ability,
persistent mode is used.

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

Blkback has to store a mapping of grefs=>{page mapped to by gref} in
an array. As the grefs are not known apriori, and provide no
guarantees on their ordering, we have to perform a linear search
through this array to find the page, for every gref we receive. The
overhead of this is low, however future work might want to use a more
efficient data structure to reduce this O(n) operation.

We (ijc, and myself) have introduced a new constant,
BLKIF_MAX_PERSISTENT_REQUESTS_PER_DEV. This is to prevent a malicious
guest from attempting a DoS, by supplying fresh grefs, causing the
Dom0 kernel from to map excessively. This is currently set to 64---the
maximum number of entires in the ring. As the number of inflight
requests <= size of ring, 64 is also the maximum sensible size (for
single page rings---this constant may need to be made dynamic when
multipage rings takeoff). This introduces a maximum overhead of 2.75MB
of mapped memory, per block device.  If the guest exceeds the limit,
it is either buggy or malicious. We treat this in one of two ways:

1) If we have mapped < BLKIF_MAX_SEGMENTS_PER_REQUEST *
BLKIF_MAX_PERSISTENT_REQUESTS_PER_DEV pages, we will persistently map
the grefs. This can occur is previous requests have not used all
BLKIF_MAX_SEGMENTS_PER_REQUEST segments.
 2) Otherwise, we revert to non-persistent grants for all future grefs.

In writing this patch, the question arrises as to if the additional
cost of performing memcpys in the guest (to/from the pool of granted
pages) outweigh the gains of not performing TLB shootdowns. The answer
to that question is `no'. There appears to be very little, if any
additional cost to the guest of using persistent grants. There is
perhaps a small saving, from the reduced number of hypercalls
performed in granting, and ending foreign access.

Signed-off-by: Oliver Chick <oliver.chick@citrix.com>
---

Changes since v1:

 * Maximum number of persistent grants per device now 64, rather than
   256, as this is the actual maxmimum request in a (1 page) ring.
 * If blkfront supplies more grefs than it is meant to, to blkback,
   blkback will fail to process them. This gives more predictable
   pefromance.
 * Use of `pers' as an abbreviation has been removed, in favour of the
   more clear `persistent'.
 * Fixed potential leak where we allocate space to store information
   about persistent grants, but fail to alloc a page for the grant.
 * Moved frontend persistent gnt feature information into vbd
 * Check that offset+length < page size in blkfront.
 * Minor variable renames, as suggested by Konrad
 * Added some comments documenting code, as suggested by Konrad

 drivers/block/xen-blkback/blkback.c |  166 ++++++++++++++++++++++++---
 drivers/block/xen-blkback/common.h  |   16 +++
 drivers/block/xen-blkback/xenbus.c  |   21 +++-
 drivers/block/xen-blkfront.c        |  211 +++++++++++++++++++++++++++++++----
 include/xen/interface/io/blkif.h    |   13 +++
 5 files changed, 385 insertions(+), 42 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 73f196c..8ac8d3f 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -78,6 +78,7 @@ struct pending_req {
 	unsigned short		operation;
 	int			status;
 	struct list_head	free_list;
+	unsigned int		flag_persistent:1;
 };
 
 #define BLKBACK_INVALID_HANDLE (~0)
@@ -128,6 +129,26 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 static void make_response(struct xen_blkif *blkif, u64 id,
 			  unsigned short op, int st);
 
+static void add_persistent_gnt(struct persistent_gnt *persistent_gnt,
+			       struct xen_blkif *blkif)
+{
+	BUG_ON(blkif->persistent_gnt_c >=
+	       BLKIF_MAX_PERSISTENT_REQUESTS_PER_DEV *
+	       BLKIF_MAX_SEGMENTS_PER_REQUEST);
+	blkif->persistent_gnts[blkif->persistent_gnt_c++] = persistent_gnt;
+}
+
+static struct persistent_gnt *get_persistent_gnt(struct xen_blkif *blkif,
+						 grant_ref_t gref)
+{
+	int i;
+
+	for (i = 0; i < blkif->persistent_gnt_c; i++)
+		if (gref == blkif->persistent_gnts[i]->gnt)
+			return blkif->persistent_gnts[i];
+	return NULL;
+}
+
 /*
  * Retrieve from the 'pending_reqs' a free pending_req structure to be used.
  */
@@ -274,6 +295,12 @@ int xen_blkif_schedule(void *arg)
 {
 	struct xen_blkif *blkif = arg;
 	struct xen_vbd *vbd = &blkif->vbd;
+	struct gnttab_unmap_grant_ref unmap[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct page *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct persistent_gnt *persistent_gnt;
+	int i;
+	int ret = 0;
+	int segs_to_unmap;
 
 	xen_blkif_get(blkif);
 
@@ -301,6 +328,31 @@ int xen_blkif_schedule(void *arg)
 			print_stats(blkif);
 	}
 
+	/* Free all persistent grant pages */
+
+	while ((segs_to_unmap = min(BLKIF_MAX_SEGMENTS_PER_REQUEST,
+				    blkif->persistent_gnt_c))) {
+
+		for (i = 0; i < segs_to_unmap; i++) {
+			persistent_gnt = blkif->persistent_gnts
+				[blkif->persistent_gnt_c - i - 1];
+
+			gnttab_set_unmap_op(&unmap[i],
+					    pfn_to_kaddr(page_to_pfn(
+							     persistent_gnt->page)),
+					    GNTMAP_host_map,
+					    persistent_gnt->handle);
+
+			pages[i] = persistent_gnt->page;
+		}
+
+		ret = gnttab_unmap_refs(unmap, pages, segs_to_unmap, false);
+		BUG_ON(ret);
+
+		blkif->persistent_gnt_c -= segs_to_unmap;
+
+	}
+
 	if (log_stats)
 		print_stats(blkif);
 
@@ -343,13 +395,31 @@ static void xen_blkbk_unmap(struct pending_req *req)
 
 static int xen_blkbk_map(struct blkif_request *req,
 			 struct pending_req *pending_req,
-			 struct seg_buf seg[])
+			 struct seg_buf seg[],
+			 struct page *pages[])
 {
 	struct gnttab_map_grant_ref map[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct persistent_gnt
+		*new_persistent_gnts[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct persistent_gnt *persistent_gnts[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct page *pages_to_gnt[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct persistent_gnt *persistent_gnt;
+	phys_addr_t addr;
 	int i;
+	int new_map;
 	int nseg = req->u.rw.nr_segments;
+	int segs_to_map = 0;
 	int ret = 0;
+	int use_persistent_gnts;
+
+	use_persistent_gnts = (pending_req->blkif->vbd.feature_gnt_persistent);
+
+	if (pending_req->blkif->persistent_gnt_c >=
+	    BLKIF_MAX_SEGMENTS_PER_REQUEST *
+	    BLKIF_MAX_PERSISTENT_REQUESTS_PER_DEV)
+		return -EIO;
 
+	pending_req->flag_persistent = use_persistent_gnts;
 	/*
 	 * Fill out preq.nr_sects with proper amount of sectors, and setup
 	 * assign map[..] with the PFN of the page in our domain with the
@@ -358,36 +428,97 @@ static int xen_blkbk_map(struct blkif_request *req,
 	for (i = 0; i < nseg; i++) {
 		uint32_t flags;
 
+		if (use_persistent_gnts) {
+			persistent_gnt = get_persistent_gnt(
+				pending_req->blkif,
+				req->u.rw.seg[i].gref);
+			if (!persistent_gnt) {
+				new_map = 1;
+				persistent_gnt = kmalloc(
+					sizeof(struct persistent_gnt),
+					GFP_KERNEL);
+				if (!persistent_gnt)
+					return -ENOMEM;
+				persistent_gnt->page = alloc_page(GFP_KERNEL);
+				if (!persistent_gnt->page) {
+					kfree(persistent_gnt);
+					return -ENOMEM;
+				}
+				persistent_gnt->gnt = req->u.rw.seg[i].gref;
+
+				pages_to_gnt[segs_to_map] =
+					persistent_gnt->page;
+				new_persistent_gnts[segs_to_map] =
+					persistent_gnt;
+
+				add_persistent_gnt(persistent_gnt,
+						   pending_req->blkif);
+
+			} else {
+				new_map = 0;
+			}
+			pages[i] = persistent_gnt->page;
+			addr = (unsigned long) pfn_to_kaddr(
+				page_to_pfn(persistent_gnt->page));
+			persistent_gnts[i] = persistent_gnt;
+		} else {
+			new_map = 1;
+			pages[i] = blkbk->pending_page(pending_req, i);
+			addr = vaddr(pending_req, i);
+			pages_to_gnt[i] = blkbk->pending_page(pending_req, i);
+		}
+
 		flags = GNTMAP_host_map;
-		if (pending_req->operation != BLKIF_OP_READ)
+		if (!use_persistent_gnts &&
+		    (pending_req->operation != BLKIF_OP_READ))
 			flags |= GNTMAP_readonly;
-		gnttab_set_map_op(&map[i], vaddr(pending_req, i), flags,
-				  req->u.rw.seg[i].gref,
-				  pending_req->blkif->domid);
+		if (new_map) {
+			gnttab_set_map_op(&map[segs_to_map++], addr,
+					  flags, req->u.rw.seg[i].gref,
+					  pending_req->blkif->domid);
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
+	for (i = 0; i < segs_to_map; i++) {
 		if (unlikely(map[i].status != 0)) {
 			pr_debug(DRV_PFX "invalid buffer -- could not remap it\n");
 			map[i].handle = BLKBACK_INVALID_HANDLE;
 			ret |= 1;
 		}
 
-		pending_handle(pending_req, i) = map[i].handle;
+		if (use_persistent_gnts) {
+			/* store the `out' values from map */
+		    pending_req->blkif->persistent_gnts
+			[pending_req->blkif->persistent_gnt_c - segs_to_map +
+			 i]->handle = map[i].handle;
+			new_persistent_gnts[i]->dev_bus_addr =
+				map[i].dev_bus_addr;
+		}
 
 		if (ret)
 			continue;
-
-		seg[i].buf  = map[i].dev_bus_addr |
-			(req->u.rw.seg[i].first_sect << 9);
+	}
+	for (i = 0; i < nseg; i++) {
+		if (use_persistent_gnts) {
+			pending_handle(pending_req, i) =
+				persistent_gnts[i]->handle;
+			seg[i].buf = persistent_gnts[i]->dev_bus_addr |
+				(req->u.rw.seg[i].first_sect << 9);
+		} else {
+			pending_handle(pending_req, i) = map[i].handle;
+			seg[i].buf = map[i].dev_bus_addr |
+				(req->u.rw.seg[i].first_sect << 9);
+		}
 	}
 	return ret;
 }
@@ -468,7 +599,8 @@ static void __end_block_io_op(struct pending_req *pending_req, int error)
 	 * the proper response on the ring.
 	 */
 	if (atomic_dec_and_test(&pending_req->pendcnt)) {
-		xen_blkbk_unmap(pending_req);
+		if (!pending_req->flag_persistent)
+			xen_blkbk_unmap(pending_req);
 		make_response(pending_req->blkif, pending_req->id,
 			      pending_req->operation, pending_req->status);
 		xen_blkif_put(pending_req->blkif);
@@ -590,6 +722,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	int operation;
 	struct blk_plug plug;
 	bool drain = false;
+	struct page *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 
 	switch (req->operation) {
 	case BLKIF_OP_READ:
@@ -676,7 +809,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	 * the hypercall to unmap the grants - that is all done in
 	 * xen_blkbk_unmap.
 	 */
-	if (xen_blkbk_map(req, pending_req, seg))
+	if (xen_blkbk_map(req, pending_req, seg, pages))
 		goto fail_flush;
 
 	/*
@@ -688,7 +821,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	for (i = 0; i < nseg; i++) {
 		while ((bio == NULL) ||
 		       (bio_add_page(bio,
-				     blkbk->pending_page(pending_req, i),
+				     pages[i],
 				     seg[i].nsec << 9,
 				     seg[i].buf & ~PAGE_MASK) == 0)) {
 
@@ -743,7 +876,8 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	return 0;
 
  fail_flush:
-	xen_blkbk_unmap(pending_req);
+	if (!blkif->vbd.feature_gnt_persistent)
+		xen_blkbk_unmap(pending_req);
  fail_response:
 	/* Haven't submitted any bio's yet. */
 	make_response(blkif, req->u.rw.id, req->operation, BLKIF_RSP_ERROR);
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index 9ad3b5e..0b7e049 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -160,10 +160,20 @@ struct xen_vbd {
 	sector_t		size;
 	bool			flush_support;
 	bool			discard_secure;
+
+	unsigned int		feature_gnt_persistent:1;
 };
 
 struct backend_info;
 
+
+struct persistent_gnt {
+	struct page *page;
+	grant_ref_t gnt;
+	grant_handle_t handle;
+	uint64_t dev_bus_addr;
+};
+
 struct xen_blkif {
 	/* Unique identifier for this interface. */
 	domid_t			domid;
@@ -190,6 +200,12 @@ struct xen_blkif {
 	struct task_struct	*xenblkd;
 	unsigned int		waiting_reqs;
 
+	/* frontend feature information */
+	struct persistent_gnt	*persistent_gnts
+					[BLKIF_MAX_PERSISTENT_REQUESTS_PER_DEV
+					 * BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	unsigned int		persistent_gnt_c;
+
 	/* statistics */
 	unsigned long		st_print;
 	int			st_rd_req;
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 4f66171..473e416 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -681,6 +681,13 @@ again:
 		goto abort;
 	}
 
+	err = xenbus_printf(xbt, dev->nodename, "feature-persistent-grants",
+			    "%d", 1);
+	if (err) {
+		dev_warn(&dev->dev, "writing persistent grants feature");
+		goto abort;
+	}
+
 	/* FIXME: use a typename instead */
 	err = xenbus_printf(xbt, dev->nodename, "info", "%u",
 			    be->blkif->vbd.type |
@@ -721,6 +728,7 @@ static int connect_ring(struct backend_info *be)
 	struct xenbus_device *dev = be->dev;
 	unsigned long ring_ref;
 	unsigned int evtchn;
+	u8 pers_grants;
 	char protocol[64] = "";
 	int err;
 
@@ -750,8 +758,17 @@ static int connect_ring(struct backend_info *be)
 		xenbus_dev_fatal(dev, err, "unknown fe protocol %s", protocol);
 		return -1;
 	}
-	pr_info(DRV_PFX "ring-ref %ld, event-channel %d, protocol %d (%s)\n",
-		ring_ref, evtchn, be->blkif->blk_protocol, protocol);
+	err = xenbus_gather(XBT_NIL, dev->otherend,
+			    "feature-persistent-grants", "%d",
+			    &pers_grants, NULL);
+	if (err)
+		pers_grants = 0;
+
+	be->blkif->vbd.feature_gnt_persistent = pers_grants;
+
+	pr_info(DRV_PFX "ring-ref %ld, event-channel %d, protocol %d (%s) persistent %d\n",
+		ring_ref, evtchn, be->blkif->blk_protocol, protocol,
+		pers_grants);
 
 	/* Map the shared frame, irq etc. */
 	err = xen_blkif_map(be->blkif, ring_ref, evtchn);
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 2c2d2e5..9606c5a 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -64,10 +64,17 @@ enum blkif_state {
 	BLKIF_STATE_SUSPENDED,
 };
 
+struct gnt_list {
+	grant_ref_t gref;
+	unsigned long pfn;
+	struct gnt_list *tail;
+};
+
 struct blk_shadow {
 	struct blkif_request req;
 	struct request *request;
 	unsigned long frame[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct gnt_list *grants_used[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 };
 
 static DEFINE_MUTEX(blkfront_mutex);
@@ -97,11 +104,14 @@ struct blkfront_info
 	struct work_struct work;
 	struct gnttab_free_callback callback;
 	struct blk_shadow shadow[BLK_RING_SIZE];
+	struct gnt_list *persistent_gnts;
+	unsigned int persistent_gnts_c;
 	unsigned long shadow_free;
 	unsigned int feature_flush;
 	unsigned int flush_op;
 	unsigned int feature_discard:1;
 	unsigned int feature_secdiscard:1;
+	unsigned int feature_persistent:1;
 	unsigned int discard_granularity;
 	unsigned int discard_alignment;
 	int is_ready;
@@ -287,21 +297,42 @@ static int blkif_queue_request(struct request *req)
 	unsigned long id;
 	unsigned int fsect, lsect;
 	int i, ref;
+
+	/*
+	 * stores if we have negotiated with the backend, agreeing to use
+	 * persistent grants.
+	 */
+	int use_persistent_gnts;
+
+	/*
+	 * Used when doing persistent grants to store if we are able to queue
+	 * the request by just using existing persistent grants (0), or if we
+	 * have to get new grants, as there are not sufficiently many free.
+	 */
+	int new_persistent_gnts;
 	grant_ref_t gref_head;
+	struct page *granted_page;
+	struct gnt_list *gnt_list_entry;
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
+	use_persistent_gnts = info->feature_persistent;
+
+	if (info->persistent_gnts_c < BLKIF_MAX_SEGMENTS_PER_REQUEST) {
+		new_persistent_gnts = 1;
+		if (gnttab_alloc_grant_references(
+			    BLKIF_MAX_SEGMENTS_PER_REQUEST, &gref_head) < 0) {
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
@@ -341,20 +372,83 @@ static int blkif_queue_request(struct request *req)
 		       BLKIF_MAX_SEGMENTS_PER_REQUEST);
 
 		for_each_sg(info->sg, sg, ring_req->u.rw.nr_segments, i) {
-			buffer_mfn = pfn_to_mfn(page_to_pfn(sg_page(sg)));
 			fsect = sg->offset >> 9;
 			lsect = fsect + (sg->length >> 9) - 1;
-			/* install a grant reference. */
-			ref = gnttab_claim_grant_reference(&gref_head);
-			BUG_ON(ref == -ENOSPC);
 
-			gnttab_grant_foreign_access_ref(
+			if (use_persistent_gnts && info->persistent_gnts_c) {
+				gnt_list_entry = info->persistent_gnts;
+
+				info->persistent_gnts = info->persistent_gnts->
+					tail;
+				ref = gnt_list_entry->gref;
+				buffer_mfn = pfn_to_mfn(gnt_list_entry->pfn);
+				info->persistent_gnts_c--;
+			} else {
+				ref = gnttab_claim_grant_reference(&gref_head);
+				BUG_ON(ref == -ENOSPC);
+
+				if (use_persistent_gnts) {
+					gnt_list_entry =
+						kmalloc(sizeof(struct gnt_list),
+								 GFP_ATOMIC);
+					if (!gnt_list_entry)
+						return -ENOMEM;
+
+					granted_page = alloc_page(GFP_ATOMIC);
+					if (!granted_page) {
+						kfree(gnt_list_entry);
+						return -ENOMEM;
+					}
+
+					gnt_list_entry->pfn =
+						page_to_pfn(granted_page);
+					gnt_list_entry->gref = ref;
+				} else
+					granted_page = sg_page(sg);
+
+				buffer_mfn = pfn_to_mfn(page_to_pfn(
+								granted_page));
+				gnttab_grant_foreign_access_ref(
 					ref,
 					info->xbdev->otherend_id,
 					buffer_mfn,
+					!use_persistent_gnts &&
 					rq_data_dir(req));
+			}
+
+			if (use_persistent_gnts)
+				info->shadow[id].grants_used[i] =
+					gnt_list_entry;
+
+			if (use_persistent_gnts && rq_data_dir(req)) {
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
+
 			ring_req->u.rw.seg[i] =
 					(struct blkif_request_segment) {
 						.gref       = ref,
@@ -368,7 +462,8 @@ static int blkif_queue_request(struct request *req)
 	/* Keep a private copy so we can reissue requests when recovering. */
 	info->shadow[id].req = *ring_req;
 
-	gnttab_free_grant_references(gref_head);
+	if (new_persistent_gnts)
+		gnttab_free_grant_references(gref_head);
 
 	return 0;
 }
@@ -480,12 +575,13 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size)
 static void xlvbd_flush(struct blkfront_info *info)
 {
 	blk_queue_flush(info->rq, info->feature_flush);
-	printk(KERN_INFO "blkfront: %s: %s: %s\n",
+	printk(KERN_INFO "blkfront: %s: %s: %s %s\n",
 	       info->gd->disk_name,
 	       info->flush_op == BLKIF_OP_WRITE_BARRIER ?
 		"barrier" : (info->flush_op == BLKIF_OP_FLUSH_DISKCACHE ?
 		"flush diskcache" : "barrier or flush"),
-	       info->feature_flush ? "enabled" : "disabled");
+	       info->feature_flush ? "enabled" : "disabled",
+	       info->feature_persistent ? "persistent" : "non-persistent");
 }
 
 static int xen_translate_vdev(int vdevice, int *minor, unsigned int *offset)
@@ -707,6 +803,8 @@ static void blkif_restart_queue(struct work_struct *work)
 
 static void blkif_free(struct blkfront_info *info, int suspend)
 {
+	struct gnt_list *persistent_gnt;
+
 	/* Prevent new requests being issued until we fix things up. */
 	spin_lock_irq(&info->io_lock);
 	info->connected = suspend ?
@@ -714,6 +812,15 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 	/* No more blkif_request(). */
 	if (info->rq)
 		blk_stop_queue(info->rq);
+
+	/* Remove all persistent grants */
+	while (info->persistent_gnts) {
+		persistent_gnt = info->persistent_gnts;
+		info->persistent_gnts = persistent_gnt->tail;
+		gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
+		kfree(persistent_gnt);
+	}
+
 	/* No more gnttab callback work. */
 	gnttab_cancel_free_callback(&info->callback);
 	spin_unlock_irq(&info->io_lock);
@@ -734,13 +841,47 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 
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
+	struct gnt_list *new_gnt_list_entry;
+	struct bio_vec *bvec;
+	struct req_iterator iter;
+	unsigned long flags;
+	char *bvec_data;
+	void *shared_data;
+
+
+	if (info->feature_persistent == 0) {
+		/* Do not let BLKIF_OP_DISCARD as nr_segment is in the same
+		 * place flag. */
+		for (i = 0; i < s->req.u.rw.nr_segments; i++)
+			gnttab_end_foreign_access(s->req.u.rw.seg[i].gref,
+						  0, 0UL);
+		return;
+	}
+
+	i = 0;
+	if (bret->operation == BLKIF_OP_READ)
+		rq_for_each_segment(bvec, s->request, iter) {
+			BUG_ON(bvec->bv_offset + bvec->bv_len > PAGE_SIZE);
+
+			shared_data = kmap_atomic
+				(pfn_to_page(s->grants_used[i++]->pfn));
+			bvec_data = bvec_kmap_irq(bvec, &flags);
+			memcpy(bvec_data, shared_data + bvec->bv_offset,
+			       bvec->bv_len);
+			bvec_kunmap_irq(bvec_data, &flags);
+			kunmap_atomic(shared_data);
+		}
+	/* Add the persistent grant into the list of free grants */
+	for (i = 0; i < s->req.u.rw.nr_segments; i++) {
+		new_gnt_list_entry = s->grants_used[i];
+		new_gnt_list_entry->tail = info->persistent_gnts;
+		info->persistent_gnts = new_gnt_list_entry;
+		info->persistent_gnts_c++;
+	}
 }
 
 static irqreturn_t blkif_interrupt(int irq, void *dev_id)
@@ -783,7 +924,7 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 		req  = info->shadow[id].request;
 
 		if (bret->operation != BLKIF_OP_DISCARD)
-			blkif_completion(&info->shadow[id]);
+			blkif_completion(&info->shadow[id], info, bret);
 
 		if (add_id_to_freelist(info, id)) {
 			WARN(1, "%s: response to %s (id %ld) couldn't be recycled!\n",
@@ -942,6 +1083,13 @@ again:
 		message = "writing protocol";
 		goto abort_transaction;
 	}
+	err = xenbus_printf(xbt, dev->nodename,
+			    "feature-persistent-grants", "%d", 1);
+	if (err) {
+		dev_warn(&dev->dev,
+			 "writing persistent grants feature to xenbus");
+		info->feature_persistent = 0;
+	}
 
 	err = xenbus_transaction_end(xbt, 0);
 	if (err) {
@@ -1029,6 +1177,7 @@ static int blkfront_probe(struct xenbus_device *dev,
 	spin_lock_init(&info->io_lock);
 	info->xbdev = dev;
 	info->vdevice = vdevice;
+	info->persistent_gnts_c = 0;
 	info->connected = BLKIF_STATE_DISCONNECTED;
 	INIT_WORK(&info->work, blkif_restart_queue);
 
@@ -1093,6 +1242,7 @@ static int blkif_recover(struct blkfront_info *info)
 					req->u.rw.seg[j].gref,
 					info->xbdev->otherend_id,
 					pfn_to_mfn(info->shadow[req->u.rw.id].frame[j]),
+					!info->feature_persistent &&
 					rq_data_dir(info->shadow[req->u.rw.id].request));
 		}
 		info->shadow[req->u.rw.id].req = *req;
@@ -1225,7 +1375,7 @@ static void blkfront_connect(struct blkfront_info *info)
 	unsigned long sector_size;
 	unsigned int binfo;
 	int err;
-	int barrier, flush, discard;
+	int barrier, flush, discard, persistent;
 
 	switch (info->connected) {
 	case BLKIF_STATE_CONNECTED:
@@ -1296,6 +1446,19 @@ static void blkfront_connect(struct blkfront_info *info)
 		info->flush_op = BLKIF_OP_FLUSH_DISKCACHE;
 	}
 
+	/*
+	 * Are we dealing with an old blkback that will unmap
+	 * all grefs?
+	 */
+	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
+			    "feature-persistent-grants", "%d", &persistent,
+			    NULL);
+
+	if (err)
+		info->feature_persistent = 0;
+	else
+		info->feature_persistent = persistent;
+
 	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
 			    "feature-discard", "%d", &discard,
 			    NULL);
diff --git a/include/xen/interface/io/blkif.h b/include/xen/interface/io/blkif.h
index ee338bf..9048df1 100644
--- a/include/xen/interface/io/blkif.h
+++ b/include/xen/interface/io/blkif.h
@@ -109,6 +109,19 @@ typedef uint64_t blkif_sector_t;
  */
 #define BLKIF_MAX_SEGMENTS_PER_REQUEST 11
 
+/*
+ * Maximum number of inflight requests that can be sent by from
+ * blkfront, and will be guaranteed to be persistently mapped.
+ * BLKIF_MAX_SEGMENTS_PER_REQUEST *
+ * BLKIF_MAX_PERSISTENT_REQUESTS_PER_DEV is the maximum number of
+ * pages that blkback will persistently map. This is set to be the size
+ * of the ring, as this is a limit on the number of requests that can
+ * be inflight at any one time. 64 imposes an overhead of 2.75MB of
+ * mapped kernel space per interface.
+ */
+#define BLKIF_MAX_PERSISTENT_REQUESTS_PER_DEV 64
+
+
 struct blkif_request_rw {
 	uint8_t        nr_segments;  /* number of segments                   */
 	blkif_vdev_t   handle;       /* only for read/write requests         */
-- 
1.7.9.5

