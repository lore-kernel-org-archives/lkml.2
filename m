Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab0FCNMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:12:37 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:30773 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab0FCNL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:11:26 -0400
X-IronPort-AV: E=Sophos;i="4.53,354,1272859200"; 
   d="scan'208";a="99908938"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: Stefano.Stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
       jeremy@goop.org, ddutile@redhat.com, sheng@linux.intel.com,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 06/12] Allow xen platform pci device to be compiled as a module
Date: Thu,  3 Jun 2010 14:10:39 +0100
Message-Id: <1275570645-27189-6-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-OriginalArrivalTime: 03 Jun 2010 13:11:25.0163 (UTC) FILETIME=[44FE9BB0:01CB031E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/events.c              |    1 +
 drivers/xen/grant-table.c         |   20 +++++++++++---------
 drivers/xen/manage.c              |    1 +
 drivers/xen/platform-pci.c        |    3 +++
 drivers/xen/xenbus/xenbus_probe.c |    1 +
 include/xen/grant_table.h         |    3 +++
 6 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index be378e1..4bd0ea3 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -689,6 +689,7 @@ void xen_hvm_evtchn_do_upcall(void)
 {
 	__xen_evtchn_do_upcall();
 }
+EXPORT_SYMBOL_GPL(xen_hvm_evtchn_do_upcall);
 
 /* Rebind a new event channel to an existing irq. */
 void rebind_evtchn_irq(int evtchn, int irq)
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 4c959a5..64bcad1 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -61,7 +61,8 @@ static unsigned int boot_max_nr_grant_frames;
 static int gnttab_free_count;
 static grant_ref_t gnttab_free_head;
 static DEFINE_SPINLOCK(gnttab_list_lock);
-static unsigned long hvm_pv_resume_frames;
+unsigned long xen_hvm_resume_frames;
+EXPORT_SYMBOL_GPL(xen_hvm_resume_frames);
 
 static struct grant_entry *shared;
 
@@ -436,7 +437,7 @@ static unsigned int __max_nr_grant_frames(void)
 	return query.max_nr_frames;
 }
 
-static inline unsigned int max_nr_grant_frames(void)
+unsigned int gnttab_max_nr_grant_frames(void)
 {
 	unsigned int xen_max = __max_nr_grant_frames();
 
@@ -444,6 +445,7 @@ static inline unsigned int max_nr_grant_frames(void)
 		return boot_max_nr_grant_frames;
 	return xen_max;
 }
+EXPORT_SYMBOL_GPL(gnttab_max_nr_grant_frames);
 
 static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 {
@@ -464,7 +466,7 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 			xatp.domid = DOMID_SELF;
 			xatp.idx = i;
 			xatp.space = XENMAPSPACE_grant_table;
-			xatp.gpfn = (hvm_pv_resume_frames >> PAGE_SHIFT) + i;
+			xatp.gpfn = (xen_hvm_resume_frames >> PAGE_SHIFT) + i;
 			rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp);
 			if (rc != 0) {
 				printk(KERN_WARNING
@@ -492,7 +494,7 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 
 	BUG_ON(rc || setup.status);
 
-	rc = arch_gnttab_map_shared(frames, nr_gframes, max_nr_grant_frames(),
+	rc = arch_gnttab_map_shared(frames, nr_gframes, gnttab_max_nr_grant_frames(),
 				    &shared);
 	BUG_ON(rc);
 
@@ -505,16 +507,15 @@ int gnttab_resume(void)
 {
 	unsigned int max_nr_gframes;
 
-	max_nr_gframes = max_nr_grant_frames();
+	max_nr_gframes = gnttab_max_nr_grant_frames();
 	if (max_nr_gframes < nr_grant_frames)
 		return -ENOSYS;
 
 	if (xen_pv_domain())
 		return gnttab_map(0, nr_grant_frames - 1);
 
-	if (!hvm_pv_resume_frames) {
-		hvm_pv_resume_frames = alloc_xen_mmio(PAGE_SIZE * max_nr_gframes);
-		shared = ioremap(hvm_pv_resume_frames, PAGE_SIZE * max_nr_gframes);
+	if (!shared) {
+		shared = ioremap(xen_hvm_resume_frames, PAGE_SIZE * max_nr_gframes);
 		if (shared == NULL) {
 			printk(KERN_WARNING
 					"Fail to ioremap gnttab share frames\n");
@@ -541,7 +542,7 @@ static int gnttab_expand(unsigned int req_entries)
 	cur = nr_grant_frames;
 	extra = ((req_entries + (GREFS_PER_GRANT_FRAME-1)) /
 		 GREFS_PER_GRANT_FRAME);
-	if (cur + extra > max_nr_grant_frames())
+	if (cur + extra > gnttab_max_nr_grant_frames())
 		return -ENOSPC;
 
 	rc = gnttab_map(cur, cur + extra - 1);
@@ -599,6 +600,7 @@ int gnttab_init(void)
 	kfree(gnttab_list);
 	return -ENOMEM;
 }
+EXPORT_SYMBOL_GPL(gnttab_init);
 
 static int __devinit __gnttab_init(void)
 {
diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 0716ba6..f5162e4 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -307,5 +307,6 @@ int xen_setup_shutdown_event(void)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(xen_setup_shutdown_event);
 
 subsys_initcall(__setup_shutdown_event);
diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
index 43f5aa8..6285bd9 100644
--- a/drivers/xen/platform-pci.c
+++ b/drivers/xen/platform-pci.c
@@ -106,6 +106,7 @@ static int __devinit platform_pci_init(struct pci_dev *pdev,
 	int i, ret;
 	long ioaddr, iolen;
 	long mmio_addr, mmio_len;
+	unsigned int max_nr_gframes;
 
 	i = pci_enable_device(pdev);
 	if (i)
@@ -153,6 +154,8 @@ static int __devinit platform_pci_init(struct pci_dev *pdev,
 		}
 	}
 
+	max_nr_gframes = gnttab_max_nr_grant_frames();
+	xen_hvm_resume_frames = alloc_xen_mmio(PAGE_SIZE * max_nr_gframes);
 	ret = gnttab_init();
 	if (ret)
 		goto out;
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index dc6ed06..cf971da 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -864,6 +864,7 @@ int xenbus_probe_init(void)
   out_error:
 	return err;
 }
+EXPORT_SYMBOL_GPL(xenbus_probe_init);
 
 postcore_initcall(__xenbus_probe_init);
 
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index 811cda5..2a58ee0 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -113,6 +113,9 @@ int arch_gnttab_map_shared(unsigned long *frames, unsigned long nr_gframes,
 void arch_gnttab_unmap_shared(struct grant_entry *shared,
 			      unsigned long nr_gframes);
 
+extern unsigned long xen_hvm_resume_frames;
+unsigned int gnttab_max_nr_grant_frames(void);
+
 #define gnttab_map_vaddr(map) ((void *)(map.host_virt_addr))
 
 #endif /* __ASM_GNTTAB_H__ */
-- 
1.7.0.4

