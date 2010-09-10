Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab0IJCvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 22:51:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:56172 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031Ab0IJCvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 22:51:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,344,1280732400"; 
   d="scan'208";a="655886362"
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Huang Ying <ying.huang@intel.com>
Subject: [RFC 5/6] x86, NMI, Add support to notify hardware error with unknown NMI
Date: Fri, 10 Sep 2010 10:51:04 +0800
Message-Id: <1284087065-32722-5-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
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

# TODO

- Report unknown NMI as fatal hardware error with new hardware error
  reporting interface, so that the error record can be gotten after
  system reboot.

- Because printk is not safe in NMI handler, all printk except that
  called after bust_spinlocks will be called in a delayed IRQ context
  to prevent system deadlock.

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
@@ -116,6 +116,8 @@ obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION)
 
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
@@ -349,6 +351,14 @@ io_check_error(unsigned char reason, str
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
