Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab0JVL5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 07:57:52 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:30018 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab0JVL5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 07:57:49 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net, khali@linux-fr.org, guenter.roeck@ericsson.com,
        jic23@cam.ac.uk
Cc: lm-sensors@lm-sensors.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] hwmon: lis3: Cleanup interrupt handling
Date: Fri, 22 Oct 2010 14:57:25 +0300
Message-Id: <1287748654-2626-4-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Irqcfg moved to chip data instead of platform data.
This simplifies access in interrupt handler little bit.

Input device open and close functions set status for
interrupt threaded handler once.

Unnecessary check for interrupt source removed since
it is enough that active interrupt line indicates that
there was an interrupt.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/hwmon/lis3lv02d.c |   33 +++++++++++----------------------
 drivers/hwmon/lis3lv02d.h |    2 ++
 2 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index ade6f3a..fe97390 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -309,10 +309,14 @@ static void lis3lv02d_joystick_open(struct input_polled_dev *pidev)
 {
 	if (lis3_dev.pm_dev)
 		pm_runtime_get_sync(lis3_dev.pm_dev);
+
+	if (lis3_dev.pdata && lis3_dev.whoami == WAI_8B && lis3_dev.idev)
+		atomic_set(&lis3_dev.wake_thread, 1);
 }
 
 static void lis3lv02d_joystick_close(struct input_polled_dev *pidev)
 {
+	atomic_set(&lis3_dev.wake_thread, 0);
 	if (lis3_dev.pm_dev)
 		pm_runtime_put(lis3_dev.pm_dev);
 }
@@ -332,8 +336,7 @@ static irqreturn_t lis302dl_interrupt(int irq, void *dummy)
 	wake_up_interruptible(&lis3_dev.misc_wait);
 	kill_fasync(&lis3_dev.async_queue, SIGIO, POLL_IN);
 out:
-	if (lis3_dev.pdata && lis3_dev.whoami == WAI_8B && lis3_dev.idev &&
-	    lis3_dev.idev->input->users)
+	if (atomic_read(&lis3_dev.wake_thread))
 		return IRQ_WAKE_THREAD;
 	return IRQ_HANDLED;
 }
@@ -364,31 +367,15 @@ static void lis302dl_interrupt_handle_click(struct lis3lv02d *lis3)
 	mutex_unlock(&lis3->mutex);
 }
 
-static void lis302dl_interrupt_handle_ff_wu(struct lis3lv02d *lis3)
-{
-	u8 wu1_src;
-	u8 wu2_src;
-
-	lis3->read(lis3, FF_WU_SRC_1, &wu1_src);
-	lis3->read(lis3, FF_WU_SRC_2, &wu2_src);
-
-	wu1_src = wu1_src & FF_WU_SRC_IA ? wu1_src : 0;
-	wu2_src = wu2_src & FF_WU_SRC_IA ? wu2_src : 0;
-
-	/* joystick poll is internally protected by the lis3->mutex. */
-	if (wu1_src || wu2_src)
-		lis3lv02d_joystick_poll(lis3_dev.idev);
-}
-
 static irqreturn_t lis302dl_interrupt_thread1_8b(int irq, void *data)
 {
 
 	struct lis3lv02d *lis3 = data;
 
-	if ((lis3->pdata->irq_cfg & LIS3_IRQ1_MASK) == LIS3_IRQ1_CLICK)
+	if ((lis3->irq_cfg & LIS3_IRQ1_MASK) == LIS3_IRQ1_CLICK)
 		lis302dl_interrupt_handle_click(lis3);
 	else
-		lis302dl_interrupt_handle_ff_wu(lis3);
+		lis3lv02d_joystick_poll(lis3->idev);
 
 	return IRQ_HANDLED;
 }
@@ -398,10 +385,10 @@ static irqreturn_t lis302dl_interrupt_thread2_8b(int irq, void *data)
 
 	struct lis3lv02d *lis3 = data;
 
-	if ((lis3->pdata->irq_cfg & LIS3_IRQ2_MASK) == LIS3_IRQ2_CLICK)
+	if ((lis3->irq_cfg & LIS3_IRQ2_MASK) == LIS3_IRQ2_CLICK)
 		lis302dl_interrupt_handle_click(lis3);
 	else
-		lis302dl_interrupt_handle_ff_wu(lis3);
+		lis3lv02d_joystick_poll(lis3->idev);
 
 	return IRQ_HANDLED;
 }
@@ -788,6 +775,7 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 	}
 
 	mutex_init(&dev->mutex);
+	atomic_set(&dev->wake_thread, 0);
 
 	lis3lv02d_add_fs(dev);
 	lis3lv02d_poweron(dev);
@@ -808,6 +796,7 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 		if (dev->whoami == WAI_8B)
 			lis3lv02d_8b_configure(dev, p);
 
+		dev->irq_cfg = p->irq_cfg;
 		if (p->irq_cfg)
 			dev->write(dev, CTRL_REG3, p->irq_cfg);
 	}
diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index 7661e59..66e37b1 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -252,6 +252,8 @@ struct lis3lv02d {
 	struct fasync_struct	*async_queue; /* queue for the misc device */
 	wait_queue_head_t	misc_wait; /* Wait queue for the misc device */
 	unsigned long		misc_opened; /* bit0: whether the device is open */
+	atomic_t                wake_thread;
+	unsigned char           irq_cfg;
 
 	struct lis3lv02d_platform_data *pdata;	/* for passing board config */
 	struct mutex		mutex;     /* Serialize poll and selftest */
-- 
1.6.0.4

