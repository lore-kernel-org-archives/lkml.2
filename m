Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab1F0VqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 17:46:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53852 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab1F0VqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 17:46:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Ralf Baechle <ralf@linux-mips.org>,
        Jamie Iles <jamie@jamieiles.com>, linux-serial@vger.kernel.org
Subject: [PATCH 4/7] serial/8250: move DWAP support to arch/mips
Date: Mon, 27 Jun 2011 23:45:17 +0200
Message-Id: <1309211120-2803-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309211120-2803-1-git-send-email-arnd@arndb.de>
References: <1309211120-2803-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:WimkWB0pNGnmqwP1VytdcWYIShDgkvpU1VHYCnaWexv
 9skU/o3uShh3GsmAo3Nvai93ltWGuJc/CNY2x357ChLhtoRi0A
 iCU3lIeAewMdaBMu/kOPP/1oZ3wbOKTlTuPIyGT1Eh5fJIUpZ5
 QX434ZmiFomJCK/ngTk2c/MyVDGc98p78wbJuHpYMPhSPxOYKh
 U9Q6yr+XJ7l7Nq1jUm/vw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only one board uses the UPIO_DWAP iotype, and nothing uses
the UPIO_DWAP32 iotype. It seems much cleaner to handle the
DWAP quirk as a new port type, and move the serial_out
accessor into the platform code. If more platforms start
using the DWAP port, that function can be moved into a
common location.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Jamie Iles <jamie@jamieiles.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-serial@vger.kernel.org
---
 arch/mips/pmc-sierra/msp71xx/msp_serial.c |   32 ++++++++++-
 drivers/tty/serial/8250.c                 |   87 +++--------------------------
 drivers/tty/serial/8250_hub6.c            |   17 ++++++
 drivers/tty/serial/serial_core.c          |    4 -
 include/linux/serial_core.h               |    5 +-
 5 files changed, 57 insertions(+), 88 deletions(-)

diff --git a/arch/mips/pmc-sierra/msp71xx/msp_serial.c b/arch/mips/pmc-sierra/msp71xx/msp_serial.c
index f726162..6c9f1d3 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_serial.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_serial.c
@@ -38,6 +38,33 @@
 #include <msp_int.h>
 #include <msp_regs.h>
 
