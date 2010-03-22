Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab0CVL1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 07:27:12 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:48479 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab0CVL1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 07:27:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=q0ey7bbn+SBRKObzCjMiLpsuF7YbhdDtCdKyjjeEGEXS2eNRvrAeMd0/a9FBkqu76K
         m1jFWhs4wt8MEj28miBq5SRhrYY6SPcro/uBFW/vYqvwLZj2yYD4G0ZYm9V+z+NNhMHr
         +pdHGRhh4D85hevziwx0ygzVqOUxpaYm3W34g=
MIME-Version: 1.0
From: Maurus Cuelenaere <mcuelenaere@gmail.com>
Date: Mon, 22 Mar 2010 12:26:48 +0100
Message-ID: <b2e8f9f71003220426j9bdb088w343bcebe642247f6@mail.gmail.com>
Subject: [PATCH] S3C RTC driver: add support for S3C64xx
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Frans Pop <elendil@planet.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the S3C64xx SoC to the generic S3C RTC driver.

Signed-off-by: Maurus Cuelenaere <mcuelenaere@gmail.com>
Acked-By: Ben Dooks <ben-linux@fluff.org>
---

This was sent to rtc-linux before (12/01/2010), but no response was
received yet.
See http://groups.google.com/group/rtc-linux/browse_thread/thread/2a2dfc23a8042f3d/2812dcbafd9a0a85
for the full thread.

At 08/03/2010 I posted this to LKML, with no result.
On recommendation of Frans Pop, I resend this to LKML with Andrew Morton in CC.

The platform part of this patch has been included in 2.6.34-rc2.

 arch/arm/plat-s3c/include/plat/regs-rtc.h |    4 +
 drivers/rtc/Kconfig                       |    2 +-
 drivers/rtc/rtc-s3c.c                     |  107 +++++++++++++++++++++++------
 3 files changed, 92 insertions(+), 21 deletions(-)

diff --git a/arch/arm/plat-s3c/include/plat/regs-rtc.h
b/arch/arm/plat-s3c/include/plat/regs-rtc.h
index d5837cf..65c190d 100644
--- a/arch/arm/plat-s3c/include/plat/regs-rtc.h
+++ b/arch/arm/plat-s3c/include/plat/regs-rtc.h
@@ -20,6 +20,10 @@
 #define S3C2410_RTCCON_CLKSEL (1<<1)
 #define S3C2410_RTCCON_CNTSEL (1<<2)
 #define S3C2410_RTCCON_CLKRST (1<<3)
+#define S3C64XX_RTCCON_TICEN  (1<<8)
+
+#define S3C64XX_RTCCON_TICMSK (0xF<<7)
+#define S3C64XX_RTCCON_TICSHT (7)

 #define S3C2410_TICNT	      S3C2410_RTCREG(0x44)
 #define S3C2410_TICNT_ENABLE  (1<<7)
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 8167e9e..b44db44 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -620,7 +620,7 @@ config RTC_DRV_OMAP

 config RTC_DRV_S3C
 	tristate "Samsung S3C series SoC RTC"
-	depends on ARCH_S3C2410
+	depends on ARCH_S3C2410 || ARCH_S3C64XX
 	help
 	  RTC (Realtime Clock) driver for the clock inbuilt into the
 	  Samsung S3C24XX series of SoCs. This can provide periodic
diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index e0d7b99..798d2dd 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -28,6 +28,11 @@
 #include <asm/irq.h>
 #include <plat/regs-rtc.h>

+enum s3c_cpu_type {
+	TYPE_S3C2410,
+	TYPE_S3C64XX,
+};
+
 /* I have yet to find an S3C implementation with more than one
  * of these rtc blocks in */

@@ -36,6 +41,7 @@ static struct resource *s3c_rtc_mem;
 static void __iomem *s3c_rtc_base;
 static int s3c_rtc_alarmno = NO_IRQ;
 static int s3c_rtc_tickno  = NO_IRQ;
+static enum s3c_cpu_type s3c_rtc_cpu_type;

 static DEFINE_SPINLOCK(s3c_rtc_pie_lock);

