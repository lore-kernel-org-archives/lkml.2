Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741Ab2EWSJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 14:09:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760659Ab2EWSJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 14:09:51 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, matt.fleming@intel.com, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/3] x86: Allow early PCI quirks to trigger on bus 1
Date: Wed, 23 May 2012 14:08:45 -0400
Message-Id: <1337796526-3649-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1337796526-3649-1-git-send-email-mjg@redhat.com>
References: <1337796526-3649-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.206
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The early PCI quirks code currently only scans bus 0. Extend it to bus 1
in order to allow us to add a quirk for broken Apple firmware, and make
sure that the vendor-generic chipset quirks are only run on bus 0.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/kernel/early-quirks.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 3755ef4..dcf4bcf 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -48,6 +48,10 @@ static void __init fix_hypertransport_config(int num, int slot, int func)
 static void __init via_bugs(int  num, int slot, int func)
 {
 #ifdef CONFIG_GART_IOMMU
+	/* Only match on the root bus */
+	if (num > 0)
+		return;
+
 	if ((max_pfn > MAX_DMA32_PFN ||  force_iommu) &&
 	    !gart_iommu_aperture_allowed) {
 		printk(KERN_INFO
@@ -72,6 +76,10 @@ static void __init nvidia_bugs(int num, int slot, int func)
 {
 #ifdef CONFIG_ACPI
 #ifdef CONFIG_X86_IO_APIC
+	/* Only match on the root bus */
+	if (num > 0)
+		return;
+
 	/*
 	 * All timer overrides on Nvidia are
 	 * wrong unless HPET is enabled.
@@ -205,10 +213,7 @@ struct chipset {
 };
 
 /*
- * Only works for devices on the root bus. If you add any devices
- * not on bus 0 readd another loop level in early_quirks(). But
- * be careful because at least the Nvidia quirk here relies on
- * only matching on bus 0.
+ * Only works for devices on the root bus and bus 1.
  */
 static struct chipset early_qrk[] __initdata = {
 	{ PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
@@ -276,17 +281,19 @@ static int __init check_dev_quirk(int num, int slot, int func)
 
 void __init early_quirks(void)
 {
-	int slot, func;
+	int bus, slot, func;
 
 	if (!early_pci_allowed())
 		return;
 
 	/* Poor man's PCI discovery */
-	/* Only scan the root bus */
-	for (slot = 0; slot < 32; slot++)
-		for (func = 0; func < 8; func++) {
-			/* Only probe function 0 on single fn devices */
-			if (check_dev_quirk(0, slot, func))
-				break;
-		}
+	/* Apple Broadcom quirk is on bus 1 */
+	for (bus = 0; bus < 2; bus++) {
+		for (slot = 0; slot < 32; slot++)
+			for (func = 0; func < 8; func++) {
+				/* Only probe function 0 on single fn devices */
+				if (check_dev_quirk(bus, slot, func))
+					break;
+			}
+	}
 }
-- 
1.7.10.2

