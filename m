Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab2HUJXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:23:14 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:53961 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755311Ab2HUJUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:20:11 -0400
From: Felipe Balbi <balbi@ti.com>
To: alan@linux.intel.com
Cc: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [RFC/PATCH 04/13] serial: omap: don't access the platform_device
Date: Tue, 21 Aug 2012 12:15:46 +0300
Message-Id: <1345540555-24359-5-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1345540555-24359-1-git-send-email-balbi@ti.com>
References: <1345540555-24359-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver doesn't need to know about its platform_device.

Everything the driver needs can be done through the
struct device pointer. In case we need to use the
OMAP-specific PM function pointers, those can make
sure to find the device's platform_device pointer
so they can find the struct omap_device through
pdev->archdata field.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/serial.c                  |  15 ++--
 arch/arm/plat-omap/include/plat/omap-serial.h |  10 +--
 drivers/tty/serial/omap-serial.c              | 124 +++++++++++++-------------
 3 files changed, 76 insertions(+), 73 deletions(-)

diff --git a/arch/arm/mach-omap2/serial.c b/arch/arm/mach-omap2/serial.c
index c1b93c7..8f07841 100644
--- a/arch/arm/mach-omap2/serial.c
+++ b/arch/arm/mach-omap2/serial.c
@@ -81,8 +81,9 @@ static struct omap_uart_port_info omap_serial_default_info[] __initdata = {
 };
 
 #ifdef CONFIG_PM
-static void omap_uart_enable_wakeup(struct platform_device *pdev, bool enable)
+static void omap_uart_enable_wakeup(struct device *dev, bool enable)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct omap_device *od = to_omap_device(pdev);
 
 	if (!od)
@@ -99,15 +100,17 @@ static void omap_uart_enable_wakeup(struct platform_device *pdev, bool enable)
  * in Smartidle Mode When Configured for DMA Operations.
  * WA: configure uart in force idle mode.
  */
-static void omap_uart_set_noidle(struct platform_device *pdev)
+static void omap_uart_set_noidle(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct omap_device *od = to_omap_device(pdev);
 
 	omap_hwmod_set_slave_idlemode(od->hwmods[0], HWMOD_IDLEMODE_NO);
 }
 
-static void omap_uart_set_smartidle(struct platform_device *pdev)
+static void omap_uart_set_smartidle(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct omap_device *od = to_omap_device(pdev);
 	u8 idlemode;
 
@@ -120,10 +123,10 @@ static void omap_uart_set_smartidle(struct platform_device *pdev)
 }
 
 #else
-static void omap_uart_enable_wakeup(struct platform_device *pdev, bool enable)
+static void omap_uart_enable_wakeup(struct device *dev, bool enable)
 {}
-static void omap_uart_set_noidle(struct platform_device *pdev) {}
-static void omap_uart_set_smartidle(struct platform_device *pdev) {}
+static void omap_uart_set_noidle(struct device *dev) {}
+static void omap_uart_set_smartidle(struct device *dev) {}
 #endif /* CONFIG_PM */
 
 #ifdef CONFIG_OMAP_MUX
diff --git a/arch/arm/plat-omap/include/plat/omap-serial.h b/arch/arm/plat-omap/include/plat/omap-serial.h
index f3b35d9..743ac80 100644
--- a/arch/arm/plat-omap/include/plat/omap-serial.h
+++ b/arch/arm/plat-omap/include/plat/omap-serial.h
@@ -18,7 +18,7 @@
 #define __OMAP_SERIAL_H__
 
 #include <linux/serial_core.h>
-#include <linux/platform_device.h>
+#include <linux/device.h>
 #include <linux/pm_qos.h>
 
 #include <plat/mux.h>
