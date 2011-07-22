Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab1GVOWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 10:22:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45414 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246Ab1GVOWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:22:24 -0400
Date: Fri, 22 Jul 2011 16:21:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timers/rtc changes for v3.1
Message-ID: <20110722142136.GA9699@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-rtc-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-rtc-for-linus

 Thanks,

	Ingo

------------------>
Jan Beulich (2):
      x86: Serialize SMP bootup CMOS accesses on rtc_lock
      x86: Serialize EFI time accesses on rtc_lock

Wolfram Sang (6):
      rtc: vt8500: Use define instead of hardcoded value for status bit
      rtc: stmp3xxx: Restore register definitions
      rtc: stmp3xxx: Port stmp-functions to mxs-equivalents
      rtc: stmp3xxx: Initialize drvdata before registering device
      rtc: stmp3xxx: Get rid of mach-specific accessors
      rtc: stmp3xxx: Remove UIE handlers


 arch/x86/include/asm/smpboot_hooks.h |    8 ++
 arch/x86/platform/efi/efi.c          |   39 +++++++--
 drivers/rtc/Kconfig                  |    6 +-
 drivers/rtc/rtc-stmp3xxx.c           |  153 +++++++++++++++++----------------
 drivers/rtc/rtc-vt8500.c             |    6 +-
 5 files changed, 127 insertions(+), 85 deletions(-)

diff --git a/arch/x86/include/asm/smpboot_hooks.h b/arch/x86/include/asm/smpboot_hooks.h
index 725b778..49adfd7 100644
--- a/arch/x86/include/asm/smpboot_hooks.h
+++ b/arch/x86/include/asm/smpboot_hooks.h
@@ -10,7 +10,11 @@ static inline void smpboot_clear_io_apic_irqs(void)
 
 static inline void smpboot_setup_warm_reset_vector(unsigned long start_eip)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&rtc_lock, flags);
 	CMOS_WRITE(0xa, 0xf);
+	spin_unlock_irqrestore(&rtc_lock, flags);
 	local_flush_tlb();
 	pr_debug("1.\n");
 	*((volatile unsigned short *)phys_to_virt(apic->trampoline_phys_high)) =
@@ -23,6 +27,8 @@ static inline void smpboot_setup_warm_reset_vector(unsigned long start_eip)
 
 static inline void smpboot_restore_warm_reset_vector(void)
 {
+	unsigned long flags;
+
 	/*
 	 * Install writable page 0 entry to set BIOS data area.
 	 */
@@ -32,7 +38,9 @@ static inline void smpboot_restore_warm_reset_vector(void)
 	 * Paranoid:  Set warm reset code and vector here back
 	 * to default values.
 	 */
+	spin_lock_irqsave(&rtc_lock, flags);
 	CMOS_WRITE(0, 0xf);
+	spin_unlock_irqrestore(&rtc_lock, flags);
 
 	*((volatile u32 *)phys_to_virt(apic->trampoline_phys_low)) = 0;
 }
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 474356b..b8823d5 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -79,26 +79,50 @@ early_param("add_efi_memmap", setup_add_efi_memmap);
 
 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 {
-	return efi_call_virt2(get_time, tm, tc);
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	status = efi_call_virt2(get_time, tm, tc);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return status;
 }
 
 static efi_status_t virt_efi_set_time(efi_time_t *tm)
 {
-	return efi_call_virt1(set_time, tm);
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	status = efi_call_virt1(set_time, tm);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return status;
 }
 
 static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
 					     efi_bool_t *pending,
 					     efi_time_t *tm)
 {
-	return efi_call_virt3(get_wakeup_time,
-			      enabled, pending, tm);
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	status = efi_call_virt3(get_wakeup_time,
+				enabled, pending, tm);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return status;
 }
 
 static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
 {
-	return efi_call_virt2(set_wakeup_time,
-			      enabled, tm);
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	status = efi_call_virt2(set_wakeup_time,
+				enabled, tm);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return status;
 }
 
 static efi_status_t virt_efi_get_variable(efi_char16_t *name,
@@ -164,11 +188,14 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
 static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
 					     efi_time_cap_t *tc)
 {
+	unsigned long flags;
 	efi_status_t status;
 
+	spin_lock_irqsave(&rtc_lock, flags);
 	efi_call_phys_prelog();
 	status = efi_call_phys2(efi_phys.get_time, tm, tc);
 	efi_call_phys_epilog();
+	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
 }
 
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index ce2aabf..dcb61e2 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -981,11 +981,11 @@ config RTC_DRV_COH901331
 
 
 config RTC_DRV_STMP
