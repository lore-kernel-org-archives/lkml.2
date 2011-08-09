Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab1HIOAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:00:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46608 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab1HIOAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:00:22 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: ashish.jangam@kpitcummins.com
Cc: randy.dunlap@oracle.com, dtor@mail.ru, dmitry.torokhov@gmail.com,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] da9052_tsi: remove fifo and use delayed work
Date: Tue,  9 Aug 2011 15:59:32 +0200
Message-Id: <1312898372-24575-1-git-send-email-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310633890.284.90.camel@L-0532.kpit.com>
References: <1310633890.284.90.camel@L-0532.kpit.com>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the coordinate fifo and check for penup with a delayed work,
instead of a watching kernel thread.

Issues:
Sometimes there are well defined jitter values on the x-axys this must
be more investigated. Hint: DA9052_TSI_CONT_A_REG holds some time Adjust
values for TSI_SKIP and TSI_DELAY, which might have to be properly
aligned to the touch events.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/input/touchscreen/da9052_tsi.c |  245 ++++++++------------------------
 1 files changed, 61 insertions(+), 184 deletions(-)

diff --git a/drivers/input/touchscreen/da9052_tsi.c b/drivers/input/touchscreen/da9052_tsi.c
index 91e051a..91d489f 100755
--- a/drivers/input/touchscreen/da9052_tsi.c
+++ b/drivers/input/touchscreen/da9052_tsi.c
@@ -15,47 +15,24 @@
 #include <linux/input.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
-#include <linux/freezer.h>
+#include <linux/sched.h>
 #include <linux/kthread.h>
-#include <linux/kfifo.h>
 
 #include <linux/mfd/da9052/reg.h>
 #include <linux/mfd/da9052/da9052.h>
 
-#define DA9052_ACTIVE			1
-#define DA9052_INACTIVE		0
-
-#define DA9052_TSI_FIFOSIZE		640
-
-enum {
-	DA9052_PEN_IDLE,
-	DA9052_PEN_DOWN,
-	DA9052_PEN_UP
-};
-
 struct da9052_tsi_reg {
 	u16	x;
 	u16	y;
 };
 
-struct tsi_thread_type {
-	u8		pid;
-	u8		state;
-	struct completion	notifier;
-	struct task_struct	*thread_task;
-};
-
 struct da9052_tsi {
 	struct da9052	*da9052;
 	struct input_dev *dev;
-	struct tsi_thread_type	tsi_pen_state_thread;
-	struct tsi_thread_type  tsi_filter_thread;
-	struct kfifo fifo;
-	struct kfifo fifo_buf;
 	u8 pen_up_detect_interval;
 	u32 zero_data_cnt;
 	u32 valid_penup_count;
-	u8 pen_state;
+	struct delayed_work work;
 	int irq_pendwn;
 	int irq_datardy;
 };
@@ -71,6 +48,48 @@ static inline int da9052_ts_stop(struct da9052_tsi *tsi)
 	return da9052_clear_bits(tsi->da9052, DA9052_TSI_CONT_A_REG, 1 << 0);
 }
 
+static void da9052_work(struct work_struct *work)
+{
+	struct da9052_tsi *tsi = container_of(work, struct da9052_tsi, work.work);
+	struct da9052 *da9052 = tsi->da9052;
+	int ret;
+	uint8_t _v;
+	u16 down;
+
+	ret = da9052_reg_read(tsi->da9052, DA9052_TSI_LSB_REG);
+	if (ret < 0)
+		return;
+
+	_v = (uint8_t) ret;
+	down = ((_v & 0x40) >> 6);
+
+	if (!down) {
+		tsi->da9052->events_mask |= DA9052_E_TSI_READY;
+		tsi->da9052->events_mask &= ~DA9052_E_PEN_DOWN;
+
+		/* Mask TSI_READY event and unmask PEN_DOWN event*/
+		ret = da9052_reg_update(tsi->da9052, DA9052_IRQ_MASK_B_REG, 0x40, 0x80);
+		if (ret < 0)
+			return;
+
+		input_report_abs(tsi->dev, ABS_PRESSURE, 0);
+		input_report_key(tsi->dev, BTN_TOUCH, 1);
+		input_sync(tsi->dev);
+	} else {
+		da9052->events_mask |= DA9052_E_PEN_DOWN;
+		da9052->events_mask &= ~DA9052_E_TSI_READY;
+
+		/* Mask PEN_DOWN event and unmask TSI_READY event*/
+		ret = da9052_reg_update(da9052, DA9052_IRQ_MASK_B_REG, 0x80, 0x40);
+		if (ret < 0)
+			return;
+
+		/* start polling for touch_det to detect release */
+		schedule_delayed_work(&tsi->work, HZ / 50);
+	}
+
+}
+
 static irqreturn_t da9052_ts_pendwn_irq(int irq, void *data)
 {
 	struct da9052_tsi *tsi = (struct da9052_tsi *)data;
@@ -86,7 +105,10 @@ static irqreturn_t da9052_ts_pendwn_irq(int irq, void *data)
 		return IRQ_NONE;
 
 	da9052_ts_start(tsi);
-	tsi->pen_state = DA9052_PEN_DOWN;
+
+	input_report_abs(tsi->dev, ABS_PRESSURE, 1023);
+	input_report_key(tsi->dev, BTN_TOUCH, 0);
+	input_sync(tsi->dev);
 
 	return IRQ_HANDLED;
 }