@@ -71,9 +71,9 @@ struct omap_uart_port_info {
 	unsigned int		dma_rx_poll_rate;
 
 	int (*get_context_loss_count)(struct device *);
-	void (*set_forceidle)(struct platform_device *);
-	void (*set_noidle)(struct platform_device *);
-	void (*enable_wakeup)(struct platform_device *, bool);
+	void (*set_forceidle)(struct device *);
+	void (*set_noidle)(struct device *);
+	void (*enable_wakeup)(struct device *, bool);
 };
 
 struct uart_omap_dma {
@@ -105,7 +105,7 @@ struct uart_omap_dma {
 struct uart_omap_port {
 	struct uart_port	port;
 	struct uart_omap_dma	uart_dma;
-	struct platform_device	*pdev;
+	struct device		*dev;
 
 	unsigned char		ier;
 	unsigned char		lcr;
diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index c3e6fa0..fb81366 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -103,36 +103,36 @@ static inline void serial_omap_clear_fifos(struct uart_omap_port *up)
 
 static int serial_omap_get_context_loss_count(struct uart_omap_port *up)
 {
-	struct omap_uart_port_info *pdata = up->pdev->dev.platform_data;
+	struct omap_uart_port_info *pdata = up->dev->platform_data;
 
 	if (!pdata->get_context_loss_count)
 		return 0;
 
-	return pdata->get_context_loss_count(&up->pdev->dev);
+	return pdata->get_context_loss_count(up->dev);
 }
 
 static void serial_omap_set_forceidle(struct uart_omap_port *up)
 {
-	struct omap_uart_port_info *pdata = up->pdev->dev.platform_data;
+	struct omap_uart_port_info *pdata = up->dev->platform_data;
 
 	if (pdata->set_forceidle)
-		pdata->set_forceidle(up->pdev);
+		pdata->set_forceidle(up->dev);
 }
 
 static void serial_omap_set_noidle(struct uart_omap_port *up)
 {
-	struct omap_uart_port_info *pdata = up->pdev->dev.platform_data;
+	struct omap_uart_port_info *pdata = up->dev->platform_data;
 
 	if (pdata->set_noidle)
-		pdata->set_noidle(up->pdev);
+		pdata->set_noidle(up->dev);
 }
 
 static void serial_omap_enable_wakeup(struct uart_omap_port *up, bool enable)
 {
-	struct omap_uart_port_info *pdata = up->pdev->dev.platform_data;
+	struct omap_uart_port_info *pdata = up->dev->platform_data;
 
 	if (pdata->enable_wakeup)
-		pdata->enable_wakeup(up->pdev, enable);
+		pdata->enable_wakeup(up->dev, enable);
 }
 
 /*
@@ -168,8 +168,8 @@ static void serial_omap_stop_rxdma(struct uart_omap_port *up)
 		omap_free_dma(up->uart_dma.rx_dma_channel);
 		up->uart_dma.rx_dma_channel = OMAP_UART_DMA_CH_FREE;
 		up->uart_dma.rx_dma_used = false;
-		pm_runtime_mark_last_busy(&up->pdev->dev);
-		pm_runtime_put_autosuspend(&up->pdev->dev);
+		pm_runtime_mark_last_busy(up->dev);
+		pm_runtime_put_autosuspend(up->dev);
 	}
 }
 
@@ -179,16 +179,16 @@ static void serial_omap_enable_ms(struct uart_port *port)
 
 	dev_dbg(up->port.dev, "serial_omap_enable_ms+%d\n", up->port.line);
 
-	pm_runtime_get_sync(&up->pdev->dev);
+	pm_runtime_get_sync(up->dev);
 	up->ier |= UART_IER_MSI;
 	serial_out(up, UART_IER, up->ier);
-	pm_runtime_put(&up->pdev->dev);
+	pm_runtime_put(up->dev);
 }
 
 static void serial_omap_stop_tx(struct uart_port *port)
 {
 	struct uart_omap_port *up = to_uart_omap_port(port);
-	struct omap_uart_port_info *pdata = up->pdev->dev.platform_data;
+	struct omap_uart_port_info *pdata = up->dev->platform_data;
 
 	if (up->use_dma &&
 		up->uart_dma.tx_dma_channel != OMAP_UART_DMA_CH_FREE) {
@@ -201,11 +201,11 @@ static void serial_omap_stop_tx(struct uart_port *port)
 		omap_stop_dma(up->uart_dma.tx_dma_channel);
 		omap_free_dma(up->uart_dma.tx_dma_channel);
 		up->uart_dma.tx_dma_channel = OMAP_UART_DMA_CH_FREE;
-		pm_runtime_mark_last_busy(&up->pdev->dev);
-		pm_runtime_put_autosuspend(&up->pdev->dev);
+		pm_runtime_mark_last_busy(up->dev);
+		pm_runtime_put_autosuspend(up->dev);
 	}
 
-	pm_runtime_get_sync(&up->pdev->dev);
+	pm_runtime_get_sync(up->dev);
 	if (up->ier & UART_IER_THRI) {
 		up->ier &= ~UART_IER_THRI;
 		serial_out(up, UART_IER, up->ier);
@@ -214,22 +214,22 @@ static void serial_omap_stop_tx(struct uart_port *port)
 	if (!up->use_dma && pdata)
 		serial_omap_set_forceidle(up);
 
-	pm_runtime_mark_last_busy(&up->pdev->dev);
-	pm_runtime_put_autosuspend(&up->pdev->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 }
 
 static void serial_omap_stop_rx(struct uart_port *port)
 {
 	struct uart_omap_port *up = to_uart_omap_port(port);
 
-	pm_runtime_get_sync(&up->pdev->dev);
+	pm_runtime_get_sync(up->dev);
 	if (up->use_dma)
 		serial_omap_stop_rxdma(up);
 	up->ier &= ~UART_IER_RLSI;
 	up->port.read_status_mask &= ~UART_LSR_DR;
 	serial_out(up, UART_IER, up->ier);
-	pm_runtime_mark_last_busy(&up->pdev->dev);
-	pm_runtime_put_autosuspend(&up->pdev->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 }
 
 static inline void receive_chars(struct uart_omap_port *up,
@@ -347,11 +347,11 @@ static void serial_omap_start_tx(struct uart_port *port)
 	int ret = 0;
 
 	if (!up->use_dma) {
-		pm_runtime_get_sync(&up->pdev->dev);
+		pm_runtime_get_sync(up->dev);
 		serial_omap_enable_ier_thri(up);
 		serial_omap_set_noidle(up);
-		pm_runtime_mark_last_busy(&up->pdev->dev);
-		pm_runtime_put_autosuspend(&up->pdev->dev);
+		pm_runtime_mark_last_busy(up->dev);
+		pm_runtime_put_autosuspend(up->dev);
 		return;
 	}
 
@@ -361,7 +361,7 @@ static void serial_omap_start_tx(struct uart_port *port)
 	xmit = &up->port.state->xmit;
 
 	if (up->uart_dma.tx_dma_channel == OMAP_UART_DMA_CH_FREE) {
-		pm_runtime_get_sync(&up->pdev->dev);
+		pm_runtime_get_sync(up->dev);
 		ret = omap_request_dma(up->uart_dma.uart_dma_tx,
 				"UART Tx DMA",
 				(void *)uart_tx_dma_callback, up,
@@ -444,11 +444,11 @@ static inline irqreturn_t serial_omap_irq(int irq, void *dev_id)
 	unsigned int iir, lsr;
 	unsigned long flags;
 
-	pm_runtime_get_sync(&up->pdev->dev);
+	pm_runtime_get_sync(up->dev);
 	iir = serial_in(up, UART_IIR);
 	if (iir & UART_IIR_NO_INT) {
-		pm_runtime_mark_last_busy(&up->pdev->dev);
-		pm_runtime_put_autosuspend(&up->pdev->dev);
+		pm_runtime_mark_last_busy(up->dev);
+		pm_runtime_put_autosuspend(up->dev);
 		return IRQ_HANDLED;
 	}
 
@@ -472,8 +472,8 @@ static inline irqreturn_t serial_omap_irq(int irq, void *dev_id)
 		transmit_chars(up);
 
 	spin_unlock_irqrestore(&up->port.lock, flags);
-	pm_runtime_mark_last_busy(&up->pdev->dev);
-	pm_runtime_put_autosuspend(&up->pdev->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 
 	up->port_activity = jiffies;
 	return IRQ_HANDLED;
@@ -485,12 +485,12 @@ static unsigned int serial_omap_tx_empty(struct uart_port *port)
 	unsigned long flags = 0;
 	unsigned int ret = 0;
 
-	pm_runtime_get_sync(&up->pdev->dev);
+	pm_runtime_get_sync(up->dev);
 	dev_dbg(up->port.dev, "serial_omap_tx_empty+%d\n", up->port.line);
 	spin_lock_irqsave(&up->port.lock, flags);
 	ret = serial_in(up, UART_LSR) & UART_LSR_TEMT ? TIOCSER_TEMT : 0;
 	spin_unlock_irqrestore(&up->port.lock, flags);
-	pm_runtime_put(&up->pdev->dev);
+	pm_runtime_put(up->dev);
 	return ret;
 }
 
@@ -500,9 +500,9 @@ static unsigned int serial_omap_get_mctrl(struct uart_port *port)
 	unsigned int status;
 	unsigned int ret = 0;
 
-	pm_runtime_get_sync(&up->pdev->dev);
+	pm_runtime_get_sync(up->dev);
 	status = check_modem_status(up);
-	pm_runtime_put(&up->pdev->dev);
+	pm_runtime_put(up->dev);
 
 	dev_dbg(up->port.dev, "serial_omap_get_mctrl+%d\n", up->port.line);
 
@@ -534,11 +534,11 @@ static void serial_omap_set_mctrl(struct uart_port *port, unsigned int mctrl)
 	if (mctrl & TIOCM_LOOP)
 		mcr |= UART_MCR_LOOP;
 
-	pm_runtime_get_sync(&up->pdev->dev);
+	pm_runtime_get_sync(up->dev);
 	up->mcr = serial_in(up, UART_MCR);
 	up->mcr |= mcr;
 	serial_out(up, UART_MCR, up->mcr);
-	pm_runtime_put(&up->pdev->dev);
+	pm_runtime_put(up->dev);
 }
 
 static void serial_omap_break_ctl(struct uart_port *port, int break_state)
@@ -547,7 +547,7 @@ static void serial_omap_break_ctl(struct uart_port *port, int break_state)
 	unsigned long flags = 0;
 
 	dev_dbg(up->port.dev, "serial_omap_break_ctl+%d\n", up->port.line);
-	pm_runtime_get_sync(&up->pdev->dev);
+	pm_runtime_get_sync(up->dev);
 	spin_lock_irqsave(&up->port.lock, flags);
 	if (break_state == -1)
 		up->lcr |= UART_LCR_SBC;
@@ -555,7 +555,7 @@ static void serial_omap_break_ctl(struct uart_port *port, int break_state)
 		up->lcr &= ~UART_LCR_SBC;
 	serial_out(up, UART_LCR, up->lcr);
 	spin_unlock_irqrestore(&up->port.lock, flags);
-	pm_runtime_put(&up->pdev->dev);
+	pm_runtime_put(up->dev);
 }
 
 static int serial_omap_startup(struct uart_port *port)
@@ -574,7 +574,7 @@ static int serial_omap_startup(struct uart_port *port)
 
 	dev_dbg(up->port.dev, "serial_omap_startup+%d\n", up->port.line);
 
-	pm_runtime_get_sync(&up->pdev->dev);
+	pm_runtime_get_sync(up->dev);
 	/*
 	 * Clear the FIFO buffers and disable them.
 	 * (they will be reenabled in set_termios())
@@ -630,8 +630,8 @@ static int serial_omap_startup(struct uart_port *port)
 	/* Enable module level wake up */
 	serial_out(up, UART_OMAP_WER, OMAP_UART_WER_MOD_WKUP);
 
-	pm_runtime_mark_last_busy(&up->pdev->dev);
-	pm_runtime_put_autosuspend(&up->pdev->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 	up->port_activity = jiffies;
 	return 0;
 }
@@ -643,7 +643,7 @@ static void serial_omap_shutdown(struct uart_port *port)
 
 	dev_dbg(up->port.dev, "serial_omap_shutdown+%d\n", up->port.line);
 
-	pm_runtime_get_sync(&up->pdev->dev);
+	pm_runtime_get_sync(up->dev);
 	/*
 	 * Disable interrupts from this port
 	 */
@@ -678,7 +678,7 @@ static void serial_omap_shutdown(struct uart_port *port)
 		up->uart_dma.rx_buf = NULL;
 	}
 
-	pm_runtime_put(&up->pdev->dev);
+	pm_runtime_put(up->dev);
 	free_irq(up->port.irq, up);
 }
 
@@ -807,7 +807,7 @@ serial_omap_set_termios(struct uart_port *port, struct ktermios *termios,
 	 * Ok, we're now changing the port state. Do it with
 	 * interrupts disabled.
 	 */
-	pm_runtime_get_sync(&up->pdev->dev);
+	pm_runtime_get_sync(up->dev);
 	spin_lock_irqsave(&up->port.lock, flags);
 
 	/*
@@ -956,7 +956,7 @@ serial_omap_set_termios(struct uart_port *port, struct ktermios *termios,
 	serial_omap_configure_xonxoff(up, termios);
 
 	spin_unlock_irqrestore(&up->port.lock, flags);
-	pm_runtime_put(&up->pdev->dev);
+	pm_runtime_put(up->dev);
 	dev_dbg(up->port.dev, "serial_omap_set_termios+%d\n", up->port.line);
 }
 
@@ -969,7 +969,7 @@ serial_omap_pm(struct uart_port *port, unsigned int state,
 
 	dev_dbg(up->port.dev, "serial_omap_pm+%d\n", up->port.line);
 
-	pm_runtime_get_sync(&up->pdev->dev);
+	pm_runtime_get_sync(up->dev);
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
 	efr = serial_in(up, UART_EFR);
 	serial_out(up, UART_EFR, efr | UART_EFR_ECB);
@@ -980,14 +980,14 @@ serial_omap_pm(struct uart_port *port, unsigned int state,
 	serial_out(up, UART_EFR, efr);
 	serial_out(up, UART_LCR, 0);
 
-	if (!device_may_wakeup(&up->pdev->dev)) {
+	if (!device_may_wakeup(up->dev)) {
 		if (!state)
-			pm_runtime_forbid(&up->pdev->dev);
+			pm_runtime_forbid(up->dev);
 		else
-			pm_runtime_allow(&up->pdev->dev);
+			pm_runtime_allow(up->dev);
 	}
 
-	pm_runtime_put(&up->pdev->dev);
+	pm_runtime_put(up->dev);
 }
 
 static void serial_omap_release_port(struct uart_port *port)
@@ -1066,10 +1066,10 @@ static void serial_omap_poll_put_char(struct uart_port *port, unsigned char ch)
 {
 	struct uart_omap_port *up = to_uart_omap_port(port);
 
-	pm_runtime_get_sync(&up->pdev->dev);
+	pm_runtime_get_sync(up->dev);
 	wait_for_xmitr(up);
 	serial_out(up, UART_TX, ch);
-	pm_runtime_put(&up->pdev->dev);
+	pm_runtime_put(up->dev);
 }
 
 static int serial_omap_poll_get_char(struct uart_port *port)
@@ -1077,13 +1077,13 @@ static int serial_omap_poll_get_char(struct uart_port *port)
 	struct uart_omap_port *up = to_uart_omap_port(port);
 	unsigned int status;
 
-	pm_runtime_get_sync(&up->pdev->dev);
+	pm_runtime_get_sync(up->dev);
 	status = serial_in(up, UART_LSR);
 	if (!(status & UART_LSR_DR))
 		return NO_POLL_CHAR;
 
 	status = serial_in(up, UART_RX);
-	pm_runtime_put(&up->pdev->dev);
+	pm_runtime_put(up->dev);
 	return status;
 }
 
@@ -1112,7 +1112,7 @@ serial_omap_console_write(struct console *co, const char *s,
 	unsigned int ier;
 	int locked = 1;
 
-	pm_runtime_get_sync(&up->pdev->dev);
+	pm_runtime_get_sync(up->dev);
 
 	local_irq_save(flags);
 	if (up->port.sysrq)
@@ -1146,8 +1146,8 @@ serial_omap_console_write(struct console *co, const char *s,
 	if (up->msr_saved_flags)
 		check_modem_status(up);
 
-	pm_runtime_mark_last_busy(&up->pdev->dev);
-	pm_runtime_put_autosuspend(&up->pdev->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 	if (locked)
 		spin_unlock(&up->port.lock);
 	local_irq_restore(flags);
@@ -1309,7 +1309,7 @@ static int serial_omap_start_rxdma(struct uart_omap_port *up)
 	int ret = 0;
 
 	if (up->uart_dma.rx_dma_channel == -1) {
-		pm_runtime_get_sync(&up->pdev->dev);
+		pm_runtime_get_sync(up->dev);
 		ret = omap_request_dma(up->uart_dma.uart_dma_rx,
 				"UART Rx DMA",
 				(void *)uart_rx_dma_callback, up,
@@ -1421,7 +1421,7 @@ static void omap_serial_fill_features_erratas(struct uart_omap_port *up)
 		minor = (mvr & OMAP_UART_MVR_MIN_MASK);
 		break;
 	default:
-		dev_warn(&up->pdev->dev,
+		dev_warn(up->dev,
 			"Unknown %s revision, defaulting to highest\n",
 			up->name);
 		/* highest possible revision */
@@ -1502,7 +1502,7 @@ static int serial_omap_probe(struct platform_device *pdev)
 	if (!up)
 		return -ENOMEM;
 
-	up->pdev = pdev;
+	up->dev = &pdev->dev;
 	up->port.dev = &pdev->dev;
 	up->port.type = PORT_OMAP;
 	up->port.iotype = UPIO_MEM;
@@ -1599,7 +1599,7 @@ static int serial_omap_remove(struct platform_device *dev)
 	struct uart_omap_port *up = platform_get_drvdata(dev);
 
 	if (up) {
-		pm_runtime_disable(&up->pdev->dev);
+		pm_runtime_disable(up->dev);
 		uart_remove_one_port(&serial_omap_reg, &up->port);
 		pm_qos_remove_request(&up->pm_qos_request);
 	}
@@ -1634,7 +1634,7 @@ static void serial_omap_mdr1_errataset(struct uart_omap_port *up, u8 mdr1)
 		timeout--;
 		if (!timeout) {
 			/* Should *never* happen. we warn and carry on */
-			dev_crit(&up->pdev->dev, "Errata i202: timedout %x\n",
+			dev_crit(up->dev, "Errata i202: timedout %x\n",
 						serial_in(up, UART_LSR));
 			break;
 		}
-- 
1.7.12.rc3