+/* Save the LCR value so it can be re-written when a Busy Detect IRQ occurs. */
+static inline void dwapb_save_out_value(struct uart_port *p, int offset,
+					int value)
+{
+	struct uart_8250_port *up =
+		container_of(p, struct uart_8250_port, port);
+
+	if (offset == UART_LCR)
+		up->lcr = value;
+}
+
+/* Read the IER to ensure any interrupt is cleared before returning from ISR. */
+static inline void dwapb_check_clear_ier(struct uart_port *p, int offset)
+{
+	if (offset == UART_TX || offset == UART_IER)
+		p->serial_in(p, UART_IER);
+}
+
+static void dwapb_serial_out(struct uart_port *p, int offset, int value)
+{
+	int save_offset = offset;
+	offset = map_8250_out_reg(p, offset) << p->regshift;
+	dwapb_save_out_value(p, save_offset, value);
+	writeb(value, p->membase + offset);
+	dwapb_check_clear_ier(p, save_offset);
+}
+
 void __init msp_serial_setup(void)
 {
 	char    *s;
@@ -59,9 +86,10 @@ void __init msp_serial_setup(void)
 	up.irq          = MSP_INT_UART0;
 	up.uartclk      = uartclk;
 	up.regshift     = 2;
-	up.iotype       = UPIO_DWAPB; /* UPIO_MEM like */
+	up.iotype       = UPIO_MEM;
+	up.serial_out	= dwapb_serial_out;
 	up.flags        = ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST;
-	up.type         = PORT_16550A;
+	up.type         = PORT_DWAP;
 	up.line         = 0;
 	up.private_data		= (void*)UART0_STATUS_REG;
 	if (early_serial_setup(&up))
diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index d575ccb..5698157 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -100,12 +100,6 @@ static unsigned int skip_txen_test; /* force skip of txen test at init time */
 #define CONFIG_SERIAL_MANY_PORTS 1
 #endif
 
-/*
- * HUB6 is always on.  This will be removed once the header
- * files have been cleaned.
- */
-#define CONFIG_HUB6 1
-
 #include <asm/serial.h>
 /*
  * SERIAL_PORT_DFNS tells us about built-in ports that have no
@@ -302,25 +296,18 @@ static const struct serial8250_config uart_config[] = {
 				  UART_FCR_T_TRIG_01,
 		.flags		= UART_CAP_FIFO | UART_CAP_RTOIE,
 	},
+	[PORT_DWAP] = {
+		.name		= "16550A",
+		.fifo_size	= 16,
+		.tx_loadsz	= 16,
+		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
+		.flags		= UART_CAP_FIFO,
+	},
 };
 
 #define map_8250_in_reg(up, offset) (offset)
 #define map_8250_out_reg(up, offset) (offset)
 
-static unsigned int hub6_serial_in(struct uart_port *p, int offset)
-{
-	offset = map_8250_in_reg(p, offset) << p->regshift;
-	outb(p->hub6 - 1 + offset, p->iobase);
-	return inb(p->iobase + 1);
-}
-
-static void hub6_serial_out(struct uart_port *p, int offset, int value)
-{
-	offset = map_8250_out_reg(p, offset) << p->regshift;
-	outb(p->hub6 - 1 + offset, p->iobase);
-	outb(value, p->iobase + 1);
-}
-
 static unsigned int mem_serial_in(struct uart_port *p, int offset)
 {
 	offset = map_8250_in_reg(p, offset) << p->regshift;
@@ -345,42 +332,6 @@ static unsigned int mem32_serial_in(struct uart_port *p, int offset)
 	return readl(p->membase + offset);
 }
 
-/* Save the LCR value so it can be re-written when a Busy Detect IRQ occurs. */
-static inline void dwapb_save_out_value(struct uart_port *p, int offset,
-					int value)
-{
-	struct uart_8250_port *up =
-		container_of(p, struct uart_8250_port, port);
-
-	if (offset == UART_LCR)
-		up->lcr = value;
-}
-
-/* Read the IER to ensure any interrupt is cleared before returning from ISR. */
-static inline void dwapb_check_clear_ier(struct uart_port *p, int offset)
-{
-	if (offset == UART_TX || offset == UART_IER)
-		p->serial_in(p, UART_IER);
-}
-
-static void dwapb_serial_out(struct uart_port *p, int offset, int value)
-{
-	int save_offset = offset;
-	offset = map_8250_out_reg(p, offset) << p->regshift;
-	dwapb_save_out_value(p, save_offset, value);
-	writeb(value, p->membase + offset);
-	dwapb_check_clear_ier(p, save_offset);
-}
-
-static void dwapb32_serial_out(struct uart_port *p, int offset, int value)
-{
-	int save_offset = offset;
-	offset = map_8250_out_reg(p, offset) << p->regshift;
-	dwapb_save_out_value(p, save_offset, value);
-	writel(value, p->membase + offset);
-	dwapb_check_clear_ier(p, save_offset);
-}
-
 static unsigned int io_serial_in(struct uart_port *p, int offset)
 {
 	offset = map_8250_in_reg(p, offset) << p->regshift;
@@ -398,11 +349,6 @@ static void set_io_from_upio(struct uart_port *p)
 	struct uart_8250_port *up =
 		container_of(p, struct uart_8250_port, port);
 	switch (p->iotype) {
-	case UPIO_HUB6:
-		p->serial_in = hub6_serial_in;
-		p->serial_out = hub6_serial_out;
-		break;
-
 	case UPIO_MEM:
 		p->serial_in = mem_serial_in;
 		p->serial_out = mem_serial_out;
@@ -413,16 +359,6 @@ static void set_io_from_upio(struct uart_port *p)
 		p->serial_out = mem32_serial_out;
 		break;
 
-	case UPIO_DWAPB:
-		p->serial_in = mem_serial_in;
-		p->serial_out = dwapb_serial_out;
-		break;
-
-	case UPIO_DWAPB32:
-		p->serial_in = mem32_serial_in;
-		p->serial_out = dwapb32_serial_out;
-		break;
-
 	default:
 		p->serial_in = io_serial_in;
 		p->serial_out = io_serial_out;
@@ -440,8 +376,6 @@ serial_out_sync(struct uart_8250_port *up, int offset, int value)
 	case UPIO_MEM:
 	case UPIO_MEM32:
 	case UPIO_AU:
-	case UPIO_DWAPB:
-	case UPIO_DWAPB32:
 		p->serial_out(p, offset, value);
 		p->serial_in(p, UART_LCR);	/* safe, no side-effects */
 		break;
@@ -1512,8 +1446,7 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 			handled = 1;
 
 			end = NULL;
-		} else if ((up->port.iotype == UPIO_DWAPB ||
-			    up->port.iotype == UPIO_DWAPB32) &&
+		} else if ((up->port.type == PORT_DWAP) &&
 			  (iir & UART_IIR_BUSY) == UART_IIR_BUSY) {
 			/* The DesignWare APB UART has an Busy Detect (0x07)
 			 * interrupt meaning an LCR write attempt occurred while the
@@ -2421,8 +2354,6 @@ static int serial8250_request_std_resource(struct uart_8250_port *up)
 	case UPIO_TSI:
 	case UPIO_MEM32:
 	case UPIO_MEM:
-	case UPIO_DWAPB:
-	case UPIO_DWAPB32:
 		if (!up->port.mapbase)
 			break;
 
@@ -2459,8 +2390,6 @@ static void serial8250_release_std_resource(struct uart_8250_port *up)
 	case UPIO_TSI:
 	case UPIO_MEM32:
 	case UPIO_MEM:
-	case UPIO_DWAPB:
-	case UPIO_DWAPB32:
 		if (!up->port.mapbase)
 			break;
 
diff --git a/drivers/tty/serial/8250_hub6.c b/drivers/tty/serial/8250_hub6.c
index a5c778e..fd1361e 100644
--- a/drivers/tty/serial/8250_hub6.c
+++ b/drivers/tty/serial/8250_hub6.c
@@ -9,6 +9,21 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/serial_8250.h>
+#include <linux/io.h>
+
+static unsigned int hub6_serial_in(struct uart_port *p, int offset)
+{
+	offset = offset << p->regshift;
+	outb(p->hub6 - 1 + offset, p->iobase);
+	return inb(p->iobase + 1);
+}
+
+static void hub6_serial_out(struct uart_port *p, int offset, int value)
+{
+	offset = offset << p->regshift;
+	outb(p->hub6 - 1 + offset, p->iobase);
+	outb(value, p->iobase + 1);
+}
 
 #define HUB6(card,port)							\
 	{								\
@@ -18,6 +33,8 @@
 		.iotype		= UPIO_HUB6,				\
 		.flags		= UPF_BOOT_AUTOCONF,			\
 		.hub6		= (card) << 6 | (port) << 3 | 1,	\
+		.serial_in	= hub6_serial_in,			\
+		.serial_out	= hub6_serial_out,			\
 	}
 
 static struct plat_serial8250_port hub6_data[] = {
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index db7912c..e5a0cae 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2063,8 +2063,6 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
 	case UPIO_MEM32:
 	case UPIO_AU:
 	case UPIO_TSI:
-	case UPIO_DWAPB:
-	case UPIO_DWAPB32:
 		snprintf(address, sizeof(address),
 			 "MMIO 0x%llx", (unsigned long long)port->mapbase);
 		break;
@@ -2484,8 +2482,6 @@ int uart_match_port(struct uart_port *port1, struct uart_port *port2)
 	case UPIO_MEM32:
 	case UPIO_AU:
 	case UPIO_TSI:
-	case UPIO_DWAPB:
-	case UPIO_DWAPB32:
 		return (port1->mapbase == port2->mapbase);
 	}
 	return 0;
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index df295e0..598992f 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -46,7 +46,8 @@
 #define PORT_AR7	18	/* Texas Instruments AR7 internal UART */
 #define PORT_U6_16550A	19	/* ST-Ericsson U6xxx internal UART */
 #define PORT_TEGRA	20	/* NVIDIA Tegra internal UART */
-#define PORT_MAX_8250	20	/* max port ID */
+#define PORT_DWAP	21	/* Designware */
+#define PORT_MAX_8250	21	/* max port ID */
 
 /*
  * ARM specific type numbers.  These are not currently guaranteed
@@ -317,8 +318,6 @@ struct uart_port {
 #define UPIO_MEM32		(3)
 #define UPIO_AU			(4)			/* Au1x00 type IO */
 #define UPIO_TSI		(5)			/* Tsi108/109 type IO */
-#define UPIO_DWAPB		(6)			/* DesignWare APB UART */
-#define UPIO_DWAPB32		(8)			/* DesignWare APB UART (32 bit accesses) */
 
 	unsigned int		read_status_mask;	/* driver specific */
 	unsigned int		ignore_status_mask;	/* driver specific */
-- 
1.7.5.4

