Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993094Ab2KOJb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:31:28 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52373 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992967Ab2KOJbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:31:23 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-serial@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/3] serial: i.MX: Make console support non optional
Date: Thu, 15 Nov 2012 10:31:05 +0100
Message-Id: <1352971866-540-3-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1352971866-540-1-git-send-email-s.hauer@pengutronix.de>
References: <1352971866-540-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Traditionally console support is optional for serial drivers. This
makes it non optional for the i.MX driver since it's not worth
asking questions for a feature virtually every user of this driver
wants to have.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/tty/serial/Kconfig |   16 +---------------
 drivers/tty/serial/imx.c   |    8 +-------
 2 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 2a53be5..919b243 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -541,26 +541,12 @@ config SERIAL_IMX
 	bool "IMX serial port support"
 	depends on ARCH_MXC
 	select SERIAL_CORE
+	select SERIAL_CORE_CONSOLE
 	select RATIONAL
 	help
 	  If you have a machine based on a Motorola IMX CPU you
 	  can enable its onboard serial port by enabling this option.
 
-config SERIAL_IMX_CONSOLE
-	bool "Console on IMX serial port"
-	depends on SERIAL_IMX
-	select SERIAL_CORE_CONSOLE
-	help
-	  If you have enabled the serial port on the Motorola IMX
-	  CPU you can make it the console by answering Y to this option.
-
-	  Even if you say Y here, the currently visible virtual console
-	  (/dev/tty0) will still be used as the system console by default, but
-	  you can alter that using a kernel command line option such as
-	  "console=ttySA0". (Try "man bootparam" or see the documentation of
-	  your boot loader (lilo or loadlin) about how to pass options to the
-	  kernel at boot time.)
-
 config SERIAL_UARTLITE
 	tristate "Xilinx uartlite serial port support"
 	depends on PPC32 || MICROBLAZE || MFD_TIMBERDALE
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 5981912..07a8ca1 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1192,7 +1192,6 @@ static struct uart_ops imx_pops = {
 
 static struct imx_port *imx_ports[UART_NR];
 
-#ifdef CONFIG_SERIAL_IMX_CONSOLE
 static void imx_console_putchar(struct uart_port *port, int ch)
 {
 	struct imx_port *sport = (struct imx_port *)port;
@@ -1348,11 +1347,6 @@ static struct console imx_console = {
 	.data		= &imx_reg,
 };
 
-#define IMX_CONSOLE	&imx_console
-#else
-#define IMX_CONSOLE	NULL
-#endif
-
 static struct uart_driver imx_reg = {
 	.owner          = THIS_MODULE,
 	.driver_name    = DRIVER_NAME,
@@ -1360,7 +1354,7 @@ static struct uart_driver imx_reg = {
 	.major          = SERIAL_IMX_MAJOR,
 	.minor          = MINOR_START,
 	.nr             = ARRAY_SIZE(imx_ports),
-	.cons           = IMX_CONSOLE,
+	.cons           = &imx_console,
 };
 
 static int serial_imx_suspend(struct platform_device *dev, pm_message_t state)
-- 
1.7.10.4

