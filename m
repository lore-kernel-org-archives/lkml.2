Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934824Ab0HDVU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:20:27 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:57585 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759033Ab0HDVSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:18:55 -0400
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        john stultz <johnstul@us.ibm.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHv3 16/16] pps: add parallel port PPS signal generator
Date: Thu,  5 Aug 2010 01:06:53 +0400
Message-Id: <6015d3803449935de8f1425efdfae4736d775047.1280952801.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add PPS signal generator which utilizes STROBE pin of a parallel port to
send PPS signals. It uses parport abstraction layer and hrtimers to
precisely control the signal.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 drivers/pps/Kconfig                      |    2 +
 drivers/pps/Makefile                     |    2 +-
 drivers/pps/generators/Kconfig           |   17 ++
 drivers/pps/generators/Makefile          |    9 +
 drivers/pps/generators/pps_gen_parport.c |  274 ++++++++++++++++++++++++++++++
 5 files changed, 303 insertions(+), 1 deletions(-)
 create mode 100644 drivers/pps/generators/Kconfig
 create mode 100644 drivers/pps/generators/Makefile
 create mode 100644 drivers/pps/generators/pps_gen_parport.c

diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
index 4823e47..79bda60 100644
--- a/drivers/pps/Kconfig
+++ b/drivers/pps/Kconfig
@@ -40,4 +40,6 @@ config NTP_PPS
 
 source drivers/pps/clients/Kconfig
 
+source drivers/pps/generators/Kconfig
+
 endmenu
diff --git a/drivers/pps/Makefile b/drivers/pps/Makefile
index 98960dd..1906eb7 100644
--- a/drivers/pps/Makefile
+++ b/drivers/pps/Makefile
@@ -4,6 +4,6 @@
 
 pps_core-y			:= pps.o kapi.o sysfs.o
 obj-$(CONFIG_PPS)		:= pps_core.o
-obj-y				+= clients/
+obj-y				+= clients/ generators/
 
 ccflags-$(CONFIG_PPS_DEBUG) := -DDEBUG
