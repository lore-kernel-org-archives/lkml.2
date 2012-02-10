Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563Ab2BJGkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 01:40:37 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:30437 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758361Ab2BJGke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 01:40:34 -0500
X-AuditID: cbfee61a-b7b78ae000001ceb-a2-4f34bbdf81e9
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, myungjoo.ham@gmail.com
Subject: [PATCH v5 5/5] Extcon: adc-jack driver to support 3.5 pi or simliar
 devices
Date: Fri, 10 Feb 2012 15:40:38 +0900
Message-id: <1328856038-21912-6-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
References: <1327021317-10222-1-git-send-email-myungjoo.ham@samsung.com>
 <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

External connector devices that decides connection information based on
ADC values may use adc-jack device driver. The user simply needs to
provide a table of adc range and connection states. Then, extcon
framework will automatically notify others.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/extcon/Kconfig          |    7 ++-
 drivers/extcon/Makefile         |    1 +
 drivers/extcon/adc_jack.c       |  188 +++++++++++++++++++++++++++++++++++++++
 include/linux/extcon/adc_jack.h |  107 ++++++++++++++++++++++
 4 files changed, 302 insertions(+), 1 deletions(-)
 create mode 100644 drivers/extcon/adc_jack.c
 create mode 100644 include/linux/extcon/adc_jack.h

diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index 3fa3c22..7487384 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -19,4 +19,9 @@ config EXTCON_GPIO
 	  Say Y here to enable GPIO based extcon support. Note that GPIO
 	  extcon supports single state per extcon instance.
 
-endif # MULTISTATE_SWITCH
+config EXTCON_ADC_JACK
+	tristate "ADC Jack extcon support"
+	help
+	  Say Y here to enable extcon device driver based on ADC values.
+
+endif # EXTCON
diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
index 2c46d41..ca558a0 100644
--- a/drivers/extcon/Makefile
+++ b/drivers/extcon/Makefile
@@ -4,3 +4,4 @@
 
 obj-$(CONFIG_EXTCON)		+= extcon_class.o
 obj-$(CONFIG_EXTCON_GPIO)	+= extcon_gpio.o
