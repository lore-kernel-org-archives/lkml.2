Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab2LMKsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 05:48:06 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:53339 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854Ab2LMKsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 05:48:03 -0500
X-IronPort-AV: E=Sophos;i="4.84,273,1355097600"; 
   d="scan'208";a="110291"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>, <xen-devel@lists.xen.org>
Subject: [PATCH v4 1/3] xen-blkback: implement safe iterator for the list of persistent grants
Date: Thu, 13 Dec 2012 11:39:37 +0100
Message-ID: <1355395179-55724-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change foreach_grant iterator to a safe version, that allows freeing
the element while iterating. Also move the free code in
free_persistent_gnts to prevent freeing the element before the rb_next
call.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: xen-devel@lists.xen.org
---
Changes since v2:
 * Implement the same semantics as list_for_each_safe, using type *
   instead of rb_node * as the temporary cursor.
---
 drivers/block/xen-blkback/blkback.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 74374fb..8808028 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -161,10 +161,14 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 static void make_response(struct xen_blkif *blkif, u64 id,
 			  unsigned short op, int st);
 
-#define foreach_grant(pos, rbtree, node) \
-	for ((pos) = container_of(rb_first((rbtree)), typeof(*(pos)), node); \
-	     &(pos)->node != NULL; \
-	     (pos) = container_of(rb_next(&(pos)->node), typeof(*(pos)), node))
+#define foreach_grant_safe(pos, n, rbtree, node) \
+	for ((pos) = container_of(rb_first((rbtree)), typeof(*(pos)), node),\
+	     (n) = container_of(((&(pos)->node != NULL) ? 		\
+	         rb_next(&(pos)->node) : NULL), typeof(*(pos)), node);	\
+	     &(pos)->node != NULL;					\
+	     (pos) = n,							\
+	     (n) = container_of(((&(pos)->node != NULL) ?		\
+	         rb_next(&(pos)->node) : NULL), typeof(*(pos)), node))
 
 
 static void add_persistent_gnt(struct rb_root *root,
@@ -216,11 +220,11 @@ static void free_persistent_gnts(struct rb_root *root, unsigned int num)
 {
 	struct gnttab_unmap_grant_ref unmap[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	struct page *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
-	struct persistent_gnt *persistent_gnt;
+	struct persistent_gnt *persistent_gnt, *n;
 	int ret = 0;
 	int segs_to_unmap = 0;
 
-	foreach_grant(persistent_gnt, root, node) {
+	foreach_grant_safe(persistent_gnt, n, root, node) {
 		BUG_ON(persistent_gnt->handle ==
 			BLKBACK_INVALID_HANDLE);
 		gnttab_set_unmap_op(&unmap[segs_to_unmap],
@@ -230,9 +234,6 @@ static void free_persistent_gnts(struct rb_root *root, unsigned int num)
 			persistent_gnt->handle);
 
 		pages[segs_to_unmap] = persistent_gnt->page;
-		rb_erase(&persistent_gnt->node, root);
-		kfree(persistent_gnt);
-		num--;
 
 		if (++segs_to_unmap == BLKIF_MAX_SEGMENTS_PER_REQUEST ||
 			!rb_next(&persistent_gnt->node)) {
@@ -241,6 +242,10 @@ static void free_persistent_gnts(struct rb_root *root, unsigned int num)
 			BUG_ON(ret);
 			segs_to_unmap = 0;
 		}
+
+		rb_erase(&persistent_gnt->node, root);
+		kfree(persistent_gnt);
+		num--;
 	}
 	BUG_ON(num != 0);
 }
-- 
1.7.7.5 (Apple Git-26)

