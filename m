Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab2B1H2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 02:28:48 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:53271 "HELO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756370Ab2B1H2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 02:28:42 -0500
From: zhaoy <zhaoy@marvell.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nicolas.pitre@linaro.org, linux@arm.linux.org.uk, hzhuang1@marvell.com,
        cxie4@marvell.com, leoy@marvell.com
Cc: zhaoy <zhaoy@marvell.com>
Subject: [PATCH 08/13] DMAC:tty serial pxa use generic dma engine APIs
Date: Tue, 28 Feb 2012 15:27:40 +0800
Message-Id: <1330414065-2949-9-git-send-email-zhaoy@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <Y>
References: <Y>
X-OriginalArrivalTime: 28 Feb 2012 07:28:26.0298 (UTC) FILETIME=[8F5841A0:01CCF5EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	1.tty serial device use dma engine APIs

Change-Id: Ie425e6cb9321914e84a7e53b8a2d57d957dce42c
Signed-off-by: zhaoy <zhaoy@marvell.com>
---
 arch/arm/configs/mmp2_defconfig |    2 +-
 arch/arm/configs/mmp3_defconfig |    2 +-
 drivers/tty/serial/Kconfig      |   12 +-
 drivers/tty/serial/Makefile     |    1 +
 drivers/tty/serial/mmp_pxa.c    | 1698 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 1712 insertions(+), 3 deletions(-)
 create mode 100644 drivers/tty/serial/mmp_pxa.c

diff --git a/arch/arm/configs/mmp2_defconfig b/arch/arm/configs/mmp2_defconfig
index 7000d6c..138c95a 100644
--- a/arch/arm/configs/mmp2_defconfig
+++ b/arch/arm/configs/mmp2_defconfig
@@ -967,7 +967,7 @@ CONFIG_DEVKMEM=y
 #
 # Non-8250 serial port support
 #
-CONFIG_SERIAL_PXA=y
+CONFIG_SERIAL_MMP_PXA=y
 CONFIG_SERIAL_PXA_CONSOLE=y
 CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
diff --git a/arch/arm/configs/mmp3_defconfig b/arch/arm/configs/mmp3_defconfig
index 53a9684..4f8b160 100644
--- a/arch/arm/configs/mmp3_defconfig
+++ b/arch/arm/configs/mmp3_defconfig
@@ -1032,7 +1032,7 @@ CONFIG_DEVKMEM=y
 #
 # CONFIG_SERIAL_MAX3100 is not set
 # CONFIG_SERIAL_MAX3107 is not set
-CONFIG_SERIAL_PXA=y
+CONFIG_SERIAL_MMP_PXA=y
 CONFIG_SERIAL_PXA_CONSOLE=y
 CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index b3692e6..70114c5 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -668,9 +668,19 @@ config SERIAL_PXA
 	  If you have a machine based on an Intel XScale PXA2xx CPU you
 	  can enable its onboard serial ports by enabling this option.
 
+config SERIAL_MMP_PXA
+	bool "MMP PXA serial port support"
+	depends on ARCH_PXA || ARCH_MMP
+	select SERIAL_CORE
+	help
+	  If you have a machine based on an Intel XScale PXA2xx CPU you
+	  can enable its onboard serial ports by enabling this option.
+	  mmp_pxa is a temporary config for mmp2 and mmp3,separate it from
+	  pxa.c for pxa910 and MG1.
+
 config SERIAL_PXA_CONSOLE
 	bool "Console on PXA serial port"
-	depends on SERIAL_PXA
+	depends on SERIAL_PXA || SERIAL_MMP_PXA
 	select SERIAL_CORE_CONSOLE
 	help
 	  If you have enabled the serial port on the Intel XScale PXA
diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
index cb2628f..bc6c1d3 100644
--- a/drivers/tty/serial/Makefile
+++ b/drivers/tty/serial/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_SERIAL_AMBA_PL010) += amba-pl010.o
 obj-$(CONFIG_SERIAL_AMBA_PL011) += amba-pl011.o
 obj-$(CONFIG_SERIAL_CLPS711X) += clps711x.o
 obj-$(CONFIG_SERIAL_PXA) += pxa.o
+obj-$(CONFIG_SERIAL_MMP_PXA) += mmp_pxa.o
 obj-$(CONFIG_SERIAL_PNX8XXX) += pnx8xxx_uart.o
 obj-$(CONFIG_SERIAL_SA1100) += sa1100.o
 obj-$(CONFIG_SERIAL_BCM63XX) += bcm63xx_uart.o
