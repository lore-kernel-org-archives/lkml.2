Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656Ab0KRQNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:13:11 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:36021 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab0KRQMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:12:36 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHv4 16/17] pps: add parallel port PPS client
Date: Thu, 18 Nov 2010 19:01:09 +0300
Message-Id: <daf0c26b66b20946b3ea632f1faf17924ba9771a.1290087481.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add parallel port PPS client. It uses a standard method for capturing
timestamps for assert edge transitions: getting a timestamp soon after
an interrupt has happened. This is not a very precise source of time
information due to interrupt handling delays. However, timestamps for
clear edge transitions are much more precise because the interrupt
handler continuously polls hardware port until the transition is done.
Hardware port operations require only about 1us so the maximum error
should not exceed this value. This was my primary goal when developing
this client.
Clear edge capture could be disabled using clear_wait parameter.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 drivers/pps/clients/Kconfig       |    7 +
 drivers/pps/clients/Makefile      |    1 +
 drivers/pps/clients/pps_parport.c |  247 +++++++++++++++++++++++++++++++++++++
 3 files changed, 255 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pps/clients/pps_parport.c

diff --git a/drivers/pps/clients/Kconfig b/drivers/pps/clients/Kconfig
index 4e801bd..8520a7f 100644
--- a/drivers/pps/clients/Kconfig
+++ b/drivers/pps/clients/Kconfig
@@ -22,4 +22,11 @@ config PPS_CLIENT_LDISC
 	  If you say yes here you get support for a PPS source connected
 	  with the CD (Carrier Detect) pin of your serial port.
 
+config PPS_CLIENT_PARPORT
+	tristate "Parallel port PPS client"
+	depends on PPS && PARPORT
+	help
+	  If you say yes here you get support for a PPS source connected
+	  with the interrupt pin of your parallel port.
+
 endif
diff --git a/drivers/pps/clients/Makefile b/drivers/pps/clients/Makefile
index 812c9b1..42517da 100644
--- a/drivers/pps/clients/Makefile
+++ b/drivers/pps/clients/Makefile
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_PPS_CLIENT_KTIMER)	+= pps-ktimer.o
 obj-$(CONFIG_PPS_CLIENT_LDISC)	+= pps-ldisc.o