-	tristate "Freescale STMP3xxx RTC"
-	depends on ARCH_STMP3XXX
+	tristate "Freescale STMP3xxx/i.MX23/i.MX28 RTC"
+	depends on ARCH_MXS
 	help
 	  If you say yes here you will get support for the onboard
-	  STMP3xxx RTC.
+	  STMP3xxx/i.MX23/i.MX28 RTC.
 
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-stmp3xxx.
diff --git a/drivers/rtc/rtc-stmp3xxx.c b/drivers/rtc/rtc-stmp3xxx.c
index 572e953..7315068 100644
--- a/drivers/rtc/rtc-stmp3xxx.c
+++ b/drivers/rtc/rtc-stmp3xxx.c
@@ -6,6 +6,7 @@
  *
  * Copyright 2008 Freescale Semiconductor, Inc. All Rights Reserved.
  * Copyright 2008 Embedded Alley Solutions, Inc All Rights Reserved.
+ * Copyright 2011 Wolfram Sang, Pengutronix e.K.
  */
 
 /*
@@ -18,21 +19,41 @@
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/io.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/rtc.h>
 #include <linux/slab.h>
 
-#include <mach/platform.h>
-#include <mach/stmp3xxx.h>
-#include <mach/regs-rtc.h>
+#include <mach/common.h>
+
+#define STMP3XXX_RTC_CTRL			0x0
+#define STMP3XXX_RTC_CTRL_SET			0x4
+#define STMP3XXX_RTC_CTRL_CLR			0x8
+#define STMP3XXX_RTC_CTRL_ALARM_IRQ_EN		0x00000001
+#define STMP3XXX_RTC_CTRL_ONEMSEC_IRQ_EN	0x00000002
+#define STMP3XXX_RTC_CTRL_ALARM_IRQ		0x00000004
+
+#define STMP3XXX_RTC_STAT			0x10
+#define STMP3XXX_RTC_STAT_STALE_SHIFT		16
+#define STMP3XXX_RTC_STAT_RTC_PRESENT		0x80000000
+
+#define STMP3XXX_RTC_SECONDS			0x30
+
+#define STMP3XXX_RTC_ALARM			0x40
+
+#define STMP3XXX_RTC_PERSISTENT0		0x60
+#define STMP3XXX_RTC_PERSISTENT0_SET		0x64
+#define STMP3XXX_RTC_PERSISTENT0_CLR		0x68
+#define STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN	0x00000002
+#define STMP3XXX_RTC_PERSISTENT0_ALARM_EN	0x00000004
+#define STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE	0x00000080
 
 struct stmp3xxx_rtc_data {
 	struct rtc_device *rtc;
-	unsigned irq_count;
 	void __iomem *io;
-	int irq_alarm, irq_1msec;
+	int irq_alarm;
 };
 
 static void stmp3xxx_wait_time(struct stmp3xxx_rtc_data *rtc_data)
@@ -42,8 +63,8 @@ static void stmp3xxx_wait_time(struct stmp3xxx_rtc_data *rtc_data)
 	 * NEW_REGS/STALE_REGS bitfields go. In fact it's 0x1=P0,
 	 * 0x2=P1, .., 0x20=P5, 0x40=ALARM, 0x80=SECONDS
 	 */
-	while (__raw_readl(rtc_data->io + HW_RTC_STAT) &
-			BF(0x80, RTC_STAT_STALE_REGS))
+	while (readl(rtc_data->io + STMP3XXX_RTC_STAT) &
+			(0x80 << STMP3XXX_RTC_STAT_STALE_SHIFT))
 		cpu_relax();
 }
 
