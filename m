Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab1GYPZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 11:25:14 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:40134 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab1GYPYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 11:24:55 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.88
Message-ID: <4E2D8AA6.9010601@tremplin-utc.net>
Date: Mon, 25 Jul 2011 17:24:22 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Mandriva/3.1.11-1 (2011.0) Thunderbird/3.1.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
CC: Ilkka Koskinen <ilkka.koskinen@nokia.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/10] lis3: Remove the references to the global variable
 in core driver
References: <4E2D8858.8000900@tremplin-utc.net>
In-Reply-To: <4E2D8858.8000900@tremplin-utc.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
---
 drivers/misc/lis3lv02d/lis3lv02d.c |  233 ++++++++++++++++++++----------------
 drivers/misc/lis3lv02d/lis3lv02d.h |    3 +
 2 files changed, 133 insertions(+), 103 deletions(-)

diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
index 83ff7b4..e67dcea 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -163,7 +163,7 @@ static void lis3lv02d_get_xyz(struct lis3lv02d *lis3, int *x, int *y, int *z)
 	int i;
 
 	if (lis3->blkread) {
-		if (lis3_dev.whoami == WAI_12B) {
+		if (lis3->whoami == WAI_12B) {
 			u16 data[3];
 			lis3->blkread(lis3, OUTX_L, 6, (u8 *)data);
 			for (i = 0; i < 3; i++)
@@ -195,20 +195,20 @@ static int lis3_8_rates[2] = {100, 400};
 static int lis3_3dc_rates[16] = {0, 1, 10, 25, 50, 100, 200, 400, 1600, 5000};
 
 /* ODR is Output Data Rate */
-static int lis3lv02d_get_odr(void)
+static int lis3lv02d_get_odr(struct lis3lv02d *lis3)
 {
 	u8 ctrl;
 	int shift;
 
-	lis3_dev.read(&lis3_dev, CTRL_REG1, &ctrl);
-	ctrl &= lis3_dev.odr_mask;
-	shift = ffs(lis3_dev.odr_mask) - 1;
-	return lis3_dev.odrs[(ctrl >> shift)];
+	lis3->read(&lis3, CTRL_REG1, &ctrl);
+	ctrl &= lis3->odr_mask;
+	shift = ffs(lis3->odr_mask) - 1;
+	return lis3->odrs[(ctrl >> shift)];
 }
 
 static int lis3lv02d_get_pwron_wait(struct lis3lv02d *lis3)
 {
-	int div = lis3lv02d_get_odr();
+	int div = lis3lv02d_get_odr(lis3);
 
 	if (WARN_ONCE(div == 0, "device returned spurious data"))
 		return -ENXIO;
@@ -218,7 +218,7 @@ static int lis3lv02d_get_pwron_wait(struct lis3lv02d *lis3)
 	return 0;
 }
 
-static int lis3lv02d_set_odr(int rate)
+static int lis3lv02d_set_odr(struct lis3lv02d *lis3, int rate)
 {
 	u8 ctrl;
 	int i, len, shift;
@@ -226,14 +226,14 @@ static int lis3lv02d_set_odr(int rate)
 	if (!rate)
 		return -EINVAL;
 
-	lis3_dev.read(&lis3_dev, CTRL_REG1, &ctrl);
-	ctrl &= ~lis3_dev.odr_mask;
-	len = 1 << hweight_long(lis3_dev.odr_mask); /* # of possible values */
-	shift = ffs(lis3_dev.odr_mask) - 1;
+	lis3->read(lis3, CTRL_REG1, &ctrl);
+	ctrl &= ~lis3->odr_mask;
+	len = 1 << hweight_long(lis3->odr_mask); /* # of possible values */
+	shift = ffs(lis3->odr_mask) - 1;
 
 	for (i = 0; i < len; i++)
-		if (lis3_dev.odrs[i] == rate) {
-			lis3_dev.write(&lis3_dev, CTRL_REG1,
+		if (lis3->odrs[i] == rate) {
+			lis3->write(lis3, CTRL_REG1,
 					ctrl | (i << shift));
 			return 0;
 		}
@@ -252,12 +252,12 @@ static int lis3lv02d_selftest(struct lis3lv02d *lis3, s16 results[3])
 	mutex_lock(&lis3->mutex);
 
 	irq_cfg = lis3->irq_cfg;
-	if (lis3_dev.whoami == WAI_8B) {
+	if (lis3->whoami == WAI_8B) {
 		lis3->data_ready_count[IRQ_LINE0] = 0;
 		lis3->data_ready_count[IRQ_LINE1] = 0;
 
 		/* Change interrupt cfg to data ready for selftest */
-		atomic_inc(&lis3_dev.wake_thread);
+		atomic_inc(&lis3->wake_thread);
 		lis3->irq_cfg = LIS3_IRQ1_DATA_READY | LIS3_IRQ2_DATA_READY;
 		lis3->read(lis3, CTRL_REG3, &ctrl_reg_data);
 		lis3->write(lis3, CTRL_REG3, (ctrl_reg_data &
@@ -265,12 +265,12 @@ static int lis3lv02d_selftest(struct lis3lv02d *lis3, s16 results[3])
 				(LIS3_IRQ1_DATA_READY | LIS3_IRQ2_DATA_READY));
 	}
 
-	if (lis3_dev.whoami == WAI_3DC) {
+	if (lis3->whoami == WAI_3DC) {
 		ctlreg = CTRL_REG4;
 		selftest = CTRL4_ST0;
 	} else {
 		ctlreg = CTRL_REG1;
-		if (lis3_dev.whoami == WAI_12B)
+		if (lis3->whoami == WAI_12B)
 			selftest = CTRL1_ST;
 		else
 			selftest = CTRL1_STP;
@@ -299,9 +299,9 @@ static int lis3lv02d_selftest(struct lis3lv02d *lis3, s16 results[3])
 
 	ret = 0;
 
-	if (lis3_dev.whoami == WAI_8B) {
+	if (lis3->whoami == WAI_8B) {
 		/* Restore original interrupt configuration */
-		atomic_dec(&lis3_dev.wake_thread);
+		atomic_dec(&lis3->wake_thread);
 		lis3->write(lis3, CTRL_REG3, ctrl_reg_data);
 		lis3->irq_cfg = irq_cfg;
 
@@ -413,24 +413,27 @@ EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
 
 static void lis3lv02d_joystick_poll(struct input_polled_dev *pidev)
 {
+	struct lis3lv02d *lis3 = pidev->private;
 	int x, y, z;
 
-	mutex_lock(&lis3_dev.mutex);
-	lis3lv02d_get_xyz(&lis3_dev, &x, &y, &z);
+	mutex_lock(&lis3->mutex);
+	lis3lv02d_get_xyz(lis3, &x, &y, &z);
 	input_report_abs(pidev->input, ABS_X, x);
 	input_report_abs(pidev->input, ABS_Y, y);
 	input_report_abs(pidev->input, ABS_Z, z);
 	input_sync(pidev->input);
-	mutex_unlock(&lis3_dev.mutex);
+	mutex_unlock(&lis3->mutex);
 }
 
 static void lis3lv02d_joystick_open(struct input_polled_dev *pidev)
 {
-	if (lis3_dev.pm_dev)
-		pm_runtime_get_sync(lis3_dev.pm_dev);
+	struct lis3lv02d *lis3 = pidev->private;
 
-	if (lis3_dev.pdata && lis3_dev.whoami == WAI_8B && lis3_dev.idev)
-		atomic_set(&lis3_dev.wake_thread, 1);
+	if (lis3->pm_dev)
+		pm_runtime_get_sync(lis3->pm_dev);
+
+	if (lis3->pdata && lis3->whoami == WAI_8B && lis3->idev)
+		atomic_set(&lis3->wake_thread, 1);
 	/*
 	 * Update coordinates for the case where poll interval is 0 and
 	 * the chip in running purely under interrupt control
@@ -440,14 +443,18 @@ static void lis3lv02d_joystick_open(struct input_polled_dev *pidev)
 
 static void lis3lv02d_joystick_close(struct input_polled_dev *pidev)
 {
-	atomic_set(&lis3_dev.wake_thread, 0);
-	if (lis3_dev.pm_dev)
-		pm_runtime_put(lis3_dev.pm_dev);
+	struct lis3lv02d *lis3 = pidev->private;
+
+	atomic_set(&lis3->wake_thread, 0);
+	if (lis3->pm_dev)
+		pm_runtime_put(lis3->pm_dev);
 }
 
-static irqreturn_t lis302dl_interrupt(int irq, void *dummy)
+static irqreturn_t lis302dl_interrupt(int irq, void *data)
 {
-	if (!test_bit(0, &lis3_dev.misc_opened))
+	struct lis3lv02d *lis3 = data;
+
+	if (!test_bit(0, &lis3->misc_opened))
 		goto out;
 
 	/*
@@ -455,12 +462,12 @@ static irqreturn_t lis302dl_interrupt(int irq, void *dummy)
 	 * the lid is closed. This leads to interrupts as soon as a little move
 	 * is done.
 	 */
-	atomic_inc(&lis3_dev.count);
+	atomic_inc(&lis3->count);
 
-	wake_up_interruptible(&lis3_dev.misc_wait);
-	kill_fasync(&lis3_dev.async_queue, SIGIO, POLL_IN);
+	wake_up_interruptible(&lis3->misc_wait);
+	kill_fasync(&lis3->async_queue, SIGIO, POLL_IN);
 out:
-	if (atomic_read(&lis3_dev.wake_thread))
+	if (atomic_read(&lis3->wake_thread))
 		return IRQ_WAKE_THREAD;
 	return IRQ_HANDLED;
 }
@@ -532,28 +539,37 @@ static irqreturn_t lis302dl_interrupt_thread2_8b(int irq, void *data)
 
 static int lis3lv02d_misc_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(0, &lis3_dev.misc_opened))
+	struct lis3lv02d *lis3 = container_of(file->private_data,
+					      struct lis3lv02d, miscdev);
+
+	if (test_and_set_bit(0, &lis3->misc_opened))
 		return -EBUSY; /* already open */
 
-	if (lis3_dev.pm_dev)
-		pm_runtime_get_sync(lis3_dev.pm_dev);
+	if (lis3->pm_dev)
+		pm_runtime_get_sync(lis3->pm_dev);
 
-	atomic_set(&lis3_dev.count, 0);
+	atomic_set(&lis3->count, 0);
 	return 0;
 }
 
 static int lis3lv02d_misc_release(struct inode *inode, struct file *file)
 {
-	fasync_helper(-1, file, 0, &lis3_dev.async_queue);
-	clear_bit(0, &lis3_dev.misc_opened); /* release the device */
-	if (lis3_dev.pm_dev)
-		pm_runtime_put(lis3_dev.pm_dev);
+	struct lis3lv02d *lis3 = container_of(file->private_data,
+					      struct lis3lv02d, miscdev);
+
+	fasync_helper(-1, file, 0, &lis3->async_queue);
+	clear_bit(0, &lis3->misc_opened); /* release the device */
+	if (lis3->pm_dev)
+		pm_runtime_put(lis3->pm_dev);
 	return 0;
 }
 
 static ssize_t lis3lv02d_misc_read(struct file *file, char __user *buf,
 				size_t count, loff_t *pos)
 {
+	struct lis3lv02d *lis3 = container_of(file->private_data,
+					      struct lis3lv02d, miscdev);
+
 	DECLARE_WAITQUEUE(wait, current);
 	u32 data;
 	unsigned char byte_data;
@@ -562,10 +578,10 @@ static ssize_t lis3lv02d_misc_read(struct file *file, char __user *buf,
 	if (count < 1)
 		return -EINVAL;
 
-	add_wait_queue(&lis3_dev.misc_wait, &wait);
+	add_wait_queue(&lis3->misc_wait, &wait);
 	while (true) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		data = atomic_xchg(&lis3_dev.count, 0);
+		data = atomic_xchg(&lis3->count, 0);
 		if (data)
 			break;
 
@@ -595,22 +611,28 @@ static ssize_t lis3lv02d_misc_read(struct file *file, char __user *buf,
 
 out:
 	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&lis3_dev.misc_wait, &wait);
+	remove_wait_queue(&lis3->misc_wait, &wait);
 
 	return retval;
 }
 
 static unsigned int lis3lv02d_misc_poll(struct file *file, poll_table *wait)
 {
-	poll_wait(file, &lis3_dev.misc_wait, wait);
-	if (atomic_read(&lis3_dev.count))
+	struct lis3lv02d *lis3 = container_of(file->private_data,
+					      struct lis3lv02d, miscdev);
+
+	poll_wait(file, &lis3->misc_wait, wait);
+	if (atomic_read(&lis3->count))
 		return POLLIN | POLLRDNORM;
 	return 0;
 }
 
 static int lis3lv02d_misc_fasync(int fd, struct file *file, int on)
 {
-	return fasync_helper(fd, file, on, &lis3_dev.async_queue);
+	struct lis3lv02d *lis3 = container_of(file->private_data,
+					      struct lis3lv02d, miscdev);
+
+	return fasync_helper(fd, file, on, &lis3->async_queue);
 }
 
 static const struct file_operations lis3lv02d_misc_fops = {
@@ -623,12 +645,6 @@ static const struct file_operations lis3lv02d_misc_fops = {
 	.fasync  = lis3lv02d_misc_fasync,
 };
 
-static struct miscdevice lis3lv02d_misc_device = {
-	.minor   = MISC_DYNAMIC_MINOR,
-	.name    = "freefall",
-	.fops    = &lis3lv02d_misc_fops,
-};
-
 int lis3lv02d_joystick_enable(struct lis3lv02d *lis3)
 {
 	struct input_dev *input_dev;
@@ -636,51 +652,52 @@ int lis3lv02d_joystick_enable(struct lis3lv02d *lis3)
 	int max_val, fuzz, flat;
 	int btns[] = {BTN_X, BTN_Y, BTN_Z};
 
-	if (lis3_dev.idev)
+	if (lis3->idev)
 		return -EINVAL;
 
-	lis3_dev.idev = input_allocate_polled_device();
-	if (!lis3_dev.idev)
+	lis3->idev = input_allocate_polled_device();
+	if (!lis3->idev)
 		return -ENOMEM;
 
-	lis3_dev.idev->poll = lis3lv02d_joystick_poll;
-	lis3_dev.idev->open = lis3lv02d_joystick_open;
-	lis3_dev.idev->close = lis3lv02d_joystick_close;
-	lis3_dev.idev->poll_interval = MDPS_POLL_INTERVAL;
-	lis3_dev.idev->poll_interval_min = MDPS_POLL_MIN;
-	lis3_dev.idev->poll_interval_max = MDPS_POLL_MAX;
-	input_dev = lis3_dev.idev->input;
+	lis3->idev->poll = lis3lv02d_joystick_poll;
+	lis3->idev->open = lis3lv02d_joystick_open;
+	lis3->idev->close = lis3lv02d_joystick_close;
+	lis3->idev->poll_interval = MDPS_POLL_INTERVAL;
+	lis3->idev->poll_interval_min = MDPS_POLL_MIN;
+	lis3->idev->poll_interval_max = MDPS_POLL_MAX;
+	lis3->idev->private = lis3;
+	input_dev = lis3->idev->input;
 
 	input_dev->name       = "ST LIS3LV02DL Accelerometer";
 	input_dev->phys       = DRIVER_NAME "/input0";
 	input_dev->id.bustype = BUS_HOST;
 	input_dev->id.vendor  = 0;
-	input_dev->dev.parent = &lis3_dev.pdev->dev;
+	input_dev->dev.parent = &lis3->pdev->dev;
 
 	set_bit(EV_ABS, input_dev->evbit);
-	max_val = (lis3_dev.mdps_max_val * lis3_dev.scale) / LIS3_ACCURACY;
-	if (lis3_dev.whoami == WAI_12B) {
+	max_val = (lis3->mdps_max_val * lis3->scale) / LIS3_ACCURACY;
+	if (lis3->whoami == WAI_12B) {
 		fuzz = LIS3_DEFAULT_FUZZ_12B;
 		flat = LIS3_DEFAULT_FLAT_12B;
 	} else {
 		fuzz = LIS3_DEFAULT_FUZZ_8B;
 		flat = LIS3_DEFAULT_FLAT_8B;
 	}
-	fuzz = (fuzz * lis3_dev.scale) / LIS3_ACCURACY;
-	flat = (flat * lis3_dev.scale) / LIS3_ACCURACY;
+	fuzz = (fuzz * lis3->scale) / LIS3_ACCURACY;
+	flat = (flat * lis3->scale) / LIS3_ACCURACY;
 
 	input_set_abs_params(input_dev, ABS_X, -max_val, max_val, fuzz, flat);
 	input_set_abs_params(input_dev, ABS_Y, -max_val, max_val, fuzz, flat);
 	input_set_abs_params(input_dev, ABS_Z, -max_val, max_val, fuzz, flat);
 
-	lis3_dev.mapped_btns[0] = lis3lv02d_get_axis(abs(lis3_dev.ac.x), btns);
-	lis3_dev.mapped_btns[1] = lis3lv02d_get_axis(abs(lis3_dev.ac.y), btns);
-	lis3_dev.mapped_btns[2] = lis3lv02d_get_axis(abs(lis3_dev.ac.z), btns);
+	lis3->mapped_btns[0] = lis3lv02d_get_axis(abs(lis3->ac.x), btns);
+	lis3->mapped_btns[1] = lis3lv02d_get_axis(abs(lis3->ac.y), btns);
+	lis3->mapped_btns[2] = lis3lv02d_get_axis(abs(lis3->ac.z), btns);
 
-	err = input_register_polled_device(lis3_dev.idev);
+	err = input_register_polled_device(lis3->idev);
 	if (err) {
-		input_free_polled_device(lis3_dev.idev);
-		lis3_dev.idev = NULL;
+		input_free_polled_device(lis3->idev);
+		lis3->idev = NULL;
 	}
 
 	return err;
@@ -689,19 +706,19 @@ EXPORT_SYMBOL_GPL(lis3lv02d_joystick_enable);
 
 void lis3lv02d_joystick_disable(struct lis3lv02d *lis3)
 {
-	if (lis3_dev.irq)
-		free_irq(lis3_dev.irq, &lis3_dev);
-	if (lis3_dev.pdata && lis3_dev.pdata->irq2)
-		free_irq(lis3_dev.pdata->irq2, &lis3_dev);
+	if (lis3->irq)
+		free_irq(lis3->irq, lis3);
+	if (lis3->pdata && lis3->pdata->irq2)
+		free_irq(lis3->pdata->irq2, lis3);
 
-	if (!lis3_dev.idev)
+	if (!lis3->idev)
 		return;
 
-	if (lis3_dev.irq)
-		misc_deregister(&lis3lv02d_misc_device);
-	input_unregister_polled_device(lis3_dev.idev);
-	input_free_polled_device(lis3_dev.idev);
-	lis3_dev.idev = NULL;
+	if (lis3->irq)
+		misc_deregister(&lis3->miscdev);
+	input_unregister_polled_device(lis3->idev);
+	input_free_polled_device(lis3->idev);
+	lis3->idev = NULL;
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_joystick_disable);
 
@@ -726,6 +743,7 @@ static void lis3lv02d_sysfs_poweron(struct lis3lv02d *lis3)
 static ssize_t lis3lv02d_selftest_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
+	struct lis3lv02d *lis3 = dev_get_drvdata(dev);
 	s16 values[3];
 
 	static const char ok[] = "OK";
@@ -733,8 +751,8 @@ static ssize_t lis3lv02d_selftest_show(struct device *dev,
 	static const char irq[] = "FAIL_IRQ";
 	const char *res;
 
-	lis3lv02d_sysfs_poweron(&lis3_dev);
-	switch (lis3lv02d_selftest(&lis3_dev, values)) {
+	lis3lv02d_sysfs_poweron(lis3);
+	switch (lis3lv02d_selftest(lis3, values)) {
 	case SELFTEST_FAIL:
 		res = fail;
 		break;
@@ -753,33 +771,37 @@ static ssize_t lis3lv02d_selftest_show(struct device *dev,
 static ssize_t lis3lv02d_position_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
+	struct lis3lv02d *lis3 = dev_get_drvdata(dev);
 	int x, y, z;
 
-	lis3lv02d_sysfs_poweron(&lis3_dev);
-	mutex_lock(&lis3_dev.mutex);
-	lis3lv02d_get_xyz(&lis3_dev, &x, &y, &z);
-	mutex_unlock(&lis3_dev.mutex);
+	lis3lv02d_sysfs_poweron(lis3);
+	mutex_lock(&lis3->mutex);
+	lis3lv02d_get_xyz(lis3, &x, &y, &z);
+	mutex_unlock(&lis3->mutex);
 	return sprintf(buf, "(%d,%d,%d)\n", x, y, z);
 }
 
 static ssize_t lis3lv02d_rate_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-	lis3lv02d_sysfs_poweron(&lis3_dev);
-	return sprintf(buf, "%d\n", lis3lv02d_get_odr());
+	struct lis3lv02d *lis3 = dev_get_drvdata(dev);
+
+	lis3lv02d_sysfs_poweron(lis3);
+	return sprintf(buf, "%d\n", lis3lv02d_get_odr(lis3));
 }
 
 static ssize_t lis3lv02d_rate_set(struct device *dev,
 				struct device_attribute *attr, const char *buf,
 				size_t count)
 {
+	struct lis3lv02d *lis3 = dev_get_drvdata(dev);
 	unsigned long rate;
 
 	if (strict_strtoul(buf, 0, &rate))
 		return -EINVAL;
 
-	lis3lv02d_sysfs_poweron(&lis3_dev);
-	if (lis3lv02d_set_odr(rate))
+	lis3lv02d_sysfs_poweron(lis3);
+	if (lis3lv02d_set_odr(lis3, rate))
 		return -EINVAL;
 
 	return count;
@@ -808,6 +830,7 @@ static int lis3lv02d_add_fs(struct lis3lv02d *lis3)
 	if (IS_ERR(lis3->pdev))
 		return PTR_ERR(lis3->pdev);
 
+	platform_set_drvdata(lis3->pdev, lis3);
 	return sysfs_create_group(&lis3->pdev->dev.kobj, &lis3lv02d_attribute_group);
 }
 
@@ -821,7 +844,7 @@ int lis3lv02d_remove_fs(struct lis3lv02d *lis3)
 
 		/* SYSFS may have left chip running. Turn off if necessary */
 		if (!pm_runtime_suspended(lis3->pm_dev))
-			lis3lv02d_poweroff(&lis3_dev);
+			lis3lv02d_poweroff(lis3);
 
 		pm_runtime_disable(lis3->pm_dev);
 		pm_runtime_set_suspended(lis3->pm_dev);
@@ -848,7 +871,7 @@ static void lis3lv02d_8b_configure(struct lis3lv02d *lis3,
 			(p->click_thresh_y << 4));
 
 		if (lis3->idev) {
-			struct input_dev *input_dev = lis3_dev.idev->input;
+			struct input_dev *input_dev = lis3->idev->input;
 			input_set_capability(input_dev, EV_KEY, BTN_X);
 			input_set_capability(input_dev, EV_KEY, BTN_Y);
 			input_set_capability(input_dev, EV_KEY, BTN_Z);
@@ -879,7 +902,7 @@ static void lis3lv02d_8b_configure(struct lis3lv02d *lis3,
 					lis302dl_interrupt_thread2_8b,
 					IRQF_TRIGGER_RISING | IRQF_ONESHOT |
 					(p->irq_flags2 & IRQF_TRIGGER_MASK),
-					DRIVER_NAME, &lis3_dev);
+					DRIVER_NAME, lis3);
 		if (err < 0)
 			pr_err("No second IRQ. Limited functionality\n");
 	}
@@ -975,7 +998,7 @@ int lis3lv02d_init_device(struct lis3lv02d *lis3)
 			lis3->write(lis3, CTRL_REG3, p->irq_cfg);
 
 		if (p->default_rate)
-			lis3lv02d_set_odr(p->default_rate);
+			lis3lv02d_set_odr(lis3, p->default_rate);
 	}
 
 	/* bail if we did not get an IRQ from the bus layer */
@@ -1004,14 +1027,18 @@ int lis3lv02d_init_device(struct lis3lv02d *lis3)
 				thread_fn,
 				IRQF_TRIGGER_RISING | IRQF_ONESHOT |
 				irq_flags,
-				DRIVER_NAME, &lis3_dev);
+				DRIVER_NAME, lis3);
 
 	if (err < 0) {
 		pr_err("Cannot get IRQ\n");
 		goto out;
 	}
 
-	if (misc_register(&lis3lv02d_misc_device))
+	lis3->miscdev.minor	= MISC_DYNAMIC_MINOR;
+	lis3->miscdev.name	= "freefall";
+	lis3->miscdev.fops	= &lis3lv02d_misc_fops;
+
+	if (misc_register(&lis3->miscdev))
 		pr_err("misc_register failed\n");
 out:
 	return 0;
diff --git a/drivers/misc/lis3lv02d/lis3lv02d.h b/drivers/misc/lis3lv02d/lis3lv02d.h
index b94e723..2b1482a 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.h
+++ b/drivers/misc/lis3lv02d/lis3lv02d.h
@@ -21,6 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/input-polldev.h>
 #include <linux/regulator/consumer.h>
+#include <linux/miscdevice.h>
 
 /*
  * This driver tries to support the "digital" accelerometer chips from
@@ -273,6 +274,8 @@ struct lis3lv02d {
 	struct fasync_struct	*async_queue; /* queue for the misc device */
 	wait_queue_head_t	misc_wait; /* Wait queue for the misc device */
 	unsigned long		misc_opened; /* bit0: whether the device is open */
+	struct miscdevice	miscdev;
+
 	int                     data_ready_count[2];
 	atomic_t		wake_thread;
 	unsigned char           irq_cfg;
-- 
1.7.6