@@ -118,7 +140,10 @@ static int da9052_ts_read(struct da9052_tsi *tsi)
 	co_ord.x = ((_x << 2) & 0x3fc) | (_v & 0x3);
 	co_ord.y = ((_y << 2) & 0x3fc) | ((_v & 0xc) >> 2);
 
-	ret = kfifo_in(&tsi->fifo, &co_ord, sizeof(struct da9052_tsi_reg));
+	input_report_abs(tsi->dev, ABS_X, co_ord.x);
+	input_report_abs(tsi->dev, ABS_Y, co_ord.y);
+	input_report_abs(tsi->dev, ABS_PRESSURE, 1023);
+	input_sync(tsi->dev);
 
 	return 0;
 }
@@ -135,131 +160,10 @@ static irqreturn_t da9052_ts_datardy_irq(int irq, void *data)
 		return IRQ_NONE;
 	}
 
-	return IRQ_HANDLED;
-}
-
-/*
-* Two FIFO are been used. FIFO1 is used for detecting pen up and
-* FIFO2 for reporting pen down co-ordinate.
-*/
-void da9052_ts_process_reg_data(struct da9052_tsi *tsi)
-{
-	struct da9052_tsi_reg tmp_raw_data;
-	u32 reg_data_cnt;
-	int ret;
-
-	reg_data_cnt = kfifo_len(&tsi->fifo);
-
-	while (reg_data_cnt-- > 0) {
-		ret = kfifo_out(&tsi->fifo, &tmp_raw_data,
-				sizeof(struct da9052_tsi_reg));
-		if (ret < 0)
-			continue;
-		kfifo_in(&tsi->fifo_buf, &tmp_raw_data,
-			 sizeof(struct da9052_tsi_reg));
-	}
-	return;
-}
-
-static void da9052_ts_report_penup(struct da9052_tsi *tsi)
-{
-	struct input_dev *ip_dev = tsi->dev;
-	struct da9052 *da9052 = tsi->da9052;
-	ssize_t ret;
-
-	ret = da9052_ts_stop(tsi);
-	if (ret < 0)
-		return;
-
-	da9052->events_mask |= DA9052_E_TSI_READY;
-	da9052->events_mask &= ~DA9052_E_PEN_DOWN;
-
-	/* Mask TSI_READY event and unmask PEN_DOWN event*/
-	ret = da9052_reg_update(da9052, DA9052_IRQ_MASK_B_REG, 0x40, 0x80);
-	if (ret < 0)
-		return;
-
-	input_report_abs(ip_dev, BTN_TOUCH, 0);
-	input_sync(ip_dev);
-
-	tsi->zero_data_cnt = 0;
-}
-
-/*
-* This function detects the pen up state using the kfifo len.
-* If kfifo len is zero for some interval then pen up is reported.
-* Else pen co-ordinate are reported.
-*/
-static int da9052_ts_monitor_pen_state(void *data)
-{
-	struct da9052_tsi *tsi = (struct da9052_tsi *) data;
-	u32 data_cnt;
-
-	set_freezable();
-
-	while (tsi->tsi_pen_state_thread.state == DA9052_ACTIVE) {
-		try_to_freeze();
-
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(msecs_to_jiffies(10));
-
-		if (tsi->pen_state != DA9052_PEN_DOWN)
-			continue;
-
-		data_cnt = kfifo_len(&tsi->fifo);
-		if (data_cnt < 0)
-			continue;
-
-		da9052_ts_process_reg_data(tsi);
-
-		if (data_cnt)
-			tsi->zero_data_cnt = 0;
-		else {
-			if ((++(tsi->zero_data_cnt)) >
-				tsi->valid_penup_count) {
-				tsi->pen_state = DA9052_PEN_UP;
-				da9052_ts_report_penup(tsi);
-			}
-		}
-	}
-
-	complete_and_exit(&tsi->tsi_pen_state_thread.notifier, 0);
-	return 0;
-}
-
-static int da9052_ts_process_thread(void *ptr)
-{
-	struct da9052_tsi_reg co_ord;
-	int cnt = 0, ret;
-	struct da9052_tsi *tsi = (struct da9052_tsi *)ptr;
-
-	set_freezable();
-
-	while (tsi->tsi_filter_thread.state == DA9052_ACTIVE) {
-
-		try_to_freeze();
-
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(msecs_to_jiffies(10));
-		cnt = kfifo_len(&tsi->fifo_buf);
-		if (cnt <= 0)
-			continue;
-
-		ret = kfifo_out(&tsi->fifo_buf, &co_ord,
-				sizeof(struct da9052_tsi_reg));
-		if (ret < 0)
-			continue;
-
-		input_report_abs(tsi->dev, BTN_TOUCH, 1);
-		input_report_abs(tsi->dev, ABS_X, co_ord.x);
-		input_report_abs(tsi->dev, ABS_Y, co_ord.y);
-		input_sync(tsi->dev);
-	}
-
-	tsi->tsi_filter_thread.thread_task = NULL;
-	complete_and_exit(&tsi->tsi_filter_thread.notifier, 0);
+	/* start polling for touch_det to detect release */
+	schedule_delayed_work(&tsi->work, HZ / 50);
 
-	return 0;
+	return IRQ_HANDLED;
 }
 
 static int da9052_ts_configure_gpio(struct da9052 *da9052)
