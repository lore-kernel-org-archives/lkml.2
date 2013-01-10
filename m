Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab3AJJ2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 04:28:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:24143 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225Ab3AJJY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 04:24:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,443,1355126400"; 
   d="scan'208";a="244528095"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>, Jamie Iles <jamie@jamieiles.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv3 6/8] serial: 8250_dw: Add ACPI 5.0 support
Date: Thu, 10 Jan 2013 11:25:10 +0200
Message-Id: <1357809912-25790-7-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357809912-25790-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1357809912-25790-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for ACPI 5.0 enumerated Designware UARTs.
ACPI does not deliver information about uart clk, so
delivering it with the driver_data.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/tty/serial/8250/8250_dw.c |   41 +++++++++++++++++++++++++++++++++++++
 drivers/tty/serial/8250/Kconfig   |    2 +-
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index e104092..f6eeff0 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -2,6 +2,7 @@
  * Synopsys DesignWare 8250 driver.
  *
  * Copyright 2011 Picochip, Jamie Iles.
+ * Copyright 2013 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -24,12 +25,16 @@
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/acpi.h>
 
 /* Offsets for the DesignWare specific registers */
 #define DW_UART_USR	0x1f /* UART Status Register */
 #define DW_UART_CPR	0xf4 /* Component Parameter Register */
 #define DW_UART_UCV	0xf8 /* UART Component Version */
 
+/* Intel Low Power Subsystem specific */
+#define LPSS_PRV_CLOCK_PARAMS 0x800
+
 /* Component Parameter Register bits */
 #define DW_UART_CPR_ABP_DATA_WIDTH	(3 << 0)
 #define DW_UART_CPR_AFCE_MODE		(1 << 4)
@@ -138,6 +143,30 @@ static int dw8250_probe_of(struct uart_port *p)
 	return 0;
 }
 
+static int dw8250_probe_acpi(struct uart_port *p)
+{
+	const struct acpi_device_id *id;
+	u32 reg;
+
+	id = acpi_match_device(p->dev->driver->acpi_match_table, p->dev);
+	if (!id)
+		return -ENODEV;
+
+	p->iotype = UPIO_MEM32;
+	p->serial_in = dw8250_serial_in32;
+	p->serial_out = dw8250_serial_out32;
+	p->regshift = 2;
+	p->uartclk = (unsigned int)id->driver_data;
+
+	/* Fix Haswell issue where the clocks do not get enabled */
+	if (!strcmp(id->id, "INT33C4") || !strcmp(id->id, "INT33C5")) {
+		reg = readl(p->membase + LPSS_PRV_CLOCK_PARAMS);
+		writel(reg | 1, p->membase + LPSS_PRV_CLOCK_PARAMS);
+	}
+
+	return 0;
+}
+
 static void dw8250_setup_port(struct uart_8250_port *up)
 {
 	struct uart_port	*p = &up->port;
@@ -199,6 +228,10 @@ static int dw8250_probe(struct platform_device *pdev)
 		err = dw8250_probe_of(&uart.port);
 		if (err)
 			return err;
+	} else if (ACPI_HANDLE(&pdev->dev)) {
+		err = dw8250_probe_acpi(&uart.port);
+		if (err)
+			return err;
 	} else {
 		return -ENODEV;
 	}
@@ -258,11 +291,19 @@ static const struct of_device_id dw8250_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, dw8250_of_match);
 
+static const struct acpi_device_id dw8250_acpi_match[] = {
+	{ "INT33C4", 100000000 },
+	{ "INT33C5", 100000000 },
+	{ },
+};
+MODULE_DEVICE_TABLE(acpi, dw8250_acpi_match);
+
 static struct platform_driver dw8250_platform_driver = {
 	.driver = {
 		.name		= "dw-apb-uart",
 		.owner		= THIS_MODULE,
 		.of_match_table	= dw8250_of_match,
+		.acpi_match_table = ACPI_PTR(dw8250_acpi_match),
 	},
 	.probe			= dw8250_probe,
 	.remove			= dw8250_remove,
diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index c31133a..11adff1 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -265,7 +265,7 @@ config SERIAL_8250_FSL
 
 config SERIAL_8250_DW
 	tristate "Support for Synopsys DesignWare 8250 quirks"
-	depends on SERIAL_8250 && OF
+	depends on SERIAL_8250
 	help
 	  Selecting this option will enable handling of the extra features
 	  present in the Synopsys DesignWare APB UART.
-- 
1.7.10.4

