Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab0EGRrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 13:47:51 -0400
Received: from mga10.intel.com ([192.55.52.92]:58130 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757387Ab0EGRrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 13:47:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,349,1270450800"; 
   d="scan'208";a="796418415"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alek Du <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Feng Tang <feng.tang@intel.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 7/8] x86/mrst: add vrtc driver which serves as a wall clock device
Date: Fri,  7 May 2010 10:41:47 -0700
Message-Id: <1273254108-3234-8-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Moorestown platform doesn't have a m146818 RTC device like traditional
x86 PC, but a firmware emulated virtual RTC device(vrtc), which provides
some basic RTC functions like get/set time. vrtc serves as the only
wall clock device on Moorestown platform.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/fixmap.h |    4 ++
 arch/x86/include/asm/vrtc.h   |   27 +++++++++++
 arch/x86/kernel/Makefile      |    2 +-
 arch/x86/kernel/mrst.c        |   20 ++++++++
 arch/x86/kernel/vrtc.c        |  100 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 152 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/include/asm/vrtc.h
 create mode 100644 arch/x86/kernel/vrtc.c

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index d07b44f..c4ba8d9 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -117,6 +117,10 @@ enum fixed_addresses {
 	FIX_TEXT_POKE1,	/* reserve 2 pages for text_poke() */
 	FIX_TEXT_POKE0, /* first page is last, because allocation is backward */
 	__end_of_permanent_fixed_addresses,
+
+#ifdef	CONFIG_X86_MRST
+	FIX_LNW_VRTC,
+#endif
 	/*
 	 * 256 temporary boot-time mappings, used by early_ioremap(),
 	 * before ioremap() is functional.
diff --git a/arch/x86/include/asm/vrtc.h b/arch/x86/include/asm/vrtc.h
new file mode 100644
index 0000000..4e40129
--- /dev/null
+++ b/arch/x86/include/asm/vrtc.h
@@ -0,0 +1,27 @@
+#ifndef _MRST_VRTC_H
+#define _MRST_VRTC_H
+
+#ifdef CONFIG_X86_MRST
+extern unsigned char vrtc_cmos_read(unsigned char reg);
+extern void vrtc_cmos_write(unsigned char val, unsigned char reg);
+extern unsigned long vrtc_get_time(void);
+extern int vrtc_set_mmss(unsigned long nowtime);
+extern void vrtc_set_base(void __iomem *base);
+
+#define MRST_VRTC_PGOFFSET  (0xc00)
+
+#else
+static inline unsigned char vrtc_cmos_read(unsigned char reg)
+{
+	return 0xff;
+}
+
+static inline void vrtc_cmos_write(unsigned char val, unsigned char reg)
+{
+	return;
+}
+#endif
+
+#define MRST_VRTC_MAP_SZ	(1024)
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
index 9e14e7f..0b3ef9f 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -24,6 +24,7 @@
 #include <asm/io.h>
 #include <asm/i8259.h>
 #include <asm/apb_timer.h>
+#include <asm/vrtc.h>
 
 /**
  * the clockevent devices on Moorestown/Medfield can be APBT or LAPIC clock,
@@ -268,7 +269,24 @@ void __init mrst_time_init(void)
 
 void __init mrst_rtc_init(void)
 {
+	unsigned long rtc_paddr;
+	void __iomem *virt_base;
+
 	sfi_table_parse(SFI_SIG_MRTC, NULL, NULL, sfi_parse_mrtc);
+	if (!sfi_mrtc_num)
+		return;
+
+	rtc_paddr = sfi_mrtc_array[0].phys_addr;
+
+	/* vRTC's register address may not be page aligned */
+	set_fixmap_nocache(FIX_LNW_VRTC, rtc_paddr);
+
+	virt_base = (void __iomem *)__fix_to_virt(FIX_LNW_VRTC);
+	virt_base += rtc_paddr & ~PAGE_MASK;
+	vrtc_set_base(virt_base);
+
+	x86_platform.get_wallclock = vrtc_get_time;
+	x86_platform.set_wallclock = vrtc_set_mmss;
 }
 
 /*
@@ -326,6 +344,8 @@ void __init x86_mrst_early_setup(void)
 	x86_cpuinit.setup_percpu_clockev = mrst_setup_secondary_clock;
 
 	x86_platform.calibrate_tsc = mrst_calibrate_tsc;
+	x86_platform.wallclock_init = mrst_rtc_init;
+
 	x86_init.pci.init = pci_mrst_init;
 	x86_init.pci.fixup_irqs = x86_init_noop;
 
diff --git a/arch/x86/kernel/vrtc.c b/arch/x86/kernel/vrtc.c
new file mode 100644
index 0000000..fa1eb63
--- /dev/null
+++ b/arch/x86/kernel/vrtc.c
@@ -0,0 +1,100 @@
+/*
+ * vrtc.c: Driver for virtual RTC device on Intel MID platform
+ *
+ * (C) Copyright 2009 Intel Corporation
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
+ * This driver is based on RTC CMOS driver.
+ */
+
+#include <linux/kernel.h>
+
+#include <asm/vrtc.h>
+#include <asm/time.h>
+#include <asm/fixmap.h>
+
+static unsigned char __iomem *vrtc_virt_base;
+
+void vrtc_set_base(void __iomem *base)
+{
+	vrtc_virt_base = base;
+}
+
+unsigned char vrtc_cmos_read(unsigned char reg)
+{
+	unsigned char retval;
+
+	/* vRTC's registers range from 0x0 to 0xD */
+	if (reg > 0xd || !vrtc_virt_base)
+		return 0xff;
+
+	lock_cmos_prefix(reg);
+	retval = __raw_readb(vrtc_virt_base + (reg << 2));
+	lock_cmos_suffix(reg);
+	return retval;
+}
+EXPORT_SYMBOL(vrtc_cmos_read);
+
+void vrtc_cmos_write(unsigned char val, unsigned char reg)
+{
+	if (reg > 0xd || !vrtc_virt_base)
+		return;
+
+	lock_cmos_prefix(reg);
+	__raw_writeb(val, vrtc_virt_base + (reg << 2));
+	lock_cmos_suffix(reg);
+}
+EXPORT_SYMBOL(vrtc_cmos_write);
+
+unsigned long vrtc_get_time(void)
+{
+	u8 sec, min, hour, mday, mon;
+	u32 year;
+
+	while ((vrtc_cmos_read(RTC_FREQ_SELECT) & RTC_UIP))
+		cpu_relax();
+
+	sec = vrtc_cmos_read(RTC_SECONDS);
+	min = vrtc_cmos_read(RTC_MINUTES);
+	hour = vrtc_cmos_read(RTC_HOURS);
+	mday = vrtc_cmos_read(RTC_DAY_OF_MONTH);
+	mon = vrtc_cmos_read(RTC_MONTH);
+	year = vrtc_cmos_read(RTC_YEAR);
+
+	/* vRTC YEAR reg contains the offset to 1960 */
+	year += 1960;
+
+	printk(KERN_INFO "vRTC: sec: %d min: %d hour: %d day: %d "
+		"mon: %d year: %d\n", sec, min, hour, mday, mon, year);
+
+	return mktime(year, mon, mday, hour, min, sec);
+}
+
+/* Only care about the minutes and seconds */
+int vrtc_set_mmss(unsigned long nowtime)
+{
+	int real_sec, real_min;
+	int vrtc_min;
+
+	vrtc_min = vrtc_cmos_read(RTC_MINUTES);
+
+	real_sec = nowtime % 60;
+	real_min = nowtime / 60;
+	if (((abs(real_min - vrtc_min) + 15)/30) & 1)
+		real_min += 30;
+	real_min %= 60;
+
+	vrtc_cmos_write(real_sec, RTC_SECONDS);
+	vrtc_cmos_write(real_min, RTC_MINUTES);
+	return 0;
+}
-- 
1.6.3.3

