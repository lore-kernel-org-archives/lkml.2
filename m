Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab2DFSea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 14:34:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:49576 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598Ab2DFSe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 14:34:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="129528179"
Subject: [PATCH 4/6] tegra, serial8250: add ->handle_break() uart_port op
To: gregkh@linuxfoundation.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: Sudhakar Mamillapalli <sudhakar@fb.com>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Nhan H Mai <nhan.h.mai@intel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, alan@linux.intel.com
Date: Fri, 06 Apr 2012 11:49:57 -0700
Message-ID: <20120406184956.22088.85217.stgit@dwillia2-linux.jf.intel.com>
In-Reply-To: <20120406184346.21744.18004.stgit@dwillia2-linux.jf.intel.com>
References: <20120406184346.21744.18004.stgit@dwillia2-linux.jf.intel.com>
User-Agent: StGit/0.16-1-g7004
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "KT" serial port has another use case for a "received break" quirk,
so before adding another special case to the 8250 core take this
opportunity to push such quirks out of the core and into a uart_port op.

Cc: Nhan H Mai <nhan.h.mai@intel.com>
Cc: Colin Cross <ccross@android.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Stephen Warren <swarren@nvidia.com>
Acked-by: Sudhakar Mamillapalli <sudhakar@fb.com>
Reported-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/arm/mach-tegra/board-harmony.c   |    1 +
 arch/arm/mach-tegra/board-paz00.c     |    2 ++
 arch/arm/mach-tegra/board-seaboard.c  |    1 +
 arch/arm/mach-tegra/board-trimslice.c |    1 +
 arch/arm/mach-tegra/devices.c         |   18 +++++++++++++++++
 arch/arm/mach-tegra/devices.h         |    2 ++
 drivers/tty/serial/8250/8250.c        |   34 +++------------------------------
 include/linux/serial_8250.h           |    1 +
 include/linux/serial_core.h           |    5 +++++
 9 files changed, 34 insertions(+), 31 deletions(-)

