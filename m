Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab0DFF7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 01:59:31 -0400
Received: from smtp.nokia.com ([192.100.122.233]:45475 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab0DFF7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 01:59:15 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [RESEND PATCH v2 5/6] lis3: Interrupt handlers for 8bit wakeup and click events
Date: Tue,  6 Apr 2010 08:58:44 +0300
Message-Id: <1270533525-15312-6-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1270533525-15312-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1270533525-15312-1-git-send-email-samu.p.onkalo@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Apr 2010 05:59:01.0381 (UTC) FILETIME=[41562350:01CAD54E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Content for the 8bit device threaded interrupt handlers.
Depending on the interrupt line and chip configuration,
either click or wakeup / freefall handler is called.
In case of click, BTN_ event is sent via input device.
In case of wakeup or freefall, input device ABS_ events
are updated immediatelly.

It is still possible to configure interrupt line 1 for fast freefall
detection and use the second line either for click or threshold
based interrupts. Or both lines can be used for click / threshold
interrupts.

Polled input device can be set to stopped state and still
get coordinate updates via input device using interrupt
based method. Polled mode and interrupt mode can also be used parallel.

BTN_ events are remapped based on existing axis remapping information.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Éric Piel <eric.piel@tremplin-utc.net>
---
 drivers/hwmon/lis3lv02d.c |   98 +++++++++++++++++++++++++++++++++++++++------
 drivers/hwmon/lis3lv02d.h |    1 +
 include/linux/lis3lv02d.h |    2 +
 3 files changed, 88 insertions(+), 13 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 3c06350..56a1d34 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -121,11 +121,9 @@ static void lis3lv02d_get_xyz(struct lis3lv02d *lis3, int *x, int *y, int *z)
 	int position[3];
 	int i;
 
-	mutex_lock(&lis3->mutex);
 	position[0] = lis3->read_data(lis3, OUTX);
 	position[1] = lis3->read_data(lis3, OUTY);
 	position[2] = lis3->read_data(lis3, OUTZ);
-	mutex_unlock(&lis3->mutex);
 
 	for (i = 0; i < 3; i++)
 		position[i] = (position[i] * lis3->scale) / LIS3_ACCURACY;
@@ -249,6 +247,19 @@ void lis3lv02d_poweron(struct lis3lv02d *lis3)
 EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
 
 
+static void lis3lv02d_joystick_poll(struct input_polled_dev *pidev)
+{
+	int x, y, z;
+
+	mutex_lock(&lis3_dev.mutex);
+	lis3lv02d_get_xyz(&lis3_dev, &x, &y, &z);
+	input_report_abs(pidev->input, ABS_X, x);
+	input_report_abs(pidev->input, ABS_Y, y);
+	input_report_abs(pidev->input, ABS_Z, z);
+	input_sync(pidev->input);
+	mutex_unlock(&lis3_dev.mutex);
+}
+
 static irqreturn_t lis302dl_interrupt(int irq, void *dummy)
 {
 	if (!test_bit(0, &lis3_dev.misc_opened))
@@ -270,13 +281,71 @@ out:
 	return IRQ_HANDLED;
 }
 
+static void lis302dl_interrupt_handle_click(struct lis3lv02d *lis3)
+{
+	struct input_dev *dev = lis3->idev->input;
+	u8 click_src;
+
+	mutex_lock(&lis3->mutex);
+	lis3->read(lis3, CLICK_SRC, &click_src);
+
+	if (click_src & CLICK_SINGLE_X) {
+		input_report_key(dev, lis3->mapped_btns[0], 1);
+		input_report_key(dev, lis3->mapped_btns[0], 0);
+	}
+
+	if (click_src & CLICK_SINGLE_Y) {
+		input_report_key(dev, lis3->mapped_btns[1], 1);
+		input_report_key(dev, lis3->mapped_btns[1], 0);
+	}
+
+	if (click_src & CLICK_SINGLE_Z) {
+		input_report_key(dev, lis3->mapped_btns[2], 1);
+		input_report_key(dev, lis3->mapped_btns[2], 0);
+	}
+	input_sync(dev);
+	mutex_unlock(&lis3->mutex);
+}
+
+static void lis302dl_interrupt_handle_ff_wu(struct lis3lv02d *lis3)
+{
+	u8 wu1_src;
+	u8 wu2_src;
+
+	lis3->read(lis3, FF_WU_SRC_1, &wu1_src);
+	lis3->read(lis3, FF_WU_SRC_2, &wu2_src);
+
+	wu1_src = wu1_src & FF_WU_SRC_IA ? wu1_src : 0;
+	wu2_src = wu2_src & FF_WU_SRC_IA ? wu2_src : 0;
+
+	/* joystick poll is internally protected by the lis3->mutex. */
+	if (wu1_src || wu2_src)
+		lis3lv02d_joystick_poll(lis3_dev.idev);
+}
+
 static irqreturn_t lis302dl_interrupt_thread1_8b(int irq, void *data)
 {
+
+	struct lis3lv02d *lis3 = data;
+
+	if ((lis3->pdata->irq_cfg & LIS3_IRQ1_MASK) == LIS3_IRQ1_CLICK)
+		lis302dl_interrupt_handle_click(lis3);
+	else
+		lis302dl_interrupt_handle_ff_wu(lis3);
+
 	return IRQ_HANDLED;
 }
 
 static irqreturn_t lis302dl_interrupt_thread2_8b(int irq, void *data)
 {
+
+	struct lis3lv02d *lis3 = data;
+
+	if ((lis3->pdata->irq_cfg & LIS3_IRQ2_MASK) == LIS3_IRQ2_CLICK)
+		lis302dl_interrupt_handle_click(lis3);
+	else
+		lis302dl_interrupt_handle_ff_wu(lis3);
+
 	return IRQ_HANDLED;
 }
 
@@ -374,22 +443,12 @@ static struct miscdevice lis3lv02d_misc_device = {
 	.fops    = &lis3lv02d_misc_fops,
 };
 
-static void lis3lv02d_joystick_poll(struct input_polled_dev *pidev)
-{
-	int x, y, z;
-
-	lis3lv02d_get_xyz(&lis3_dev, &x, &y, &z);
-	input_report_abs(pidev->input, ABS_X, x);
-	input_report_abs(pidev->input, ABS_Y, y);
-	input_report_abs(pidev->input, ABS_Z, z);
-	input_sync(pidev->input);
-}
-
 int lis3lv02d_joystick_enable(void)
 {
 	struct input_dev *input_dev;
 	int err;
 	int max_val, fuzz, flat;
+	int btns[] = {BTN_X, BTN_Y, BTN_Z};
 
 	if (lis3_dev.idev)
 		return -EINVAL;
@@ -416,6 +475,10 @@ int lis3lv02d_joystick_enable(void)
 	input_set_abs_params(input_dev, ABS_Y, -max_val, max_val, fuzz, flat);
 	input_set_abs_params(input_dev, ABS_Z, -max_val, max_val, fuzz, flat);
 
+	lis3_dev.mapped_btns[0] = lis3lv02d_get_axis(abs(lis3_dev.ac.x), btns);
+	lis3_dev.mapped_btns[1] = lis3lv02d_get_axis(abs(lis3_dev.ac.y), btns);
+	lis3_dev.mapped_btns[2] = lis3lv02d_get_axis(abs(lis3_dev.ac.z), btns);
+
 	err = input_register_polled_device(lis3_dev.idev);
 	if (err) {
 		input_free_polled_device(lis3_dev.idev);
@@ -461,7 +524,9 @@ static ssize_t lis3lv02d_position_show(struct device *dev,
 {
 	int x, y, z;
 
+	mutex_lock(&lis3_dev.mutex);
 	lis3lv02d_get_xyz(&lis3_dev, &x, &y, &z);
+	mutex_unlock(&lis3_dev.mutex);
 	return sprintf(buf, "(%d,%d,%d)\n", x, y, z);
 }
 
@@ -535,6 +600,13 @@ static void lis3lv02d_8b_configure(struct lis3lv02d *dev,
 		dev->write(dev, CLICK_THSY_X,
 			(p->click_thresh_x & 0xf) |
 			(p->click_thresh_y << 4));
+
+		if (dev->idev) {
+			struct input_dev *input_dev = lis3_dev.idev->input;
+			input_set_capability(input_dev, EV_KEY, BTN_X);
+			input_set_capability(input_dev, EV_KEY, BTN_Y);
+			input_set_capability(input_dev, EV_KEY, BTN_Z);
+		}
 	}
 
 	if (p->wakeup_flags) {
diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index 692e244..8540913 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -233,6 +233,7 @@ struct lis3lv02d {
 	struct platform_device	*pdev;     /* platform device */
 	atomic_t		count;     /* interrupt count after last read */
 	struct axis_conversion	ac;        /* hw -> logical axis */
+	int			mapped_btns[3];
 
 	u32			irq;       /* IRQ number */
 	struct fasync_struct	*async_queue; /* queue for the misc device */
diff --git a/include/linux/lis3lv02d.h b/include/linux/lis3lv02d.h
index fd289b1..0e8a346 100644
--- a/include/linux/lis3lv02d.h
+++ b/include/linux/lis3lv02d.h
@@ -25,12 +25,14 @@ struct lis3lv02d_platform_data {
 #define LIS3_IRQ1_FF_WU_12	(3 << 0)
 #define LIS3_IRQ1_DATA_READY	(4 << 0)
 #define LIS3_IRQ1_CLICK		(7 << 0)
+#define LIS3_IRQ1_MASK		(7 << 0)
 #define LIS3_IRQ2_DISABLE	(0 << 3)
 #define LIS3_IRQ2_FF_WU_1	(1 << 3)
 #define LIS3_IRQ2_FF_WU_2	(2 << 3)
 #define LIS3_IRQ2_FF_WU_12	(3 << 3)
 #define LIS3_IRQ2_DATA_READY	(4 << 3)
 #define LIS3_IRQ2_CLICK		(7 << 3)
+#define LIS3_IRQ2_MASK		(7 << 3)
 #define LIS3_IRQ_OPEN_DRAIN	(1 << 6)
 #define LIS3_IRQ_ACTIVE_LOW	(1 << 7)
 	unsigned char irq_cfg;
-- 
1.6.0.4

