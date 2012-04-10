Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab2DJHRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 03:17:11 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:46930 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab2DJHRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 03:17:09 -0400
Date: Tue, 10 Apr 2012 00:17:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, neilb@suse.de,
        rpurdie@linux.intel.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] LEDS-One-Shot-Timer-Trigger-implementation
Message-ID: <20120410071702.GA5244@core.coreip.homeip.net>
References: <20120406165353.ab667eb0.akpm@linux-foundation.org>
 <1333808024.2728.39.camel@lorien2>
 <20120407215641.GA4539@core.coreip.homeip.net>
 <1333990549.2871.10.camel@lorien2>
 <20120409173703.GA18542@core.coreip.homeip.net>
 <1333995365.2871.17.camel@lorien2>
 <20120409184558.GB18542@core.coreip.homeip.net>
 <1334002847.2871.26.camel@lorien2>
 <20120409204202.GC18542@core.coreip.homeip.net>
 <1334011229.2871.32.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334011229.2871.32.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 04:40:29PM -0600, Shuah Khan wrote:
> On Mon, 2012-04-09 at 13:42 -0700, Dmitry Torokhov wrote:
> > On Mon, Apr 09, 2012 at 02:20:47PM -0600, Shuah Khan wrote:
> > > On Mon, 2012-04-09 at 11:45 -0700, Dmitry Torokhov wrote:
> > > > On Mon, Apr 09, 2012 at 12:16:05PM -0600, Shuah Khan wrote:
> > > > > On Mon, 2012-04-09 at 10:37 -0700, Dmitry Torokhov wrote:
> > > > > > On Mon, Apr 09, 2012 at 10:55:49AM -0600, Shuah Khan wrote:
> > > > > > > On Sat, 2012-04-07 at 14:56 -0700, Dmitry Torokhov wrote:
> > > > > > > > Hi Shuah,
> > > > > > > > 
> > > > > > > > On Sat, Apr 07, 2012 at 08:13:44AM -0600, Shuah Khan wrote:
> > > > > > > > > 
> > > > > > > > > > > +This feature will help implement vibrate functionality which requires one
> > > > > > > > > > > +time activation of vibrate mode without a continuous vibrate on/off cycles.
> > > > > > > > > > 
> > > > > > > > > > They make vibrating LED? ;)
> > > > > > > > > > 
> > > > > > > > > > What's going on here?  You're proposing to repurpose the LEDs code to
> > > > > > > > > > drive vibration devices?  Or some devices couple a LED with a vibration
> > > > > > > > > > device?
> > > > > > > > > 
> > > > > > > > > I owe you filling in the blanks type explanation. Let me describe the
> > > > > > > > > use-case I am trying to address first. Vibrater function on phones is
> > > > > > > > > implemented using PWM pins on SoC or PMIC. When there is no such
> > > > > > > > > hardware present, a software solution is needed. Currently two drivers
> > > > > > > > > timed-gpio and timed-output (under staging/android in Linux 3.3)
> > > > > > > > > together implement the software vibrate feature. The main functionality
> > > > > > > > > it implements is the one time enables of timer to prevent user space
> > > > > > > > > crashes leaving the phone in vibrate mode causing the battery to drain.
> > > > > > > > > leds as it is implemented currently, is not suitable to address this
> > > > > > > > > use-case as it doesn't support one time enables.
> > > > > > > > 
> > > > > > > > So why do not you use memoryless force feedback framework that other
> > > > > > > > devices use (see drivers/input/misc/*vibra.c drivers).
> > > > > > > > 
> > > > > > > 
> > > > > > > Dimitry,
> > > > > > > 
> > > > > > > I took a look at these vibra* drivers. The three vibrate drivers are
> > > > > > > chip-set specific. The use-case I have is a non-chip set approach to
> > > > > > > address the use-case when vibrate hardware is not present. Are you
> > > > > > > envisioning a generic approach using ff-memoryless infrastructure?
> > > > > > 
> > > > > > Shuah,
> > > > > > 
> > > > > > I guess I am confused now. You need some form of hardware to make your
> > > > > > device to vibrate.
> > > > > > 
> > > > > > What exactly are you trying to do? Are you trying to:
> > > > > > 
> > > > > > 1. activate vibration on devices that can actually do it using LED
> > > > > >    interface, or
> > > > > > 
> > > > > > 2. use LEDs as an alternative to vibrate on devices that can't
> > > > > >    physically vibrate?
> > > > > > 
> > > > > > Thanks.
> > > > > 
> > > > > What I meant by generic approach is a higher level interface that is not
> > > > > tied too closely to the underlying hardware. Similar to the leds-pwm.c
> > > > > and leds-gpio.c handle gpio and pwm based leds. The vibrate hardware in
> > > > > my sue-case is a gpio based and could pwm based on some phones.
> > > > 
> > > > Ok, so you need to add drivers/input/misc/gpio-vibrate.c and pwm-vibrate.c
> > > > and then use FF to activate them. This way we have all vibrate
> > > > implementation use one subsystem instead of splitting between
> > > > input/led/whatever else people could come up with.
> > > > 
> > > > Thanks.
> > > > 
> > > 
> > > Dmitry,
> > > 
> > > It is unfortunate that we have these two infrastructures evolve that has
> > > a lot of overlap. Let me summarize the two alternatives first so we get
> > > a feel for the work involved to address this use-case using ff and leds
> > > frameworks:
> > > 
> > > Alternative 1: using leds infrastructure
> > > 
> > > Add new kernel interface to support one time enables. This will enable
> > > existing gpio and pwm drivers to be used to implement vibrate.
> > > 
> > > Alternative 2: using ff infrastructure
> > > 
> > > Add new drivers gpio and pwm that use existing one time enable to
> > > implement vibrate in a generic way.
> > > 
> > > Does this sound right? From a quick glance it sounds like we can get to
> > > the end goal quicker and in a simpler way with Alternative 1. However, I
> > > might be missing longterm view. Any other alternatives we could explore?
> > > 
> > 
> > For 1 you are forgetting "persuade current users of mainline vibrator
> > drivers in kernel to adopt their drivers and userpace to LED framework"
> > because we should try to provide single interface for a given function.
> > 
> > Thanks.
> > 
> 
> Dmitry,
> 
> I can't argue against the user-space angle. Let me give more thought to
> Alternative 2 and see if it indeed turns out to be more work. Thanks for
> a good discussion.

See if the following patch will make the decision a bit easier ;)  It
might need some love as I do not actually have the hardware.

-- 
Dmitry


Input: add support for PWM-based vibrators

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/misc/Kconfig         |   11 ++
 drivers/input/misc/Makefile        |    1 
 drivers/input/misc/pwm-vibrator.c  |  213 ++++++++++++++++++++++++++++++++++++
 include/linux/input/pwm-vibrator.h |   13 ++
 4 files changed, 238 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/misc/pwm-vibrator.c
 create mode 100644 include/linux/input/pwm-vibrator.h


diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index ee077a4..913bdb8 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -451,6 +451,17 @@ config INPUT_PWM_BEEPER
 	  To compile this driver as a module, choose M here: the module will be
 	  called pwm-beeper.
 
+config INPUT_PWM_VIBRATOR
+	tristate "PWM vibrator support"
+	depends on HAVE_PWM
+	help
+	  Say Y here to get support for PWM based vibrator devices.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called pwm-vibrator.
+
 config INPUT_GPIO_ROTARY_ENCODER
 	tristate "Rotary encoders connected to GPIO pins"
 	depends on GPIOLIB && GENERIC_GPIO
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index f55cdf4..e8b7643 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_INPUT_PM8XXX_VIBRATOR)	+= pm8xxx-vibrator.o
 obj-$(CONFIG_INPUT_PMIC8XXX_PWRKEY)	+= pmic8xxx-pwrkey.o
 obj-$(CONFIG_INPUT_POWERMATE)		+= powermate.o
 obj-$(CONFIG_INPUT_PWM_BEEPER)		+= pwm-beeper.o
+obj-$(CONFIG_INPUT_PWM_VIBRATOR)	+= pwm-vibrator.o
 obj-$(CONFIG_INPUT_RB532_BUTTON)	+= rb532_button.o
 obj-$(CONFIG_INPUT_GPIO_ROTARY_ENCODER)	+= rotary_encoder.o
 obj-$(CONFIG_INPUT_SGI_BTNS)		+= sgi_btns.o
diff --git a/drivers/input/misc/pwm-vibrator.c b/drivers/input/misc/pwm-vibrator.c
new file mode 100644
index 0000000..c72bac9
--- /dev/null
+++ b/drivers/input/misc/pwm-vibrator.c
@@ -0,0 +1,213 @@
+/*
+ *  PWM vibrator driver
+ *
+ *  Copyright (C) 2012 Dmitry Torokhov <dmitry.torokhov@gmail.com>
+ *
+ *  Based on PWM beeper driver:
+ *  Copyright (C) 2010, Lars-Peter Clausen <lars@metafoo.de>
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under  the terms of the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the License, or (at your
+ *  option) any later version.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#include <linux/input.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/pwm.h>
+#include <linux/slab.h>
+#include <linux/input/pwm-vibrator.h>
+
+struct pwm_vibrator {
+	struct input_dev *input;
+	struct pwm_device *pwm;
+	unsigned int pwm_period;
+	unsigned int level;
+};
+
+static int pwm_vibrator_start(struct pwm_vibrator *vibrator)
+{
+	unsigned int duty = vibrator->pwm_period * vibrator->level / 100;
+	int error;
+
+	error = pwm_config(vibrator->pwm, duty, vibrator->pwm_period);
+	if (error < 0)
+		return error;
+
+	error = pwm_enable(vibrator->pwm);
+	if (error < 0)
+		return error;
+
+	return 0;
+}
+
+static void pwm_vibrator_stop(struct pwm_vibrator *vibrator)
+{
+	pwm_config(vibrator->pwm, 0, 0);
+	pwm_disable(vibrator->pwm);
+}
+
+static int pwm_vibrator_play_effect(struct input_dev *dev, void *data,
+				    struct ff_effect *effect)
+{
+	struct pwm_vibrator *vibrator = input_get_drvdata(dev);
+	int error;
+
+	vibrator->level = effect->u.rumble.strong_magnitude;
+	if (!vibrator->level)
+		vibrator->level = effect->u.rumble.weak_magnitude;
+
+	if (vibrator->level) {
+		error = pwm_vibrator_start(vibrator);
+		if (error) {
+			dev_err(vibrator->input->dev.parent,
+				"%s: pwm_vibrator_start failed, error: %d\n",
+				__func__, error);
+			return error;
+		}
+	} else {
+		pwm_vibrator_stop(vibrator);
+	}
+
+	return 0;
+}
+
+
+static int __devinit pwm_vibrator_probe(struct platform_device *pdev)
+{
+	const struct pwm_vibrator_platform_data *pdata;
+	struct pwm_vibrator *vibrator;
+	struct input_dev *input;
+	int error;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		dev_err(&pdev->dev, "Missing platform dat\n");
+		return -EINVAL;
+	}
+
+	vibrator = kzalloc(sizeof(*vibrator), GFP_KERNEL);
+	input = input_allocate_device();
+	if (!vibrator || !input) {
+		error = -ENOMEM;
+		goto err_mem_free;
+	}
+
+	vibrator->input = input;
+	vibrator->pwm_period = pdata->pwm_period;
+
+	vibrator->pwm = pwm_request(pdata->pwm_id, "pwm vibrator");
+	if (IS_ERR(vibrator->pwm)) {
+		error = PTR_ERR(vibrator->pwm);
+		dev_err(&pdev->dev, "Failed to request pwm device: %d\n", error);
+		goto err_mem_free;
+	}
+
+	input->name = "pwm-vibrator";
+	input->id.bustype = BUS_HOST;
+	input->dev.parent = &pdev->dev;
+
+	input_set_drvdata(input, vibrator);
+	input_set_capability(input, EV_FF, FF_RUMBLE);
+
+	error = input_ff_create_memless(input, NULL,
+					pwm_vibrator_play_effect);
+	if (error) {
+		dev_err(&pdev->dev,
+			"Unable to create FF device, error: %d\n",
+			error);
+		goto err_pwm_free;
+	}
+
+	error = input_register_device(input);
+	if (error) {
+		dev_err(&pdev->dev, "Failed to register input device: %d\n", error);
+		goto err_pwm_free;
+	}
+
+	platform_set_drvdata(pdev, vibrator);
+
+	return 0;
+
+err_pwm_free:
+	pwm_free(vibrator->pwm);
+err_mem_free:
+	input_free_device(vibrator->input);
+	kfree(vibrator);
+
+	return error;
+}
+
+static int __devexit pwm_vibrator_remove(struct platform_device *pdev)
+{
+	struct pwm_vibrator *vibrator = platform_get_drvdata(pdev);
+
+	platform_set_drvdata(pdev, NULL);
+
+	input_unregister_device(vibrator->input);
+
+	pwm_disable(vibrator->pwm);
+	pwm_free(vibrator->pwm);
+
+	kfree(vibrator);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int pwm_vibrator_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct pwm_vibrator *vibrator = platform_get_drvdata(pdev);
+	struct input_dev *input = vibrator->input;
+	unsigned long flags;
+
+	spin_lock_irqsave(&input->event_lock, flags);
+	if (vibrator->level)
+		pwm_vibrator_stop(vibrator);
+	spin_unlock_irqrestore(&input->event_lock, flags);
+
+	return 0;
+}
+
+static int pwm_vibrator_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct pwm_vibrator *vibrator = platform_get_drvdata(pdev);
+	struct input_dev *input = vibrator->input;
+	unsigned long flags;
+
+	spin_lock_irqsave(&input->event_lock, flags);
+	if (vibrator->level)
+		pwm_vibrator_start(vibrator);
+	spin_unlock_irqrestore(&input->event_lock, flags);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(pwm_vibrator_pm_ops,
+			 pwm_vibrator_suspend, pwm_vibrator_resume);
+
+static struct platform_driver pwm_vibrator_driver = {
+	.probe	= pwm_vibrator_probe,
+	.remove	= __devexit_p(pwm_vibrator_remove),
+	.driver	= {
+		.name	= "pwm-vibrator",
+		.owner	= THIS_MODULE,
+		.pm	= &pwm_vibrator_pm_ops,
+	},
+};
+module_platform_driver(pwm_vibrator_driver);
+
+MODULE_AUTHOR("Dmitry Torokhov <dmitry.torokhov@gmail.com>");
+MODULE_DESCRIPTION("PWM vibrator driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pwm-vibrator");
diff --git a/include/linux/input/pwm-vibrator.h b/include/linux/input/pwm-vibrator.h
new file mode 100644
index 0000000..efe1f72
--- /dev/null
+++ b/include/linux/input/pwm-vibrator.h
@@ -0,0 +1,13 @@
+#ifndef __INPUT_PWM_VIBRATOR_H
+#define __INPUT_PWM_VIBRATOR_H
+
+/*
+ * PWM vibrator driver data
+ */
+
+struct pwm_vibrator_platform_data {
+	unsigned int pwm_id;
+	unsigned int pwm_period;
+};
+
+#endif
