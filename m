Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681Ab0I0A54 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 20:57:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:61860 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758547Ab0I0A5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 20:57:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,240,1283756400"; 
   d="scan'208";a="841121789"
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v2 6/7] x86, NMI, Add support to notify hardware error with unknown NMI
Date: Mon, 27 Sep 2010 08:57:05 +0800
Message-Id: <1285549026-5008-6-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some platforms, fatal hardware error may be notified via unknown
NMI.

For example, on some platform with APEI firmware first mode support,
firmware generates NMI for fatal error but without error record. The
unknown NMI should be treated as notification of fatal hardware
error. The unknown_nmi_for_hwerr is added for these platform, if it is
not zero, system will treat unknown NMI as notification of fatal
hardware error.

These platforms are identified via the presentation of APEI HEST or
some PCI ID of the host bridge. The PCI ID of host bridge instead of
DMI ID is used, so that the checking can be done based on the platform
type instead of motherboard. This should be simpler and sufficient.

The method to identify the platforms is designed by Andi Kleen.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/include/asm/nmi.h |    1 
 arch/x86/kernel/Makefile   |    2 +
 arch/x86/kernel/hwerr.c    |   55 +++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/traps.c    |   10 ++++++++
 drivers/acpi/apei/hest.c   |    8 ++++++
 5 files changed, 76 insertions(+)
 create mode 100644 arch/x86/kernel/hwerr.c

--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -44,6 +44,7 @@ struct ctl_table;
 extern int proc_nmi_enabled(struct ctl_table *, int ,
 			void __user *, size_t *, loff_t *);
 extern int unknown_nmi_panic;
+extern int unknown_nmi_for_hwerr;
 
 void arch_trigger_all_cpu_backtrace(void);
 #define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -118,6 +118,8 @@ obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION)
 
 obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
 
+obj-y					+= hwerr.o
+
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
--- /dev/null
+++ b/arch/x86/kernel/hwerr.c
@@ -0,0 +1,55 @@
+/*
+ * Hardware error architecture dependent processing
+ *
+ * Copyright 2010 Intel Corp.
+ *   Author: Huang Ying <ying.huang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/nmi.h>
+
+/*
+ * On some platform, hardware errors may be notified via unknown
+ * NMI. These platform is identified via the PCI ID of host bridge.
+ *
+ * The PCI ID of host bridge instead of DMI ID is used, so that the
+ * checking can be done based on the platform instead of motherboard.
+ * This should be simpler and sufficient.
+ */
+static const
+struct pci_device_id unknown_nmi_for_hwerr_platform[] __initdata = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x3406) },
+	{ 0, }
+};
+
+int __init check_unknown_nmi_for_hwerr(void)
+{
+	struct pci_dev *dev = NULL;
+
+	for_each_pci_dev(dev) {
+		if (pci_match_id(unknown_nmi_for_hwerr_platform, dev)) {
+			pr_info(
+"Host bridge is identified, will treat unknown NMI as hardware error!\n");
+			unknown_nmi_for_hwerr = 1;
+			break;
+		}
+	}
+
+	return 0;
+}
+late_initcall(check_unknown_nmi_for_hwerr);
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -83,6 +83,8 @@ EXPORT_SYMBOL_GPL(used_vectors);
 
 static int ignore_nmis;
 
+int unknown_nmi_for_hwerr;
+
 /*
  * Prevent NMI reason port (0x61) being accessed simultaneously, can
  * only be used in NMI handler.
@@ -360,6 +362,14 @@ io_check_error(unsigned char reason, str
 static notrace __kprobes void
 unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 {
+	/*
+	 * On some platforms, hardware errors may be notified via
+	 * unknown NMI
+	 */
+	if (unknown_nmi_for_hwerr)
+		panic("NMI for hardware error without error record: "
+		      "Not continuing");
+
 #ifdef CONFIG_MCA
 	/*
 	 * Might actually be able to figure out what the guilty party
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -35,6 +35,7 @@
 #include <linux/highmem.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
+#include <linux/nmi.h>
 #include <acpi/apei.h>
 
 #include "apei-internal.h"
@@ -222,6 +223,13 @@ static int __init hest_init(void)
 	if (rc)
 		goto err;
 
+	/*
+	 * System has proper HEST should treat unknown NMI as fatal
+	 * hardware error notification
+	 */
+	pr_info("HEST is valid, will treat unknown NMI as hardware error!\n");
+	unknown_nmi_for_hwerr = 1;
+
 	rc = hest_ghes_dev_register(ghes_count);
 	if (rc)
 		goto err;