+obj-$(CONFIG_PPS_CLIENT_PARPORT) += pps_parport.o
 
 ifeq ($(CONFIG_PPS_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
diff --git a/drivers/pps/clients/pps_parport.c b/drivers/pps/clients/pps_parport.c
new file mode 100644
index 0000000..20dc52e
--- /dev/null
+++ b/drivers/pps/clients/pps_parport.c
@@ -0,0 +1,247 @@
+/*
+ * pps_parport.c -- kernel parallel port PPS client
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
+ * implement echo over SEL pin
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/irqnr.h>
+#include <linux/time.h>
+#include <linux/parport.h>
+#include <linux/pps_kernel.h>
+
+#define DRVDESC "parallel port PPS client"
+
+/* module parameters */
+
+#define CLEAR_WAIT_MAX		100
+#define CLEAR_WAIT_MAX_ERRORS	5
+
+static unsigned int clear_wait = 100;
+MODULE_PARM_DESC(clear_wait,
+	"Maximum number of port reads when polling for signal clear,"
+	" zero turns clear edge capture off entirely");
+module_param(clear_wait, uint, 0);
+
+
+/* internal per port structure */
+struct pps_client_pp {
+	struct pardevice *pardev;	/* parport device */
+	struct pps_device *pps;		/* PPS device */
+	unsigned int cw;		/* port clear timeout */
+	unsigned int cw_err;		/* number of timeouts */
+};
+
+static inline int signal_is_set(struct parport *port)
+{
+	return (port->ops->read_status(port) & PARPORT_STATUS_ACK) != 0;
+}
+
+/* parport interrupt handler */
+static void parport_irq(void *handle)
+{
+	struct pps_event_time ts_assert, ts_clear;
+	struct pps_client_pp *dev = handle;
+	struct parport *port = dev->pardev->port;
+	unsigned int i;
+	unsigned long flags;
+
+	/* first of all we get the time stamp... */
+	pps_get_ts(&ts_assert);
+
+	if (dev->cw == 0)
+		/* clear edge capture disabled */
+		goto out_assert;
+
+	/* try capture the clear edge */
+	local_irq_save(flags);
+	/* check the signal (no signal means the pulse is lost this time) */
+	if (!signal_is_set(port)) {
+		local_irq_restore(flags);
+		dev_err(dev->pps->dev, "lost the signal\n");
+		goto out_assert;
+	}
+
+	/* poll the port until the signal is unset */
+	for (i = dev->cw; i; i--)
+		if (!signal_is_set(port)) {
+			pps_get_ts(&ts_clear);
+			local_irq_restore(flags);
+			dev->cw_err = 0;
+			goto out_both;
+		}
+	local_irq_restore(flags);
+
+	/* timeout */
+	dev->cw_err++;
+	if (dev->cw_err >= CLEAR_WAIT_MAX_ERRORS) {
+		dev_err(dev->pps->dev, "disabled clear edge capture after %d"
+				" timeouts\n", dev->cw_err);
+		dev->cw = 0;
+		dev->cw_err = 0;
+	}
+
+out_assert:
+	/* fire assert event */
+	pps_event_irq(dev->pps, &ts_assert,
+			PPS_CAPTUREASSERT, NULL);
+	return;
+
+out_both:
+	/* fire assert event */
+	pps_event_irq(dev->pps, &ts_assert,
+			PPS_CAPTUREASSERT, NULL);
+	/* fire clear event */
+	pps_event_irq(dev->pps, &ts_clear,
+			PPS_CAPTURECLEAR, NULL);
+	return;
+}
+
+/* the PPS echo function */
+static void pps_echo(struct pps_device *pps, int event, void *data)
+{
+	dev_info(pps->dev, "echo %s %s\n",
+		event & PPS_CAPTUREASSERT ? "assert" : "",
+		event & PPS_CAPTURECLEAR ? "clear" : "");
+}
+
+static void parport_attach(struct parport *port)
+{
+	struct pps_client_pp *device;
+	struct pps_source_info info = {
+		.name		= KBUILD_MODNAME,
+		.path		= "",
+		.mode		= PPS_CAPTUREBOTH | \
+				  PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
+				  PPS_ECHOASSERT | PPS_ECHOCLEAR | \
+				  PPS_CANWAIT | PPS_TSFMT_TSPEC,
+		.echo		= pps_echo,
+		.owner		= THIS_MODULE,
+		.dev		= NULL
+	};
+
+	device = kzalloc(sizeof(struct pps_client_pp), GFP_KERNEL);
+	if (!device) {
+		pr_err("memory allocation failed, not attaching\n");
+		return;
+	}
+
+	device->pardev = parport_register_device(port, KBUILD_MODNAME,
+			NULL, NULL, parport_irq, 0, device);
+	if (!device->pardev) {
+		pr_err("couldn't register with %s\n", port->name);
+		goto err_free;
+	}
+
+	if (parport_claim_or_block(device->pardev) < 0) {
+		pr_err("couldn't claim %s\n", port->name);
+		goto err_unregister_dev;
+	}
+
+	device->pps = pps_register_source(&info,
+			PPS_CAPTUREBOTH | PPS_OFFSETASSERT | PPS_OFFSETCLEAR);
+	if (device->pps == NULL) {
+		pr_err("couldn't register PPS source\n");
+		goto err_release_dev;
+	}
+
+	device->cw = clear_wait;
+
+	port->ops->enable_irq(port);
+
+	pr_info("attached to %s\n", port->name);
+
+	return;
+
+err_release_dev:
+	parport_release(device->pardev);
+err_unregister_dev:
+	parport_unregister_device(device->pardev);
+err_free:
+	kfree(device);
+}
+
+static void parport_detach(struct parport *port)
+{
+	struct pardevice *pardev = port->cad;
+	struct pps_client_pp *device;
+
+	/* FIXME: oooh, this is ugly! */
+	if (strcmp(pardev->name, KBUILD_MODNAME))
+		/* not our port */
+		return;
+
+	device = pardev->private;
+
+	port->ops->disable_irq(port);
+	pps_unregister_source(device->pps);
+	parport_release(pardev);
+	parport_unregister_device(pardev);
+	kfree(device);
+}
+
+static struct parport_driver pps_parport_driver = {
+	.name = KBUILD_MODNAME,
+	.attach = parport_attach,
+	.detach = parport_detach,
+};
+
+/* module staff */
+
+static int __init pps_parport_init(void)
+{
+	int ret;
+
+	pr_info(DRVDESC "\n");
+
+	if (clear_wait > CLEAR_WAIT_MAX) {
+		pr_err("clear_wait value should be not greater"
+				" then %d\n", CLEAR_WAIT_MAX);
+		return -EINVAL;
+	}
+
+	ret = parport_register_driver(&pps_parport_driver);
+	if (ret) {
+		pr_err("unable to register with parport\n");
+		return ret;
+	}
+
+	return  0;
+}
+
+static void __exit pps_parport_exit(void)
+{
+	parport_unregister_driver(&pps_parport_driver);
+}
+
+module_init(pps_parport_init);
+module_exit(pps_parport_exit);
+
+MODULE_AUTHOR("Alexander Gordeev <lasaine@lvk.cs.msu.su>");
+MODULE_DESCRIPTION(DRVDESC);
+MODULE_LICENSE("GPL");
-- 
1.7.2.3

