Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab0DFF7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 01:59:24 -0400
Received: from smtp.nokia.com ([192.100.122.233]:45472 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab0DFF7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 01:59:14 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [RESEND PATCH v2 4/6] lis3: Add skeletons for interrupt handlers
Date: Tue,  6 Apr 2010 08:58:43 +0300
Message-Id: <1270533525-15312-5-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1270533525-15312-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1270533525-15312-1-git-send-email-samu.p.onkalo@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Apr 2010 05:58:59.0522 (UTC) FILETIME=[403A7A20:01CAD54E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original lis3 driver didn't provide interrupt handler(s) for
click or threshold event handling. This patch adds threaded handlers
for one or two interrupt lines for 8 bit device.
Actual content for interrupt handling is provided in the
separate patch.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Tested-by: Daniel Mack <daniel@caiaq.de>
Acked-by: Éric Piel <eric.piel@tremplin-utc.net>
---
 drivers/hwmon/lis3lv02d.c |   87 +++++++++++++++++++++++++++++++++------------
 include/linux/lis3lv02d.h |    1 +
 2 files changed, 65 insertions(+), 23 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 50f3123..3c06350 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -251,6 +251,9 @@ EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
 
 static irqreturn_t lis302dl_interrupt(int irq, void *dummy)
 {
+	if (!test_bit(0, &lis3_dev.misc_opened))
+		goto out;
+
 	/*
 	 * Be careful: on some HP laptops the bios force DD when on battery and
 	 * the lid is closed. This leads to interrupts as soon as a little move
@@ -260,44 +263,35 @@ static irqreturn_t lis302dl_interrupt(int irq, void *dummy)
 
 	wake_up_interruptible(&lis3_dev.misc_wait);
 	kill_fasync(&lis3_dev.async_queue, SIGIO, POLL_IN);
+out:
+	if (lis3_dev.whoami == WAI_8B && lis3_dev.idev &&
+	    lis3_dev.idev->input->users)
+		return IRQ_WAKE_THREAD;
 	return IRQ_HANDLED;
 }
 
-static int lis3lv02d_misc_open(struct inode *inode, struct file *file)
+static irqreturn_t lis302dl_interrupt_thread1_8b(int irq, void *data)
 {
-	int ret;
+	return IRQ_HANDLED;
+}
 
+static irqreturn_t lis302dl_interrupt_thread2_8b(int irq, void *data)
+{
+	return IRQ_HANDLED;
+}
+
+static int lis3lv02d_misc_open(struct inode *inode, struct file *file)
+{
 	if (test_and_set_bit(0, &lis3_dev.misc_opened))
 		return -EBUSY; /* already open */
 
 	atomic_set(&lis3_dev.count, 0);
-
-	/*
-	 * The sensor can generate interrupts for free-fall and direction
-	 * detection (distinguishable with FF_WU_SRC and DD_SRC) but to keep
-	 * the things simple and _fast_ we activate it only for free-fall, so
-	 * no need to read register (very slow with ACPI). For the same reason,
-	 * we forbid shared interrupts.
-	 *
-	 * IRQF_TRIGGER_RISING seems pointless on HP laptops because the
-	 * io-apic is not configurable (and generates a warning) but I keep it
-	 * in case of support for other hardware.
-	 */
-	ret = request_irq(lis3_dev.irq, lis302dl_interrupt, IRQF_TRIGGER_RISING,
-			  DRIVER_NAME, &lis3_dev);
-
-	if (ret) {
-		clear_bit(0, &lis3_dev.misc_opened);
-		printk(KERN_ERR DRIVER_NAME ": IRQ%d allocation failed\n", lis3_dev.irq);
-		return -EBUSY;
-	}
 	return 0;
 }
 
 static int lis3lv02d_misc_release(struct inode *inode, struct file *file)
 {
 	fasync_helper(-1, file, 0, &lis3_dev.async_queue);
-	free_irq(lis3_dev.irq, &lis3_dev);
 	clear_bit(0, &lis3_dev.misc_opened); /* release the device */
 	return 0;
 }
@@ -434,6 +428,11 @@ EXPORT_SYMBOL_GPL(lis3lv02d_joystick_enable);
 
 void lis3lv02d_joystick_disable(void)
 {
+	if (lis3_dev.irq)
+		free_irq(lis3_dev.irq, &lis3_dev);
+	if (lis3_dev.pdata && lis3_dev.pdata->irq2)
+		free_irq(lis3_dev.pdata->irq2, &lis3_dev);
+
 	if (!lis3_dev.idev)
 		return;
 
@@ -524,6 +523,7 @@ EXPORT_SYMBOL_GPL(lis3lv02d_remove_fs);
 static void lis3lv02d_8b_configure(struct lis3lv02d *dev,
 				struct lis3lv02d_platform_data *p)
 {
+	int err;
 	int ctrl2 = p->hipass_ctrl;
 
 	if (p->click_flags) {
@@ -554,6 +554,18 @@ static void lis3lv02d_8b_configure(struct lis3lv02d *dev,
 	}
 	/* Configure hipass filters */
 	dev->write(dev, CTRL_REG2, ctrl2);
+
+	if (p->irq2) {
+		err = request_threaded_irq(p->irq2,
+					NULL,
+					lis302dl_interrupt_thread2_8b,
+					IRQF_TRIGGER_RISING |
+					IRQF_ONESHOT,
+					DRIVER_NAME, &lis3_dev);
+		if (err < 0)
+			printk(KERN_ERR DRIVER_NAME
+				"No second IRQ. Limited functionality\n");
+	}
 }
 
 /*
@@ -562,6 +574,9 @@ static void lis3lv02d_8b_configure(struct lis3lv02d *dev,
  */
 int lis3lv02d_init_device(struct lis3lv02d *dev)
 {
+	int err;
+	irq_handler_t thread_fn;
+
 	dev->whoami = lis3lv02d_read_8(dev, WHO_AM_I);
 
 	switch (dev->whoami) {
@@ -616,6 +631,32 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 		goto out;
 	}
 
+	/*
+	 * The sensor can generate interrupts for free-fall and direction
+	 * detection (distinguishable with FF_WU_SRC and DD_SRC) but to keep
+	 * the things simple and _fast_ we activate it only for free-fall, so
+	 * no need to read register (very slow with ACPI). For the same reason,
+	 * we forbid shared interrupts.
+	 *
+	 * IRQF_TRIGGER_RISING seems pointless on HP laptops because the
+	 * io-apic is not configurable (and generates a warning) but I keep it
+	 * in case of support for other hardware.
+	 */
+	if (dev->whoami == WAI_8B)
+		thread_fn = lis302dl_interrupt_thread1_8b;
+	else
+		thread_fn = NULL;
+
+	err = request_threaded_irq(dev->irq, lis302dl_interrupt,
+				thread_fn,
+				IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+				DRIVER_NAME, &lis3_dev);
+
+	if (err < 0) {
+		printk(KERN_ERR DRIVER_NAME "Cannot get IRQ\n");
+		goto out;
+	}
+
 	if (misc_register(&lis3lv02d_misc_device))
 		printk(KERN_ERR DRIVER_NAME ": misc_register failed\n");
 out:
diff --git a/include/linux/lis3lv02d.h b/include/linux/lis3lv02d.h
index d625199..fd289b1 100644
--- a/include/linux/lis3lv02d.h
+++ b/include/linux/lis3lv02d.h
@@ -67,6 +67,7 @@ struct lis3lv02d_platform_data {
 	/* Limits for selftest are specified in chip data sheet */
 	s16 st_min_limits[3]; /* min pass limit x, y, z */
 	s16 st_max_limits[3]; /* max pass limit x, y, z */
+	int irq2;
 };
 
 #endif /* __LIS3LV02D_H_ */
-- 
1.6.0.4

