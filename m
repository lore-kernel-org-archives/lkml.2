Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366Ab1JZP3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 11:29:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35867 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933026Ab1JZP3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 11:29:41 -0400
Date: Wed, 26 Oct 2011 17:28:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/hyperv change for v3.2
Message-ID: <20111026152803.GA31571@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-hyperv-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-hyperv-for-linus


out-of-topic modifications in x86-hyperv-for-linus:
---------------------------------------------------
drivers/staging/hv/Makefile        # 6f4151c8: x86: Hyper-V: Integrate the cloc
drivers/staging/hv/hv_timesource.c # 6f4151c8: x86: Hyper-V: Integrate the cloc

 Thanks,

	Ingo

------------------>
K. Y. Srinivasan (1):
      x86: Hyper-V: Integrate the clocksource with Hyper-V detection code


 arch/x86/kernel/cpu/mshyperv.c     |   23 ++++++++
 drivers/staging/hv/Makefile        |    2 +-
 drivers/staging/hv/hv_timesource.c |  101 ------------------------------------
 3 files changed, 24 insertions(+), 102 deletions(-)
 delete mode 100644 drivers/staging/hv/hv_timesource.c

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index d944bf6..0a630dd 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -11,6 +11,8 @@
  */
 
 #include <linux/types.h>
+#include <linux/time.h>
+#include <linux/clocksource.h>
 #include <linux/module.h>
 #include <asm/processor.h>
 #include <asm/hypervisor.h>
@@ -36,6 +38,25 @@ static bool __init ms_hyperv_platform(void)
 		!memcmp("Microsoft Hv", hyp_signature, 12);
 }
 
+static cycle_t read_hv_clock(struct clocksource *arg)
+{
+	cycle_t current_tick;
+	/*
+	 * Read the partition counter to get the current tick count. This count
+	 * is set to 0 when the partition is created and is incremented in
+	 * 100 nanosecond units.
+	 */
+	rdmsrl(HV_X64_MSR_TIME_REF_COUNT, current_tick);
+	return current_tick;
+}
+
+static struct clocksource hyperv_cs = {
+	.name		= "hyperv_clocksource",
+	.rating		= 400, /* use this when running on Hyperv*/
+	.read		= read_hv_clock,
+	.mask		= CLOCKSOURCE_MASK(64),
+};
+
 static void __init ms_hyperv_init_platform(void)
 {
 	/*
@@ -46,6 +67,8 @@ static void __init ms_hyperv_init_platform(void)
 
 	printk(KERN_INFO "HyperV: features 0x%x, hints 0x%x\n",
 	       ms_hyperv.features, ms_hyperv.hints);
+
+	clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
 }
 
 const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
diff --git a/drivers/staging/hv/Makefile b/drivers/staging/hv/Makefile
index 3004674..14e3c6a 100644
--- a/drivers/staging/hv/Makefile
+++ b/drivers/staging/hv/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_HYPERV)		+= hv_vmbus.o hv_timesource.o
+obj-$(CONFIG_HYPERV)		+= hv_vmbus.o
 obj-$(CONFIG_HYPERV_STORAGE)	+= hv_storvsc.o
 obj-$(CONFIG_HYPERV_BLOCK)	+= hv_blkvsc.o
 obj-$(CONFIG_HYPERV_NET)	+= hv_netvsc.o
diff --git a/drivers/staging/hv/hv_timesource.c b/drivers/staging/hv/hv_timesource.c
deleted file mode 100644
index 2b0f9aa..0000000
--- a/drivers/staging/hv/hv_timesource.c
+++ /dev/null
@@ -1,101 +0,0 @@
-/*
- * A clocksource for Linux running on HyperV.
- *
- *
- * Copyright (C) 2010, Novell, Inc.
- * Author : K. Y. Srinivasan <ksrinivasan@novell.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- * NON INFRINGEMENT.  See the GNU General Public License for more
- * details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
- *
- */
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/clocksource.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/dmi.h>
-#include <asm/hyperv.h>
-#include <asm/mshyperv.h>
-#include <asm/hypervisor.h>
-
-#define HV_CLOCK_SHIFT	22
-
-static cycle_t read_hv_clock(struct clocksource *arg)
-{
-	cycle_t current_tick;
-	/*
-	 * Read the partition counter to get the current tick count. This count
-	 * is set to 0 when the partition is created and is incremented in
-	 * 100 nanosecond units.
-	 */
-	rdmsrl(HV_X64_MSR_TIME_REF_COUNT, current_tick);
-	return current_tick;
-}
-
-static struct clocksource hyperv_cs = {
-	.name           = "hyperv_clocksource",
-	.rating         = 400, /* use this when running on Hyperv*/
-	.read           = read_hv_clock,
-	.mask           = CLOCKSOURCE_MASK(64),
-	/*
-	 * The time ref counter in HyperV is in 100ns units.
-	 * The definition of mult is:
-	 * mult/2^shift = ns/cyc = 100
-	 * mult = (100 << shift)
-	 */
-	.mult           = (100 << HV_CLOCK_SHIFT),
-	.shift          = HV_CLOCK_SHIFT,
-};
-
-static const struct dmi_system_id __initconst
-hv_timesource_dmi_table[] __maybe_unused  = {
-	{
-		.ident = "Hyper-V",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
-			DMI_MATCH(DMI_BOARD_NAME, "Virtual Machine"),
-		},
-	},
-	{ },
-};
-MODULE_DEVICE_TABLE(dmi, hv_timesource_dmi_table);
-
-static const struct pci_device_id __initconst
-hv_timesource_pci_table[] __maybe_unused = {
-	{ PCI_DEVICE(0x1414, 0x5353) }, /* VGA compatible controller */
-	{ 0 }
-};
-MODULE_DEVICE_TABLE(pci, hv_timesource_pci_table);
-
-
-static int __init init_hv_clocksource(void)
-{
-	if ((x86_hyper != &x86_hyper_ms_hyperv) ||
-		!(ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE))
-		return -ENODEV;
-
-	if (!dmi_check_system(hv_timesource_dmi_table))
-		return -ENODEV;
-
-	pr_info("Registering HyperV clock source\n");
-	return clocksource_register(&hyperv_cs);
-}
-
-module_init(init_hv_clocksource);
-MODULE_DESCRIPTION("HyperV based clocksource");
-MODULE_AUTHOR("K. Y. Srinivasan <ksrinivasan@novell.com>");
-MODULE_LICENSE("GPL");
