Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161341Ab2CSGGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:06:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56589 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab2CSGGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 02:06:19 -0400
Date: Sun, 18 Mar 2012 23:06:11 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com, david@protonic.nl,
        tklauser@distanz.ch, alexander.stein@informatik.tu-chemnitz.de,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1] input: keyboard: gpio: Support for interrupt only key
Message-ID: <20120319060610.GA8835@core.coreip.homeip.net>
References: <1331715123-15099-1-git-send-email-ldewangan@nvidia.com>
 <20120314160011.GA12987@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <20120314160011.GA12987@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 14, 2012 at 09:00:11AM -0700, Dmitry Torokhov wrote:
> Hi Laxman,
> 
> On Wed, Mar 14, 2012 at 02:22:03PM +0530, Laxman Dewangan wrote:
> > Some of key in system generates interrupt only when it
> > pressed like power-on key or onkey. These keys do not
> > actually mapped as gpio in system.
> > Supporting the key pressed event on such keys which are
> > not actually gpio keys but generates interrupt only.
> > 
> > Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> > ---
> > When I pushed the new driver for interrupt key, the suggestion came
> > to include this functionality in the gpio-key driver. I added require
> > changed in gpio-keys.c to support interrupt key only.
> > 
> 
> This looks much much better than a whole new driver. Let me look it over
> in more detail and get back to you.

OK, so I am generally happy with the patch; the only issue is that in
interrupt mode the only event type that makes sense is EV_KEY so we need
to make sure we do not accept anything else.

Also, I do not think that having button_irq() that is called all the
time is the best solution; I;d rather pulled RQ number up into button
data.

I tried doing the above in the patch below. Please let me know if it
still works for you. Note that it depends on some other patches for
gpio_keys that I have; I am attaching them for your reference.

Thanks.

-- 
Dmitry

Input: gpio_keys - add support for interrupt only keys

From: Laxman Dewangan <ldewangan@nvidia.com>

Some of buttons, like power-on key or onkey, may only generate interrupts
when pressed and not actually be mapped as gpio in the system. Allow
setting gpio to invalid value and specify IRQ instead to support such
keys. The debounce timer is used not to debounce but to ignore new IRQs
coming while button is kept pressed.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/gpio_keys.c |  196 +++++++++++++++++++++++++-----------
 include/linux/gpio_keys.h          |    3 -
 2 files changed, 139 insertions(+), 60 deletions(-)


diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 8f44f7b..5d369c2 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -28,14 +28,18 @@
 #include <linux/gpio.h>
 #include <linux/of_platform.h>
 #include <linux/of_gpio.h>
+#include <linux/spinlock.h>
 
 struct gpio_button_data {
 	const struct gpio_keys_button *button;
 	struct input_dev *input;
 	struct timer_list timer;
 	struct work_struct work;
-	int timer_debounce;	/* in msecs */
+	unsigned int timer_debounce;	/* in msecs */
+	unsigned int irq;
+	spinlock_t lock;
 	bool disabled;
+	bool key_pressed;
 };
 
 struct gpio_keys_drvdata {
@@ -114,7 +118,7 @@ static void gpio_keys_disable_button(struct gpio_button_data *bdata)
 		/*
 		 * Disable IRQ and possible debouncing timer.
 		 */
-		disable_irq(gpio_to_irq(bdata->button->gpio));
+		disable_irq(bdata->irq);
 		if (bdata->timer_debounce)
 			del_timer_sync(&bdata->timer);
 
@@ -135,7 +139,7 @@ static void gpio_keys_disable_button(struct gpio_button_data *bdata)
 static void gpio_keys_enable_button(struct gpio_button_data *bdata)
 {
 	if (bdata->disabled) {
-		enable_irq(gpio_to_irq(bdata->button->gpio));
+		enable_irq(bdata->irq);
 		bdata->disabled = false;
 	}
 }
@@ -344,19 +348,18 @@ static void gpio_keys_work_func(struct work_struct *work)
 	gpio_keys_report_event(bdata);
 }
 
