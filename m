Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826Ab2HWKha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:37:30 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:42134 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933749Ab2HWKhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:37:18 -0400
From: Felipe Balbi <balbi@ti.com>
To: alan@linux.intel.com
Cc: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v3 04/23] serial: omap: drop DMA support
Date: Thu, 23 Aug 2012 13:32:44 +0300
Message-Id: <1345717983-18179-5-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1345717983-18179-1-git-send-email-balbi@ti.com>
References: <1345717983-18179-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current support is known to be broken and
a later patch will come re-adding it using
dma engine API.

Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 330 ++-------------------------------------
 1 file changed, 12 insertions(+), 318 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 6ab3582..16808b6 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -33,14 +33,12 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/io.h>
-#include <linux/dma-mapping.h>
 #include <linux/clk.h>
 #include <linux/serial_core.h>
 #include <linux/irq.h>
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
 
-#include <plat/dma.h>
 #include <plat/dmtimer.h>
 #include <plat/omap-serial.h>
 
@@ -74,9 +72,6 @@
 static struct uart_omap_port *ui[OMAP_MAX_HSUART_PORTS];
 
 /* Forward declaration of functions */
-static void uart_tx_dma_callback(int lch, u16 ch_status, void *data);
-static void serial_omap_rxdma_poll(unsigned long uart_no);
-static int serial_omap_start_rxdma(struct uart_omap_port *up);
 static void serial_omap_mdr1_errataset(struct uart_omap_port *up, u8 mdr1);
 
 static struct workqueue_struct *serial_omap_uart_wq;
@@ -160,19 +155,6 @@ serial_omap_get_divisor(struct uart_port *port, unsigned int baud)
 	return port->uartclk/(baud * divisor);
 }
 