@@ -53,7 +74,7 @@ static int stmp3xxx_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
 
 	stmp3xxx_wait_time(rtc_data);
-	rtc_time_to_tm(__raw_readl(rtc_data->io + HW_RTC_SECONDS), rtc_tm);
+	rtc_time_to_tm(readl(rtc_data->io + STMP3XXX_RTC_SECONDS), rtc_tm);
 	return 0;
 }
 
@@ -61,7 +82,7 @@ static int stmp3xxx_rtc_set_mmss(struct device *dev, unsigned long t)
 {
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
 
-	__raw_writel(t, rtc_data->io + HW_RTC_SECONDS);
+	writel(t, rtc_data->io + STMP3XXX_RTC_SECONDS);
 	stmp3xxx_wait_time(rtc_data);
 	return 0;
 }
@@ -70,47 +91,34 @@ static int stmp3xxx_rtc_set_mmss(struct device *dev, unsigned long t)
 static irqreturn_t stmp3xxx_rtc_interrupt(int irq, void *dev_id)
 {
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev_id);
-	u32 status;
-	u32 events = 0;
-
-	status = __raw_readl(rtc_data->io + HW_RTC_CTRL) &
-			(BM_RTC_CTRL_ALARM_IRQ | BM_RTC_CTRL_ONEMSEC_IRQ);
+	u32 status = readl(rtc_data->io + STMP3XXX_RTC_CTRL);
 
-	if (status & BM_RTC_CTRL_ALARM_IRQ) {
-		stmp3xxx_clearl(BM_RTC_CTRL_ALARM_IRQ,
-				rtc_data->io + HW_RTC_CTRL);
-		events |= RTC_AF | RTC_IRQF;
+	if (status & STMP3XXX_RTC_CTRL_ALARM_IRQ) {
+		writel(STMP3XXX_RTC_CTRL_ALARM_IRQ,
+				rtc_data->io + STMP3XXX_RTC_CTRL_CLR);
+		rtc_update_irq(rtc_data->rtc, 1, RTC_AF | RTC_IRQF);
+		return IRQ_HANDLED;
 	}
 
-	if (status & BM_RTC_CTRL_ONEMSEC_IRQ) {
-		stmp3xxx_clearl(BM_RTC_CTRL_ONEMSEC_IRQ,
-				rtc_data->io + HW_RTC_CTRL);
-		if (++rtc_data->irq_count % 1000 == 0) {
-			events |= RTC_UF | RTC_IRQF;
-			rtc_data->irq_count = 0;
-		}
-	}
-
-	if (events)
-		rtc_update_irq(rtc_data->rtc, 1, events);
-
-	return IRQ_HANDLED;
+	return IRQ_NONE;
 }
 
 static int stmp3xxx_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
-	void __iomem *p = rtc_data->io + HW_RTC_PERSISTENT0,
-		     *ctl = rtc_data->io + HW_RTC_CTRL;
 
 	if (enabled) {
-		stmp3xxx_setl(BM_RTC_PERSISTENT0_ALARM_EN |
-			      BM_RTC_PERSISTENT0_ALARM_WAKE_EN, p);
-		stmp3xxx_setl(BM_RTC_CTRL_ALARM_IRQ_EN, ctl);
+		writel(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
+				STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN,
+				rtc_data->io + STMP3XXX_RTC_PERSISTENT0_SET);
+		writel(STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
+				rtc_data->io + STMP3XXX_RTC_CTRL_SET);
 	} else {
-		stmp3xxx_clearl(BM_RTC_PERSISTENT0_ALARM_EN |
-			      BM_RTC_PERSISTENT0_ALARM_WAKE_EN, p);
-		stmp3xxx_clearl(BM_RTC_CTRL_ALARM_IRQ_EN, ctl);
+		writel(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
+				STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN,
+				rtc_data->io + STMP3XXX_RTC_PERSISTENT0_CLR);
+		writel(STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
+				rtc_data->io + STMP3XXX_RTC_CTRL_CLR);
 	}
 	return 0;
 }
