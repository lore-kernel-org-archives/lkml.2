Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab2JKWBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 18:01:22 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:48149 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab2JKWBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 18:01:20 -0400
Date: Thu, 11 Oct 2012 15:01:13 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 6/7]: PVH: balloon and grant changes
Message-ID: <20121011150113.4d525407@mantra.us.oracle.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PVH: balloon and grant changes. For balloon changes we skip setting of
local p2m as it's updated in xen. For grant, the shared grant frame is
the pfn and not mfn, hence its mapped via the same code path as HVM

Signed-off-by: Mukesh R <mukesh.rathor@oracle.com>
---
 drivers/xen/balloon.c     |   18 +++++++++++-------
 drivers/xen/gntdev.c      |    3 ++-
 drivers/xen/grant-table.c |   25 +++++++++++++++++++++----
 3 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 31ab82f..9b895ad 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -358,10 +358,13 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
 		BUG_ON(!xen_feature(XENFEAT_auto_translated_physmap) &&
 		       phys_to_machine_mapping_valid(pfn));
 
-		set_phys_to_machine(pfn, frame_list[i]);
+		if (!xen_feature(XENFEAT_auto_translated_physmap))
+			set_phys_to_machine(pfn, frame_list[i]);
 
 		/* Link back into the page tables if not highmem. */
-		if (xen_pv_domain() && !PageHighMem(page)) {
+		if (xen_pv_domain() && !PageHighMem(page) &&
+		    !xen_feature(XENFEAT_auto_translated_physmap)) {
+
 			int ret;
 			ret = HYPERVISOR_update_va_mapping(
 				(unsigned long)__va(pfn << PAGE_SHIFT),
@@ -418,12 +421,13 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 		scrub_page(page);
 
 		if (xen_pv_domain() && !PageHighMem(page)) {
-			ret = HYPERVISOR_update_va_mapping(
-				(unsigned long)__va(pfn << PAGE_SHIFT),
-				__pte_ma(0), 0);
-			BUG_ON(ret);
+			if (!xen_feature(XENFEAT_auto_translated_physmap)) {
+				ret = HYPERVISOR_update_va_mapping(
+					(unsigned long)__va(pfn << PAGE_SHIFT),
+					__pte_ma(0), 0);
+				BUG_ON(ret);
+			}
 		}
-
 	}
 
 	/* Ensure that ballooned highmem pages don't have kmaps. */
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 5df9fd8..36ec380 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -803,7 +803,8 @@ static int __init gntdev_init(void)
 	if (!xen_domain())
 		return -ENODEV;
 
-	use_ptemod = xen_pv_domain();
+	use_ptemod = xen_pv_domain() &&
+		     !xen_feature(XENFEAT_auto_translated_physmap);
 
 	err = misc_register(&gntdev_miscdev);
 	if (err != 0) {
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index f37faf6..feaebeb 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -976,14 +976,19 @@ static void gnttab_unmap_frames_v2(void)
 static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 {
 	struct gnttab_setup_table setup;
-	unsigned long *frames;
+	unsigned long *frames, start_gpfn;
 	unsigned int nr_gframes = end_idx + 1;
 	int rc;
 
-	if (xen_hvm_domain()) {
+	if (xen_hvm_domain() || xen_feature(XENFEAT_auto_translated_physmap)) {
 		struct xen_add_to_physmap xatp;
 		unsigned int i = end_idx;
 		rc = 0;
+
+		if (xen_hvm_domain())
+			start_gpfn = xen_hvm_resume_frames >> PAGE_SHIFT;
+		else
+			start_gpfn = virt_to_pfn(gnttab_shared.addr);
 		/*
 		 * Loop backwards, so that the first hypercall has the largest
 		 * index, ensuring that the table will grow only once.
@@ -992,7 +997,7 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 			xatp.domid = DOMID_SELF;
 			xatp.idx = i;
 			xatp.space = XENMAPSPACE_grant_table;
-			xatp.gpfn = (xen_hvm_resume_frames >> PAGE_SHIFT) + i;
+			xatp.gpfn = start_gpfn + i;
 			rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp);
 			if (rc != 0) {
 				printk(KERN_WARNING
@@ -1055,7 +1060,7 @@ static void gnttab_request_version(void)
 	int rc;
 	struct gnttab_set_version gsv;
 
-	if (xen_hvm_domain())
+	if (xen_hvm_domain() || xen_feature(XENFEAT_auto_translated_physmap))
 		gsv.version = 1;
 	else
 		gsv.version = 2;
@@ -1083,12 +1088,24 @@ static void gnttab_request_version(void)
 int gnttab_resume(void)
 {
 	unsigned int max_nr_gframes;
+	char *kmsg = "Failed to kmalloc pages for pv in hvm grant frames\n";
 
 	gnttab_request_version();
 	max_nr_gframes = gnttab_max_grant_frames();
 	if (max_nr_gframes < nr_grant_frames)
 		return -ENOSYS;
 
+	/* PVH note: xen will free existing kmalloc'd mfn in
+	 * XENMEM_add_to_physmap */
+	if (xen_pv_domain() && xen_feature(XENFEAT_auto_translated_physmap) &&
+	    !gnttab_shared.addr) {
+		gnttab_shared.addr =
+			kmalloc(max_nr_gframes * PAGE_SIZE, GFP_KERNEL);
+		if (!gnttab_shared.addr) {
+			pr_warn("%s", kmsg);
+			return -ENOMEM;
+		}
+	}
 	if (xen_pv_domain())
 		return gnttab_map(0, nr_grant_frames - 1);
 
-- 
1.7.2.3

