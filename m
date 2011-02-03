Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab1BCQ2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 11:28:21 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:33915 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316Ab1BCQ14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 11:27:56 -0500
Date: Thu, 3 Feb 2011 17:26:36 +0100
From: Daniel Kiper <dkiper@net-space.pl>
To: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH R3 3/7] xen/balloon: HVM mode support
Message-ID: <20110203162636.GF1364@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HVM mode support.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
---
 drivers/xen/balloon.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index b4206fd..952cfe2 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -227,7 +227,7 @@ static int increase_reservation(unsigned long nr_pages)
 		set_phys_to_machine(pfn, frame_list[i]);
 
 		/* Link back into the page tables if not highmem. */
-		if (pfn < max_low_pfn) {
+		if (xen_pv_domain() && !PageHighMem(page)) {
 			int ret;
 			ret = HYPERVISOR_update_va_mapping(
 				(unsigned long)__va(pfn << PAGE_SHIFT),
@@ -275,7 +275,7 @@ static int decrease_reservation(unsigned long nr_pages)
 
 		scrub_page(page);
 
-		if (!PageHighMem(page)) {
+		if (xen_pv_domain() && !PageHighMem(page)) {
 			ret = HYPERVISOR_update_va_mapping(
 				(unsigned long)__va(pfn << PAGE_SHIFT),
 				__pte_ma(0), 0);
@@ -390,12 +390,12 @@ static int __init balloon_init(void)
 	unsigned long pfn, extra_pfn_end;
 	struct page *page;
 
-	if (!xen_pv_domain())
+	if (!xen_domain())
 		return -ENODEV;
 
 	pr_info("xen_balloon: Initialising balloon driver.\n");
 
-	balloon_stats.current_pages = min(xen_start_info->nr_pages, max_pfn);
+	balloon_stats.current_pages = xen_pv_domain() ? min(xen_start_info->nr_pages, max_pfn) : max_pfn;
 	balloon_stats.target_pages  = balloon_stats.current_pages;
 	balloon_stats.balloon_low   = 0;
 	balloon_stats.balloon_high  = 0;
-- 
1.5.6.5

