Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab0LCQw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 11:52:27 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:26041 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753293Ab0LCQw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 11:52:26 -0500
Date: Fri, 3 Dec 2010 08:52:26 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, pv-drivers@vmware.com
Subject: [PATCH] VMware balloon: stop locking pages when hypervisor tells us
 enough
Message-ID: <20101203165226.GA16146@dtor-ws.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When hypervisor decides to decrease target balloon size while the
balloon driver tries to lock pages hypervisor may respond with
VMW_BALLOON_PPN_NOTNEEDED. Use this data and immediately stop reserving
pages and wait for the next update cycle to fetch new target instead
of continuing trying to lock pages until size of refused list grows
above VMW_BALLOON_MAX_REFUSED (16) pages.

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---
 drivers/misc/vmw_balloon.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 2a1e804..4263d9d 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -45,7 +45,7 @@
 
 MODULE_AUTHOR("VMware, Inc.");
 MODULE_DESCRIPTION("VMware Memory Control (Balloon) Driver");
-MODULE_VERSION("1.2.1.1-k");
+MODULE_VERSION("1.2.1.2-k");
 MODULE_ALIAS("dmi:*:svnVMware*:*");
 MODULE_ALIAS("vmware_vmmemctl");
 MODULE_LICENSE("GPL");
@@ -315,7 +315,8 @@ static bool vmballoon_send_get_target(struct vmballoon *b, u32 *new_target)
  * fear that guest will need it. Host may reject some pages, we need to
  * check the return value and maybe submit a different page.
  */
-static bool vmballoon_send_lock_page(struct vmballoon *b, unsigned long pfn)
+static bool vmballoon_send_lock_page(struct vmballoon *b, unsigned long pfn,
+				     unsigned int *hv_status)
 {
 	unsigned long status, dummy;
 	u32 pfn32;
@@ -326,7 +327,7 @@ static bool vmballoon_send_lock_page(struct vmballoon *b, unsigned long pfn)
 
 	STATS_INC(b->stats.lock);
 
-	status = VMWARE_BALLOON_CMD(LOCK, pfn, dummy);
+	*hv_status = status = VMWARE_BALLOON_CMD(LOCK, pfn, dummy);
 	if (vmballoon_check_status(b, status))
 		return true;
 
@@ -410,6 +411,7 @@ static int vmballoon_reserve_page(struct vmballoon *b, bool can_sleep)
 {
 	struct page *page;
 	gfp_t flags;
+	unsigned int hv_status;
 	bool locked = false;
 
 	do {
@@ -429,11 +431,12 @@ static int vmballoon_reserve_page(struct vmballoon *b, bool can_sleep)
 		}
 
 		/* inform monitor */
-		locked = vmballoon_send_lock_page(b, page_to_pfn(page));
+		locked = vmballoon_send_lock_page(b, page_to_pfn(page), &hv_status);
 		if (!locked) {
 			STATS_INC(b->stats.refused_alloc);
 
-			if (b->reset_required) {
+			if (hv_status == VMW_BALLOON_ERROR_RESET ||
+			    hv_status == VMW_BALLOON_ERROR_PPN_NOTNEEDED) {
 				__free_page(page);
 				return -EIO;
 			}
-- 
1.7.3.2

