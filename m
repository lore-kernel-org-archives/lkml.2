Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab1D0SP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 14:15:27 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:33180 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754769Ab1D0SPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 14:15:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KxgBqt5FG2urV9Nfpm2GYwrELC1/sWcfcZUnL8z9ZzsRtUUj9/kHkwQNN9phJ4Dsj3
         OP9D+U7hEqBboSzaiznU+r/69s6M5WrI6A8/AlL8f4KXntInldEsQ/CKdwBVGU1UqJot
         3hip3sj5WZWTyR7r+VNu6r41MgCKBlzUpHYkY=
From: James Nuss <jamesnuss@nanometrics.ca>
To: Rodolfo Giometti <rodolfo.giometti@enneenne.com>,
        Ricardo Martins <rasm@fe.up.pt>
Cc: Ben Gardiner <bengardiner@nanometrics.ca>, linux-kernel@vger.kernel.org,
        linuxpps@ml.enneenne.com, James Nuss <jamesnuss@nanometrics.ca>,
        Ricardo Martins <rasm@fe.up.pt>
Subject: [PATCH 2/2] pps: new client driver using IRQs
Date: Wed, 27 Apr 2011 14:14:14 -0400
Message-Id: <1303928054-14662-3-git-send-email-jamesnuss@nanometrics.ca>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This client driver allows you to use raw IRQs as a source for PPS
signals.

This driver is based on the work by Ricardo Martins <rasm@fe.up.pt> who
submitted an initial implementation [1] of a PPS IRQ client driver to
the linuxpps mailing-list on Dec 3 2010.

[1] http://ml.enneenne.com/pipermail/linuxpps/2010-December/004155.html

Signed-off-by: James Nuss <jamesnuss@nanometrics.ca>
Reviewed-by: Ben Gardiner <bengardiner@nanometrics.ca>
CC: Ricardo Martins <rasm@fe.up.pt>
---
NOTE: drivers/pps/clients/Kconfig does not have the obligatory statements
regarding building the drivers as modules, even though they are all tristates.
This was purposefully omitted from the new config item for consistency.
This could be addressed in a separate patch.

 drivers/pps/clients/Kconfig   |    8 ++
 drivers/pps/clients/Makefile  |    1 +
 drivers/pps/clients/pps-irq.c |  169 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 178 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pps/clients/pps-irq.c

diff --git a/drivers/pps/clients/Kconfig b/drivers/pps/clients/Kconfig
index 8520a7f..94b2cc6 100644
--- a/drivers/pps/clients/Kconfig
+++ b/drivers/pps/clients/Kconfig
@@ -29,4 +29,12 @@ config PPS_CLIENT_PARPORT
 	  If you say yes here you get support for a PPS source connected
 	  with the interrupt pin of your parallel port.
 
+config PPS_CLIENT_IRQ
+	tristate "PPS client based on raw IRQs"
+	depends on PPS
+	help
+	  If you say yes here you get support for a PPS source based
+	  on raw IRQs. To be useful, you must also register a platform
+	  device with an IRQ resource, usually in your board setup.
+
 endif
diff --git a/drivers/pps/clients/Makefile b/drivers/pps/clients/Makefile
index 42517da..609a332 100644
--- a/drivers/pps/clients/Makefile
+++ b/drivers/pps/clients/Makefile
@@ -5,6 +5,7 @@
 obj-$(CONFIG_PPS_CLIENT_KTIMER)	+= pps-ktimer.o
 obj-$(CONFIG_PPS_CLIENT_LDISC)	+= pps-ldisc.o
 obj-$(CONFIG_PPS_CLIENT_PARPORT) += pps_parport.o
