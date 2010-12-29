Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab0L2RTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 12:19:34 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:47397 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab0L2RTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 12:19:31 -0500
Date: Wed, 29 Dec 2010 18:03:35 +0100
From: Daniel Kiper <dkiper@net-space.pl>
To: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH R2 3/7] xen/balloon: HVM mode support
Message-ID: <20101229170335.GH2743@router-fw-old.local.net-space.pl>
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
 drivers/xen/balloon.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 97919af..878f54c 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -224,7 +224,7 @@ static int increase_reservation(unsigned long nr_pages)
 		set_phys_to_machine(pfn, frame_list[i]);
 
 		/* Link back into the page tables if not highmem. */
-		if (pfn < max_low_pfn) {
+		if (xen_pv_domain() && !PageHighMem(page)) {
 			int ret;
 			ret = HYPERVISOR_update_va_mapping(
 				(unsigned long)__va(pfn << PAGE_SHIFT),
@@ -274,7 +274,7 @@ static int decrease_reservation(unsigned long nr_pages)
 
 		scrub_page(page);
 
-		if (!PageHighMem(page)) {
+		if (xen_pv_domain() && !PageHighMem(page)) {
 			ret = HYPERVISOR_update_va_mapping(
 				(unsigned long)__va(pfn << PAGE_SHIFT),
 				__pte_ma(0), 0);
@@ -390,15 +390,17 @@ static struct notifier_block xenstore_notifier;
 
 static int __init balloon_init(void)
 {
-	unsigned long pfn;
+	unsigned long pfn, nr_pages;
 	struct page *page;
 
-	if (!xen_pv_domain())
+	if (!xen_domain())
 		return -ENODEV;
 
 	pr_info("xen_balloon: Initialising balloon driver.\n");
 
-	balloon_stats.current_pages = min(xen_start_info->nr_pages, max_pfn);
+	nr_pages = xen_pv_domain() ? xen_start_info->nr_pages : max_pfn;
+
+	balloon_stats.current_pages = min(nr_pages, max_pfn);
 	balloon_stats.target_pages  = balloon_stats.current_pages;
 	balloon_stats.balloon_low   = 0;
 	balloon_stats.balloon_high  = 0;
@@ -410,7 +412,7 @@ static int __init balloon_init(void)
 	register_balloon(&balloon_sysdev);
 
 	/* Initialise the balloon with excess memory space. */
-	for (pfn = xen_start_info->nr_pages; pfn < max_pfn; pfn++) {
+	for (pfn = nr_pages; pfn < max_pfn; pfn++) {
 		page = pfn_to_page(pfn);
 		if (!PageReserved(page))
 			balloon_append(page);
-- 
1.4.4.4

