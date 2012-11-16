Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab2KPS1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:27:37 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:60081 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab2KPS1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:27:36 -0500
X-IronPort-AV: E=Sophos;i="4.83,266,1352073600"; 
   d="scan'208";a="15857992"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        <konrad.wilk@oracle.com>
CC: Roger Pau Monne <roger.pau@citrix.com>
Subject: [PATCH 2/2] xen-blkback: move free persistent grants code
Date: Fri, 16 Nov 2012 19:26:48 +0100
Message-ID: <1353090408-66400-2-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1353090408-66400-1-git-send-email-roger.pau@citrix.com>
References: <1353090408-66400-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the code that frees persistent grants from the red-black tree
to a function. This will make it easier for other consumers to move
this to a common place.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
---
 drivers/block/xen-blkback/blkback.c |   68 +++++++++++++++++++----------------
 1 files changed, 37 insertions(+), 31 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index a059616..74374fb 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -212,6 +212,39 @@ static struct persistent_gnt *get_persistent_gnt(struct rb_root *root,
 	return NULL;
 }
 
+static void free_persistent_gnts(struct rb_root *root, unsigned int num)
+{
+	struct gnttab_unmap_grant_ref unmap[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct page *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct persistent_gnt *persistent_gnt;
+	int ret = 0;
+	int segs_to_unmap = 0;
+
+	foreach_grant(persistent_gnt, root, node) {
+		BUG_ON(persistent_gnt->handle ==
+			BLKBACK_INVALID_HANDLE);
+		gnttab_set_unmap_op(&unmap[segs_to_unmap],
+			(unsigned long) pfn_to_kaddr(page_to_pfn(
+				persistent_gnt->page)),
+			GNTMAP_host_map,
+			persistent_gnt->handle);
+
+		pages[segs_to_unmap] = persistent_gnt->page;
+		rb_erase(&persistent_gnt->node, root);
+		kfree(persistent_gnt);
+		num--;
+
+		if (++segs_to_unmap == BLKIF_MAX_SEGMENTS_PER_REQUEST ||
+			!rb_next(&persistent_gnt->node)) {
+			ret = gnttab_unmap_refs(unmap, NULL, pages,
+				segs_to_unmap);
+			BUG_ON(ret);
+			segs_to_unmap = 0;
+		}
+	}
+	BUG_ON(num != 0);
+}
+
 /*
  * Retrieve from the 'pending_reqs' a free pending_req structure to be used.
  */
@@ -358,11 +391,6 @@ int xen_blkif_schedule(void *arg)
 {
 	struct xen_blkif *blkif = arg;
 	struct xen_vbd *vbd = &blkif->vbd;
-	struct gnttab_unmap_grant_ref unmap[BLKIF_MAX_SEGMENTS_PER_REQUEST];
-	struct page *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
-	struct persistent_gnt *persistent_gnt;
-	int ret = 0;
-	int segs_to_unmap = 0;
 
 	xen_blkif_get(blkif);
 
@@ -391,34 +419,12 @@ int xen_blkif_schedule(void *arg)
 	}
 
 	/* Free all persistent grant pages */
-	if (!RB_EMPTY_ROOT(&blkif->persistent_gnts)) {
-		foreach_grant(persistent_gnt, &blkif->persistent_gnts, node) {
-			BUG_ON(persistent_gnt->handle ==
-				BLKBACK_INVALID_HANDLE);
-			gnttab_set_unmap_op(&unmap[segs_to_unmap],
-			    (unsigned long) pfn_to_kaddr(page_to_pfn(
-				persistent_gnt->page)),
-			    GNTMAP_host_map,
-			    persistent_gnt->handle);
-
-			pages[segs_to_unmap] = persistent_gnt->page;
-			rb_erase(&persistent_gnt->node,
-				&blkif->persistent_gnts);
-			kfree(persistent_gnt);
-			blkif->persistent_gnt_c--;
-
-			if (++segs_to_unmap == BLKIF_MAX_SEGMENTS_PER_REQUEST ||
-				!rb_next(&persistent_gnt->node)) {
-				ret = gnttab_unmap_refs(unmap, NULL, pages,
-							segs_to_unmap);
-				BUG_ON(ret);
-				segs_to_unmap = 0;
-			}
-		}
-	}
+	if (!RB_EMPTY_ROOT(&blkif->persistent_gnts))
+		free_persistent_gnts(&blkif->persistent_gnts,
+			blkif->persistent_gnt_c);
 
-	BUG_ON(blkif->persistent_gnt_c != 0);
 	BUG_ON(!RB_EMPTY_ROOT(&blkif->persistent_gnts));
+	blkif->persistent_gnt_c = 0;
 
 	if (log_stats)
 		print_stats(blkif);
-- 
1.7.7.5 (Apple Git-26)