-static void serial_omap_stop_rxdma(struct uart_omap_port *up)
-{
-	if (up->uart_dma.rx_dma_used) {
-		del_timer(&up->uart_dma.rx_timer);
-		omap_stop_dma(up->uart_dma.rx_dma_channel);
-		omap_free_dma(up->uart_dma.rx_dma_channel);
-		up->uart_dma.rx_dma_channel = OMAP_UART_DMA_CH_FREE;
-		up->uart_dma.rx_dma_used = false;
-		pm_runtime_mark_last_busy(up->dev);
-		pm_runtime_put_autosuspend(up->dev);
-	}
-}
-
 static void serial_omap_enable_ms(struct uart_port *port)
 {
 	struct uart_omap_port *up = to_uart_omap_port(port);
@@ -188,22 +170,6 @@ static void serial_omap_enable_ms(struct uart_port *port)
 static void serial_omap_stop_tx(struct uart_port *port)
 {
 	struct uart_omap_port *up = to_uart_omap_port(port);
-	struct omap_uart_port_info *pdata = up->dev->platform_data;
-
-	if (up->use_dma &&
-		up->uart_dma.tx_dma_channel != OMAP_UART_DMA_CH_FREE) {
-		/*
-		 * Check if dma is still active. If yes do nothing,
-		 * return. Else stop dma
-		 */
-		if (omap_get_dma_active_status(up->uart_dma.tx_dma_channel))
-			return;
-		omap_stop_dma(up->uart_dma.tx_dma_channel);
-		omap_free_dma(up->uart_dma.tx_dma_channel);
-		up->uart_dma.tx_dma_channel = OMAP_UART_DMA_CH_FREE;
-		pm_runtime_mark_last_busy(up->dev);
-		pm_runtime_put_autosuspend(up->dev);
-	}
 
 	pm_runtime_get_sync(up->dev);
 	if (up->ier & UART_IER_THRI) {
@@ -211,8 +177,7 @@ static void serial_omap_stop_tx(struct uart_port *port)
 		serial_out(up, UART_IER, up->ier);
 	}
 
-	if (!up->use_dma && pdata)
-		serial_omap_set_forceidle(up);
+	serial_omap_set_forceidle(up);
 
 	pm_runtime_mark_last_busy(up->dev);
 	pm_runtime_put_autosuspend(up->dev);
@@ -223,8 +188,6 @@ static void serial_omap_stop_rx(struct uart_port *port)
 	struct uart_omap_port *up = to_uart_omap_port(port);
 
 	pm_runtime_get_sync(up->dev);
-	if (up->use_dma)
-		serial_omap_stop_rxdma(up);
 	up->ier &= ~UART_IER_RLSI;
 	up->port.read_status_mask &= ~UART_LSR_DR;
 	serial_out(up, UART_IER, up->ier);
@@ -342,67 +305,12 @@ static inline void serial_omap_enable_ier_thri(struct uart_omap_port *up)
 static void serial_omap_start_tx(struct uart_port *port)
 {
 	struct uart_omap_port *up = to_uart_omap_port(port);
-	struct circ_buf *xmit;
-	unsigned int start;
-	int ret = 0;
-
-	if (!up->use_dma) {
-		pm_runtime_get_sync(up->dev);
-		serial_omap_enable_ier_thri(up);
-		serial_omap_set_noidle(up);
-		pm_runtime_mark_last_busy(up->dev);
-		pm_runtime_put_autosuspend(up->dev);
-		return;
-	}
-
-	if (up->uart_dma.tx_dma_used)
-		return;
-
-	xmit = &up->port.state->xmit;
-
-	if (up->uart_dma.tx_dma_channel == OMAP_UART_DMA_CH_FREE) {
-		pm_runtime_get_sync(up->dev);
-		ret = omap_request_dma(up->uart_dma.uart_dma_tx,
-				"UART Tx DMA",
-				(void *)uart_tx_dma_callback, up,
-				&(up->uart_dma.tx_dma_channel));
 
-		if (ret < 0) {
-			serial_omap_enable_ier_thri(up);
-			return;
-		}
-	}
-	spin_lock(&(up->uart_dma.tx_lock));
-	up->uart_dma.tx_dma_used = true;
-	spin_unlock(&(up->uart_dma.tx_lock));
-
-	start = up->uart_dma.tx_buf_dma_phys +
-				(xmit->tail & (UART_XMIT_SIZE - 1));
-
-	up->uart_dma.tx_buf_size = uart_circ_chars_pending(xmit);
-	/*
-	 * It is a circular buffer. See if the buffer has wounded back.
-	 * If yes it will have to be transferred in two separate dma
-	 * transfers
-	 */
-	if (start + up->uart_dma.tx_buf_size >=
-			up->uart_dma.tx_buf_dma_phys + UART_XMIT_SIZE)
-		up->uart_dma.tx_buf_size =
-			(up->uart_dma.tx_buf_dma_phys +
-			UART_XMIT_SIZE) - start;
-
-	omap_set_dma_dest_params(up->uart_dma.tx_dma_channel, 0,
-				OMAP_DMA_AMODE_CONSTANT,
-				up->uart_dma.uart_base, 0, 0);
-	omap_set_dma_src_params(up->uart_dma.tx_dma_channel, 0,
-				OMAP_DMA_AMODE_POST_INC, start, 0, 0);
-	omap_set_dma_transfer_params(up->uart_dma.tx_dma_channel,
-				OMAP_DMA_DATA_TYPE_S8,
-				up->uart_dma.tx_buf_size, 1,
-				OMAP_DMA_SYNC_ELEMENT,
-				up->uart_dma.uart_dma_tx, 0);
-	/* FIXME: Cache maintenance needed here? */
-	omap_start_dma(up->uart_dma.tx_dma_channel);
+	pm_runtime_get_sync(up->dev);
+	serial_omap_enable_ier_thri(up);
+	serial_omap_set_noidle(up);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 }
 
 static unsigned int check_modem_status(struct uart_omap_port *up)
@@ -455,16 +363,8 @@ static inline irqreturn_t serial_omap_irq(int irq, void *dev_id)
 	spin_lock_irqsave(&up->port.lock, flags);
 	lsr = serial_in(up, UART_LSR);
 	if (iir & UART_IIR_RLSI) {
-		if (!up->use_dma) {
-			if (lsr & UART_LSR_DR)
-				receive_chars(up, &lsr);
-		} else {
-			up->ier &= ~(UART_IER_RDI | UART_IER_RLSI);
-			serial_out(up, UART_IER, up->ier);
-			if ((serial_omap_start_rxdma(up) != 0) &&
-					(lsr & UART_LSR_DR))
-				receive_chars(up, &lsr);
-		}
+		if (lsr & UART_LSR_DR)
+			receive_chars(up, &lsr);
 	}
 
 	check_modem_status(up);
@@ -605,20 +505,6 @@ static int serial_omap_startup(struct uart_port *port)
 	spin_unlock_irqrestore(&up->port.lock, flags);
 
 	up->msr_saved_flags = 0;
-	if (up->use_dma) {
-		free_page((unsigned long)up->port.state->xmit.buf);
-		up->port.state->xmit.buf = dma_alloc_coherent(NULL,
-			UART_XMIT_SIZE,
-			(dma_addr_t *)&(up->uart_dma.tx_buf_dma_phys),
-			0);
-		init_timer(&(up->uart_dma.rx_timer));
-		up->uart_dma.rx_timer.function = serial_omap_rxdma_poll;
-		up->uart_dma.rx_timer.data = up->port.line;
-		/* Currently the buffer size is 4KB. Can increase it */
-		up->uart_dma.rx_buf = dma_alloc_coherent(NULL,
-			up->uart_dma.rx_buf_size,
-			(dma_addr_t *)&(up->uart_dma.rx_buf_dma_phys), 0);
-	}
 	/*
 	 * Finally, enable interrupts. Note: Modem status interrupts
 	 * are set via set_termios(), which will be occurring imminently
@@ -666,17 +552,6 @@ static void serial_omap_shutdown(struct uart_port *port)
 	 */
 	if (serial_in(up, UART_LSR) & UART_LSR_DR)
 		(void) serial_in(up, UART_RX);
-	if (up->use_dma) {
-		dma_free_coherent(up->port.dev,
-			UART_XMIT_SIZE,	up->port.state->xmit.buf,
-			up->uart_dma.tx_buf_dma_phys);
-		up->port.state->xmit.buf = NULL;
-		serial_omap_stop_rx(port);
-		dma_free_coherent(up->port.dev,
-			up->uart_dma.rx_buf_size, up->uart_dma.rx_buf,
-			up->uart_dma.rx_buf_dma_phys);
-		up->uart_dma.rx_buf = NULL;
-	}
 
 	pm_runtime_put(up->dev);
 	free_irq(up->port.irq, up);
@@ -800,8 +675,6 @@ serial_omap_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	up->fcr = UART_FCR_R_TRIG_01 | UART_FCR_T_TRIG_01 |
 			UART_FCR_ENABLE_FIFO;
-	if (up->use_dma)
-		up->fcr |= UART_FCR_DMA_SELECT;
 
 	/*
 	 * Ok, we're now changing the port state. Do it with
@@ -877,14 +750,9 @@ serial_omap_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	up->scr |= OMAP_UART_SCR_RX_TRIG_GRANU1_MASK;
 
-	if (up->use_dma) {
-		serial_out(up, UART_TI752_TLR, 0);
-		up->scr |= UART_FCR_TRIGGER_4;
-	} else {
-		/* Set receive FIFO threshold to 1 byte */
-		up->fcr &= ~OMAP_UART_FCR_RX_FIFO_TRIG_MASK;
-		up->fcr |= (0x1 << OMAP_UART_FCR_RX_FIFO_TRIG_SHIFT);
-	}
+	/* Set receive FIFO threshold to 1 byte */
+	up->fcr &= ~OMAP_UART_FCR_RX_FIFO_TRIG_MASK;
+	up->fcr |= (0x1 << OMAP_UART_FCR_RX_FIFO_TRIG_SHIFT);
 
 	serial_out(up, UART_FCR, up->fcr);
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
@@ -1253,149 +1121,6 @@ static int serial_omap_resume(struct device *dev)
 }
 #endif
 
