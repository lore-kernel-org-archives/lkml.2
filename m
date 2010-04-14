Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab0DNTX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 15:23:27 -0400
Received: from mail.perches.com ([173.55.12.10]:1480 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab0DNTXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 15:23:24 -0400
Subject: Re: cy8ctmg110 for review
From: Joe Perches <joe@perches.com>
To: Alan Cox <alan@linux.intel.com>,
       Samuli Konttila <samuli.konttila@aavamobile.com>
Cc: linux-i2c@vger.kernel.org, khali@linux-fr.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100414125234.23507.42816.stgit@localhost.localdomain>
References: <20100414125234.23507.42816.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 12:23:19 -0700
Message-ID: <1271272999.1833.3.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-14 at 13:54 +0100, Alan Cox wrote:
> Subject: [FOR COMMENT] cy8ctmg110 for review
> 
> From: Samuli Konttila <samuli.konttila@aavamobile.com>

> Add support for the cy8ctmg110 capacitive touchscreen used on some embedded
> devices.
> 
> (Some clean up by Alan Cox)

Some more cleanups.  Still not signed.

Cleanup includes
Cleanup typos
Remove a few used-once #defines
Cleanup logging

 drivers/input/touchscreen/cy8ctmg110_ts.c |  145 ++++++++++++----------------
 1 files changed, 62 insertions(+), 83 deletions(-)

diff --git a/drivers/input/touchscreen/cy8ctmg110_ts.c b/drivers/input/touchscreen/cy8ctmg110_ts.c
index 4adbe87..ea41f97 100644
--- a/drivers/input/touchscreen/cy8ctmg110_ts.c
+++ b/drivers/input/touchscreen/cy8ctmg110_ts.c
@@ -16,57 +16,48 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/input.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <asm/io.h>
 #include <linux/i2c.h>
 #include <linux/timer.h>
 #include <linux/gpio.h>
 #include <linux/hrtimer.h>
-
-#include <linux/platform_device.h>
-#include <linux/delay.h>
-#include <linux/fs.h>
-#include <asm/ioctl.h>
-#include <asm/uaccess.h>
+#include <linux/init.h>
 #include <linux/device.h>
-#include <linux/module.h>
+#include <linux/miscdevice.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
-#include <asm/ioctl.h>
-#include <linux/fs.h>
-#include <linux/init.h>
-#include <linux/miscdevice.h>
-#include <linux/module.h>
-
+#include <linux/io.h>
+#include <linux/ioctl.h>
+#include <linux/uaccess.h>
 
 #define CY8CTMG110_DRIVER_NAME      "cy8ctmg110"
 
-
-/*HW definations*/
+/* HW definitions */
 #define CY8CTMG110_RESET_PIN_GPIO   43
 #define CY8CTMG110_IRQ_PIN_GPIO     59
 #define CY8CTMG110_I2C_ADDR         0x38
 #define CY8CTMG110_I2C_ADDR_EXT     0x39
 #define CY8CTMG110_I2C_ADDR_        0x2	/*i2c address first sample */
-#define CY8CTMG110_I2C_ADDR__       53	/*i2c address to FW where irq support missing */
+#define CY8CTMG110_I2C_ADDR__       53	/*i2c address to FW where
+					  irq support missing */
 #define CY8CTMG110_TOUCH_IRQ        21
-#define CY8CTMG110_TOUCH_LENGHT     9787
-#define CY8CTMG110_SCREEN_LENGHT    8424
-
+#define CY8CTMG110_TOUCH_LENGTH     9787
+#define CY8CTMG110_SCREEN_LENGTH    8424
 
-/*Touch coordinates*/
+/* Touch coordinates */
 #define CY8CTMG110_X_MIN        0
 #define CY8CTMG110_Y_MIN        0
 #define CY8CTMG110_X_MAX        864
 #define CY8CTMG110_Y_MAX        480
 
-
-/*cy8ctmg110 registers defination*/
+/* cy8ctmg110 registers definition */
 #define CY8CTMG110_TOUCH_WAKEUP_TIME   0
 #define CY8CTMG110_TOUCH_SLEEP_TIME    2
 #define CY8CTMG110_TOUCH_X1            3
@@ -77,21 +68,17 @@
 #define CY8CTMG110_GESTURE             12
 #define CY8CTMG110_REG_MAX             13
 
-#define CY8CTMG110_POLL_TIMER_DELAY  1000*1000*100
+#define CY8CTMG110_POLL_TIMER_DELAY  (1000 * 1000 * 100)
 #define TOUCH_MAX_I2C_FAILS          50
 
-/* Scale factors for coordinates */
-#define X_SCALE_FACTOR 9387/8424
-#define Y_SCALE_FACTOR 97/100
-
 /* For tracing */
-static int g_y_trace_coord = 0;
+static int g_y_trace_coord;
 module_param(g_y_trace_coord, int, 0600);
 
 /* Polling mode */
-static int polling = 0;
+static int polling;
 module_param(polling, int, 0);
-MODULE_PARM_DESC(polling, "Set to enabling polling of the touchscreen");
+MODULE_PARM_DESC(polling, "Set to enable polling of the touchscreen");
 
 
 /*
@@ -102,7 +89,7 @@ struct ts_event {
 	int y1;
 	int x2;
 	int y2;
-	bool event_sended;
+	bool event_sent;
 };
 
 /*
@@ -122,8 +109,8 @@ struct cy8ctmg110 {
 };
 
 /*
- * cy8ctmg110_poweroff is the routine that is called when touch hardware 
- * will powered off
+ * cy8ctmg110_poweroff is the routine that is called
+ * when touch hardware will be powered off
  */
 static void cy8ctmg110_power(bool poweron)
 {
@@ -135,7 +122,6 @@ static void cy8ctmg110_power(bool poweron)
 
 /*
  * cy8ctmg110_write_req write regs to the i2c devices
- * 
  */
 static int cy8ctmg110_write_req(struct cy8ctmg110 *tsc, unsigned char reg,
 		unsigned char len, unsigned char *value)
@@ -152,7 +138,7 @@ static int cy8ctmg110_write_req(struct cy8ctmg110 *tsc, unsigned char reg,
 
 	ret = i2c_transfer(client->adapter, msg, 1);
 	if (ret != 1) {
-		printk("cy8ctmg110 touch : i2c write data cmd failed \n");
+		pr_err("i2c write data cmd failed\n");
 		return ret;
 	}
 	return 0;
@@ -160,9 +146,7 @@ static int cy8ctmg110_write_req(struct cy8ctmg110 *tsc, unsigned char reg,
 
 /*
  * cy8ctmg110_read_req read regs from i2c devise
- * 
  */
-
 static int cy8ctmg110_read_req(struct cy8ctmg110 *tsc,
 		unsigned char *i2c_data, unsigned char len, unsigned char cmd)
 {
@@ -208,23 +192,23 @@ static void cy8ctmg110_send_event(void *tsc)
 	x = ts->tc.x1;
 	y = ts->tc.y1;
 
-	if (ts->tc.event_sended == false) {
+	if (!ts->tc.event_sent) {
 		input_report_key(input, BTN_TOUCH, 1);
 		ts->pending = true;
-		x2 = (u16) (y * X_SCALE_FACTOR);
-		y2 = (u16) (x * Y_SCALE_FACTOR);
+		x2 = (u16)(y * 9387 / 8424);
+		y2 = (u16)(x * 97 / 100);
 		input_report_abs(input, ABS_X, x2);
 		input_report_abs(input, ABS_Y, y2);
 		input_sync(input);
 		if (g_y_trace_coord)
-			printk("cy8ctmg110 touch position X:%d (was = %d) Y:%d (was = %d)\n", x2, y, y2, x);
+			pr_info("position X:%d (was = %d) Y:%d (was = %d)\n",
+				x2, y, y2, x);
 	}
 
 }
 
 /*
  * cy8ctmg110_touch_pos check touch position from i2c devices
- * 
  */
 static int cy8ctmg110_touch_pos(struct cy8ctmg110 *tsc)
 {
@@ -236,30 +220,29 @@ static int cy8ctmg110_touch_pos(struct cy8ctmg110 *tsc)
 	/*Reading coordinates */
 	if (cy8ctmg110_read_req(tsc, reg_p, 9, CY8CTMG110_TOUCH_X1) != 0)
 		return -EIO;
-		
+
 	y = reg_p[2] << 8 | reg_p[3];
 	x = reg_p[0] << 8 | reg_p[1];
 		/*number of touch */
 	if (reg_p[8] == 0) {
-		if (tsc->pending == true) {
+		if (tsc->pending) {
 			struct input_dev *input = tsc->input;
 
 			input_report_key(input, BTN_TOUCH, 0);
-			tsc->tc.event_sended = true;
+			tsc->tc.event_sent = true;
 			tsc->pending = false;
 		}
 	} else if (tsc->tc.x1 != x || tsc->tc.y1 != y) {
 		tsc->tc.y1 = y;
 		tsc->tc.x1 = x;
-		tsc->tc.event_sended = false;
+		tsc->tc.event_sent = false;
 		cy8ctmg110_send_event(tsc);
 	}
 	return 0;
 }
 
 /*
- * if interrupt isn't in use the touch positions can reads by polling
- * 
+ * if interrupt isn't in use the touch positions can be read by polling
  */
 static enum hrtimer_restart cy8ctmg110_timer(struct hrtimer *handle)
 {
@@ -270,7 +253,9 @@ static enum hrtimer_restart cy8ctmg110_timer(struct hrtimer *handle)
 
 	cy8ctmg110_touch_pos(ts);
 	if (ts->i2c_fail_count < TOUCH_MAX_I2C_FAILS)
-		hrtimer_start(&ts->timer, ktime_set(0, CY8CTMG110_POLL_TIMER_DELAY), HRTIMER_MODE_REL);
+		hrtimer_start(&ts->timer,
+			      ktime_set(0, CY8CTMG110_POLL_TIMER_DELAY),
+			      HRTIMER_MODE_REL);
 
 	spin_unlock_irqrestore(&ts->lock, flags);
 	return HRTIMER_NORESTART;
@@ -278,13 +263,12 @@ static enum hrtimer_restart cy8ctmg110_timer(struct hrtimer *handle)
 
 /*
  * cy8ctmg110_init_controller set init value to touchcontroller
- * 
  */
 static bool cy8ctmg110_set_sleepmode(struct cy8ctmg110 *ts)
 {
 	unsigned char reg_p[3];
 
-	if (ts->sleepmode == true) {
+	if (ts->sleepmode) {
 		reg_p[0] = 0x00;
 		reg_p[1] = 0xff;
 		reg_p[2] = 5;
@@ -303,15 +287,13 @@ static bool cy8ctmg110_set_sleepmode(struct cy8ctmg110 *ts)
 
 /*
  * cy8ctmg110_irq_handler irq handling function
- * 
  */
-
 static irqreturn_t cy8ctmg110_irq_handler(int irq, void *dev_id)
 {
 	struct cy8ctmg110 *tsc = (struct cy8ctmg110 *) dev_id;
 
-	if (tsc->initController == false) {
-		if (cy8ctmg110_set_sleepmode(tsc) == true)
+	if (!tsc->initController) {
+		if (cy8ctmg110_set_sleepmode(tsc))
 			tsc->initController = true;
 	} else
 		cy8ctmg110_touch_pos(tsc);
@@ -322,8 +304,8 @@ static irqreturn_t cy8ctmg110_irq_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-
-static int cy8ctmg110_probe(struct i2c_client *client, const struct i2c_device_id *id)
+static int cy8ctmg110_probe(struct i2c_client *client,
+			    const struct i2c_device_id *id)
 {
 	struct cy8ctmg110 *ts;
 	struct input_dev *input_dev;
@@ -350,7 +332,7 @@ static int cy8ctmg110_probe(struct i2c_client *client, const struct i2c_device_i
 	ts->sleepmode = false;
 
 	snprintf(ts->phys, sizeof(ts->phys), "%s/input0",
-						dev_name(&client->dev));
+		 dev_name(&client->dev));
 
 	input_dev->name = CY8CTMG110_DRIVER_NAME " Touchscreen";
 	input_dev->phys = ts->phys;
@@ -358,20 +340,22 @@ static int cy8ctmg110_probe(struct i2c_client *client, const struct i2c_device_i
 
 	spin_lock_init(&ts->lock);
 
-	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP) |
-					BIT_MASK(EV_REL) | BIT_MASK(EV_ABS);
+	input_dev->evbit[0] = (BIT_MASK(EV_KEY) | BIT_MASK(EV_REP) |
+			       BIT_MASK(EV_REL) | BIT_MASK(EV_ABS));
 	input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 
 	input_set_capability(input_dev, EV_KEY, KEY_F);
 
-	input_set_abs_params(input_dev, ABS_X, CY8CTMG110_X_MIN, CY8CTMG110_X_MAX, 0, 0);
-	input_set_abs_params(input_dev, ABS_Y, CY8CTMG110_Y_MIN, CY8CTMG110_Y_MAX, 0, 0);
+	input_set_abs_params(input_dev, ABS_X,
+			     CY8CTMG110_X_MIN, CY8CTMG110_X_MAX, 0, 0);
+	input_set_abs_params(input_dev, ABS_Y,
+			     CY8CTMG110_Y_MIN, CY8CTMG110_Y_MAX, 0, 0);
 
 	err = gpio_request(CY8CTMG110_RESET_PIN_GPIO, NULL);
 
 	if (err) {
-		dev_err(&client->dev, "cy8ctmg110_ts: Unable to request GPIO pin %d.\n",
-						CY8CTMG110_RESET_PIN_GPIO);
+		dev_err(&client->dev, "Unable to request GPIO pin %d\n",
+			CY8CTMG110_RESET_PIN_GPIO);
 		goto err_free_irq;
 	}
 	cy8ctmg110_power(true);
@@ -385,14 +369,14 @@ static int cy8ctmg110_probe(struct i2c_client *client, const struct i2c_device_i
 	if (polling)
 		hrtimer_start(&ts->timer, ktime_set(10, 0), HRTIMER_MODE_REL);
 
-	/* Can we fall back to polling if these bits fail - something to look
-	   at for robustness */
+	/* Can we fall back to polling if these bits fail?
+	   - something to look at for robustness */
 
 	err = gpio_request(CY8CTMG110_IRQ_PIN_GPIO, "touch_irq_key");
 	if (err < 0) {
 		dev_err(&client->dev,
-			"cy8ctmg110_ts: failed to request GPIO %d, error %d\n",
-						CY8CTMG110_IRQ_PIN_GPIO, err);
+			"failed to request GPIO %d, error %d\n",
+			CY8CTMG110_IRQ_PIN_GPIO, err);
 		goto err_free_timer;
 	}
 
@@ -400,8 +384,8 @@ static int cy8ctmg110_probe(struct i2c_client *client, const struct i2c_device_i
 
 	if (err < 0) {
 		dev_err(&client->dev,
-			"cy8ctmg110_ts: failed to configure input direction for GPIO %d, error %d\n",
-						CY8CTMG110_IRQ_PIN_GPIO, err);
+			"failed to configure input direction for GPIO %d, error %d\n",
+			CY8CTMG110_IRQ_PIN_GPIO, err);
 		goto err_free_gpio;
 	}
 	client->irq = gpio_to_irq(CY8CTMG110_IRQ_PIN_GPIO);
@@ -409,15 +393,16 @@ static int cy8ctmg110_probe(struct i2c_client *client, const struct i2c_device_i
 	if (client->irq < 0) {
 		err = client->irq;
 		dev_err(&client->dev,
-	"cy8ctmg110_ts: Unable to get irq number" " for GPIO %d, error %d\n",
-						CY8CTMG110_IRQ_PIN_GPIO, err);
+			"Unable to get irq number for GPIO %d, error %d\n",
+			CY8CTMG110_IRQ_PIN_GPIO, err);
 		goto err_free_gpio;
 	}
-	err = request_irq(client->irq, cy8ctmg110_irq_handler, IRQF_TRIGGER_RISING | IRQF_SHARED, "touch_reset_key", ts);
+	err = request_irq(client->irq, cy8ctmg110_irq_handler,
+			  IRQF_TRIGGER_RISING | IRQF_SHARED,
+			  "touch_reset_key", ts);
 	if (err < 0) {
 		dev_err(&client->dev,
-			"cy8ctmg110 irq %d busy? error %d\n",
-				client->irq, err);
+			"cy8ctmg110 irq %d busy? error %d\n", client->irq, err);
 		goto err_free_gpio;
 	}
 
@@ -439,9 +424,7 @@ err_free_mem:
 
 /*
  * cy8ctmg110_suspend
- * 
  */
-
 static int cy8ctmg110_suspend(struct i2c_client *client, pm_message_t mesg)
 {
 	if (device_may_wakeup(&client->dev))
@@ -451,10 +434,8 @@ static int cy8ctmg110_suspend(struct i2c_client *client, pm_message_t mesg)
 }
 
 /*
- * cy8ctmg110_resume 
- * 
+ * cy8ctmg110_resume
  */
-
 static int cy8ctmg110_resume(struct i2c_client *client)
 {
 	if (device_may_wakeup(&client->dev))
@@ -465,9 +446,7 @@ static int cy8ctmg110_resume(struct i2c_client *client)
 
 /*
  * cy8ctmg110_remove
- * 
  */
-
 static int cy8ctmg110_remove(struct i2c_client *client)
 {
 	struct cy8ctmg110 *ts = i2c_get_clientdata(client);