diff --git a/drivers/tty/serial/mmp_pxa.c b/drivers/tty/serial/mmp_pxa.c
new file mode 100644
index 0000000..68e5b3b
--- /dev/null
+++ b/drivers/tty/serial/mmp_pxa.c
@@ -0,0 +1,1698 @@
+/*
+ *  Based on drivers/serial/8250.c by Russell King.
+ *
+ *  Author:	Nicolas Pitre
+ *  Created:	Feb 20, 2003
+ *  Copyright:	(C) 2003 Monta Vista Software, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * Note 1: This driver is made separate from the already too overloaded
+ * 8250.c because it needs some kirks of its own and that'll make it
+ * easier to add DMA support.
+ *
+ * Note 2: I'm too sick of device allocation policies for serial ports.
+ * If someone else wants to request an "official" allocation of major/minor
+ * for this driver please be my guest.  And don't forget that new hardware
+ * to come from Intel might have more than 3 or 4 of those UARTs.  Let's
+ * hope for a better port registration and dynamic device allocation scheme
+ * with the serial core maintainer satisfaction to appear soon.
+ */
+
+
+#if defined(CONFIG_SERIAL_PXA_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
+#define SUPPORT_SYSRQ
+#endif
+
+#include <linux/module.h>
+#include <linux/ioport.h>
+#include <linux/init.h>
+#include <linux/console.h>
+#include <linux/sysrq.h>
+#include <linux/serial_reg.h>
+#include <linux/circ_buf.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
+#include <linux/serial_core.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/dma-mapping.h>
+#include <linux/wakelock.h>
+#include <linux/dmaengine.h>
+#include <linux/scatterlist.h>
+#include <mach/dma.h>
+#include <plat/pm.h>
+
+#ifdef CONFIG_PXA95x
+#include <mach/dvfm.h>
+#include <mach/pxa95x_dvfm.h>
+#endif
+
+#define	DMA_BLOCK	UART_XMIT_SIZE
+
+#define PXA_UART_TX	0
+#define PXA_UART_RX	1
+
+struct uart_pxa_port {
+	struct uart_port        port;
+	unsigned int            ier;
+	unsigned char           lcr;
+	unsigned int            mcr;
+	unsigned int            lsr_break_flag;
+	struct clk		*clk;
+	char			*name;
+
+	struct timer_list	pxa_timer;
+	struct work_struct	uart_tx_lpm_work;
+#ifdef CONFIG_PXA95x
+	int			dvfm_dev_idx[2];
+	struct notifier_block	notifier_freq_block;
+	struct work_struct	uart_rx_lpm_work;
+#else
+	struct wake_lock idle_lock[2];
+	struct pm_qos_request_list qos_idle[2];
+#endif
+	struct dma_chan *txdma;
+	struct dma_chan *rxdma;
+	struct dma_async_tx_descriptor *rx_desc;
+	struct dma_async_tx_descriptor *tx_desc;
+
+	void			*txdma_addr;
+	void			*rxdma_addr;
+	dma_addr_t		txdma_addr_phys;
+	dma_addr_t		rxdma_addr_phys;
+	int			dma_enable;
+	int			tx_stop;
+	int			rx_stop;
+	int			data_len;
+	int			txdrcmr;
+	int			rxdrcmr;
+	struct	tasklet_struct	tklet;
+
+	int tx_cnt;
+	struct scatterlist rxsg;
+	struct scatterlist txsg;
+	dma_cookie_t rx_cookie;
+	dma_cookie_t tx_cookie;
+
+#ifdef	CONFIG_PM
+	/* We needn't save rx dma register because we
+	 * just restart the dma totallly after resume
+	 */
+	void			*buf_save;
+	unsigned long		dcsr_tx;
+	unsigned long		dsadr_tx;
+	unsigned long		dtadr_tx;
+	unsigned long		dcmd_tx;
+#endif
+};
+
+static int uart_dma;
+
+static int __init uart_dma_setup(char *__unused)
+{
+	uart_dma = 1;
+	return 1;
+}
+__setup("uart_dma", uart_dma_setup);
+
+static void pxa_uart_transmit_dma(void *data);
+static void pxa_uart_receive_dma(void *data);
+static void pxa_uart_receive_dma_err(struct uart_pxa_port *up, int *status);
+static void pxa_uart_transmit_dma_start(struct uart_pxa_port *up, int count);
+static void pxa_uart_receive_dma_start(struct uart_pxa_port *up);
+static inline void wait_for_xmitr(struct uart_pxa_port *up);
+static inline void serial_out(struct uart_pxa_port *up, int offset, int value);
+
+static unsigned int serial_pxa_tx_empty(struct uart_port *port);
+
+#define PXA_TIMER_TIMEOUT (3*HZ)
+
+static inline unsigned int serial_in(struct uart_pxa_port *up, int offset)
+{
+	offset <<= 2;
+	return readl(up->port.membase + offset);
+}
+
+static inline void serial_out(struct uart_pxa_port *up, int offset, int value)
+{
+	offset <<= 2;
+	writel(value, up->port.membase + offset);
+}
+
+static void serial_pxa_enable_ms(struct uart_port *port)
+{
+	struct uart_pxa_port *up = (struct uart_pxa_port *)port;
+
+	if (up->dma_enable)
+		return;
+
+	up->ier |= UART_IER_MSI;
+	serial_out(up, UART_IER, up->ier);
+}
+
+static void serial_pxa_stop_tx(struct uart_port *port)
+{
+	struct uart_pxa_port *up = (struct uart_pxa_port *)port;
+
+	if (up->dma_enable) {
+		up->tx_stop = 1;
+
+		if (up->ier & UART_IER_DMAE) {
+			while (dma_async_is_tx_complete(up->txdma,
+				up->tx_cookie, NULL, NULL) != DMA_SUCCESS)
+				rmb();
+		}
+	} else {
+		if (up->ier & UART_IER_THRI) {
+			up->ier &= ~UART_IER_THRI;
+			serial_out(up, UART_IER, up->ier);
+		}
+	}
+}
+
+static void serial_pxa_stop_rx(struct uart_port *port)
+{
+	struct uart_pxa_port *up = (struct uart_pxa_port *)port;
+
+	if (up->dma_enable) {
+		if (up->ier & UART_IER_DMAE) {
+			dmaengine_terminate_all(up->rxdma);
+
+			while (dma_async_is_tx_complete(up->rxdma,
+				up->rx_cookie, NULL, NULL) != DMA_SUCCESS)
+				rmb();
+		}
+		up->rx_stop = 1;
+	} else {
+		up->ier &= ~UART_IER_RLSI;
+		up->port.read_status_mask &= ~UART_LSR_DR;
+		serial_out(up, UART_IER, up->ier);
+	}
+}
+
+static inline void receive_chars(struct uart_pxa_port *up, int *status)
+{
+	struct tty_struct *tty = up->port.state->port.tty;
+	unsigned int ch, flag;
+	int max_count = 256;
+
+	do {
+		ch = serial_in(up, UART_RX);
+		flag = TTY_NORMAL;
+		up->port.icount.rx++;
+
+		if (unlikely(*status & (UART_LSR_BI | UART_LSR_PE |
+				       UART_LSR_FE | UART_LSR_OE))) {
+			/*
+			 * For statistics only
+			 */
+			if (*status & UART_LSR_BI) {
+				*status &= ~(UART_LSR_FE | UART_LSR_PE);
+				up->port.icount.brk++;
+				/*
+				 * We do the SysRQ and SAK checking
+				 * here because otherwise the break
+				 * may get masked by ignore_status_mask
+				 * or read_status_mask.
+				 */
+				if (uart_handle_break(&up->port))
+					goto ignore_char;
+			} else if (*status & UART_LSR_PE)
+				up->port.icount.parity++;
+			else if (*status & UART_LSR_FE)
+				up->port.icount.frame++;
+			if (*status & UART_LSR_OE)
+				up->port.icount.overrun++;
+
+			/*
+			 * Mask off conditions which should be ignored.
+			 */
+			*status &= up->port.read_status_mask;
+
+#ifdef CONFIG_SERIAL_PXA_CONSOLE
+			if (up->port.line == up->port.cons->index) {
+				/* Recover the break flag from console xmit */
+				*status |= up->lsr_break_flag;
+				up->lsr_break_flag = 0;
+			}
+#endif
+			if (*status & UART_LSR_BI)
+				flag = TTY_BREAK;
+			else if (*status & UART_LSR_PE)
+				flag = TTY_PARITY;
+			else if (*status & UART_LSR_FE)
+				flag = TTY_FRAME;
+		}
+
+		if (uart_handle_sysrq_char(&up->port, ch))
+			goto ignore_char;
+
+		uart_insert_char(&up->port, *status, UART_LSR_OE, ch, flag);
+
+ignore_char:
+		*status = serial_in(up, UART_LSR);
+	} while ((*status & UART_LSR_DR) && (max_count-- > 0));
+	tty_flip_buffer_push(tty);
+}
+
+static void transmit_chars(struct uart_pxa_port *up)
+{
+	struct circ_buf *xmit = &up->port.state->xmit;
+	int count;
+
+	if (up->port.x_char) {
+		serial_out(up, UART_TX, up->port.x_char);
+		up->port.icount.tx++;
+		up->port.x_char = 0;
+		return;
+	}
+	if (uart_circ_empty(xmit) || uart_tx_stopped(&up->port)) {
+		serial_pxa_stop_tx(&up->port);
+		return;
+	}
+
+	count = up->port.fifosize / 2;
+	do {
+		serial_out(up, UART_TX, xmit->buf[xmit->tail]);
+		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
+		up->port.icount.tx++;
+		if (uart_circ_empty(xmit))
+			break;
+	} while (--count > 0);
+
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+		uart_write_wakeup(&up->port);
+
+
+	if (uart_circ_empty(xmit))
+		serial_pxa_stop_tx(&up->port);
+}
+
+static inline void
+dma_receive_chars(struct uart_pxa_port *up, int *status)
+{
+	struct tty_struct *tty = up->port.state->port.tty;
+	unsigned char ch;
+	int max_count = 256;
+	int count = 0;
+	unsigned char *tmp;
+	unsigned int flag = TTY_NORMAL;
+
+	dmaengine_terminate_all(up->rxdma);
+	count = pxa_dmac_chan_get_dst_ptr(up->rxdma) - up->rxdma_addr_phys;
+	tmp = up->rxdma_addr;
+
+	while (count > 0) {
+		if (!uart_handle_sysrq_char(&up->port, *tmp))
+			uart_insert_char(&up->port, *status, 0, *tmp, flag);
+		tmp++;
+		count--;
+	}
+
+	*status = serial_in(up, UART_LSR);
+	if (!(*status & UART_LSR_DR)) {
+		ch = serial_in(up, UART_RX);
+		goto done;
+	}
+
+	do {
+		ch = serial_in(up, UART_RX);
+		flag = TTY_NORMAL;
+		up->port.icount.rx++;
+
+		if (unlikely(*status & (UART_LSR_BI | UART_LSR_PE |
+					UART_LSR_FE | UART_LSR_OE))) {
+			/*
+			 * For statistics only
+			 */
+			if (*status & UART_LSR_BI) {
+				*status &= ~(UART_LSR_FE | UART_LSR_PE);
+				up->port.icount.brk++;
+				/*
+				 * We do the SysRQ and SAK checking
+				 * here because otherwise the break
+				 * may get masked by ignore_status_mask
+				 * or read_status_mask.
+				 */
+				if (uart_handle_break(&up->port))
+					goto ignore_char2;
+			} else if (*status & UART_LSR_PE)
+				up->port.icount.parity++;
+			else if (*status & UART_LSR_FE)
+				up->port.icount.frame++;
+			if (*status & UART_LSR_OE)
+				up->port.icount.overrun++;
+
+			/*
+			 * Mask off conditions which should be ignored.
+			 */
+			*status &= up->port.read_status_mask;
+
+#ifdef CONFIG_SERIAL_PXA_CONSOLE
+			if (up->port.line == up->port.cons->index) {
+				/* Recover the break flag from console xmit */
+				*status |= up->lsr_break_flag;
+				up->lsr_break_flag = 0;
+			}
+#endif
+			if (*status & UART_LSR_BI)
+				flag = TTY_BREAK;
+			else if (*status & UART_LSR_PE)
+				flag = TTY_PARITY;
+			else if (*status & UART_LSR_FE)
+				flag = TTY_FRAME;
+		}
+		if (!uart_handle_sysrq_char(&up->port, ch))
+			uart_insert_char(&up->port, *status, UART_LSR_OE,
+					 ch, flag);
+ignore_char2:
+		*status = serial_in(up, UART_LSR);
+	} while ((*status & UART_LSR_DR) && (max_count-- > 0));
+
+done:
+	tty_schedule_flip(tty);
+	if (up->rx_stop)
+		return;
+	pxa_uart_receive_dma_start(up);
+}
+
+static void serial_pxa_start_tx(struct uart_port *port)
+{
+	struct uart_pxa_port *up = (struct uart_pxa_port *)port;
+
+	if (up->dma_enable) {
+		up->tx_stop = 0;
+		tasklet_schedule(&up->tklet);
+	} else {
+		if (!(up->ier & UART_IER_THRI)) {
+			up->ier |= UART_IER_THRI;
+			serial_out(up, UART_IER, up->ier);
+		}
+	}
+}
+
+static inline void check_modem_status(struct uart_pxa_port *up)
+{
+	int status;
+
+	status = serial_in(up, UART_MSR);
+
+	if ((status & UART_MSR_ANY_DELTA) == 0)
+		return;
+
+	if (status & UART_MSR_TERI)
+		up->port.icount.rng++;
+	if (status & UART_MSR_DDSR)
+		up->port.icount.dsr++;
+	if (status & UART_MSR_DDCD)
+		uart_handle_dcd_change(&up->port, status & UART_MSR_DCD);
+	if (status & UART_MSR_DCTS)
+		uart_handle_cts_change(&up->port, status & UART_MSR_CTS);
+
+	wake_up_interruptible(&up->port.state->port.delta_msr_wait);
+}
+
+/*
+ * This handles the interrupt from one port.
+ */
+static inline irqreturn_t serial_pxa_irq(int irq, void *dev_id)
+{
+	struct uart_pxa_port *up = dev_id;
+	unsigned int iir, lsr;
+
+	iir = serial_in(up, UART_IIR);
+	if (iir & UART_IIR_NO_INT)
+		return IRQ_NONE;
+
+	/* timer is not active */
+	if (!mod_timer(&up->pxa_timer, jiffies + PXA_TIMER_TIMEOUT)) {
+#ifdef CONFIG_PXA95x
+		dvfm_disable_lowpower(up->dvfm_dev_idx[PXA_UART_RX]);
+#else
+		pm_qos_update_request(&up->qos_idle[PXA_UART_RX],
+						PM_QOS_CONSTRAINT);
+		wake_lock(&up->idle_lock[PXA_UART_RX]);
+#endif
+	}
+
+	lsr = serial_in(up, UART_LSR);
+	if (up->dma_enable) {
+		if (UART_LSR_FIFOE & lsr)
+			pxa_uart_receive_dma_err(up, &lsr);
+
+		if (iir & UART_IIR_TOD)
+			dma_receive_chars(up, &lsr);
+	} else {
+		if (lsr & UART_LSR_DR)
+			receive_chars(up, &lsr);
+
+		check_modem_status(up);
+		if (lsr & UART_LSR_THRE) {
+			transmit_chars(up);
+			/* wait Tx empty */
+			while (!serial_pxa_tx_empty(	\
+						(struct uart_port *)dev_id))
+				;
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+static unsigned int serial_pxa_tx_empty(struct uart_port *port)
+{
+	struct uart_pxa_port *up = (struct uart_pxa_port *)port;
+	unsigned long flags;
+	unsigned int ret;
+
+	spin_lock_irqsave(&up->port.lock, flags);
+
+	if (up->dma_enable) {
+		if (up->ier & UART_IER_DMAE) {
+			if (dma_async_is_tx_complete(up->txdma,
+				up->tx_cookie, NULL, NULL) != DMA_SUCCESS) {
+				spin_unlock_irqrestore(&up->port.lock, flags);
+				return 0;
+			}
+		}
+	}
+
+	ret = serial_in(up, UART_LSR) & UART_LSR_TEMT ? TIOCSER_TEMT : 0;
+	spin_unlock_irqrestore(&up->port.lock, flags);
+
+	return ret;
+}
+
+static unsigned int serial_pxa_get_mctrl(struct uart_port *port)
+{
+	struct uart_pxa_port *up = (struct uart_pxa_port *)port;
+	unsigned char status;
+	unsigned int ret;
+
+	status = serial_in(up, UART_MSR);
+
+	ret = 0;
+	if (status & UART_MSR_DCD)
+		ret |= TIOCM_CAR;
+	if (status & UART_MSR_RI)
+		ret |= TIOCM_RNG;
+	if (status & UART_MSR_DSR)
+		ret |= TIOCM_DSR;
+	if (status & UART_MSR_CTS)
+		ret |= TIOCM_CTS;
+
+	return ret;
+}
+
+static void serial_pxa_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+	struct uart_pxa_port *up = (struct uart_pxa_port *)port;
+	unsigned int mcr = 0;
+
+	if (mctrl & TIOCM_RTS)
+		mcr |= UART_MCR_RTS;
+	if (mctrl & TIOCM_DTR)
+		mcr |= UART_MCR_DTR;
+	if (mctrl & TIOCM_OUT1)
+		mcr |= UART_MCR_OUT1;
+	if (mctrl & TIOCM_OUT2)
+		mcr |= UART_MCR_OUT2;
+	if (mctrl & TIOCM_LOOP)
+		mcr |= UART_MCR_LOOP;
+
+	mcr |= up->mcr;
+
+	serial_out(up, UART_MCR, mcr);
+}
+
+static void serial_pxa_break_ctl(struct uart_port *port, int break_state)
+{
+	struct uart_pxa_port *up = (struct uart_pxa_port *)port;
+	unsigned long flags;
+
+	spin_lock_irqsave(&up->port.lock, flags);
+	if (break_state == -1)
+		up->lcr |= UART_LCR_SBC;
+	else
+		up->lcr &= ~UART_LCR_SBC;
+	serial_out(up, UART_LCR, up->lcr);
+	spin_unlock_irqrestore(&up->port.lock, flags);
+}
+
+static void pxa_uart_transmit_dma_start(struct uart_pxa_port *up, int count)
+{
+	unsigned long flags;
+	struct scatterlist *sg;
+	struct pxa_dmac_data dmac_data;
+	struct dma_slave_config slave_config;
+	int ret;
+
+	slave_config.direction      = DMA_TO_DEVICE;
+	slave_config.dst_addr       = up->port.mapbase;
+	slave_config.dst_maxburst   = 8;
+	slave_config.dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+
+	dmac_data.flow_ctrl = true;
+	dmac_data.ch_map    = up->txdrcmr;
+	up->txdma->private = &dmac_data;
+
+	ret = dmaengine_slave_config(up->txdma, &slave_config);
+	if (ret) {
+		printk(KERN_ERR "%s: dmaengine slave config err.\n", __func__);
+		return;
+	}
+
+	sg = &up->txsg;
+	sg_init_table(sg, 1); /* Initialize SG table */
+	sg_set_buf(sg, phys_to_virt(up->txdma_addr_phys), count);
+	sg_dma_address(sg) = up->txdma_addr_phys;
+
+	up->tx_desc = up->txdma->device->device_prep_slave_sg(up->txdma,
+			sg, 1, DMA_TO_DEVICE, 0);
+
+	up->tx_desc->callback = pxa_uart_transmit_dma;
+	up->tx_desc->callback_param = up;
+	up->tx_cnt = count;
+
+	local_irq_save(flags);
+
+#ifdef CONFIG_PXA95x
+	dvfm_disable_lowpower(up->dvfm_dev_idx[PXA_UART_TX]);
+#else
+	pm_qos_update_request(&up->qos_idle[PXA_UART_TX],
+					PM_QOS_CONSTRAINT);
+	wake_lock(&up->idle_lock[PXA_UART_TX]);
+#endif
+
+	up->tx_cookie = up->tx_desc->tx_submit(up->tx_desc);
+	dma_async_issue_pending(up->txdma);
+
+	local_irq_restore(flags);
+}
+
+static void pxa_uart_receive_dma_start(struct uart_pxa_port *up)
+{
+	struct scatterlist *sg;
+	struct pxa_dmac_data dmac_data;
+	struct dma_slave_config slave_config;
+	int ret;
+
+	slave_config.direction      = DMA_FROM_DEVICE;
+	slave_config.src_addr       = up->port.mapbase;
+	slave_config.src_maxburst   = 8;
+	slave_config.src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+
+	dmac_data.flow_ctrl = true;
+	dmac_data.ch_map    = up->rxdrcmr;
+	up->rxdma->private = &dmac_data;
+
+	ret = dmaengine_slave_config(up->rxdma, &slave_config);
+	if (ret) {
+		printk(KERN_ERR "%s: dmaengine slave config err.\n", __func__);
+		return;
+	}
+
+	sg = &up->rxsg;
+	sg_init_table(sg, 1); /* Initialize SG table */
+	sg_set_buf(sg, phys_to_virt(up->rxdma_addr_phys), DMA_BLOCK);
+	sg_dma_address(sg) = up->rxdma_addr_phys;
+
+	up->rx_desc = up->rxdma->device->device_prep_slave_sg(up->rxdma,
+			sg, 1, DMA_FROM_DEVICE, 0);
+
+	up->rx_desc->callback = pxa_uart_receive_dma;
+	up->rx_desc->callback_param = up;
+
+	up->rx_cookie = up->rx_desc->tx_submit(up->rx_desc);
+	dma_async_issue_pending(up->rxdma);
+}
+
+static void pxa_uart_receive_dma_err(struct uart_pxa_port *up, int *status)
+{
+	unsigned char ch;
+	struct tty_struct *tty = up->port.state->port.tty;
+	unsigned char *tmp;
+	int count;
+	unsigned int flag = 0;
+
+	dmaengine_terminate_all(up->rxdma);
+	count = pxa_dmac_chan_get_dst_ptr(up->rxdma) - up->rxdma_addr_phys;
+
+	/* if have DMA reqeust, wait. */
+	while (dma_async_is_tx_complete(up->rxdma,
+		up->rx_cookie, NULL, NULL) != DMA_SUCCESS)
+		rmb();
+
+	tmp = up->rxdma_addr;
+
+	tty_insert_flip_string(tty, tmp, count);
+	up->port.icount.rx += count;
+
+	do {
+		ch = serial_in(up, UART_RX);
+		up->port.icount.rx++;
+
+		/*
+		 * For statistics only
+		 */
+		if (*status & UART_LSR_BI) {
+			*status &= ~(UART_LSR_FE | UART_LSR_PE);
+
+			up->port.icount.brk++;
+			/*
+			 * We do the SysRQ and SAK checking
+			 * here because otherwise the break
+			 * may get masked by ignore_status_mask
+			 * or read_status_mask.
+			 */
+			if (uart_handle_break(&up->port))
+				goto ignore_char;
+			flag = TTY_BREAK;
+		} else if (*status & UART_LSR_PE) {
+			up->port.icount.parity++;
+			flag = TTY_PARITY;
+		} else if (*status & UART_LSR_FE) {
+			up->port.icount.frame++;
+			flag = TTY_FRAME;
+		}
+
+		if (*status & UART_LSR_OE)
+			up->port.icount.overrun++;
+
+		/*
+		 * Mask off conditions which should be ignored.
+		 */
+		*status &= up->port.read_status_mask;
+
+#ifdef CONFIG_SERIAL_PXA_CONSOLE
+		if (up->port.line == up->port.cons->index) {
+			/* Recover the break flag from console xmit */
+			*status |= up->lsr_break_flag;
+			up->lsr_break_flag = 0;
+		}
+#endif
+
+		if (uart_handle_sysrq_char(&up->port, ch))
+			goto ignore_char;
+
+		uart_insert_char(&up->port, *status, UART_LSR_OE, ch, flag);
+
+ignore_char:
+		*status = serial_in(up, UART_LSR);
+	} while (*status & UART_LSR_DR);
+
+	tty_flip_buffer_push(tty);
+	if (up->rx_stop)
+		return;
+	pxa_uart_receive_dma_start(up);
+}
+
+static void pxa_uart_receive_dma(void *data)
+{
+	struct uart_pxa_port *up = (struct uart_pxa_port *)data;
+	struct tty_struct *tty = up->port.state->port.tty;
+	unsigned int count;
+	unsigned char *tmp = up->rxdma_addr;
+
+	dmaengine_terminate_all(up->rxdma);
+
+	count = pxa_dmac_chan_get_dst_ptr(up->rxdma) - up->rxdma_addr_phys;
+	tty_insert_flip_string(tty, tmp, count);
+	up->port.icount.rx += count;
+	tty_flip_buffer_push(tty);
+	if (up->rx_stop)
+		return;
+	pxa_uart_receive_dma_start(up);
+	return;
+}
+
+static void pxa_uart_transmit_dma(void *data)
+{
+	struct uart_pxa_port *up = (struct uart_pxa_port *)data;
+	struct circ_buf *xmit = &up->port.state->xmit;
+
+	dmaengine_terminate_all(up->txdma);
+
+	/* if tx stop, stop transmit DMA and return */
+	if (up->tx_stop)
+		return;
+
+	if (up->port.x_char) {
+		serial_out(up, UART_TX, up->port.x_char);
+		up->port.icount.tx++;
+		up->port.x_char = 0;
+	}
+
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+		uart_write_wakeup(&up->port);
+
+	if (!uart_circ_empty(xmit))
+		tasklet_schedule(&up->tklet);
+	return;
+}
+
+static bool filter(struct dma_chan *chan, void *param)
+{
+	if (!pxa_dmac_is_this_type(chan))
+		return false;
+
+	if (pxa_dmac_chan_get_prio(chan) != (pxa_dma_prio)param)
+		return false;
+
+	return true;
+}
+
+static void uart_pxa_dma_init(struct uart_pxa_port *up)
+{
+	dma_cap_mask_t mask;
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SG, mask);
+
+	if (0 == up->rxdma) {
+		up->rxdma = dma_request_channel(mask, filter,
+					(void *)DMA_PRIO_LOW);
+		if (up->rxdma < 0)
+			goto out;
+
+		printk(KERN_ERR "%s: get rx dma channel %p\n", __func__,
+					up->rxdma);
+	}
+
+	if (0 == up->txdma) {
+		up->txdma = dma_request_channel(mask, filter,
+					(void *)DMA_PRIO_LOW);
+		if (up->txdma < 0)
+			goto err_txdma;
+
+		printk(KERN_ERR "%s: get tx dma channel %p\n", __func__,
+					up->txdma);
+	}
+
+	if (NULL == up->txdma_addr) {
+		up->txdma_addr = dma_alloc_coherent(NULL, DMA_BLOCK,
+				&up->txdma_addr_phys, GFP_KERNEL);
+		if (!up->txdma_addr)
+			goto txdma_err_alloc;
+	}
+
+	if (NULL == up->rxdma_addr) {
+		up->rxdma_addr = dma_alloc_coherent(NULL, DMA_BLOCK,
+				&up->rxdma_addr_phys, GFP_KERNEL);
+		if (!up->rxdma_addr)
+			goto rxdma_err_alloc;
+	}
+
+#ifdef CONFIG_PM
+	up->buf_save = kmalloc(DMA_BLOCK, GFP_KERNEL);
+	if (!up->buf_save)
+		goto buf_err_alloc;
+#endif
+
+	return;
+
+#ifdef CONFIG_PM
+buf_err_alloc:
+	dma_free_coherent(NULL, DMA_BLOCK, up->rxdma_addr,
+			up->rxdma_addr_phys);
+	up->rxdma_addr = NULL;
+#endif
+rxdma_err_alloc:
+	dma_free_coherent(NULL, DMA_BLOCK, up->txdma_addr,
+			up->txdma_addr_phys);
+	up->txdma_addr = NULL;
+txdma_err_alloc:
+	dma_release_channel(up->rxdma);
+	dma_release_channel(up->txdma);
+err_txdma:
+	dma_release_channel(up->rxdma);
+out:
+	return;
+}
+
+static void uart_pxa_dma_uninit(struct uart_pxa_port *up)
+{
+#ifdef CONFIG_PM
+	kfree(up->buf_save);
+#endif
+	dmaengine_terminate_all(up->rxdma);
+	dmaengine_terminate_all(up->txdma);
+
+	if (up->txdma_addr != NULL) {
+		dma_free_coherent(NULL, DMA_BLOCK, up->txdma_addr,
+				up->txdma_addr_phys);
+		up->txdma_addr = NULL;
+	}
+	if (up->txdma != 0)
+		dma_release_channel(up->txdma);
+
+	if (up->rxdma_addr != NULL) {
+		dma_free_coherent(NULL, DMA_BLOCK, up->rxdma_addr,
+				up->rxdma_addr_phys);
+		up->rxdma_addr = NULL;
+	}
+
+	if (up->rxdma != 0)
+		dma_release_channel(up->rxdma);
+
+	return;
+}
+
+static void uart_task_action(unsigned long data)
+{
+	struct uart_pxa_port *up = (struct uart_pxa_port *)data;
+	struct circ_buf *xmit = &up->port.state->xmit;
+	unsigned char *tmp = up->txdma_addr;
+	unsigned long flags;
+	int count = 0, c;
+
+	/* if the tx is stop, just return.*/
+	if (up->tx_stop)
+		return;
+
+	if (dma_async_is_tx_complete(up->txdma, up->tx_cookie, NULL, NULL) !=
+	    DMA_SUCCESS)
+		return;
+
+	spin_lock_irqsave(&up->port.lock, flags);
+	while (1) {
+		c = CIRC_CNT_TO_END(xmit->head, xmit->tail, UART_XMIT_SIZE);
+		if (c <= 0)
+			break;
+
+		memcpy(tmp, xmit->buf + xmit->tail, c);
+		xmit->tail = (xmit->tail + c) & (UART_XMIT_SIZE - 1);
+		tmp += c;
+		count += c;
+		up->port.icount.tx += c;
+	}
+	spin_unlock_irqrestore(&up->port.lock, flags);
+
+	tmp = up->txdma_addr;
+	up->tx_stop = 0;
+
+	pxa_uart_transmit_dma_start(up, count);
+}
+
+static int serial_pxa_startup(struct uart_port *port)
+{
+	struct uart_pxa_port *up = (struct uart_pxa_port *)port;
+	unsigned long flags;
+	int retval;
+
+	if (port->line == 3) /* HWUART */
+		up->mcr |= UART_MCR_AFE;
+	else
+		up->mcr = 0;
+
+	up->port.uartclk = clk_get_rate(up->clk);
+
+	/*
+	 * Allocate the IRQ
+	 */
+	retval = request_irq(up->port.irq, serial_pxa_irq, 0, up->name, up);
+	if (retval)
+		return retval;
+
+	/*
+	 * Clear the FIFO buffers and disable them.
+	 * (they will be reenabled in set_termios())
+	 */
+	serial_out(up, UART_FCR, UART_FCR_ENABLE_FIFO);
+	serial_out(up, UART_FCR, UART_FCR_ENABLE_FIFO |
+			UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT);
+	serial_out(up, UART_FCR, 0);
+
+	/*
+	 * Clear the interrupt registers.
+	 */
+	(void) serial_in(up, UART_LSR);
+	(void) serial_in(up, UART_RX);
+	(void) serial_in(up, UART_IIR);
+	(void) serial_in(up, UART_MSR);
+
+	/*
+	 * Now, initialize the UART
+	 */
+	serial_out(up, UART_LCR, UART_LCR_WLEN8);
+
+	spin_lock_irqsave(&up->port.lock, flags);
+	up->port.mctrl |= TIOCM_OUT2;
+	serial_pxa_set_mctrl(&up->port, up->port.mctrl);
+	spin_unlock_irqrestore(&up->port.lock, flags);
+
+	/*
+	 * Finally, enable interrupts.  Note: Modem status interrupts
+	 * are set via set_termios(), which will be occurring imminently
+	 * anyway, so we don't enable them here.
+	 */
+	if (up->dma_enable) {
+		uart_pxa_dma_init(up);
+		up->rx_stop = 0;
+		pxa_uart_receive_dma_start(up);
+		up->ier = UART_IER_DMAE | UART_IER_UUE | UART_IER_RTOIE;
+		tasklet_init(&up->tklet, uart_task_action, (unsigned long)up);
+	} else {
+		up->ier = UART_IER_RLSI | UART_IER_RDI |
+			UART_IER_RTOIE | UART_IER_UUE;
+	}
+	serial_out(up, UART_IER, up->ier);
+
+	/*
+	 * And clear the interrupt registers again for luck.
+	 */
+	(void) serial_in(up, UART_LSR);
+	(void) serial_in(up, UART_RX);
+	(void) serial_in(up, UART_IIR);
+	(void) serial_in(up, UART_MSR);
+
+	return 0;
+}
+
+static void serial_pxa_shutdown(struct uart_port *port)
+{
+	struct uart_pxa_port *up = (struct uart_pxa_port *)port;
+	unsigned long flags;
+
+	flush_work(&up->uart_tx_lpm_work);
+
+	free_irq(up->port.irq, up);
+
+	if (up->dma_enable) {
+		tasklet_kill(&up->tklet);
+		uart_pxa_dma_uninit(up);
+	}
+
+	/*
+	 * Disable interrupts from this port
+	 */
+	up->ier = 0;
+	serial_out(up, UART_IER, 0);
+
+	spin_lock_irqsave(&up->port.lock, flags);
+	up->port.mctrl &= ~TIOCM_OUT2;
+	serial_pxa_set_mctrl(&up->port, up->port.mctrl);
+	spin_unlock_irqrestore(&up->port.lock, flags);
+
+	/*
+	 * Disable break condition and FIFOs
+	 */
+	serial_out(up, UART_LCR, serial_in(up, UART_LCR) & ~UART_LCR_SBC);
+	serial_out(up, UART_FCR, UART_FCR_ENABLE_FIFO |
+				  UART_FCR_CLEAR_RCVR |
+				  UART_FCR_CLEAR_XMIT);
+	serial_out(up, UART_FCR, 0);
+}
+
+static void
+serial_pxa_set_termios(struct uart_port *port, struct ktermios *termios,
+		       struct ktermios *old)
+{
+	struct uart_pxa_port *up = (struct uart_pxa_port *)port;
+	unsigned char cval, fcr = 0;
+	unsigned long flags;
+	unsigned int baud, quot = 0;
+	unsigned int dll;
+
+	switch (termios->c_cflag & CSIZE) {
+	case CS5:
+		cval = UART_LCR_WLEN5;
+		break;
+	case CS6:
+		cval = UART_LCR_WLEN6;
+		break;
+	case CS7:
+		cval = UART_LCR_WLEN7;
+		break;
+	default:
+	case CS8:
+		cval = UART_LCR_WLEN8;
+		break;
+	}
+
+	if (termios->c_cflag & CSTOPB)
+		cval |= UART_LCR_STOP;
+	if (termios->c_cflag & PARENB)
+		cval |= UART_LCR_PARITY;
+	if (!(termios->c_cflag & PARODD))
+		cval |= UART_LCR_EPAR;
+
+	/*
+	 * Ask the core to calculate the divisor for us.
+	 */
+	baud = uart_get_baud_rate(port, termios, old, 0, 921600*16*4/16);
+	if (baud > 921600) {
+		port->uartclk = 921600*16*4; /* 58.9823MHz as the clk src */
+		up->ier |= UART_IER_HSE;
+		if (B1500000 == (termios->c_cflag & B1500000))
+			quot = 2;
+		if (B3500000 == (termios->c_cflag & B3500000))
+			quot = 1;
+		if (quot == 0)
+			quot = uart_get_divisor(port, baud);
+	} else {
+		quot = uart_get_divisor(port, baud);
+		up->ier &= ~UART_IER_HSE;
+	}
+
+	if (up->dma_enable) {
+		fcr = UART_FCR_ENABLE_FIFO | UART_FCR_PXAR32;
+		fcr &= ~UART_FCR_PXA_BUS32;
+	} else {
+		if ((up->port.uartclk / quot) < (2400 * 16))
+			fcr = UART_FCR_ENABLE_FIFO | UART_FCR_PXAR1;
+		else if ((up->port.uartclk / quot) < (230400 * 16))
+			fcr = UART_FCR_ENABLE_FIFO | UART_FCR_PXAR8;
+		else
+			fcr = UART_FCR_ENABLE_FIFO | UART_FCR_PXAR32;
+	}
+
+	/*
+	 * Ok, we're now changing the port state.  Do it with
+	 * interrupts disabled.
+	 */
+	spin_lock_irqsave(&up->port.lock, flags);
+
+	/*
+	 * Ensure the port will be enabled.
+	 * This is required especially for serial console.
+	 */
+	up->ier |= UART_IER_UUE;
+
+	/*
+	 * Update the per-port timeout.
+	 */
+	uart_update_timeout(port, termios->c_cflag, baud);
+
+	up->port.read_status_mask = UART_LSR_OE | UART_LSR_THRE | UART_LSR_DR;
+	if (termios->c_iflag & INPCK)
+		up->port.read_status_mask |= UART_LSR_FE | UART_LSR_PE;
+	if (termios->c_iflag & (BRKINT | PARMRK))
+		up->port.read_status_mask |= UART_LSR_BI;
+
+	/*
+	 * Characters to ignore
+	 */
+	up->port.ignore_status_mask = 0;
+	if (termios->c_iflag & IGNPAR)
+		up->port.ignore_status_mask |= UART_LSR_PE | UART_LSR_FE;
+	if (termios->c_iflag & IGNBRK) {
+		up->port.ignore_status_mask |= UART_LSR_BI;
+		/*
+		 * If we're ignoring parity and break indicators,
+		 * ignore overruns too (for real raw support).
+		 */
+		if (termios->c_iflag & IGNPAR)
+			up->port.ignore_status_mask |= UART_LSR_OE;
+	}
+
+	/*
+	 * ignore all characters if CREAD is not set
+	 */
+	if ((termios->c_cflag & CREAD) == 0)
+		up->port.ignore_status_mask |= UART_LSR_DR;
+
+	/*
+	 * CTS flow control flag and modem status interrupts
+	 */
+	if (up->dma_enable) {
+		if (termios->c_cflag & CRTSCTS)
+			up->mcr |= UART_MCR_AFE;
+		else
+			up->mcr &= UART_MCR_AFE;
+	} else {
+		up->ier &= ~UART_IER_MSI;
+		if (UART_ENABLE_MS(&up->port, termios->c_cflag))
+			up->ier |= UART_IER_MSI;
+	}
+
+	serial_out(up, UART_IER, up->ier);
+
+	if (termios->c_cflag & CRTSCTS)
+		up->mcr |= UART_MCR_AFE;
+	else
+		up->mcr &= ~UART_MCR_AFE;
+
+	serial_out(up, UART_LCR, cval | UART_LCR_DLAB);	/* set DLAB */
+	serial_out(up, UART_DLL, quot & 0xff);		/* LS of divisor */
+
+	/*
+	 * work around Errata #75 according to Intel(R) PXA27x Processor Family
+	 * Specification Update (Nov 2005)
+	 */
+	dll = serial_in(up, UART_DLL);
+	WARN_ON(dll != (quot & 0xff));
+
+	serial_out(up, UART_DLM, quot >> 8);		/* MS of divisor */
+	serial_out(up, UART_LCR, cval);			/* reset DLAB */
+	up->lcr = cval;					/* Save LCR */
+	serial_pxa_set_mctrl(&up->port, up->port.mctrl);
+	serial_out(up, UART_FCR, fcr);
+	spin_unlock_irqrestore(&up->port.lock, flags);
+}
+
+static void
+serial_pxa_pm(struct uart_port *port, unsigned int state,
+	      unsigned int oldstate)
+{
+	struct uart_pxa_port *up = (struct uart_pxa_port *)port;
+
+	if (!state)
+		clk_enable(up->clk);
+	else
+		clk_disable(up->clk);
+}
+
+static void serial_pxa_release_port(struct uart_port *port)
+{
+}
+
+static int serial_pxa_request_port(struct uart_port *port)
+{
+	return 0;
+}
+
+static void serial_pxa_config_port(struct uart_port *port, int flags)
+{
+	struct uart_pxa_port *up = (struct uart_pxa_port *)port;
+	up->port.type = PORT_PXA;
+}
+
+static int
+serial_pxa_verify_port(struct uart_port *port, struct serial_struct *ser)
+{
+	/* we don't want the core code to modify any port params */
+	return -EINVAL;
+}
+
+static const char *
+serial_pxa_type(struct uart_port *port)
+{
+	struct uart_pxa_port *up = (struct uart_pxa_port *)port;
+	return up->name;
+}
+
+static struct uart_pxa_port *serial_pxa_ports[4];
+static struct uart_driver serial_pxa_reg;
+
+#ifdef CONFIG_SERIAL_PXA_CONSOLE
+
+#define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
+
+/*
+ *	Wait for transmitter & holding register to empty
+ */
+static inline void wait_for_xmitr(struct uart_pxa_port *up)
+{
+	unsigned int status, tmout = 10000;
+
+	/* Wait up to 10ms for the character(s) to be sent. */
+	do {
+		status = serial_in(up, UART_LSR);
+
+		if (status & UART_LSR_BI)
+			up->lsr_break_flag = UART_LSR_BI;
+
+		if (--tmout == 0)
+			break;
+		udelay(1);
+	} while ((status & BOTH_EMPTY) != BOTH_EMPTY);
+
+	/* Wait up to 1s for flow control if necessary */
+	if (up->port.flags & UPF_CONS_FLOW) {
+		tmout = 1000000;
+		while (--tmout &&
+		       ((serial_in(up, UART_MSR) & UART_MSR_CTS) == 0))
+			udelay(1);
+	}
+}
+
+static void serial_pxa_console_putchar(struct uart_port *port, int ch)
+{
+	struct uart_pxa_port *up = (struct uart_pxa_port *)port;
+
+	wait_for_xmitr(up);
+	serial_out(up, UART_TX, ch);
+}
+
+/*
+ * Print a string to the serial port trying not to disturb
+ * any possible real use of the port...
+ *
+ *	The console_lock must be held when we get here.
+ */
+static void
+serial_pxa_console_write(struct console *co, const char *s, unsigned int count)
+{
+	struct uart_pxa_port *up = serial_pxa_ports[co->index];
+	unsigned int ier;
+	unsigned long flags;
+	int locked = 1;
+
+	local_irq_save(flags);
+	if (up->port.sysrq)
+		locked = 0;
+	else if (oops_in_progress)
+		locked = spin_trylock(&up->port.lock);
+	else
+		spin_lock(&up->port.lock);
+
+	clk_enable(up->clk);
+
+	/*
+	 *	First save the IER then disable the interrupts
+	 */
+	ier = serial_in(up, UART_IER);
+	serial_out(up, UART_IER, UART_IER_UUE);
+
+	uart_console_write(&up->port, s, count, serial_pxa_console_putchar);
+
+	/*
+	 *	Finally, wait for transmitter to become empty
+	 *	and restore the IER
+	 */
+	wait_for_xmitr(up);
+	serial_out(up, UART_IER, ier);
+
+	clk_disable(up->clk);
+
+	if (locked)
+		spin_unlock(&up->port.lock);
+	local_irq_restore(flags);
+}
+
+static int __init
+serial_pxa_console_setup(struct console *co, char *options)
+{
+	struct uart_pxa_port *up;
+	int baud = 9600;
+	int bits = 8;
+	int parity = 'n';
+	int flow = 'n';
+
+	if (co->index == -1 || co->index >= serial_pxa_reg.nr)
+		co->index = 0;
+	up = serial_pxa_ports[co->index];
+	if (!up)
+		return -ENODEV;
+
+	if (options)
+		uart_parse_options(options, &baud, &parity, &bits, &flow);
+
+	return uart_set_options(&up->port, co, baud, parity, bits, flow);
+}
+
+static struct console serial_pxa_console = {
+	.name		= "ttyS",
+	.write		= serial_pxa_console_write,
+	.device		= uart_console_device,
+	.setup		= serial_pxa_console_setup,
+	.flags		= CON_PRINTBUFFER,
+	.index		= -1,
+	.data		= &serial_pxa_reg,
+};
+
+#define PXA_CONSOLE (&serial_pxa_console)
+#else
+#define PXA_CONSOLE NULL
+#endif
+
+struct uart_ops serial_pxa_pops = {
+	.tx_empty	= serial_pxa_tx_empty,
+	.set_mctrl	= serial_pxa_set_mctrl,
+	.get_mctrl	= serial_pxa_get_mctrl,
+	.stop_tx	= serial_pxa_stop_tx,
+	.start_tx	= serial_pxa_start_tx,
+	.stop_rx	= serial_pxa_stop_rx,
+	.enable_ms	= serial_pxa_enable_ms,
+	.break_ctl	= serial_pxa_break_ctl,
+	.startup	= serial_pxa_startup,
+	.shutdown	= serial_pxa_shutdown,
+	.set_termios	= serial_pxa_set_termios,
+	.pm		= serial_pxa_pm,
+	.type		= serial_pxa_type,
+	.release_port	= serial_pxa_release_port,
+	.request_port	= serial_pxa_request_port,
+	.config_port	= serial_pxa_config_port,
+	.verify_port	= serial_pxa_verify_port,
+};
+
+static struct uart_driver serial_pxa_reg = {
+	.owner		= THIS_MODULE,
+	.driver_name	= "PXA serial",
+	.dev_name	= "ttyS",
+	.major		= TTY_MAJOR,
+	.minor		= 64,
+	.nr		= 4,
+	.cons		= PXA_CONSOLE,
+};
+
+#ifdef CONFIG_PM
+static int serial_pxa_suspend(struct device *dev)
+{
+	struct uart_pxa_port *sport = dev_get_drvdata(dev);
+
+	if (sport && (sport->ier & UART_IER_DMAE)) {
+		int length = 0, sent = 0;
+		unsigned long flags;
+
+		local_irq_save(flags);
+		sport->tx_stop = 1;
+		sport->rx_stop = 1;
+		sport->data_len = 0;
+		if (dma_async_is_tx_complete(sport->txdma, sport->tx_cookie,
+					NULL, NULL) != DMA_SUCCESS) {
+			dmaengine_terminate_all(sport->txdma);
+			length = sport->tx_cnt;
+			sent = pxa_dmac_chan_get_src_ptr(sport->txdma) -
+							sport->txdma_addr_phys;
+			memcpy(sport->buf_save, sport->txdma_addr
+				 + sent, length);
+			sport->data_len = length;
+
+		}
+
+		if (dma_async_is_tx_complete(sport->rxdma, sport->rx_cookie,
+					NULL, NULL) != DMA_SUCCESS)
+			dmaengine_terminate_all(sport->rxdma);
+
+		pxa_uart_receive_dma(sport);
+
+		local_irq_restore(flags);
+	}
+
+	if (sport)
+		uart_suspend_port(&serial_pxa_reg, &sport->port);
+
+	return 0;
+}
+
+static int serial_pxa_resume(struct device *dev)
+{
+	struct uart_pxa_port *sport = dev_get_drvdata(dev);
+
+	if (sport)
+		uart_resume_port(&serial_pxa_reg, &sport->port);
+
+	if (sport && (sport->ier & UART_IER_DMAE)) {
+		if (sport->data_len > 0) {
+			memcpy(sport->txdma_addr, sport->buf_save,
+					sport->data_len);
+			pxa_uart_transmit_dma_start(sport,
+					sport->data_len);
+		} else
+			tasklet_schedule(&sport->tklet);
+
+		pxa_uart_receive_dma_start(sport);
+	}
+
+	return 0;
+}
+
+static const struct dev_pm_ops serial_pxa_pm_ops = {
+	.suspend	= serial_pxa_suspend,
+	.resume		= serial_pxa_resume,
+};
+#endif
+
+static void pxa_timer_handler(unsigned long data)
+{
+	struct uart_pxa_port *up = (struct uart_pxa_port *)data;
+#ifdef CONFIG_PXA95x
+	dvfm_enable_lowpower(up->dvfm_dev_idx[PXA_UART_RX]);
+#else
+	pm_qos_update_request(&up->qos_idle[PXA_UART_RX], PM_QOS_DEFAULT_VALUE);
+	wake_unlock(&up->idle_lock[PXA_UART_RX]);
+#endif
+}
+
+static void uart_tx_lpm_handler(struct work_struct *work)
+{
+	struct uart_pxa_port *up =
+	    container_of(work, struct uart_pxa_port, uart_tx_lpm_work);
+
+	/* Polling until TX FIFO is empty */
+	while (!(serial_in(up, UART_LSR) & UART_LSR_TEMT))
+		msleep(1);
+#ifdef CONFIG_PXA95x
+	dvfm_enable_lowpower(up->dvfm_dev_idx[PXA_UART_TX]);
+#else
+	pm_qos_update_request(&up->qos_idle[PXA_UART_TX], PM_QOS_DEFAULT_VALUE);
+	wake_unlock(&up->idle_lock[PXA_UART_TX]);
+#endif
+}
+
+#ifdef CONFIG_PXA95x
+
+extern void get_wakeup_source(pm_wakeup_src_t *);
+
+static void uart_rx_lpm_handler(struct work_struct *work)
+{
+	struct uart_pxa_port *up =
+	    container_of(work, struct uart_pxa_port, uart_rx_lpm_work);
+
+	mod_timer(&up->pxa_timer, jiffies + PXA_TIMER_TIMEOUT);
+	dvfm_disable_lowpower(up->dvfm_dev_idx[PXA_UART_RX]);
+}
+
+static int uart_notifier_freq(struct notifier_block *nb,
+				unsigned long val, void *data)
+{
+	struct dvfm_freqs *freqs = (struct dvfm_freqs *)data;
+	struct op_info *new = NULL;
+	struct dvfm_md_opt *opt;
+	pm_wakeup_src_t src;
+	struct uart_pxa_port *sport;
+
+	if (freqs)
+		new = &freqs->new_info;
+	else
+		return 0;
+
+	sport = container_of(nb, struct uart_pxa_port, notifier_freq_block);
+	if (val != DVFM_FREQ_POSTCHANGE)
+		return 0;
+
+	opt = new->op;
+	if ((opt->power_mode != POWER_MODE_D1) &&
+	    (opt->power_mode != POWER_MODE_D2) &&
+	    (opt->power_mode != POWER_MODE_CG))
+		return 0;
+
+	get_wakeup_source(&src);
+
+	if ((src.bits.uart1 && sport->port.irq == IRQ_FFUART) ||
+	    (src.bits.uart2 && sport->port.irq == IRQ_STUART)) {
+		schedule_work(&sport->uart_rx_lpm_work);
+	}
+
+	return 0;
+}
+#endif
+
+static int serial_pxa_probe(struct platform_device *dev)
+{
+	struct uart_pxa_port *sport;
+	struct resource *mmres, *irqres, *dmares;
+	int ret, i;
+	char dev_name[30];
+
+	mmres = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	irqres = platform_get_resource(dev, IORESOURCE_IRQ, 0);
+	if (!mmres || !irqres)
+		return -ENODEV;
+
+	sport = kzalloc(sizeof(struct uart_pxa_port), GFP_KERNEL);
+	if (!sport)
+		return -ENOMEM;
+
+	sport->clk = clk_get(&dev->dev, NULL);
+	if (IS_ERR(sport->clk)) {
+		ret = PTR_ERR(sport->clk);
+		goto err_free;
+	}
+
+	sport->port.type = PORT_PXA;
+	sport->port.iotype = UPIO_MEM;
+	sport->port.mapbase = mmres->start;
+	sport->port.irq = irqres->start;
+	sport->port.fifosize = 64;
+	sport->port.ops = &serial_pxa_pops;
+	sport->port.line = dev->id;
+	sport->port.dev = &dev->dev;
+	sport->port.flags = UPF_IOREMAP | UPF_BOOT_AUTOCONF;
+	sport->port.uartclk = clk_get_rate(sport->clk);
+
+	switch (dev->id) {
+	case 0:
+		sport->name = "FFUART";
+		break;
+	case 1:
+		sport->name = "BTUART";
+		break;
+	case 2:
+		sport->name = "STUART";
+		break;
+	case 3:
+		sport->name = "HWUART";
+		break;
+	default:
+		sport->name = "???";
+		break;
+	}
+
+	sport->rxdrcmr = 0;
+	sport->txdrcmr = 0;
+	sport->txdma = 0;
+	sport->rxdma = 0;
+	sport->txdma_addr = NULL;
+	sport->rxdma_addr = NULL;
+	sport->dma_enable = 0;
+
+	if (uart_dma) {
+		/* Get Rx DMA mapping register */
+		dmares = platform_get_resource(dev, IORESOURCE_DMA, 0);
+		if (dmares)
+			sport->rxdrcmr = dmares->start;
+
+		/* Get Tx DMA mapping register */
+		dmares = platform_get_resource(dev, IORESOURCE_DMA, 1);
+		if (dmares)
+			sport->txdrcmr = dmares->start;
+
+		if (sport->rxdrcmr && sport->txdrcmr)
+			sport->dma_enable = 1;
+	}
+
+	for (i = 0; i < 2; i++) {
+		sprintf(dev_name, "%s.%s", sport->name,
+				(i == PXA_UART_RX) ? "rx" : "tx");
+
+#ifdef CONFIG_PXA95x
+		sport->dvfm_dev_idx[i] = -1;
+		dvfm_register(dev_name, &(sport->dvfm_dev_idx[i]));
+#else
+		pm_qos_add_request(&sport->qos_idle[i], PM_QOS_CPU_DMA_LATENCY,
+				PM_QOS_DEFAULT_VALUE);
+		wake_lock_init(&sport->idle_lock[i], WAKE_LOCK_IDLE,
+				(const char *)dev_name);
+#endif
+	}
+
+#ifdef CONFIG_PXA95x
+	sport->notifier_freq_block.notifier_call = uart_notifier_freq;
+	dvfm_register_notifier(&sport->notifier_freq_block,
+				DVFM_FREQUENCY_NOTIFIER);
+	INIT_WORK(&sport->uart_rx_lpm_work, uart_rx_lpm_handler);
+#endif
+	INIT_WORK(&sport->uart_tx_lpm_work, uart_tx_lpm_handler);
+
+	init_timer(&sport->pxa_timer);
+	sport->pxa_timer.function = pxa_timer_handler;
+	sport->pxa_timer.data = (long)sport;
+
+	sport->port.membase = ioremap(mmres->start,
+			mmres->end - mmres->start + 1);
+	if (!sport->port.membase) {
+		ret = -ENOMEM;
+		goto err_clk;
+	}
+
+	serial_pxa_ports[dev->id] = sport;
+
+	uart_add_one_port(&serial_pxa_reg, &sport->port);
+	platform_set_drvdata(dev, sport);
+
+	return 0;
+
+ err_clk:
+#ifdef CONFIG_PXA95x
+	dvfm_unregister(sport->name, &(sport->dvfm_dev_idx[PXA_UART_RX]));
+	dvfm_unregister(sport->name, &(sport->dvfm_dev_idx[PXA_UART_TX]));
+	dvfm_unregister_notifier(&sport->notifier_freq_block,
+			DVFM_FREQUENCY_NOTIFIER);
+#else
+	pm_qos_remove_request(&sport->qos_idle[PXA_UART_RX]);
+	pm_qos_remove_request(&sport->qos_idle[PXA_UART_TX]);
+	wake_lock_destroy(&sport->idle_lock[PXA_UART_RX]);
+	wake_lock_destroy(&sport->idle_lock[PXA_UART_TX]);
+#endif
+	clk_put(sport->clk);
+ err_free:
+	kfree(sport);
+	return ret;
+}
+
+static int serial_pxa_remove(struct platform_device *dev)
+{
+	struct uart_pxa_port *sport = platform_get_drvdata(dev);
+
+#ifdef CONFIG_PXA95x
+	dvfm_unregister(sport->name, &(sport->dvfm_dev_idx[PXA_UART_RX]));
+	dvfm_unregister(sport->name, &(sport->dvfm_dev_idx[PXA_UART_TX]));
+	dvfm_unregister_notifier(&sport->notifier_freq_block,
+			DVFM_FREQUENCY_NOTIFIER);
+#else
+	pm_qos_remove_request(&sport->qos_idle[PXA_UART_RX]);
+	pm_qos_remove_request(&sport->qos_idle[PXA_UART_TX]);
+	wake_lock_destroy(&sport->idle_lock[PXA_UART_RX]);
+	wake_lock_destroy(&sport->idle_lock[PXA_UART_TX]);
+#endif
+
+	platform_set_drvdata(dev, NULL);
+
+	uart_remove_one_port(&serial_pxa_reg, &sport->port);
+	clk_put(sport->clk);
+	kfree(sport);
+	serial_pxa_ports[dev->id] = NULL;
+
+	return 0;
+}
+
+static struct platform_driver serial_pxa_driver = {
+	.probe          = serial_pxa_probe,
+	.remove         = serial_pxa_remove,
+
+	.driver		= {
+		.name	= "pxa2xx-uart",
+		.owner	= THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm	= &serial_pxa_pm_ops,
+#endif
+	},
+};
+
+int __init serial_pxa_init(void)
+{
+	int ret;
+
+	ret = uart_register_driver(&serial_pxa_reg);
+	if (ret != 0)
+		return ret;
+
+	ret = platform_driver_register(&serial_pxa_driver);
+	if (ret != 0)
+		uart_unregister_driver(&serial_pxa_reg);
+
+	return ret;
+}
+
+void __exit serial_pxa_exit(void)
+{
+	platform_driver_unregister(&serial_pxa_driver);
+	uart_unregister_driver(&serial_pxa_reg);
+}
+
+module_init(serial_pxa_init);
+module_exit(serial_pxa_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pxa2xx-uart");
-- 
1.7.0.4

