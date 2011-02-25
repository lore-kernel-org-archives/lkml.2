Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab1BYRLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 12:11:35 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:28475 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932650Ab1BYRLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 12:11:33 -0500
X-IronPort-AV: E=Sophos;i="4.62,226,1297054800"; 
   d="scan'208";a="137550359"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        konrad.wilk@oracle.com, Stefano.Stabellini@eu.citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v2 4/6] xen: make the ballon driver work for hvm domains
Date: Fri, 25 Feb 2011 17:11:58 +0000
Message-Id: <1298653920-20299-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1102251651570.19277@kaball-desktop>
References: <alpine.DEB.2.00.1102251651570.19277@kaball-desktop>
X-OriginalArrivalTime: 25 Feb 2011 17:11:31.0861 (UTC) FILETIME=[0C598450:01CBD50F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/balloon.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 43f9f02..9294f25 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -232,7 +232,7 @@ static int increase_reservation(unsigned long nr_pages)
 		set_phys_to_machine(pfn, frame_list[i]);
 
 		/* Link back into the page tables if not highmem. */
-		if (pfn < max_low_pfn) {
+		if (!xen_hvm_domain() && pfn < max_low_pfn) {
 			int ret;
 			ret = HYPERVISOR_update_va_mapping(
 				(unsigned long)__va(pfn << PAGE_SHIFT),
@@ -280,7 +280,7 @@ static int decrease_reservation(unsigned long nr_pages)
 
 		scrub_page(page);
 
-		if (!PageHighMem(page)) {
+		if (!xen_hvm_domain() && !PageHighMem(page)) {
 			ret = HYPERVISOR_update_va_mapping(
 				(unsigned long)__va(pfn << PAGE_SHIFT),
 				__pte_ma(0), 0);
@@ -392,15 +392,19 @@ static struct notifier_block xenstore_notifier;
 
 static int __init balloon_init(void)
 {
-	unsigned long pfn, extra_pfn_end;
+ 	unsigned long pfn, nr_pages, extra_pfn_end;
 	struct page *page;
 
-	if (!xen_pv_domain())
+	if (!xen_domain())
 		return -ENODEV;
 
 	pr_info("xen_balloon: Initialising balloon driver.\n");
 
-	balloon_stats.current_pages = min(xen_start_info->nr_pages, max_pfn);
+ 	if (xen_pv_domain())
+ 		nr_pages = xen_start_info->nr_pages;
+ 	else
+ 		nr_pages = max_pfn;
+ 	balloon_stats.current_pages = min(nr_pages, max_pfn);
 	balloon_stats.target_pages  = balloon_stats.current_pages;
 	balloon_stats.balloon_low   = 0;
 	balloon_stats.balloon_high  = 0;
-- 
1.5.6.5

