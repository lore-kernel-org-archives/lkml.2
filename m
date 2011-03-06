Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab1CFERP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 23:17:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33915 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab1CFEQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 23:16:51 -0500
From: Bill Gatliff <bgat@billgatliff.com>
To: linux-kernel@vger.kernel.org
Cc: Bill Gatliff <bgat@billgatliff.com>
Subject: [PWM v6 2/3] PWM: GPIO+hrtimer device emulation
Date: Sat,  5 Mar 2011 22:17:29 -0600
Message-Id: <1299385050-13674-3-git-send-email-bgat@billgatliff.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299385050-13674-1-git-send-email-bgat@billgatliff.com>
References: <1299385050-13674-1-git-send-email-bgat@billgatliff.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emulates a PWM device using a GPIO pin and an hrtimer.  Subject
to CPU, scheduler and hardware limitations, can support many
PWM outputs, e.g. as many as you have GPIO pins available for.

On a 200 MHz ARM9 processor, a PWM frequency of 100 Hz can be attained
with this code so long as the duty cycle remains between about 20-80%.
At higher or lower duty cycles, the transition events may arrive too
close for the scheduler and CPU to reliably service.

This driver supports creation of new GPIO+hrtimer PWM devices via
configfs:

   # mount config /config -t configfs
   # mkdir /config/gpio-pwm/<gpio number>

The new PWM device will appear as /sys/class/pwm/gpio-pwm.<gpio number>.

Caveats:
   * The GPIO pin number must be valid, not already in use
   * The output state of the GPIO pin is configured when the PWM starts
     running i.e. not immediately upon request, because the polarity of
     the inactive state of the pin isn't known until the pwm device's
     'polarity' attribute is configured
   * After creating and binding the pwm device, you must then request
     it by reading from /sys/class/pwm/gpio-pwm.<gpio number>/request

Unbind and destroy the pwm device by first stopping and unrequesting
the pwm device under sysfs as usual; then do:

   # rm -rf /config/gpio-pwm/<gpio number>

Signed-off-by: Bill Gatliff <bgat@billgatliff.com>
---
 drivers/pwm/Kconfig    |   11 ++
 drivers/pwm/Makefile   |    2 +
 drivers/pwm/gpio-pwm.c |  348 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 361 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pwm/gpio-pwm.c

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index bc550f7..476de67 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -8,3 +8,14 @@ menuconfig GENERIC_PWM
 	  Enables PWM device support implemented via a generic
 	  framework.  If unsure, say N.
 
+config GPIO_PWM
+       tristate "GPIO+hrtimer PWM device emulation"
+       depends on GENERIC_PWM
+       help
+         When enabled, this feature emulates single-channel PWM
+	 devices using high-resolution timers and GPIO pins.  You may
+	 create as many of these devices as desired, subject to CPU
+	 throughput limitations and GPIO pin availability.
+
+	 To compile this feature as a module, chose M here; the module
+	 will be called gpio-pwm.  If unsure, say N.
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index 7baa201..ecec3e4 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -2,3 +2,5 @@
 # Makefile for pwm devices
 #
 obj-$(CONFIG_GENERIC_PWM) := pwm.o
