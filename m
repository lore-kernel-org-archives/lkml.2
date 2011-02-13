Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab1BMGjg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 01:39:36 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:56118 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab1BMGj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 01:39:29 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
Subject: [PATCHv2 09/11] unicore32 core architecture: timer and time handling
Date: Sun, 13 Feb 2011 14:39:20 +0800
Message-ID: <02f301cbcb48$bebea4c0$3c3bee40$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvLSLmocEtq8LBZSMapRTyHqpGHag==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements timer and time.
RTC and PWM device drivers are also here.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/timex.h |   34 ++++
 arch/unicore32/kernel/pwm.c        |  263 +++++++++++++++++++++++++
 arch/unicore32/kernel/rtc.c        |  380 ++++++++++++++++++++++++++++++++++++
 arch/unicore32/kernel/time.c       |  148 ++++++++++++++
 4 files changed, 825 insertions(+), 0 deletions(-)
 create mode 100644 arch/unicore32/include/asm/timex.h
 create mode 100644 arch/unicore32/kernel/pwm.c
 create mode 100644 arch/unicore32/kernel/rtc.c
 create mode 100644 arch/unicore32/kernel/time.c

diff --git a/arch/unicore32/include/asm/timex.h b/arch/unicore32/include/asm/timex.h
new file mode 100644
index 0000000..faf16ba
--- /dev/null
+++ b/arch/unicore32/include/asm/timex.h
@@ -0,0 +1,34 @@
+/*
+ * linux/arch/unicore32/include/asm/timex.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __UNICORE_TIMEX_H__
+#define __UNICORE_TIMEX_H__
+
+#ifdef	CONFIG_ARCH_FPGA
+
+/* in FPGA, APB clock is 33M, and OST clock is 32K, */
+/* so, 1M is selected for timer interrupt correctly */
+#define	CLOCK_TICK_RATE		(32*1024)
+
+#endif
+
+#if defined(CONFIG_PUV3_DB0913)		\
+	|| defined(CONFIG_PUV3_NB0916)	\
+	|| defined(CONFIG_PUV3_SMW0919)
+
+#define  CLOCK_TICK_RATE         (14318000)
+
+#endif
+
+#include <asm-generic/timex.h>
+
+#endif
diff --git a/arch/unicore32/kernel/pwm.c b/arch/unicore32/kernel/pwm.c
new file mode 100644
index 0000000..4615d51
--- /dev/null
+++ b/arch/unicore32/kernel/pwm.c
@@ -0,0 +1,263 @@
+/*
+ * linux/arch/unicore32/kernel/pwm.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/pwm.h>
+
+#include <asm/div64.h>
+#include <mach/hardware.h>
+
+struct pwm_device {
+	struct list_head	node;
+	struct platform_device *pdev;
+
+	const char	*label;
+	struct clk	*clk;
+	int		clk_enabled;
+
+	unsigned int	use_count;
+	unsigned int	pwm_id;
+};
+
+/*
+ * period_ns = 10^9 * (PRESCALE + 1) * (PV + 1) / PWM_CLK_RATE
+ * duty_ns   = 10^9 * (PRESCALE + 1) * DC / PWM_CLK_RATE
+ */
+int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
+{
+	unsigned long long c;
+	unsigned long period_cycles, prescale, pv, dc;
+
+	if (pwm == NULL || period_ns == 0 || duty_ns > period_ns)
+		return -EINVAL;
+
+	c = clk_get_rate(pwm->clk);
+	c = c * period_ns;
+	do_div(c, 1000000000);
+	period_cycles = c;
+
+	if (period_cycles < 1)
+		period_cycles = 1;
+	prescale = (period_cycles - 1) / 1024;
+	pv = period_cycles / (prescale + 1) - 1;
+
+	if (prescale > 63)
+		return -EINVAL;
+
+	if (duty_ns == period_ns)
+		dc = OST_PWMDCCR_FDCYCLE;
+	else
+		dc = (pv + 1) * duty_ns / period_ns;
+
+	/* NOTE: the clock to PWM has to be enabled first
+	 * before writing to the registers
+	 */
+	clk_enable(pwm->clk);
+	OST_PWMPWCR = prescale;
+	OST_PWMDCCR = pv - dc;
+	OST_PWMPCR  = pv;
+	clk_disable(pwm->clk);
+
+	return 0;
+}
+EXPORT_SYMBOL(pwm_config);
+
+int pwm_enable(struct pwm_device *pwm)
+{
+	int rc = 0;
+
+	if (!pwm->clk_enabled) {
+		rc = clk_enable(pwm->clk);
+		if (!rc)
+			pwm->clk_enabled = 1;
+	}
+	return rc;
+}
+EXPORT_SYMBOL(pwm_enable);
+
+void pwm_disable(struct pwm_device *pwm)
+{
+	if (pwm->clk_enabled) {
+		clk_disable(pwm->clk);
+		pwm->clk_enabled = 0;
+	}
+}
+EXPORT_SYMBOL(pwm_disable);
+
+static DEFINE_MUTEX(pwm_lock);
+static LIST_HEAD(pwm_list);
+
+struct pwm_device *pwm_request(int pwm_id, const char *label)
+{
+	struct pwm_device *pwm;
+	int found = 0;
+
+	mutex_lock(&pwm_lock);
+
+	list_for_each_entry(pwm, &pwm_list, node) {
+		if (pwm->pwm_id == pwm_id) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (found) {
+		if (pwm->use_count == 0) {
+			pwm->use_count++;
+			pwm->label = label;
+		} else
+			pwm = ERR_PTR(-EBUSY);
+	} else
+		pwm = ERR_PTR(-ENOENT);
+
+	mutex_unlock(&pwm_lock);
+	return pwm;
+}
+EXPORT_SYMBOL(pwm_request);
+
+void pwm_free(struct pwm_device *pwm)
+{
+	mutex_lock(&pwm_lock);
+
+	if (pwm->use_count) {
+		pwm->use_count--;
+		pwm->label = NULL;
+	} else
+		pr_warning("PWM device already freed\n");
+
+	mutex_unlock(&pwm_lock);
+}
+EXPORT_SYMBOL(pwm_free);
+
+static inline void __add_pwm(struct pwm_device *pwm)
+{
+	mutex_lock(&pwm_lock);
+	list_add_tail(&pwm->node, &pwm_list);
+	mutex_unlock(&pwm_lock);
+}
+
+static struct pwm_device *pwm_probe(struct platform_device *pdev,
+		unsigned int pwm_id, struct pwm_device *parent_pwm)
+{
+	struct pwm_device *pwm;
+	struct resource *r;
+	int ret = 0;
+
+	pwm = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
+	if (pwm == NULL) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	pwm->clk = clk_get(NULL, "OST_CLK");
+	if (IS_ERR(pwm->clk)) {
+		ret = PTR_ERR(pwm->clk);
+		goto err_free;
+	}
+	pwm->clk_enabled = 0;
+
+	pwm->use_count = 0;
+	pwm->pwm_id = pwm_id;
+	pwm->pdev = pdev;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (r == NULL) {
+		dev_err(&pdev->dev, "no memory resource defined\n");
+		ret = -ENODEV;
+		goto err_free_clk;
+	}
+
+	r = request_mem_region(r->start, resource_size(r), pdev->name);
+	if (r == NULL) {
+		dev_err(&pdev->dev, "failed to request memory resource\n");
+		ret = -EBUSY;
+		goto err_free_clk;
+	}
+
+	__add_pwm(pwm);
+	platform_set_drvdata(pdev, pwm);
+	return pwm;
+
+err_free_clk:
+	clk_put(pwm->clk);
+err_free:
+	kfree(pwm);
+	return ERR_PTR(ret);
+}
+
+static int __devinit puv3_pwm_probe(struct platform_device *pdev)
+{
+	struct pwm_device *pwm = pwm_probe(pdev, pdev->id, NULL);
+
+	if (IS_ERR(pwm))
+		return PTR_ERR(pwm);
+
+	return 0;
+}
+
+static int __devexit pwm_remove(struct platform_device *pdev)
+{
+	struct pwm_device *pwm;
+	struct resource *r;
+
+	pwm = platform_get_drvdata(pdev);
+	if (pwm == NULL)
+		return -ENODEV;
+
+	mutex_lock(&pwm_lock);
+	list_del(&pwm->node);
+	mutex_unlock(&pwm_lock);
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	release_mem_region(r->start, resource_size(r));
+
+	clk_put(pwm->clk);
+	kfree(pwm);
+	return 0;
+}
+
+static struct platform_driver puv3_pwm_driver = {
+	.driver		= {
+		.name	= "PKUnity-v3-PWM",
+	},
+	.probe		= puv3_pwm_probe,
+	.remove		= __devexit_p(pwm_remove),
+};
+
+static int __init pwm_init(void)
+{
+	int ret = 0;
+
+	ret = platform_driver_register(&puv3_pwm_driver);
+	if (ret) {
+		printk(KERN_ERR "failed to register puv3_pwm_driver\n");
+		return ret;
+	}
+
+	return ret;
+}
+arch_initcall(pwm_init);
+
+static void __exit pwm_exit(void)
+{
+	platform_driver_unregister(&puv3_pwm_driver);
+}
+module_exit(pwm_exit);
+
+MODULE_LICENSE("GPL v2");
diff --git a/arch/unicore32/kernel/rtc.c b/arch/unicore32/kernel/rtc.c
new file mode 100644
index 0000000..5e4db41
--- /dev/null
+++ b/arch/unicore32/kernel/rtc.c
@@ -0,0 +1,380 @@
+/*
+ * linux/arch/unicore32/kernel/rtc.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/rtc.h>
+#include <linux/bcd.h>
+#include <linux/clk.h>
+#include <linux/log2.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+
+#include <asm/irq.h>
+#include <mach/hardware.h>
+
+static struct resource *puv3_rtc_mem;
+
+static int puv3_rtc_alarmno = IRQ_RTCAlarm;
+static int puv3_rtc_tickno  = IRQ_RTC;
+
+static DEFINE_SPINLOCK(puv3_rtc_pie_lock);
+
+/* IRQ Handlers */
+
+static irqreturn_t puv3_rtc_alarmirq(int irq, void *id)
+{
+	struct rtc_device *rdev = id;
+
+	RTC_RTSR |= RTC_RTSR_AL;
+	rtc_update_irq(rdev, 1, RTC_AF | RTC_IRQF);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t puv3_rtc_tickirq(int irq, void *id)
+{
+	struct rtc_device *rdev = id;
+
+	RTC_RTSR |= RTC_RTSR_HZ;
+	rtc_update_irq(rdev, 1, RTC_PF | RTC_IRQF);
+	return IRQ_HANDLED;
+}
+
+/* Update control registers */
+static void puv3_rtc_setaie(int to)
+{
+	unsigned int tmp;
+
+	pr_debug("%s: aie=%d\n", __func__, to);
+
+	tmp = RTC_RTSR & ~RTC_RTSR_ALE;
+
+	if (to)
+		tmp |= RTC_RTSR_ALE;
+
+	RTC_RTSR = tmp;
+}
+
+static int puv3_rtc_setpie(struct device *dev, int enabled)
+{
+	unsigned int tmp;
+
+	pr_debug("%s: pie=%d\n", __func__, enabled);
+
+	spin_lock_irq(&puv3_rtc_pie_lock);
+	tmp = RTC_RTSR & ~RTC_RTSR_HZE;
+
+	if (enabled)
+		tmp |= RTC_RTSR_HZE;
+
+	RTC_RTSR = tmp;
+	spin_unlock_irq(&puv3_rtc_pie_lock);
+
+	return 0;
+}
+
+static int puv3_rtc_setfreq(struct device *dev, int freq)
+{
+	return 0;
+}
+
+/* Time read/write */
+
+static int puv3_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
+{
+	rtc_time_to_tm(RTC_RCNR, rtc_tm);
+
+	pr_debug("read time %02x.%02x.%02x %02x/%02x/%02x\n",
+		 rtc_tm->tm_year, rtc_tm->tm_mon, rtc_tm->tm_mday,
+		 rtc_tm->tm_hour, rtc_tm->tm_min, rtc_tm->tm_sec);
+
+	return 0;
+}
+
+static int puv3_rtc_settime(struct device *dev, struct rtc_time *tm)
+{
+	unsigned long rtc_count = 0;
+
+	pr_debug("set time %02d.%02d.%02d %02d/%02d/%02d\n",
+		 tm->tm_year, tm->tm_mon, tm->tm_mday,
+		 tm->tm_hour, tm->tm_min, tm->tm_sec);
+
+	rtc_tm_to_time(tm, &rtc_count);
+	RTC_RCNR = rtc_count;
+
+	return 0;
+}
+
+static int puv3_rtc_getalarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct rtc_time *alm_tm = &alrm->time;
+
+	rtc_time_to_tm(RTC_RTAR, alm_tm);
+
+	alrm->enabled = RTC_RTSR & RTC_RTSR_ALE;
+
+	pr_debug("read alarm %02x %02x.%02x.%02x %02x/%02x/%02x\n",
+		 alrm->enabled,
+		 alm_tm->tm_year, alm_tm->tm_mon, alm_tm->tm_mday,
+		 alm_tm->tm_hour, alm_tm->tm_min, alm_tm->tm_sec);
+
+	return 0;
+}
+
+static int puv3_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct rtc_time *tm = &alrm->time;
+	unsigned long rtcalarm_count = 0;
+
+	pr_debug("puv3_rtc_setalarm: %d, %02x/%02x/%02x %02x.%02x.%02x\n",
+		 alrm->enabled,
+		 tm->tm_mday & 0xff, tm->tm_mon & 0xff, tm->tm_year & 0xff,
+		 tm->tm_hour & 0xff, tm->tm_min & 0xff, tm->tm_sec);
+
+	rtc_tm_to_time(tm, &rtcalarm_count);
+	RTC_RTAR = rtcalarm_count;
+
+	puv3_rtc_setaie(alrm->enabled);
+
+	if (alrm->enabled)
+		enable_irq_wake(puv3_rtc_alarmno);
+	else
+		disable_irq_wake(puv3_rtc_alarmno);
+
+	return 0;
+}
+
+static int puv3_rtc_proc(struct device *dev, struct seq_file *seq)
+{
+	seq_printf(seq, "periodic_IRQ\t: %s\n",
+		     (RTC_RTSR & RTC_RTSR_HZE) ? "yes" : "no");
+	return 0;
+}
+
+static int puv3_rtc_open(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rtc_device *rtc_dev = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = request_irq(puv3_rtc_alarmno, puv3_rtc_alarmirq,
+			  IRQF_DISABLED,  "pkunity-rtc alarm", rtc_dev);
+
+	if (ret) {
+		dev_err(dev, "IRQ%d error %d\n", puv3_rtc_alarmno, ret);
+		return ret;
+	}
+
+	ret = request_irq(puv3_rtc_tickno, puv3_rtc_tickirq,
+			  IRQF_DISABLED,  "pkunity-rtc tick", rtc_dev);
+
+	if (ret) {
+		dev_err(dev, "IRQ%d error %d\n", puv3_rtc_tickno, ret);
+		goto tick_err;
+	}
+
+	return ret;
+
+ tick_err:
+	free_irq(puv3_rtc_alarmno, rtc_dev);
+	return ret;
+}
+
+static void puv3_rtc_release(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rtc_device *rtc_dev = platform_get_drvdata(pdev);
+
+	/* do not clear AIE here, it may be needed for wake */
+
+	puv3_rtc_setpie(dev, 0);
+	free_irq(puv3_rtc_alarmno, rtc_dev);
+	free_irq(puv3_rtc_tickno, rtc_dev);
+}
+
+static const struct rtc_class_ops puv3_rtcops = {
+	.open		= puv3_rtc_open,
+	.release	= puv3_rtc_release,
+	.read_time	= puv3_rtc_gettime,
+	.set_time	= puv3_rtc_settime,
+	.read_alarm	= puv3_rtc_getalarm,
+	.set_alarm	= puv3_rtc_setalarm,
+	.irq_set_freq	= puv3_rtc_setfreq,
+	.irq_set_state	= puv3_rtc_setpie,
+	.proc	        = puv3_rtc_proc,
+};
+
+static void puv3_rtc_enable(struct platform_device *pdev, int en)
+{
+	if (!en) {
+		RTC_RTSR &= ~RTC_RTSR_HZE;
+	} else {
+		/* re-enable the device, and check it is ok */
+
+		if ((RTC_RTSR & RTC_RTSR_HZE) == 0) {
+			dev_info(&pdev->dev, "rtc disabled, re-enabling\n");
+			RTC_RTSR |= RTC_RTSR_HZE;
+		}
+	}
+}
+
+static int puv3_rtc_remove(struct platform_device *dev)
+{
+	struct rtc_device *rtc = platform_get_drvdata(dev);
+
+	platform_set_drvdata(dev, NULL);
+	rtc_device_unregister(rtc);
+
+	puv3_rtc_setpie(&dev->dev, 0);
+	puv3_rtc_setaie(0);
+
+	release_resource(puv3_rtc_mem);
+	kfree(puv3_rtc_mem);
+
+	return 0;
+}
+
+static int puv3_rtc_probe(struct platform_device *pdev)
+{
+	struct rtc_device *rtc;
+	struct resource *res;
+	int ret;
+
+	pr_debug("%s: probe=%p\n", __func__, pdev);
+
+	/* find the IRQs */
+
+	puv3_rtc_tickno = platform_get_irq(pdev, 1);
+	if (puv3_rtc_tickno < 0) {
+		dev_err(&pdev->dev, "no irq for rtc tick\n");
+		return -ENOENT;
+	}
+
+	puv3_rtc_alarmno = platform_get_irq(pdev, 0);
+	if (puv3_rtc_alarmno < 0) {
+		dev_err(&pdev->dev, "no irq for alarm\n");
+		return -ENOENT;
+	}
+
+	pr_debug("PKUnity_rtc: tick irq %d, alarm irq %d\n",
+		 puv3_rtc_tickno, puv3_rtc_alarmno);
+
+	/* get the memory region */
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "failed to get memory region resource\n");
+		return -ENOENT;
+	}
+
+	puv3_rtc_mem = request_mem_region(res->start,
+					 res->end-res->start+1,
+					 pdev->name);
+
+	if (puv3_rtc_mem == NULL) {
+		dev_err(&pdev->dev, "failed to reserve memory region\n");
+		ret = -ENOENT;
+		goto err_nores;
+	}
+
+	puv3_rtc_enable(pdev, 1);
+
+	puv3_rtc_setfreq(&pdev->dev, 1);
+
+	/* register RTC and exit */
+
+	rtc = rtc_device_register("pkunity", &pdev->dev, &puv3_rtcops,
+				  THIS_MODULE);
+
+	if (IS_ERR(rtc)) {
+		dev_err(&pdev->dev, "cannot attach rtc\n");
+		ret = PTR_ERR(rtc);
+		goto err_nortc;
+	}
+
+	/* platform setup code should have handled this; sigh */
+	if (!device_can_wakeup(&pdev->dev))
+		device_init_wakeup(&pdev->dev, 1);
+
+	platform_set_drvdata(pdev, rtc);
+	return 0;
+
+ err_nortc:
+	puv3_rtc_enable(pdev, 0);
+	release_resource(puv3_rtc_mem);
+
+ err_nores:
+	return ret;
+}
+
+#ifdef CONFIG_PM
+
+/* RTC Power management control */
+
+static int ticnt_save;
+
+static int puv3_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	/* save RTAR for anyone using periodic interrupts */
+	ticnt_save = RTC_RTAR;
+	puv3_rtc_enable(pdev, 0);
+	return 0;
+}
+
+static int puv3_rtc_resume(struct platform_device *pdev)
+{
+	puv3_rtc_enable(pdev, 1);
+	RTC_RTAR = ticnt_save;
+	return 0;
+}
+#else
+#define puv3_rtc_suspend NULL
+#define puv3_rtc_resume  NULL
+#endif
+
+static struct platform_driver puv3_rtcdrv = {
+	.probe		= puv3_rtc_probe,
+	.remove		= __devexit_p(puv3_rtc_remove),
+	.suspend	= puv3_rtc_suspend,
+	.resume		= puv3_rtc_resume,
+	.driver		= {
+		.name	= "PKUnity-v3-RTC",
+		.owner	= THIS_MODULE,
+	}
+};
+
+static char __initdata banner[] = "PKUnity-v3 RTC, (c) 2009 PKUnity Co.\n";
+
+static int __init puv3_rtc_init(void)
+{
+	printk(banner);
+	return platform_driver_register(&puv3_rtcdrv);
+}
+
+static void __exit puv3_rtc_exit(void)
+{
+	platform_driver_unregister(&puv3_rtcdrv);
+}
+
+module_init(puv3_rtc_init);
+module_exit(puv3_rtc_exit);
+
+MODULE_DESCRIPTION("RTC Driver for the PKUnity v3 chip");
+MODULE_AUTHOR("Hu Dongliang");
+MODULE_LICENSE("GPL v2");
+
diff --git a/arch/unicore32/kernel/time.c b/arch/unicore32/kernel/time.c
new file mode 100644
index 0000000..8090d76
--- /dev/null
+++ b/arch/unicore32/kernel/time.c
@@ -0,0 +1,148 @@
+/*
+ * linux/arch/unicore32/kernel/time.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/timex.h>
+#include <linux/clockchips.h>
+
+#include <mach/hardware.h>
+
+#define MIN_OSCR_DELTA 2
+
+static irqreturn_t puv3_ost0_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *c = dev_id;
+
+	/* Disarm the compare/match, signal the event. */
+	OST_OIER &= ~OST_OIER_E0;
+	OST_OSSR &= ~OST_OSSR_M0;
+	c->event_handler(c);
+
+	return IRQ_HANDLED;
+}
+
+static int
+puv3_osmr0_set_next_event(unsigned long delta, struct clock_event_device *c)
+{
+	unsigned long next, oscr;
+
+	OST_OIER |= OST_OIER_E0;
+	next = OST_OSCR + delta;
+	OST_OSMR0 = next;
+	oscr = OST_OSCR;
+
+	return (signed)(next - oscr) <= MIN_OSCR_DELTA ? -ETIME : 0;
+}
+
+static void
+puv3_osmr0_set_mode(enum clock_event_mode mode, struct clock_event_device *c)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_ONESHOT:
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		OST_OIER &= ~OST_OIER_E0;
+		OST_OSSR &= ~OST_OSSR_M0;
+		break;
+
+	case CLOCK_EVT_MODE_RESUME:
+	case CLOCK_EVT_MODE_PERIODIC:
+		break;
+	}
+}
+
+static struct clock_event_device ckevt_puv3_osmr0 = {
+	.name		= "osmr0",
+	.features	= CLOCK_EVT_FEAT_ONESHOT,
+#ifdef CONFIG_ARCH_FPGA
+	.shift		= 18, /* correct shift val: 16, but warn_on_slowpath */
+#else
+	.shift          = 30,
+#endif
+	.rating		= 200,
+	.set_next_event	= puv3_osmr0_set_next_event,
+	.set_mode	= puv3_osmr0_set_mode,
+};
+
+static cycle_t puv3_read_oscr(struct clocksource *cs)
+{
+	return OST_OSCR;
+}
+
+static struct clocksource cksrc_puv3_oscr = {
+	.name		= "oscr",
+	.rating		= 200,
+	.read		= puv3_read_oscr,
+	.mask		= CLOCKSOURCE_MASK(32),
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static struct irqaction puv3_timer_irq = {
+	.name		= "ost0",
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.handler	= puv3_ost0_interrupt,
+	.dev_id		= &ckevt_puv3_osmr0,
+};
+
+void __init time_init(void)
+{
+	OST_OIER = 0;		/* disable any timer interrupts */
+	OST_OSSR = 0;		/* clear status on all timers */
+
+	ckevt_puv3_osmr0.mult =
+		div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC, ckevt_puv3_osmr0.shift);
+	ckevt_puv3_osmr0.max_delta_ns =
+		clockevent_delta2ns(0x7fffffff, &ckevt_puv3_osmr0);
+	ckevt_puv3_osmr0.min_delta_ns =
+		clockevent_delta2ns(MIN_OSCR_DELTA * 2, &ckevt_puv3_osmr0) + 1;
+	ckevt_puv3_osmr0.cpumask = cpumask_of(0);
+
+	setup_irq(IRQ_TIMER0, &puv3_timer_irq);
+
+	clocksource_register_hz(&cksrc_puv3_oscr, CLOCK_TICK_RATE);
+	clockevents_register_device(&ckevt_puv3_osmr0);
+}
+
+#ifdef CONFIG_PM
+unsigned long osmr[4], oier;
+
+void puv3_timer_suspend(void)
+{
+	osmr[0] = OST_OSMR0;
+	osmr[1] = OST_OSMR1;
+	osmr[2] = OST_OSMR2;
+	osmr[3] = OST_OSMR3;
+	oier = OST_OIER;
+}
+
+void puv3_timer_resume(void)
+{
+	OST_OSSR = 0;
+	OST_OSMR0 = osmr[0];
+	OST_OSMR1 = osmr[1];
+	OST_OSMR2 = osmr[2];
+	OST_OSMR3 = osmr[3];
+	OST_OIER = oier;
+
+	/*
+	 * OSMR0 is the system timer: make sure OSCR is sufficiently behind
+	 */
+	OST_OSCR = OST_OSMR0 - LATCH;
+}
+#else
+void puv3_timer_suspend(void) { };
+void puv3_timer_resume(void) { };
+#endif
+
-- 
1.7.0.4