@@ -119,7 +127,7 @@ static int stmp3xxx_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
 
-	rtc_time_to_tm(__raw_readl(rtc_data->io + HW_RTC_ALARM), &alm->time);
+	rtc_time_to_tm(readl(rtc_data->io + STMP3XXX_RTC_ALARM), &alm->time);
 	return 0;
 }
 
@@ -129,7 +137,10 @@ static int stmp3xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
 
 	rtc_tm_to_time(&alm->time, &t);
-	__raw_writel(t, rtc_data->io + HW_RTC_ALARM);
+	writel(t, rtc_data->io + STMP3XXX_RTC_ALARM);
+
+	stmp3xxx_alarm_irq_enable(dev, alm->enabled);
+
 	return 0;
 }
 
@@ -149,11 +160,11 @@ static int stmp3xxx_rtc_remove(struct platform_device *pdev)
 	if (!rtc_data)
 		return 0;
 
-	stmp3xxx_clearl(BM_RTC_CTRL_ONEMSEC_IRQ_EN | BM_RTC_CTRL_ALARM_IRQ_EN,
-			rtc_data->io + HW_RTC_CTRL);
+	writel(STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
+			rtc_data->io + STMP3XXX_RTC_CTRL_CLR);
 	free_irq(rtc_data->irq_alarm, &pdev->dev);
-	free_irq(rtc_data->irq_1msec, &pdev->dev);
 	rtc_device_unregister(rtc_data->rtc);
+	platform_set_drvdata(pdev, NULL);
 	iounmap(rtc_data->io);
 	kfree(rtc_data);
 
@@ -185,20 +196,26 @@ static int stmp3xxx_rtc_probe(struct platform_device *pdev)
 	}
 
 	rtc_data->irq_alarm = platform_get_irq(pdev, 0);
-	rtc_data->irq_1msec = platform_get_irq(pdev, 1);
 
-	if (!(__raw_readl(HW_RTC_STAT + rtc_data->io) &
-			BM_RTC_STAT_RTC_PRESENT)) {
+	if (!(readl(STMP3XXX_RTC_STAT + rtc_data->io) &
+			STMP3XXX_RTC_STAT_RTC_PRESENT)) {
 		dev_err(&pdev->dev, "no device onboard\n");
 		err = -ENODEV;
 		goto out_remap;
 	}
 
-	stmp3xxx_reset_block(rtc_data->io, true);
-	stmp3xxx_clearl(BM_RTC_PERSISTENT0_ALARM_EN |
-			BM_RTC_PERSISTENT0_ALARM_WAKE_EN |
-			BM_RTC_PERSISTENT0_ALARM_WAKE,
-			rtc_data->io + HW_RTC_PERSISTENT0);
+	platform_set_drvdata(pdev, rtc_data);
+
+	mxs_reset_block(rtc_data->io);
+	writel(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
+			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN |
+			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE,
+			rtc_data->io + STMP3XXX_RTC_PERSISTENT0_CLR);
+
+	writel(STMP3XXX_RTC_CTRL_ONEMSEC_IRQ_EN |
+			STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
+			rtc_data->io + STMP3XXX_RTC_CTRL_CLR);
+
 	rtc_data->rtc = rtc_device_register(pdev->name, &pdev->dev,
 				&stmp3xxx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc_data->rtc)) {
@@ -206,33 +223,20 @@ static int stmp3xxx_rtc_probe(struct platform_device *pdev)
 		goto out_remap;
 	}
 
-	rtc_data->irq_count = 0;
-	err = request_irq(rtc_data->irq_alarm, stmp3xxx_rtc_interrupt,
-			IRQF_DISABLED, "RTC alarm", &pdev->dev);
+	err = request_irq(rtc_data->irq_alarm, stmp3xxx_rtc_interrupt, 0,
+			"RTC alarm", &pdev->dev);
 	if (err) {
 		dev_err(&pdev->dev, "Cannot claim IRQ%d\n",
 			rtc_data->irq_alarm);
 		goto out_irq_alarm;
 	}
