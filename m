Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab2LDOcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:32:48 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:61728 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab2LDOcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:32:01 -0500
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Dec 2012 09:32:00 EST
X-IronPort-AV: E=Sophos;i="4.84,215,1355097600"; 
   d="scan'208";a="16149111"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>, <xen-devel@lists.xen.org>
Subject: [PATCH 2/2] xen-blkfront: implement safe version of llist_for_each_entry
Date: Tue, 4 Dec 2012 15:21:53 +0100
Message-ID: <1354630913-17287-2-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1354630913-17287-1-git-send-email-roger.pau@citrix.com>
References: <1354630913-17287-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a safe version of llist_for_each_entry, and use it in
blkif_free. Previously grants where freed while iterating the list,
which lead to dereferences when trying to fetch the next item.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: xen-devel@lists.xen.org
---
 drivers/block/xen-blkfront.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 96e9b00..df21b05 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -143,6 +143,13 @@ static DEFINE_SPINLOCK(minor_lock);
 
 #define DEV_NAME	"xvd"	/* name in /dev */
 
+#define llist_for_each_entry_safe(pos, n, node, member)		\
+	for ((pos) = llist_entry((node), typeof(*(pos)), member),	\
+	     (n) = (pos)->member.next;					\
+	     &(pos)->member != NULL;					\
+	     (pos) = llist_entry(n, typeof(*(pos)), member),		\
+	     (n) = (&(pos)->member != NULL) ? (pos)->member.next : NULL)
+
 static int get_id_from_freelist(struct blkfront_info *info)
 {
 	unsigned long free = info->shadow_free;
@@ -792,6 +799,7 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 {
 	struct llist_node *all_gnts;
 	struct grant *persistent_gnt;
+	struct llist_node *n;
 
 	/* Prevent new requests being issued until we fix things up. */
 	spin_lock_irq(&info->io_lock);
@@ -804,7 +812,7 @@ static void blkif_free(struct blkfront_info *info, int suspend)
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

