Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab2LJRZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 12:25:42 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:51305 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab2LJRZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 12:25:16 -0500
X-IronPort-AV: E=Sophos;i="4.84,252,1355097600"; 
   d="scan'208";a="40447"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>, <xen-devel@lists.xen.org>
Subject: [PATCH v2 3/3] xen-blkfront: transverse list of persistent grants safely
Date: Mon, 10 Dec 2012 18:24:50 +0100
Message-ID: <1355160290-22180-3-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1355160290-22180-1-git-send-email-roger.pau@citrix.com>
References: <1355160290-22180-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use llist_for_each_entry_safe in blkif_free. Previously grants where
freed while iterating the list, which lead to dereferences when trying
to fetch the next item.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: xen-devel@lists.xen.org
---
 drivers/block/xen-blkfront.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 96e9b00..cfdb033 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -792,6 +792,7 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 {
 	struct llist_node *all_gnts;
 	struct grant *persistent_gnt;
+	struct llist_node *n;
 
 	/* Prevent new requests being issued until we fix things up. */
 	spin_lock_irq(&info->io_lock);
@@ -804,7 +805,7 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 	/* Remove all persistent grants */
 	if (info->persistent_gnts_c) {
 		all_gnts = llist_del_all(&info->persistent_gnts);
-		llist_for_each_entry(persistent_gnt, all_gnts, node) {
+		llist_for_each_entry_safe(persistent_gnt, n, all_gnts, node) {
 			gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
 			__free_page(pfn_to_page(persistent_gnt->pfn));
 			kfree(persistent_gnt);
-- 
1.7.7.5 (Apple Git-26)

