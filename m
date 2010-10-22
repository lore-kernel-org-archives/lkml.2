Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab0JVL7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 07:59:08 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:30081 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab0JVL5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 07:57:50 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net, khali@linux-fr.org, guenter.roeck@ericsson.com,
        jic23@cam.ac.uk
Cc: lm-sensors@lm-sensors.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/12] hwmon: lis3: Enhance lis3 selftest with IRQ line test
Date: Fri, 22 Oct 2010 14:57:32 +0300
Message-Id: <1287748654-2626-11-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Configure chip to data ready mode in selftest and count received
interrupts to see that interrupt line(s) are working.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/hwmon/lis3lv02d.c |   87 ++++++++++++++++++++++++++++++++++++++++----
 drivers/hwmon/lis3lv02d.h |    3 +-
 2 files changed, 81 insertions(+), 9 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 9fd946c..f0343f3 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -48,6 +48,13 @@
 
 #define LIS3_SYSFS_POWERDOWN_DELAY 5000 /* In milliseconds */
 
+#define SELFTEST_OK	       0
+#define SELFTEST_FAIL	       -1
+#define SELFTEST_IRQ	       -2
+
+#define IRQ_LINE0	       0
+#define IRQ_LINE1	       1
+
 /*
  * The sensor can also generate interrupts (DRDY) but it's pretty pointless
  * because they are generated even if the data do not change. So it's better
@@ -198,6 +205,8 @@ static int lis3lv02d_selftest(struct lis3lv02d *lis3, s16 results[3])
 	s16 x, y, z;
 	u8 selftest;
 	int ret;
+	u8 ctrl_reg_data;
+	unsigned char irq_cfg;
 
 	mutex_lock(&lis3->mutex);
 	if (lis3_dev.whoami == WAI_12B)
@@ -205,6 +214,20 @@ static int lis3lv02d_selftest(struct lis3lv02d *lis3, s16 results[3])
 	else
 		selftest = CTRL1_STP;
 
+	irq_cfg = lis3->irq_cfg;
+	if (lis3_dev.whoami == WAI_8B) {
+		lis3->data_ready_count[IRQ_LINE0] = 0;
+		lis3->data_ready_count[IRQ_LINE1] = 0;
+
+		/* Change interrupt cfg to data ready for selftest */
+		atomic_inc(&lis3_dev.wake_thread);
+		lis3->irq_cfg = LIS3_IRQ1_DATA_READY | LIS3_IRQ2_DATA_READY;
+		lis3->read(lis3, CTRL_REG3, &ctrl_reg_data);
+		lis3->write(lis3, CTRL_REG3, (ctrl_reg_data &
+				~(LIS3_IRQ1_MASK | LIS3_IRQ2_MASK)) |
+				(LIS3_IRQ1_DATA_READY | LIS3_IRQ2_DATA_READY));
+	}
+
 	lis3->read(lis3, CTRL_REG1, &reg);
 	lis3->write(lis3, CTRL_REG1, (reg | selftest));
 	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
@@ -223,13 +246,33 @@ static int lis3lv02d_selftest(struct lis3lv02d *lis3, s16 results[3])
 	results[2] = z - lis3->read_data(lis3, OUTZ);
 
 	ret = 0;
+
+	if (lis3_dev.whoami == WAI_8B) {
+		/* Restore original interrupt configuration */
+		atomic_dec(&lis3_dev.wake_thread);
+		lis3->write(lis3, CTRL_REG3, ctrl_reg_data);
+		lis3->irq_cfg = irq_cfg;
+
+		if ((irq_cfg & LIS3_IRQ1_MASK) &&
+			lis3->data_ready_count[IRQ_LINE0] < 2) {
+			ret = SELFTEST_IRQ;
+			goto fail;
+		}
+
+		if ((irq_cfg & LIS3_IRQ2_MASK) &&
+			lis3->data_ready_count[IRQ_LINE1] < 2) {
+			ret = SELFTEST_IRQ;
+			goto fail;
+		}
+	}
+
 	if (lis3->pdata) {
 		int i;
 		for (i = 0; i < 3; i++) {
 			/* Check against selftest acceptance limits */
 			if ((results[i] < lis3->pdata->st_min_limits[i]) ||
 			    (results[i] > lis3->pdata->st_max_limits[i])) {
-				ret = -EIO;
+				ret = SELFTEST_FAIL;
 				goto fail;
 			}
 		}
@@ -392,13 +435,24 @@ static void lis302dl_interrupt_handle_click(struct lis3lv02d *lis3)
 	mutex_unlock(&lis3->mutex);
 }
 