-	err = request_irq(rtc_data->irq_1msec, stmp3xxx_rtc_interrupt,
-			IRQF_DISABLED, "RTC tick", &pdev->dev);
-	if (err) {
-		dev_err(&pdev->dev, "Cannot claim IRQ%d\n",
-			rtc_data->irq_1msec);
-		goto out_irq1;
-	}
-
-	platform_set_drvdata(pdev, rtc_data);
 
 	return 0;
 
-out_irq1:
-	free_irq(rtc_data->irq_alarm, &pdev->dev);
 out_irq_alarm:
-	stmp3xxx_clearl(BM_RTC_CTRL_ONEMSEC_IRQ_EN | BM_RTC_CTRL_ALARM_IRQ_EN,
-			rtc_data->io + HW_RTC_CTRL);
 	rtc_device_unregister(rtc_data->rtc);
 out_remap:
+	platform_set_drvdata(pdev, NULL);
 	iounmap(rtc_data->io);
 out_free:
 	kfree(rtc_data);
@@ -249,11 +253,11 @@ static int stmp3xxx_rtc_resume(struct platform_device *dev)
 {
 	struct stmp3xxx_rtc_data *rtc_data = platform_get_drvdata(dev);
 
-	stmp3xxx_reset_block(rtc_data->io, true);
-	stmp3xxx_clearl(BM_RTC_PERSISTENT0_ALARM_EN |
-			BM_RTC_PERSISTENT0_ALARM_WAKE_EN |
-			BM_RTC_PERSISTENT0_ALARM_WAKE,
-			rtc_data->io + HW_RTC_PERSISTENT0);
+	mxs_reset_block(rtc_data->io);
+	writel(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
+			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN |
+			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE,
+			rtc_data->io + STMP3XXX_RTC_PERSISTENT0_CLR);
 	return 0;
 }
 #else
@@ -286,5 +290,6 @@ module_init(stmp3xxx_rtc_init);
 module_exit(stmp3xxx_rtc_exit);
 
 MODULE_DESCRIPTION("STMP3xxx RTC Driver");
-MODULE_AUTHOR("dmitry pervushin <dpervushin@embeddedalley.com>");
+MODULE_AUTHOR("dmitry pervushin <dpervushin@embeddedalley.com> and "
+		"Wolfram Sang <w.sang@pengutronix.de>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/rtc/rtc-vt8500.c b/drivers/rtc/rtc-vt8500.c
index efd6066..f93f412 100644
--- a/drivers/rtc/rtc-vt8500.c
+++ b/drivers/rtc/rtc-vt8500.c
@@ -74,6 +74,8 @@
 #define VT8500_RTC_CR_SM_SEC	(1 << 3)	/* 0: 1Hz/60, 1: 1Hz */
 #define VT8500_RTC_CR_CALIB	(1 << 4)	/* Enable calibration */
 
+#define VT8500_RTC_IS_ALARM	(1 << 0)	/* Alarm interrupt status */
+
 struct vt8500_rtc {
 	void __iomem		*regbase;
 	struct resource		*res;
@@ -96,7 +98,7 @@ static irqreturn_t vt8500_rtc_irq(int irq, void *dev_id)
 
 	spin_unlock(&vt8500_rtc->lock);
 
-	if (isr & 1)
+	if (isr & VT8500_RTC_IS_ALARM)
 		events |= RTC_AF | RTC_IRQF;
 
 	rtc_update_irq(vt8500_rtc->rtc, 1, events);
@@ -161,8 +163,8 @@ static int vt8500_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	alrm->time.tm_sec = bcd2bin((alarm & TIME_SEC_MASK));
 
 	alrm->enabled = (alarm & ALARM_ENABLE_MASK) ? 1 : 0;
+	alrm->pending = (isr & VT8500_RTC_IS_ALARM) ? 1 : 0;
 
-	alrm->pending = (isr & 1) ? 1 : 0;
 	return rtc_valid_tm(&alrm->time);
 }
 
