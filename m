Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab0EUCHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 22:07:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:60820 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab0EUCHc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 22:07:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,274,1272870000"; 
   d="scan'208,223";a="519939961"
Date: Fri, 21 May 2010 10:19:12 +0800
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       "Du, Alek" <alek.du@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 3/3] x86/mrst: add vrtc driver which serves as a wall clock
 device
Message-ID: <20100521101912.18197227@feng-i7>
In-Reply-To: <alpine.LFD.2.00.1005171102590.3368@localhost.localdomain>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1273254108-3234-8-git-send-email-jacob.jun.pan@linux.intel.com>
	<alpine.LFD.2.00.1005111643380.3401@localhost.localdomain>
	<20100512103422.1d59cc85@feng-i7>
	<alpine.LFD.2.00.1005171102590.3368@localhost.localdomain>
Organization: intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 14760d3bf6f77a17400c30258e365c06cbc36661 Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Wed, 24 Mar 2010 10:31:35 +0800
Subject: [PATCH 3/3] x86/mrst: add vrtc driver which serves as a wall clock device

Moorestown platform doesn't have a m146818 RTC device like traditional
x86 PC, but a firmware emulated virtual RTC device(vrtc), which provides
some basic RTC functions like get/set time. vrtc serves as the only
wall clock device on Moorestown platform.

Currently, vrtc init func will be called as arch_initcall() before
xtime's init. Also move the sfi vrtc table parsing from mrst.c to
vrtc.c

There will be another general vrtc driver for rtc subsystem

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 arch/x86/include/asm/mrst.h |    2 -
 arch/x86/include/asm/vrtc.h |   24 +++++++
 arch/x86/kernel/Makefile    |    2 +-
 arch/x86/kernel/mrst.c      |   45 +-------------
 arch/x86/kernel/vrtc.c      |  147 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 173 insertions(+), 47 deletions(-)
 create mode 100644 arch/x86/include/asm/vrtc.h
 create mode 100644 arch/x86/kernel/vrtc.c

diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index 451d30e..fa144f2 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -11,9 +11,7 @@
 #ifndef _ASM_X86_MRST_H
 #define _ASM_X86_MRST_H
 extern int pci_mrst_init(void);
-int __init sfi_parse_mrtc(struct sfi_table_header *table);
 
 #define SFI_MTMR_MAX_NUM 8
-#define SFI_MRTC_MAX	8
 
 #endif /* _ASM_X86_MRST_H */
diff --git a/arch/x86/include/asm/vrtc.h b/arch/x86/include/asm/vrtc.h
new file mode 100644
index 0000000..fcdfcde
--- /dev/null
+++ b/arch/x86/include/asm/vrtc.h
@@ -0,0 +1,24 @@
+#ifndef _MRST_VRTC_H
+#define _MRST_VRTC_H
+
+#define SFI_MRTC_MAX	8
+#define VRTC_IOLEN	1024
+
+#ifdef CONFIG_X86_MRST
+extern unsigned char vrtc_reg_read(unsigned char reg);
+extern void vrtc_reg_write(unsigned char val, unsigned char reg);
+
+extern struct sfi_rtc_table_entry sfi_mrtc_array[];
+#else
+static inline unsigned char vrtc_reg_read(unsigned char reg)
+{
+	return 0xff;
+}
+
+static inline void vrtc_reg_write(unsigned char val, unsigned char reg)
+{
+	return;
+}
+#endif
+
+#endif
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index e77b220..f3fdcbe 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -104,7 +104,7 @@ obj-$(CONFIG_SCx200)		+= scx200.o
 scx200-y			+= scx200_32.o
 
 obj-$(CONFIG_OLPC)		+= olpc.o
-obj-$(CONFIG_X86_MRST)		+= mrst.o
+obj-$(CONFIG_X86_MRST)		+= mrst.o vrtc.o
 
 microcode-y				:= microcode_core.o
 microcode-$(CONFIG_MICROCODE_INTEL)	+= microcode_intel.o
diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index def416c..fc9268e 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -29,10 +29,6 @@ static u32 sfi_mtimer_usage[SFI_MTMR_MAX_NUM];
 static struct sfi_timer_table_entry sfi_mtimer_array[SFI_MTMR_MAX_NUM];
 int sfi_mtimer_num;
 
