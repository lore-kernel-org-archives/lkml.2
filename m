Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab2DISHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 14:07:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:65295 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757350Ab2DISHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 14:07:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="128808244"
Subject: [PATCH v2 1/4] of_serial: add support for setup quirks
To: gregkh@linuxfoundation.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        linux-serial@vger.kernel.org, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, alan@linux.intel.com
Date: Mon, 09 Apr 2012 11:22:03 -0700
Message-ID: <20120409182203.317.81835.stgit@dwillia2-linux.jf.intel.com>
In-Reply-To: <20120409182041.317.33360.stgit@dwillia2-linux.jf.intel.com>
References: <20120409182041.317.33360.stgit@dwillia2-linux.jf.intel.com>
User-Agent: StGit/0.16-1-g7004
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benign conversion of of_serial.c to offer the option of 'setup' quirks
similar to how 8250_pci.c houses the pci-serial-device quirks.

A setup quirk allows custom uart_port ops to specified in the
of_serial_info data fed to each serial of_device_id.

Tegra's 'break' quirk is the target consumer.

Cc: Colin Cross <ccross@android.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/tty/serial/of_serial.c |   68 ++++++++++++++++++++++++++++------------
 1 files changed, 47 insertions(+), 21 deletions(-)

diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index e8c9cee..4621cf9 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -22,13 +22,15 @@
 struct of_serial_info {
 	int type;
 	int line;
+	void (*setup)(struct uart_port *);
 };
 
 /*
  * Fill a struct uart_port for a given device node
  */
 static int __devinit of_platform_serial_setup(struct platform_device *ofdev,
-					int type, struct uart_port *port)
+					      struct of_serial_info *info,
+					      struct uart_port *port)
 {
 	struct resource resource;
 	struct device_node *np = ofdev->dev.of_node;
@@ -78,12 +80,15 @@ static int __devinit of_platform_serial_setup(struct platform_device *ofdev,
 		}
 	}
 
-	port->type = type;
+	port->type = info->type;
 	port->uartclk = clk;
 	port->flags = UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF | UPF_IOREMAP
 		| UPF_FIXED_PORT | UPF_FIXED_TYPE;
 	port->dev = &ofdev->dev;
 
+	if (info->setup)
+		info->setup(port);
+
 	return 0;
 }
 
@@ -96,7 +101,6 @@ static int __devinit of_platform_serial_probe(struct platform_device *ofdev)
 	const struct of_device_id *match;
 	struct of_serial_info *info;
 	struct uart_port port;
-	int port_type;
 	int ret;
 
 	match = of_match_device(of_platform_serial_table, &ofdev->dev);
@@ -106,16 +110,12 @@ static int __devinit of_platform_serial_probe(struct platform_device *ofdev)
 	if (of_find_property(ofdev->dev.of_node, "used-by-rtas", NULL))
 		return -EBUSY;
 
-	info = kmalloc(sizeof(*info), GFP_KERNEL);
-	if (info == NULL)
-		return -ENOMEM;
-
-	port_type = (unsigned long)match->data;
-	ret = of_platform_serial_setup(ofdev, port_type, &port);
+	info = match->data;
+	ret = of_platform_serial_setup(ofdev, info, &port);
 	if (ret)
 		goto out;
 
-	switch (port_type) {
+	switch (info->type) {
 #ifdef CONFIG_SERIAL_8250
 	case PORT_8250 ... PORT_MAX_8250:
 		ret = serial8250_register_port(&port);
@@ -136,12 +136,10 @@ static int __devinit of_platform_serial_probe(struct platform_device *ofdev)
 	if (ret < 0)
 		goto out;
 
-	info->type = port_type;
 	info->line = ret;
 	dev_set_drvdata(&ofdev->dev, info);
 	return 0;
 out:
-	kfree(info);
 	irq_dispose_mapping(port.irq);
 	return ret;
 }
@@ -167,24 +165,52 @@ static int of_platform_serial_remove(struct platform_device *ofdev)
 		/* need to add code for these */
 		break;
 	}
-	kfree(info);
 	return 0;
 }
 
 /*
+ * contiguous OF_ number space for serial port types so the
+ * __sinfo array does not have holes, and to allow cases of:
+ *  .type = 'common type', .setup = 'device specific quirk'
+ */
+enum {
+	OF_PORT_8250,
+	OF_PORT_16450,
+	OF_PORT_16550A,
+	OF_PORT_16550,
+	OF_PORT_16750,
+	OF_PORT_16850,
+	OF_PORT_TEGRA,
+	OF_PORT_NWPSERIAL,
+	OF_PORT_UNKNOWN,
+};
+
+static struct of_serial_info __refdata __sinfo[] = {
+	[OF_PORT_8250] = { .type = PORT_8250, },
+	[OF_PORT_16450] = { .type = PORT_16450, },
+	[OF_PORT_16550A] = { .type = PORT_16550A, },
+	[OF_PORT_16550] = { .type = PORT_16550, },
+	[OF_PORT_16750] = { .type = PORT_16750, },
+	[OF_PORT_16850] = { .type = PORT_16850, },
+	[OF_PORT_TEGRA] = { .type = PORT_TEGRA, },
+	[OF_PORT_NWPSERIAL] = { .type = PORT_NWPSERIAL, },
+	[OF_PORT_UNKNOWN] = { .type = PORT_UNKNOWN,  },
+};
+
+/*
  * A few common types, add more as needed.
  */
 static struct of_device_id __devinitdata of_platform_serial_table[] = {
-	{ .compatible = "ns8250",   .data = (void *)PORT_8250, },
-	{ .compatible = "ns16450",  .data = (void *)PORT_16450, },
-	{ .compatible = "ns16550a", .data = (void *)PORT_16550A, },
-	{ .compatible = "ns16550",  .data = (void *)PORT_16550, },
-	{ .compatible = "ns16750",  .data = (void *)PORT_16750, },
-	{ .compatible = "ns16850",  .data = (void *)PORT_16850, },
-	{ .compatible = "nvidia,tegra20-uart", .data = (void *)PORT_TEGRA, },
+	{ .compatible = "ns8250",   .data = &__sinfo[OF_PORT_8250], },
+	{ .compatible = "ns16450",  .data = &__sinfo[OF_PORT_16450], },
+	{ .compatible = "ns16550a", .data = &__sinfo[OF_PORT_16550A], },
+	{ .compatible = "ns16550",  .data = &__sinfo[OF_PORT_16550], },
+	{ .compatible = "ns16750",  .data = &__sinfo[OF_PORT_16750], },
+	{ .compatible = "ns16850",  .data = &__sinfo[OF_PORT_16850], },
+	{ .compatible = "nvidia,tegra20-uart", .data = &__sinfo[OF_PORT_TEGRA], },
 #ifdef CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL
 	{ .compatible = "ibm,qpace-nwp-serial",
-		.data = (void *)PORT_NWPSERIAL, },
+		.data = &__sinfo[OF_PORT_NWPSERIAL], },
 #endif
 	{ .type = "serial",         .data = (void *)PORT_UNKNOWN, },
 	{ /* end of list */ },