+
+obj-$(CONFIG_GPIO_PWM)		+= gpio-pwm.o
diff --git a/drivers/pwm/gpio-pwm.c b/drivers/pwm/gpio-pwm.c
new file mode 100644
index 0000000..39e2dc6
--- /dev/null
+++ b/drivers/pwm/gpio-pwm.c
@@ -0,0 +1,348 @@
+/*
+ * Emulates a PWM device using an hrtimer and GPIO pin
+ *
+ * Copyright (C) 2011 Bill Gatliff <bgat@billgatliff.com>
+ *
+ * This program is free software; you may redistribute and/or modify
+ * it under the terms of the GNU General Public License Version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+ * USA
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/hrtimer.h>
+#include <linux/err.h>
+#include <linux/workqueue.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+#include <linux/completion.h>
+#include <linux/configfs.h>
+#include <linux/pwm/pwm.h>
+
+#define DRIVER_NAME KBUILD_MODNAME
+
+struct gpio_pwm {
+	struct pwm_device pwm;
+	struct hrtimer t;
+	struct work_struct work;
+	spinlock_t lock;
+	struct completion complete;
+	int gpio;
+	int callback;
+	unsigned long polarity : 1;
+	unsigned long active : 1;
+	char name[16];
+};
+
+static inline struct gpio_pwm *to_gpio_pwm(const struct pwm_device *p)
+{
+	return container_of(p, struct gpio_pwm, pwm);
+}
+
+static void gpio_pwm_work(struct work_struct *work)
+{
+	struct gpio_pwm *gp = container_of(work, struct gpio_pwm, work);
+
+	gpio_direction_output(gp->gpio, !(!!gp->polarity ^ !!gp->active));
+}
+
+static enum hrtimer_restart gpio_pwm_timeout(struct hrtimer *t)
+{
+	struct gpio_pwm *gp = container_of(t, struct gpio_pwm, t);
+	struct pwm_device *p = &gp->pwm;
+
+	if (unlikely(p->duty_ticks == 0))
+		gp->active = 0;
+	else if (unlikely(p->duty_ticks == p->period_ticks))
+		gp->active = 1;
+	else
+		gp->active ^= 1;
+
+	if (gpio_cansleep(gp->gpio))
+		schedule_work(&gp->work);
+	else
+		gpio_pwm_work(&gp->work);
+
+	if (!gp->active && gp->callback)
+		pwm_callback(p);
+
+	if (unlikely(!gp->active && test_bit(FLAG_STOP, &p->flags))) {
+		clear_bit(FLAG_STOP, &p->flags);
+		complete_all(&gp->complete);
+		goto done;
+	}
+
+	if (gp->active)
+		hrtimer_forward_now(&gp->t, ktime_set(0, p->duty_ticks));
+	else
+		hrtimer_forward_now(&gp->t, ktime_set(0, p->period_ticks
+						      - p->duty_ticks));
+
+done:
+	return HRTIMER_RESTART;
+}
+
+static void gpio_pwm_start(struct pwm_device *p)
+{
+	struct gpio_pwm *gp = to_gpio_pwm(p);
+
+	gp->active = 0;
+	hrtimer_start(&gp->t, ktime_set(0, p->period_ticks - p->duty_ticks),
+		      HRTIMER_MODE_REL);
+	set_bit(FLAG_RUNNING, &p->flags);
+}
+
+static int gpio_pwm_config_nosleep(struct pwm_device *p, struct pwm_config *c)
+{
+	struct gpio_pwm *gp = to_gpio_pwm(p);
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&gp->lock, flags);
+
+	switch (c->config_mask) {
+
+	case BIT(PWM_CONFIG_DUTY_TICKS):
+		p->duty_ticks = c->duty_ticks;
+		break;
+
+	case BIT(PWM_CONFIG_START):
+		if (!hrtimer_active(&gp->t)) {
+			gpio_pwm_start(p);
+		}
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	spin_unlock_irqrestore(&gp->lock, flags);
+	return ret;
+}
+
+static int gpio_pwm_stop_sync(struct pwm_device *p)
+{
+	struct gpio_pwm *gp = to_gpio_pwm(p);
+	int ret;
+	int was_on = hrtimer_active(&gp->t);
+
+	if (was_on) {
+		do {
+			init_completion(&gp->complete);
+			set_bit(FLAG_STOP, &p->flags);
+			ret = wait_for_completion_interruptible(&gp->complete);
+			if (ret)
+				return ret;
+		} while (test_bit(FLAG_STOP, &p->flags));
+	}
+
+	clear_bit(FLAG_RUNNING, &p->flags);
+
+	return was_on;
+}
+
+static int gpio_pwm_config(struct pwm_device *p, struct pwm_config *c)
+{
+	struct gpio_pwm *gp = to_gpio_pwm(p);
+	int was_on = 0;
+
+	if (p->ops->config_nosleep) {
+		if (!p->ops->config_nosleep(p, c))
+			return 0;
+	}
+
+	might_sleep();
+
+	was_on = gpio_pwm_stop_sync(p);
+	if (was_on < 0)
+		return was_on;
+
+	if (test_bit(PWM_CONFIG_ENABLE_CALLBACK, &c->config_mask))
+		gp->callback = 1;
+	if (test_bit(PWM_CONFIG_DISABLE_CALLBACK, &c->config_mask))
+		gp->callback = 0;
+	
+	if (test_bit(PWM_CONFIG_PERIOD_TICKS, &c->config_mask))
+		p->period_ticks = c->period_ticks;
+	if (test_bit(PWM_CONFIG_DUTY_TICKS, &c->config_mask))
+		p->duty_ticks = c->duty_ticks;
+	if (test_bit(PWM_CONFIG_POLARITY, &c->config_mask))
+		gp->polarity = !!c->polarity;
+
+	if (test_bit(PWM_CONFIG_START, &c->config_mask)
+	    || (was_on && !test_bit(PWM_CONFIG_STOP, &c->config_mask)))
+		gpio_pwm_start(p);
+
+	return 0;
+}
+
+static int gpio_pwm_request(struct pwm_device *p)
+{
+	p->tick_hz = 1000000000UL;
+	return 0;
+}
+
+static const struct pwm_device_ops gpio_pwm_device_ops = {
+	.config		= gpio_pwm_config,
+	.config_nosleep	= gpio_pwm_config_nosleep,
+	.request	= gpio_pwm_request,
+};
+
+struct pwm_device *gpio_pwm_create(int gpio)
+{
+	struct gpio_pwm *gp;
+	int ret = 0;
+
+	if (!gpio_is_valid(gpio))
+		return ERR_PTR(-EINVAL);
+
+	if (gpio_request(gpio, DRIVER_NAME))
+		return ERR_PTR(-EBUSY);
+
+	gp = kzalloc(sizeof(*gp), GFP_KERNEL);
+	if (!gp)
+		goto err_alloc;
+
+	pwm_set_drvdata(&gp->pwm, gp);
+	gp->pwm.ops = &gpio_pwm_device_ops;
+	gp->gpio = gpio;
+
+	INIT_WORK(&gp->work, gpio_pwm_work);
+	init_completion(&gp->complete);
+	hrtimer_init(&gp->t, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	gp->t.function = gpio_pwm_timeout;
+
+	scnprintf(gp->name, sizeof(gp->name), "%s:%d", DRIVER_NAME, gpio);
+	ret = pwm_register_byname(&gp->pwm, NULL, gp->name);
+	if (ret)
+		goto err_pwm_register;
+
+	return &gp->pwm;
+
+err_pwm_register:
+	kfree(gp);
+err_alloc:
+	gpio_free(gpio);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL(gpio_pwm_create);
+
+int gpio_pwm_destroy(struct pwm_device *p)
+{
+	struct gpio_pwm *gp = pwm_get_drvdata(p);
+
+	if (pwm_is_requested(&gp->pwm)) {
+		if (pwm_is_running(&gp->pwm))
+			pwm_stop(&gp->pwm);
+		pwm_release(&gp->pwm);
+	}
+	hrtimer_cancel(&gp->t);
+	cancel_work_sync(&gp->work);
+
+	pwm_unregister(&gp->pwm);
+	gpio_free(gp->gpio);
+	kfree(gp);
+
+	return 0;
+}
+EXPORT_SYMBOL(gpio_pwm_destroy);
+
+#ifdef CONFIG_CONFIGFS_FS
+struct gpio_pwm_target {
+	struct config_item item;
+	struct pwm_device *p;
+};
+
+static struct config_item_type gpio_pwm_item_type = {
+	.ct_owner = THIS_MODULE,
+};
+
+static struct config_item *make_gpio_pwm_target(struct config_group *group,
+						const char *name)
+{
+	struct gpio_pwm_target *t;
+	unsigned long gpio;
+	int ret;
+
+	t = kzalloc(sizeof(*t), GFP_KERNEL);
+	if (!t)
+		return ERR_PTR(-ENOMEM);
+
+	ret = strict_strtoul(name, 10, &gpio);
+	if (ret || !gpio_is_valid(gpio)) {
+		ret = -EINVAL;
+		goto err_invalid_gpio;
+	}
+
+	config_item_init_type_name(&t->item, name, &gpio_pwm_item_type);
+
+	t->p = gpio_pwm_create(gpio);
+	if (IS_ERR_OR_NULL(t->p))
+		goto err_gpio_pwm_create;
+
+	return &t->item;
+
+err_gpio_pwm_create:
+err_invalid_gpio:
+	kfree(t);
+	return ERR_PTR(ret);
+}
+
+static void drop_gpio_pwm_target(struct config_group *group,
+				 struct config_item *item)
+{
+	struct gpio_pwm_target *t =
+		container_of(item, struct gpio_pwm_target, item);
+
+	gpio_pwm_destroy(t->p);
+	config_item_put(&t->item);
+	kfree(t);
+}
+
+static struct configfs_group_operations gpio_pwm_subsys_group_ops = {
+	.make_item = make_gpio_pwm_target,
+	.drop_item = drop_gpio_pwm_target,
+};
+
+static struct config_item_type gpio_pwm_subsys_type = {
+	.ct_group_ops = &gpio_pwm_subsys_group_ops,
+	.ct_owner = THIS_MODULE,
+};
+
+static struct configfs_subsystem gpio_pwm_subsys = {
+	.su_group = {
+		.cg_item = {
+			.ci_name = DRIVER_NAME,
+			.ci_type = &gpio_pwm_subsys_type,
+		},
+	},
+};
+
+static int __init gpio_pwm_init(void)
+{
+	config_group_init(&gpio_pwm_subsys.su_group);
+	mutex_init(&gpio_pwm_subsys.su_mutex);
+	return configfs_register_subsystem(&gpio_pwm_subsys);
+}
+module_init(gpio_pwm_init);
+
+static void __exit gpio_pwm_exit(void)
+{
+	configfs_unregister_subsystem(&gpio_pwm_subsys);
+}
+module_exit(gpio_pwm_exit);
+#endif
+
+MODULE_AUTHOR("Bill Gatliff <bgat@billgatliff.com>");
+MODULE_DESCRIPTION("PWM channel emulator using GPIO and a high-resolution timer");
+MODULE_LICENSE("GPL");
-- 
1.7.2.3