@@ -296,16 +200,6 @@ static int __init da9052_ts_enable_device(struct da9052_tsi *tsi)
 
 	tsi->valid_penup_count = 5;
 
-	init_completion(&tsi->tsi_pen_state_thread.notifier);
-	tsi->tsi_pen_state_thread.state = DA9052_ACTIVE;
-	tsi->tsi_pen_state_thread.pid = kernel_thread(da9052_ts_monitor_pen_state, tsi,
-						      CLONE_KERNEL | SIGCHLD);
-
-	init_completion(&tsi->tsi_filter_thread.notifier);
-	tsi->tsi_filter_thread.state = DA9052_ACTIVE;
-	tsi->tsi_filter_thread.pid = kernel_thread(da9052_ts_process_thread, tsi,
-						   CLONE_KERNEL | SIGCHLD);
-
 	tsi->zero_data_cnt = 0;
 
 	/* Measure TSI sample every 1ms */
@@ -354,14 +248,6 @@ static s32 __devinit da9052_ts_probe(struct platform_device *pdev)
 		goto err_mem;
 	}
 
-	ret = kfifo_alloc(&tsi->fifo, DA9052_TSI_FIFOSIZE, GFP_KERNEL);
-	if (ret < 0)
-		goto err_input;
-
-	ret = kfifo_alloc(&tsi->fifo_buf, DA9052_TSI_FIFOSIZE, GFP_KERNEL);
-	if (ret < 0)
-		goto err_fifo;
-
 	tsi->da9052 = da9052;
 	tsi->pen_up_detect_interval = 5;
 	platform_set_drvdata(pdev, tsi);
@@ -388,6 +274,8 @@ static s32 __devinit da9052_ts_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_mem;
 
+	INIT_DELAYED_WORK(&tsi->work, da9052_work);
+
 	tsi->irq_pendwn = platform_get_irq_byname(pdev, "PENDWN");
 	ret = request_threaded_irq(tsi->da9052->irq_base + tsi->irq_pendwn,
 				NULL, da9052_ts_pendwn_irq,
@@ -397,7 +285,7 @@ static s32 __devinit da9052_ts_probe(struct platform_device *pdev)
 		dev_err(tsi->da9052->dev,
 			"Failed to register %s IRQ %d, error = %d\n", "PENDWN",
 			tsi->da9052->irq_base + tsi->irq_pendwn, ret);
-		goto err_fifo_buf;
+		goto err_input;
 	}
 
 	tsi->irq_datardy = platform_get_irq_byname(pdev, "TSIRDY");
@@ -409,19 +297,15 @@ static s32 __devinit da9052_ts_probe(struct platform_device *pdev)
 		dev_err(tsi->da9052->dev,
 			"Failed to register %s IRQ %d, error = %d\n", "TSIRDY",
 			tsi->da9052->irq_base + tsi->irq_datardy, ret);
-		goto err_fifo_buf;
+		goto err_input;
 	}
 
 	ret = da9052_ts_enable_device(tsi);
 	if (ret < 0)
-		goto err_fifo_buf;
+		goto err_input;
 
 	return 0;
 
-err_fifo_buf:
-	kfifo_free(&tsi->fifo_buf);
-err_fifo:
-	kfifo_free(&tsi->fifo);
 err_input:
 	input_free_device(input_dev);
 err_mem:
@@ -445,18 +329,11 @@ static int __devexit da9052_ts_remove(struct platform_device *pdev)
 	free_irq(tsi->da9052->irq_base + tsi->irq_pendwn, NULL);
 	free_irq(tsi->da9052->irq_base + tsi->irq_datardy, NULL);
 
-	tsi->tsi_pen_state_thread.state = DA9052_INACTIVE;
-	wait_for_completion(&tsi->tsi_pen_state_thread.notifier);
-
-	tsi->tsi_filter_thread.state = DA9052_INACTIVE;
-	wait_for_completion(&tsi->tsi_filter_thread.notifier);
-
+	cancel_delayed_work(&tsi->work);
 	input_unregister_device(tsi->dev);
 
 	platform_set_drvdata(pdev, NULL);
 
-	kfifo_free(&tsi->fifo);
-	kfifo_free(&tsi->fifo_buf);
 	kfree(tsi);
 
 	return 0;
-- 
1.7.5.4