-static irqreturn_t lis302dl_interrupt_thread1_8b(int irq, void *data)
+static inline void lis302dl_data_ready(struct lis3lv02d *lis3, int index)
 {
+	int dummy;
 
+	/* Dummy read to ack interrupt */
+	lis3lv02d_get_xyz(lis3, &dummy, &dummy, &dummy);
+	lis3->data_ready_count[index]++;
+}
+
+static irqreturn_t lis302dl_interrupt_thread1_8b(int irq, void *data)
+{
 	struct lis3lv02d *lis3 = data;
+	u8 irq_cfg = lis3->irq_cfg & LIS3_IRQ1_MASK;
 
-	if ((lis3->irq_cfg & LIS3_IRQ1_MASK) == LIS3_IRQ1_CLICK)
+	if (irq_cfg == LIS3_IRQ1_CLICK)
 		lis302dl_interrupt_handle_click(lis3);
+	else if (unlikely(irq_cfg == LIS3_IRQ1_DATA_READY))
+		lis302dl_data_ready(lis3, IRQ_LINE0);
 	else
 		lis3lv02d_joystick_poll(lis3->idev);
 
@@ -407,11 +461,13 @@ static irqreturn_t lis302dl_interrupt_thread1_8b(int irq, void *data)
 
 static irqreturn_t lis302dl_interrupt_thread2_8b(int irq, void *data)
 {
-
 	struct lis3lv02d *lis3 = data;
+	u8 irq_cfg = lis3->irq_cfg & LIS3_IRQ2_MASK;
 
-	if ((lis3->irq_cfg & LIS3_IRQ2_MASK) == LIS3_IRQ2_CLICK)
+	if (irq_cfg == LIS3_IRQ2_CLICK)
 		lis302dl_interrupt_handle_click(lis3);
+	else if (unlikely(irq_cfg == LIS3_IRQ2_DATA_READY))
+		lis302dl_data_ready(lis3, IRQ_LINE1);
 	else
 		lis3lv02d_joystick_poll(lis3->idev);
 
@@ -614,12 +670,27 @@ static void lis3lv02d_sysfs_poweron(struct lis3lv02d *lis3)
 static ssize_t lis3lv02d_selftest_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	int result;
 	s16 values[3];
 
+	static const char ok[] = "OK";
+	static const char fail[] = "FAIL";
+	static const char irq[] = "FAIL_IRQ";
+	const char *res;
+
 	lis3lv02d_sysfs_poweron(&lis3_dev);
-	result = lis3lv02d_selftest(&lis3_dev, values);
-	return sprintf(buf, "%s %d %d %d\n", result == 0 ? "OK" : "FAIL",
+	switch (lis3lv02d_selftest(&lis3_dev, values)) {
+	case SELFTEST_FAIL:
+		res = fail;
+		break;
+	case SELFTEST_IRQ:
+		res = irq;
+		break;
+	case SELFTEST_OK:
+	default:
+		res = ok;
+		break;
+	}
+	return sprintf(buf, "%s %d %d %d\n", res,
 		values[0], values[1], values[2]);
 }
 
diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index d3cb662..7b22cd9 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -254,7 +254,8 @@ struct lis3lv02d {
 	struct fasync_struct	*async_queue; /* queue for the misc device */
 	wait_queue_head_t	misc_wait; /* Wait queue for the misc device */
 	unsigned long		misc_opened; /* bit0: whether the device is open */
-	atomic_t                wake_thread;
+	int                     data_ready_count[2];
+	atomic_t		wake_thread;
 	unsigned char           irq_cfg;
 
 	struct lis3lv02d_platform_data *pdata;	/* for passing board config */
-- 
1.6.0.4

