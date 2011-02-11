Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab1BKOjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:39:46 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54325 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab1BKOji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:39:38 -0500
From: Subhasish Ghosh <subhasish@mistralsolutions.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        Greg Kroah-Hartman <gregkh@suse.de> (maintainer:TTY LAYER 
	,commit_signer:1/3=33%,commit_signer:1/2=50%),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 13/13] tty: pruss SUART driver
Date: Fri, 11 Feb 2011 20:21:32 +0530
Message-Id: <1297435892-28278-14-git-send-email-subhasish@mistralsolutions.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the TTY compliant
Soft-UART device emulated on PRUSS.

Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
---
 drivers/tty/serial/Kconfig                         |    2 +
 drivers/tty/serial/Makefile                        |    1 +
 drivers/tty/serial/da8xx_pruss/Kconfig             |   19 +
 drivers/tty/serial/da8xx_pruss/Makefile            |    9 +
 drivers/tty/serial/da8xx_pruss/pruss_suart.c       | 1014 +++++++++
 drivers/tty/serial/da8xx_pruss/pruss_suart_api.c   | 2350 ++++++++++++++++++++
 drivers/tty/serial/da8xx_pruss/pruss_suart_api.h   |  345 +++
 drivers/tty/serial/da8xx_pruss/pruss_suart_board.h |   58 +
 drivers/tty/serial/da8xx_pruss/pruss_suart_err.h   |   48 +
 drivers/tty/serial/da8xx_pruss/pruss_suart_mcasp.h |  526 +++++
 drivers/tty/serial/da8xx_pruss/pruss_suart_regs.h  |  153 ++
 drivers/tty/serial/da8xx_pruss/pruss_suart_utils.c |  384 ++++
 drivers/tty/serial/da8xx_pruss/pruss_suart_utils.h |   63 +
 include/linux/serial_core.h                        |    2 +
 14 files changed, 4974 insertions(+), 0 deletions(-)
 create mode 100644 drivers/tty/serial/da8xx_pruss/Kconfig
 create mode 100644 drivers/tty/serial/da8xx_pruss/Makefile
 create mode 100644 drivers/tty/serial/da8xx_pruss/pruss_suart.c
 create mode 100644 drivers/tty/serial/da8xx_pruss/pruss_suart_api.c
 create mode 100644 drivers/tty/serial/da8xx_pruss/pruss_suart_api.h
 create mode 100644 drivers/tty/serial/da8xx_pruss/pruss_suart_board.h
 create mode 100644 drivers/tty/serial/da8xx_pruss/pruss_suart_err.h
 create mode 100644 drivers/tty/serial/da8xx_pruss/pruss_suart_mcasp.h
 create mode 100644 drivers/tty/serial/da8xx_pruss/pruss_suart_regs.h
 create mode 100644 drivers/tty/serial/da8xx_pruss/pruss_suart_utils.c
 create mode 100644 drivers/tty/serial/da8xx_pruss/pruss_suart_utils.h

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index b1682d7..68c40c2 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1595,4 +1595,6 @@ config SERIAL_PCH_UART
 	  This driver is for PCH(Platform controller Hub) UART of Intel EG20T
 	  which is an IOH(Input/Output Hub) for x86 embedded processor.
 	  Enabling PCH_DMA, this PCH UART works as DMA mode.
+
+source "drivers/tty/serial/da8xx_pruss/Kconfig"
 endmenu
diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
index 8ea92e9..51c89e9 100644
--- a/drivers/tty/serial/Makefile
+++ b/drivers/tty/serial/Makefile
@@ -92,3 +92,4 @@ obj-$(CONFIG_SERIAL_MRST_MAX3110)	+= mrst_max3110.o
 obj-$(CONFIG_SERIAL_MFD_HSU)	+= mfd.o
 obj-$(CONFIG_SERIAL_IFX6X60)  	+= ifx6x60.o
 obj-$(CONFIG_SERIAL_PCH_UART)	+= pch_uart.o