diff --git a/drivers/pps/generators/Kconfig b/drivers/pps/generators/Kconfig
new file mode 100644
index 0000000..5fbd614
--- /dev/null
+++ b/drivers/pps/generators/Kconfig
@@ -0,0 +1,17 @@
+#
+# PPS generators configuration
+#
+
+if PPS
+
+comment "PPS generators support"
+
+config PPS_GENERATOR_PARPORT
+	tristate "Parallel port PPS signal generator"
+	depends on PARPORT != n && GENERIC_TIME
+	help
+	  If you say yes here you get support for a PPS signal generator which
+	  utilizes STROBE pin of a parallel port to send PPS signals. It uses
+	  parport abstraction layer and hrtimers to precisely control the signal.
+
+endif
diff --git a/drivers/pps/generators/Makefile b/drivers/pps/generators/Makefile
new file mode 100644
index 0000000..303304a
--- /dev/null
+++ b/drivers/pps/generators/Makefile
@@ -0,0 +1,9 @@
+#
+# Makefile for PPS generators.
+#
+
+obj-$(CONFIG_PPS_GENERATOR_PARPORT) += pps_gen_parport.o
+
+ifeq ($(CONFIG_PPS_DEBUG),y)
+EXTRA_CFLAGS += -DDEBUG
+endif
diff --git a/drivers/pps/generators/pps_gen_parport.c b/drivers/pps/generators/pps_gen_parport.c
new file mode 100644
index 0000000..be819d2
--- /dev/null
+++ b/drivers/pps/generators/pps_gen_parport.c
@@ -0,0 +1,274 @@
+/*
+ * pps_gen_parport.c -- kernel parallel port PPS signal generator
+ *
+ *
+ * Copyright (C) 2009   Alexander Gordeev <lasaine@lvk.cs.msu.su>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+
+/*
+ * TODO:
+ * fix issues when realtime clock is adjusted in a leap
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/time.h>
+#include <linux/hrtimer.h>
+#include <linux/parport.h>
+
+#define DRVNAME "pps_gen_parport"
+#define DRVDESC "parallel port PPS signal generator"
+
+#define SIGNAL		0
+#define NO_SIGNAL	PARPORT_CONTROL_STROBE
+
+/* module parameters */
+
+#define SEND_DELAY_MAX		300000000
+
+static unsigned int send_delay = 30000;
+MODULE_PARM_DESC(delay,
+	"Delay between setting and dropping the signal (ns)");
+module_param_named(delay, send_delay, uint, 0);
+
+
+#define SAFETY_INTERVAL	3000	/* set the hrtimer earlier for safety (ns) */
+
+/* internal per port structure */
+struct pps_generator_pp {
+	struct pardevice *pardev;	/* parport device */
+	struct hrtimer timer;
+	long port_write_time;		/* calibrated port write time (ns) */
+};
+
+static struct pps_generator_pp device = {
+	.pardev = NULL,
+};
+
+static int attached;
+
+/* calibrated time between a hrtimer event and the reaction */
+static long hrtimer_error = SAFETY_INTERVAL;
+
+/* the kernel hrtimer event */
+static enum hrtimer_restart hrtimer_event(struct hrtimer *timer)
+{
+	struct timespec expire_time, ts1, ts2, ts3, dts;
+	struct pps_generator_pp *dev;
+	struct parport *port;
+	long lim, delta;
+	unsigned long flags;
+
+	/* NB: approx time with blocked interrupts =
+	   send_delay + 3 * SAFETY_INTERVAL */
+	local_irq_save(flags);
+
+	/* first of all we get the time stamp... */
+	getnstimeofday(&ts1);
+	expire_time = ktime_to_timespec(timer->_expires);
+	dev = container_of(timer, struct pps_generator_pp, timer);
+	lim = NSEC_PER_SEC - send_delay - dev->port_write_time;
+
+	/* check if we are late */
+	if (expire_time.tv_sec != ts1.tv_sec || ts1.tv_nsec > lim) {
+		local_irq_restore(flags);
+		pr_err(DRVNAME ": we are late this time %ld.%09ld\n",
+				ts1.tv_sec, ts1.tv_nsec);
+		goto done;
+	}
+
+	/* busy loop until the time is right for an assert edge */
+	do {
+		getnstimeofday(&ts2);
+	} while (expire_time.tv_sec == ts2.tv_sec && ts2.tv_nsec < lim);
+
+	/* set the signal */
+	port = dev->pardev->port;
+	port->ops->write_control(port, SIGNAL);
+
+	/* busy loop until the time is right for a clear edge */
+	lim = NSEC_PER_SEC - dev->port_write_time;
+	do {
+		getnstimeofday(&ts2);
+	} while (expire_time.tv_sec == ts2.tv_sec && ts2.tv_nsec < lim);
+
+	/* unset the signal */
+	port->ops->write_control(port, NO_SIGNAL);
+
+	getnstimeofday(&ts3);
+
+	local_irq_restore(flags);
+
+	/* update calibrated port write time */
+	dts = timespec_sub(ts3, ts2);
+	dev->port_write_time =
+		(dev->port_write_time + timespec_to_ns(&dts)) >> 1;
+
+done:
+	/* update calibrated hrtimer error */
+	dts = timespec_sub(ts1, expire_time);
+	delta = timespec_to_ns(&dts);
+	/* If the new error value is bigger then the old, use the new
+	 * value, if not then slowly move towards the new value. This
+	 * way it should be safe in bad conditions and efficient in
+	 * good conditions.
+	 */
+	if (delta >= hrtimer_error)
+		hrtimer_error = delta;
+	else
+		hrtimer_error = (3 * hrtimer_error + delta) >> 2;
+
+	/* update the hrtimer expire time */
+	hrtimer_set_expires(timer,
+			ktime_set(expire_time.tv_sec + 1,
+				NSEC_PER_SEC - (send_delay +
+				dev->port_write_time + SAFETY_INTERVAL +
+				2 * hrtimer_error)));
+
+	return HRTIMER_RESTART;
+}
+
+/* calibrate port write time */
+#define PORT_NTESTS_SHIFT	5
+static void calibrate_port(struct pps_generator_pp *dev)
+{
+	struct parport *port = dev->pardev->port;
+	int i;
+	long acc = 0;
+
+	for (i = 0; i < (1 << PORT_NTESTS_SHIFT); i++) {
+		struct timespec a, b;
+		unsigned long irq_flags;
+
+		local_irq_save(irq_flags);
+		getnstimeofday(&a);
+		port->ops->write_control(port, NO_SIGNAL);
+		getnstimeofday(&b);
+		local_irq_restore(irq_flags);
+
+		b = timespec_sub(b, a);
+		acc += timespec_to_ns(&b);
+	}
+
+	dev->port_write_time = acc >> PORT_NTESTS_SHIFT;
+	pr_info(DRVNAME ": port write takes %ldns\n", dev->port_write_time);
+}
+
+static inline ktime_t next_intr_time(struct pps_generator_pp *dev)
+{
+	struct timespec ts;
+
+	getnstimeofday(&ts);
+
+	return ktime_set(ts.tv_sec +
+			((ts.tv_nsec > 990 * NSEC_PER_MSEC) ? 1 : 0),
+			NSEC_PER_SEC - (send_delay +
+			dev->port_write_time + 3 * SAFETY_INTERVAL));
+}
+
+static void parport_attach(struct parport *port)
+{
+	if (attached) {
+		/* we already have a port */
+		return;
+	}
+
+	device.pardev = parport_register_device(port, DRVNAME,
+			NULL, NULL, NULL, 0, &device);
+	if (!device.pardev) {
+		pr_err(DRVNAME ": couldn't register with %s\n", port->name);
+		return;
+	}
+
+	if (parport_claim_or_block(device.pardev) < 0) {
+		pr_err(DRVNAME ": couldn't claim %s\n", port->name);
+		goto err_unregister_dev;
+	}
+
+	pr_info(DRVNAME ": attached to %s\n", port->name);
+	attached = 1;
+
+	calibrate_port(&device);
+
+	hrtimer_init(&device.timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
+	device.timer.function = hrtimer_event;
+#ifdef CONFIG_PREEMPT_RT
+	/* hrtimer interrupt will run in the interrupt context with this */
+	device.timer.irqsafe = 1;
+#endif
+
+	hrtimer_start(&device.timer, next_intr_time(&device), HRTIMER_MODE_ABS);
+
+	return;
+
+err_unregister_dev:
+	parport_unregister_device(device.pardev);
+}
+
+static void parport_detach(struct parport *port)
+{
+	if (port->cad != device.pardev)
+		return;	/* not our port */
+
+	hrtimer_cancel(&device.timer);
+	parport_release(device.pardev);
+	parport_unregister_device(device.pardev);
+}
+
+static struct parport_driver pps_gen_parport_driver = {
+	.name = DRVNAME,
+	.attach = parport_attach,
+	.detach = parport_detach,
+};
+
+/* module staff */
+
+static int __init pps_gen_parport_init(void)
+{
+	int ret;
+
+	pr_info(DRVNAME ": " DRVDESC "\n");
+
+	if (send_delay > SEND_DELAY_MAX) {
+		pr_err(DRVNAME ": delay value should be not"
+				" greater then %d\n", SEND_DELAY_MAX);
+		return -EINVAL;
+	}
+
+	ret = parport_register_driver(&pps_gen_parport_driver);
+	if (ret) {
+		pr_err(DRVNAME ": unable to register with parport\n");
+		return ret;
+	}
+
+	return  0;
+}
+
+static void __exit pps_gen_parport_exit(void)
+{
+	parport_unregister_driver(&pps_gen_parport_driver);
+	pr_info(DRVNAME ": hrtimer avg error is %ldns\n", hrtimer_error);
+}
+
+module_init(pps_gen_parport_init);
+module_exit(pps_gen_parport_exit);
+
+MODULE_AUTHOR("Alexander Gordeev <lasaine@lvk.cs.msu.su>");
+MODULE_DESCRIPTION(DRVDESC);
+MODULE_LICENSE("GPL");
-- 
1.7.1