+obj-$(CONFIG_EXTCON_ADC_JACK)	+= adc_jack.o
diff --git a/drivers/extcon/adc_jack.c b/drivers/extcon/adc_jack.c
new file mode 100644
index 0000000..9cad565
--- /dev/null
+++ b/drivers/extcon/adc_jack.c
@@ -0,0 +1,188 @@
+/*
+ * drivers/extcon/adc_jack.c
+ *
+ * Analog Jack extcon driver with ADC-based detection capability.
+ *
+ * Copyright (C) 2012 Samsung Electronics
+ * MyungJoo Ham <myungjoo.ham@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/extcon.h>
+#include <linux/extcon/adc_jack.h>
+
+static void adc_jack_handler(struct work_struct *work)
+{
+	struct adc_jack_data *data = container_of(to_delayed_work(work),
+						  struct adc_jack_data,
+						  handler);
+	u32 adc, state = 0;
+	int ret;
+	int i;
+
+	if (!data->ready)
+		return;
+
+	ret = data->get_adc(&adc);
+	if (ret) {
+		dev_err(data->edev.dev, "get_adc() error: %d\n", ret);
+		return;
+	}
+
+	/* Get state from adc value with adc_condition */
+	for (i = 0; i < data->num_conditions; i++) {
+		struct adc_jack_cond *def = &data->adc_condition[i];
+		if (!def->state)
+			break;
+		if (def->min_adc <= adc && def->max_adc >= adc) {
+			state = def->state;
+			break;
+		}
+	}
+	/* if no def has met, it means state = 0 (no cables attached) */
+
+	extcon_set_state(&data->edev, state);
+}
+
+static irqreturn_t adc_jack_irq_thread(int irq, void *_data)
+{
+	struct adc_jack_data *data = _data;
+
+	schedule_delayed_work(&data->handler, data->handling_delay);
+
+	return IRQ_HANDLED;
+}
+
+static int adc_jack_probe(struct platform_device *pdev)
+{
+	struct adc_jack_data *data;
+	struct adc_jack_pdata *pdata = pdev->dev.platform_data;
+	int i, err = 0;
+
+	data = kzalloc(sizeof(struct adc_jack_data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->edev.name = pdata->name;
+
+	if (pdata->cable_names)
+		data->edev.supported_cable = pdata->cable_names;
+	else
+		data->edev.supported_cable = extcon_cable_name;
+
+	/* Check the length of array and set num_cables */
+	for (i = 0; data->edev.supported_cable[i]; i++)
+		;
+	if (i == 0 || i > SUPPORTED_CABLE_MAX) {
+		err = -EINVAL;
+		dev_err(&pdev->dev, "error: pdata->cable_names size = %d\n",
+			i - 1);
+		goto err_alloc;
+	}
+	data->num_cables = i;
+
+	if (!pdata->adc_condition ||
+	    !pdata->adc_condition[0].state) {
+		err = -EINVAL;
+		dev_err(&pdev->dev, "error: adc_condition not defined.\n");
+		goto err_alloc;
+	}
+	data->adc_condition = pdata->adc_condition;
+
+	/* Check the length of array and set num_conditions */
+	for (i = 0; data->adc_condition[i].state; i++)
+		;
+	data->num_conditions = i;
+
+	if (!pdata->get_adc) {
+		dev_err(&pdev->dev, "error: get_adc() is mandatory.\n");
+		err = -EINVAL;
+		goto err_alloc;
+	}
+	data->get_adc = pdata->get_adc;
+	data->handling_delay = msecs_to_jiffies(pdata->handling_delay_ms);
+
+	INIT_DELAYED_WORK_DEFERRABLE(&data->handler, adc_jack_handler);
+
+	platform_set_drvdata(pdev, data);
+
+	if (pdata->irq) {
+		data->irq = pdata->irq;
+
+		err = request_threaded_irq(data->irq, NULL,
+					   adc_jack_irq_thread,
+					   pdata->irq_flags, pdata->name,
+					   data);
+
+		if (err) {
+			dev_err(&pdev->dev, "error: irq %d\n", data->irq);
+			err = -EINVAL;
+			goto err_initwork;
+		}
+	}
+	err = extcon_dev_register(&data->edev, &pdev->dev);
+	if (err)
+		goto err_irq;
+
+	data->ready = true;
+
+	goto out;
+
+err_irq:
+	if (data->irq)
+		free_irq(data->irq, data);
+err_initwork:
+	cancel_delayed_work_sync(&data->handler);
+err_alloc:
+	kfree(data);
+out:
+	return err;
+}
+
+static int __devexit adc_jack_remove(struct platform_device *pdev)
+{
+	struct adc_jack_data *data = platform_get_drvdata(pdev);
+
+	extcon_dev_unregister(&data->edev);
+	if (data->irq)
+		free_irq(data->irq, data);
+	platform_set_drvdata(pdev, NULL);
+	kfree(data);
+
+	return 0;
+}
+
+static struct platform_driver adc_jack_driver = {
+	.probe		= adc_jack_probe,
+	.remove		= __devexit_p(adc_jack_remove),
+	.driver		= {
+		.name	= "adc-jack",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init adc_jack_init(void)
+{
+	return platform_driver_register(&adc_jack_driver);
+}
+
+static void __exit adc_jack_exit(void)
+{
+	platform_driver_unregister(&adc_jack_driver);
+}
+
+module_init(adc_jack_init);
+module_exit(adc_jack_exit);
+
+MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
+MODULE_DESCRIPTION("ADC jack extcon driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/extcon/adc_jack.h b/include/linux/extcon/adc_jack.h
new file mode 100644
index 0000000..1650b85
--- /dev/null
+++ b/include/linux/extcon/adc_jack.h
@@ -0,0 +1,107 @@
+/*
+ * include/linux/extcon/adc_jack.h
+ *
+ * Analog Jack extcon driver with ADC-based detection capability.
+ *
+ * Copyright (C) 2012 Samsung Electronics
+ * MyungJoo Ham <myungjoo.ham@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef _EXTCON_ADC_JACK_H_
+#define _EXTCON_ADC_JACK_H_ __FILE__
+#include <linux/extcon.h>
+
+/**
+ * struct adc_jack_data - internal data for adc_jack device driver
+ * @edev	- extcon device.
+ * @cable_names	- list of supported cables.
+ * @num_cables	- size of cable_names.
+ * @adc_condition	- list of adc value conditions.
+ * @num_condition	- size of adc_condition.
+ * @irq		- irq number of attach/detach event (0 if not exist).
+ * @handling_delay	- interrupt handler will schedule extcon event
+ *			handling at handling_delay jiffies.
+ * @handler	- extcon event handler called by interrupt handler.
+ * @get_adc	- a callback to get ADC value to identify state.
+ * @ready	- true if it is safe to run handler.
+ */
+struct adc_jack_data {
+	struct extcon_dev edev;
+
+	const char **cable_names;
+	int num_cables;
+	struct adc_jack_cond *adc_condition;
+	int num_conditions;
+
+	int irq;
+	unsigned long handling_delay; /* in jiffies */
+	struct delayed_work handler;
+
+	int (*get_adc)(u32 *value);
+
+	bool ready;
+};
+
+/**
+ * struct adc_jack_cond - condition to use an extcon state
+ * @state	- the corresponding extcon state (if 0, this struct denotes
+ *		the last adc_jack_cond element among the array)
+ * @min_adc	- min adc value for this condition
+ * @max_adc	- max adc value for this condition
+ *
+ * For example, if { .state = 0x3, .min_adc = 100, .max_adc = 200}, it means
+ * that if ADC value is between (inclusive) 100 and 200, than the cable 0 and
+ * 1 are attached (1<<0 | 1<<1 == 0x3)
+ *
+ * Note that you don't need to describe condition for "no cable attached"
+ * because when no adc_jack_cond is met, state = 0 is automatically chosen.
+ */
+struct adc_jack_cond {
+	u32 state; /* extcon state value. 0 if invalid */
+
+	u32 min_adc;
+	u32 max_adc;
+};
+
+/**
+ * struct adc_jack_pdata - platform data for adc jack device.
+ * @name	- name of the extcon device. If null, "adc-jack" is used.
+ * @cable_names	- array of cable names ending with null. If the array itself
+ *		if null, extcon standard cable names are chosen.
+ * @adc_contition	- array of struct adc_jack_cond conditions ending
+ *			with .state = 0 entry. This describes how to decode
+ *			adc values into extcon state.
+ * @irq		- IRQ number that is triggerred by cable attach/detach
+ *		events. If irq = 0, use should manually update extcon state
+ *		with extcon APIs.
+ * @irq_flags	- irq flags used for the @irq
+ * @handling_delay_ms	- in some devices, we need to read ADC value some
+ *			milli-seconds after the interrupt occurs. You may
+ *			describe such delays with @handling_delay_ms, which
+ *			is rounded-off by jiffies.
+ * @get_adc	- the callback to read ADC value to identify cable states.
+ */
+struct adc_jack_pdata {
+	const char *name;
+	/*
+	 * NULL if standard extcon names are used.
+	 * The last entry should be NULL
+	 */
+	const char **cable_names;
+	/* The last entry's state should be 0 */
+	struct adc_jack_cond *adc_condition;
+
+	int irq; /* Jack insertion/removal interrupt */
+	unsigned long irq_flags;
+	unsigned long handling_delay_ms; /* in ms */
+
+	/* When we have ADC subsystem, this can be generalized. */
+	int (*get_adc)(u32 *value);
+};
+
+#endif /* _EXTCON_ADC_JACK_H */
-- 
1.7.4.1

