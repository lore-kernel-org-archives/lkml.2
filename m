Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934443Ab0EURFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:05:11 -0400
Received: from kroah.org ([198.145.64.141]:50296 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934075Ab0EUQwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:52:01 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Mike Frysinger <vapier@gentoo.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/25] serial: bfin_sport_uart: add support for CTS/RTS via GPIOs
Date: Fri, 21 May 2010 09:51:35 -0700
Message-Id: <1274460714-11277-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165113.GB11216@kroah.com>
References: <20100521165113.GB11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Some people need flow control on their ports, so now boards can support
that via any GPIOs.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/Kconfig           |   24 ++++++++
 drivers/serial/bfin_sport_uart.c |  111 ++++++++++++++++++++++++++++++++++----
 drivers/serial/bfin_sport_uart.h |   11 ++++
 3 files changed, 135 insertions(+), 11 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 302836a..6325830 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -1443,24 +1443,48 @@ config SERIAL_BFIN_SPORT0_UART
 	help
 	  Enable UART over SPORT0
 
+config SERIAL_BFIN_SPORT0_UART_CTSRTS
+	bool "Enable UART over SPORT0 hardware flow control"
+	depends on SERIAL_BFIN_SPORT0_UART
+	help
+	  Enable hardware flow control in the driver.
+
 config SERIAL_BFIN_SPORT1_UART
 	bool "Enable UART over SPORT1"
 	depends on SERIAL_BFIN_SPORT
 	help
 	  Enable UART over SPORT1
 
+config SERIAL_BFIN_SPORT1_UART_CTSRTS
+	bool "Enable UART over SPORT1 hardware flow control"
+	depends on SERIAL_BFIN_SPORT1_UART
+	help
+	  Enable hardware flow control in the driver.
+
 config SERIAL_BFIN_SPORT2_UART
 	bool "Enable UART over SPORT2"
 	depends on SERIAL_BFIN_SPORT && (BF54x || BF538 || BF539)
 	help
 	  Enable UART over SPORT2
 
+config SERIAL_BFIN_SPORT2_UART_CTSRTS
+	bool "Enable UART over SPORT2 hardware flow control"
+	depends on SERIAL_BFIN_SPORT2_UART
+	help
+	  Enable hardware flow control in the driver.
+
 config SERIAL_BFIN_SPORT3_UART
 	bool "Enable UART over SPORT3"
 	depends on SERIAL_BFIN_SPORT && (BF54x || BF538 || BF539)
 	help
 	  Enable UART over SPORT3
 
+config SERIAL_BFIN_SPORT3_UART_CTSRTS
+	bool "Enable UART over SPORT3 hardware flow control"
+	depends on SERIAL_BFIN_SPORT3_UART
+	help
+	  Enable hardware flow control in the driver.
+
 config SERIAL_TIMBERDALE
 	tristate "Support for timberdale UART"
 	select SERIAL_CORE
diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index 7925266..8cb0a40 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -48,6 +48,10 @@ struct sport_uart_port {
 	unsigned short		txmask2;
 	unsigned char		stopb;
 /*	unsigned char		parib; */
+#ifdef CONFIG_SERIAL_BFIN_SPORT_CTSRTS
+	int cts_pin;
+	int rts_pin;
+#endif
 };
 
 static void sport_uart_tx_chars(struct sport_uart_port *up);
@@ -198,6 +202,59 @@ static irqreturn_t sport_uart_err_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+#ifdef CONFIG_SERIAL_BFIN_SPORT_CTSRTS
+static unsigned int sport_get_mctrl(struct uart_port *port)
+{
+	struct sport_uart_port *up = (struct sport_uart_port *)port;
+	if (up->cts_pin < 0)
+		return TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;
+
+	/* CTS PIN is negative assertive. */
+	if (SPORT_UART_GET_CTS(up))
+		return TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;
+	else
+		return TIOCM_DSR | TIOCM_CAR;
+}
+
+static void sport_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+	struct sport_uart_port *up = (struct sport_uart_port *)port;
+	if (up->rts_pin < 0)
+		return;
+
+	/* RTS PIN is negative assertive. */
+	if (mctrl & TIOCM_RTS)
+		SPORT_UART_ENABLE_RTS(up);
+	else
+		SPORT_UART_DISABLE_RTS(up);
+}
+
+/*
+ * Handle any change of modem status signal.
+ */
+static irqreturn_t sport_mctrl_cts_int(int irq, void *dev_id)
+{
+	struct sport_uart_port *up = (struct sport_uart_port *)dev_id;
+	unsigned int status;
+
+	status = sport_get_mctrl(&up->port);
+	uart_handle_cts_change(&up->port, status & TIOCM_CTS);
+
+	return IRQ_HANDLED;
+}
+#else
+static unsigned int sport_get_mctrl(struct uart_port *port)
+{
+	pr_debug("%s enter\n", __func__);
+	return TIOCM_CTS | TIOCM_CD | TIOCM_DSR;
+}
+
+static void sport_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+	pr_debug("%s enter\n", __func__);
+}
+#endif
+
 /* Reqeust IRQ, Setup clock */
 static int sport_startup(struct uart_port *port)
 {
@@ -226,6 +283,21 @@ static int sport_startup(struct uart_port *port)
 		goto fail2;
 	}
 