-static void serial_omap_rxdma_poll(unsigned long uart_no)
-{
-	struct uart_omap_port *up = ui[uart_no];
-	unsigned int curr_dma_pos, curr_transmitted_size;
-	int ret = 0;
-
-	curr_dma_pos = omap_get_dma_dst_pos(up->uart_dma.rx_dma_channel);
-	if ((curr_dma_pos == up->uart_dma.prev_rx_dma_pos) ||
-			     (curr_dma_pos == 0)) {
-		if (jiffies_to_msecs(jiffies - up->port_activity) <
-						up->uart_dma.rx_timeout) {
-			mod_timer(&up->uart_dma.rx_timer, jiffies +
-				usecs_to_jiffies(up->uart_dma.rx_poll_rate));
-		} else {
-			serial_omap_stop_rxdma(up);
-			up->ier |= (UART_IER_RDI | UART_IER_RLSI);
-			serial_out(up, UART_IER, up->ier);
-		}
-		return;
-	}
-
-	curr_transmitted_size = curr_dma_pos -
-					up->uart_dma.prev_rx_dma_pos;
-	up->port.icount.rx += curr_transmitted_size;
-	tty_insert_flip_string(up->port.state->port.tty,
-			up->uart_dma.rx_buf +
-			(up->uart_dma.prev_rx_dma_pos -
-			up->uart_dma.rx_buf_dma_phys),
-			curr_transmitted_size);
-	tty_flip_buffer_push(up->port.state->port.tty);
-	up->uart_dma.prev_rx_dma_pos = curr_dma_pos;
-	if (up->uart_dma.rx_buf_size +
-			up->uart_dma.rx_buf_dma_phys == curr_dma_pos) {
-		ret = serial_omap_start_rxdma(up);
-		if (ret < 0) {
-			serial_omap_stop_rxdma(up);
-			up->ier |= (UART_IER_RDI | UART_IER_RLSI);
-			serial_out(up, UART_IER, up->ier);
-		}
-	} else  {
-		mod_timer(&up->uart_dma.rx_timer, jiffies +
-			usecs_to_jiffies(up->uart_dma.rx_poll_rate));
-	}
-	up->port_activity = jiffies;
-}
-
-static void uart_rx_dma_callback(int lch, u16 ch_status, void *data)
-{
-	return;
-}
-
-static int serial_omap_start_rxdma(struct uart_omap_port *up)
-{
-	int ret = 0;
-
-	if (up->uart_dma.rx_dma_channel == -1) {
-		pm_runtime_get_sync(up->dev);
-		ret = omap_request_dma(up->uart_dma.uart_dma_rx,
-				"UART Rx DMA",
-				(void *)uart_rx_dma_callback, up,
-				&(up->uart_dma.rx_dma_channel));
-		if (ret < 0)
-			return ret;
-
-		omap_set_dma_src_params(up->uart_dma.rx_dma_channel, 0,
-				OMAP_DMA_AMODE_CONSTANT,
-				up->uart_dma.uart_base, 0, 0);
-		omap_set_dma_dest_params(up->uart_dma.rx_dma_channel, 0,
-				OMAP_DMA_AMODE_POST_INC,
-				up->uart_dma.rx_buf_dma_phys, 0, 0);
-		omap_set_dma_transfer_params(up->uart_dma.rx_dma_channel,
-				OMAP_DMA_DATA_TYPE_S8,
-				up->uart_dma.rx_buf_size, 1,
-				OMAP_DMA_SYNC_ELEMENT,
-				up->uart_dma.uart_dma_rx, 0);
-	}
-	up->uart_dma.prev_rx_dma_pos = up->uart_dma.rx_buf_dma_phys;
-	/* FIXME: Cache maintenance needed here? */
-	omap_start_dma(up->uart_dma.rx_dma_channel);
-	mod_timer(&up->uart_dma.rx_timer, jiffies +
-				usecs_to_jiffies(up->uart_dma.rx_poll_rate));
-	up->uart_dma.rx_dma_used = true;
-	return ret;
-}
-
-static void serial_omap_continue_tx(struct uart_omap_port *up)
-{
-	struct circ_buf *xmit = &up->port.state->xmit;
-	unsigned int start = up->uart_dma.tx_buf_dma_phys
-			+ (xmit->tail & (UART_XMIT_SIZE - 1));
-
-	if (uart_circ_empty(xmit))
-		return;
-
-	up->uart_dma.tx_buf_size = uart_circ_chars_pending(xmit);
-	/*
-	 * It is a circular buffer. See if the buffer has wounded back.
-	 * If yes it will have to be transferred in two separate dma
-	 * transfers
-	 */
-	if (start + up->uart_dma.tx_buf_size >=
-			up->uart_dma.tx_buf_dma_phys + UART_XMIT_SIZE)
-		up->uart_dma.tx_buf_size =
-			(up->uart_dma.tx_buf_dma_phys + UART_XMIT_SIZE) - start;
-	omap_set_dma_dest_params(up->uart_dma.tx_dma_channel, 0,
-				OMAP_DMA_AMODE_CONSTANT,
-				up->uart_dma.uart_base, 0, 0);
-	omap_set_dma_src_params(up->uart_dma.tx_dma_channel, 0,
-				OMAP_DMA_AMODE_POST_INC, start, 0, 0);
-	omap_set_dma_transfer_params(up->uart_dma.tx_dma_channel,
-				OMAP_DMA_DATA_TYPE_S8,
-				up->uart_dma.tx_buf_size, 1,
-				OMAP_DMA_SYNC_ELEMENT,
-				up->uart_dma.uart_dma_tx, 0);
-	/* FIXME: Cache maintenance needed here? */
-	omap_start_dma(up->uart_dma.tx_dma_channel);
-}
-
-static void uart_tx_dma_callback(int lch, u16 ch_status, void *data)
-{
-	struct uart_omap_port *up = data;
-	struct circ_buf *xmit = &up->port.state->xmit;
-
-	xmit->tail = (xmit->tail + up->uart_dma.tx_buf_size) & \
-			(UART_XMIT_SIZE - 1);
-	up->port.icount.tx += up->uart_dma.tx_buf_size;
-
-	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
-		uart_write_wakeup(&up->port);
-
-	if (uart_circ_empty(xmit)) {
-		spin_lock(&(up->uart_dma.tx_lock));
-		serial_omap_stop_tx(&up->port);
-		up->uart_dma.tx_dma_used = false;
-		spin_unlock(&(up->uart_dma.tx_lock));
-	} else {
-		omap_stop_dma(up->uart_dma.tx_dma_channel);
-		serial_omap_continue_tx(up);
-	}
-	up->port_activity = jiffies;
-	return;
-}
-
 static void omap_serial_fill_features_erratas(struct uart_omap_port *up)
 {
 	u32 mvr, scheme;
@@ -1465,7 +1190,7 @@ static struct omap_uart_port_info *of_get_uart_port_info(struct device *dev)
 static int serial_omap_probe(struct platform_device *pdev)
 {
 	struct uart_omap_port	*up;
-	struct resource		*mem, *irq, *dma_tx, *dma_rx;
+	struct resource		*mem, *irq;
 	struct omap_uart_port_info *omap_up_info = pdev->dev.platform_data;
 	int ret = -ENOSPC;
 
@@ -1490,14 +1215,6 @@ static int serial_omap_probe(struct platform_device *pdev)
 		return -EBUSY;
 	}
 
-	dma_rx = platform_get_resource_byname(pdev, IORESOURCE_DMA, "rx");
-	if (!dma_rx)
-		return -ENXIO;
-
-	dma_tx = platform_get_resource_byname(pdev, IORESOURCE_DMA, "tx");
-	if (!dma_tx)
-		return -ENXIO;
-
 	up = devm_kzalloc(&pdev->dev, sizeof(*up), GFP_KERNEL);
 	if (!up)
 		return -ENOMEM;
@@ -1541,20 +1258,6 @@ static int serial_omap_probe(struct platform_device *pdev)
 		dev_warn(&pdev->dev, "No clock speed specified: using default:"
 						"%d\n", DEFAULT_CLK_SPEED);
 	}