diff --git a/arch/arm/mach-tegra/board-harmony.c b/arch/arm/mach-tegra/board-harmony.c
index 789bdc9..7a4755b 100644
--- a/arch/arm/mach-tegra/board-harmony.c
+++ b/arch/arm/mach-tegra/board-harmony.c
@@ -52,6 +52,7 @@ static struct plat_serial8250_port debug_uart_platform_data[] = {
 		.irq		= INT_UARTD,
 		.flags		= UPF_BOOT_AUTOCONF | UPF_FIXED_TYPE,
 		.type		= PORT_TEGRA,
+		.handle_break	= tegra_serial_handle_break,
 		.iotype		= UPIO_MEM,
 		.regshift	= 2,
 		.uartclk	= 216000000,
diff --git a/arch/arm/mach-tegra/board-paz00.c b/arch/arm/mach-tegra/board-paz00.c
index 330afdf..9426e76 100644
--- a/arch/arm/mach-tegra/board-paz00.c
+++ b/arch/arm/mach-tegra/board-paz00.c
@@ -55,6 +55,7 @@ static struct plat_serial8250_port debug_uart_platform_data[] = {
 		.irq		= INT_UARTA,
 		.flags		= UPF_BOOT_AUTOCONF | UPF_FIXED_TYPE,
 		.type		= PORT_TEGRA,
+		.handle_break	= tegra_serial_handle_break,
 		.iotype		= UPIO_MEM,
 		.regshift	= 2,
 		.uartclk	= 216000000,
@@ -65,6 +66,7 @@ static struct plat_serial8250_port debug_uart_platform_data[] = {
 		.irq		= INT_UARTC,
 		.flags		= UPF_BOOT_AUTOCONF | UPF_FIXED_TYPE,
 		.type		= PORT_TEGRA,
+		.handle_break	= tegra_serial_handle_break,
 		.iotype		= UPIO_MEM,
 		.regshift	= 2,
 		.uartclk	= 216000000,
diff --git a/arch/arm/mach-tegra/board-seaboard.c b/arch/arm/mach-tegra/board-seaboard.c
index ebac65f..11b8d27 100644
--- a/arch/arm/mach-tegra/board-seaboard.c
+++ b/arch/arm/mach-tegra/board-seaboard.c
@@ -47,6 +47,7 @@ static struct plat_serial8250_port debug_uart_platform_data[] = {
 		/* Memory and IRQ filled in before registration */
 		.flags		= UPF_BOOT_AUTOCONF | UPF_FIXED_TYPE,
 		.type		= PORT_TEGRA,
+		.handle_break	= tegra_serial_handle_break,
 		.iotype		= UPIO_MEM,
 		.regshift	= 2,
 		.uartclk	= 216000000,
diff --git a/arch/arm/mach-tegra/board-trimslice.c b/arch/arm/mach-tegra/board-trimslice.c
index cd52820..e7763ff 100644
--- a/arch/arm/mach-tegra/board-trimslice.c
+++ b/arch/arm/mach-tegra/board-trimslice.c
@@ -48,6 +48,7 @@ static struct plat_serial8250_port debug_uart_platform_data[] = {
 		.irq		= INT_UARTA,
 		.flags		= UPF_BOOT_AUTOCONF | UPF_FIXED_TYPE,
 		.type		= PORT_TEGRA,
+		.handle_break	= tegra_serial_handle_break,
 		.iotype		= UPIO_MEM,
 		.regshift	= 2,
 		.uartclk	= 216000000,
diff --git a/arch/arm/mach-tegra/devices.c b/arch/arm/mach-tegra/devices.c
index 7a2a02d..d9301bc 100644
--- a/arch/arm/mach-tegra/devices.c
+++ b/arch/arm/mach-tegra/devices.c
@@ -17,11 +17,13 @@
  */
 
 
+#include <linux/delay.h>
 #include <linux/resource.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/fsl_devices.h>
 #include <linux/serial_8250.h>
+#include <linux/serial_reg.h>
 #include <linux/i2c-tegra.h>
 #include <linux/platform_data/tegra_usb.h>
 #include <asm/pmu.h>
@@ -704,3 +706,19 @@ struct platform_device tegra_pcm_device = {
 	.name = "tegra-pcm-audio",
 	.id = -1,
 };
+
+void tegra_serial_handle_break(struct uart_port *p)
+{
+	unsigned int status, tmout = 10000;
+
+	do {
+		status = p->serial_in(p, UART_LSR);
+		if (status & (UART_LSR_FIFOE | UART_LSR_BRK_ERROR_BITS))
+			status = p->serial_in(p, UART_RX);
+		else
+			break;
+		if (--tmout == 0)
+			break;
+		udelay(1);
+	} while (1);
+}
diff --git a/arch/arm/mach-tegra/devices.h b/arch/arm/mach-tegra/devices.h
index 873ecb2..c2253be 100644
--- a/arch/arm/mach-tegra/devices.h
+++ b/arch/arm/mach-tegra/devices.h
@@ -20,6 +20,7 @@
 #define __MACH_TEGRA_DEVICES_H
 
 #include <linux/platform_device.h>
+#include <linux/serial_8250.h>
 
 extern struct platform_device tegra_gpio_device;
 extern struct platform_device tegra_pinmux_device;
@@ -49,4 +50,5 @@ extern struct platform_device tegra_i2s_device2;
 extern struct platform_device tegra_das_device;
 extern struct platform_device tegra_pcm_device;
 
+void tegra_serial_handle_break(struct uart_port *p);
 #endif
diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index 0e2c703..d1e0b3d 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -1353,27 +1353,6 @@ static void serial8250_enable_ms(struct uart_port *port)
 }
 
 /*
- * Clear the Tegra rx fifo after a break
- *
- * FIXME: This needs to become a port specific callback once we have a
- * framework for this
- */
-static void clear_rx_fifo(struct uart_8250_port *up)
-{
-	unsigned int status, tmout = 10000;
-	do {
-		status = serial_in(up, UART_LSR);
-		if (status & (UART_LSR_FIFOE | UART_LSR_BRK_ERROR_BITS))
-			status = serial_in(up, UART_RX);
-		else
-			break;
-		if (--tmout == 0)
-			break;
-		udelay(1);
-	} while (1);
-}
-
-/*
  * serial8250_rx_chars: processes according to the passed in LSR
  * value, and returns the remaining LSR bits not handled
  * by this Rx routine.
@@ -1406,20 +1385,10 @@ serial8250_rx_chars(struct uart_8250_port *up, unsigned char lsr)
 		up->lsr_saved_flags = 0;
 
 		if (unlikely(lsr & UART_LSR_BRK_ERROR_BITS)) {
-			/*
-			 * For statistics only
-			 */
 			if (lsr & UART_LSR_BI) {
 				lsr &= ~(UART_LSR_FE | UART_LSR_PE);
 				up->port.icount.brk++;
 				/*
-				 * If tegra port then clear the rx fifo to
-				 * accept another break/character.
-				 */
-				if (up->port.type == PORT_TEGRA)
-					clear_rx_fifo(up);
-
-				/*
 				 * We do the SysRQ and SAK checking
 				 * here because otherwise the break
 				 * may get masked by ignore_status_mask
@@ -3047,6 +3016,7 @@ static int __devinit serial8250_probe(struct platform_device *dev)
 		port.serial_in		= p->serial_in;
 		port.serial_out		= p->serial_out;
 		port.handle_irq		= p->handle_irq;
+		port.handle_break	= p->handle_break;
 		port.set_termios	= p->set_termios;
 		port.pm			= p->pm;
 		port.dev		= &dev->dev;
@@ -3219,6 +3189,8 @@ int serial8250_register_port(struct uart_port *port)
 			uart->port.set_termios = port->set_termios;
 		if (port->pm)
 			uart->port.pm = port->pm;
+		if (port->handle_break)
+			uart->port.handle_break = port->handle_break;
 
 		if (serial8250_isa_config != NULL)
 			serial8250_isa_config(0, &uart->port,
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index 8f012f8..a522fd9 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -38,6 +38,7 @@ struct plat_serial8250_port {
 	int		(*handle_irq)(struct uart_port *);
 	void		(*pm)(struct uart_port *, unsigned int state,
 			      unsigned old);
+	void		(*handle_break)(struct uart_port *);
 };
 
 /*
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index cbb3d12..82f6147 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -308,6 +308,7 @@ struct uart_port {
 	int			(*handle_irq)(struct uart_port *);
 	void			(*pm)(struct uart_port *, unsigned int state,
 				      unsigned int old);
+	void			(*handle_break)(struct uart_port *);
 	unsigned int		irq;			/* irq number */
 	unsigned long		irqflags;		/* irq flags  */
 	unsigned int		uartclk;		/* base uart clock */
@@ -521,6 +522,10 @@ uart_handle_sysrq_char(struct uart_port *port, unsigned int ch)
 static inline int uart_handle_break(struct uart_port *port)
 {
 	struct uart_state *state = port->state;
+
+	if (port->handle_break)
+		port->handle_break(port);
+
 #ifdef SUPPORT_SYSRQ
 	if (port->cons && port->cons->index == port->line) {
 		if (!port->sysrq) {