+#ifdef CONFIG_SERIAL_BFIN_SPORT_CTSRTS
+	if (up->cts_pin >= 0) {
+		if (request_irq(gpio_to_irq(up->cts_pin),
+			sport_mctrl_cts_int,
+			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
+			IRQF_DISABLED, "BFIN_SPORT_UART_CTS", up)) {
+			up->cts_pin = -1;
+			dev_info(port->dev, "Unable to attach BlackFin UART \
+				over SPORT CTS interrupt. So, disable it.\n");
+		}
+	}
+	if (up->rts_pin >= 0)
+		gpio_direction_output(up->rts_pin, 0);
+#endif
+
 	return 0;
  fail2:
 	free_irq(up->port.irq+1, up);
@@ -283,17 +355,6 @@ static unsigned int sport_tx_empty(struct uart_port *port)
 		return 0;
 }
 
-static unsigned int sport_get_mctrl(struct uart_port *port)
-{
-	pr_debug("%s enter\n", __func__);
-	return (TIOCM_CTS | TIOCM_CD | TIOCM_DSR);
-}
-
-static void sport_set_mctrl(struct uart_port *port, unsigned int mctrl)
-{
-	pr_debug("%s enter\n", __func__);
-}
-
 static void sport_stop_tx(struct uart_port *port)
 {
 	struct sport_uart_port *up = (struct sport_uart_port *)port;
@@ -364,6 +425,10 @@ static void sport_shutdown(struct uart_port *port)
 	free_irq(up->port.irq, up);
 	free_irq(up->port.irq+1, up);
 	free_irq(up->err_irq, up);
+#ifdef CONFIG_SERIAL_BFIN_SPORT_CTSRTS
+	if (up->cts_pin >= 0)
+		free_irq(gpio_to_irq(up->cts_pin), up);
+#endif
 }
 
 static const char *sport_type(struct uart_port *port)
@@ -536,7 +601,11 @@ sport_uart_console_setup(struct console *co, char *options)
 	int baud = 57600;
 	int bits = 8;
 	int parity = 'n';
+# ifdef CONFIG_SERIAL_BFIN_SPORT_CTSRTS
+	int flow = 'r';
+# else
 	int flow = 'n';
+# endif
 
 	/* Check whether an invalid uart number has been specified */
 	if (co->index < 0 || co->index >= BFIN_SPORT_UART_MAX_PORTS)
@@ -729,6 +798,22 @@ static int __devinit sport_uart_probe(struct platform_device *pdev)
 			ret = -ENOENT;
 			goto out_error_unmap;
 		}
+#ifdef CONFIG_SERIAL_BFIN_SPORT_CTSRTS
+		res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+		if (res == NULL)
+			sport->cts_pin = -1;
+		else
+			sport->cts_pin = res->start;
+
+		res = platform_get_resource(pdev, IORESOURCE_IO, 1);
+		if (res == NULL)
+			sport->rts_pin = -1;
+		else
+			sport->rts_pin = res->start;
+
+		if (sport->rts_pin >= 0)
+			gpio_request(sport->rts_pin, DRV_NAME);
+#endif
 	}
 
 #ifdef CONFIG_SERIAL_BFIN_SPORT_CONSOLE
@@ -767,6 +852,10 @@ static int __devexit sport_uart_remove(struct platform_device *pdev)
 
 	if (sport) {
 		uart_remove_one_port(&sport_uart_reg, &sport->port);
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
+		if (sport->rts_pin >= 0)
+			gpio_free(sport->rts_pin);
+#endif
 		iounmap(sport->port.membase);
 		peripheral_free_list(
 			(unsigned short *)pdev->dev.platform_data);
diff --git a/drivers/serial/bfin_sport_uart.h b/drivers/serial/bfin_sport_uart.h
index 9791fcc..9ce253e 100644
--- a/drivers/serial/bfin_sport_uart.h
+++ b/drivers/serial/bfin_sport_uart.h
@@ -72,4 +72,15 @@
 
 #define SPORT_TX_FIFO_SIZE	8
 
+#define SPORT_UART_GET_CTS(x)		gpio_get_value(x->cts_pin)
+#define SPORT_UART_DISABLE_RTS(x)	gpio_set_value(x->rts_pin, 1)
+#define SPORT_UART_ENABLE_RTS(x)	gpio_set_value(x->rts_pin, 0)
+
+#if defined(CONFIG_SERIAL_BFIN_SPORT0_UART_CTSRTS) \
+	|| defined(CONFIG_SERIAL_BFIN_SPORT1_UART_CTSRTS) \
+	|| defined(CONFIG_SERIAL_BFIN_SPORT2_UART_CTSRTS) \
+	|| defined(CONFIG_SERIAL_BFIN_SPORT3_UART_CTSRTS)
+# define CONFIG_SERIAL_BFIN_SPORT_CTSRTS
+#endif
+
 #endif /* _BFIN_SPORT_UART_H */
-- 
1.7.0.3