-	up->uart_dma.uart_base = mem->start;
-
-	if (omap_up_info->dma_enabled) {
-		up->uart_dma.uart_dma_tx = dma_tx->start;
-		up->uart_dma.uart_dma_rx = dma_rx->start;
-		up->use_dma = 1;
-		up->uart_dma.rx_buf_size = omap_up_info->dma_rx_buf_size;
-		up->uart_dma.rx_timeout = omap_up_info->dma_rx_timeout;
-		up->uart_dma.rx_poll_rate = omap_up_info->dma_rx_poll_rate;
-		spin_lock_init(&(up->uart_dma.tx_lock));
-		spin_lock_init(&(up->uart_dma.rx_lock));
-		up->uart_dma.tx_dma_channel = OMAP_UART_DMA_CH_FREE;
-		up->uart_dma.rx_dma_channel = OMAP_UART_DMA_CH_FREE;
-	}
 
 	up->latency = PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE;
 	up->calc_latency = PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE;
@@ -1697,10 +1400,6 @@ static int serial_omap_runtime_suspend(struct device *dev)
 		}
 	}
 
-	/* Errata i291 */
-	if (up->use_dma && (up->errata & UART_ERRATA_i291_DMA_FORCEIDLE))
-		serial_omap_set_forceidle(up);
-
 	up->latency = PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE;
 	schedule_work(&up->qos_work);
 
@@ -1718,11 +1417,6 @@ static int serial_omap_runtime_resume(struct device *dev)
 			if (up->context_loss_cnt != loss_cnt)
 				serial_omap_restore_context(up);
 
-		/* Errata i291 */
-		if ((up->errata & UART_ERRATA_i291_DMA_FORCEIDLE) &&
-				up->use_dma)
-			serial_omap_set_noidle(up);
-
 		up->latency = up->calc_latency;
 		schedule_work(&up->qos_work);
 	}
-- 
1.7.12.rc3

