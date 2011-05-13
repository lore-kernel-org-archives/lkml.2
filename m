Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab1EMIX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 04:23:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:22866 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757797Ab1EMIXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 04:23:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,363,1301900400"; 
   d="scan'208";a="746686180"
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [RFC] x86, NMI, Treat unknown NMI as hardware error
Date: Fri, 13 May 2011 16:23:38 +0800
Message-Id: <1305275018-20596-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In general, unknown NMI is used by hardware and firmware to notify
fatal hardware errors to OS. So the Linux should treat unknown NMI as
hardware error and go panic upon unknown NMI for better error
containment.

But there are some legacy machine which would randomly send unknown
NMIs for no good reason.  To support these machines, a white list
mechanism is provided to treat unknown NMI as hardware error only on
some known working system.

These systems are identified via the presentation of APEI HEST or
some PCI ID of the host bridge. The PCI ID of host bridge instead of
DMI ID is used, so that the checking can be done based on the platform
type instead of motherboard. This should be simpler and sufficient.

The method to identify the platforms is designed by Andi Kleen.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/nmi.h |    1 
 arch/x86/kernel/Makefile   |    2 +
 arch/x86/kernel/hwerr.c    |   61 +++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/traps.c    |   31 +++++++++++++++++-----
 drivers/acpi/apei/hest.c   |    8 +++++
 5 files changed, 96 insertions(+), 7 deletions(-)
 create mode 100644 arch/x86/kernel/hwerr.c

--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -17,6 +17,7 @@ struct ctl_table;
 extern int proc_nmi_enabled(struct ctl_table *, int ,
 			void __user *, size_t *, loff_t *);
 extern int unknown_nmi_panic;
+extern void set_unknown_nmi_as_hwerr(void);
 
 void arch_trigger_all_cpu_backtrace(void);
 #define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -112,6 +112,8 @@ obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION)
 obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
 obj-$(CONFIG_OF)			+= devicetree.o
 
+obj-y					+= hwerr.o
+
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
--- /dev/null
+++ b/arch/x86/kernel/hwerr.c
@@ -0,0 +1,61 @@
+/*
+ * Hardware error architecture dependent processing
+ *
+ * Copyright 2010,2011 Intel Corp.
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
+ * In general, unknown NMI is used by hardware and firmware to notify
+ * fatal hardware errors to OS. So the Linux should treat unknown NMI
+ * as hardware error and go panic upon unknown NMI for better error
+ * containment.
+ *
+ * But there are some legacy machine which would randomly send unknown
+ * NMIs for no good reason.  To support these systems, a white list
+ * mechanism is used to treat unknown NMI as hardware error only on
+ * some known working system.
+ *
+ * The PCI ID of host bridge instead of DMI ID is used, so that the
+ * checking can be done based on the platform instead of motherboard.
+ * This should be simpler and sufficient.
+ */
+static const
+struct pci_device_id unknown_nmi_as_hwerr_platform[] __initdata = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x3406) },
+	{ 0, }
+};
+
+int __init check_unknown_nmi_as_hwerr(void)
+{
+	struct pci_dev *dev = NULL;
+
+	for_each_pci_dev(dev) {
+		if (pci_match_id(unknown_nmi_as_hwerr_platform, dev)) {
+			pr_info("System has working NMI, will treat unknown NMI as hardware error!\n");
+			set_unknown_nmi_as_hwerr();
+			break;
+		}
+	}
+
+	return 0;
+}
+late_initcall(check_unknown_nmi_as_hwerr);
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -83,6 +83,8 @@ EXPORT_SYMBOL_GPL(used_vectors);
 
 static int ignore_nmis;
 
+static int unknown_nmi_as_hwerr;
+
 int unknown_nmi_panic;
 /*
  * Prevent NMI reason port (0x61) being accessed simultaneously, can
@@ -368,12 +370,18 @@ io_check_error(unsigned char reason, str
 	outb(reason, NMI_REASON_PORT);
 }
 
+void set_unknown_nmi_as_hwerr(void)
+{
+	unknown_nmi_as_hwerr = 1;
+}
+
 static notrace __kprobes void
 unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 {
 	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
 			NOTIFY_STOP)
 		return;
+
 #ifdef CONFIG_MCA
 	/*
 	 * Might actually be able to figure out what the guilty party
@@ -384,14 +392,23 @@ unknown_nmi_error(unsigned char reason,
 		return;
 	}
 #endif
-	pr_emerg("Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
-		 reason, smp_processor_id());
-
-	pr_emerg("Do you have a strange power saving mode enabled?\n");
-	if (unknown_nmi_panic || panic_on_unrecovered_nmi)
-		panic("NMI: Not continuing");
+	/*
+	 * On modern systems, unknown NMI means fatal hardware error, but
+	 * this may be not true on some legacy system.
+	 */
+	if (unknown_nmi_as_hwerr) {
+		panic("NMI for hardware error without error record: Not continuing\n"
+		      "Please check BIOS/BMC log for further information.");
+	} else {
+		pr_emerg("Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
+			 reason, smp_processor_id());
+
+		pr_emerg("Do you have a strange power saving mode enabled?\n");
+		if (unknown_nmi_panic || panic_on_unrecovered_nmi)
+			panic("NMI: Not continuing");
 
-	pr_emerg("Dazed and confused, but trying to continue\n");
+		pr_emerg("Dazed and confused, but trying to continue\n");
+	}
 }
 
 static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -35,6 +35,7 @@
 #include <linux/highmem.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
+#include <linux/nmi.h>
 #include <acpi/apei.h>
 
 #include "apei-internal.h"
@@ -225,6 +226,13 @@ void __init acpi_hest_init(void)
 	if (rc)
 		goto err;
 
+	/*
+	 * System has proper HEST should treat unknown NMI as fatal
+	 * hardware error notification
+	 */
+	pr_info(HEST_PFX "HEST is valid, will treat unknown NMI as hardware error!\n");
+	set_unknown_nmi_as_hwerr();
+
 	rc = hest_ghes_dev_register(ghes_count);
 	if (!rc) {
 		pr_info(HEST_PFX "Table parsing has been initialized.\n");
