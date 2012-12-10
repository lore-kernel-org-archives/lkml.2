Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab2LJRZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 12:25:26 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:49524 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab2LJRZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 12:25:17 -0500
X-IronPort-AV: E=Sophos;i="4.84,252,1355097600"; 
   d="scan'208";a="40445"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>, <xen-devel@lists.xen.org>
Subject: [PATCH v2 1/3] xen-blkback: implement safe iterator for the list of persistent grants
Date: Mon, 10 Dec 2012 18:24:48 +0100
Message-ID: <1355160290-22180-1-git-send-email-roger.pau@citrix.com>
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
 drivers/block/xen-blkback/blkback.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 74374fb..5ac841f 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -161,10 +161,12 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 static void make_response(struct xen_blkif *blkif, u64 id,
 			  unsigned short op, int st);
 
-#define foreach_grant(pos, rbtree, node) \
-	for ((pos) = container_of(rb_first((rbtree)), typeof(*(pos)), node); \
+#define foreach_grant_safe(pos, n, rbtree, node) \
+	for ((pos) = container_of(rb_first((rbtree)), typeof(*(pos)), node), \
+	     (n) = rb_next(&(pos)->node); \
 	     &(pos)->node != NULL; \
-	     (pos) = container_of(rb_next(&(pos)->node), typeof(*(pos)), node))
+	     (pos) = container_of(n, typeof(*(pos)), node), \
+	     (n) = (&(pos)->node != NULL) ? rb_next(&(pos)->node) : NULL)
 
 
 static void add_persistent_gnt(struct rb_root *root,
@@ -217,10 +219,11 @@ static void free_persistent_gnts(struct rb_root *root, unsigned int num)
 	struct gnttab_unmap_grant_ref unmap[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	struct page *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	struct persistent_gnt *persistent_gnt;
+	struct rb_node *n;
 	int ret = 0;
 	int segs_to_unmap = 0;
 
-	foreach_grant(persistent_gnt, root, node) {
+	foreach_grant_safe(persistent_gnt, n, root, node) {
 		BUG_ON(persistent_gnt->handle ==
 			BLKBACK_INVALID_HANDLE);
 		gnttab_set_unmap_op(&unmap[segs_to_unmap],
@@ -230,9 +233,6 @@ static void free_persistent_gnts(struct rb_root *root, unsigned int num)
 			persistent_gnt->handle);
 
 		pages[segs_to_unmap] = persistent_gnt->page;
-		rb_erase(&persistent_gnt->node, root);
-		kfree(persistent_gnt);
-		num--;
 
 		if (++segs_to_unmap == BLKIF_MAX_SEGMENTS_PER_REQUEST ||
 			!rb_next(&persistent_gnt->node)) {
@@ -241,6 +241,10 @@ static void free_persistent_gnts(struct rb_root *root, unsigned int num)
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