@@ -79,12 +85,25 @@ static int s3c_rtc_setpie(struct device *dev, int enabled)
 	pr_debug("%s: pie=%d\n", __func__, enabled);

 	spin_lock_irq(&s3c_rtc_pie_lock);
-	tmp = readb(s3c_rtc_base + S3C2410_TICNT) & ~S3C2410_TICNT_ENABLE;

-	if (enabled)
-		tmp |= S3C2410_TICNT_ENABLE;
+	if (s3c_rtc_cpu_type == TYPE_S3C64XX) {
+		tmp = readb(s3c_rtc_base + S3C2410_RTCCON);
+		tmp &= ~S3C64XX_RTCCON_TICEN;
+
+		if (enabled)
+			tmp |= S3C64XX_RTCCON_TICEN;
+
+		writeb(tmp, s3c_rtc_base + S3C2410_RTCCON);
+	} else {
+		tmp = readb(s3c_rtc_base + S3C2410_TICNT);
+		tmp &= ~S3C2410_TICNT_ENABLE;
+
+		if (enabled)
+			tmp |= S3C2410_TICNT_ENABLE;
+
+		writeb(tmp, s3c_rtc_base + S3C2410_TICNT);
+	}

-	writeb(tmp, s3c_rtc_base + S3C2410_TICNT);
 	spin_unlock_irq(&s3c_rtc_pie_lock);

 	return 0;
@@ -92,15 +111,21 @@ static int s3c_rtc_setpie(struct device *dev, int enabled)

 static int s3c_rtc_setfreq(struct device *dev, int freq)
 {
-	unsigned int tmp;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rtc_device *rtc_dev = platform_get_drvdata(pdev);
+	unsigned int tmp = 0;

 	if (!is_power_of_2(freq))
 		return -EINVAL;

 	spin_lock_irq(&s3c_rtc_pie_lock);

-	tmp = readb(s3c_rtc_base + S3C2410_TICNT) & S3C2410_TICNT_ENABLE;
-	tmp |= (128 / freq)-1;
+	if (s3c_rtc_cpu_type == TYPE_S3C2410) {
+		tmp = readb(s3c_rtc_base + S3C2410_TICNT);
+		tmp &= S3C2410_TICNT_ENABLE;
+	}
+
+	tmp |= (rtc_dev->max_user_freq / freq)-1;

 	writeb(tmp, s3c_rtc_base + S3C2410_TICNT);
 	spin_unlock_irq(&s3c_rtc_pie_lock);
@@ -282,10 +307,17 @@ static int s3c_rtc_setalarm(struct device *dev,
struct rtc_wkalrm *alrm)

 static int s3c_rtc_proc(struct device *dev, struct seq_file *seq)
 {
-	unsigned int ticnt = readb(s3c_rtc_base + S3C2410_TICNT);
+	unsigned int ticnt;

-	seq_printf(seq, "periodic_IRQ\t: %s\n",
-		     (ticnt & S3C2410_TICNT_ENABLE) ? "yes" : "no" );
+	if (s3c_rtc_cpu_type == TYPE_S3C64XX) {
+		ticnt = readb(s3c_rtc_base + S3C2410_RTCCON);
+		ticnt &= S3C64XX_RTCCON_TICEN;
+	} else {
+		ticnt = readb(s3c_rtc_base + S3C2410_TICNT);
+		ticnt &= S3C2410_TICNT_ENABLE;
+	}
+
+	seq_printf(seq, "periodic_IRQ\t: %s\n", ticnt  ? "yes" : "no");
 	return 0;
 }

@@ -352,10 +384,16 @@ static void s3c_rtc_enable(struct
platform_device *pdev, int en)

 	if (!en) {
 		tmp = readb(base + S3C2410_RTCCON);
-		writeb(tmp & ~S3C2410_RTCCON_RTCEN, base + S3C2410_RTCCON);
-
-		tmp = readb(base + S3C2410_TICNT);
-		writeb(tmp & ~S3C2410_TICNT_ENABLE, base + S3C2410_TICNT);
+		if (s3c_rtc_cpu_type == TYPE_S3C64XX)
+			tmp &= ~S3C64XX_RTCCON_TICEN;
+		tmp &= ~S3C2410_RTCCON_RTCEN;
+		writeb(tmp, base + S3C2410_RTCCON);
+
+		if (s3c_rtc_cpu_type == TYPE_S3C2410) {
+			tmp = readb(base + S3C2410_TICNT);
+			tmp &= ~S3C2410_TICNT_ENABLE;
+			writeb(tmp, base + S3C2410_TICNT);
+		}
 	} else {
 		/* re-enable the device, and check it is ok */

@@ -471,7 +509,12 @@ static int __devinit s3c_rtc_probe(struct
platform_device *pdev)
 		goto err_nortc;
 	}

-	rtc->max_user_freq = 128;
+	if (s3c_rtc_cpu_type == TYPE_S3C64XX)
+		rtc->max_user_freq = 32768;
+	else
+		rtc->max_user_freq = 128;
+
+	s3c_rtc_cpu_type = platform_get_device_id(pdev)->driver_data;

 	platform_set_drvdata(pdev, rtc);
 	return 0;
@@ -491,20 +534,30 @@ static int __devinit s3c_rtc_probe(struct
platform_device *pdev)

 /* RTC Power management control */

-static int ticnt_save;
+static int ticnt_save, ticnt_en_save;

 static int s3c_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	/* save TICNT for anyone using periodic interrupts */
 	ticnt_save = readb(s3c_rtc_base + S3C2410_TICNT);
+	if (s3c_rtc_cpu_type == TYPE_S3C64XX) {
+		ticnt_en_save = readb(s3c_rtc_base + S3C2410_RTCCON);
+		ticnt_en_save &= S3C64XX_RTCCON_TICEN;
+	}
 	s3c_rtc_enable(pdev, 0);
 	return 0;
 }

 static int s3c_rtc_resume(struct platform_device *pdev)
 {
+	unsigned int tmp;
+
 	s3c_rtc_enable(pdev, 1);
 	writeb(ticnt_save, s3c_rtc_base + S3C2410_TICNT);
+	if (s3c_rtc_cpu_type == TYPE_S3C64XX && ticnt_en_save) {
+		tmp = readb(s3c_rtc_base + S3C2410_RTCCON);
+		writeb(tmp | ticnt_en_save, s3c_rtc_base + S3C2410_RTCCON);
+	}
 	return 0;
 }
 #else
