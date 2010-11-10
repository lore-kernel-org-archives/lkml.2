Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab0KJRt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:49:28 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42973 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab0KJRt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:49:26 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] UPDATED x86/mrst: add vrtc driver which serves as a wall
	clock device
To: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 10 Nov 2010 17:29:00 +0000
Message-ID: <20101110172837.3311.40483.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please discard original pair of rtc patches)

From: Feng Tang <feng.tang@intel.com>

Moorestown platform doesn't have a m146818 RTC device like traditional
x86 PC, but a firmware emulated virtual RTC device(vrtc), which provides
some basic RTC functions like get/set time. vrtc serves as the only
wall clock device on Moorestown platform.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/include/asm/fixmap.h    |    4 +
 arch/x86/include/asm/mrst-vrtc.h |    9 +++
 arch/x86/include/asm/mrst.h      |   10 +++
 arch/x86/platform/mrst/Makefile  |    1 
 arch/x86/platform/mrst/mrst.c    |    6 --
 arch/x86/platform/mrst/vrtc.c    |  120 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 143 insertions(+), 7 deletions(-)
 create mode 100644 arch/x86/include/asm/mrst-vrtc.h
 create mode 100644 arch/x86/platform/mrst/vrtc.c


diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 4d293dc..139591a 100644
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
diff --git a/arch/x86/include/asm/mrst-vrtc.h b/arch/x86/include/asm/mrst-vrtc.h
new file mode 100644
index 0000000..73668ab
--- /dev/null
+++ b/arch/x86/include/asm/mrst-vrtc.h
@@ -0,0 +1,9 @@
+#ifndef _MRST_VRTC_H
+#define _MRST_VRTC_H
+
+extern unsigned char vrtc_cmos_read(unsigned char reg);
+extern void vrtc_cmos_write(unsigned char val, unsigned char reg);
+extern unsigned long vrtc_get_time(void);
+extern int vrtc_set_mmss(unsigned long nowtime);
+
+#endif
diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index 283debd..719f00b 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -14,7 +14,9 @@
 #include <linux/sfi.h>
 
 extern int pci_mrst_init(void);
-int __init sfi_parse_mrtc(struct sfi_table_header *table);
+extern int __init sfi_parse_mrtc(struct sfi_table_header *table);
+extern int sfi_mrtc_num;
+extern struct sfi_rtc_table_entry sfi_mrtc_array[];
 
 /*
  * Medfield is the follow-up of Moorestown, it combines two chip solution into
@@ -54,4 +56,10 @@ extern void hsu_early_console_init(void);
 extern void intel_scu_devices_create(void);
 extern void intel_scu_devices_destroy(void);
 
+/* VRTC timer */
+#define MRST_VRTC_MAP_SZ	(1024)
+/*#define MRST_VRTC_PGOFFSET	(0xc00) */
+
+extern void mrst_rtc_init(void);
+
 #endif /* _ASM_X86_MRST_H */
diff --git a/arch/x86/platform/mrst/Makefile b/arch/x86/platform/mrst/Makefile
index efbbc55..4d3e256 100644
--- a/arch/x86/platform/mrst/Makefile
+++ b/arch/x86/platform/mrst/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_X86_MRST)		+= mrst.o
+obj-$(CONFIG_X86_MRST)		+= vrtc.o
diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index 10fec10..a3fe2fd 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -37,7 +37,6 @@
 #include <asm/apb_timer.h>
 #include <asm/reboot.h>
 
-
 /*
  * the clockevent devices on Moorestown/Medfield can be APBT or LAPIC clock,
  * cmdline option x86_mrst_timer can be used to override the configuration
@@ -242,11 +241,6 @@ void __init mrst_time_init(void)
 	apbt_time_init();
 }
 
-void __init mrst_rtc_init(void)
-{
-	sfi_table_parse(SFI_SIG_MRTC, NULL, NULL, sfi_parse_mrtc);
-}
-
 void __cpuinit mrst_arch_setup(void)
 {
 	if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 0x27)
diff --git a/arch/x86/platform/mrst/vrtc.c b/arch/x86/platform/mrst/vrtc.c
new file mode 100644
index 0000000..00c564d
--- /dev/null
+++ b/arch/x86/platform/mrst/vrtc.c
@@ -0,0 +1,120 @@
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
+#include <linux/init.h>
+#include <linux/sfi.h>
+
+#include <asm/mrst.h>
+#include <asm/mrst-vrtc.h>
+#include <asm/time.h>
+#include <asm/fixmap.h>
+
+static unsigned char __iomem *vrtc_virt_base;
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
+
+void __init mrst_rtc_init(void)
+{
+	unsigned long rtc_paddr;
+	void __iomem *virt_base;
+
+	sfi_table_parse(SFI_SIG_MRTC, NULL, NULL, sfi_parse_mrtc);
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
+	vrtc_virt_base = virt_base;
+
+	x86_platform.get_wallclock = vrtc_get_time;
+	x86_platform.set_wallclock = vrtc_set_mmss;
+}