-static void gpio_keys_timer(unsigned long _data)
+static void gpio_keys_gpio_timer(unsigned long _data)
 {
-	struct gpio_button_data *data = (struct gpio_button_data *)_data;
+	struct gpio_button_data *bdata = (struct gpio_button_data *)_data;
 
-	schedule_work(&data->work);
+	schedule_work(&bdata->work);
 }
 
-static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
+static irqreturn_t gpio_keys_gpio_isr(int irq, void *dev_id)
 {
 	struct gpio_button_data *bdata = dev_id;
-	const struct gpio_keys_button *button = bdata->button;
 
-	BUG_ON(irq != gpio_to_irq(button->gpio));
+	BUG_ON(irq != bdata->irq);
 
 	if (bdata->timer_debounce)
 		mod_timer(&bdata->timer,
@@ -367,6 +370,53 @@ static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static void gpio_keys_irq_timer(unsigned long _data)
+{
+	struct gpio_button_data *bdata = (struct gpio_button_data *)_data;
+	struct input_dev *input = bdata->input;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bdata->lock, flags);
+	if (bdata->key_pressed) {
+		input_event(input, EV_KEY, bdata->button->code, 0);
+		input_sync(input);
+		bdata->key_pressed = false;
+	}
+	spin_unlock_irqrestore(&bdata->lock, flags);
+}
+
+static irqreturn_t gpio_keys_irq_isr(int irq, void *dev_id)
+{
+	struct gpio_button_data *bdata = dev_id;
+	const struct gpio_keys_button *button = bdata->button;
+	struct input_dev *input = bdata->input;
+	unsigned long flags;
+
+	BUG_ON(irq != bdata->irq);
+
+	spin_lock_irqsave(&bdata->lock, flags);
+
+	if (!bdata->key_pressed) {
+		input_event(input, EV_KEY, button->code, 1);
+		input_sync(input);
+
+		if (!bdata->timer_debounce) {
+			input_event(input, EV_KEY, button->code, 0);
+			input_sync(input);
+			goto out;
+		}
+
+		bdata->key_pressed = true;
+	}
+
+	if (bdata->timer_debounce)
+		mod_timer(&bdata->timer,
+			jiffies + msecs_to_jiffies(bdata->timer_debounce));
+out:
+	spin_unlock_irqrestore(&bdata->lock, flags);
+	return IRQ_HANDLED;
+}
+
 static int __devinit gpio_keys_setup_key(struct platform_device *pdev,
 					 struct input_dev *input,
 					 struct gpio_button_data *bdata,
@@ -374,46 +424,79 @@ static int __devinit gpio_keys_setup_key(struct platform_device *pdev,
 {
 	const char *desc = button->desc ? button->desc : "gpio_keys";
 	struct device *dev = &pdev->dev;
+	irq_handler_t isr;
 	unsigned long irqflags;
 	int irq, error;
 
-	setup_timer(&bdata->timer, gpio_keys_timer, (unsigned long)bdata);
-	INIT_WORK(&bdata->work, gpio_keys_work_func);
 	bdata->input = input;
 	bdata->button = button;
+	spin_lock_init(&bdata->lock);
+	INIT_WORK(&bdata->work, gpio_keys_work_func);
 
-	error = gpio_request(button->gpio, desc);
-	if (error < 0) {
-		dev_err(dev, "failed to request GPIO %d, error %d\n",
-			button->gpio, error);
-		goto fail2;
-	}
+	if (gpio_is_valid(button->gpio)) {
 
-	error = gpio_direction_input(button->gpio);
-	if (error < 0) {
-		dev_err(dev, "failed to configure"
-			" direction for GPIO %d, error %d\n",
-			button->gpio, error);
-		goto fail3;
-	}
+		error = gpio_request(button->gpio, desc);
+		if (error < 0) {
+			dev_err(dev, "Failed to request GPIO %d, error %d\n",
+				button->gpio, error);
+			return error;
+		}
 
-	if (button->debounce_interval) {
-		error = gpio_set_debounce(button->gpio,
-					  button->debounce_interval * 1000);
-		/* use timer if gpiolib doesn't provide debounce */
-		if (error < 0)
-			bdata->timer_debounce = button->debounce_interval;
-	}
+		error = gpio_direction_input(button->gpio);
+		if (error < 0) {
+			dev_err(dev,
+				"Failed to configure direction for GPIO %d, error %d\n",
+				button->gpio, error);
+			goto fail;
+		}
 
-	irq = gpio_to_irq(button->gpio);
-	if (irq < 0) {
-		error = irq;
-		dev_err(dev, "Unable to get irq number for GPIO %d, error %d\n",
-			button->gpio, error);
-		goto fail3;
+		if (button->debounce_interval) {
+			error = gpio_set_debounce(button->gpio,
+					button->debounce_interval * 1000);
+			/* use timer if gpiolib doesn't provide debounce */
+			if (error < 0)
+				bdata->timer_debounce =
+						button->debounce_interval;
+		}
+
+		irq = gpio_to_irq(button->gpio);
+		if (irq < 0) {
+			error = irq;
+			dev_err(dev,
+				"Unable to get irq number for GPIO %d, error %d\n",
+				button->gpio, error);
+			goto fail;
+		}
+		bdata->irq = irq;
+
+		setup_timer(&bdata->timer,
+			    gpio_keys_gpio_timer, (unsigned long)bdata);
+
+		isr = gpio_keys_gpio_isr;
+		irqflags = IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING;
+
+	} else {
+		if (!button->irq) {
+			dev_err(dev, "No IRQ specified\n");
+			return -EINVAL;
+		}
+		bdata->irq = button->irq;
+
+		if (button->type && button->type != EV_KEY) {
+			dev_err(dev, "Only EV_KEY allowed for IRQ buttons.\n");
+			return -EINVAL;
+		}
+
+		bdata->timer_debounce = button->debounce_interval;
+		setup_timer(&bdata->timer,
+			    gpio_keys_irq_timer, (unsigned long)bdata);
+
+		isr = gpio_keys_irq_isr;
+		irqflags = 0;
 	}
 
-	irqflags = IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING;
+	input_set_capability(input, button->type ?: EV_KEY, button->code);
+
 	/*
 	 * If platform has specified that the button can be disabled,
 	 * we don't want it to share the interrupt line.
@@ -421,19 +504,19 @@ static int __devinit gpio_keys_setup_key(struct platform_device *pdev,
 	if (!button->can_disable)
 		irqflags |= IRQF_SHARED;
 
-	error = request_any_context_irq(irq, gpio_keys_isr, irqflags, desc, bdata);
+	error = request_any_context_irq(bdata->irq, isr, irqflags, desc, bdata);
 	if (error < 0) {
 		dev_err(dev, "Unable to claim irq %d; error %d\n",
-			irq, error);
-		goto fail3;
+			bdata->irq, error);
+		goto fail;
 	}
 
-	input_set_capability(input, button->type ?: EV_KEY, button->code);
 	return 0;
 
-fail3:
-	gpio_free(button->gpio);
-fail2:
+fail:
+	if (gpio_is_valid(button->gpio))
+		gpio_free(button->gpio);
+
 	return error;
 }
 
@@ -553,11 +636,12 @@ static int gpio_keys_get_devtree_pdata(struct device *dev,
 
 static void gpio_remove_key(struct gpio_button_data *bdata)
 {
-	free_irq(gpio_to_irq(bdata->button->gpio), bdata);
+	free_irq(bdata->irq, bdata);
 	if (bdata->timer_debounce)
 		del_timer_sync(&bdata->timer);
 	cancel_work_sync(&bdata->work);
-	gpio_free(bdata->button->gpio);
+	if (gpio_is_valid(bdata->button->gpio))
+		gpio_free(bdata->button->gpio);
 }
 
 static int __devinit gpio_keys_probe(struct platform_device *pdev)
@@ -695,16 +779,13 @@ static int __devexit gpio_keys_remove(struct platform_device *pdev)
 static int gpio_keys_suspend(struct device *dev)
 {
 	struct gpio_keys_drvdata *ddata = dev_get_drvdata(dev);
-	const struct gpio_keys_button *button;
 	int i;
 
 	if (device_may_wakeup(dev)) {
 		for (i = 0; i < ddata->n_buttons; i++) {
-			button = ddata->data[i].button;
-			if (button->wakeup) {
-				int irq = gpio_to_irq(button->gpio);
-				enable_irq_wake(irq);
-			}
+			struct gpio_button_data *bdata = &ddata->data[i];
+			if (bdata->button->wakeup)
+				enable_irq_wake(bdata->irq);
 		}
 	}
 
@@ -714,15 +795,12 @@ static int gpio_keys_suspend(struct device *dev)
 static int gpio_keys_resume(struct device *dev)
 {
 	struct gpio_keys_drvdata *ddata = dev_get_drvdata(dev);
-	const struct gpio_keys_button *button;
 	int i;
 
 	for (i = 0; i < ddata->n_buttons; i++) {
-		button = ddata->data[i].button;
-		if (button->wakeup && device_may_wakeup(dev)) {
-			int irq = gpio_to_irq(button->gpio);
-			disable_irq_wake(irq);
-		}
+		struct gpio_button_data *bdata = &ddata->data[i];
+		if (bdata->button->wakeup && device_may_wakeup(dev))
+			disable_irq_wake(bdata->irq);
 
 		gpio_keys_report_event(&ddata->data[i]);
 	}
diff --git a/include/linux/gpio_keys.h b/include/linux/gpio_keys.h
index 004ff33..a7e977f 100644
--- a/include/linux/gpio_keys.h
+++ b/include/linux/gpio_keys.h
@@ -6,7 +6,7 @@ struct device;
 struct gpio_keys_button {
 	/* Configuration parameters */
 	unsigned int code;	/* input event code (KEY_*, SW_*) */
-	int gpio;
+	int gpio;		/* -1 if this key does not support gpio */
 	int active_low;
 	const char *desc;
 	unsigned int type;	/* input event type (EV_KEY, EV_SW, EV_ABS) */
@@ -14,6 +14,7 @@ struct gpio_keys_button {
 	int debounce_interval;	/* debounce ticks interval in msecs */
 	bool can_disable;
 	int value;		/* axis value for EV_ABS */
+	unsigned int irq;	/* Irq number in case of interrupt keys */
 };
 
 struct gpio_keys_platform_data {

--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="gpio-keys-const.patch"

Input: gpio_keys - constify platform data

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

The platform data should not be altered and therefore should be
accessed through const pointers.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/gpio_keys.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)


diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index ed1ed46..19887fc 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -30,7 +30,7 @@
 #include <linux/of_gpio.h>
 
 struct gpio_button_data {
-	struct gpio_keys_button *button;
+	const struct gpio_keys_button *button;
 	struct input_dev *input;
 	struct timer_list timer;
 	struct work_struct work;
@@ -322,7 +322,7 @@ static struct attribute_group gpio_keys_attr_group = {
 
 static void gpio_keys_report_event(struct gpio_button_data *bdata)
 {
-	struct gpio_keys_button *button = bdata->button;
+	const struct gpio_keys_button *button = bdata->button;
 	struct input_dev *input = bdata->input;
 	unsigned int type = button->type ?: EV_KEY;
 	int state = (gpio_get_value_cansleep(button->gpio) ? 1 : 0) ^ button->active_low;
@@ -354,7 +354,7 @@ static void gpio_keys_timer(unsigned long _data)
 static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
 {
 	struct gpio_button_data *bdata = dev_id;
-	struct gpio_keys_button *button = bdata->button;
+	const struct gpio_keys_button *button = bdata->button;
 
 	BUG_ON(irq != gpio_to_irq(button->gpio));
 
@@ -368,8 +368,9 @@ static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
 }
 
 static int __devinit gpio_keys_setup_key(struct platform_device *pdev,
+					 struct input_dev *input,
 					 struct gpio_button_data *bdata,
-					 struct gpio_keys_button *button)
+					 const struct gpio_keys_button *button)
 {
 	const char *desc = button->desc ? button->desc : "gpio_keys";
 	struct device *dev = &pdev->dev;
@@ -378,6 +379,8 @@ static int __devinit gpio_keys_setup_key(struct platform_device *pdev,
 
 	setup_timer(&bdata->timer, gpio_keys_timer, (unsigned long)bdata);
 	INIT_WORK(&bdata->work, gpio_keys_work_func);
+	bdata->input = input;
+	bdata->button = button;
 
 	error = gpio_request(button->gpio, desc);
 	if (error < 0) {
@@ -425,6 +428,7 @@ static int __devinit gpio_keys_setup_key(struct platform_device *pdev,
 		goto fail3;
 	}
 
+	input_set_capability(input, button->type ?: EV_KEY, button->code);
 	return 0;
 
 fail3:
@@ -549,7 +553,7 @@ static int gpio_keys_get_devtree_pdata(struct device *dev,
 
 static int __devinit gpio_keys_probe(struct platform_device *pdev)
 {
-	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
+	const struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
 	struct gpio_keys_drvdata *ddata;
 	struct device *dev = &pdev->dev;
 	struct gpio_keys_platform_data alt_pdata;
@@ -599,21 +603,15 @@ static int __devinit gpio_keys_probe(struct platform_device *pdev)
 		__set_bit(EV_REP, input->evbit);
 
 	for (i = 0; i < pdata->nbuttons; i++) {
-		struct gpio_keys_button *button = &pdata->buttons[i];
+		const struct gpio_keys_button *button = &pdata->buttons[i];
 		struct gpio_button_data *bdata = &ddata->data[i];
-		unsigned int type = button->type ?: EV_KEY;
 
-		bdata->input = input;
-		bdata->button = button;
-
-		error = gpio_keys_setup_key(pdev, bdata, button);
+		error = gpio_keys_setup_key(pdev, input, bdata, button);
 		if (error)
 			goto fail2;
 
 		if (button->wakeup)
 			wakeup = 1;
-
-		input_set_capability(input, type, button->code);
 	}
 
 	error = sysfs_create_group(&pdev->dev.kobj, &gpio_keys_attr_group);
@@ -699,11 +697,12 @@ static int __devexit gpio_keys_remove(struct platform_device *pdev)
 static int gpio_keys_suspend(struct device *dev)
 {
 	struct gpio_keys_drvdata *ddata = dev_get_drvdata(dev);
+	const struct gpio_keys_button *button;
 	int i;
 
 	if (device_may_wakeup(dev)) {
 		for (i = 0; i < ddata->n_buttons; i++) {
-			struct gpio_keys_button *button = ddata->data[i].button;
+			button = ddata->data[i].button;
 			if (button->wakeup) {
 				int irq = gpio_to_irq(button->gpio);
 				enable_irq_wake(irq);
@@ -717,11 +716,11 @@ static int gpio_keys_suspend(struct device *dev)
 static int gpio_keys_resume(struct device *dev)
 {
 	struct gpio_keys_drvdata *ddata = dev_get_drvdata(dev);
+	const struct gpio_keys_button *button;
 	int i;
 
 	for (i = 0; i < ddata->n_buttons; i++) {
-
-		struct gpio_keys_button *button = ddata->data[i].button;
+		button = ddata->data[i].button;
 		if (button->wakeup && device_may_wakeup(dev)) {
 			int irq = gpio_to_irq(button->gpio);
 			disable_irq_wake(irq);

--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="gpio_keys-request-any-context-irq.patch"

Input: revert "gpio_keys - switch to using threaded IRQs"

From: David Jander <david@protonic.nl>

request_any_context_irq() should handle the case when using GPIO expanders
that themselves use threaded IRQs, and so the premise of change
7e2ecdf438bb479e2b4667fc16b1a84d6348da04 is incorrect.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/gpio_keys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 19887fc..6f06758 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -421,7 +421,7 @@ static int __devinit gpio_keys_setup_key(struct platform_device *pdev,
 	if (!button->can_disable)
 		irqflags |= IRQF_SHARED;
 
-	error = request_threaded_irq(irq, NULL, gpio_keys_isr, irqflags, desc, bdata);
+	error = request_any_context_irq(irq, gpio_keys_isr, irqflags, desc, bdata);
 	if (error < 0) {
 		dev_err(dev, "Unable to claim irq %d; error %d\n",
 			irq, error);

--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="gpio_keys-rework-unwind.patch"

Input: gpio_keys - consolidate key destructor code

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/gpio_keys.c |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)


diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 6f06758..8f44f7b 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -195,7 +195,7 @@ static ssize_t gpio_keys_attr_show_helper(struct gpio_keys_drvdata *ddata,
  * @type: button type (%EV_KEY, %EV_SW)
  *
  * This function parses stringified bitmap from @buf and disables/enables
- * GPIO buttons accordinly. Returns 0 on success and negative error
+ * GPIO buttons accordingly. Returns 0 on success and negative error
  * on failure.
  */
 static ssize_t gpio_keys_attr_store_helper(struct gpio_keys_drvdata *ddata,
@@ -551,6 +551,15 @@ static int gpio_keys_get_devtree_pdata(struct device *dev,
 
 #endif
 
+static void gpio_remove_key(struct gpio_button_data *bdata)
+{
+	free_irq(gpio_to_irq(bdata->button->gpio), bdata);
+	if (bdata->timer_debounce)
+		del_timer_sync(&bdata->timer);
+	cancel_work_sync(&bdata->work);
+	gpio_free(bdata->button->gpio);
+}
+
 static int __devinit gpio_keys_probe(struct platform_device *pdev)
 {
 	const struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
@@ -640,13 +649,8 @@ static int __devinit gpio_keys_probe(struct platform_device *pdev)
  fail3:
 	sysfs_remove_group(&pdev->dev.kobj, &gpio_keys_attr_group);
  fail2:
-	while (--i >= 0) {
-		free_irq(gpio_to_irq(pdata->buttons[i].gpio), &ddata->data[i]);
-		if (ddata->data[i].timer_debounce)
-			del_timer_sync(&ddata->data[i].timer);
-		cancel_work_sync(&ddata->data[i].work);
-		gpio_free(pdata->buttons[i].gpio);
-	}
+	while (--i >= 0)
+		gpio_remove_key(&ddata->data[i]);
 
 	platform_set_drvdata(pdev, NULL);
  fail1:
@@ -669,14 +673,8 @@ static int __devexit gpio_keys_remove(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, 0);
 
-	for (i = 0; i < ddata->n_buttons; i++) {
-		int irq = gpio_to_irq(ddata->data[i].button->gpio);
-		free_irq(irq, &ddata->data[i]);
-		if (ddata->data[i].timer_debounce)
-			del_timer_sync(&ddata->data[i].timer);
-		cancel_work_sync(&ddata->data[i].work);
-		gpio_free(ddata->data[i].button->gpio);
-	}
+	for (i = 0; i < ddata->n_buttons; i++)
+		gpio_remove_key(&ddata->data[i]);
 
 	input_unregister_device(input);
 

--T4sUOijqQbZv57TR--
