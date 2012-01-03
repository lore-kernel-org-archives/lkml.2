Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab2ACW5C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:57:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765Ab2ACWi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:38:57 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:22 2012
Message-Id: <20120103223322.264990233@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:32:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mike Snitzer <snitzer@redhat.com>,
        David Rientjes <rientjes@google.com>, Jens Axboe <axboe@kernel.dk>
Subject: [15/75] block: initialize request_queues numa node during
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 5151412dd4338b273afdb107c3772528e9e67d92 upstream.

struct request_queue is allocated with __GFP_ZERO so its "node" field is
zero before initialization.  This causes an oops if node 0 is offline in
the page allocator because its zonelists are not initialized.  From Dave
Young's dmesg:

	SRAT: Node 1 PXM 2 0-d0000000
	SRAT: Node 1 PXM 2 100000000-330000000
	SRAT: Node 0 PXM 1 330000000-630000000
	Initmem setup node 1 0000000000000000-000000000affb000
	...
	Built 1 zonelists in Node order, mobility grouping on.
	...
	BUG: unable to handle kernel paging request at 0000000000001c08
	IP: [<ffffffff8111c355>] __alloc_pages_nodemask+0xb5/0x870

and __alloc_pages_nodemask+0xb5 translates to a NULL pointer on
zonelist->_zonerefs.

The fix is to initialize q->node at the time of allocation so the correct
node is passed to the slab allocator later.

Since blk_init_allocated_queue_node() is no longer needed, merge it with
blk_init_allocated_queue().

[rientjes@google.com: changelog, initializing q->node]
Reported-by: Dave Young <dyoung@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Tested-by: Dave Young <dyoung@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/blk-core.c       |   14 +++-----------
 include/linux/blkdev.h |    3 ---
 2 files changed, 3 insertions(+), 14 deletions(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -418,6 +418,7 @@ struct request_queue *blk_alloc_queue_no
 	q->backing_dev_info.state = 0;
 	q->backing_dev_info.capabilities = BDI_CAP_MAP_COPY;
 	q->backing_dev_info.name = "block";
+	q->node = node_id;
 
 	err = bdi_init(&q->backing_dev_info);
 	if (err) {
@@ -502,7 +503,7 @@ blk_init_queue_node(request_fn_proc *rfn
 	if (!uninit_q)
 		return NULL;
 
-	q = blk_init_allocated_queue_node(uninit_q, rfn, lock, node_id);
+	q = blk_init_allocated_queue(uninit_q, rfn, lock);
 	if (!q)
 		blk_cleanup_queue(uninit_q);
 
@@ -514,18 +515,9 @@ struct request_queue *
 blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 			 spinlock_t *lock)
 {
-	return blk_init_allocated_queue_node(q, rfn, lock, -1);
-}
-EXPORT_SYMBOL(blk_init_allocated_queue);
-
-struct request_queue *
-blk_init_allocated_queue_node(struct request_queue *q, request_fn_proc *rfn,
-			      spinlock_t *lock, int node_id)
-{
 	if (!q)
 		return NULL;
 
-	q->node = node_id;
 	if (blk_init_free_list(q))
 		return NULL;
 
@@ -555,7 +547,7 @@ blk_init_allocated_queue_node(struct req
 
 	return NULL;
 }
-EXPORT_SYMBOL(blk_init_allocated_queue_node);
+EXPORT_SYMBOL(blk_init_allocated_queue);
 
 int blk_get_queue(struct request_queue *q)
 {
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -803,9 +803,6 @@ extern void blk_unprep_request(struct re
  */
 extern struct request_queue *blk_init_queue_node(request_fn_proc *rfn,
 					spinlock_t *lock, int node_id);
-extern struct request_queue *blk_init_allocated_queue_node(struct request_queue *,
-							   request_fn_proc *,
-							   spinlock_t *, int node_id);
 extern struct request_queue *blk_init_queue(request_fn_proc *, spinlock_t *);
 extern struct request_queue *blk_init_allocated_queue(struct request_queue *,
 						      request_fn_proc *, spinlock_t *);