@@ -512,13 +565,27 @@ static int s3c_rtc_resume(struct platform_device *pdev)
 #define s3c_rtc_resume  NULL
 #endif

-static struct platform_driver s3c2410_rtc_driver = {
+static struct platform_device_id s3c_rtc_driver_ids[] = {
+	{
+		.name		= "s3c2410-rtc",
+		.driver_data	= TYPE_S3C2410,
+	}, {
+		.name		= "s3c64xx-rtc",
+		.driver_data	= TYPE_S3C64XX,
+	},
+	{ }
+};
+
+MODULE_DEVICE_TABLE(platform, s3c_rtc_driver_ids);
+
+static struct platform_driver s3c_rtc_driver = {
 	.probe		= s3c_rtc_probe,
 	.remove		= __devexit_p(s3c_rtc_remove),
 	.suspend	= s3c_rtc_suspend,
 	.resume		= s3c_rtc_resume,
+	.id_table	= s3c_rtc_driver_ids,
 	.driver		= {
-		.name	= "s3c2410-rtc",
+		.name	= "s3c-rtc",
 		.owner	= THIS_MODULE,
 	},
 };
@@ -528,12 +595,12 @@ static char __initdata banner[] = "S3C24XX RTC,
(c) 2004,2006 Simtec Electronics
 static int __init s3c_rtc_init(void)
 {
 	printk(banner);
-	return platform_driver_register(&s3c2410_rtc_driver);
+	return platform_driver_register(&s3c_rtc_driver);
 }

 static void __exit s3c_rtc_exit(void)
 {
-	platform_driver_unregister(&s3c2410_rtc_driver);
+	platform_driver_unregister(&s3c_rtc_driver);
 }

 module_init(s3c_rtc_init);
-- 
1.7.0.2
