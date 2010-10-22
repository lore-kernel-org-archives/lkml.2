Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab0JVL7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 07:59:12 -0400
Received: from mgw-sa02.ext.nokia.com ([147.243.1.48]:30077 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab0JVL5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 07:57:50 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net, khali@linux-fr.org, guenter.roeck@ericsson.com,
        jic23@cam.ac.uk
Cc: lm-sensors@lm-sensors.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] hwmon: lis3: New parameters to platform data
Date: Fri, 22 Oct 2010 14:57:29 +0300
Message-Id: <1287748654-2626-8-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added default output data rate setting to platform data.
If default rate is 0, reset default value is used.
Added control for duration via platform data.
Added possibility to configure interrupts to trig on
both rising and falling edge. The lis3 WU unit can be
configured quite many ways and with some configurations it
is quite handy to get coordinate refresh when some
event trigs and when it reason goes away.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/hwmon/lis3lv02d.c |   21 ++++++++++++++-------
 include/linux/lis3lv02d.h |    6 +++++-
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index b44d4c5..d66cbe1 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -706,16 +706,16 @@ static void lis3lv02d_8b_configure(struct lis3lv02d *dev,
 	if (p->wakeup_flags) {
 		dev->write(dev, FF_WU_CFG_1, p->wakeup_flags);
 		dev->write(dev, FF_WU_THS_1, p->wakeup_thresh & 0x7f);
-		/* default to 2.5ms for now */
-		dev->write(dev, FF_WU_DURATION_1, 1);
+		/* pdata value + 1 to keep this backward compatible*/
+		dev->write(dev, FF_WU_DURATION_1, p->duration1 + 1);
 		ctrl2 ^= HP_FF_WU1; /* Xor to keep compatible with old pdata*/
 	}
 
 	if (p->wakeup_flags2) {
 		dev->write(dev, FF_WU_CFG_2, p->wakeup_flags2);
 		dev->write(dev, FF_WU_THS_2, p->wakeup_thresh2 & 0x7f);
-		/* default to 2.5ms for now */
-		dev->write(dev, FF_WU_DURATION_2, 1);
+		/* pdata value + 1 to keep this backward compatible*/
+		dev->write(dev, FF_WU_DURATION_2, p->duration2 + 1);
 		ctrl2 ^= HP_FF_WU2; /* Xor to keep compatible with old pdata*/
 	}
 	/* Configure hipass filters */
@@ -725,8 +725,8 @@ static void lis3lv02d_8b_configure(struct lis3lv02d *dev,
 		err = request_threaded_irq(p->irq2,
 					NULL,
 					lis302dl_interrupt_thread2_8b,
-					IRQF_TRIGGER_RISING |
-					IRQF_ONESHOT,
+					IRQF_TRIGGER_RISING | IRQF_ONESHOT |
+					(p->irq_flags2 & IRQF_TRIGGER_MASK),
 					DRIVER_NAME, &lis3_dev);
 		if (err < 0)
 			printk(KERN_ERR DRIVER_NAME
@@ -742,6 +742,7 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 {
 	int err;
 	irq_handler_t thread_fn;
+	int irq_flags = 0;
 
 	dev->whoami = lis3lv02d_read_8(dev, WHO_AM_I);
 
@@ -804,9 +805,14 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 		if (dev->whoami == WAI_8B)
 			lis3lv02d_8b_configure(dev, p);
 
+		irq_flags = p->irq_flags1 & IRQF_TRIGGER_MASK;
+
 		dev->irq_cfg = p->irq_cfg;
 		if (p->irq_cfg)
 			dev->write(dev, CTRL_REG3, p->irq_cfg);
+
+		if (p->default_rate)
+			lis3lv02d_set_odr(p->default_rate);
 	}
 
 	/* bail if we did not get an IRQ from the bus layer */
@@ -834,7 +840,8 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 
 	err = request_threaded_irq(dev->irq, lis302dl_interrupt,
 				thread_fn,
-				IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+				IRQF_TRIGGER_RISING | IRQF_ONESHOT |
+				irq_flags,
 				DRIVER_NAME, &lis3_dev);
 
 	if (err < 0) {
diff --git a/include/linux/lis3lv02d.h b/include/linux/lis3lv02d.h
index c4a4a52..18d578f 100644
--- a/include/linux/lis3lv02d.h
+++ b/include/linux/lis3lv02d.h
@@ -36,7 +36,10 @@ struct lis3lv02d_platform_data {
 #define LIS3_IRQ_OPEN_DRAIN	(1 << 6)
 #define LIS3_IRQ_ACTIVE_LOW	(1 << 7)
 	unsigned char irq_cfg;
-
+	unsigned char irq_flags1; /* Additional irq edge / level flags */
+	unsigned char irq_flags2; /* Additional irq edge / level flags */
+	unsigned char duration1;
+	unsigned char duration2;
 #define LIS3_WAKEUP_X_LO	(1 << 0)
 #define LIS3_WAKEUP_X_HI	(1 << 1)
 #define LIS3_WAKEUP_Y_LO	(1 << 2)
@@ -66,6 +69,7 @@ struct lis3lv02d_platform_data {
 	s8 axis_z;
 #define LIS3_USE_REGULATOR_CTRL 0x01
 	u16 driver_features;
+	int default_rate;
 	int (*setup_resources)(void);
 	int (*release_resources)(void);
 	/* Limits for selftest are specified in chip data sheet */
-- 
1.6.0.4