+obj-$(CONFIG_PPS_CLIENT_IRQ)	+= pps-irq.o
 
 ifeq ($(CONFIG_PPS_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
diff --git a/drivers/pps/clients/pps-irq.c b/drivers/pps/clients/pps-irq.c
new file mode 100644
index 0000000..33c1bf4
--- /dev/null
+++ b/drivers/pps/clients/pps-irq.c
@@ -0,0 +1,169 @@
+/*
+ * pps-irq.c -- PPS IRQ client
+ *
+ *
+ * Copyright (C) 2010 Ricardo Martins <rasm@fe.up.pt>
+ * Copyright (C) 2011 James Nuss <jamesnuss@nanometrics.ca>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/pps_kernel.h>
+#include <linux/gpio.h>
+#include <linux/list.h>
+
+#define PPS_IRQ_NAME            "pps-irq"
+#define PPS_IRQ_VERSION         "1.1.0"
+
+/* Info for each registered platform device */
+struct pps_irq_data {
+	int irq;			/* IRQ used as PPS source */
+	struct pps_device *pps;		/* PPS source device */
+	struct pps_source_info info;	/* PPS source information */
+};
+
+/*
+ * Report the PPS event
+ */
+
+static irqreturn_t pps_irq_irq_handler(int irq, void *data)
+{
+	struct pps_irq_data *info;
+	struct pps_event_time ts;
+
+	/* Get the time stamp first */
+	pps_get_ts(&ts);
+
+	info = (struct pps_irq_data *)data;
+	pps_event(info->pps, &ts, PPS_CAPTUREASSERT, NULL);
+
+	return IRQ_HANDLED;
+}
+
+static int pps_irq_probe(struct platform_device *pdev)
+{
+	struct pps_irq_data *data;
+	struct resource *res;
+	int irq;
+	int ret;
+
+	/* Validate resource. */
+	if (pdev->num_resources != 1) {
+		pr_err(PPS_IRQ_NAME ": this driver handles only one IRQ resource");
+		return -EINVAL;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (res == NULL) {
+		pr_err(PPS_IRQ_NAME ": no IRQ resource was given");
+		return -EINVAL;
+	}
+
+	if (!(res->flags & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING))) {
+		pr_err(PPS_IRQ_NAME ": given IRQ resource must be edge triggered");
+		return -EINVAL;
+	}
+
+	/* Allocate space for device info */
+	data = kzalloc(sizeof(struct pps_irq_data), GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	/* Initialize PPS specific parts of the bookkeeping data structure. */
+	data->info.mode = PPS_CAPTUREASSERT | PPS_OFFSETASSERT |
+			PPS_ECHOASSERT | PPS_CANWAIT | PPS_TSFMT_TSPEC;
+	data->info.owner = THIS_MODULE;
+	snprintf(data->info.name, PPS_MAX_NAME_LEN - 1, "%s.%d",
+		 pdev->name, pdev->id);
+
+	/* Register PPS source. */
+	irq = platform_get_irq(pdev, 0);
+	pr_info(PPS_IRQ_NAME ": registering IRQ %d as PPS source", irq);
+	data->pps = pps_register_source(&data->info, PPS_CAPTUREASSERT
+					| PPS_OFFSETASSERT);
+	if (data->pps == NULL) {
+		kfree(data);
+		pr_err(PPS_IRQ_NAME ": failed to register IRQ %d as PPS source",
+				irq);
+		return -1;
+	}
+
+	/* Request IRQ. */
+	pr_info(PPS_IRQ_NAME ": requesting IRQ %d", irq);
+	ret = request_irq(irq, pps_irq_irq_handler,
+			 res->flags & IRQF_TRIGGER_MASK,
+			 data->info.name, data);
+	if (ret) {
+		pps_unregister_source(data->pps);
+		kfree(data);
+		pr_err(PPS_IRQ_NAME ": failed to acquire IRQ %d\n", irq);
+		return ret;
+	}
+	data->irq = irq;
+
+	platform_set_drvdata(pdev, data);
+	dev_info(data->pps->dev, "Registered IRQ %d as PPS source", data->irq);
+
+	return 0;
+}
+
+static int pps_irq_remove(struct platform_device *pdev)
+{
+	struct pps_irq_data *data = platform_get_drvdata(pdev);
+	platform_set_drvdata(pdev, NULL);
+	free_irq(data->irq, data);
+	pps_unregister_source(data->pps);
+	pr_info(PPS_IRQ_NAME ": removed IRQ %d as PPS source", data->irq);
+	kfree(data);
+	return 0;
+}
+
+static struct platform_driver pps_irq_driver = {
+	.probe		= pps_irq_probe,
+	.remove		=  __devexit_p(pps_irq_remove),
+	.driver		= {
+		.name	= PPS_IRQ_NAME,
+		.owner	= THIS_MODULE
+	},
+};
+
+static int __init pps_irq_init(void)
+{
+	int ret = platform_driver_register(&pps_irq_driver);
+	if (ret < 0)
+		pr_err(PPS_IRQ_NAME ": failed to register platform driver");
+	return ret;
+}
+
+static void __exit pps_irq_exit(void)
+{
+	platform_driver_unregister(&pps_irq_driver);
+	pr_debug(PPS_IRQ_NAME ": unregistered platform driver");
+}
+
+module_init(pps_irq_init);
+module_exit(pps_irq_exit);
+
+MODULE_AUTHOR("Ricardo Martins <rasm@fe.up.pt>");
+MODULE_AUTHOR("James Nuss <jamesnuss@nanometrics.ca>");
+MODULE_DESCRIPTION("Use raw IRQs as PPS source");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(PPS_IRQ_VERSION);
-- 
1.7.1

