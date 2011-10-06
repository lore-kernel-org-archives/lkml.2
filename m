Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965149Ab1JFQhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 12:37:10 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:57197 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735Ab1JFQhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 12:37:09 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E8DDB2F.7030601@cam.ac.uk>
Date: Thu, 06 Oct 2011 17:45:35 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: faking interrupts (or using a software knob to produce them).
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I have posted an RFC for a dummy / example driver for IIO on
the linux-iio list.  In order to make it look as much like
a real hardware driver as possible, I wanted to have it
register an interrupt handler.

http://article.gmane.org/gmane.linux.kernel.iio/1990

To that end it has a nasty little companion module (not
intended to demonstrate anything).

This just creates a fake interrupt chip which can then
be pinged form userspace using handle_nested_irq.

Now it isn't meant to be pretty, but rather to just work.  If one
registers too many of the dummy device drivers, it will fail a request
for the interrupt.

The approach is ugly, so whilst to a certain extent I don't care, I was
just wondering (before sending a merge request to Greg) whether there
was any existing facility for 'faking' interrupts or whether this
sort of thing was of more general interest?

Ripping the relevant bit of the patch out:

diff --git a/drivers/staging/iio/iio_dummy_evgen.c b/drivers/staging/iio/iio_dummy_evgen.c
new file mode 100644
index 0000000..da657d1
--- /dev/null
+++ b/drivers/staging/iio/iio_dummy_evgen.c
@@ -0,0 +1,217 @@
+/**
+ * Copyright (c) 2011 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * Companion module to the iio simple dummy example driver.
+ * The purpose of this is to generate 'fake' event interrupts thus
+ * allowing that driver's code to be as close as possible to that of
+ * a normal driver talking to hardware.  The approach used here
+ * is not intended to be general and just happens to work for this
+ * particular use case.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/mutex.h>
+#include <linux/module.h>
+#include <linux/sysfs.h>
+
+#include "iio_dummy_evgen.h"
+#include "iio.h"
+#include "sysfs.h"
+
+/* Fiddly bit of faking and irq without hardware */
+#define IIO_EVENTGEN_NO 10
+/**
+ * struct iio_dummy_evgen - evgen state
+ * @chip: irq chip we are faking
+ * @base: base of irq range
+ * @enabled: mask of which irqs are enabled
+ * @inuse: mask of which irqs actually have anyone connected
+ * @lock: protect the evgen state
+ */
+struct iio_dummy_eventgen {
+	struct irq_chip chip;
+	int base;
+	bool enabled[IIO_EVENTGEN_NO];
+	bool inuse[IIO_EVENTGEN_NO];
+	struct mutex lock;
+};
+
+/* We can only ever have one instance of this 'device' */
+static struct iio_dummy_eventgen *iio_evgen;
+static const char *iio_evgen_name = "iio_dummy_evgen";
+
+static void iio_dummy_event_irqmask(struct irq_data *d)
+{
+	struct irq_chip *chip = irq_data_get_irq_chip(d);
+	struct iio_dummy_eventgen *evgen =
+		container_of(chip, struct iio_dummy_eventgen, chip);
+
+	evgen->enabled[d->irq - evgen->base] = false;
+}
+
+static void iio_dummy_event_irqunmask(struct irq_data *d)
+{
+	struct irq_chip *chip = irq_data_get_irq_chip(d);
+	struct iio_dummy_eventgen *evgen =
+		container_of(chip, struct iio_dummy_eventgen, chip);
+
+	evgen->enabled[d->irq - evgen->base] = true;
+}
+
+static int iio_dummy_evgen_create(void)
+{
+	int ret, i;
+
+	iio_evgen = kzalloc(sizeof(*iio_evgen), GFP_KERNEL);
+	if (iio_evgen == NULL)
+		return -ENOMEM;
+
+	iio_evgen->base = irq_alloc_descs(-1, 0, IIO_EVENTGEN_NO, 0);
+	if (iio_evgen->base < 0) {
+		ret = iio_evgen->base;
+		kfree(iio_evgen);
+		return ret;
+	}
+	iio_evgen->chip.name = iio_evgen_name;
+	iio_evgen->chip.irq_mask = &iio_dummy_event_irqmask;
+	iio_evgen->chip.irq_unmask = &iio_dummy_event_irqunmask;
+	for (i = 0; i < IIO_EVENTGEN_NO; i++) {
+		irq_set_chip(iio_evgen->base + i, &iio_evgen->chip);
+		irq_set_handler(iio_evgen->base + i, &handle_simple_irq);
+		irq_modify_status(iio_evgen->base + i,
+				  IRQ_NOREQUEST | IRQ_NOAUTOEN,
+				  IRQ_NOPROBE);
+	}
+	mutex_init(&iio_evgen->lock);
+	return 0;
+}
+
+/**
+ * iio_dummy_evgen_get_irq() - get an evgen provided irq for a device
+ *
+ * This function will give a free allocated irq to a client device.
+ * That irq can then be caused to 'fire' by using the associated sysfs file.
+ */
+int iio_dummy_evgen_get_irq(void)
+{
+	int i, ret = 0;
+	mutex_lock(&iio_evgen->lock);
+	for (i = 0; i < IIO_EVENTGEN_NO; i++)
+		if (iio_evgen->inuse[i] == false) {
+			ret = iio_evgen->base + i;
+			iio_evgen->inuse[i] = true;
+			break;
+		}
+	mutex_unlock(&iio_evgen->lock);
+	if (i == IIO_EVENTGEN_NO)
+		return -ENOMEM;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iio_dummy_evgen_get_irq);
+
+/**
+ * iio_dummy_evgen_release_irq() - give the irq back.
+ * @irq: irq being returned to the pool
+ *
+ * Used by client driver instances to give the irqs back when they disconnect
+ */
+int iio_dummy_evgen_release_irq(int irq)
+{
+	mutex_lock(&iio_evgen->lock);
+	iio_evgen->inuse[irq - iio_evgen->base] = false;
+	mutex_unlock(&iio_evgen->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iio_dummy_evgen_release_irq);
+
+static void iio_dummy_evgen_free(void)
+{
+	irq_free_descs(iio_evgen->base, IIO_EVENTGEN_NO);
+	kfree(iio_evgen);
+}
+
+static void iio_evgen_release(struct device *dev)
+{
+	iio_dummy_evgen_free();
+}
+
+static ssize_t iio_evgen_poke(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf,
+			      size_t len)
+{
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+
+	if (iio_evgen->enabled[this_attr->address])
+		handle_nested_irq(iio_evgen->base + this_attr->address);
+
+	return len;
+}
+
+static IIO_DEVICE_ATTR(poke_ev0, S_IWUSR, NULL, &iio_evgen_poke, 0);
+static IIO_DEVICE_ATTR(poke_ev1, S_IWUSR, NULL, &iio_evgen_poke, 1);
+static IIO_DEVICE_ATTR(poke_ev2, S_IWUSR, NULL, &iio_evgen_poke, 2);
+static IIO_DEVICE_ATTR(poke_ev3, S_IWUSR, NULL, &iio_evgen_poke, 3);
+static IIO_DEVICE_ATTR(poke_ev4, S_IWUSR, NULL, &iio_evgen_poke, 4);
+static IIO_DEVICE_ATTR(poke_ev5, S_IWUSR, NULL, &iio_evgen_poke, 5);
+static IIO_DEVICE_ATTR(poke_ev6, S_IWUSR, NULL, &iio_evgen_poke, 6);
+static IIO_DEVICE_ATTR(poke_ev7, S_IWUSR, NULL, &iio_evgen_poke, 7);
+static IIO_DEVICE_ATTR(poke_ev8, S_IWUSR, NULL, &iio_evgen_poke, 8);
+static IIO_DEVICE_ATTR(poke_ev9, S_IWUSR, NULL, &iio_evgen_poke, 9);
+
+static struct attribute *iio_evgen_attrs[] = {
+	&iio_dev_attr_poke_ev0.dev_attr.attr,
+	&iio_dev_attr_poke_ev1.dev_attr.attr,
+	&iio_dev_attr_poke_ev2.dev_attr.attr,
+	&iio_dev_attr_poke_ev3.dev_attr.attr,
+	&iio_dev_attr_poke_ev4.dev_attr.attr,
+	&iio_dev_attr_poke_ev5.dev_attr.attr,
+	&iio_dev_attr_poke_ev6.dev_attr.attr,
+	&iio_dev_attr_poke_ev7.dev_attr.attr,
+	&iio_dev_attr_poke_ev8.dev_attr.attr,
+	&iio_dev_attr_poke_ev9.dev_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group iio_evgen_group = {
+	.attrs = iio_evgen_attrs,
+};
+
+static const struct attribute_group *iio_evgen_groups[] = {
+	&iio_evgen_group,
+	NULL
+};
+
+static struct device iio_evgen_dev = {
+	.bus = &iio_bus_type,
+	.groups = iio_evgen_groups,
+	.release = &iio_evgen_release,
+};
+static __init int iio_dummy_evgen_init(void)
+{
+	int ret = iio_dummy_evgen_create();
+	if (ret < 0)
+		return ret;
+	device_initialize(&iio_evgen_dev);
+	dev_set_name(&iio_evgen_dev, "iio_evgen");
+	return device_add(&iio_evgen_dev);
+}
+module_init(iio_dummy_evgen_init);
+
+static __exit void iio_dummy_evgen_exit(void)
+{
+	device_unregister(&iio_evgen_dev);
+}
+module_exit(iio_dummy_evgen_exit);
+
+MODULE_AUTHOR("Jonathan Cameron <jic23@...>");
+MODULE_DESCRIPTION("IIO dummy driver");
+MODULE_LICENSE("GPL v2");