+obj-$(CONFIG_SERIAL_PRUSS_SUART)	+= da8xx_pruss/
diff --git a/drivers/tty/serial/da8xx_pruss/Kconfig b/drivers/tty/serial/da8xx_pruss/Kconfig
new file mode 100644
index 0000000..23ac53f
--- /dev/null
+++ b/drivers/tty/serial/da8xx_pruss/Kconfig
@@ -0,0 +1,19 @@
+#
+# SUART Kernel Configuration
+#
+
+config SERIAL_PRUSS_SUART
+	depends on ARCH_DAVINCI && ARCH_DAVINCI_DA850
+	select SERIAL_CORE
+	tristate "PRUSS based SoftUART emulation on DA8XX"
+	---help---
+	Enable this to emulate a UART controller on the PRUSS of DA8XX.
+	If not sure, mark N
+
+config PRUSS_SUART_MCASP
+    int "McASP number"
+    depends on ARCH_DAVINCI && ARCH_DAVINCI_DA830 && SERIAL_PRUSS_SUART
+    default "0"
+    ---help---
+    Enter the McASP number to use with SUART (0, 1 or 2).
+	You will need to recompile the kernel if this is changed.
diff --git a/drivers/tty/serial/da8xx_pruss/Makefile b/drivers/tty/serial/da8xx_pruss/Makefile
new file mode 100644
index 0000000..34a5b1f
--- /dev/null
+++ b/drivers/tty/serial/da8xx_pruss/Makefile
@@ -0,0 +1,9 @@
+#
+# Makefile for SoftUART emulation
+#
+
+suart_emu-objs :=       pruss_suart.o \
+                        pruss_suart_api.o \
+                        pruss_suart_utils.o
+
+obj-$(CONFIG_SERIAL_PRUSS_SUART)        += suart_emu.o
diff --git a/drivers/tty/serial/da8xx_pruss/pruss_suart.c b/drivers/tty/serial/da8xx_pruss/pruss_suart.c
new file mode 100644
index 0000000..d222e2e
--- /dev/null
+++ b/drivers/tty/serial/da8xx_pruss/pruss_suart.c
@@ -0,0 +1,1014 @@
+/*
+ * PRUSS SUART Emulation device driver
+ * Author: subhasish@mistralsolutions.com
+ *
+ * This driver supports TI's PRU SUART Emulation and the
+ * specs for the same is available at <http://www.ti.com>
+ *
+ * Copyright (C) 2009 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed as is WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
+#include <linux/serial.h>
+#include <linux/serial_core.h>
+#include <linux/module.h>
+#include <mach/da8xx.h>
+#include <linux/platform_device.h>
+#include <linux/firmware.h>
+#include <linux/clk.h>
+#include <linux/serial_reg.h>
+#include <linux/delay.h>
+#include <mach/sram.h>
+#include "pruss_suart_board.h"
+#include "pruss_suart_api.h"
+#include "pruss_suart_utils.h"
+#include "pruss_suart_err.h"
+
+#define NR_SUART			8
+#define DRV_NAME			"da8xx_pruss_uart"
+#define DRV_DESC			"PRUSS SUART Driver v1.0"
+#define MAX_SUART_RETRIES		100
+#define SUART_CNTX_SZ			512
+#define SUART_FIFO_TIMEOUT_DFLT		5
+#define SUART_FIFO_TIMEOUT_MIN		4
+#define SUART_FIFO_TIMEOUT_MAX		500
+
+#ifdef __SUART_DEBUG
+#define __suart_debug(fmt, args...) \
+		printk(KERN_DEBUG "suart_debug: " fmt, ## args)
+#else
+#define __suart_debug(fmt, args...)
+#endif
+
+#define  __suart_err(fmt, args...) printk(KERN_ERR "suart_err: " fmt, ## args)
+
+/* Default timeout set to 5ms */
+static s16 suart_timeout = SUART_FIFO_TIMEOUT_DFLT;
+module_param(suart_timeout, short, S_IRUGO);
+MODULE_PARM_DESC(suart_timeout,
+		 "fifo timeout in milli seconds (min: 4; max: 500)");
+
+struct suart_fifo {
+	void *fifo_vaddr_buff_tx;
+	void *fifo_vaddr_buff_rx;
+	void *fifo_phys_addr_tx;
+	void *fifo_phys_addr_rx;
+};
+
+struct omapl_pru_suart {
+	struct uart_port port[NR_SUART];
+	struct device *dev; /* pdev->dev */
+	struct semaphore port_sem[NR_SUART];
+	struct clk *clk_mcasp;
+	struct suart_fifo suart_fifo_addr[NR_SUART];
+	const struct firmware *fw;
+	suart_struct_handle suart_hdl[NR_SUART];
+	pruss_suart_iomap suart_iomap;
+	u32 clk_freq_pru;
+	u32 clk_freq_mcasp;
+	u32 tx_loadsz;
+};
+
+static u32 suart_get_duplex(struct omapl_pru_suart *soft_uart, u32 uart_no)
+{
+	return soft_uart->suart_hdl[uart_no].uart_type;
+}
+
+static inline void __stop_tx(struct omapl_pru_suart *soft_uart, u32 uart_no)
+{
+	struct device *dev = soft_uart->dev;
+	u16 txready;
+	u32 i;
+
+	/* Check if any TX in progress */
+	for (i = 0, txready = 1; (i < 10000) && txready; i++) {
+		txready = (pru_softuart_get_tx_status
+			(dev, &soft_uart->suart_hdl[uart_no]) &
+				CHN_TXRX_STATUS_RDY);
+	}
+	/* To stop tx, disable the TX interrupt */
+	suart_intr_clrmask(dev, soft_uart->suart_hdl[uart_no].uart_num,
+				PRU_TX_INTR, CHN_TXRX_IE_MASK_CMPLT);
+	pru_softuart_clr_tx_status(dev, &soft_uart->suart_hdl[uart_no]);
+}
+
+static void pruss_suart_stop_tx(struct uart_port *port)
+{
+	struct omapl_pru_suart *soft_uart =
+	    container_of(port, struct omapl_pru_suart, port[port->line]);
+	__stop_tx(soft_uart, port->line);
+}
+
+static void omapl_pru_tx_chars(struct omapl_pru_suart *soft_uart, u32 uart_no)
+{
+	struct circ_buf *xmit = &soft_uart->port[uart_no].state->xmit;
+	struct device *dev = soft_uart->dev;
+	s32 count = 0;
+
+	if (!(suart_get_duplex(soft_uart, uart_no) & ePRU_SUART_HALF_TX))
+		return;
+
+	if (down_trylock(&soft_uart->port_sem[uart_no]))
+		return;
+
+	if (uart_circ_empty(xmit) ||
+			uart_tx_stopped(&soft_uart->port[uart_no])) {
+		pruss_suart_stop_tx(&soft_uart->port[uart_no]);
+		up(&soft_uart->port_sem[uart_no]);
+		return;
+	}
+
+	for (count = 0; count <= soft_uart->tx_loadsz; count++) {
+		*((s8 *)soft_uart->suart_fifo_addr[uart_no].fifo_vaddr_buff_tx
+		+ count) = xmit->buf[xmit->tail];
+		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
+		soft_uart->port[uart_no].icount.tx++;
+		if (uart_circ_empty(xmit)) {
+			uart_circ_clear(xmit);
+			break;
+		}
+	}
+
+	if (count == (SUART_FIFO_LEN + 1))
+		count = SUART_FIFO_LEN;
+
+	/* Write the character to the data port */
+	if (SUART_SUCCESS != pru_softuart_write(dev,
+		&soft_uart->suart_hdl[uart_no],
+			(u32 *)&soft_uart->suart_fifo_addr
+				[uart_no].fifo_phys_addr_tx, count)) {
+		__suart_err("failed to tx data\n");
+	}
+
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+		uart_write_wakeup(&soft_uart->port[uart_no]);
+
+#if 0
+	if (uart_circ_empty(xmit))
+		__stop_tx(soft_uart, uart_no);
+#endif
+}
+
+static void omapl_pru_rx_chars(struct omapl_pru_suart *soft_uart, u32 uart_no)
+{
+	struct tty_struct *tty = soft_uart->port[uart_no].state->port.tty;
+	struct device *dev = soft_uart->dev;
+	s8 flags = TTY_NORMAL;
+	u16 rx_status, data_len = SUART_FIFO_LEN;
+	u32 data_len_read;
+	u8 suart_data[SUART_FIFO_LEN + 1];
+	s32 i = 0;
+
+	if (!(suart_get_duplex(soft_uart, uart_no) & ePRU_SUART_HALF_RX))
+		return;
+	/* read the status */
+	rx_status = pru_softuart_get_rx_status(dev,
+			&soft_uart->suart_hdl[uart_no]);
+
+	/* check for errors */
+	if (rx_status & CHN_TXRX_STATUS_ERR) {
+		if (rx_status & CHN_TXRX_STATUS_FE)
+			soft_uart->port[uart_no].icount.frame++;
+		if (rx_status & CHN_TXRX_STATUS_OVRNERR)
+			soft_uart->port[uart_no].icount.overrun++;
+		if (rx_status & CHN_TXRX_STATUS_BI)
+			soft_uart->port[uart_no].icount.brk++;
+		rx_status &= soft_uart->port[uart_no].read_status_mask;
+		if (rx_status & CHN_TXRX_STATUS_FE)
+			flags = TTY_FRAME;
+		if (rx_status & CHN_TXRX_STATUS_OVRNERR)
+			flags = TTY_OVERRUN;
+		if (rx_status & CHN_TXRX_STATUS_BI)
+			flags = TTY_BREAK;
+
+#ifdef SUPPORT_SYSRQ
+		soft_uart->port[uart_no].sysrq = 0;
+#endif
+	} else {
+		pru_softuart_read_data(dev, &soft_uart->suart_hdl[uart_no],
+				       suart_data, data_len + 1,
+				       &data_len_read);
+
+		for (i = 0; i <= data_len_read; i++) {
+			soft_uart->port[uart_no].icount.rx++;
+			/* check for sys rq */
+			if (uart_handle_sysrq_char
+			    (&soft_uart->port[uart_no], suart_data))
+				continue;
+		}
+		/* update the tty data structure */
+		tty_insert_flip_string(tty, suart_data, data_len_read);
+	}
+
+	/* push data into tty */
+	pru_softuart_clr_rx_status(dev, &soft_uart->suart_hdl[uart_no]);
+	spin_unlock(&soft_uart->port[uart_no].lock);
+	tty_flip_buffer_push(tty);
+	spin_lock(&soft_uart->port[uart_no].lock);
+}
+
+static irqreturn_t pruss_suart_interrupt(s32 irq, void *dev_id)
+{
+	struct uart_port *port = dev_id;
+	struct omapl_pru_suart *soft_uart =
+	    container_of(port, struct omapl_pru_suart, port[port->line]);
+	struct device *dev = soft_uart->dev;
+	u16 txrx_flag;
+	u32 ret;
+	unsigned long flags = 0;
+	u16 uart_num = port->line + 1;
+
+	spin_lock_irqsave(&soft_uart->port[port->line].lock, flags);
+	do {
+		ret = pru_softuart_get_isrstatus(dev, uart_num, &txrx_flag);
+		if (PRU_SUART_SUCCESS != ret) {
+			__suart_err("suart%d: failed to get interrupt, ret:"
+				" 0x%X txrx_flag 0x%X\n",
+				port->line, ret, txrx_flag);
+			spin_unlock_irqrestore(&soft_uart->
+				port[port->line].lock, flags);
+			return IRQ_NONE;
+		}
+		if ((PRU_RX_INTR & txrx_flag) == PRU_RX_INTR) {
+			pru_intr_clr_isrstatus(dev, uart_num, PRU_RX_INTR);
+			if ((soft_uart->port[port->line].ignore_status_mask &
+				CHN_TXRX_STATUS_RDY) == CHN_TXRX_STATUS_RDY) {
+				pru_softuart_clr_rx_status(dev,
+					&soft_uart->suart_hdl
+				[port->line]);
+			} else {
+				omapl_pru_rx_chars(soft_uart, port->line);
+			}
+		}
+
+		if ((PRU_TX_INTR & txrx_flag) == PRU_TX_INTR) {
+			pru_intr_clr_isrstatus(dev, uart_num, PRU_TX_INTR);
+			pru_softuart_clr_tx_status(dev, &soft_uart->suart_hdl
+						 [port->line]);
+			up(&soft_uart->port_sem[port->line]);
+			omapl_pru_tx_chars(soft_uart, port->line);
+		}
+	} while (txrx_flag & (PRU_RX_INTR | PRU_TX_INTR));
+
+	spin_unlock_irqrestore(&soft_uart->port[port->line].lock, flags);
+	return IRQ_HANDLED;
+}
+
+static void pruss_suart_stop_rx(struct uart_port *port)
+{
+	struct omapl_pru_suart *soft_uart =
+	    container_of(port, struct omapl_pru_suart, port[port->line]);
+	struct device *dev = soft_uart->dev;
+	/* disable rx interrupt */
+	suart_intr_clrmask(dev, soft_uart->suart_hdl[port->line].uart_num,
+			   PRU_RX_INTR, CHN_TXRX_IE_MASK_BI
+			   | CHN_TXRX_IE_MASK_FE | CHN_TXRX_IE_MASK_CMPLT
+			   | CHN_TXRX_IE_MASK_TIMEOUT);
+}
+
+static void pruss_suart_enable_ms(struct uart_port *port)
+{
+	__suart_err("modem control timer not supported\n");
+}
+
+static void pruss_suart_start_tx(struct uart_port *port)
+{
+	struct omapl_pru_suart *soft_uart =
+	    container_of(port, struct omapl_pru_suart, port[port->line]);
+	struct device *dev = soft_uart->dev;
+	/* unmask the tx interrupts */
+
+	suart_intr_setmask(dev, soft_uart->suart_hdl[port->line].uart_num,
+			   PRU_TX_INTR, CHN_TXRX_IE_MASK_CMPLT);
+	omapl_pru_tx_chars(soft_uart, port->line);
+}
+
+static u32 pruss_suart_tx_empty(struct uart_port *port)
+{
+	struct omapl_pru_suart *soft_uart =
+	    container_of(port, struct omapl_pru_suart, port[port->line]);
+	struct device *dev = soft_uart->dev;
+
+	return (pru_softuart_get_tx_status(dev,
+		&soft_uart->suart_hdl[port->line])
+		& CHN_TXRX_STATUS_RDY) ? 0 : TIOCSER_TEMT;
+}
+
+static u32 pruss_suart_get_mctrl(struct uart_port *port)
+{
+	return -ENOTSUPP;
+}
+
+static void pruss_suart_set_mctrl(struct uart_port *port, u32 mctrl)
+{
+	__suart_debug("modem control not supported\n");
+}
+
+static void pruss_suart_break_ctl(struct uart_port *port, s32 break_state)
+{
+	struct omapl_pru_suart *soft_uart =
+	    container_of(port, struct omapl_pru_suart, port[port->line]);
+	struct device *dev = soft_uart->dev;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	if (break_state == -1)
+		suart_intr_clrmask(dev,
+			soft_uart->suart_hdl[port->line].uart_num,
+			PRU_RX_INTR, CHN_TXRX_IE_MASK_BI);
+	else
+		suart_intr_setmask(dev,
+			soft_uart->suart_hdl[port->line].uart_num,
+			PRU_RX_INTR, CHN_TXRX_IE_MASK_BI);
+
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+
+static void pruss_suart_set_termios(struct uart_port *port,
+				  struct ktermios *termios,
+				  struct ktermios *old)
+{
+	struct omapl_pru_suart *soft_uart =
+	    container_of(port, struct omapl_pru_suart, port[port->line]);
+	struct device *dev = soft_uart->dev;
+	u8 cval = 0;
+	unsigned long flags = 0;
+	u32 baud = 0;
+	u32 old_csize = old ? old->c_cflag & CSIZE : CS8;
+
+/*
+ * Do not allow unsupported configurations to be set
+ */
+	if (1) {
+		termios->c_cflag &= ~(HUPCL | CRTSCTS | CMSPAR | CSTOPB
+				      | PARENB | PARODD | CMSPAR);
+		termios->c_cflag |= CLOCAL;
+	}
+
+	switch (termios->c_cflag & CSIZE) {
+	case CS6:
+		cval = ePRU_SUART_DATA_BITS6;
+		break;
+	case CS7:
+		cval = ePRU_SUART_DATA_BITS7;
+		break;
+	default:
+	case CS8:
+		cval = ePRU_SUART_DATA_BITS8;
+		break;
+	}
+	/*
+	 * We do not support CS5.
+	 */
+	if ((termios->c_cflag & CSIZE) == CS5) {
+		termios->c_cflag &= ~CSIZE;
+		termios->c_cflag |= old_csize;
+	}
+	if (SUART_SUCCESS != pru_softuart_setdatabits
+		(dev, &soft_uart->suart_hdl[port->line], cval, cval))
+		__suart_err("failed to set data bits to: %d\n", cval);
+
+/*
+ * Ask the core to calculate the divisor for us.
+ */
+	baud = uart_get_baud_rate(port, termios, old,
+			  port->uartclk / 16 / 0xffff,
+			  port->uartclk / 16);
+
+/*
+ * Ok, we're now changing the port state.  Do it with
+ * interrupts disabled.
+ */
+	spin_lock_irqsave(&port->lock, flags);
+
+	/* Set the baud */
+	if (SUART_SUCCESS !=
+	    pru_softuart_setbaud(dev, &soft_uart->suart_hdl[port->line],
+				 SUART_DEFAULT_BAUD / baud,
+				 SUART_DEFAULT_BAUD / baud))
+		__suart_err("failed to set baud to: %d\n", baud);
+
+/*
+ * update port->read_config_mask and port->ignore_config_mask
+ * to indicate the events we are interested in receiving
+ */
+	suart_intr_setmask(dev, soft_uart->suart_hdl[port->line].uart_num,
+			   PRU_RX_INTR, SUART_GBL_INTR_ERR_MASK);
+	port->read_status_mask = 0;
+	if (termios->c_iflag & INPCK) {	/* Input parity check not supported,
+					just enabled FE */
+		port->read_status_mask |= CHN_TXRX_STATUS_FE;
+		suart_intr_setmask(dev,
+			soft_uart->suart_hdl[port->line].uart_num,
+			PRU_RX_INTR, CHN_TXRX_IE_MASK_FE);
+	}
+	if (termios->c_iflag & (BRKINT | PARMRK)) {
+		port->read_status_mask |= CHN_TXRX_STATUS_BI;
+		suart_intr_setmask(dev,
+			soft_uart->suart_hdl[port->line].uart_num,
+			PRU_RX_INTR, CHN_TXRX_IE_MASK_BI);
+	}
+/*
+ * Characteres to ignore
+ */
+	port->ignore_status_mask = 0;
+	if (termios->c_iflag & IGNBRK) {
+		port->ignore_status_mask |= CHN_TXRX_STATUS_BI;
+		/*
+		 * If we're ignoring break indicators,
+		 * ignore overruns too (for real raw support).
+		 */
+		if (termios->c_iflag & IGNPAR) {
+			port->ignore_status_mask |=
+			    (CHN_TXRX_STATUS_OVRNERR | CHN_TXRX_STATUS_FE);
+			/*
+			 * Overrun in case of RX
+			 * Underrun in case of TX
+			 */
+			suart_intr_clrmask(dev, soft_uart->
+					   suart_hdl[port->line].uart_num,
+					   PRU_RX_INTR, CHN_TXRX_IE_MASK_FE);
+		}
+		suart_intr_clrmask(dev,
+			soft_uart->suart_hdl[port->line].uart_num,
+			PRU_RX_INTR, CHN_TXRX_IE_MASK_BI);
+	}
+/*
+ * ignore all characters if CREAD is not set
+ */
+	if ((termios->c_cflag & CREAD) == 0) {
+		port->ignore_status_mask |= CHN_TXRX_STATUS_RDY;
+		pruss_suart_stop_rx(port);
+	}
+
+	spin_unlock_irqrestore(&port->lock, flags);
+	/* Don't rewrite B0 */
+	if (tty_termios_baud_rate(termios))
+		tty_termios_encode_baud_rate(termios, baud, baud);
+}
+
+/*
+ *	Grab any interrupt resources and initialise any low level driver
+ *	state.  Enable the port for reception.  It should not activate
+ *	RTS nor DTR; this will be done via a separate call to set_mctrl.
+ *
+ *	This method will only be called when the port is initially opened.
+ *
+ *	Locking: port_sem taken.
+ *	Interrupts: globally disabled.
+ */
+static s32 pruss_suart_startup(struct uart_port *port)
+{
+	struct omapl_pru_suart *soft_uart =
+	    container_of(port, struct omapl_pru_suart, port[port->line]);
+	struct device *dev = soft_uart->dev;
+	s32 retval;
+
+	/*
+	 * Disable interrupts from this port
+	 */
+	suart_intr_clrmask(dev, soft_uart->suart_hdl[port->line].uart_num,
+			   PRU_TX_INTR, CHN_TXRX_IE_MASK_CMPLT);
+	suart_intr_clrmask(dev, soft_uart->suart_hdl[port->line].uart_num,
+			   PRU_RX_INTR, CHN_TXRX_IE_MASK_BI
+			   | CHN_TXRX_IE_MASK_FE | CHN_TXRX_IE_MASK_CMPLT
+			   | CHN_TXRX_IE_MASK_TIMEOUT);
+
+	retval = request_irq(port->irq, pruss_suart_interrupt,
+			     port->irqflags, "suart_irq", port);
+	if (retval) {
+		free_irq(port->irq, port); /* should we free this if err */
+		goto out;
+	}
+	/*
+	 * enable interrupts from this port
+	 */
+	suart_intr_setmask(dev, soft_uart->suart_hdl[port->line].uart_num,
+			   PRU_RX_INTR, SUART_GBL_INTR_ERR_MASK);
+
+	suart_intr_setmask(dev, soft_uart->suart_hdl[port->line].uart_num,
+			   PRU_RX_INTR, CHN_TXRX_IE_MASK_BI
+			   | CHN_TXRX_IE_MASK_FE | CHN_TXRX_IE_MASK_CMPLT
+			   | CHN_TXRX_IE_MASK_TIMEOUT);
+
+	suart_intr_setmask(dev, soft_uart->suart_hdl[port->line].uart_num,
+			   PRU_TX_INTR, CHN_TXRX_IE_MASK_CMPLT);
+
+	if ((suart_get_duplex(soft_uart, port->line) & ePRU_SUART_HALF_TX)
+	    == ePRU_SUART_HALF_TX) {
+		suart_pru_to_host_intr_enable(dev, soft_uart->
+			suart_hdl[port->line].uart_num, PRU_TX_INTR, true);
+	}
+	/* Seed RX if port is half-rx or full-duplex */
+	if ((suart_get_duplex(soft_uart, port->line) & ePRU_SUART_HALF_RX)
+		== ePRU_SUART_HALF_RX) {
+		suart_pru_to_host_intr_enable(dev, soft_uart->
+			suart_hdl[port->line].uart_num, PRU_RX_INTR, true);
+		pru_softuart_read(dev, &soft_uart->suart_hdl[port->line],
+			(u32 *)&soft_uart->suart_fifo_addr[port->line].
+			fifo_phys_addr_rx, SUART_FIFO_LEN);
+	}
+out:
+	return retval;
+}
+
+/*
+ * Disable the port, disable any break condition that may be in
+ * effect, and free any interrupt resources.  It should not disable
+ * RTS nor DTR; this will have already been done via a separate
+ * call to set_mctrl.
+ *
+ * Drivers must not access port->info once this call has completed.
+ *
+ * This method will only be called when there are no more users of
+ * this port.
+ *
+ * Locking: port_sem taken.
+ * Interrupts: caller dependent.
+ */
+
+static void pruss_suart_shutdown(struct uart_port *port)
+{
+	struct omapl_pru_suart *soft_uart =
+	    container_of(port, struct omapl_pru_suart, port[port->line]);
+	struct device *dev = soft_uart->dev;
+
+	/*
+	 * Disable interrupts from this port
+	 */
+	/* Disable BI and FE intr */
+	suart_intr_clrmask(dev, soft_uart->suart_hdl[port->line].uart_num,
+			   PRU_TX_INTR, CHN_TXRX_IE_MASK_CMPLT);
+	suart_intr_clrmask(dev, soft_uart->suart_hdl[port->line].uart_num,
+			   PRU_RX_INTR, CHN_TXRX_IE_MASK_BI
+			   | CHN_TXRX_IE_MASK_FE | CHN_TXRX_IE_MASK_CMPLT
+			   | CHN_TXRX_IE_MASK_TIMEOUT);
+
+	/* free interrupts */
+	free_irq(port->irq, port);
+}
+
+/*
+ * Return a pointer to a string constant describing the specified
+ * port, or return NULL, in which case the string 'unknown' is
+ * substituted.
+ *
+ * Locking: none.
+ * Interrupts: caller dependent.
+ */
+
+static const char *pruss_suart_type(struct uart_port *port)
+{
+	return "suart_tty";
+}
+
+/*
+ * Release any memory and IO region resources currently in use by
+ * the port.
+ *
+ * Locking: none.
+ * Interrupts: caller dependent.
+ */
+
+static void pruss_suart_release_port(struct uart_port *port)
+{
+	struct omapl_pru_suart *soft_uart =
+	    container_of(port, struct omapl_pru_suart, port[port->line]);
+	struct platform_device *pdev = to_platform_device(port->dev);
+
+	if (0 != pru_softuart_close(&soft_uart->suart_hdl[port->line]))
+		dev_err(&pdev->dev, "failed to close suart\n");
+
+	return;
+}
+
+/*
+ * Request any memory and IO region resources required by the port.
+ * If any fail, no resources should be registered when this function
+ * returns, and it should return -EBUSY on failure.
+ *
+ * Locking: none.
+ * Interrupts: caller dependent.
+ *
+ * We need to d/l the f/w in probe and since this api
+ * is called per uart, the request_mem_region should
+ * be called in probe itself.
+ */
+static s32 pruss_suart_request_port(struct uart_port *port)
+{
+	struct omapl_pru_suart *soft_uart =
+	    container_of(port, struct omapl_pru_suart, port[port->line]);
+	struct platform_device *pdev = to_platform_device(port->dev);
+	struct device *dev = soft_uart->dev;
+	suart_config pru_suart_config;
+	s16 timeout = 0;
+	u32 err = 0;
+
+	if (soft_uart == NULL) {
+		__suart_err("soft_uart ptr failed\n");
+		return -ENODEV;
+	}
+	err = pru_softuart_open(&soft_uart->suart_hdl[port->line]);
+	if (PRU_SUART_SUCCESS != err) {
+		dev_err(&pdev->dev, "failed to open suart: %d\n", err);
+		err = -ENODEV;
+		goto exit;
+	}
+
+	/* set fifo /timeout */
+	if (SUART_FIFO_TIMEOUT_MIN > suart_timeout) {
+		__suart_err("fifo timeout less than %d ms not supported\n",
+			    SUART_FIFO_TIMEOUT_MIN);
+		suart_timeout = SUART_FIFO_TIMEOUT_MIN;
+	} else if (SUART_FIFO_TIMEOUT_MAX < suart_timeout) {
+		__suart_err("fifo timeout more than %d ms not supported\n",
+			    SUART_FIFO_TIMEOUT_MAX);
+		suart_timeout = SUART_FIFO_TIMEOUT_MAX;
+	}
+
+	/* This is only for x8 */
+	timeout = (SUART_DEFAULT_BAUD * suart_timeout) / 1000;
+	pru_set_fifo_timeout(dev, timeout);
+
+	if (soft_uart->suart_hdl[port->line].uart_num == PRU_SUART_UART1) {
+		pru_suart_config.tx_serializer = PRU_SUART0_CONFIG_TX_SER;
+		pru_suart_config.rx_serializer = PRU_SUART0_CONFIG_RX_SER;
+	} else if (soft_uart->suart_hdl[port->line].uart_num ==
+							PRU_SUART_UART2) {
+		pru_suart_config.tx_serializer = PRU_SUART1_CONFIG_TX_SER;
+		pru_suart_config.rx_serializer = PRU_SUART1_CONFIG_RX_SER;
+	} else if (soft_uart->suart_hdl[port->line].uart_num ==
+							PRU_SUART_UART3) {
+		pru_suart_config.tx_serializer = PRU_SUART2_CONFIG_TX_SER;
+		pru_suart_config.rx_serializer = PRU_SUART2_CONFIG_RX_SER;
+	} else if (soft_uart->suart_hdl[port->line].uart_num ==
+							PRU_SUART_UART4) {
+		pru_suart_config.tx_serializer = PRU_SUART3_CONFIG_TX_SER;
+		pru_suart_config.rx_serializer = PRU_SUART3_CONFIG_RX_SER;
+	} else if (soft_uart->suart_hdl[port->line].uart_num ==
+							PRU_SUART_UART5) {
+		pru_suart_config.tx_serializer = PRU_SUART4_CONFIG_TX_SER;
+		pru_suart_config.rx_serializer = PRU_SUART4_CONFIG_RX_SER;
+	} else if (soft_uart->suart_hdl[port->line].uart_num ==
+							PRU_SUART_UART6) {
+		pru_suart_config.tx_serializer = PRU_SUART5_CONFIG_TX_SER;
+		pru_suart_config.rx_serializer = PRU_SUART5_CONFIG_RX_SER;
+	} else if (soft_uart->suart_hdl[port->line].uart_num ==
+							PRU_SUART_UART7) {
+		pru_suart_config.tx_serializer = PRU_SUART6_CONFIG_TX_SER;
+		pru_suart_config.rx_serializer = PRU_SUART6_CONFIG_RX_SER;
+	} else if (soft_uart->suart_hdl[port->line].uart_num ==
+							PRU_SUART_UART8) {
+		pru_suart_config.tx_serializer = PRU_SUART7_CONFIG_TX_SER;
+		pru_suart_config.rx_serializer = PRU_SUART7_CONFIG_RX_SER;
+	} else {
+		return -ENOTSUPP;
+	}
+
+	/* Some defaults to startup. reconfigured by terimos later */
+	pru_suart_config.tx_clk_divisor = 1;
+	pru_suart_config.rx_clk_divisor = 1;
+	pru_suart_config.tx_bits_per_char = ePRU_SUART_DATA_BITS8;
+	pru_suart_config.rx_bits_per_char = ePRU_SUART_DATA_BITS8;
+	pru_suart_config.oversampling = SUART_DEFAULT_OVRSMPL;
+
+	if (PRU_SUART_SUCCESS !=
+		pru_softuart_setconfig(dev, &soft_uart->suart_hdl[port->line],
+			&pru_suart_config)) {
+		dev_err(&pdev->dev,
+			"pru_softuart_setconfig: failed to set config: %X\n",
+			err);
+	}
+exit:
+	return err;
+}
+
+/*
+ * Perform any autoconfiguration steps required for the port.  `flag`
+ * contains a bit mask of the required configuration.  UART_CONFIG_TYPE
+ * indicates that the port requires detection and identification.
+ * port->type should be set to the type found, or PORT_UNKNOWN if
+ * no port was detected.
+ *
+ * UART_CONFIG_IRQ indicates autoconfiguration of the interrupt signal,
+ * which should be probed using standard kernel autoprobing techniques.
+ * This is not necessary on platforms where ports have interrupts
+ * internally hard wired (eg, system on a chip implementations).
+ *
+ * Locking: none.
+ * Interrupts: caller dependent.
+ */
+
+static void pruss_suart_config_port(struct uart_port *port, s32 flags)
+{
+	if (flags & UART_CONFIG_TYPE && pruss_suart_request_port(port) == 0)
+		port->type = PORT_DA8XX_PRU_SUART;
+}
+
+/*
+ * Verify the new serial port information contained within serinfo is
+ * suitable for this port type.
+ *
+ * Locking: none.
+ * Interrupts: caller dependent.
+ */
+static s32 pruss_suart_verify_port(struct uart_port *port,
+				 struct serial_struct *ser)
+{
+	struct omapl_pru_suart *soft_uart =
+	    container_of(port, struct omapl_pru_suart, port[port->line]);
+	s32 ret = 0;
+
+	if (ser->type != PORT_UNKNOWN && ser->type != PORT_DA8XX_PRU_SUART)
+		ret = -EINVAL;
+	if (soft_uart->port[port->line].irq != ser->irq)
+		ret = -EINVAL;
+	if (ser->io_type != UPIO_MEM)
+		ret = -EINVAL;
+	if (soft_uart->port[port->line].uartclk / 16 != ser->baud_base)
+		ret = -EINVAL;
+	if ((void *)soft_uart->port[port->line].mapbase != ser->iomem_base)
+		ret = -EINVAL;
+	if (soft_uart->port[port->line].iobase != ser->port)
+		ret = -EINVAL;
+	return ret;
+}
+
+static struct uart_ops pruss_suart_ops = {
+	.tx_empty	= pruss_suart_tx_empty,
+	.set_mctrl	= pruss_suart_set_mctrl,
+	.get_mctrl	= pruss_suart_get_mctrl,
+	.stop_tx	= pruss_suart_stop_tx,
+	.start_tx	= pruss_suart_start_tx,
+	.stop_rx	= pruss_suart_stop_rx,
+	.enable_ms	= pruss_suart_enable_ms,
+	.break_ctl	= pruss_suart_break_ctl,
+	.startup	= pruss_suart_startup,
+	.shutdown	= pruss_suart_shutdown,
+	.set_termios	= pruss_suart_set_termios,
+	.type		= pruss_suart_type,
+	.release_port	= pruss_suart_release_port,
+	.request_port	= pruss_suart_request_port,
+	.config_port	= pruss_suart_config_port,
+	.verify_port	= pruss_suart_verify_port,
+};
+
+static struct uart_driver pruss_suart_reg = {
+	.owner		= THIS_MODULE,
+	.driver_name	= DRV_NAME,
+	.dev_name	= "ttySU",
+	.major		= 0,
+	.minor		= 16,
+	.nr		= NR_SUART,
+};
+
+static s32 __devinit pruss_suart_probe(struct platform_device *pdev)
+{
+	struct omapl_pru_suart *soft_uart;
+	const struct da850_evm_pruss_suart_data *pdata;
+	struct device *dev = &pdev->dev;
+	s32 err, i;
+	u8 *fw_data = NULL;
+
+	pdata = dev->platform_data;
+	if (!pdata) {
+		dev_err(&pdev->dev, "platform data not found\n");
+		return -EINVAL;
+	}
+
+	soft_uart = kzalloc(sizeof(struct omapl_pru_suart), GFP_KERNEL);
+	if (!soft_uart)
+		return -ENOMEM;
+
+	if (!request_mem_region(pdata->resource.start,
+			resource_size(&pdata->resource),
+			dev_name(&pdev->dev))) {
+		dev_err(&pdev->dev, "mcasp memory region already claimed!\n");
+		err = -EBUSY;
+		goto probe_exit;
+	}
+
+	soft_uart->suart_iomap.mcasp_io_addr =
+			ioremap(pdata->resource.start,
+			resource_size(&pdata->resource));
+	if (!soft_uart->suart_iomap.mcasp_io_addr) {
+		dev_err(&pdev->dev, "mcasp ioremap failed\n");
+		err = -EFAULT;
+		goto probe_exit_1;
+	}
+
+	soft_uart->suart_iomap.p_fifo_buff_virt_base =
+	sram_alloc(SUART_CNTX_SZ * NR_SUART * 2,
+	(dma_addr_t *) &soft_uart->suart_iomap.p_fifo_buff_phys_base);
+	if (!soft_uart->suart_iomap.p_fifo_buff_virt_base)
+		goto probe_exit_iounmap;
+
+	soft_uart->clk_freq_pru = pruss_get_clk_freq(dev);
+
+	soft_uart->clk_mcasp = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(soft_uart->clk_mcasp)) {
+		dev_err(&pdev->dev, "no clock available: mcasp\n");
+		err = -ENODEV;
+		soft_uart->clk_mcasp = NULL;
+		goto probe_exit_sram_free;
+	}
+
+	soft_uart->clk_freq_mcasp = clk_get_rate(soft_uart->clk_mcasp);
+	clk_enable(soft_uart->clk_mcasp);
+
+	err = request_firmware(&soft_uart->fw, "PRU_SUART_Emulation.bin",
+			       &pdev->dev);
+	if (err) {
+		dev_err(&pdev->dev, "can't load firmware\n");
+		err = -ENODEV;
+		goto probe_exit_clk;
+	}
+	dev_info(&pdev->dev, "fw size %td. downloading...\n",
+		soft_uart->fw->size);
+
+	/* download firmware into pru  & init */
+	fw_data = kmalloc(soft_uart->fw->size, GFP_KERNEL);
+	memcpy((void *)fw_data, (const void *)soft_uart->fw->data,
+		soft_uart->fw->size);
+
+	soft_uart->suart_iomap.pru_clk_freq =
+		(soft_uart->clk_freq_pru / 1000000);
+
+	err = pru_softuart_init(dev, SUART_DEFAULT_BAUD, SUART_DEFAULT_BAUD,
+			SUART_DEFAULT_OVRSMPL, fw_data,
+			soft_uart->fw->size, &soft_uart->suart_iomap);
+	if (err) {
+		dev_err(&pdev->dev, "pruss init error\n");
+		err = -ENODEV;
+		kfree((const void *)fw_data);
+		goto probe_release_fw;
+	}
+	kfree((const void *)fw_data);
+
+	platform_set_drvdata(pdev, &soft_uart->port[0]);
+	soft_uart->dev = dev;
+
+	for (i = 0; i < NR_SUART; i++) {
+		soft_uart->port[i].ops = &pruss_suart_ops;
+		soft_uart->port[i].iotype = UPIO_MEM;
+		soft_uart->port[i].flags = UPF_BOOT_AUTOCONF | UPF_IOREMAP;
+		soft_uart->port[i].mapbase =
+			(u32)soft_uart->suart_iomap.p_fifo_buff_virt_base;
+		soft_uart->port[i].membase =
+			(u8 *)&soft_uart->suart_iomap;
+		soft_uart->port[i].type = PORT_DA8XX_PRU_SUART;
+		soft_uart->port[i].irq =
+			platform_get_irq(to_platform_device(dev->parent), i);
+		soft_uart->port[i].dev = &pdev->dev;
+		soft_uart->port[i].irqflags = IRQF_SHARED;
+		soft_uart->port[i].uartclk = soft_uart->clk_freq_mcasp;
+		soft_uart->port[i].fifosize = SUART_FIFO_LEN;
+		soft_uart->tx_loadsz = SUART_FIFO_LEN;
+		soft_uart->port[i].custom_divisor = 1;
+		soft_uart->port[i].line = i;
+		soft_uart->suart_hdl[i].uart_num = i + 1;
+		spin_lock_init(&soft_uart->port[i].lock);
+		soft_uart->port[i].serial_in = NULL;
+
+		soft_uart->suart_fifo_addr[i].fifo_vaddr_buff_tx =
+		soft_uart->suart_iomap.p_fifo_buff_virt_base +
+		(2 * SUART_CNTX_SZ * i);
+
+		soft_uart->suart_fifo_addr[i].fifo_vaddr_buff_rx =
+		soft_uart->suart_iomap.p_fifo_buff_virt_base +
+		((2 * SUART_CNTX_SZ * i) + SUART_CNTX_SZ);
+
+		soft_uart->suart_fifo_addr[i].fifo_phys_addr_tx =
+		soft_uart->suart_iomap.p_fifo_buff_phys_base +
+		(2 * SUART_CNTX_SZ * i);
+
+		soft_uart->suart_fifo_addr[i].fifo_phys_addr_rx =
+		soft_uart->suart_iomap.p_fifo_buff_phys_base +
+		((2 * SUART_CNTX_SZ * i) + SUART_CNTX_SZ);
+
+		soft_uart->port[i].serial_out = NULL;
+		uart_add_one_port(&pruss_suart_reg, &soft_uart->port[i]);
+		sema_init(&soft_uart->port_sem[i], 1);
+	}
+
+	dev_info(&pdev->dev,
+		"%s device registered (pru_clk=%d, asp_clk=%d)\n",
+		DRV_NAME, soft_uart->clk_freq_pru, soft_uart->clk_freq_mcasp);
+
+	return 0;
+
+probe_release_fw:
+	release_firmware(soft_uart->fw);
+probe_exit_clk:
+	clk_put(soft_uart->clk_mcasp);
+	clk_disable(soft_uart->clk_mcasp);
+probe_exit_sram_free:
+	sram_free(soft_uart->suart_iomap.p_fifo_buff_virt_base,
+	SUART_CNTX_SZ * NR_SUART * 2);
+probe_exit_iounmap:
+	iounmap(soft_uart->suart_iomap.mcasp_io_addr);
+probe_exit_1:
+	release_mem_region(pdata->resource.start,
+		resource_size(&pdata->resource));
+probe_exit:
+	kfree(soft_uart);
+	return err;
+}
+
+static s32 __devexit pruss_suart_remove(struct platform_device *pdev)
+{
+	struct omapl_pru_suart *soft_uart = platform_get_drvdata(pdev);
+	const struct da850_evm_pruss_suart_data *pdata;
+	struct device *dev = &pdev->dev;
+	int i;
+
+	pdata = dev->platform_data;
+	if (!pdata)
+		dev_err(&pdev->dev, "platform data not found\n");
+
+	platform_set_drvdata(pdev, NULL);
+
+	if (soft_uart) {
+		for (i = 0; i < NR_SUART; i++) {
+			uart_remove_one_port(&pruss_suart_reg,
+			&soft_uart->port[i]);
+		}
+	}
+
+	sram_free(soft_uart->suart_iomap.p_fifo_buff_virt_base,
+		SUART_CNTX_SZ * NR_SUART * 2);
+	release_firmware(soft_uart->fw);
+	clk_put(soft_uart->clk_mcasp);
+	clk_disable(soft_uart->clk_mcasp);
+	iounmap(soft_uart->suart_iomap.mcasp_io_addr);
+	if (pdata) {
+		release_mem_region(pdata->resource.start,
+			resource_size(&pdata->resource));
+	}
+	kfree(soft_uart);
+	return 0;
+}
+
+#define pruss_suart_suspend NULL
+#define pruss_suart_resume NULL
+
+static struct platform_driver serial_pruss_driver = {
+	.probe		= pruss_suart_probe,
+	.remove		= __devexit_p(pruss_suart_remove),
+	.suspend	= pruss_suart_suspend,
+	.resume		= pruss_suart_resume,
+	.driver		= {
+			.name	= DRV_NAME,
+			.owner	= THIS_MODULE,
+	},
+};
+
+static s32 __init pruss_suart_init(void)
+{
+	s32 ret;
+
+	pruss_suart_reg.nr = NR_SUART;
+	ret = uart_register_driver(&pruss_suart_reg);
+	if (ret)
+		return ret;
+	ret = platform_driver_register(&serial_pruss_driver);
+	if (ret)
+		goto out;
+
+	__suart_debug("SUART serial driver loaded\n");
+	return ret;
+out:
+	uart_unregister_driver(&pruss_suart_reg);
+	return ret;
+}
+
+module_init(pruss_suart_init);
+
+static void __exit pruss_suart_exit(void)
+{
+	platform_driver_unregister(&serial_pruss_driver);
+	uart_unregister_driver(&pruss_suart_reg);
+	__suart_debug("SUART serial driver unloaded\n");
+}
+
+module_exit(pruss_suart_exit);
+
+/* Module information */
+MODULE_AUTHOR("Subhasish Ghosh <subhasish@mistralsolutions.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION(DRV_DESC);
diff --git a/drivers/tty/serial/da8xx_pruss/pruss_suart_api.c b/drivers/tty/serial/da8xx_pruss/pruss_suart_api.c
new file mode 100644
index 0000000..d809dd3
--- /dev/null
+++ b/drivers/tty/serial/da8xx_pruss/pruss_suart_api.c
@@ -0,0 +1,2350 @@
+/*
+ * Copyright (C) 2010 Texas Instruments Incorporated
+ * Author: Jitendra Kumar <jitendra@mistralsolutions.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as  published by the
+ * Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/types.h>
+#include <linux/mfd/pruss/da8xx_pru.h>
+#include <linux/io.h>
+#include <mach/hardware.h>
+#include "pruss_suart_api.h"
+#include "pruss_suart_regs.h"
+#include "pruss_suart_board.h"
+#include "pruss_suart_utils.h"
+#include "pruss_suart_err.h"
+
+static u8 g_uart_statu_table[8];
+static pruss_suart_iomap suart_iomap;
+
+static u32 uart_rx[8] = {PRU_SUART0_CONFIG_RX_SER, PRU_SUART1_CONFIG_RX_SER,
+			PRU_SUART2_CONFIG_RX_SER, PRU_SUART3_CONFIG_RX_SER,
+			PRU_SUART4_CONFIG_RX_SER, PRU_SUART5_CONFIG_RX_SER,
+			PRU_SUART6_CONFIG_RX_SER, PRU_SUART7_CONFIG_RX_SER};
+
+static u32 uart_tx[8] = {PRU_SUART0_CONFIG_TX_SER, PRU_SUART1_CONFIG_TX_SER,
+			PRU_SUART2_CONFIG_TX_SER, PRU_SUART3_CONFIG_TX_SER,
+			PRU_SUART4_CONFIG_TX_SER, PRU_SUART5_CONFIG_TX_SER,
+			PRU_SUART6_CONFIG_TX_SER, PRU_SUART7_CONFIG_TX_SER};
+
+static u32 uart_config[8] = {PRU_SUART0_CONFIG_DUPLEX, PRU_SUART1_CONFIG_DUPLEX,
+			PRU_SUART2_CONFIG_DUPLEX, PRU_SUART3_CONFIG_DUPLEX,
+			PRU_SUART4_CONFIG_DUPLEX, PRU_SUART5_CONFIG_DUPLEX,
+			PRU_SUART6_CONFIG_DUPLEX, PRU_SUART7_CONFIG_DUPLEX};
+
+#if (PRU_ACTIVE == BOTH_PRU)
+#if 1
+void pru_set_ram_data(struct device *dev, pruss_suart_iomap *pruss_ioaddr)
+{
+	u16 u16datatowrite;
+	u32 u32datatowrite;
+	u32 i;
+	pru_suart_regs_ovly pru_suart_regs = PRU0_DATARAM_OFFSET;
+	u32 *pu32_sr_ctl_addr = (u32 *)(pruss_ioaddr->mcasp_io_addr + 0x180);
+	pru_suart_tx_cntx_priv *pru_suart_tx_priv = NULL;
+	pru_suart_rx_cntx_priv *pru_suart_rx_priv = NULL;
+
+	/* RX PRU - 0 Chanel 0-7 context information */
+	for (i = 0; i < 8; i++, pru_suart_regs++) {
+		pruss_readw(dev, (u32) &pru_suart_regs->ch_ctrl, &u16datatowrite, 1);
+		u16datatowrite |= (SUART_CHN_RX << 0);
+		pruss_writew(dev, (u32) &pru_suart_regs->ch_ctrl,
+						&u16datatowrite, 1);
+
+		pruss_readw(dev, (u32) &pru_suart_regs->ch_ctrl, &u16datatowrite, 1);
+		u16datatowrite |= ((0xF & uart_rx[i]) << 8);
+		pruss_writew(dev, (u32) &pru_suart_regs->ch_ctrl,
+						&u16datatowrite, 1);
+
+		pruss_readw(dev, (u32) &pru_suart_regs->ch_config1,
+						&u16datatowrite, 1);
+		u16datatowrite |= (SUART_DEFAULT_OVRSMPL << 10);
+		pruss_writew(dev, (u32) &pru_suart_regs->ch_config1,
+						&u16datatowrite, 1);
+
+		pruss_readw(dev, (u32) &pru_suart_regs->ch_config2,
+						&u16datatowrite, 1);
+		u16datatowrite |= 8;
+		pruss_writew(dev, (u32) &pru_suart_regs->ch_config2,
+						&u16datatowrite, 1);
+
+		if ((uart_config[i] & PRU_SUART_HALF_RX_DISABLED) ==
+					PRU_SUART_HALF_RX_DISABLED) {
+			pruss_readw(dev, (u32) &pru_suart_regs->ch_txrx_status,
+						&u16datatowrite, 1);
+			u16datatowrite |= (SUART_CHN_DISABLED << 15) ;
+			pruss_writew(dev, (u32) &pru_suart_regs->ch_txrx_status,
+						&u16datatowrite, 1);
+		} else {
+			pruss_readw(dev, (u32) &pru_suart_regs->ch_txrx_status,
+						&u16datatowrite, 1);
+			u16datatowrite |= (SUART_CHN_ENABLED << 15);
+			pruss_writew(dev, (u32) &pru_suart_regs->ch_txrx_status,
+							&u16datatowrite, 1);
+		__raw_writel(MCASP_SRCTL_RX_MODE, pu32_sr_ctl_addr +
+								uart_rx[i]);
+		}
+		/*
+		* RX is active by default, write the dummy received data at
+		* PRU RAM addr 0x1FC to avoid memory corruption.
+		*/
+		pruss_readl(dev, (u32) &pru_suart_regs->ch_txrx_data,
+							&u32datatowrite, 1);
+		u32datatowrite |= RX_DEFAULT_DATA_DUMP_ADDR;
+		pruss_writel(dev, (u32) &pru_suart_regs->ch_txrx_data,
+							&u32datatowrite, 1);
+		pruss_readl(dev, (u32) &pru_suart_regs->reserved1, &u32datatowrite, 1);
+		u32datatowrite = 0;
+		pruss_writel(dev, (u32) &pru_suart_regs->reserved1,
+							&u32datatowrite, 1);
+		/* SUART1 RX context base addr */
+		pru_suart_rx_priv = (pru_suart_rx_cntx_priv *)
+				(PRU0_DATARAM_OFFSET + (0x090 + (i * 0x020)));
+		u32datatowrite = (MCASP_RBUF_BASE_ADDR + (uart_rx[i] << 2));
+		pruss_writel(dev, (u32) &pru_suart_rx_priv->asp_rbuf_base,
+				&u32datatowrite, 1);
+		u32datatowrite = (MCASP_SRCTL_BASE_ADDR + (uart_rx[i] << 2));
+		pruss_writel(dev, (u32) &pru_suart_rx_priv->asp_rsrctl_base,
+				&u32datatowrite, 1);
+	}
+
+	/* ****************** PRU1 RAM BASE ADDR ************************ */
+	pru_suart_regs = (pru_suart_regs_ovly) PRU1_DATARAM_OFFSET;
+
+	/* ******************* TX PRU - 1  *********************** */
+	/* Channel 0-7 context information */
+	for (i = 0; i < 8; i++, pru_suart_regs++) {
+		pruss_readw(dev, (u32) &pru_suart_regs->ch_ctrl, &u16datatowrite, 1);
+		u16datatowrite |= (SUART_CHN_TX << 0);
+		pruss_writew(dev, (u32) &pru_suart_regs->ch_ctrl,
+						&u16datatowrite, 1);
+		pruss_readw(dev, (u32) &pru_suart_regs->ch_ctrl, &u16datatowrite, 1);
+		u16datatowrite |= (0xF & uart_tx[i] << 8);
+		pruss_writew(dev, (u32) &pru_suart_regs->ch_ctrl,
+							&u16datatowrite, 1);
+		pruss_readw(dev, (u32) &pru_suart_regs->ch_config1,
+						&u16datatowrite, 1);
+		u16datatowrite |= (SUART_DEFAULT_OVRSMPL << 10);
+		pruss_writew(dev, (u32) &pru_suart_regs->ch_config1,
+						&u16datatowrite, 1);
+		pruss_readw(dev, (u32) &pru_suart_regs->ch_config2,
+						&u16datatowrite, 1);
+		u16datatowrite |= 8;
+		pruss_writew(dev, (u32) &pru_suart_regs->ch_config2,
+						&u16datatowrite, 1);
+		if ((uart_config[i] & PRU_SUART_HALF_TX_DISABLED) ==
+						PRU_SUART_HALF_TX_DISABLED) {
+			pruss_readw(dev, (u32) &pru_suart_regs->ch_txrx_status,
+						&u16datatowrite, 1);
+			u16datatowrite |= (SUART_CHN_DISABLED << 15);
+			pruss_writew(dev, (u32) &pru_suart_regs->ch_txrx_status,
+						&u16datatowrite, 1);
+		} else {
+			pruss_readw(dev, (u32) &pru_suart_regs->ch_txrx_status,
+						&u16datatowrite, 1);
+			u16datatowrite |= (SUART_CHN_ENABLED << 15);
+			pruss_writew(dev, (u32) &pru_suart_regs->ch_txrx_status,
+							&u16datatowrite, 1);
+		__raw_writel(MCASP_SRCTL_TX_MODE,
+				pu32_sr_ctl_addr + uart_tx[i]);
+		}
+		pruss_readl(dev, (u32) &pru_suart_regs->reserved1, &u32datatowrite, 1);
+		u32datatowrite |= 1;
+		pruss_writel(dev, (u32) &pru_suart_regs->reserved1,
+							 &u32datatowrite, 1);
+	/* SUART1 TX context base addr */
+		 pru_suart_tx_priv = (pru_suart_tx_cntx_priv *)
+			(PRU1_DATARAM_OFFSET + (0x0B0 + (i * 0x02C)));
+		u32datatowrite = (MCASP_SRCTL_BASE_ADDR + (uart_tx[i] << 2));
+		pruss_writel(dev, (u32) &pru_suart_tx_priv->asp_xsrctl_base,
+				&u32datatowrite, 1);
+		u32datatowrite = (MCASP_XBUF_BASE_ADDR + (uart_tx[i] << 2));
+		pruss_writel(dev, (u32) &pru_suart_tx_priv->asp_xbuf_base,
+				&u32datatowrite, 1);
+	/* SUART1 TX formatted data base addr */
+		u32datatowrite = (0x0090 + (i * 0x002C));
+		pruss_writel(dev, (u32) &pru_suart_tx_priv->buff_addr,
+					&u32datatowrite, 1);
+	}
+}
+#endif
+#else
+void pru_set_ram_data(struct device *dev, pruss_suart_iomap *pruss_ioaddr)
+{
+
+	pru_suart_regs_ovly pru_suart_regs = (pru_suart_regs_ovly)
+						pruss_ioaddr->pru_io_addr;
+	u32 i;
+	u32 *pu32_sr_ctl_addr = (u32 *)(pruss_ioaddr->mcasp_io_addr + 0x180);
+	pru_suart_tx_cntx_priv *pru_suart_tx_priv = NULL;
+	pru_suart_rx_cntx_priv *pru_suart_rx_priv = NULL;
+
+	/* ***************** UART 0  ************************ */
+	/* Channel 0 context information is Tx */
+	for (i = 0; i < 4; i++, pru_suart_regs++) {
+		pruss_readw(dev, (u32) &pru_suart_regs->ch_ctrl, &u16datatowrite, 1);
+		u16datatowrite |= (SUART_CHN_TX << 8);
+		pruss_writew(dev, (u32) &pru_suart_regs->ch_ctrl,
+							&u16datatowrite, 1);
+		pruss_readw(dev, (u32) &pru_suart_regs->ch_ctrl, &u16datatowrite, 1);
+		u16datatowrite |= (0xF & uart_tx[i]);
+		pruss_writew(dev, (u32) &pru_suart_regs->ch_ctrl,
+							&u16datatowrite, 1);
+		pruss_readw(dev, (u32) &pru_suart_regs->ch_config1,
+							&u16datatowrite, 1);
+		u16datatowrite |= (SUART_DEFAULT_OVRSMPL << 10);
+		pruss_writew(dev, (u32) &pru_suart_regs->ch_config1,
+							&u16datatowrite, 1);
+		pruss_readw(dev, (u32) &pru_suart_regs->ch_config2,
+							&u16datatowrite, 1);
+		u16datatowrite |= 8;
+		pruss_writew(dev, (u32) &pru_suart_regs->ch_config2,
+							&u16datatowrite, 1);
+		if ((uart_config[i] & PRU_SUART_HALF_TX_DISABLED) ==
+						PRU_SUART_HALF_TX_DISABLED){
+			pruss_readw(dev, (u32) &pru_suart_regs->ch_txrx_status,
+							&u16datatowrite, 1);
+			u16datatowrite |= (SUART_CHN_DISABLED << 15);
+			pruss_writew(dev, (u32) &pru_suart_regs->ch_txrx_status,
+							&u16datatowrite, 1);
+		} else {
+			pruss_readw(dev, (u32) &pru_suart_regs->ch_txrx_status,
+							&u16datatowrite, 1);
+			u16datatowrite |= (SUART_CHN_ENABLED << 15);
+			pruss_writew(dev, (u32) &pru_suart_regs->ch_txrx_status,
+							&u16datatowrite, 1);
+			__raw_writel(MCASP_SRCTL_TX_MODE,
+						pu32_sr_ctl_addr + uart_tx[i]);
+		}
+		pruss_readl(dev, (u32) &pru_suart_regs->reserved1, &u32datatowrite, 1);
+		u32datatowrite |= 1;
+		pruss_writel(dev, (u32) &pru_suart_regs->reserved1,
+							&u32datatowrite, 1);
+	/* SUART1 TX context base addr */
+		 pru_suart_tx_priv = (pru_suart_tx_cntx_priv *)
+				(PRU0_DATARAM_OFFSET + (0x0B0 + (i * 0x50)));
+		pruss_writel(dev, (u32) &pru_suart_tx_priv->asp_xsrctl_base,
+				(MCASP_SRCTL_BASE_ADDR + (uart_tx[i] << 2)), 1);
+		pruss_writel(dev, (u32) &pru_suart_tx_priv->asp_xbuf_base,
+				(MCASP_XBUF_BASE_ADDR + (uart_tx[i] << 2)), 1);
+	/* SUART1 TX formatted data base addr */
+		pruss_writel(dev, (u32) &pru_suart_tx_priv->buff_addr,
+					(0x0090 + (i * 0x050)), 1);
+
+	/* Channel 1 is Rx context information */
+		pru_suart_regs++;
+		pruss_readw(dev, (u32) &pru_suart_regs->ch_ctrl, &u16datatowrite, 1);
+		u16datatowrite |= (SUART_CHN_RX << 8);
+		pruss_writew(dev, (u32) &pru_suart_regs->ch_ctrl,
+						&u16datatowrite, 1);
+		pruss_readw(dev, (u32) &pru_suart_regs->ch_ctrl, &u16datatowrite, 1);
+		u16datatowrite |= (0xF & uart_rx[i]);
+		pruss_writew(dev, (u32) &pru_suart_regs->ch_ctrl,
+							&u16datatowrite, 1);
+		pruss_readw(dev, (u32) &pru_suart_regs->ch_config1,
+							&u16datatowrite, 1);
+		u16datatowrite |= (SUART_DEFAULT_OVRSMPL << 10);
+		pruss_writew(dev, (u32) &pru_suart_regs->ch_config1,
+							&u16datatowrite, 1);
+		pruss_readw(dev, (u32) &pru_suart_regs->ch_config2,
+							&u16datatowrite, 1);
+		u16datatowrite |= 8;
+		pruss_writew(dev, (u32) &pru_suart_regs->ch_config2,
+							&u16datatowrite, 1);
+		if ((uart_config[i] & PRU_SUART_HALF_RX_DISABLED) ==
+						PRU_SUART_HALF_RX_DISABLED) {
+			pruss_readw(dev, (u32) &pru_suart_regs->ch_txrx_status,
+							&u16datatowrite, 1);
+			u16datatowrite |= (SUART_CHN_DISABLED << 15);
+			pruss_writew(dev, (u32) &pru_suart_regs->ch_txrx_status,
+							&u16datatowrite, 1);
+		} else {
+		pruss_readw(dev, (u32) &pru_suart_regs->ch_txrx_status,
+							&u16datatowrite, 1);
+		u16datatowrite |= (SUART_CHN_ENABLED << 15);
+		pruss_writew(dev, (u32) &pru_suart_regs->ch_txrx_status,
+							&u16datatowrite, 1);
+		__raw_writel(MCASP_SRCTL_RX_MODE,
+					pu32_sr_ctl_addr + uart_rx[i]);
+		}
+	/* RX is active by default, write the dummy received data
+	 * at PRU RAM addr 0x1FC to avoid memory corruption
+	 */
+		pruss_readl(dev, (u32) &pru_surt_regs->ch_txrx_data,
+						&u32datatowrite, 1);
+		u32datatowrite |= RX_DEFAULT_DATA_DUMP_ADDR;
+		pruss_writel(dev, (u32) &pru_suart_regs->ch_txrx_data,
+							&u32datatowrite, 1);
+		pruss_readl(dev, (u32) &pru_suart_regs->reserved1, &u32datatowrite, 1);
+		u32datatowrite = 0;
+	pruss_writel(dev, (u32) &pru_suart_regs->reserved1, &u32datatowrite, 1);
+	/* SUART1 RX context base addr */
+		pru_suart_rx_priv = (pru_suart_rx_cntx_priv *)
+			(PRU0_DATARAM_OFFSET + (0x0C0 + (i * 0x50)));
+		pruss_writel(dev, (u32) &pru_suart_rx_priv->asp_rbuf_base,
+				(MCASP_RBUF_BASE_ADDR + (uart_rx[i] << 2)), 1);
+		pruss_writel(dev, (u32) &pru_suart_rx_priv->asp_rsrctl_base,
+				(MCASP_SRCTL_BASE_ADDR + (uart_rx[i] << 2)), 1);
+	}
+}
+#endif
+
+static void pru_set_rx_tx_mode(struct device *dev, u32 pru_mode, u32 pru_num)
+{
+
+	u32 pru_offset;
+
+	if (pru_num == PRUSS_NUM0)
+		pru_offset = PRU_SUART_PRU0_RX_TX_MODE;
+	else if (pru_num == PRUSS_NUM1)
+		pru_offset = PRU_SUART_PRU1_RX_TX_MODE;
+	else
+		return;
+	pruss_writeb(dev, pru_offset, (u8 *) &pru_mode, 1);
+}
+
+static void pru_set_delay_count(struct device *dev, u32 pru_freq)
+{
+	u32 u32delay_cnt;
+
+	if (pru_freq == 228)
+		u32delay_cnt = 5;
+	else if (pru_freq == 186)
+		u32delay_cnt = 5;
+	else
+		u32delay_cnt = 3;
+
+	/* PRU 0 */
+	pruss_writeb(dev, PRU_SUART_PRU0_DELAY_OFFSET,
+		(u8 *) &u32delay_cnt, 1);
+
+	/* PRU 1 */
+	pruss_writeb(dev, PRU_SUART_PRU1_DELAY_OFFSET,
+		(u8 *) &u32delay_cnt, 1);
+}
+
+static s32 suart_set_pru_id(struct device *dev, u32 pru_no)
+{
+	u32 offset;
+	u8 reg_val = 0;
+
+	if (0 == pru_no)
+		offset = PRU_SUART_PRU0_ID_ADDR;
+	else if (1 == pru_no)
+		offset = PRU_SUART_PRU1_ID_ADDR;
+	else
+		return PRU_SUART_FAILURE;
+
+	reg_val = pru_no;
+	pruss_writeb(dev, offset, (u8 *) &reg_val, 1);
+
+	return PRU_SUART_SUCCESS;
+}
+
+/*
+ * suart Initialization routine
+ */
+s16 pru_softuart_init(struct device *dev, u32 tx_baud_value,
+			u32 rx_baud_value, u32 oversampling,
+			u8 *pru_suart_emu_code, u32 fw_size,
+			pruss_suart_iomap *pruss_ioaddr)
+{
+	u32 u32datatowrite[128] = {0};
+	s16 status = PRU_SUART_SUCCESS;
+	s16 idx;
+	s16 retval;
+
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH) &&
+				(PRU1_MODE == PRU_MODE_RX_TX_BOTH))
+		return PRU_SUART_FAILURE;
+
+	suart_iomap.mcasp_io_addr = pruss_ioaddr->mcasp_io_addr;
+	suart_iomap.p_fifo_buff_phys_base =
+					pruss_ioaddr->p_fifo_buff_phys_base;
+	suart_iomap.p_fifo_buff_virt_base =
+					pruss_ioaddr->p_fifo_buff_virt_base;
+	suart_iomap.pru_clk_freq = pruss_ioaddr->pru_clk_freq;
+	/* Configure McASP0  */
+	suart_mcasp_config(tx_baud_value,
+			rx_baud_value, oversampling, pruss_ioaddr);
+	pruss_enable(dev, PRUSS_NUM0);
+	pruss_enable(dev, PRUSS_NUM1);
+
+	/* Reset PRU RAM */
+	pruss_writel(dev, PRU0_DATARAM_OFFSET, u32datatowrite,
+				 (PRU0_DATARAM_SIZE / sizeof(int)));
+	pruss_writel(dev, PRU1_DATARAM_OFFSET, u32datatowrite,
+				 (PRU1_DATARAM_SIZE / sizeof(int)));
+	pruss_load(dev, PRUSS_NUM0, (u32 *)pru_suart_emu_code,
+				(fw_size / sizeof(u32)));
+	pruss_load(dev, PRUSS_NUM1, (u32 *)pru_suart_emu_code,
+				(fw_size / sizeof(u32)));
+	retval = arm_to_pru_intr_init(dev);
+	if (-1 == retval)
+		return status;
+	pru_set_delay_count(dev, pruss_ioaddr->pru_clk_freq);
+	suart_set_pru_id(dev, PRUSS_NUM0);
+	suart_set_pru_id(dev, PRUSS_NUM1);
+	pru_set_rx_tx_mode(dev, PRU0_MODE, PRUSS_NUM0);
+	pru_set_rx_tx_mode(dev, PRU1_MODE, PRUSS_NUM1);
+	pru_set_ram_data(dev, pruss_ioaddr);
+	pruss_run(dev, PRUSS_NUM0);
+	pruss_run(dev, PRUSS_NUM1);
+
+	/* Initialize g_uart_statu_table */
+	for (idx = 0; idx < 8; idx++)
+		g_uart_statu_table[idx] = ePRU_SUART_UART_FREE;
+
+	return status;
+}
+
+void pru_set_fifo_timeout(struct device *dev, s16 timeout)
+{
+	pruss_writew(dev, PRU_SUART_PRU0_IDLE_TIMEOUT_OFFSET,
+		&timeout, 1);
+	pruss_writew(dev, PRU_SUART_PRU1_IDLE_TIMEOUT_OFFSET,
+		&timeout, 1);
+}
+
+s16 pru_softuart_deinit(struct device *dev)
+{
+	u32 offset;
+	s16 s16retval = 0;
+	u32 u32value = 0;
+
+	offset = (u32) (PRUSS_INTC_STATCLRINT1 & 0xFFFF);
+	u32value = 0xFFFFFFFF;
+	s16retval = pruss_writel(dev, offset, (u32 *)&u32value, 1);
+	if (-1 == s16retval)
+		return -1;
+	offset = (u32) (PRUSS_INTC_STATCLRINT0 & 0xFFFF);
+	u32value = 0xFFFFFFFF;
+	s16retval = pruss_writel(dev, offset, (u32 *)&u32value, 1);
+	if (-1 == s16retval)
+		return -1;
+	pruss_disable(dev, 0);
+	pruss_disable(dev, 1);
+
+	return PRU_SUART_SUCCESS;
+}
+
+/* suart Instance open routine  */
+s16 pru_softuart_open(suart_handle h_suart)
+{
+	s16 status = PRU_SUART_SUCCESS;
+
+	switch (h_suart->uart_num) {
+	case PRU_SUART_UART1:
+		if (g_uart_statu_table[PRU_SUART_UART1 - 1] ==
+				ePRU_SUART_UART_IN_USE) {
+			status = SUART_UART_IN_USE;
+			return status;
+		} else {
+			h_suart->uart_status = ePRU_SUART_UART_IN_USE;
+			h_suart->uart_type = PRU_SUART0_CONFIG_DUPLEX;
+			h_suart->uart_tx_channel = PRU_SUART0_CONFIG_TX_SER;
+			h_suart->uart_rx_channel = PRU_SUART0_CONFIG_RX_SER;
+			g_uart_statu_table[PRU_SUART_UART1 - 1] =
+			    ePRU_SUART_UART_IN_USE;
+		}
+		break;
+
+	case PRU_SUART_UART2:
+		if (g_uart_statu_table[PRU_SUART_UART2 - 1] ==
+				ePRU_SUART_UART_IN_USE) {
+			status = SUART_UART_IN_USE;
+			return status;
+		} else {
+
+			h_suart->uart_status = ePRU_SUART_UART_IN_USE;
+			h_suart->uart_type = PRU_SUART1_CONFIG_DUPLEX;
+			h_suart->uart_tx_channel = PRU_SUART1_CONFIG_TX_SER;
+			h_suart->uart_rx_channel = PRU_SUART1_CONFIG_RX_SER;
+			g_uart_statu_table[PRU_SUART_UART2 - 1] =
+			    ePRU_SUART_UART_IN_USE;
+		}
+		break;
+
+	case PRU_SUART_UART3:
+		if (g_uart_statu_table[PRU_SUART_UART3 - 1] ==
+				ePRU_SUART_UART_IN_USE) {
+			status = SUART_UART_IN_USE;
+			return status;
+		} else {
+
+			h_suart->uart_status = ePRU_SUART_UART_IN_USE;
+			h_suart->uart_type = PRU_SUART2_CONFIG_DUPLEX;
+			h_suart->uart_tx_channel = PRU_SUART2_CONFIG_TX_SER;
+			h_suart->uart_rx_channel = PRU_SUART2_CONFIG_RX_SER;
+			g_uart_statu_table[PRU_SUART_UART3 - 1] =
+			    ePRU_SUART_UART_IN_USE;
+		}
+		break;
+
+	case PRU_SUART_UART4:
+		if (g_uart_statu_table[PRU_SUART_UART4 - 1] ==
+				ePRU_SUART_UART_IN_USE) {
+			status = SUART_UART_IN_USE;
+			return status;
+		} else {
+
+			h_suart->uart_status = ePRU_SUART_UART_IN_USE;
+			h_suart->uart_type = PRU_SUART3_CONFIG_DUPLEX;
+			h_suart->uart_tx_channel = PRU_SUART3_CONFIG_TX_SER;
+			h_suart->uart_rx_channel = PRU_SUART3_CONFIG_RX_SER;
+
+			g_uart_statu_table[PRU_SUART_UART4 - 1] =
+			    ePRU_SUART_UART_IN_USE;
+		}
+		break;
+
+	case PRU_SUART_UART5:
+		if (g_uart_statu_table[PRU_SUART_UART5 - 1] ==
+				ePRU_SUART_UART_IN_USE) {
+			status = SUART_UART_IN_USE;
+			return status;
+		} else {
+			h_suart->uart_status = ePRU_SUART_UART_IN_USE;
+			h_suart->uart_type = PRU_SUART4_CONFIG_DUPLEX;
+			h_suart->uart_tx_channel = PRU_SUART4_CONFIG_TX_SER;
+			h_suart->uart_rx_channel = PRU_SUART4_CONFIG_RX_SER;
+
+			g_uart_statu_table[PRU_SUART_UART5 - 1] =
+			    ePRU_SUART_UART_IN_USE;
+		}
+		break;
+
+	case PRU_SUART_UART6:
+		if (g_uart_statu_table[PRU_SUART_UART6 - 1] ==
+				ePRU_SUART_UART_IN_USE) {
+			status = SUART_UART_IN_USE;
+			return status;
+		} else {
+			h_suart->uart_status = ePRU_SUART_UART_IN_USE;
+			h_suart->uart_type = PRU_SUART5_CONFIG_DUPLEX;
+			h_suart->uart_tx_channel = PRU_SUART5_CONFIG_TX_SER;
+			h_suart->uart_rx_channel = PRU_SUART5_CONFIG_RX_SER;
+			g_uart_statu_table[PRU_SUART_UART6 - 1] =
+			    ePRU_SUART_UART_IN_USE;
+		}
+		break;
+
+	case PRU_SUART_UART7:
+		if (g_uart_statu_table[PRU_SUART_UART7 - 1] ==
+				ePRU_SUART_UART_IN_USE) {
+			status = SUART_UART_IN_USE;
+			return status;
+		} else {
+			h_suart->uart_status = ePRU_SUART_UART_IN_USE;
+			h_suart->uart_type = PRU_SUART6_CONFIG_DUPLEX;
+			h_suart->uart_tx_channel = PRU_SUART6_CONFIG_TX_SER;
+			h_suart->uart_rx_channel = PRU_SUART6_CONFIG_RX_SER;
+			g_uart_statu_table[PRU_SUART_UART7 - 1] =
+			    ePRU_SUART_UART_IN_USE;
+		}
+		break;
+
+	case PRU_SUART_UART8:
+		if (g_uart_statu_table[PRU_SUART_UART8 - 1] ==
+				ePRU_SUART_UART_IN_USE) {
+			status = SUART_UART_IN_USE;
+			return status;
+		} else {
+			h_suart->uart_status = ePRU_SUART_UART_IN_USE;
+			h_suart->uart_type = PRU_SUART7_CONFIG_DUPLEX;
+			h_suart->uart_tx_channel = PRU_SUART7_CONFIG_TX_SER;
+			h_suart->uart_rx_channel = PRU_SUART7_CONFIG_RX_SER;
+			g_uart_statu_table[PRU_SUART_UART8 - 1] =
+			    ePRU_SUART_UART_IN_USE;
+		}
+		break;
+
+	default:
+		status = SUART_INVALID_UART_NUM;
+		break;
+	}
+	return status;
+}
+
+/* suart instance close routine */
+s16 pru_softuart_close(suart_handle h_uart)
+{
+	s16 status = SUART_SUCCESS;
+
+	if (h_uart == NULL) {
+		return PRU_SUART_ERR_HANDLE_INVALID;
+	} else {
+		g_uart_statu_table[h_uart->uart_num - 1] =
+			ePRU_SUART_UART_FREE;
+		/* Reset the Instance to Invalid */
+		h_uart->uart_num = PRU_SUART_UARTx_INVALID;
+		h_uart->uart_status = ePRU_SUART_UART_FREE;
+	}
+	return status;
+}
+
+/*
+ * suart routine for setting relative baud rate
+ */
+s16 pru_softuart_setbaud(struct device *dev, suart_handle h_uart,
+		u16 tx_clk_divisor, u16 rx_clk_divisor)
+{
+	u32 offset;
+	u32 pru_offset;
+	s16 status = SUART_SUCCESS;
+	u16 ch_num;
+	u16 regval = 0;
+
+	if (h_uart == NULL)
+		return PRU_SUART_ERR_HANDLE_INVALID;
+
+	/* Set the clock divisor value s32o the McASP */
+	if ((tx_clk_divisor > 385) || (tx_clk_divisor == 0))
+		return SUART_INVALID_CLKDIVISOR;
+	if ((rx_clk_divisor > 385) || (rx_clk_divisor == 0))
+		return SUART_INVALID_CLKDIVISOR;
+	ch_num = h_uart->uart_num - 1;
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH)
+		|| (PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		/* channel starts from 0 and uart instance starts from 1 */
+		ch_num = (h_uart->uart_num *
+			SUART_NUM_OF_CHANNELS_PER_SUART) - 2;
+		if (h_uart->uart_num <= 4) {
+			pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+		} else {
+			pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+			ch_num -= 8;
+		}
+	} else if (PRU0_MODE == PRU_MODE_TX_ONLY) {
+		pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+	} else if (PRU1_MODE == PRU_MODE_TX_ONLY) {
+		pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+
+	if (tx_clk_divisor != 0) {
+		offset = pru_offset +
+			(ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+			PRU_SUART_CH_CONFIG1_OFFSET;
+		pruss_readb(dev, offset, (u8 *) &regval, 2);
+		regval &= (~0x3FF);
+		regval |= tx_clk_divisor;
+		pruss_writeb(dev, offset, (u8 *) &regval, 2);
+	}
+	if (PRU0_MODE == PRU_MODE_RX_ONLY) {
+		pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+	} else if (PRU1_MODE == PRU_MODE_RX_ONLY) {
+		pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+	} else if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH) ||
+			(PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		ch_num++;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+	regval = 0;
+	if (rx_clk_divisor != 0) {
+		offset = pru_offset +
+			(ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+			PRU_SUART_CH_CONFIG1_OFFSET;
+		pruss_readb(dev, offset, (u8 *) &regval, 2);
+		regval &= (~0x3FF);
+		regval |= tx_clk_divisor;
+		pruss_writeb(dev, offset, (u8 *) &regval, 2);
+	}
+	return status;
+}
+
+/*
+ * suart routine for setting number of bits per character for a specific uart
+ */
+s16 pru_softuart_setdatabits(struct device *dev, suart_handle h_uart,
+		u16 tx_data_bits, u16 rx_data_bits)
+{
+	u32 offset;
+	u32 pru_offset;
+	s16 status = SUART_SUCCESS;
+	u16 ch_num;
+	u32 reg_val;
+
+	if (h_uart == NULL)
+		return PRU_SUART_ERR_HANDLE_INVALID;
+
+	/*
+	 * NOTE:
+	 * The supported data bits are 6,7,8,9,10,11,12 bits per character
+	 */
+
+	if ((tx_data_bits < ePRU_SUART_DATA_BITS6)
+			|| (tx_data_bits > ePRU_SUART_DATA_BITS12))
+		return PRU_SUART_ERR_PARAMETER_INVALID;
+
+	if ((rx_data_bits < ePRU_SUART_DATA_BITS6)
+			|| (rx_data_bits > ePRU_SUART_DATA_BITS12))
+		return PRU_SUART_ERR_PARAMETER_INVALID;
+
+	ch_num = h_uart->uart_num - 1;
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH)
+			|| (PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		ch_num = (h_uart->uart_num *
+			SUART_NUM_OF_CHANNELS_PER_SUART) - 2;
+		if (h_uart->uart_num <= 4) {
+			pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+		} else {
+			pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+			ch_num -= 8;
+		}
+	} else if (PRU0_MODE == PRU_MODE_TX_ONLY) {
+		pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+	} else if (PRU1_MODE == PRU_MODE_TX_ONLY) {
+		pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+
+	if (tx_data_bits != 0) {
+		offset = pru_offset +
+			(ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+			PRU_SUART_CH_CONFIG2_OFFSET;
+		pruss_readb(dev, offset, (u8 *) &reg_val, 1);
+		reg_val &= ~(0xF);
+		reg_val |= tx_data_bits;
+		pruss_writeb(dev, offset, (u8 *) &reg_val, 1);
+	}
+	if (PRU0_MODE == PRU_MODE_RX_ONLY) {
+		pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+	} else if (PRU1_MODE == PRU_MODE_RX_ONLY) {
+		pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+	} else if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH)
+			|| (PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		ch_num++;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+	if (rx_data_bits != 0) {
+		offset = pru_offset +
+			(ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+			PRU_SUART_CH_CONFIG2_OFFSET;
+		pruss_readb(dev, offset, (u8 *) &reg_val, 1);
+		reg_val &= ~(0xF);
+		reg_val |= rx_data_bits;
+		pruss_writeb(dev, offset, (u8 *) &rx_data_bits, 1);
+	}
+
+	return status;
+}
+
+/*
+ * suart routine to configure specific uart
+ */
+s16 pru_softuart_setconfig(struct device *dev, suart_handle h_uart,
+				suart_config *config_uart)
+{
+	u32 offset;
+	u32 pru_offset;
+	s16 status = SUART_SUCCESS;
+	u16 ch_num;
+	u16 reg_val = 0;
+
+	if (h_uart == NULL)
+		return PRU_SUART_ERR_HANDLE_INVALID;
+
+	/*
+	 * NOTE:
+	 * Dependent baud rate for the given UART,the value MUST BE LESS THAN OR
+	 * EQUAL TO 64, preScalarValue <= 64
+	 */
+	if ((config_uart->tx_clk_divisor > 384)
+			|| (config_uart->rx_clk_divisor > 384)) {
+		return SUART_INVALID_CLKDIVISOR;
+	}
+	if ((config_uart->tx_bits_per_char < 8)
+			|| (config_uart->tx_bits_per_char > 14)) {
+		return PRU_SUART_ERR_PARAMETER_INVALID;
+	}
+	if ((config_uart->rx_bits_per_char < 8)
+			|| (config_uart->rx_bits_per_char > 14)) {
+		return PRU_SUART_ERR_PARAMETER_INVALID;
+	}
+	ch_num = h_uart->uart_num - 1;
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH)
+			|| (PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		ch_num = (h_uart->uart_num * SUART_NUM_OF_CHANNELS_PER_SUART)
+									 - 2;
+		if (h_uart->uart_num <= 4) {
+			pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+		} else {
+			pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+			ch_num -= 8;
+		}
+	} else if (PRU0_MODE == PRU_MODE_TX_ONLY) {
+		pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+	} else if (PRU1_MODE == PRU_MODE_TX_ONLY) {
+		pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+
+	/* Configuring the Transmit part of the given UART */
+	/* Serializer has been as TX in mcasp config, by writing 1 in bits
+	*  corresponding to tx serializer in PFUNC regsiter ie already set
+	*  to GPIO mode PRU code will set then back to MCASP mode once TX
+	*  request for that serializer is posted.It is required because at this
+	*  pos32 Mcasp is accessed by both PRU and DSP have lower priority for
+	*  Mcasp in comparison to PRU and DPS keeps on looping there only
+	*/
+	/*
+	 * suart_mcasp_tx_serialzier_set
+	 * (config_uart->tx_serializer, &suart_iomap);
+	 */
+	/* Configuring TX serializer  */
+	if (config_uart->tx_serializer != PRU_SUART_SERIALIZER_NONE) {
+		offset = pru_offset +
+			(ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+			PRU_SUART_CH_CTRL_OFFSET;
+		pruss_readb(dev, offset, (u8 *) &reg_val, 2);
+		reg_val = reg_val | (config_uart->tx_serializer <<
+			PRU_SUART_CH_CTRL_SR_SHIFT);
+		pruss_writeb(dev, offset, (u8 *) &reg_val, 2);
+		offset = pru_offset +
+			(ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+			PRU_SUART_CH_CONFIG1_OFFSET;
+		pruss_readb(dev, offset, (u8 *) &reg_val, 2);
+		reg_val = reg_val | (config_uart->tx_clk_divisor <<
+			PRU_SUART_CH_CONFIG1_DIVISOR_SHIFT);
+		pruss_writeb(dev, offset, (u8 *) &reg_val, 2);
+		offset = pru_offset +
+			(ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+			PRU_SUART_CH_CONFIG2_OFFSET;
+		pruss_readb(dev, offset, (u8 *) &reg_val, 2);
+		reg_val = reg_val | (config_uart->tx_bits_per_char <<
+			PRU_SUART_CH_CONFIG2_BITPERCHAR_SHIFT);
+		pruss_writeb(dev, offset, (u8 *) &reg_val, 2);
+		offset = 8;
+		pru_softuart_write(dev, h_uart, &offset, 0);
+	}
+
+	if (PRU0_MODE == PRU_MODE_RX_ONLY) {
+		pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+	} else if (PRU1_MODE == PRU_MODE_RX_ONLY) {
+		pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+	} else if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH) ||
+			(PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		ch_num++;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+
+	/* Configuring the Transmit part of the given UART */
+	if (config_uart->rx_serializer != PRU_SUART_SERIALIZER_NONE) {
+		/* Configuring RX serializer  */
+		offset = pru_offset +
+			(ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+			PRU_SUART_CH_CTRL_OFFSET;
+		pruss_readb(dev, offset, (u8 *) &reg_val, 2);
+		reg_val = reg_val | (config_uart->rx_serializer <<
+			PRU_SUART_CH_CTRL_SR_SHIFT);
+		pruss_writeb(dev, offset, (u8 *) &reg_val, 2);
+
+		/* Configuring RX prescalar value and Oversampling */
+		offset = pru_offset +
+			(ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+			PRU_SUART_CH_CONFIG1_OFFSET;
+		pruss_readb(dev, offset, (u8 *) &reg_val, 2);
+		reg_val = reg_val | (config_uart->rx_clk_divisor <<
+			PRU_SUART_CH_CONFIG1_DIVISOR_SHIFT) |
+			(config_uart->oversampling <<
+			PRU_SUART_CH_CONFIG1_OVS_SHIFT);
+		pruss_writeb(dev, offset, (u8 *) &reg_val, 2);
+
+		/* Configuring RX bits per character value */
+		offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL)
+						+ PRU_SUART_CH_CONFIG2_OFFSET;
+		pruss_readb(dev, offset, (u8 *) &reg_val, 2);
+		reg_val = reg_val | (config_uart->rx_bits_per_char <<
+			PRU_SUART_CH_CONFIG1_DIVISOR_SHIFT);
+		pruss_writeb(dev, offset, (u8 *) &reg_val, 2);
+	}
+	return status;
+}
+
+/*
+ * suart routine for getting the number of bytes transfered
+ */
+s16 pru_softuart_get_tx_data_len(struct device *dev, suart_handle h_uart)
+{
+	u32 offset;
+	u32 pru_offset;
+	u16 ch_num;
+	u16 u16_read_value = 0;
+
+	if (h_uart == NULL)
+		return PRU_SUART_ERR_HANDLE_INVALID;
+
+	ch_num = h_uart->uart_num - 1;
+
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH) ||
+				(PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		ch_num = (h_uart->uart_num * SUART_NUM_OF_CHANNELS_PER_SUART)
+									 - 2;
+		if (h_uart->uart_num <= 4) {
+			pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+		} else {
+			pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+			ch_num -= 8;
+		}
+	} else if (PRU0_MODE == PRU_MODE_TX_ONLY) {
+		pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+	} else if (PRU1_MODE == PRU_MODE_TX_ONLY) {
+		pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+						PRU_SUART_CH_CONFIG2_OFFSET;
+	pruss_readb(dev, offset, (u8 *) &u16_read_value, 2);
+	u16_read_value = ((u16_read_value & PRU_SUART_CH_CONFIG1_DIVISOR_MASK)
+					>> PRU_SUART_CH_CONFIG2_DATALEN_SHIFT);
+	return u16_read_value;
+}
+
+/*
+ * suart routine for getting the number of bytes received
+ */
+s16 pru_softuart_get_rx_data_len(struct device *dev, suart_handle h_uart)
+{
+	u32 offset;
+	u32 pru_offset;
+	u16 ch_num;
+	u16 u16_read_value = 0;
+
+	if (h_uart == NULL)
+		return PRU_SUART_ERR_HANDLE_INVALID;
+	ch_num = h_uart->uart_num - 1;
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH) ||
+				(PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		ch_num = (h_uart->uart_num *
+			SUART_NUM_OF_CHANNELS_PER_SUART) - 2;
+		if (h_uart->uart_num <= 4) {
+			pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+		} else {
+			pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+			ch_num -= 8;
+		}
+		ch_num++;
+	} else if (PRU0_MODE == PRU_MODE_RX_ONLY) {
+		pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+	} else if (PRU1_MODE == PRU_MODE_RX_ONLY) {
+		pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+						PRU_SUART_CH_CONFIG2_OFFSET;
+	pruss_readb(dev, offset, (u8 *) &u16_read_value, 2);
+	u16_read_value = ((u16_read_value & PRU_SUART_CH_CONFIG1_DIVISOR_MASK)
+					>> PRU_SUART_CH_CONFIG2_DATALEN_SHIFT);
+
+	return u16_read_value;
+}
+
+/*
+ * suart routine to get the configuration information from a specific uart
+ */
+s16 pru_softuart_getconfig(struct device *dev,
+			 suart_handle h_uart, suart_config *config_uart)
+{
+	u32 offset;
+	u32 pru_offset;
+	u16 ch_num;
+	u16 reg_val = 0;
+	s16 status = SUART_SUCCESS;
+
+	if (h_uart == NULL)
+		return PRU_SUART_ERR_HANDLE_INVALID;
+
+	/*
+	 * NOTE:
+	 * Dependent baud rate for the given UART,the value MUST BE LESS THAN OR
+	 * EQUAL TO 64, preScalarValue <= 64
+	 */
+
+	ch_num = h_uart->uart_num - 1;
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH) ||
+					 (PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		/* channel starts from 0 and uart instance starts from 1 */
+		ch_num = (h_uart->uart_num * SUART_NUM_OF_CHANNELS_PER_SUART)
+									 - 2;
+		if (h_uart->uart_num <= 4) {
+			pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+		} else {
+			pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+			ch_num -= 8;
+		}
+	} else if (PRU0_MODE == PRU_MODE_TX_ONLY) {
+		pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+	} else if (PRU1_MODE == PRU_MODE_TX_ONLY) {
+		pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+
+	/* Configuring the Transmit part of the given UART */
+	/* Configuring TX serializer  */
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+						PRU_SUART_CH_CTRL_OFFSET;
+	pruss_readb(dev, offset, (u8 *) &reg_val, 2);
+	config_uart->tx_serializer = ((reg_val & PRU_SUART_CH_CTRL_SR_MASK) >>
+						PRU_SUART_CH_CTRL_SR_SHIFT);
+	/* Configuring TX prescalar value */
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+						PRU_SUART_CH_CONFIG1_OFFSET;
+	pruss_readb(dev, offset, (u8 *) &reg_val, 2);
+	config_uart->tx_clk_divisor = ((reg_val &
+				 PRU_SUART_CH_CONFIG1_DIVISOR_MASK) >>
+					 PRU_SUART_CH_CONFIG1_DIVISOR_SHIFT);
+
+	/* Configuring TX bits per character value */
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+					PRU_SUART_CH_CONFIG2_OFFSET;
+	pruss_readb(dev, offset, (u8 *) &reg_val, 2);
+	config_uart->tx_bits_per_char = ((reg_val &
+				 PRU_SUART_CH_CONFIG1_DIVISOR_MASK) >>
+					PRU_SUART_CH_CONFIG1_DIVISOR_SHIFT);
+
+	if (PRU0_MODE == PRU_MODE_RX_ONLY) {
+		pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+	} else if (PRU1_MODE == PRU_MODE_RX_ONLY) {
+		pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+	} else if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH) ||
+				(PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		ch_num++;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+	/* Configuring the Transmit part of the given UART */
+	/* Configuring RX serializer  */
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+						PRU_SUART_CH_CTRL_OFFSET;
+	pruss_readb(dev, offset, (u8 *) &reg_val, 2);
+	config_uart->rx_serializer = ((reg_val & PRU_SUART_CH_CTRL_SR_MASK) >>
+						PRU_SUART_CH_CTRL_SR_SHIFT);
+
+	/* Configuring RX prescalar value and oversampling */
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+						PRU_SUART_CH_CONFIG1_OFFSET;
+	pruss_readb(dev, offset, (u8 *) &reg_val, 2);
+	config_uart->rx_clk_divisor = ((reg_val &
+					 PRU_SUART_CH_CONFIG1_DIVISOR_MASK)
+					>> PRU_SUART_CH_CONFIG1_DIVISOR_SHIFT);
+	config_uart->oversampling = ((reg_val &
+					 PRU_SUART_CH_CONFIG1_OVS_MASK) >>
+						PRU_SUART_CH_CONFIG1_OVS_SHIFT);
+
+	/* Configuring RX bits per character value */
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+						PRU_SUART_CH_CONFIG2_OFFSET;
+	pruss_readb(dev, offset, (u8 *) &reg_val, 2);
+	config_uart->rx_bits_per_char = ((reg_val &
+					 PRU_SUART_CH_CONFIG1_DIVISOR_MASK)
+					>> PRU_SUART_CH_CONFIG1_DIVISOR_SHIFT);
+
+	return status;
+}
+
+s32 pru_softuart_pending_tx_request(struct device *dev)
+{
+	u32 offset = 0;
+	u32 u32ISR_value = 0;
+
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH)
+	    || (PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		return SUART_SUCCESS;
+	} else if (PRU0_MODE == PRU_MODE_TX_ONLY) {
+		/* Read PRU Interrupt Status Register from PRU */
+		offset = (u32) (PRUSS_INTC_STATCLRINT1 & 0xFFFF);
+		pruss_readl(dev, offset, (u32 *)&u32ISR_value, 1);
+		if ((u32ISR_value & 0x1) == 0x1)
+			return PRU_SUART_FAILURE;
+	} else if (PRU1_MODE == PRU_MODE_TX_ONLY) {
+		/* Read PRU Interrupt Status Register from PRU */
+		offset = (u32) (PRUSS_INTC_STATCLRINT1 & 0xFFFF);
+		pruss_readl(dev, offset, (u32 *)&u32ISR_value, 1);
+		if ((u32ISR_value & 0x2) == 0x2)
+			return PRU_SUART_FAILURE;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+
+	return SUART_SUCCESS;
+}
+
+/*
+ * suart data transmit routine
+ */
+s16 pru_softuart_write(struct device *dev, suart_handle h_uart,
+		u32 *pt_tx_data_buf, u16 data_len)
+{
+	u32 offset = 0;
+	u32 pru_offset;
+	s16 status = SUART_SUCCESS;
+	u16 ch_num;
+	u16 reg_val = 0;
+	u16 pru_num;
+
+	if (h_uart == NULL)
+		return PRU_SUART_ERR_HANDLE_INVALID;
+	ch_num = h_uart->uart_num - 1;
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH)
+	    || (PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		ch_num = (h_uart->uart_num *
+			SUART_NUM_OF_CHANNELS_PER_SUART) - 2;
+		if (h_uart->uart_num <= 4) {
+			pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+			pru_num = h_uart->uart_num;
+		} else {
+			pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+			ch_num -= 8;
+			pru_num = h_uart->uart_num;
+		}
+	} else if (PRU0_MODE == PRU_MODE_TX_ONLY) {
+		pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+		pru_num = 0;
+	} else if (PRU1_MODE == PRU_MODE_TX_ONLY) {
+		pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+		pru_num = 1;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+
+	/* Writing data length to SUART channel register */
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+				PRU_SUART_CH_CONFIG2_OFFSET;
+	pruss_readb(dev, offset, (u8 *) &reg_val, 2);
+	reg_val &= ~PRU_SUART_CH_CONFIG2_DATALEN_MASK;
+	reg_val = reg_val | (data_len << PRU_SUART_CH_CONFIG2_DATALEN_SHIFT);
+	pruss_writeb(dev, offset, (u8 *) &reg_val, 2);
+
+	/* Writing the data pos32er to channel TX data pointer */
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+				PRU_SUART_CH_TXRXDATA_OFFSET;
+	pruss_writeb(dev, offset, (u8 *) pt_tx_data_buf, 4);
+
+	/* Service Request to PRU */
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+				PRU_SUART_CH_CTRL_OFFSET;
+	pruss_readb(dev, offset, (u8 *) &reg_val, 2);
+	reg_val &= ~(PRU_SUART_CH_CTRL_MODE_MASK |
+			PRU_SUART_CH_CTRL_SREQ_MASK);
+	reg_val |= (PRU_SUART_CH_CTRL_TX_MODE <<
+		PRU_SUART_CH_CTRL_MODE_SHIFT) | (PRU_SUART_CH_CTRL_SREQ <<
+		PRU_SUART_CH_CTRL_SREQ_SHIFT);
+	pruss_writeb(dev, offset, (u8 *) &reg_val, 2);
+
+	/* generate ARM->PRU event */
+	suart_arm_to_pru_intr(dev, pru_num);
+
+	return status;
+}
+
+/*
+ * suart data receive routine
+ */
+s16 pru_softuart_read(struct device *dev, suart_handle h_uart,
+		u32 *ptDataBuf, u16 data_len)
+{
+	u32 offset = 0;
+	u32 pru_offset;
+	s16 status = SUART_SUCCESS;
+	u16 ch_num;
+	u16 reg_val = 0;
+	u16 pru_num;
+
+	if (h_uart == NULL)
+		return PRU_SUART_ERR_HANDLE_INVALID;
+
+	ch_num = h_uart->uart_num - 1;
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH) ||
+			 (PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		/* channel starts from 0 and uart instance starts from 1 */
+	ch_num = (h_uart->uart_num * SUART_NUM_OF_CHANNELS_PER_SUART) - 2;
+		if (h_uart->uart_num <= 4) {
+			pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+			pru_num = h_uart->uart_num;
+		} else {
+			pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+			ch_num -= 8;
+			pru_num = h_uart->uart_num;
+		}
+		ch_num++;
+	} else if (PRU0_MODE == PRU_MODE_RX_ONLY) {
+		pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+		pru_num = 0;
+	} else if (PRU1_MODE == PRU_MODE_RX_ONLY) {
+		pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+		pru_num = 1;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+	/* Writing data length to SUART channel register */
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+					PRU_SUART_CH_CONFIG2_OFFSET;
+	pruss_readb(dev, offset, (u8 *) &reg_val, 2);
+	reg_val &= ~PRU_SUART_CH_CONFIG2_DATALEN_MASK;
+	reg_val = reg_val | (data_len << PRU_SUART_CH_CONFIG2_DATALEN_SHIFT);
+	pruss_writeb(dev, offset, (u8 *) &reg_val, 2);
+
+	/* Writing the data pos32er to channel RX data pointer */
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+		PRU_SUART_CH_TXRXDATA_OFFSET;
+	pruss_writeb(dev, offset, (u8 *) ptDataBuf, 4);
+
+	/* Service Request to PRU */
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+		PRU_SUART_CH_CTRL_OFFSET;
+	pruss_readb(dev, offset, (u8 *) &reg_val, 2);
+	reg_val &= ~(PRU_SUART_CH_CTRL_MODE_MASK |
+		PRU_SUART_CH_CTRL_SREQ_MASK);
+	reg_val |= (PRU_SUART_CH_CTRL_RX_MODE <<
+		PRU_SUART_CH_CTRL_MODE_SHIFT) | (PRU_SUART_CH_CTRL_SREQ <<
+		PRU_SUART_CH_CTRL_SREQ_SHIFT);
+	pruss_writeb(dev, offset, (u8 *) &reg_val, 2);
+
+	/* enable the timeout s32errupt */
+	suart_intr_setmask(dev, h_uart->uart_num, PRU_RX_INTR,
+		CHN_TXRX_IE_MASK_TIMEOUT);
+
+	/* generate ARM->PRU event */
+	suart_arm_to_pru_intr(dev, pru_num);
+
+	return status;
+}
+
+/*
+ * suart routine to read the data from the RX FIFO
+ */
+s16 pru_softuart_read_data(struct device *dev, suart_handle h_uart,
+				u8 *p_data_buffer, s32 s32max_len,
+					u32 *pu32data_read)
+{
+	s16 ret_val = PRU_SUART_SUCCESS;
+	u8 *pu8src_addr = NULL;
+	u32 u32data_read = 0;
+	u32 u32data_len = 0;
+	u32 u32char_len = 0;
+	u32 offset = 0;
+	u32 pru_offset;
+	u16 ch_num;
+	u16 u16status = 0;
+
+	if (h_uart == NULL)
+		return PRU_SUART_ERR_HANDLE_INVALID;
+
+	ch_num = h_uart->uart_num - 1;
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH)
+	    || (PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		/* channel starts from 0 and uart instance starts from 1 */
+		ch_num = (h_uart->uart_num *
+			SUART_NUM_OF_CHANNELS_PER_SUART) - 2;
+		if (h_uart->uart_num <= 4) {
+			pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+		} else {
+			pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+			ch_num -= 8;
+		}
+		ch_num++;
+	} else if (PRU0_MODE == PRU_MODE_RX_ONLY) {
+		pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+	} else if (PRU1_MODE == PRU_MODE_RX_ONLY) {
+		pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+
+	/* Get the data pos32er from channel RX data pointer */
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+						PRU_SUART_CH_TXRXDATA_OFFSET;
+	pruss_readb(dev, offset, (u8 *) &pu8src_addr, 4);
+
+	/* Reading data length from SUART channel register */
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+						PRU_SUART_CH_CONFIG2_OFFSET;
+	pruss_readb(dev, offset, (u8 *) &u32data_len, 2);
+
+	/* read the character length */
+	u32char_len = u32data_len & PRU_SUART_CH_CONFIG2_BITPERCHAR_MASK;
+	u32char_len -= 2;	/* remove the START & STOP bit */
+
+	u32data_len &= PRU_SUART_CH_CONFIG2_DATALEN_MASK;
+	u32data_len = u32data_len >> PRU_SUART_CH_CONFIG2_DATALEN_SHIFT;
+	u32data_len++;
+
+	/* if the character length is greater than 8, then the size doubles */
+	if (u32char_len > 8)
+		u32data_len *= 2;
+
+	/* Check if the time-out had occured. If, yes, then we need to find the
+	 * number of bytes read from PRU. Else, we need to
+	 * read the requested bytes
+	 */
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+						PRU_SUART_CH_TXRXSTATUS_OFFSET;
+	pruss_readb(dev, offset, (u8 *) &u16status, 1);
+	if (CHN_TXRX_STATUS_TIMEOUT == (u16status & CHN_TXRX_STATUS_TIMEOUT)) {
+		/* determine the number of bytes read s32o the FIFO */
+		offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL)
+				 + PRU_SUART_CH_BYTESDONECNTR_OFFSET;
+		pruss_readb(dev, offset, (u8 *) &u32data_read, 1);
+
+		/* if the character length is greater than 8,
+				then the size doubles */
+		if (u32char_len > 8)
+			u32data_read *= 2;
+
+/*
+ * the data corresponding is loaded in second
+ * half during the timeout
+ */
+		if (u32data_read > u32data_len) {
+			u32data_read -= u32data_len;
+			pu8src_addr += (u32data_len + 1);
+		}
+
+		pru_softuart_clr_rx_fifo(dev, h_uart);
+	} else {
+		u32data_read = u32data_len;
+/*
+ * if the bit is set, the data is in the first
+ * half of the FIFO else the data is in the second half
+ */
+		/* Determine the buffer index by reading FIFO_OddEven flag*/
+		if (u16status & CHN_TXRX_STATUS_CMPLT)
+			pu8src_addr += u32data_len;
+	}
+
+	/* we should be copying only max len given by the application */
+	if (u32data_read > s32max_len)
+		u32data_read = s32max_len;
+
+/* evaluate the virtual address of the FIFO address
+ * based on the physical addr
+ */
+	pu8src_addr = (u8 *)((u32) pu8src_addr -
+		(u32) suart_iomap.p_fifo_buff_phys_base +
+		(u32) suart_iomap.p_fifo_buff_virt_base);
+
+	/* Now we have both the data length and the source address. copy */
+	for (offset = 0; offset < u32data_read; offset++) {
+		*p_data_buffer++ = *pu8src_addr++;
+	}
+	*pu32data_read = u32data_read;
+	ret_val = PRU_SUART_SUCCESS;
+
+	return ret_val;
+}
+
+/*
+ * suart routine to disable the receive functionality.
+ * This routine stops the PRU from receiving on selected
+ * UART and also disables the McASP serializer corresponding
+ * to this UART Rx line.
+ */
+s16 pru_softuart_stop_receive(struct device *dev, suart_handle h_uart)
+{
+	u16 status = SUART_SUCCESS;
+	u32 offset;
+	u32 pru_offset;
+	u16 ch_num;
+	u16 u16status;
+
+	if (h_uart == NULL)
+		return PRU_SUART_ERR_HANDLE_INVALID;
+
+	ch_num = h_uart->uart_num - 1;
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH)
+	    || (PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+
+		/* channel starts from 0 and uart instance starts from 1 */
+		ch_num = (h_uart->uart_num *
+			SUART_NUM_OF_CHANNELS_PER_SUART) - 2;
+
+		if (h_uart->uart_num <= 4) {
+			/* PRU0 */
+			pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+		} else {
+			/* PRU1 */
+			pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+			/* First 8 channel corresponds to PRU0 */
+			ch_num -= 8;
+		}
+		ch_num++;
+	} else if (PRU0_MODE == PRU_MODE_RX_ONLY) {
+		pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+	} else if (PRU1_MODE == PRU_MODE_RX_ONLY) {
+		pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+
+	/* read the existing value of status flag */
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+						PRU_SUART_CH_TXRXSTATUS_OFFSET;
+	pruss_readb(dev, offset, (u8 *) &u16status, 1);
+
+	/* we need to clear the busy bit corresponding to receive channel */
+	u16status &= ~(CHN_TXRX_STATUS_RDY);
+	pruss_writeb(dev, offset, (u8 *) &u16status, 1);
+
+	/* get the serizlizer number being used for this Rx channel */
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+						PRU_SUART_CH_CTRL_OFFSET;
+	pruss_readb(dev, offset, (u8 *) &u16status, 2);
+	u16status &= PRU_SUART_CH_CTRL_SR_MASK;
+	u16status = u16status >> PRU_SUART_CH_CTRL_SR_SHIFT;
+
+	/* we need to de-activate the serializer corresponding to this rx */
+	status = suart_asp_serializer_deactivate(u16status, &suart_iomap);
+
+	return status;
+}
+
+/*
+ * suart routine to get the tx status for a specific uart
+ */
+s16 pru_softuart_get_tx_status(struct device *dev, suart_handle h_uart)
+{
+	u32 offset;
+	u32 pru_offset;
+	u16 status = SUART_SUCCESS;
+	u16 ch_num;
+
+	if (h_uart == NULL)
+		return PRU_SUART_ERR_HANDLE_INVALID;
+
+	ch_num = h_uart->uart_num - 1;
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH)
+	    || (PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		/* channel starts from 0 and uart instance starts from 1 */
+		ch_num = (h_uart->uart_num *
+			SUART_NUM_OF_CHANNELS_PER_SUART) - 2;
+
+		if (h_uart->uart_num <= 4) {
+			/* PRU0 */
+			pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+		} else {
+			/* PRU1 */
+			pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+			/* First 8 channel corresponds to PRU0 */
+			ch_num -= 8;
+		}
+	} else if (PRU0_MODE == PRU_MODE_TX_ONLY) {
+		pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+	} else if (PRU1_MODE == PRU_MODE_TX_ONLY) {
+		pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+					PRU_SUART_CH_TXRXSTATUS_OFFSET;
+	pruss_readb(dev, offset, (u8 *) &status, 1);
+	return status;
+}
+
+s16 pru_softuart_clr_tx_status(struct device *dev, suart_handle h_uart)
+{
+	u32 offset;
+	u32 pru_offset;
+	u16 status = SUART_SUCCESS;
+	u16 ch_num;
+
+	if (h_uart == NULL)
+		return PRU_SUART_ERR_HANDLE_INVALID;
+
+	ch_num = h_uart->uart_num - 1;
+
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH)
+	    || (PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+
+		/* channel starts from 0 and uart instance starts from 1 */
+		ch_num = (h_uart->uart_num *
+			SUART_NUM_OF_CHANNELS_PER_SUART) - 2;
+
+		if (h_uart->uart_num <= 4) {
+			/* PRU0 */
+			pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+		} else {
+			/* PRU1 */
+			pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+			/* First 8 channel corresponds to PRU0 */
+			ch_num -= 8;
+		}
+	} else if (PRU0_MODE == PRU_MODE_TX_ONLY) {
+		pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+	} else if (PRU1_MODE == PRU_MODE_TX_ONLY) {
+		pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+					PRU_SUART_CH_TXRXSTATUS_OFFSET;
+	pruss_readb(dev, offset, (u8 *) &status, 1);
+	status &= ~(0x2);
+	pruss_writeb(dev, offset, (u8 *) &status, 1);
+	return status;
+}
+
+/*
+ * suart routine to get the rx status for a specific uart
+ */
+s16 pru_softuart_get_rx_status(struct device *dev, suart_handle h_uart)
+{
+	u32 offset;
+	u32 pru_offset;
+	u16 status = SUART_SUCCESS;
+	u16 ch_num;
+
+	if (h_uart == NULL)
+		return PRU_SUART_ERR_HANDLE_INVALID;
+	ch_num = h_uart->uart_num - 1;
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH)
+	    || (PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		/* channel starts from 0 and uart instance starts from 1 */
+		ch_num = (h_uart->uart_num *
+			SUART_NUM_OF_CHANNELS_PER_SUART) - 2;
+
+		if (h_uart->uart_num <= 4) {
+			/* PRU0 */
+			pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+		} else {
+			/* PRU1 */
+			pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+			/* First 8 channel corresponds to PRU0 */
+			ch_num -= 8;
+		}
+		ch_num++;
+	} else if (PRU0_MODE == PRU_MODE_RX_ONLY) {
+		pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+	} else if (PRU1_MODE == PRU_MODE_RX_ONLY) {
+		pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+				PRU_SUART_CH_TXRXSTATUS_OFFSET;
+	pruss_readb(dev, offset, (u8 *) &status, 1);
+	return status;
+}
+
+s16 pru_softuart_clr_rx_fifo(struct device *dev, suart_handle h_uart)
+{
+	u32 offset;
+	u32 pru_offset;
+	u16 status = SUART_SUCCESS;
+	u16 ch_num;
+	u16 reg_val;
+	u16 uart_num;
+
+	if (h_uart == NULL)
+		return PRU_SUART_ERR_HANDLE_INVALID;
+	uart_num = h_uart->uart_num;
+	ch_num = h_uart->uart_num - 1;
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH)
+	    || (PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+
+		/* channel starts from 0 and uart instance starts from 1 */
+		ch_num = (h_uart->uart_num * SUART_NUM_OF_CHANNELS_PER_SUART)
+									 - 2;
+
+		if (h_uart->uart_num <= 4) {
+			/* PRU0 */
+			pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+		} else {
+			/* PRU1 */
+			pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+			/* First 8 channel corresponds to PRU0 */
+			ch_num -= 8;
+		}
+		ch_num++;
+	} else if (PRU0_MODE == PRU_MODE_RX_ONLY) {
+		pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+		uart_num = 0;
+	} else if (PRU1_MODE == PRU_MODE_RX_ONLY) {
+		pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+		uart_num = 1;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+
+	/* Service Request to PRU */
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+						PRU_SUART_CH_CTRL_OFFSET;
+	pruss_readb(dev, offset, (u8 *) &reg_val, 2);
+	reg_val &= ~(PRU_SUART_CH_CTRL_MODE_MASK | PRU_SUART_CH_CTRL_SREQ_MASK);
+	reg_val |= (PRU_SUART_CH_CTRL_RX_MODE << PRU_SUART_CH_CTRL_MODE_SHIFT) |
+		(PRU_SUART_CH_CTRL_SREQ << PRU_SUART_CH_CTRL_SREQ_SHIFT);
+	pruss_writeb(dev, offset, (u8 *) &reg_val, 2);
+	suart_intr_setmask(dev, h_uart->uart_num, PRU_RX_INTR,
+						CHN_TXRX_IE_MASK_TIMEOUT);
+
+	/* generate ARM->PRU event */
+	suart_arm_to_pru_intr(dev, uart_num);
+
+	return status;
+}
+
+s16 pru_softuart_clr_rx_status(struct device *dev, suart_handle h_uart)
+{
+	u32 offset;
+	u32 pru_offset;
+	u16 status = SUART_SUCCESS;
+	u16 ch_num;
+
+	if (h_uart == NULL)
+		return PRU_SUART_ERR_HANDLE_INVALID;
+
+	ch_num = h_uart->uart_num - 1;
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH) ||
+		(PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+
+		/* channel starts from 0 and uart instance starts from 1 */
+		ch_num = (h_uart->uart_num *
+			SUART_NUM_OF_CHANNELS_PER_SUART) - 2;
+
+		if (h_uart->uart_num <= 4) {
+			/* PRU0 */
+			pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+		} else {
+			/* PRU1 */
+			pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+			/* First 8 channel corresponds to PRU0 */
+			ch_num -= 8;
+		}
+		ch_num++;
+	} else if (PRU0_MODE == PRU_MODE_RX_ONLY) {
+		pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+	} else if (PRU1_MODE == PRU_MODE_RX_ONLY) {
+		pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+
+	offset = pru_offset + (ch_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+			PRU_SUART_CH_TXRXSTATUS_OFFSET;
+	pruss_readb(dev, offset, (u8 *) &status, 1);
+	status &= ~(0x3C);
+	pruss_writeb(dev, offset, (u8 *) &status, 1);
+	return status;
+}
+
+/*
+ * suart_s32r_status_read: Gets the Global Interrupt status register
+ * for the specified SUART.
+ * uart_num < 1 to 6 >
+ * txrx_flag < Indicates TX or RX s32errupt for the uart >
+ */
+s16 pru_softuart_get_isrstatus(struct device *dev, u16 uart_num, u16 *txrx_flag)
+{
+	u32 offset;
+	u32 u32intc_offset;
+	u32 ch_num = 0xFF;
+	u32 reg_val = 0;
+	u32 u32reg_val = 0;
+	u32 u32ISR_value = 0;
+	u32 u32ack_reg_val = 0;
+	u8 pru0_mode = PRU_MODE_INVALID;
+	u8 pru1_mode = PRU_MODE_INVALID;
+	u32 u32stat_inx_clr_regoffset = 0;
+
+	/* initialize the status & Flag to known value */
+	*txrx_flag = 0;
+
+	u32stat_inx_clr_regoffset = (u32) (PRUSS_INTC_STATIDXCLR & 0xFFFF);
+
+	/* Read PRU Interrupt Status Register from PRU */
+	u32intc_offset = (u32) (PRUSS_INTC_STATCLRINT1 & 0xFFFF);
+
+	pruss_readl(dev, u32intc_offset, (u32 *)&u32ISR_value, 1);
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH)
+		|| (PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		/* determine if the s32errupt occured current UART context */
+		u32reg_val = (PRU_SUART0_TX_EVT_BIT | PRU_SUART0_RX_EVT_BIT) <<
+				((uart_num - 1) * 2);
+
+		/* channel starts from 0 and uart instance starts from 1 */
+		ch_num = uart_num * 2 - 2;
+		if (uart_num <= 4)
+			pru0_mode = PRU_MODE_RX_TX_BOTH;
+		else
+			pru1_mode = PRU_MODE_RX_TX_BOTH;
+	} else {
+		ch_num = uart_num - 1;
+		if ((u32ISR_value & 0x03FC) != 0) {
+			u32reg_val = 0;
+
+			offset = PRU_SUART_PRU0_RX_TX_MODE;
+			pruss_readb(dev, offset, (u8 *) &pru0_mode, 1);
+			u32reg_val |= 1 << (uart_num + 1);
+			if (u32ISR_value & u32reg_val) {
+				/* acknowledge the s32errupt  */
+				u32ack_reg_val = ch_num + PRU_SUART0_TX_EVT;
+				pruss_writel(dev, u32stat_inx_clr_regoffset,
+					(u32 *)&u32ack_reg_val, 1);
+				*txrx_flag |= PRU_RX_INTR;
+			}
+		}
+		pruss_readl(dev, u32intc_offset, (u32 *)&u32ISR_value, 1);
+		if (u32ISR_value & 0x3FC00) {
+			u32reg_val = 0;
+			offset = PRU_SUART_PRU1_RX_TX_MODE;
+			pruss_readb(dev, offset, (u8 *) &pru1_mode, 1);
+			u32reg_val |= 1 << (uart_num + 9);
+			if (u32ISR_value & u32reg_val) {
+				/* acknowledge the s32errupt  */
+				u32ack_reg_val = ch_num + PRU_SUART4_TX_EVT;
+				pruss_writel(dev, u32stat_inx_clr_regoffset,
+					(u32 *)&u32ack_reg_val, 1);
+				*txrx_flag |= PRU_TX_INTR;
+			}
+		}
+	}
+	if (u32ISR_value & u32reg_val) {
+		if ((pru0_mode == PRU_MODE_RX_TX_BOTH)
+		    || (pru1_mode == PRU_MODE_RX_TX_BOTH)) {
+			/* Check if the s32errupt occured for Tx */
+			u32reg_val = PRU_SUART0_TX_EVT_BIT << ((uart_num - 1)
+									 * 2);
+			if (u32ISR_value & u32reg_val) {
+				/* s32erupt occured for TX */
+				*txrx_flag |= PRU_TX_INTR;
+				/* acknowledge the RX s32errupt  */
+				u32ack_reg_val = ch_num + PRU_SUART0_TX_EVT;
+				pruss_writel(dev, u32stat_inx_clr_regoffset,
+					(u32 *)&u32ack_reg_val, 1);
+			}
+
+			/* Check if the s32errupt occured for Rx */
+			u32reg_val = PRU_SUART0_RX_EVT_BIT<<((uart_num - 1)
+									 * 2);
+			if (u32ISR_value & u32reg_val) {
+				/* s32erupt occured for RX */
+				*txrx_flag |= PRU_RX_INTR;
+				ch_num += 1;
+
+				/* acknowledge the RX s32errupt  */
+				u32ack_reg_val = ch_num + PRU_SUART0_TX_EVT;
+				pruss_writel(dev, u32stat_inx_clr_regoffset,
+					(u32 *)&u32ack_reg_val, 1);
+			}
+		}
+		reg_val = SUART_SUCCESS;
+	}
+	return reg_val;
+}
+
+s32 pru_intr_clr_isrstatus(struct device *dev, u16 uart_num, u32 txrxmode)
+{
+	u32 offset;
+	u16 txrx_flag = 0;
+	u16 chn_num;
+
+	chn_num = uart_num - 1;
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH)
+	    || (PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		/* channel starts from 0 and uart instance starts from 1 */
+		chn_num = (uart_num * SUART_NUM_OF_CHANNELS_PER_SUART) - 2;
+		if (uart_num <= 4) {
+			/* PRU0 */
+			offset = PRU_SUART_PRU0_ISR_OFFSET + 1;
+		} else {
+			/* PRU1 */
+			offset = PRU_SUART_PRU1_ISR_OFFSET + 1;
+			/* First 8 channel corresponds to PRU0 */
+			chn_num -= 8;
+		}
+		if (2 == txrxmode)
+			chn_num++;
+	} else if (PRU0_MODE == txrxmode) {
+		offset = PRU_SUART_PRU0_ISR_OFFSET + 1;
+	} else if (PRU1_MODE == txrxmode) {
+		offset = PRU_SUART_PRU1_ISR_OFFSET + 1;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+
+	pruss_readb(dev, offset, (u8 *) &txrx_flag, 1);
+	txrx_flag &= ~(0x2);
+	pruss_writeb(dev, offset, (u8 *) &txrx_flag, 1);
+
+	return 0;
+}
+
+s16 suart_arm_to_pru_intr(struct device *dev, u16 uart_num)
+{
+	u32 u32offset;
+	u32 u32value;
+	s16 s16retval;
+
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH)
+	    || (PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		if ((uart_num > 0) && (uart_num <= 4)) {
+			/* PRU0 SYS_EVT32 */
+			u32value = 0x20;
+		} else if ((uart_num > 4) && (uart_num <= 8)) {
+			/* PRU1 SYS_EVT33 */
+			u32value = 0x21;
+		} else {
+			return SUART_INVALID_UART_NUM;
+		}
+	}
+
+	if ((PRU0_MODE == PRU_MODE_RX_ONLY) || (PRU1_MODE == PRU_MODE_RX_ONLY)
+	    || (PRU0_MODE == PRU_MODE_TX_ONLY)
+	    || (PRU1_MODE == PRU_MODE_TX_ONLY)) {
+		if (uart_num == PRUSS_NUM0) {
+			/* PRU0 SYS_EVT32 */
+			u32value = 0x20;
+		}
+
+		if (uart_num == PRUSS_NUM1) {
+			/* PRU0 SYS_EVT33 */
+			u32value = 0x21;
+		}
+	}
+
+	u32offset = (u32) (PRUSS_INTC_STATIDXSET & 0xFFFF);
+	s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+	if (s16retval == -1)
+		return -1;
+	return 0;
+}
+
+s16 arm_to_pru_intr_init(struct device *dev)
+{
+	u32 u32offset;
+	u32 u32value;
+	u32 int_offset;
+	s16 s16retval = -1;
+#if 0
+	/* Set the MCASP Event to PRU0 as Edge Triggered */
+	u32offset = (u32)(PRU_INTC_TYPE0 & 0xFFFF);
+	u32value = 0x80000000;
+	s16retval =
+	    pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+	if (s16retval == -1)
+		return -1;
+
+#endif
+	/* Clear all the host s32errupts */
+	for (int_offset = 0; int_offset <= PRUSS_INTC_HOSTINTLVL_MAX;
+							int_offset++) {
+		u32offset = (u32) (PRUSS_INTC_HSTINTENIDXCLR & 0xFFFF);
+		u32value = int_offset;
+		s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+		if (s16retval == -1)
+			return -1;
+	}
+
+	/* Enable the global s32errupt */
+	u32offset = (u32) (PRUSS_INTC_GLBLEN & 0xFFFF);
+	u32value = 0x1;
+	s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+	if (s16retval == -1)
+		return -1;
+
+	/* Enable the Host s32errupts for all host channels */
+	for (int_offset = 0; int_offset <= PRUSS_INTC_HOSTINTLVL_MAX;
+							 int_offset++) {
+		u32offset = (u32) (PRUSS_INTC_HSTINTENIDXSET & 0xFFFF);
+		u32value = int_offset;
+		s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+		if (s16retval == -1)
+			return -1;
+	}
+
+	u32offset = (u32) (PRUSS_INTC_HOSTMAP0 & 0xFFFF);
+	u32value = PRU_INTC_CHAN_123_HOST;
+	s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+	if (-1 == s16retval)
+		return -1;
+
+	u32offset = (u32) (PRUSS_INTC_HOSTMAP1 & 0xFFFF);
+	u32value = PRU_INTC_CHAN_4567_HOST;
+	s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+	if (-1 == s16retval)
+		return -1;
+	u32offset = (u32) (PRUSS_INTC_HOSTMAP2 & 0xFFFF);
+	u32value = PRU_INTC_CHAN_89_HOST;
+	s16retval =
+	    pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+	if (-1 == s16retval)
+		return -1;
+
+	/* Set the channel for System s32rrupts
+	 * MAP Channel 0 to SYS_EVT31
+	 */
+	u32offset =	(u32) (PRUSS_INTC_CHANMAP7 & 0xFFFF);
+	u32value = PRU_INTC_CHAN_0_SYSEVT_31;
+	s16retval =
+	    pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+	if (-1 == s16retval)
+		return -1;
+
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH)
+	    || (PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		u32offset = (u32) (PRUSS_INTC_CHANMAP8 & 0xFFFF);
+		u32value = PRU_INTC_CHAN_12_SYSEVT;
+		s16retval =
+		    pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+		if (-1 == s16retval)
+			return -1;
+
+		/* Sets the channel for the system s32errupt
+		 * MAP channel 3 to SYS_EVT36   SUART1-Tx
+		 * MAP channel 3 to SYS_EVT37   SUART1-Rx
+		 * MAP channel 4 to SYS_EVT38   SUART2-Tx
+		 * MAP channel 4 to SYS_EVT39   SUART2-Rx
+		 */
+		u32offset = (u32) (PRUSS_INTC_CHANMAP9 & 0xFFFF);
+		u32value = PRU_INTC_CHAN_34_SYSEVT_36_39;
+		s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+		if (-1 == s16retval)
+			return -1;
+
+		/* Sets the channel for the system s32errupt
+		 * MAP channel 5 to SYS_EVT40   SUART3-Tx
+		 * MAP channel 5 to SYS_EVT41   SUART3-Rx
+		 * MAP channel 6 to SYS_EVT42   SUART4-Tx
+		 * MAP channel 6 to SYS_EVT43   SUART4-Rx
+		 */
+		u32offset = (u32) (PRUSS_INTC_CHANMAP10 & 0xFFFF);
+		u32value = PRU_INTC_CHAN_56_SYSEVT_40_43;
+		s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+		if (-1 == s16retval)
+			return -1;
+
+		/* Sets the channel for the system s32errupt
+		 * MAP channel 7 to SYS_EVT44   SUART5-Tx
+		 * MAP channel 7 to SYS_EVT45   SUART5-Rx
+		 * MAP channel 8 to SYS_EVT46   SUART6-Tx
+		 * MAP channel 8 to SYS_EVT47   SUART6-Rx
+		 */
+		u32offset = (u32) (PRUSS_INTC_CHANMAP11 & 0xFFFF);
+		u32value = PRU_INTC_CHAN_78_SYSEVT_44_47;
+		s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+		if (-1 == s16retval)
+			return -1;
+
+		/* Sets the channel for the system s32errupt
+		 * MAP channel 9 to SYS_EVT48   SUART7-Tx
+		 * MAP channel 9 to SYS_EVT49   SUART7-Rx
+		 */
+		u32offset = (u32) (PRUSS_INTC_CHANMAP12 & 0xFFFF);
+		u32value = PRU_INTC_CHAN_9_SYSEVT_48_49;
+		s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+		if (-1 == s16retval)
+			return -1;
+	}
+	if ((PRU0_MODE == PRU_MODE_RX_ONLY) || (PRU1_MODE == PRU_MODE_RX_ONLY)
+	    || (PRU0_MODE == PRU_MODE_TX_ONLY)
+	    || (PRU1_MODE == PRU_MODE_TX_ONLY)) {
+		/* Sets the channel for the system s32errupt
+		 * MAP channel 0 to SYS_EVT32
+		 * MAP channel 1 to SYS_EVT33
+		 * MAP channel 2 to SYS_EVT34  SUART0
+		 * MAP channel 3 to SYS_EVT35  SUART1
+		 */
+		u32offset = (u32) (PRUSS_INTC_CHANMAP8 & 0xFFFF);
+		u32value = PRU_INTC_CHAN_0123_SYSEVT_32_35;
+		s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+		if (-1 == s16retval)
+			return -1;
+
+		/* Sets the channel for the system s32errupt
+		 * MAP channel 4 to SYS_EVT36   SUART2
+		 * MAP channel 5 to SYS_EVT37   SUART3
+		 * MAP channel 6 to SYS_EVT38   SUART4
+		 * MAP channel 7 to SYS_EVT39   SUART5
+		 */
+		u32offset = (u32) (PRUSS_INTC_CHANMAP9 & 0xFFFF);
+		u32value = PRU_INTC_CHAN_4567_SYSEVT_36_39;
+		s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+		if (-1 == s16retval)
+			return -1;
+
+		/* Sets the channel for the system s32errupt
+		 * MAP channel 8 to SYS_EVT40   SUART6
+		 * MAP channel 9 to SYS_EVT41   SUART7
+		 * MAP channel 2 to SYS_EVT42   SUART0
+		 * MAP channel 3 to SYS_EVT43   SUART1
+		 */
+		u32offset = (u32) (PRUSS_INTC_CHANMAP10 & 0xFFFF);
+		u32value = PRU_INTC_CHAN_8923_SYSEVT_40_43;
+		s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+		if (-1 == s16retval)
+			return -1;
+
+		/* Sets the channel for the system s32errupt
+		 * MAP channel 4 to SYS_EVT44   SUART2
+		 * MAP channel 5 to SYS_EVT45   SUART3
+		 * MAP channel 6 to SYS_EVT46   SUART4
+		 * MAP channel 7 to SYS_EVT47   SUART5
+		 */
+		u32offset = (u32) (PRUSS_INTC_CHANMAP11 & 0xFFFF);
+		u32value = PRU_INTC_CHAN_4567_SYSEVT_44_47;
+		s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+		if (-1 == s16retval)
+			return -1;
+
+		/* Sets the channel for the system s32errupt
+		 * MAP channel 8 to SYS_EVT48   SUART6
+		 * MAP channel 9 to SYS_EVT49   SUART7
+		 */
+		u32offset = (u32) (PRUSS_INTC_CHANMAP12 & 0xFFFF);
+		u32value = 0x00010908;
+		s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+		if (-1 == s16retval)
+			return -1;
+	}
+
+	/* Clear required set of system events
+	* and enable them using indexed register
+	*/
+	for (int_offset = 0; int_offset < 18; int_offset++) {
+		u32offset = (u32) (PRUSS_INTC_STATIDXCLR & 0xFFFF);
+		u32value = 32 + int_offset;
+		s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+		if (s16retval == -1)
+			return -1;
+
+	}
+	/* enable only the HOST to PRU s32errupts and let the PRU to Host events
+	 * enabled by the separate API on demand basis.
+	 */
+	u32offset = (u32) (PRUSS_INTC_ENIDXSET & 0xFFFF);
+	u32value = 31;
+	s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+	if (s16retval == -1)
+		return -1;
+
+	u32offset = (u32) (PRUSS_INTC_ENIDXSET & 0xFFFF);
+	u32value = 32;
+	s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+	if (s16retval == -1)
+		return -1;
+	u32offset = (u32) (PRUSS_INTC_ENIDXSET & 0xFFFF);
+	u32value = 33;
+	s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+	if (s16retval == -1)
+		return -1;
+	u32offset = (u32) (PRUSS_INTC_ENIDXSET & 0xFFFF);
+	u32value = 50;
+	s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+	if (s16retval == -1)
+		return -1;
+
+	/* Enable the global s32errupt */
+	u32offset = (u32) (PRUSS_INTC_GLBLEN & 0xFFFF);
+	u32value = 0x1;
+	s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+	if (s16retval == -1)
+		return -1;
+
+	/* Enable the Host s32errupts for all host channels */
+	for (int_offset = 0; int_offset <= PRUSS_INTC_HOSTINTLVL_MAX;
+							int_offset++) {
+		u32offset = (u32) (PRUSS_INTC_HSTINTENIDXSET & 0xFFFF);
+		u32value = int_offset;
+		s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+		if (s16retval == -1)
+			return -1;
+	}
+
+	return 0;
+}
+
+s32 suart_pru_to_host_intr_enable(struct device *dev, u16 uart_num,
+		u32 txrxmode, s32 s32_flag)
+{
+	s32 ret_val = 0;
+	u32 u32offset;
+	u32 chn_num;
+	u32 u32value;
+	s16 s16retval = 0;
+
+	if (uart_num > 8)
+		return SUART_INVALID_UART_NUM;
+
+	chn_num = uart_num - 1;
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH) ||
+		(PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		chn_num = (uart_num * 2) - 2;
+		if (2 == txrxmode)	/* Rx mode */
+			chn_num++;
+		u32value = 34 + chn_num;
+	} else if ((PRU_MODE_RX_ONLY == txrxmode)
+		&& (PRU0_MODE == PRU_MODE_RX_ONLY))
+		u32value = 34 + chn_num;
+	else if ((PRU_MODE_RX_ONLY == txrxmode)
+		&& (PRU1_MODE == PRU_MODE_RX_ONLY))
+		u32value = 42 + chn_num;
+	else if ((PRU_MODE_TX_ONLY == txrxmode)
+		&& (PRU0_MODE == PRU_MODE_TX_ONLY))
+		u32value = 34 + chn_num;
+	else if ((PRU_MODE_TX_ONLY == txrxmode)
+		&& (PRU1_MODE == PRU_MODE_TX_ONLY))
+		u32value = 42 + chn_num;
+	else
+		return -1;
+
+	if (SUART_TRUE == s32_flag) {
+		u32offset = (u32) (PRUSS_INTC_ENIDXSET & 0xFFFF);
+		s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+		if (s16retval == -1)
+			return -1;
+	} else {
+		u32offset = (u32) (PRUSS_INTC_ENIDXCLR & 0xFFFF);
+		s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
+		if (s16retval == -1)
+			return -1;
+	}
+	return ret_val;
+}
+
+s32 suart_intr_setmask(struct device *dev, u16 uart_num,
+		u32 txrxmode, u32 s32rmask)
+{
+	u32 offset;
+	u32 pru_offset;
+	u32 txrx_flag;
+	u32 regval = 0;
+	u32 chn_num;
+
+	chn_num = uart_num - 1;
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH)
+	    || (PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		/* channel starts from 0 and uart instance starts from 1 */
+		chn_num = (uart_num * SUART_NUM_OF_CHANNELS_PER_SUART) - 2;
+
+		if ((uart_num > 0) && (uart_num <= 4)) {
+			pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+			offset = PRU_SUART_PRU0_IMR_OFFSET;
+		} else if ((uart_num > 4) && (uart_num <= 8)) {
+			offset = PRU_SUART_PRU1_IMR_OFFSET;
+			pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+			chn_num -= 8;
+		} else {
+			return SUART_INVALID_UART_NUM;
+		}
+		if (2 == txrxmode) {	/* rx mode */
+			chn_num++;
+		}
+	} else if (PRU0_MODE == txrxmode) {
+		pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+		offset = PRU_SUART_PRU0_IMR_OFFSET;
+	} else if (PRU1_MODE == txrxmode) {
+		offset = PRU_SUART_PRU1_IMR_OFFSET;
+		pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+	regval = 1 << chn_num;
+	if (CHN_TXRX_IE_MASK_CMPLT == (s32rmask & CHN_TXRX_IE_MASK_CMPLT)) {
+		pruss_readb(dev, offset, (u8 *) &txrx_flag, 2);
+		txrx_flag &= ~(regval);
+		txrx_flag |= regval;
+		pruss_writeb(dev, offset, (u8 *) &txrx_flag, 2);
+	}
+	if ((s32rmask & SUART_GBL_INTR_ERR_MASK) ==
+			SUART_GBL_INTR_ERR_MASK) {
+		regval = 0;
+		pruss_readb(dev, offset, (u8 *) &regval, 2);
+		regval &= ~(SUART_GBL_INTR_ERR_MASK);
+		regval |= (SUART_GBL_INTR_ERR_MASK);
+		pruss_writeb(dev, offset, (u8 *) &regval, 2);
+
+	}
+	/* Break Indicator Interrupt Masked */
+	if ((s32rmask & CHN_TXRX_IE_MASK_FE) == CHN_TXRX_IE_MASK_FE) {
+		regval = 0;
+		offset = pru_offset +
+			(chn_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+			PRU_SUART_CH_CONFIG1_OFFSET;
+		pruss_readb(dev, offset, (u8 *) &regval, 2);
+		regval &= ~(CHN_TXRX_IE_MASK_FE);
+		regval |= CHN_TXRX_IE_MASK_FE;
+		pruss_writeb(dev, offset, (u8 *) &regval, 2);
+	}
+	/* Framing Error Interrupt Masked */
+	if (CHN_TXRX_IE_MASK_BI == (s32rmask & CHN_TXRX_IE_MASK_BI)) {
+		regval = 0;
+		offset = pru_offset +
+			(chn_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+			PRU_SUART_CH_CONFIG1_OFFSET;
+		pruss_readb(dev, offset, (u8 *) &regval, 2);
+		regval &= ~(CHN_TXRX_IE_MASK_BI);
+		regval |= CHN_TXRX_IE_MASK_BI;
+		pruss_writeb(dev, offset, (u8 *) &regval, 2);
+	}
+	/* Timeout error Interrupt Masked */
+	if (CHN_TXRX_IE_MASK_TIMEOUT ==
+			(s32rmask & CHN_TXRX_IE_MASK_TIMEOUT)) {
+		regval = 0;
+		offset = pru_offset +
+			(chn_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+			PRU_SUART_CH_CONFIG1_OFFSET;
+		pruss_readb(dev, offset, (u8 *) &regval, 2);
+		regval &= ~(CHN_TXRX_IE_MASK_TIMEOUT);
+		regval |= CHN_TXRX_IE_MASK_TIMEOUT;
+		pruss_writeb(dev, offset, (u8 *) &regval, 2);
+	}
+	return 0;
+}
+
+s32 suart_intr_clrmask(struct device *dev, u16 uart_num,
+		u32 txrxmode, u32 s32rmask)
+{
+	u32 offset;
+	u32 pru_offset;
+	u16 txrx_flag;
+	u16 regval = 0;
+	u16 chn_num;
+
+	chn_num = uart_num - 1;
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH)
+	    || (PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		/* channel starts from 0 and uart instance starts from 1 */
+		chn_num = (uart_num * SUART_NUM_OF_CHANNELS_PER_SUART) - 2;
+		if ((uart_num > 0) && (uart_num <= 4)) {
+			pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+			offset = PRU_SUART_PRU0_IMR_OFFSET;
+		} else if ((uart_num > 4) && (uart_num <= 8)) {
+			/* PRU1 */
+			offset = PRU_SUART_PRU1_IMR_OFFSET;
+			pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+			/* First 8 channel corresponds to PRU0 */
+			chn_num -= 8;
+		} else {
+			return SUART_INVALID_UART_NUM;
+		}
+		if (2 == txrxmode) {	/* rx mode */
+			chn_num++;
+		}
+	} else if (PRU0_MODE == txrxmode) {
+		pru_offset = PRU_SUART_PRU0_CH0_OFFSET;
+		offset = PRU_SUART_PRU0_IMR_OFFSET;
+	} else if (PRU1_MODE == txrxmode) {
+		offset = PRU_SUART_PRU1_IMR_OFFSET;
+		pru_offset = PRU_SUART_PRU1_CH0_OFFSET;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+	regval = 1 << chn_num;
+	if (CHN_TXRX_IE_MASK_CMPLT == (s32rmask & CHN_TXRX_IE_MASK_CMPLT)) {
+		pruss_readb(dev, offset, (u8 *) &txrx_flag, 2);
+		txrx_flag &= ~(regval);
+		pruss_writeb(dev, offset, (u8 *) &txrx_flag, 2);
+	}
+
+	if ((s32rmask & SUART_GBL_INTR_ERR_MASK) == SUART_GBL_INTR_ERR_MASK) {
+		regval = 0;
+		pruss_readb(dev, offset, (u8 *) &regval, 2);
+		regval &= ~(SUART_GBL_INTR_ERR_MASK);
+		pruss_writeb(dev, offset, (u8 *) &regval, 2);
+
+	}
+	/* Break Indicator Interrupt Masked */
+	if ((s32rmask & CHN_TXRX_IE_MASK_FE) == CHN_TXRX_IE_MASK_FE) {
+		regval = 0;
+		offset = pru_offset +
+			(chn_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+			PRU_SUART_CH_CONFIG1_OFFSET;
+		pruss_readb(dev, offset, (u8 *) &regval, 2);
+		regval &= ~(CHN_TXRX_IE_MASK_FE);
+		pruss_writeb(dev, offset, (u8 *) &regval, 2);
+	}
+	/* Framing Error Interrupt Masked */
+	if (CHN_TXRX_IE_MASK_BI == (s32rmask & CHN_TXRX_IE_MASK_BI)) {
+		regval = 0;
+		offset = pru_offset +
+			(chn_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+			PRU_SUART_CH_CONFIG1_OFFSET;
+		pruss_readb(dev, offset, (u8 *) &regval, 2);
+		regval &= ~(CHN_TXRX_IE_MASK_BI);
+		pruss_writeb(dev, offset, (u8 *) &regval, 2);
+	}
+
+	/* Timeout error Interrupt Masked */
+	if (CHN_TXRX_IE_MASK_TIMEOUT ==
+			(s32rmask & CHN_TXRX_IE_MASK_TIMEOUT)) {
+		regval = 0;
+		offset = pru_offset +
+			(chn_num * SUART_NUM_OF_BYTES_PER_CHANNEL) +
+			PRU_SUART_CH_CONFIG1_OFFSET;
+		pruss_readb(dev, offset, (u8 *) &regval, 2);
+		regval &= ~(CHN_TXRX_IE_MASK_TIMEOUT);
+		pruss_writeb(dev, offset, (u8 *) &regval, 2);
+	}
+	return 0;
+}
+
+s32 suart_intr_getmask(struct device *dev, u16 uart_num, u32 txrxmode,
+			u32 s32rmask)
+{
+	u16 chn_num;
+	u32 offset;
+	u16 txrx_flag;
+	u16 regval = 1;
+
+	chn_num = uart_num - 1;
+	if ((PRU0_MODE == PRU_MODE_RX_TX_BOTH)
+	    || (PRU1_MODE == PRU_MODE_RX_TX_BOTH)) {
+		/* channel starts from 0 and uart instance starts from 1 */
+		chn_num = (uart_num * SUART_NUM_OF_CHANNELS_PER_SUART) - 2;
+
+		if ((uart_num > 0) && (uart_num <= 4)) {
+
+			offset = PRU_SUART_PRU0_IMR_OFFSET;
+		} else if ((uart_num > 4) && (uart_num <= 8)) {
+			/* PRU1 */
+			offset = PRU_SUART_PRU1_IMR_OFFSET;
+			/* First 8 channel corresponds to PRU0 */
+			chn_num -= 8;
+		} else {
+			return SUART_INVALID_UART_NUM;
+		}
+
+		if (2 == txrxmode) {	/* rx mode */
+			chn_num++;
+		}
+	} else if (PRU0_MODE == txrxmode) {
+		offset = PRU_SUART_PRU0_IMR_OFFSET;
+	} else if (PRU1_MODE == txrxmode) {
+		offset = PRU_SUART_PRU1_IMR_OFFSET;
+	} else {
+		return PRU_MODE_INVALID;
+	}
+	regval = regval << chn_num;
+	pruss_readb(dev, offset, (u8 *) &txrx_flag, 2);
+	txrx_flag &= regval;
+	if (0 == s32rmask) {
+		if (txrx_flag == 0)
+			return 1;
+	}
+	if (1 == s32rmask) {
+		if (txrx_flag == regval)
+			return 1;
+	}
+	return 0;
+}
diff --git a/drivers/tty/serial/da8xx_pruss/pruss_suart_api.h b/drivers/tty/serial/da8xx_pruss/pruss_suart_api.h
new file mode 100644
index 0000000..4ce5621
--- /dev/null
+++ b/drivers/tty/serial/da8xx_pruss/pruss_suart_api.h
@@ -0,0 +1,345 @@
+/*
+ * Copyright (C) 2010 Texas Instruments Incorporated
+ * Author: Jitendra Kumar <jitendra@mistralsolutions.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as  published by the
+ * Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef _SUART_API_H_
+#define _SUART_API_H_
+
+#include <linux/types.h>
+#include <linux/bitops.h>
+#include <linux/mfd/pruss/da8xx_pru.h>
+
+#define SINGLE_PRU				0
+#define BOTH_PRU				1
+#define PRU_ACTIVE				BOTH_PRU
+
+#define SUART_NUM_OF_CHANNELS_PER_SUART		2
+#define SUART_NUM_OF_BYTES_PER_CHANNEL		16
+
+#define SUART_PASS				0
+#define SUART_SUCCESS				0
+#define SUART_FAIL				1
+#define SUART_FALSE				0
+#define SUART_TRUE				1
+
+#define PRU_TX_INTR				1
+#define PRU_RX_INTR				2
+
+#define CHN_TXRX_STATUS_TIMEOUT			BIT(6)
+#define CHN_TXRX_STATUS_BI			BIT(5)
+#define CHN_TXRX_STATUS_FE			BIT(4)
+#define CHN_TXRX_STATUS_UNERR			BIT(3)
+#define CHN_TXRX_STATUS_OVRNERR			BIT(3)
+#define CHN_TXRX_STATUS_ERR			BIT(2)
+#define CHN_TXRX_STATUS_CMPLT			BIT(1)
+#define CHN_TXRX_STATUS_RDY			BIT(0)
+
+#define CHN_TXRX_IE_MASK_TIMEOUT		BIT(14)
+#define CHN_TXRX_IE_MASK_BI			BIT(13)
+#define CHN_TXRX_IE_MASK_FE			BIT(12)
+#define CHN_TXRX_IE_MASK_CMPLT			BIT(1)
+
+#define SUART_GBL_INTR_ERR_MASK			BIT(9)
+#define SUART_PRU_ID_MASK			0xFF
+
+#define SUART_FIFO_LEN				15
+#define SUART_8X_OVRSMPL			1
+#define SUART_16X_OVRSMPL			2
+#define SUART_DEFAULT_OVRSMPL			SUART_8X_OVRSMPL
+
+#if (SUART_DEFAULT_OVRSMPL == SUART_16X_OVRSMPL)
+#define SUART_DEFAULT_BAUD			57600
+#else
+#define SUART_DEFAULT_BAUD			115200
+#endif
+
+#define PRU_MODE_INVALID			0x00
+#define PRU_MODE_TX_ONLY			0x1
+#define PRU_MODE_RX_ONLY			0x2
+#define PRU_MODE_RX_TX_BOTH			0x3
+
+#if (PRU_ACTIVE == BOTH_PRU)
+#define PRU0_MODE				PRU_MODE_RX_ONLY
+#define PRU1_MODE				PRU_MODE_TX_ONLY
+#elif (PRU_ACTIVE ==  SINGLE_PRU)
+#define PRU0_MODE				PRU_MODE_RX_TX_BOTH
+#define PRU1_MODE				PRU_MODE_INVALID
+#else
+#define PRU0_MODE				PRU_MODE_INVALID
+#define PRU1_MODE				PRU_MODE_INVALID
+#endif
+
+#define MCASP_XBUF_BASE_ADDR			(0x01d00200)
+#define MCASP_RBUF_BASE_ADDR			(0x01d00280)
+#define MCASP_SRCTL_BASE_ADDR			(0x01d00180)
+
+#define MCASP_SRCTL_TX_MODE			(0x000D)
+#define MCASP_SRCTL_RX_MODE			(0x000E)
+
+/* Since only PRU0 can work as RX */
+#define RX_DEFAULT_DATA_DUMP_ADDR		(0x00001FC)
+#define PRU_NUM_OF_CHANNELS			(16)
+
+#define	PRU_SUART_UART1		(1u)
+#define	PRU_SUART_UART2		(2u)
+#define	PRU_SUART_UART3		(3u)
+#define	PRU_SUART_UART4		(4u)
+#define	PRU_SUART_UART5		(5u)
+#define	PRU_SUART_UART6		(6u)
+#define	PRU_SUART_UART7		(7u)
+#define PRU_SUART_UART8		(8u)
+
+#define PRU_SUART_UARTx_INVALID	(9u)
+
+#define PRU_SUART_HALF_TX	(1u)
+#define PRU_SUART_HALF_RX			(2u)
+#define PRU_SUART_HALF_TX_DISABLED		(4u)
+#define PRU_SUART_HALF_RX_DISABLED		(8u)
+
+
+/*
+ *  This enum is used to specify the direction of the channel in UART
+ */
+typedef enum {
+	SUART_CHN_TX = 1,
+	SUART_CHN_RX = 2
+} SUART_CHN_DIR;
+
+/*
+ *  This enum is used to specify the state of the channel in UART. It
+ *  is either enabled or disabled.
+ */
+typedef enum {
+	SUART_CHN_DISABLED = 0,
+	SUART_CHN_ENABLED = 1
+} SUART_CHN_STATE;
+
+typedef enum {
+	ePRU_SUART_DATA_BITS6 = 8,
+	ePRU_SUART_DATA_BITS7,
+	ePRU_SUART_DATA_BITS8,
+	ePRU_SUART_DATA_BITS9,
+	ePRU_SUART_DATA_BITS10,
+	ePRU_SUART_DATA_BITS11,
+	ePRU_SUART_DATA_BITS12
+	} SUART_EN_BITSPERCHAR;
+
+typedef enum {
+	ePRU_SUART_NUM_1 = 1,
+	ePRU_SUART_NUM_2,
+	ePRU_SUART_NUM_3,
+	ePRU_SUART_NUM_4,
+	ePRU_SUART_NUM_5,
+	ePRU_SUART_NUM_6,
+	ePRU_SUART_NUM_7,
+	ePRU_SUART_NUM_8
+} SUART_EN_UARTNUM;
+
+typedef enum {
+	ePRU_SUART_HALF_TX = 1,
+	ePRU_SUART_HALF_RX,
+	ePRU_SUART_FULL_TX_RX
+} SUART_EN_UARTTYPE;
+
+typedef enum {
+	ePRU_SUART_TX_CH0 = 0,
+	ePRU_SUART_TX_CH1,
+	ePRU_SUART_TX_CH2,
+	ePRU_SUART_TX_CH3,
+	ePRU_SUART_TX_CH4,
+	ePRU_SUART_TX_CH5,
+	ePRU_SUART_TX_CH6,
+	ePRU_SUART_TX_CH7
+} SUART_EN_TXCHANNEL;
+
+typedef enum {
+	ePRU_SUART_RX_CH0 = 0,
+	ePRU_SUART_RX_CH1,
+	ePRU_SUART_RX_CH2,
+	ePRU_SUART_RX_CH3,
+	ePRU_SUART_RX_CH4,
+	ePRU_SUART_RX_CH5,
+	ePRU_SUART_RX_CH6,
+	ePRU_SUART_RX_CH7
+} SUART_EN_RXCHANNEL;
+
+typedef enum {
+	ePRU_SUART_UART_FREE = 0,
+	ePRU_SUART_UART_IN_USE
+} SUART_EN_UART_STATUS;
+
+typedef struct {
+	u16 mode:2;
+	u16 service_req:1;
+	u16 asp_id:2;
+	u16 reserved1:3;
+	u16 serializer_num:4;
+	u16 reserved2:4;
+
+} pru_suart_chn_cntrl;
+
+typedef struct {
+	u16 presacler:10;
+	u16 over_sampling:2;
+	u16 framing_mask:1;
+	u16 break_mask:1;
+	u16 timeout_mask:1;
+	u16 reserved:1;
+} pru_suart_cnh_config1;
+
+typedef struct {
+	u16 bits_per_char:4;
+	u16 reserved1:4;
+	u16 data_len:4;
+	u16 reserved:4;
+} pru_suart_chn_config2;
+
+typedef struct {
+	u16 txrx_ready:1;
+	u16 txrx_complete:1;
+	u16 txrx_error:1;
+	u16 txrx_underrun:1;
+	u16 framing_error:1;
+	u16 break_error:1;
+	u16 timeout_error:1;
+	u16 reserved:8;
+	u16 chn_state:1;
+} pru_suart_chn_status;
+
+typedef struct {
+	pru_suart_chn_cntrl ch_ctrl;
+	pru_suart_cnh_config1 ch_config1;
+	pru_suart_chn_config2 ch_config2;
+	pru_suart_chn_status ch_txrx_status;
+	u32 ch_txrx_data;
+	u32 reserved1;
+} pru_suart_regs, *pru_suart_regs_ovly;
+
+typedef struct {
+	u32 asp_xsrctl_base;
+	u32 asp_xbuf_base;
+	u16 buff_addr;
+	u8 buff_size;
+	u8 bits_loaded;
+} pru_suart_tx_cntx_priv, *ppru_suart_tx_cntx_priv;
+
+typedef struct {
+	u32 asp_rbuf_base;
+	u32 asp_rsrctl_base;
+	u32 reserved1;
+	u32 reserved2;
+	u32 reserved3;
+	u32 reserved4;
+} pru_suart_rx_cntx_priv, *ppru_suart_rx_cntx_priv;
+
+typedef struct {
+	u8  tx_serializer;
+	u8  rx_serializer;
+	u16 tx_clk_divisor;
+	u16 rx_clk_divisor;
+	u8  tx_bits_per_char;
+	u8  rx_bits_per_char;
+	u8  oversampling;
+	u8  bi_inter_mask;
+	u8  fe_intr_mask;
+} suart_config;
+
+typedef struct {
+	u16 uart_num;
+	u16 uart_type;
+	u16 uart_tx_channel;
+	u16 uart_rx_channel;
+	u16 uart_status;
+} suart_struct_handle, *suart_handle;
+
+typedef struct {
+	void *mcasp_io_addr;
+	void *p_fifo_buff_phys_base;
+	void *p_fifo_buff_virt_base;
+	u32  pru_clk_freq;
+} pruss_suart_iomap;
+
+s16 pru_softuart_init(struct device *dev, u32 tx_baud_value,
+			u32 rx_baud_value, u32 oversampling,
+			u8 *pru_suart_emu_code, u32 fw_size,
+			pruss_suart_iomap *pruss_ioaddr);
+
+s16 pru_softuart_open(suart_handle h_suart);
+
+s16 pru_softuart_close(suart_handle h_uart);
+
+s16 pru_softuart_setbaud(struct device *dev, suart_handle h_uart,
+			u16 tx_clk_divisor, u16 rx_clk_divisor);
+
+s16 pru_softuart_setdatabits(struct device *dev, suart_handle h_uart,
+			u16 tx_data_bits, u16 rx_data_bits);
+
+s16 pru_softuart_setconfig(struct device *dev, suart_handle h_uart,
+			suart_config *config_uart);
+
+s16 pru_softuart_getconfig(struct device *dev, suart_handle h_uart,
+			suart_config *config_uart);
+
+s32 pru_softuart_pending_tx_request(struct device *dev);
+
+s16 pru_softuart_write(struct device *dev, suart_handle h_uart,
+			u32 *pt_tx_data_buf, u16 data_len);
+
+s16 pru_softuart_read(struct device *dev, suart_handle h_uart,
+			u32 *pt_data_buf, u16 data_len);
+
+s32 suart_intr_clrmask(struct device *dev, u16 uart_num, u32 txrxmode,
+			u32 intrmask);
+
+s16 pru_softuart_clr_tx_status(struct device *dev, suart_handle h_uart);
+
+s16 pru_softuart_get_tx_status(struct device *dev, suart_handle h_uart);
+
+s16 pru_softuart_clr_rx_status(struct device *dev, suart_handle h_uart);
+
+s16 pru_softuart_get_rx_status(struct device *dev, suart_handle h_uart);
+
+s16 pru_softuart_get_isrstatus(struct device *dev, u16 uart_num,
+			u16 *txrx_flag);
+
+s32 pru_intr_clr_isrstatus(struct device *dev, u16 uart_num, u32 txrxmode);
+
+s32 suart_intr_getmask(struct device *dev, u16 uart_num, u32 txrxmode,
+			u32 intrmask);
+
+s32 suart_intr_setmask(struct device *dev, u16 uart_num,
+			u32 txrxmode, u32 intrmask);
+
+s16 pru_softuart_get_tx_data_len(struct device *dev, suart_handle h_uart);
+
+s16 pru_softuart_get_rx_data_len(struct device *dev, suart_handle h_uart);
+
+s16 suart_arm_to_pru_intr(struct device *dev, u16 uart_num);
+
+s16 arm_to_pru_intr_init(struct device *dev);
+
+s16 pru_softuart_deinit(struct device *dev);
+
+s16 pru_softuart_clr_rx_fifo(struct device *dev, suart_handle h_uart);
+
+s16 pru_softuart_read_data(struct device *dev, suart_handle h_uart,
+			u8 *p_data_buffer, s32 s32_max_len,
+			u32 *pu32data_read);
+
+s16 pru_softuart_stop_receive(struct device *dev, suart_handle h_uart);
+
+s32 suart_pru_to_host_intr_enable(struct device *dev, u16 uart_num,
+			u32 txrxmode, s32 s32flag);
+
+void pru_set_fifo_timeout(struct device *dev, s16 timeout);
+#endif
diff --git a/drivers/tty/serial/da8xx_pruss/pruss_suart_board.h b/drivers/tty/serial/da8xx_pruss/pruss_suart_board.h
new file mode 100644
index 0000000..58cc9e4
--- /dev/null
+++ b/drivers/tty/serial/da8xx_pruss/pruss_suart_board.h
@@ -0,0 +1,58 @@
+/*
+ * Copyright (C) 2010 Texas Instruments Incorporated
+ * Author: subhasish@mistralsolutions.com
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as  published by the
+ * Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef _OMAPL_SUART_BOARD_H_
+#define _OMAPL_SUART_BOARD_H_
+
+#define PRU_SUART0_CONFIG_DUPLEX	(PRU_SUART_HALF_TX_DISABLED | \
+					PRU_SUART_HALF_RX_DISABLED)
+#define PRU_SUART0_CONFIG_RX_SER	(PRU_SUART_SERIALIZER_NONE)
+#define PRU_SUART0_CONFIG_TX_SER	(PRU_SUART_SERIALIZER_NONE)
+
+#define PRU_SUART1_CONFIG_DUPLEX	(PRU_SUART_HALF_TX | \
+					PRU_SUART_HALF_RX)
+#define PRU_SUART1_CONFIG_RX_SER	(PRU_SUART_SERIALIZER_7)
+#define PRU_SUART1_CONFIG_TX_SER	(PRU_SUART_SERIALIZER_8)
+
+#define PRU_SUART2_CONFIG_DUPLEX	(PRU_SUART_HALF_TX | \
+					PRU_SUART_HALF_RX)
+#define PRU_SUART2_CONFIG_RX_SER	(PRU_SUART_SERIALIZER_9)
+#define PRU_SUART2_CONFIG_TX_SER	(PRU_SUART_SERIALIZER_10)
+
+#define PRU_SUART3_CONFIG_DUPLEX	(PRU_SUART_HALF_TX_DISABLED | \
+					PRU_SUART_HALF_RX_DISABLED)
+#define PRU_SUART3_CONFIG_RX_SER	(PRU_SUART_SERIALIZER_NONE)
+#define PRU_SUART3_CONFIG_TX_SER	(PRU_SUART_SERIALIZER_NONE)
+
+#define PRU_SUART4_CONFIG_DUPLEX	(PRU_SUART_HALF_TX_DISABLED | \
+					PRU_SUART_HALF_RX_DISABLED)
+#define PRU_SUART4_CONFIG_RX_SER	(PRU_SUART_SERIALIZER_NONE)
+#define PRU_SUART4_CONFIG_TX_SER	(PRU_SUART_SERIALIZER_NONE)
+
+#define PRU_SUART5_CONFIG_DUPLEX	(PRU_SUART_HALF_TX_DISABLED | \
+					PRU_SUART_HALF_RX_DISABLED)
+#define PRU_SUART5_CONFIG_RX_SER	(PRU_SUART_SERIALIZER_NONE)
+#define PRU_SUART5_CONFIG_TX_SER	(PRU_SUART_SERIALIZER_NONE)
+
+#define PRU_SUART6_CONFIG_DUPLEX	(PRU_SUART_HALF_TX_DISABLED | \
+					PRU_SUART_HALF_RX_DISABLED)
+#define PRU_SUART6_CONFIG_RX_SER	(PRU_SUART_SERIALIZER_NONE)
+#define PRU_SUART6_CONFIG_TX_SER	(PRU_SUART_SERIALIZER_NONE)
+
+#define PRU_SUART7_CONFIG_DUPLEX	(PRU_SUART_HALF_TX_DISABLED | \
+					PRU_SUART_HALF_RX_DISABLED)
+#define PRU_SUART7_CONFIG_RX_SER	(PRU_SUART_SERIALIZER_NONE)
+#define PRU_SUART7_CONFIG_TX_SER	(PRU_SUART_SERIALIZER_NONE)
+
+#endif				/* End of _OMAPL_SUART_BOARD_H_ */
diff --git a/drivers/tty/serial/da8xx_pruss/pruss_suart_err.h b/drivers/tty/serial/da8xx_pruss/pruss_suart_err.h
new file mode 100644
index 0000000..dd94f4e
--- /dev/null
+++ b/drivers/tty/serial/da8xx_pruss/pruss_suart_err.h
@@ -0,0 +1,48 @@
+/*
+ * Copyright (C) 2010 Texas Instruments Incorporated
+ * Author: jitendra@mistralsolutions.com
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as  published by the
+ * Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef _SUART_ERR_H_
+#define _SUART_ERR_H_
+
+#define PRU_SUART_SUCCESS	(0u)
+#define PRU_SUART_FAILURE	(-1)
+
+#define PRU_SUART_ERR_DEVICE_NOT_OPEN	(1u)
+#define PRU_SUART_ERR_UARTS_INIT_FAIL	(2u)
+#define PRU_SUART_ERR_UARTS_RESET_FAIL	(3u)
+#define PRU_SUART_ERR_HANDLE_INVALID	(4u)
+#define PRU_SUART_ERR_PARAMETER_INVALID	(5u)
+
+#define PRU_SUART_ERR_TX		(6u)
+#define PRU_SUART_TX_COMPLETE		(7u)
+#define PRU_SUART_TX_BUSY		(8u)
+#define PRU_SUART_TX_UNDERRUN		(9u)
+
+#define PRU_SUART_ERR_RX		(10u)
+#define PRU_SUART_RX_COMPLETE		(11u)
+#define PRU_SUART_RX_BUSY		(12u)
+#define PRU_SUART_RX_OVERRUN		(13u)
+
+/* API Specific Errors */
+#define SUART_INVALID_TX_BAUD		(14u)
+#define SUART_INVALID_OVERSAMPLING	(15u)
+#define SUART_INVALID_RX_BAUD		(16u)
+
+#define SUART_UART_IN_USE		(17u)
+
+#define SUART_INVALID_CLKDIVISOR	(18u)
+#define SUART_INVALID_UART_NUM		(19u)
+#define SUART_INVALID_SR_NUM		(20u)
+
+#endif
diff --git a/drivers/tty/serial/da8xx_pruss/pruss_suart_mcasp.h b/drivers/tty/serial/da8xx_pruss/pruss_suart_mcasp.h
new file mode 100644
index 0000000..fa99c6b
--- /dev/null
+++ b/drivers/tty/serial/da8xx_pruss/pruss_suart_mcasp.h
@@ -0,0 +1,526 @@
+/*
+ * Copyright (C) 2010 Texas Instruments Incorporated
+ * Author: Jitendra Kumar <jitendra@mistralsolutions.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as  published by the
+ * Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef _OMAPLR_MCASP_H_
+#define _OMAPLR_MCASP_H_
+
+#include <linux/types.h>
+#include <linux/io.h>
+#include <linux/mfd/pruss/da8xx_pru.h>
+
+typedef struct {
+	u32 REVID;
+	u32 RSVD0[3];
+	u32 PFUNC;
+	u32 PDIR;
+	u32 PDOUT;
+	u32 PDIN;
+	u32 PDCLR;
+	u32 RSVD1[8];
+	u32 GBLCTL;
+	u32 AMUTE;
+	u32 DLBCTL;
+	u32 DITCTL;
+	u32 RSVD2[3];
+	u32 RGBLCTL;
+	u32 RMASK;
+	u32 RFMT;
+	u32 AFSRCTL;
+	u32 ACLKRCTL;
+	u32 AHCLKRCTL;
+	u32 RTDM;
+	u32 RINTCTL;
+	u32 RSTAT;
+	u32 RSLOT;
+	u32 RCLKCHK;
+	u32 REVTCTL;
+	u32 RSVD3[4];
+	u32 XGBLCTL;
+	u32 XMASK;
+	u32 XFMT;
+	u32 AFSXCTL;
+	u32 ACLKXCTL;
+	u32 AHCLKXCTL;
+	u32 XTDM;
+	u32 XINTCTL;
+	u32 XSTAT;
+	u32 XSLOT;
+	u32 XCLKCHK;
+	u32 XEVTCTL;
+	u32 RSVD4[12];
+	u32 DITCSRA0;
+	u32 DITCSRA1;
+	u32 DITCSRA2;
+	u32 DITCSRA3;
+	u32 DITCSRA4;
+	u32 DITCSRA5;
+	u32 DITCSRB0;
+	u32 DITCSRB1;
+	u32 DITCSRB2;
+	u32 DITCSRB3;
+	u32 DITCSRB4;
+	u32 DITCSRB5;
+	u32 DITUDRA0;
+	u32 DITUDRA1;
+	u32 DITUDRA2;
+	u32 DITUDRA3;
+	u32 DITUDRA4;
+	u32 DITUDRA5;
+	u32 DITUDRB0;
+	u32 DITUDRB1;
+	u32 DITUDRB2;
+	u32 DITUDRB3;
+	u32 DITUDRB4;
+	u32 DITUDRB5;
+	u32 RSVD5[8];
+	u32 SRCTL0;
+	u32 SRCTL1;
+	u32 SRCTL2;
+	u32 SRCTL3;
+	u32 SRCTL4;
+	u32 SRCTL5;
+	u32 SRCTL6;
+	u32 SRCTL7;
+	u32 SRCTL8;
+	u32 SRCTL9;
+	u32 SRCTL10;
+	u32 SRCTL11;
+	u32 SRCTL12;
+	u32 SRCTL13;
+	u32 SRCTL14;
+	u32 SRCTL15;
+	u32 RSVD6[16];
+	u32 XBUF0;
+	u32 XBUF1;
+	u32 XBUF2;
+	u32 XBUF3;
+	u32 XBUF4;
+	u32 XBUF5;
+	u32 XBUF6;
+	u32 XBUF7;
+	u32 XBUF8;
+	u32 XBUF9;
+	u32 XBUF10;
+	u32 XBUF11;
+	u32 XBUF12;
+	u32 XBUF13;
+	u32 XBUF14;
+	u32 XBUF15;
+	u32 RSVD7[16];
+	u32 RBUF0;
+	u32 RBUF1;
+	u32 RBUF2;
+	u32 RBUF3;
+	u32 RBUF4;
+	u32 RBUF5;
+	u32 RBUF6;
+	u32 RBUF7;
+	u32 RBUF8;
+	u32 RBUF9;
+	u32 RBUF10;
+	u32 RBUF11;
+	u32 RBUF12;
+	u32 RBUF13;
+	u32 RBUF14;
+	u32 RBUF15;
+} omapl_mcasp_regs, *omapl_mcasp_regs_ovly;
+
+
+#define OMAPL_MCASP_PFUNC_AFSR_MASK			(0x80000000u)
+#define OMAPL_MCASP_PFUNC_AFSR_SHIFT			(0x0000001Fu)
+#define OMAPL_MCASP_PFUNC_AFSR_RESETVAL			(0x00000000u)
+/* AFSR Tokens */
+#define OMAPL_MCASP_PFUNC_AFSR_MCASP			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AFSR_GPIO			(0x00000001u)
+
+#define OMAPL_MCASP_PFUNC_AHCLKR_MASK			(0x40000000u)
+#define OMAPL_MCASP_PFUNC_AHCLKR_SHIFT			(0x0000001Eu)
+#define OMAPL_MCASP_PFUNC_AHCLKR_RESETVAL		(0x00000000u)
+/* AHCLKR Tokens */
+#define OMAPL_MCASP_PFUNC_AHCLKR_MCASP			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AHCLKR_GPIO			(0x00000001u)
+
+#define OMAPL_MCASP_PFUNC_ACLKR_MASK			(0x20000000u)
+#define OMAPL_MCASP_PFUNC_ACLKR_SHIFT			(0x0000001Du)
+#define OMAPL_MCASP_PFUNC_ACLKR_RESETVAL		(0x00000000u)
+/* ACLKR Tokens */
+#define OMAPL_MCASP_PFUNC_ACLKR_MCASP			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_ACLKR_GPIO			(0x00000001u)
+
+#define OMAPL_MCASP_PFUNC_AFSX_MASK			(0x10000000u)
+#define OMAPL_MCASP_PFUNC_AFSX_SHIFT			(0x0000001Cu)
+#define OMAPL_MCASP_PFUNC_AFSX_RESETVAL			(0x00000000u)
+/* AFSX Tokens */
+#define OMAPL_MCASP_PFUNC_AFSX_MCASP			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AFSX_GPIO			(0x00000001u)
+
+#define OMAPL_MCASP_PFUNC_AHCLKX_MASK			(0x08000000u)
+#define OMAPL_MCASP_PFUNC_AHCLKX_SHIFT			(0x0000001Bu)
+#define OMAPL_MCASP_PFUNC_AHCLKX_RESETVAL		(0x00000000u)
+/* AHCLKX Tokens */
+#define OMAPL_MCASP_PFUNC_AHCLKX_MCASP			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AHCLKX_GPIO			(0x00000001u)
+
+#define OMAPL_MCASP_PFUNC_ACLKX_MASK			(0x04000000u)
+#define OMAPL_MCASP_PFUNC_ACLKX_SHIFT			(0x0000001Au)
+#define OMAPL_MCASP_PFUNC_ACLKX_RESETVAL		(0x00000000u)
+/* ACLKX Tokens */
+#define OMAPL_MCASP_PFUNC_ACLKX_MCASP			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_ACLKX_GPIO			(0x00000001u)
+
+#define OMAPL_MCASP_PFUNC_AMUTE_MASK			(0x02000000u)
+#define OMAPL_MCASP_PFUNC_AMUTE_SHIFT			(0x00000019u)
+#define OMAPL_MCASP_PFUNC_AMUTE_RESETVAL		(0x00000000u)
+/* AMUTE Tokens */
+#define OMAPL_MCASP_PFUNC_AMUTE_MCASP			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AMUTE_GPIO			(0x00000001u)
+
+#define OMAPL_MCASP_PFUNC_AXR15_MASK			(0x00008000u)
+#define OMAPL_MCASP_PFUNC_AXR15_SHIFT			(0x0000000Fu)
+#define OMAPL_MCASP_PFUNC_AXR15_RESETVAL		(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AXR15_MCASP			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AXR15_GPIO			(0x00000001u)
+
+#define OMAPL_MCASP_PFUNC_AXR14_MASK			(0x00004000u)
+#define OMAPL_MCASP_PFUNC_AXR14_SHIFT			(0x0000000Eu)
+#define OMAPL_MCASP_PFUNC_AXR14_RESETVAL		(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AXR14_MCASP			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AXR14_GPIO			(0x00000001u)
+
+#define OMAPL_MCASP_PFUNC_AXR13_MASK			(0x00002000u)
+#define OMAPL_MCASP_PFUNC_AXR13_SHIFT			(0x0000000Du)
+#define OMAPL_MCASP_PFUNC_AXR13_RESETVAL		(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AXR13_MCASP			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AXR13_GPIO			(0x00000001u)
+
+#define OMAPL_MCASP_PFUNC_AXR12_MASK			(0x00001000u)
+#define OMAPL_MCASP_PFUNC_AXR12_SHIFT			(0x0000000Cu)
+#define OMAPL_MCASP_PFUNC_AXR12_RESETVAL		(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AXR12_MCASP			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AXR12_GPIO			(0x00000001u)
+
+#define OMAPL_MCASP_PFUNC_AXR11_MASK			(0x00000800u)
+#define OMAPL_MCASP_PFUNC_AXR11_SHIFT			(0x0000000Bu)
+#define OMAPL_MCASP_PFUNC_AXR11_RESETVAL		(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AXR11_MCASP			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AXR11_GPIO			(0x00000001u)
+
+#define OMAPL_MCASP_PFUNC_AXR10_MASK			(0x00000400u)
+#define OMAPL_MCASP_PFUNC_AXR10_SHIFT			(0x0000000Au)
+#define OMAPL_MCASP_PFUNC_AXR10_RESETVAL		(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AXR10_MCASP			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AXR10_GPIO			(0x00000001u)
+#define OMAPL_MCASP_PFUNC_AXR9_MASK			(0x00000200u)
+#define OMAPL_MCASP_PFUNC_AXR9_SHIFT			(0x00000009u)
+#define OMAPL_MCASP_PFUNC_AXR9_RESETVAL			(0x00000000u)
+/* AXR9 Token */
+#define OMAPL_MCASP_PFUNC_AXR9_MCASP			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AXR9_GPIO			(0x00000001u)
+
+#define OMAPL_MCASP_PFUNC_AXR8_MASK			(0x00000100u)
+#define OMAPL_MCASP_PFUNC_AXR8_SHIFT			(0x00000008u)
+#define OMAPL_MCASP_PFUNC_AXR8_RESETVAL			(0x00000000u)
+/* AXR8 Tokens */
+#define OMAPL_MCASP_PFUNC_AXR8_MCASP			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AXR8_GPIO			(0x00000001u)
+
+#define OMAPL_MCASP_PFUNC_AXR7_MASK			(0x00000080u)
+#define OMAPL_MCASP_PFUNC_AXR7_SHIFT			(0x00000007u)
+#define OMAPL_MCASP_PFUNC_AXR7_RESETVAL			(0x00000000u)
+/* AXR7 Tokens */
+#define OMAPL_MCASP_PFUNC_AXR7_MCASP			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AXR7_GPIO			(0x00000001u)
+
+#define OMAPL_MCASP_PFUNC_AXR6_MASK			(0x00000040u)
+#define OMAPL_MCASP_PFUNC_AXR6_SHIFT			(0x00000006u)
+#define OMAPL_MCASP_PFUNC_AXR6_RESETVAL			(0x00000000u)
+/* AXR6 Tokens */
+#define OMAPL_MCASP_PFUNC_AXR6_MCASP			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AXR6_GPIO			(0x00000001u)
+
+#define OMAPL_MCASP_PFUNC_AXR5_MASK			(0x00000020u)
+#define OMAPL_MCASP_PFUNC_AXR5_SHIFT			(0x00000005u)
+#define OMAPL_MCASP_PFUNC_AXR5_RESETVAL			(0x00000000u)
+/* AXR5 Tokens */
+#define OMAPL_MCASP_PFUNC_AXR5_MCASP			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AXR5_GPIO			(0x00000001u)
+
+#define OMAPL_MCASP_PFUNC_AXR4_MASK			(0x00000010u)
+#define OMAPL_MCASP_PFUNC_AXR4_SHIFT			(0x00000004u)
+#define OMAPL_MCASP_PFUNC_AXR4_RESETVAL			(0x00000000u)
+/* AXR4 Tokens */
+#define OMAPL_MCASP_PFUNC_AXR4_MCASP			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AXR4_GPIO			(0x00000001u)
+
+#define OMAPL_MCASP_PFUNC_AXR3_MASK			(0x00000008u)
+#define OMAPL_MCASP_PFUNC_AXR3_SHIFT			(0x00000003u)
+#define OMAPL_MCASP_PFUNC_AXR3_RESETVAL			(0x00000000u)
+/* AXR3 Tokens */
+#define OMAPL_MCASP_PFUNC_AXR3_MCASP			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AXR3_GPIO			(0x00000001u)
+
+#define OMAPL_MCASP_PFUNC_AXR2_MASK			(0x00000004u)
+#define OMAPL_MCASP_PFUNC_AXR2_SHIFT			(0x00000002u)
+#define OMAPL_MCASP_PFUNC_AXR2_RESETVAL			(0x00000000u)
+/* AXR2 Tokens */
+#define OMAPL_MCASP_PFUNC_AXR2_MCASP			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AXR2_GPIO			(0x00000001u)
+
+#define OMAPL_MCASP_PFUNC_AXR1_MASK			(0x00000002u)
+#define OMAPL_MCASP_PFUNC_AXR1_SHIFT			(0x00000001u)
+#define OMAPL_MCASP_PFUNC_AXR1_RESETVAL			(0x00000000u)
+/* AXR1 Tokens */
+#define OMAPL_MCASP_PFUNC_AXR1_MCASP			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AXR1_GPIO			(0x00000001u)
+
+#define OMAPL_MCASP_PFUNC_AXR0_MASK			(0x00000001u)
+#define OMAPL_MCASP_PFUNC_AXR0_SHIFT			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AXR0_RESETVAL			(0x00000000u)
+/* AXR0 Tokens */
+#define OMAPL_MCASP_PFUNC_AXR0_MCASP			(0x00000000u)
+#define OMAPL_MCASP_PFUNC_AXR0_GPIO			(0x00000001u)
+#define OMAPL_MCASP_PFUNC_RESETVAL			(0x00000000u)
+
+#define OMAPL_MCASP_PDIR_AFSR_MASK			(0x80000000u)
+#define OMAPL_MCASP_PDIR_AFSR_SHIFT			(0x0000001Fu)
+#define OMAPL_MCASP_PDIR_AFSR_RESETVAL			(0x00000000u)
+/* AFSR Tokens */
+#define OMAPL_MCASP_PDIR_AFSR_INPUT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AFSR_OUTPUT			(0x00000001u)
+
+#define OMAPL_MCASP_PDIR_AHCLKR_MASK			(0x40000000u)
+#define OMAPL_MCASP_PDIR_AHCLKR_SHIFT			(0x0000001Eu)
+#define OMAPL_MCASP_PDIR_AHCLKR_RESETVAL		(0x00000000u)
+/* AHCLKR Tokens */
+#define OMAPL_MCASP_PDIR_AHCLKR_INPUT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AHCLKR_OUTPUT			(0x00000001u)
+
+#define OMAPL_MCASP_PDIR_ACLKR_MASK			(0x20000000u)
+#define OMAPL_MCASP_PDIR_ACLKR_SHIFT			(0x0000001Du)
+#define OMAPL_MCASP_PDIR_ACLKR_RESETVAL			(0x00000000u)
+/* ACLKR Tokens */
+#define OMAPL_MCASP_PDIR_ACLKR_INPUT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_ACLKR_OUTPUT			(0x00000001u)
+
+#define OMAPL_MCASP_PDIR_AFSX_MASK			(0x10000000u)
+#define OMAPL_MCASP_PDIR_AFSX_SHIFT			(0x0000001Cu)
+#define OMAPL_MCASP_PDIR_AFSX_RESETVAL			(0x00000000u)
+/* AFSX Tokens */
+#define OMAPL_MCASP_PDIR_AFSX_INPUT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AFSX_OUTPUT			(0x00000001u)
+
+#define OMAPL_MCASP_PDIR_AHCLKX_MASK			(0x08000000u)
+#define OMAPL_MCASP_PDIR_AHCLKX_SHIFT			(0x0000001Bu)
+#define OMAPL_MCASP_PDIR_AHCLKX_RESETVAL		(0x00000000u)
+/* AHCLKX Tokens */
+#define OMAPL_MCASP_PDIR_AHCLKX_INPUT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AHCLKX_OUTPUT			(0x00000001u)
+
+#define OMAPL_MCASP_PDIR_ACLKX_MASK			(0x04000000u)
+#define OMAPL_MCASP_PDIR_ACLKX_SHIFT			(0x0000001Au)
+#define OMAPL_MCASP_PDIR_ACLKX_RESETVAL			(0x00000000u)
+/* ACLKX Tokens */
+#define OMAPL_MCASP_PDIR_ACLKX_INPUT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_ACLKX_OUTPUT			(0x00000001u)
+
+#define OMAPL_MCASP_PDIR_AMUTE_MASK			(0x02000000u)
+#define OMAPL_MCASP_PDIR_AMUTE_SHIFT			(0x00000019u)
+#define OMAPL_MCASP_PDIR_AMUTE_RESETVAL			(0x00000000u)
+/* AMUTE Tokens */
+#define OMAPL_MCASP_PDIR_AMUTE_INPUT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AMUTE_OUTPUT			(0x00000001u)
+
+#define OMAPL_MCASP_PDIR_AXR15_MASK			(0x00008000u)
+#define OMAPL_MCASP_PDIR_AXR15_SHIFT			(0x0000000Fu)
+#define OMAPL_MCASP_PDIR_AXR15_RESETVAL			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AXR15_INPUT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AXR15_OUTPUT			(0x00000001u)
+
+#define OMAPL_MCASP_PDIR_AXR14_MASK			(0x00004000u)
+#define OMAPL_MCASP_PDIR_AXR14_SHIFT			(0x0000000Eu)
+#define OMAPL_MCASP_PDIR_AXR14_RESETVAL			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AXR14_INPUT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AXR14_OUTPUT			(0x00000001u)
+
+#define OMAPL_MCASP_PDIR_AXR13_MASK			(0x00002000u)
+#define OMAPL_MCASP_PDIR_AXR13_SHIFT			(0x0000000Du)
+#define OMAPL_MCASP_PDIR_AXR13_RESETVAL			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AXR13_INPUT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AXR13_OUTPUT			(0x00000001u)
+
+#define OMAPL_MCASP_PDIR_AXR12_MASK			(0x00001000u)
+#define OMAPL_MCASP_PDIR_AXR12_SHIFT			(0x0000000Cu)
+#define OMAPL_MCASP_PDIR_AXR12_RESETVAL			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AXR12_INPUT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AXR12_OUTPUT			(0x00000001u)
+
+#define OMAPL_MCASP_PDIR_AXR11_MASK			(0x00000800u)
+#define OMAPL_MCASP_PDIR_AXR11_SHIFT			(0x0000000Bu)
+#define OMAPL_MCASP_PDIR_AXR11_RESETVAL			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AXR11_INPUT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AXR11_OUTPUT			(0x00000001u)
+
+#define OMAPL_MCASP_PDIR_AXR10_MASK			(0x00000400u)
+#define OMAPL_MCASP_PDIR_AXR10_SHIFT			(0x0000000Au)
+#define OMAPL_MCASP_PDIR_AXR10_RESETVAL			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AXR10_INPUT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AXR10_OUTPUT			(0x00000001u)
+#define OMAPL_MCASP_PDIR_AXR9_MASK			(0x00000200u)
+#define OMAPL_MCASP_PDIR_AXR9_SHIFT			(0x00000009u)
+#define OMAPL_MCASP_PDIR_AXR9_RESETVAL			(0x00000000u)
+/* AXR9 Tokens */
+#define OMAPL_MCASP_PDIR_AXR9_INPUT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AXR9_OUTPUT			(0x00000001u)
+
+#define OMAPL_MCASP_PDIR_AXR8_MASK			(0x00000100u)
+#define OMAPL_MCASP_PDIR_AXR8_SHIFT			(0x00000008u)
+#define OMAPL_MCASP_PDIR_AXR8_RESETVAL			(0x00000000u)
+/* AXR8 Tokens */
+#define OMAPL_MCASP_PDIR_AXR8_INPUT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AXR8_OUTPUT			(0x00000001u)
+
+#define OMAPL_MCASP_PDIR_AXR7_MASK			(0x00000080u)
+#define OMAPL_MCASP_PDIR_AXR7_SHIFT			(0x00000007u)
+#define OMAPL_MCASP_PDIR_AXR7_RESETVAL			(0x00000000u)
+/*----AXR7 Tokens----*/
+#define OMAPL_MCASP_PDIR_AXR7_INPUT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AXR7_OUTPUT			(0x00000001u)
+
+#define OMAPL_MCASP_PDIR_AXR6_MASK			(0x00000040u)
+#define OMAPL_MCASP_PDIR_AXR6_SHIFT			(0x00000006u)
+#define OMAPL_MCASP_PDIR_AXR6_RESETVAL			(0x00000000u)
+/*----AXR6 Tokens----*/
+#define OMAPL_MCASP_PDIR_AXR6_INPUT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AXR6_OUTPUT			(0x00000001u)
+
+#define OMAPL_MCASP_PDIR_AXR5_MASK			(0x00000020u)
+#define OMAPL_MCASP_PDIR_AXR5_SHIFT			(0x00000005u)
+#define OMAPL_MCASP_PDIR_AXR5_RESETVAL			(0x00000000u)
+/*----AXR5 Tokens----*/
+#define OMAPL_MCASP_PDIR_AXR5_INPUT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AXR5_OUTPUT			(0x00000001u)
+
+#define OMAPL_MCASP_PDIR_AXR4_MASK			(0x00000010u)
+#define OMAPL_MCASP_PDIR_AXR4_SHIFT			(0x00000004u)
+#define OMAPL_MCASP_PDIR_AXR4_RESETVAL			(0x00000000u)
+/*----AXR4 Tokens----*/
+#define OMAPL_MCASP_PDIR_AXR4_INPUT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AXR4_OUTPUT			(0x00000001u)
+
+#define OMAPL_MCASP_PDIR_AXR3_MASK			(0x00000008u)
+#define OMAPL_MCASP_PDIR_AXR3_SHIFT			(0x00000003u)
+#define OMAPL_MCASP_PDIR_AXR3_RESETVAL			(0x00000000u)
+/*----AXR3 Tokens----*/
+#define OMAPL_MCASP_PDIR_AXR3_INPUT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AXR3_OUTPUT			(0x00000001u)
+
+#define OMAPL_MCASP_PDIR_AXR2_MASK			(0x00000004u)
+#define OMAPL_MCASP_PDIR_AXR2_SHIFT			(0x00000002u)
+#define OMAPL_MCASP_PDIR_AXR2_RESETVAL			(0x00000000u)
+/*----AXR2 Tokens----*/
+#define OMAPL_MCASP_PDIR_AXR2_INPUT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AXR2_OUTPUT			(0x00000001u)
+
+#define OMAPL_MCASP_PDIR_AXR1_MASK			(0x00000002u)
+#define OMAPL_MCASP_PDIR_AXR1_SHIFT			(0x00000001u)
+#define OMAPL_MCASP_PDIR_AXR1_RESETVAL			(0x00000000u)
+/*----AXR1 Tokens----*/
+#define OMAPL_MCASP_PDIR_AXR1_INPUT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AXR1_OUTPUT			(0x00000001u)
+
+#define OMAPL_MCASP_PDIR_AXR0_MASK			(0x00000001u)
+#define OMAPL_MCASP_PDIR_AXR0_SHIFT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AXR0_RESETVAL			(0x00000000u)
+/*----AXR0 Tokens----*/
+#define OMAPL_MCASP_PDIR_AXR0_INPUT			(0x00000000u)
+#define OMAPL_MCASP_PDIR_AXR0_OUTPUT			(0x00000001u)
+
+#define OMAPL_MCASP_PDIR_RESETVAL			(0x00000000u)
+
+#define OMAPL_MCASP_ACLKXCTL_CLKXP_MASK			(0x00000080u)
+#define OMAPL_MCASP_ACLKXCTL_CLKXP_SHIFT		(0x00000007u)
+#define OMAPL_MCASP_ACLKXCTL_CLKXP_RESETVAL		(0x00000000u)
+/*----CLKXP Tokens----*/
+#define OMAPL_MCASP_ACLKXCTL_CLKXP_RISINGEDGE		(0x00000000u)
+#define OMAPL_MCASP_ACLKXCTL_CLKXP_FALLINGEDGE		(0x00000001u)
+
+#define OMAPL_MCASP_ACLKXCTL_ASYNC_MASK			(0x00000040u)
+#define OMAPL_MCASP_ACLKXCTL_ASYNC_SHIFT		(0x00000006u)
+#define OMAPL_MCASP_ACLKXCTL_ASYNC_RESETVAL		(0x00000001u)
+/*----ASYNC Tokens----*/
+#define OMAPL_MCASP_ACLKXCTL_ASYNC_SYNC			(0x00000000u)
+#define OMAPL_MCASP_ACLKXCTL_ASYNC_ASYNC		(0x00000001u)
+
+#define OMAPL_MCASP_ACLKXCTL_CLKXM_MASK			(0x00000020u)
+#define OMAPL_MCASP_ACLKXCTL_CLKXM_SHIFT		(0x00000005u)
+#define OMAPL_MCASP_ACLKXCTL_CLKXM_RESETVAL		(0x00000001u)
+/*----CLKXM Tokens----*/
+#define OMAPL_MCASP_ACLKXCTL_CLKXM_EXTERNAL		(0x00000000u)
+#define OMAPL_MCASP_ACLKXCTL_CLKXM_INTERNAL		(0x00000001u)
+
+#define OMAPL_MCASP_ACLKXCTL_CLKXDIV_MASK		(0x0000001Fu)
+#define OMAPL_MCASP_ACLKXCTL_CLKXDIV_SHIFT		(0x00000000u)
+#define OMAPL_MCASP_ACLKXCTL_CLKXDIV_RESETVAL		(0x00000000u)
+
+#define OMAPL_MCASP_ACLKXCTL_RESETVAL			(0x00000060u)
+
+/* AHCLKXCTL */
+#define OMAPL_MCASP_AHCLKXCTL_HCLKXM_MASK		(0x00008000u)
+#define OMAPL_MCASP_AHCLKXCTL_HCLKXM_SHIFT		(0x0000000Fu)
+#define OMAPL_MCASP_AHCLKXCTL_HCLKXM_RESETVAL		(0x00000001u)
+/*----HCLKXM Tokens----*/
+#define OMAPL_MCASP_AHCLKXCTL_HCLKXM_EXTERNAL		(0x00000000u)
+#define OMAPL_MCASP_AHCLKXCTL_HCLKXM_INTERNAL		(0x00000001u)
+
+#define OMAPL_MCASP_AHCLKXCTL_HCLKXP_MASK		(0x00004000u)
+#define OMAPL_MCASP_AHCLKXCTL_HCLKXP_SHIFT		(0x0000000Eu)
+#define OMAPL_MCASP_AHCLKXCTL_HCLKXP_RESETVAL		(0x00000000u)
+/*----HCLKXP Tokens----*/
+#define OMAPL_MCASP_AHCLKXCTL_HCLKXP_NOTINVERTED	(0x00000000u)
+#define OMAPL_MCASP_AHCLKXCTL_HCLKXP_INVERTED		(0x00000001u)
+
+#define OMAPL_MCASP_AHCLKXCTL_HCLKXDIV_MASK		(0x00000FFFu)
+#define OMAPL_MCASP_AHCLKXCTL_HCLKXDIV_SHIFT		(0x00000000u)
+#define OMAPL_MCASP_AHCLKXCTL_HCLKXDIV_RESETVAL		(0x00000000u)
+
+#define OMAPL_MCASP_AHCLKXCTL_RESETVAL			(0x00008000u)
+
+#define MCASP_SUART_GBLCTL				(0X00000000)
+#define MCASP_SUART_RGBLCTL				(0X00000000)
+#define MCASP_SUART_XGBLCTL				(0X00000000)
+#define MCASP_SUART_RMASK_8				(0x000000FF)
+#define MCASP_SUART_RMASK_16				(0x0000FFFF)
+#define MCASP_SUART_RFMT_8				(0x0000A038)
+#define MCASP_SUART_RFMT_16				(0x0000A078)
+#define MCASP_SUART_FSRM				(0X00000002)
+#define MCASP_SUART_CLKRM_CLKRP				(0X000000A0)
+#define MCASP_SUART_HCLKRP				(0X00008000)
+#define MCASP_SUART_RTDMS0				(0X00000001)
+#define MCASP_SUART_RSYNCERR				(0X00000002)
+#define MCASP_SUART_RMAX_RPS_256			(0x00FF0008)
+#define MCASP_SUART_XMASK_0_31				(0X0000FFFF)
+#define MCASP_SUART_XBUSEL_XSSZ_16_XPAD_0		(0x00002078)
+#define MCASP_SUART_FSXM				(0x00000002)
+#define MCASP_SUART_CLKXM_ASYNC_CLKXP			(0x000000E0)
+#define MCASP_SUART_HCLKXM				(0x00008000)
+#define MCASP_SUART_XTDMS0				(0X00000001)
+#define MCASP_SUART_XSYNCERR				(0x00000002)
+#define MCASP_SUART_XMAX_XPS_256			(0x00FF0008)
+#define MCASP_SUART_SRCTL_DISMOD			(0x0000000c)
+#define MCASP_SUART_DIT_DISABLE				(0X00000000)
+#define MCASP_SUART_LOOPBACK_DISABLE			(0x00000000)
+#define MCASP_SUART_AMUTE_DISABLE			(0X00000000)
+#define MCASP_SUART_XSTAT				(0x0000FFFF)
+#define MCASP_SUART_RSTAT				(0x0000FFFF)
+#endif
diff --git a/drivers/tty/serial/da8xx_pruss/pruss_suart_regs.h b/drivers/tty/serial/da8xx_pruss/pruss_suart_regs.h
new file mode 100644
index 0000000..c2aa9d7
--- /dev/null
+++ b/drivers/tty/serial/da8xx_pruss/pruss_suart_regs.h
@@ -0,0 +1,153 @@
+/*
+ * Copyright (C) 2010 Texas Instruments Incorporated
+ * Author: jitendra@mistralsolutions.com
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as  published by the
+ * Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef _SUART_PRU_REGS_H_
+#define _SUART_PRU_REGS_H_
+
+#include <linux/types.h>
+
+/** PRU0 DATA RAM base address */
+#define PRU0_DATARAM_OFFSET		(0x0000u)
+/** PRU1 DATA RAM base address */
+#define PRU1_DATARAM_OFFSET		(0x2000u)
+
+/** PRU0 DATA RAM size */
+#define PRU0_DATARAM_SIZE		(0x200u)
+/** PRU1 DATA RAM size */
+#define PRU1_DATARAM_SIZE		(0x200u)
+
+#define PRU_SUART_PRU0_CH0_OFFSET	(0x0000)
+#define PRU_SUART_PRU0_CH1_OFFSET	(0x0010)
+#define PRU_SUART_PRU0_CH2_OFFSET	(0x0020)
+#define PRU_SUART_PRU0_CH3_OFFSET	(0x0030)
+#define PRU_SUART_PRU0_CH4_OFFSET	(0x0040)
+#define PRU_SUART_PRU0_CH5_OFFSET	(0x0050)
+#define PRU_SUART_PRU0_CH6_OFFSET	(0x0060)
+#define PRU_SUART_PRU0_CH7_OFFSET	(0x0070)
+#define PRU_SUART_PRU0_IMR_OFFSET	(0x0080)
+/** Interrupt Mask Register */
+#define PRU_SUART_PRU0_ISR_OFFSET	(0x0082)
+/** Interrupt Status Register */
+#define PRU_SUART_PRU0_ID_ADDR		(0x0084)
+/** PRU ID Register */
+#define PRU_SUART_PRU0_RX_TX_MODE	(0x0085)
+#define PRU_SUART_PRU0_DELAY_OFFSET	(0x0086)
+#define PRU_SUART_PRU0_IDLE_TIMEOUT_OFFSET	(0x0088)
+
+/* ********* PRU 1 Macros ************* */
+#define PRU_SUART_PRU1_CH0_OFFSET	(0x2000)
+#define PRU_SUART_PRU1_CH1_OFFSET	(0x2010)
+#define PRU_SUART_PRU1_CH2_OFFSET	(0x2020)
+#define PRU_SUART_PRU1_CH3_OFFSET	(0x2030)
+#define PRU_SUART_PRU1_CH4_OFFSET	(0x2040)
+#define PRU_SUART_PRU1_CH5_OFFSET	(0x2050)
+#define PRU_SUART_PRU1_CH6_OFFSET	(0x2060)
+#define PRU_SUART_PRU1_CH7_OFFSET	(0x2070)
+#define PRU_SUART_PRU1_IMR_OFFSET	(0x2080)
+#define PRU_SUART_PRU1_ISR_OFFSET	(0x2082)
+#define PRU_SUART_PRU1_ID_ADDR		(0x2084)
+#define PRU_SUART_PRU1_RX_TX_MODE	(0x2085)
+#define PRU_SUART_PRU1_DELAY_OFFSET	(0x2086)
+#define PRU_SUART_PRU1_IDLE_TIMEOUT_OFFSET	(0x2088)
+
+/* SUART Channel Control Register bit descriptions */
+#define PRU_SUART_CH_CTRL_MODE_SHIFT		0x0000
+#define PRU_SUART_CH_CTRL_MODE_MASK		0x0003
+#define PRU_SUART_CH_CTRL_TX_MODE		0x0001
+#define PRU_SUART_CH_CTRL_RX_MODE		0x0002
+
+/* Service Request */
+#define PRU_SUART_CH_CTRL_SREQ_SHIFT		0x0002
+#define PRU_SUART_CH_CTRL_SREQ_MASK		0x0004
+#define PRU_SUART_CH_CTRL_SREQ			0x0001
+
+/* McASP Instance */
+#define PRU_SUART_CH_CTRL_MCASP_SHIFT		0x0003
+#define PRU_SUART_CH_CTRL_MCASP_MASK		0x0018
+#define PRU_SUART_CH_CTRL_SR_SHIFT		0x0008
+#define PRU_SUART_CH_CTRL_SR_MASK		0x0F00
+
+/* SUART channel configuration1 register descriptions */
+
+/* clock divisor -  relative baud value */
+#define PRU_SUART_CH_CONFIG1_DIVISOR_SHIFT	0x0000
+#define PRU_SUART_CH_CONFIG1_DIVISOR_MASK	0x03FF
+/* oversampling */
+#define PRU_SUART_CH_CONFIG1_OVS_SHIFT		0x000A
+#define PRU_SUART_CH_CONFIG1_OVS_MASK		0x0C00
+
+/* SUART channel configuration2 register descriptions */
+/* Bits per character */
+#define PRU_SUART_CH_CONFIG2_BITPERCHAR_SHIFT	0x0000
+#define PRU_SUART_CH_CONFIG2_BITPERCHAR_MASK	0x000F
+
+/* Bits per character */
+#define PRU_SUART_CH_CONFIG2_DATALEN_SHIFT	0x0008
+#define PRU_SUART_CH_CONFIG2_DATALEN_MASK	0x0F00
+
+/* SUART Channel register offsets */
+#define PRU_SUART_CH_CTRL_OFFSET		0x00
+#define PRU_SUART_CH_CONFIG1_OFFSET		0x02
+#define PRU_SUART_CH_CONFIG2_OFFSET		0x04
+#define PRU_SUART_CH_TXRXSTATUS_OFFSET		0x06
+#define PRU_SUART_CH_TXRXDATA_OFFSET		0x08
+#define PRU_SUART_CH_BYTESDONECNTR_OFFSET	0x0C
+
+/* SUART Event Numbers macros */
+#define PRU_SUART0_TX_EVT	34
+#define PRU_SUART0_RX_EVT	35
+#define PRU_SUART1_TX_EVT	36
+#define PRU_SUART1_RX_EVT	37
+#define PRU_SUART2_TX_EVT	38
+#define PRU_SUART2_RX_EVT	39
+#define PRU_SUART3_TX_EVT	40
+#define PRU_SUART3_RX_EVT	41
+#define PRU_SUART4_TX_EVT	42
+#define PRU_SUART4_RX_EVT	43
+#define PRU_SUART5_TX_EVT	44
+#define PRU_SUART5_RX_EVT	45
+#define PRU_SUART6_TX_EVT	46
+#define PRU_SUART6_RX_EVT	47
+#define PRU_SUART7_TX_EVT	48
+#define PRU_SUART7_RX_EVT	49
+
+#define PRU_SUART0_TX_EVT_BIT	BIT(2)
+#define PRU_SUART0_RX_EVT_BIT	BIT(3)
+#define PRU_SUART1_TX_EVT_BIT	BIT(4)
+#define PRU_SUART1_RX_EVT_BIT	BIT(5)
+#define PRU_SUART2_TX_EVT_BIT	BIT(6)
+#define PRU_SUART2_RX_EVT_BIT	BIT(7)
+#define PRU_SUART3_TX_EVT_BIT	BIT(8)
+#define PRU_SUART3_RX_EVT_BIT	BIT(9)
+#define PRU_SUART4_TX_EVT_BIT	BIT(10)
+#define PRU_SUART4_RX_EVT_BIT	BIT(11)
+#define PRU_SUART5_TX_EVT_BIT	BIT(12)
+#define PRU_SUART5_RX_EVT_BIT	BIT(13)
+#define PRU_SUART6_TX_EVT_BIT	BIT(14)
+#define PRU_SUART6_RX_EVT_BIT	BIT(15)
+#define PRU_SUART7_TX_EVT_BIT	BIT(16)
+#define PRU_SUART7_RX_EVT_BIT	BIT(17)
+
+/*
+ *  SUART Config regs
+ */
+typedef struct {
+	u16 chn_ctrl;
+	u16 chn_config1;
+	u16 chn_config2;
+	u16 chn_txrx_status;
+	u32 chn_txrx_data;
+} suart_struct_pru_regs;
+
+#endif
diff --git a/drivers/tty/serial/da8xx_pruss/pruss_suart_utils.c b/drivers/tty/serial/da8xx_pruss/pruss_suart_utils.c
new file mode 100644
index 0000000..7ced423
--- /dev/null
+++ b/drivers/tty/serial/da8xx_pruss/pruss_suart_utils.c
@@ -0,0 +1,384 @@
+/*
+ * Copyright (C) 2010 Texas Instruments Incorporated
+ * Author: Jitendra Kumar <jitendra@mistralsolutions.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as  published by the
+ * Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+
+#include <linux/mfd/pruss/da8xx_pru.h>
+#include "pruss_suart_mcasp.h"
+#include "pruss_suart_api.h"
+#include "pruss_suart_regs.h"
+#include "pruss_suart_board.h"
+#include "pruss_suart_utils.h"
+#include "pruss_suart_err.h"
+
+
+#define SUART_TRX_DIV_CONF_SZ	4
+
+static s16 suart_mcasp_tx_baud_set(u32 tx_baud_value,
+			pruss_suart_iomap *pruss_ioaddr);
+static s16 suart_mcasp_rx_baud_set(u32 rx_baud_value, u32 oversampling,
+			pruss_suart_iomap *pruss_ioaddr);
+
+/*
+ * Lookup table for TX baud rate
+ * The divisor value is calculated using the formula
+ *
+ * ACLKX = (AUXCLK)/(CLKXDIV * HCLKXDIV)
+ *
+ * Where
+ *		CLKXDIV takes values from 1-32
+ *		HCLKXDIV takes values from 1-4096
+ * Here
+ *		AUXCLK = 24MHz
+ */
+u32 lt_tx_baud_rate[][SUART_TRX_DIV_CONF_SZ] = {
+	/*BaudRate,	Divisor,	CLKXDIV,HCLKXDIV */
+	{300,		80000,		24,		3200},
+	{600,		40000,		15,		2500},
+	{1800,		13333,		10,		1212},
+	{2400,		10000,		4,		2000},
+	{4800,		5000,		1,		2500},
+	{7200,		3333,		0,		3333},
+	{9600,		2500,		0,		2500},
+	{14400,		1666,		0,		1666},
+	{19200,		1250,		0,		1250},
+	{38400,		625,		0,		625},
+	{57600,		416,		0,		416},
+	{115200,	208,		0,		208},
+	{230400,	104,		0,		104}
+};
+
+/*
+ * Lookup table for RX baud rate for 8 bit oversampling
+ * The divisor value is calculated using the formula
+ *
+ *	ACLKR = (AUXCLK)/(CLKRDIV * HCLKRDIV) * Oversampling
+ *
+ * Where
+ *		CLKRDIV takes values from 1-32
+ *		HCLKRDIV takes values from 1-4096
+ * Here
+ *		AUXCLK = 24MHz
+ */
+u32 lt_rx_8x_baud_rate[][SUART_TRX_DIV_CONF_SZ] = {
+/* BaudRate,	Divisor,	CLKXDIV,	HCLKXDIV */
+	{300,		10000,		4,		2000},
+	{600,		5000,		1,		2500},
+	{1800,		1667,		0,		1667},
+	{2400,		1250,		0,		1250},
+	{7200,		417,		0,		417},
+	{4800,		625,		0,		625},
+	{9600,		312,		0,		312},
+	{14400,		208,		0,		208},
+	{19200,		156,		0,		156},
+	{38400,		78,		0,		78},
+	{57600,		52,		0,		52},
+	{115200,	26,		0,		26},
+	{230400,	13,		0,		13}
+};
+
+/*
+ * Lookup table for RX baud rate for 16 bit oversampling
+ * The divisor value is calculated using the formula
+ *
+ *	ACLKR = (AUXCLK)/(CLKRDIV * HCLKRDIV) * Oversampling
+ *
+ * Where
+ *		CLKRDIV takes values from 1-32
+ *		HCLKRDIV takes values from 1-4096
+ * Here
+ *		AUXCLK = 24MHz
+ */
+u32 lt_rx_16x_baud_rate[][SUART_TRX_DIV_CONF_SZ] = {
+/*BaudRate,	Divisor,	CLKXDIV,	HCLKXDIV */
+	{300,		5000,		1,		2500},
+	{600,		2500,		0,		2500},
+	{1800,		833,		0,		833},
+	{2400,		625,		0,		625},
+	{4800,		312,		0,		312},
+	{7200,		208,		0,		208},
+	{9600,		156,		0,		156},
+	{14400,		104,		0,		104},
+	{19200,		78,		0,		78},
+	{38400,		39,		0,		39},
+	{57600,		26,		0,		26},
+	{115200,	13,		0,		13},
+	{230400,	6,		0,		6}
+};
+
+/*
+ * McASP configuration routine
+ */
+void suart_mcasp_config(u32 tx_baud_value,
+			u32 rx_baud_value,
+			u32 oversampling,
+			pruss_suart_iomap *pruss_ioaddr)
+{
+	omapl_mcasp_regs_ovly mcasp0_regs =
+		(omapl_mcasp_regs_ovly) pruss_ioaddr->mcasp_io_addr;
+	u32 temp_reg;
+
+	/* reset mcasp */
+	__raw_writel(MCASP_SUART_GBLCTL, &mcasp0_regs->GBLCTL);
+	__raw_writel(MCASP_SUART_RGBLCTL, &mcasp0_regs->RGBLCTL);
+	__raw_writel(MCASP_SUART_XGBLCTL, &mcasp0_regs->XGBLCTL);
+
+	/* configure receive registers */
+	if ((SUART_8X_OVRSMPL == oversampling) || (0 == oversampling)) {
+		__raw_writel(MCASP_SUART_RMASK_8, &mcasp0_regs->RMASK);
+		__raw_writel(MCASP_SUART_RFMT_8, &mcasp0_regs->RFMT);
+	}
+	if (SUART_16X_OVRSMPL == oversampling) {
+		__raw_writel(MCASP_SUART_RMASK_16, &mcasp0_regs->RMASK);
+		__raw_writel(MCASP_SUART_RFMT_16, &mcasp0_regs->RFMT);
+
+	}
+
+	__raw_writel(MCASP_SUART_FSRM, &mcasp0_regs->AFSRCTL);
+	__raw_writel(MCASP_SUART_CLKRM_CLKRP, &mcasp0_regs->ACLKRCTL);
+	__raw_writel(MCASP_SUART_HCLKRP, &mcasp0_regs->AHCLKRCTL);
+	suart_mcasp_rx_baud_set(rx_baud_value, oversampling, pruss_ioaddr);
+	__raw_writel(MCASP_SUART_RTDMS0, &mcasp0_regs->RTDM);
+	__raw_writel(MCASP_SUART_RSYNCERR, &mcasp0_regs->RINTCTL);
+	__raw_writel(MCASP_SUART_RMAX_RPS_256, &mcasp0_regs->RCLKCHK);
+
+	/* configure transmit registers. */
+	__raw_writel(MCASP_SUART_XMASK_0_31, &mcasp0_regs->XMASK);
+	__raw_writel(MCASP_SUART_XBUSEL_XSSZ_16_XPAD_0, &mcasp0_regs->XFMT);
+	__raw_writel(MCASP_SUART_FSXM, &mcasp0_regs->AFSXCTL);
+	__raw_writel(MCASP_SUART_CLKXM_ASYNC_CLKXP, &mcasp0_regs->ACLKXCTL);
+	__raw_writel(MCASP_SUART_HCLKXM, &mcasp0_regs->AHCLKXCTL);
+
+	suart_mcasp_tx_baud_set(tx_baud_value, pruss_ioaddr);
+	__raw_writel(MCASP_SUART_XTDMS0, &mcasp0_regs->XTDM);
+	__raw_writel(MCASP_SUART_XSYNCERR, &mcasp0_regs->XINTCTL);
+	__raw_writel(MCASP_SUART_XMAX_XPS_256, &mcasp0_regs->XCLKCHK);
+
+	/* Serializer as a transmitter */
+	__raw_writel(MCASP_SUART_SRCTL_DISMOD, &mcasp0_regs->SRCTL0);
+	__raw_writel(MCASP_SUART_SRCTL_DISMOD, &mcasp0_regs->SRCTL1);
+	__raw_writel(MCASP_SUART_SRCTL_DISMOD, &mcasp0_regs->SRCTL2);
+	__raw_writel(MCASP_SUART_SRCTL_DISMOD, &mcasp0_regs->SRCTL3);
+	__raw_writel(MCASP_SUART_SRCTL_DISMOD, &mcasp0_regs->SRCTL4);
+	__raw_writel(MCASP_SUART_SRCTL_DISMOD, &mcasp0_regs->SRCTL5);
+	__raw_writel(MCASP_SUART_SRCTL_DISMOD, &mcasp0_regs->SRCTL6);
+	__raw_writel(MCASP_SUART_SRCTL_DISMOD, &mcasp0_regs->SRCTL7);
+	__raw_writel(MCASP_SUART_SRCTL_DISMOD, &mcasp0_regs->SRCTL8);
+	__raw_writel(MCASP_SUART_SRCTL_DISMOD, &mcasp0_regs->SRCTL9);
+	__raw_writel(MCASP_SUART_SRCTL_DISMOD, &mcasp0_regs->SRCTL10);
+	__raw_writel(MCASP_SUART_SRCTL_DISMOD, &mcasp0_regs->SRCTL11);
+	__raw_writel(MCASP_SUART_SRCTL_DISMOD, &mcasp0_regs->SRCTL12);
+	__raw_writel(MCASP_SUART_SRCTL_DISMOD, &mcasp0_regs->SRCTL13);
+	__raw_writel(MCASP_SUART_SRCTL_DISMOD, &mcasp0_regs->SRCTL14);
+	__raw_writel(MCASP_SUART_SRCTL_DISMOD, &mcasp0_regs->SRCTL15);
+
+	/* Configure all AXR[n] as McASP pins  */
+
+	/*
+	 *  Setting  all TX MCASP AXR[n] Pin mapped to Even Serializer number
+	 *  (0,2,4,6,8,10,12,14) to GPIO Mode by default. During setting the
+	 *  serializer to TX mode in PRU assembly code, the MCASP AXR[n] Pin
+	 *  would get configured to MCASP mode of operation,
+	 *  before Actual Data Transfer
+	 */
+
+	/* Setting  all TX Pin to GPIO Mode by default */
+	temp_reg = (OMAPL_MCASP_PFUNC_RESETVAL) |
+	    (1 << PRU_SUART0_CONFIG_TX_SER) | (1 << PRU_SUART1_CONFIG_TX_SER) |
+	    (1 << PRU_SUART2_CONFIG_TX_SER) | (1 << PRU_SUART3_CONFIG_TX_SER) |
+	    (1 << PRU_SUART4_CONFIG_TX_SER) | (1 << PRU_SUART5_CONFIG_TX_SER) |
+	    (1 << PRU_SUART6_CONFIG_TX_SER) | (1 << PRU_SUART7_CONFIG_TX_SER);
+	__raw_writel(temp_reg, &mcasp0_regs->PFUNC);
+
+	__raw_writel(0xFFF, &mcasp0_regs->PDOUT);
+
+	/* config pin function and direction */
+	__raw_writel(0x00000000, &mcasp0_regs->PDIR);
+	temp_reg =
+	    (1 << PRU_SUART0_CONFIG_TX_SER) | (1 << PRU_SUART1_CONFIG_TX_SER) |
+	    (1 << PRU_SUART2_CONFIG_TX_SER) | (1 << PRU_SUART3_CONFIG_TX_SER) |
+	    (1 << PRU_SUART4_CONFIG_TX_SER) | (1 << PRU_SUART5_CONFIG_TX_SER) |
+	    (1 << PRU_SUART6_CONFIG_TX_SER) | (1 << PRU_SUART7_CONFIG_TX_SER) |
+	    (MCASP_PDIR_VAL);
+	__raw_writel(temp_reg, &mcasp0_regs->PDIR);
+
+	__raw_writel(MCASP_SUART_DIT_DISABLE, &mcasp0_regs->DITCTL);
+	__raw_writel(MCASP_SUART_LOOPBACK_DISABLE, &mcasp0_regs->DLBCTL);
+	__raw_writel(MCASP_SUART_AMUTE_DISABLE, &mcasp0_regs->AMUTE);
+
+	__raw_writel(MCASP_SUART_XSTAT, &mcasp0_regs->XSTAT);
+	__raw_writel(MCASP_SUART_RSTAT, &mcasp0_regs->RSTAT);
+}
+
+void suart_mcasp_tx_serialzier_set(u32 serializer_num,
+		pruss_suart_iomap *pruss_ioaddr)
+{
+	omapl_mcasp_regs_ovly mcasp0_regs =
+	    (omapl_mcasp_regs_ovly) pruss_ioaddr->mcasp_io_addr;
+	u32 temp_reg;
+	temp_reg = mcasp0_regs->PFUNC | (0x1 << serializer_num);
+	__raw_writel(temp_reg, &mcasp0_regs->PFUNC);
+}
+
+/*
+ * mcasp TX buard rate setting routine
+ */
+s16 suart_mcasp_tx_baud_set(u32 tx_baud_value,
+		pruss_suart_iomap *pruss_ioaddr)
+{
+	u32 clk_div_val;
+	u32 loop_cnt;
+	s16 status = SUART_SUCCESS;
+	s16 found_val = SUART_FALSE;
+
+	omapl_mcasp_regs_ovly mcasp0_regs =
+	    (omapl_mcasp_regs_ovly) pruss_ioaddr->mcasp_io_addr;
+	u32 temp_reg;
+
+	/* Search the supported baud rate in the table */
+	for (loop_cnt = 0; loop_cnt < SUART_NUM_OF_BAUDS_SUPPORTED;
+							loop_cnt++) {
+		if (tx_baud_value == lt_tx_baud_rate[loop_cnt][0]) {
+			found_val = SUART_TRUE;
+			break;
+		}
+	}
+	if (found_val == SUART_TRUE) {
+		clk_div_val = lt_tx_baud_rate[loop_cnt][2];
+		temp_reg = mcasp0_regs->ACLKXCTL |
+			clk_div_val << OMAPL_MCASP_ACLKXCTL_CLKXDIV_SHIFT;
+		__raw_writel(temp_reg, &mcasp0_regs->ACLKXCTL);
+		clk_div_val = lt_tx_baud_rate[loop_cnt][3];
+		temp_reg = mcasp0_regs->AHCLKXCTL |
+			clk_div_val << OMAPL_MCASP_AHCLKXCTL_HCLKXDIV_SHIFT;
+		__raw_writel(temp_reg, &mcasp0_regs->AHCLKXCTL);
+	} else {
+		return SUART_INVALID_TX_BAUD;
+	}
+	return status;
+}
+
+/*
+ * mcasp RX buard rate setting routine
+ */
+s16 suart_mcasp_rx_baud_set(u32 rx_baud_value,
+	u32 oversampling, pruss_suart_iomap *pruss_ioaddr)
+{
+	u32 clk_div_val;
+	u32 loop_cnt;
+	s16 status = SUART_SUCCESS;
+	s16 found_val = SUART_FALSE;
+
+	omapl_mcasp_regs_ovly mcasp0_regs =
+	    (omapl_mcasp_regs_ovly) pruss_ioaddr->mcasp_io_addr;
+	u32 temp_reg;
+
+	if (oversampling == SUART_8X_OVRSMPL) {
+		for (loop_cnt = 0; loop_cnt < SUART_NUM_OF_BAUDS_SUPPORTED;
+		     loop_cnt++) {
+			if (rx_baud_value == lt_rx_8x_baud_rate[loop_cnt][0]) {
+				clk_div_val = lt_rx_8x_baud_rate[loop_cnt][2];
+				temp_reg = mcasp0_regs->ACLKRCTL | (clk_div_val
+					<< OMAPL_MCASP_ACLKXCTL_CLKXDIV_SHIFT);
+
+				__raw_writel(temp_reg, &mcasp0_regs->ACLKRCTL);
+
+				clk_div_val =
+				lt_rx_8x_baud_rate[loop_cnt][3] - 1;
+
+				temp_reg = mcasp0_regs->AHCLKRCTL | (clk_div_val
+				<< OMAPL_MCASP_AHCLKXCTL_HCLKXDIV_SHIFT);
+
+				__raw_writel(temp_reg, &mcasp0_regs->AHCLKRCTL);
+
+				found_val = SUART_TRUE;
+				break;
+			}
+		}
+	} else if (oversampling == SUART_16X_OVRSMPL) {
+		for (loop_cnt = 0; loop_cnt < SUART_NUM_OF_BAUDS_SUPPORTED;
+		     loop_cnt++) {
+			if (rx_baud_value == lt_rx_16x_baud_rate[loop_cnt][0]) {
+				clk_div_val = lt_rx_16x_baud_rate[loop_cnt][2];
+				temp_reg =
+					mcasp0_regs->ACLKRCTL | (clk_div_val <<
+					OMAPL_MCASP_ACLKXCTL_CLKXDIV_SHIFT);
+				__raw_writel(temp_reg, &mcasp0_regs->ACLKRCTL);
+				clk_div_val = lt_rx_16x_baud_rate[loop_cnt][3];
+				temp_reg =
+				mcasp0_regs->AHCLKRCTL | (clk_div_val <<
+				OMAPL_MCASP_AHCLKXCTL_HCLKXDIV_SHIFT);
+				__raw_writel(temp_reg, &mcasp0_regs->AHCLKRCTL);
+				found_val = SUART_TRUE;
+				break;
+			}
+		}
+	} else if (oversampling == 0) {
+		for (loop_cnt = 0; loop_cnt < SUART_NUM_OF_BAUDS_SUPPORTED;
+		     loop_cnt++) {
+			if (rx_baud_value == lt_tx_baud_rate[loop_cnt][0]) {
+				clk_div_val = lt_tx_baud_rate[loop_cnt][2];
+				temp_reg =
+				mcasp0_regs->ACLKRCTL | (clk_div_val <<
+				OMAPL_MCASP_ACLKXCTL_CLKXDIV_SHIFT);
+				__raw_writel(temp_reg, &mcasp0_regs->ACLKRCTL);
+				clk_div_val = lt_tx_baud_rate[loop_cnt][3];
+				temp_reg =
+				mcasp0_regs->AHCLKRCTL | (clk_div_val <<
+				OMAPL_MCASP_AHCLKXCTL_HCLKXDIV_SHIFT);
+				__raw_writel(temp_reg, &mcasp0_regs->AHCLKRCTL);
+				found_val = SUART_TRUE;
+				break;
+			}
+		}
+	} else {
+		return SUART_INVALID_OVERSAMPLING;
+	}
+
+	if (found_val != SUART_TRUE)
+		return SUART_INVALID_RX_BAUD;
+
+	return status;
+}
+
+/*
+ * mcasp buard rate setting routine
+ */
+s16 suart_asp_baud_set(u32 tx_baud_value, u32 rx_baud_value, u32 oversampling,
+					pruss_suart_iomap *pruss_ioaddr)
+{
+	s16 status = SUART_SUCCESS;
+
+	status = suart_mcasp_tx_baud_set(tx_baud_value, pruss_ioaddr);
+	status = suart_mcasp_rx_baud_set(rx_baud_value, oversampling,
+					pruss_ioaddr);
+
+	return status;
+}
+
+/*
+ * mcasp deactivate the selected serializer
+ */
+s16 suart_asp_serializer_deactivate(u16 u16sr_num,
+		pruss_suart_iomap *pruss_ioaddr)
+{
+	s16 status = SUART_SUCCESS;
+	omapl_mcasp_regs_ovly mcasp0_regs = (omapl_mcasp_regs_ovly)
+				pruss_ioaddr->mcasp_io_addr;
+	if (u16sr_num > 15)
+		status = SUART_INVALID_SR_NUM;
+	else
+		__raw_writel(MCASP_SUART_SRCTL_DISMOD, &mcasp0_regs->SRCTL0);
+
+	return status;
+}
diff --git a/drivers/tty/serial/da8xx_pruss/pruss_suart_utils.h b/drivers/tty/serial/da8xx_pruss/pruss_suart_utils.h
new file mode 100644
index 0000000..7839eb6
--- /dev/null
+++ b/drivers/tty/serial/da8xx_pruss/pruss_suart_utils.h
@@ -0,0 +1,63 @@
+/*
+ * Copyright (C) 2010 Texas Instruments Incorporated
+ * Author: jitendra@mistralsolutions.com
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as  published by the
+ * Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef _SUART_UTILS_H_
+#define _SUART_UTILS_H_
+
+#include <linux/types.h>
+
+/* ************ Serializers ***************** */
+#define PRU_SUART_SERIALIZER_0		(0u)
+#define PRU_SUART_SERIALIZER_1		(1u)
+#define PRU_SUART_SERIALIZER_2		(2u)
+#define PRU_SUART_SERIALIZER_3		(3u)
+#define PRU_SUART_SERIALIZER_4		(4u)
+#define PRU_SUART_SERIALIZER_5		(5u)
+#define PRU_SUART_SERIALIZER_6		(6u)
+#define PRU_SUART_SERIALIZER_7		(7u)
+#define PRU_SUART_SERIALIZER_8		(8u)
+#define PRU_SUART_SERIALIZER_9		(9u)
+#define PRU_SUART_SERIALIZER_10		(10u)
+#define PRU_SUART_SERIALIZER_11		(11u)
+#define PRU_SUART_SERIALIZER_12		(12u)
+#define PRU_SUART_SERIALIZER_13		(13u)
+#define PRU_SUART_SERIALIZER_14		(14u)
+#define PRU_SUART_SERIALIZER_15		(15u)
+#define PRU_SUART_SERIALIZER_NONE	(16u)
+
+/* Total number of baud rates supported */
+#define SUART_NUM_OF_BAUDS_SUPPORTED	13
+
+#define MCASP_PDIR_VAL ( \
+	OMAPL_MCASP_PDIR_AFSR_OUTPUT<<OMAPL_MCASP_PDIR_AFSR_SHIFT | \
+	OMAPL_MCASP_PDIR_AHCLKR_OUTPUT<<OMAPL_MCASP_PDIR_AHCLKR_SHIFT | \
+	OMAPL_MCASP_PDIR_ACLKR_OUTPUT<<OMAPL_MCASP_PDIR_ACLKR_SHIFT | \
+	OMAPL_MCASP_PDIR_AFSX_OUTPUT<<OMAPL_MCASP_PDIR_AFSX_SHIFT | \
+	OMAPL_MCASP_PDIR_AHCLKX_OUTPUT<<OMAPL_MCASP_PDIR_AHCLKX_SHIFT | \
+	OMAPL_MCASP_PDIR_ACLKX_OUTPUT<<OMAPL_MCASP_PDIR_ACLKX_SHIFT)
+
+extern void suart_mcasp_config(u32 tx_baud_value,
+			u32 rx_baud_value, u32 oversampling,
+			pruss_suart_iomap *pruss_ioaddr);
+
+extern short suart_asp_baud_set(u32 tx_baud_value,
+			u32 rx_baud_value, u32 oversampling,
+			pruss_suart_iomap *pruss_ioaddr);
+
+extern short suart_asp_serializer_deactivate(u16 u16sr_num,
+			pruss_suart_iomap *pruss_ioaddr);
+
+extern void suart_mcasp_tx_serialzier_set(u32 serializer_num,
+			pruss_suart_iomap *pruss_ioaddr);
+#endif
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 758c5b0..eae37fe 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -202,6 +202,8 @@
 /* VIA VT8500 SoC */
 #define PORT_VT8500	97
 
+#define PORT_DA8XX_PRU_SUART	98
+
 #ifdef __KERNEL__
 
 #include <linux/compiler.h>
-- 
1.7.2.3