-struct sfi_rtc_table_entry sfi_mrtc_array[SFI_MRTC_MAX];
-EXPORT_SYMBOL_GPL(sfi_mrtc_array);
-int sfi_mrtc_num;
-
 /* parse all the mtimer info to a static mtimer array */
 static int __init sfi_parse_mtmr(struct sfi_table_header *table)
 {
@@ -106,41 +102,6 @@ void sfi_free_mtmr(struct sfi_timer_table_entry *mtmr)
 	}
 }
 
-/* parse all the mrtc info to a global mrtc array */
-int __init sfi_parse_mrtc(struct sfi_table_header *table)
-{
-	struct sfi_table_simple *sb;
-	struct sfi_rtc_table_entry *pentry;
-	struct mpc_intsrc mp_irq;
-
-	int totallen;
-
-	sb = (struct sfi_table_simple *)table;
-	if (!sfi_mrtc_num) {
-		sfi_mrtc_num = SFI_GET_NUM_ENTRIES(sb,
-						struct sfi_rtc_table_entry);
-		pentry = (struct sfi_rtc_table_entry *)sb->pentry;
-		totallen = sfi_mrtc_num * sizeof(*pentry);
-		memcpy(sfi_mrtc_array, pentry, totallen);
-	}
-
-	printk(KERN_INFO "SFI: RTC info (num = %d):\n", sfi_mrtc_num);
-	pentry = sfi_mrtc_array;
-	for (totallen = 0; totallen < sfi_mrtc_num; totallen++, pentry++) {
-		printk(KERN_INFO "RTC[%d]: paddr = 0x%08x, irq = %d\n",
-			totallen, (u32)pentry->phys_addr, pentry->irq);
-		mp_irq.type = MP_IOAPIC;
-		mp_irq.irqtype = mp_INT;
-		mp_irq.irqflag = 0;
-		mp_irq.srcbus = 0;
-		mp_irq.srcbusirq = pentry->irq;	/* IRQ */
-		mp_irq.dstapic = MP_APIC_ALL;
-		mp_irq.dstirq = pentry->irq;
-		mp_save_irq(&mp_irq);
-	}
-	return 0;
-}
-
 /*
  * the secondary clock in Moorestown can be APBT or LAPIC clock, default to
  * APBT but cmdline option can also override it.
@@ -174,11 +135,6 @@ void __init mrst_time_init(void)
 	apbt_time_init();
 }
 
-void __init mrst_rtc_init(void)
-{
-	sfi_table_parse(SFI_SIG_MRTC, NULL, NULL, sfi_parse_mrtc);
-}
-
 /*
  * if we use per cpu apb timer, the bootclock already setup. if we use lapic
  * timer and one apbt timer for broadcast, we need to set up lapic boot clock.
@@ -207,6 +163,7 @@ void __init x86_mrst_early_setup(void)
 	x86_cpuinit.setup_percpu_clockev = mrst_setup_secondary_clock;
 
 	x86_platform.calibrate_tsc = mrst_calibrate_tsc;
+
 	x86_init.pci.init = pci_mrst_init;
 	x86_init.pci.fixup_irqs = x86_init_noop;
 
diff --git a/arch/x86/kernel/vrtc.c b/arch/x86/kernel/vrtc.c
new file mode 100644
index 0000000..b113c67
--- /dev/null
+++ b/arch/x86/kernel/vrtc.c
@@ -0,0 +1,147 @@
+/*
+ * vrtc.c: Driver for virtual RTC device on Intel MID platform
+ *
+ * (C) Copyright 2010 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ *
+ * Note:
+ * VRTC is emulated by system controller firmware, the real HW
+ * RTC is located in the PMIC device. SCU FW shadows PMIC RTC
+ * in a memory mapped IO space that is visible to the host IA
+ * processor.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/sfi.h>
+
+#include <asm/time.h>
+#include <asm/vrtc.h>
+
+static unsigned char __iomem *vrtc_virt_base;
+struct sfi_rtc_table_entry sfi_mrtc_array[SFI_MRTC_MAX];
+EXPORT_SYMBOL_GPL(sfi_mrtc_array);
+static int sfi_mrtc_num;
+
+/* vRTC's registers range from 0x0 to 0xD */
+unsigned char vrtc_reg_read(unsigned char reg)
+{
+	if (unlikely(reg > 0xd || !vrtc_virt_base))
+		return 0xff;
+
+	return __raw_readb(vrtc_virt_base + (reg << 2));
+}
+EXPORT_SYMBOL(vrtc_reg_read);
+
+void vrtc_reg_write(unsigned char val, unsigned char reg)
+{
+	if (unlikely(reg > 0xd || !vrtc_virt_base))
+		return;
+
+	__raw_writeb(val, vrtc_virt_base + (reg << 2));
+}
+EXPORT_SYMBOL(vrtc_reg_write);
+
+static unsigned long vrtc_get_time(void)
+{
+	u8 sec, min, hour, mday, mon;
+	u32 year;
+
+	while ((vrtc_reg_read(RTC_FREQ_SELECT) & RTC_UIP))
+		cpu_relax();
+
+	sec = vrtc_reg_read(RTC_SECONDS);
+	min = vrtc_reg_read(RTC_MINUTES);
+	hour = vrtc_reg_read(RTC_HOURS);
+	mday = vrtc_reg_read(RTC_DAY_OF_MONTH);
+	mon = vrtc_reg_read(RTC_MONTH);
+	year = vrtc_reg_read(RTC_YEAR);
+
+	/* vRTC YEAR reg contains the offset to 1960 */
+	year += 1960;
+
+	pr_debug("vrtc time: %4d-%02d-%02d %02d:%02d:%02d\n",
+		year, mon, mday, hour, min, sec);
+
+	return mktime(year, mon, mday, hour, min, sec);
+}
+
+/* Only care about the minutes and seconds */
+static int vrtc_set_mmss(unsigned long nowtime)
+{
+	int real_sec, real_min;
+	int vrtc_min;
+
+	vrtc_min = vrtc_reg_read(RTC_MINUTES);
+
+	real_sec = nowtime % 60;
+	real_min = nowtime / 60;
+	if (((abs(real_min - vrtc_min) + 15)/30) & 1)
+		real_min += 30;
+	real_min %= 60;
+
+	vrtc_reg_write(real_sec, RTC_SECONDS);
+	vrtc_reg_write(real_min, RTC_MINUTES);
+	return 0;
+}
+
+/* parse all the mrtc info to a global mrtc array */
+static int __init sfi_parse_mrtc(struct sfi_table_header *table)
+{
+	struct sfi_table_simple *sb;
+	struct sfi_rtc_table_entry *pentry;
+	struct mpc_intsrc mp_irq;
+
+	int totallen;
+
+	sb = (struct sfi_table_simple *)table;
+	if (!sfi_mrtc_num) {
+		sfi_mrtc_num = SFI_GET_NUM_ENTRIES(sb,
+						struct sfi_rtc_table_entry);
+		pentry = (struct sfi_rtc_table_entry *)sb->pentry;
+		totallen = sfi_mrtc_num * sizeof(*pentry);
+		memcpy(sfi_mrtc_array, pentry, totallen);
+	}
+
+	pr_info("SFI: RTC info (num = %d):\n", sfi_mrtc_num);
+	pentry = sfi_mrtc_array;
+	for (totallen = 0; totallen < sfi_mrtc_num; totallen++, pentry++) {
+		pr_info("RTC[%d]: paddr = 0x%08x, irq = %d\n",
+			totallen, (u32)pentry->phys_addr, pentry->irq);
+		mp_irq.type = MP_IOAPIC;
+		mp_irq.irqtype = mp_INT;
+		mp_irq.irqflag = 0;
+		mp_irq.srcbus = 0;
+		mp_irq.srcbusirq = pentry->irq;
+		mp_irq.dstapic = MP_APIC_ALL;
+		mp_irq.dstirq = pentry->irq;
+		mp_save_irq(&mp_irq);
+	}
+	return 0;
+}
+
+static int __init vrtc_init(void)
+{
+	unsigned long rtc_paddr;
+
+	sfi_table_parse(SFI_SIG_MRTC, NULL, NULL, sfi_parse_mrtc);
+	if (!sfi_mrtc_num)
+		return -1;
+
+	rtc_paddr = sfi_mrtc_array[0].phys_addr;
+	vrtc_virt_base = ioremap(rtc_paddr, VRTC_IOLEN);
+	if (!vrtc_virt_base)
+		return -1;
+
+	x86_platform.get_wallclock = vrtc_get_time;
+	x86_platform.set_wallclock = vrtc_set_mmss;
+
+	pr_info("vrtc: successfully inited as a wall clock device.\n");
+	return 0;
+}
+arch_initcall(vrtc_init);
-- 
1.6.3.3
