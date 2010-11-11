Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab0KKA4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:56:16 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:46541 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab0KKA4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:56:12 -0500
Message-ID: <4CDB3EBB.4010800@kernel.org>
Date: Wed, 10 Nov 2010 16:54:19 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Jan Beulich <jbeulich@novell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -v2 2/2] x86/pci: Add mmconf range into e820 for when it is
 from MSR with amd faml0h
References: <4CDB3E85.9010604@kernel.org>
In-Reply-To: <4CDB3E85.9010604@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


for AMD Fam10h, it we read mmconf from MSR early, we should just trust it
because we check it and correct it already.

so add it to e820

Also correct the base calulating to make it work below 4g case.

-v2: remove unrelated sort_range changes.
     also make FAM10H_MMIO_CONF_BASE_MASK to be ULL pointed by Jan.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/msr-index.h   |    2 +-
 arch/x86/kernel/mmconf-fam10h_64.c |   21 ++++++++++++++++++++-
 2 files changed, 21 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/mmconf-fam10h_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mmconf-fam10h_64.c
+++ linux-2.6/arch/x86/kernel/mmconf-fam10h_64.c
@@ -16,6 +16,7 @@
 #include <asm/acpi.h>
 #include <asm/mmconfig.h>
 #include <asm/pci_x86.h>
+#include <asm/e820.h>
 
 struct pci_hostbridge_probe {
 	u32 bus;
@@ -27,6 +28,21 @@ struct pci_hostbridge_probe {
 static u64 __cpuinitdata fam10h_pci_mmconf_base;
 static int __cpuinitdata fam10h_pci_mmconf_base_status;
 
+/* only on BSP */
+static void __init_refok e820_add_mmconf_range(int busnbits)
+{
+	u64 end;
+
+	end = fam10h_pci_mmconf_base + (1ULL<<(busnbits + 20)) - 1;
+	if (!e820_all_mapped(fam10h_pci_mmconf_base, end+1, E820_RESERVED)) {
+		printk(KERN_DEBUG "Fam 10h mmconf [%llx, %llx]\n",
+				 fam10h_pci_mmconf_base, end);
+		e820_add_region(fam10h_pci_mmconf_base, 1ULL<<(busnbits + 20),
+				 E820_RESERVED);
+		sanitize_e820_map();
+	}
+}
+
 static struct pci_hostbridge_probe pci_probes[] __cpuinitdata = {
 	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 },
 	{ 0xff, 0, PCI_VENDOR_ID_AMD, 0x1200 },
@@ -169,6 +185,7 @@ fail:
 out:
 	fam10h_pci_mmconf_base = base;
 	fam10h_pci_mmconf_base_status = 1;
+	e820_add_mmconf_range(8);
 }
 
 void __cpuinit fam10h_check_enable_mmcfg(void)
@@ -191,10 +208,12 @@ void __cpuinit fam10h_check_enable_mmcfg
 		/* only trust the one handle 256 buses, if acpi=off */
 		if (!acpi_pci_disabled || busnbits >= 8) {
 			u64 base;
-			base = val & (0xffffULL << 32);
+			base = val & (FAM10H_MMIO_CONF_BASE_MASK <<
+					FAM10H_MMIO_CONF_BASE_SHIFT);
 			if (fam10h_pci_mmconf_base_status <= 0) {
 				fam10h_pci_mmconf_base = base;
 				fam10h_pci_mmconf_base_status = 1;
+				e820_add_mmconf_range(busnbits);
 				return;
 			} else if (fam10h_pci_mmconf_base ==  base)
 				return;
Index: linux-2.6/arch/x86/include/asm/msr-index.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/msr-index.h
+++ linux-2.6/arch/x86/include/asm/msr-index.h
@@ -128,7 +128,7 @@
 #define FAM10H_MMIO_CONF_ENABLE		(1<<0)
 #define FAM10H_MMIO_CONF_BUSRANGE_MASK	0xf
 #define FAM10H_MMIO_CONF_BUSRANGE_SHIFT 2
-#define FAM10H_MMIO_CONF_BASE_MASK	0xfffffff
+#define FAM10H_MMIO_CONF_BASE_MASK	0xfffffffULL
 #define FAM10H_MMIO_CONF_BASE_SHIFT	20
 #define MSR_FAM10H_NODE_ID		0xc001100c
 
