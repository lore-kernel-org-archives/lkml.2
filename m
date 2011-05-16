Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab1EPNBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 09:01:48 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:45814 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751963Ab1EPNBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 09:01:45 -0400
From: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
To: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rmk+kernel@arm.linux.org.uk>, <linus.walleij@stericsson.com>,
        <alan@linux.intel.com>
Cc: <shreshthakumar.sahu@stericsson.com>
Subject: [PATCH 1/2] amba pl011: workaround for uart registers lockup
Date: Mon, 16 May 2011 18:31:18 +0530
Message-ID: <1305550879-28945-1-git-send-email-shreshthakumar.sahu@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>

This workaround aims to break the deadlock situation
which raises during continuous transfer of data for long
duration over uart with hardware flow control. It is
observed that CTS interrupt cannot be cleared in uart
interrupt register (ICR). Hence further transfer over
uart gets blocked.

It is seen that during such deadlock condition ICR
don't get cleared even on multiple write. This leads
pass_counter to decrease and finally reach zero. This
can be taken as trigger point to run this UART_BT_WA.

Workaround backups the register configuration, does soft
reset of UART using BIT-0 of PRCC_K_SOFTRST_SET/CLEAR
registers and restores the registers.

This patch also provides support for uart init and exit
function calls if present.

Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
---
 drivers/tty/serial/amba-pl011.c |  123 ++++++++++++++++++++++++++++++++++++++-
 include/linux/amba/serial.h     |    3 +
 2 files changed, 125 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 8dc0541..f5f6831 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -50,6 +50,7 @@
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
 #include <linux/scatterlist.h>
+#include <linux/delay.h>
 
 #include <asm/io.h>
 #include <asm/sizes.h>
@@ -65,6 +66,30 @@
 #define UART_DR_ERROR		(UART011_DR_OE|UART011_DR_BE|UART011_DR_PE|UART011_DR_FE)
 #define UART_DUMMY_DR_RX	(1 << 16)
 
+
+#define UART_WA_SAVE_NR 14
+
+static void pl011_lockup_wa(unsigned long data);
+static const u32 uart_wa_reg[UART_WA_SAVE_NR] = {
+	ST_UART011_DMAWM,
+	ST_UART011_TIMEOUT,
+	ST_UART011_LCRH_RX,
+	UART011_IBRD,
+	UART011_FBRD,
+	ST_UART011_LCRH_TX,
+	UART011_IFLS,
+	ST_UART011_XFCR,
+	ST_UART011_XON1,
+	ST_UART011_XON2,
+	ST_UART011_XOFF1,
+	ST_UART011_XOFF2,
+	UART011_CR,
+	UART011_IMSC
+};
+
+static u32 uart_wa_regdata[UART_WA_SAVE_NR];
+static DECLARE_TASKLET(pl011_lockup_tlet, pl011_lockup_wa, 0);
+
 /* There is by now at least one vendor with differing details, so handle it */
 struct vendor_data {
 	unsigned int		ifls;
@@ -72,6 +97,7 @@ struct vendor_data {
 	unsigned int		lcrh_tx;
 	unsigned int		lcrh_rx;
 	bool			oversampling;
+	bool			interrupt_may_hang;   /* vendor-specific */
 	bool			dma_threshold;
 };
 
@@ -90,9 +116,12 @@ static struct vendor_data vendor_st = {
 	.lcrh_tx		= ST_UART011_LCRH_TX,
 	.lcrh_rx		= ST_UART011_LCRH_RX,
 	.oversampling		= true,
+	.interrupt_may_hang	= true,
 	.dma_threshold		= true,
 };
 
+static struct uart_amba_port *amba_ports[UART_NR];
+
 /* Deals with DMA transactions */
 
 struct pl011_sgbuf {
@@ -132,6 +161,7 @@ struct uart_amba_port {
 	unsigned int		lcrh_rx;	/* vendor-specific */
 	bool			autorts;
 	char			type[12];
+	bool			interrupt_may_hang; /* vendor-specific */
 #ifdef CONFIG_DMA_ENGINE
 	/* DMA stuff */
 	bool			using_tx_dma;
@@ -1008,6 +1038,68 @@ static inline bool pl011_dma_rx_running(struct uart_amba_port *uap)
 #endif
 
 
+/*
+ * pl011_lockup_wa
+ * This workaround aims to break the deadlock situation
+ * when after long transfer over uart in hardware flow
+ * control, uart interrupt registers cannot be cleared.
+ * Hence uart transfer gets blocked.
+ *
+ * It is seen that during such deadlock condition ICR
+ * don't get cleared even on multiple write. This leads
+ * pass_counter to decrease and finally reach zero. This
+ * can be taken as trigger point to run this UART_BT_WA.
+ *
+ */
+static void pl011_lockup_wa(unsigned long data)
+{
+	struct uart_amba_port *uap = amba_ports[0];
+	void __iomem *base = uap->port.membase;
+	struct circ_buf *xmit = &uap->port.state->xmit;
+	struct tty_struct *tty = uap->port.state->port.tty;
+	int buf_empty_retries = 200;
+	int loop;
+
+	/* Stop HCI layer from submitting data for tx */
+	tty->hw_stopped = 1;
+	while (!uart_circ_empty(xmit)) {
+		if (buf_empty_retries-- == 0)
+			break;
+		udelay(100);
+	}
+
+	/* Backup registers */
+	for (loop = 0; loop < UART_WA_SAVE_NR; loop++)
+		uart_wa_regdata[loop] = readl(base + uart_wa_reg[loop]);
+
+	/* Disable UART so that FIFO data is flushed out */
+	writew(0x00, uap->port.membase + UART011_CR);
+
+	/* Soft reset UART module */
+	if (uap->port.dev->platform_data) {
+		struct amba_pl011_data *plat;
+
+		plat = uap->port.dev->platform_data;
+		if (plat->reset)
+			plat->reset();
+	}
+
+	/* Restore registers */
+	for (loop = 0; loop < UART_WA_SAVE_NR; loop++)
+		writew(uart_wa_regdata[loop] ,
+				uap->port.membase + uart_wa_reg[loop]);
+
+	/* Initialise the old status of the modem signals */
+	uap->old_status = readw(uap->port.membase + UART01x_FR) &
+		UART01x_FR_MODEM_ANY;
+
+	if (readl(base + UART011_MIS) & 0x2)
+		printk(KERN_EMERG "UART_BT_WA: ***FAILED***\n");
+
+	/* Start Tx/Rx */
+	tty->hw_stopped = 0;
+}
+
 static void pl011_stop_tx(struct uart_port *port)
 {
 	struct uart_amba_port *uap = (struct uart_amba_port *)port;
@@ -1158,8 +1250,11 @@ static irqreturn_t pl011_int(int irq, void *dev_id)
 			if (status & UART011_TXIS)
 				pl011_tx_chars(uap);
 
-			if (pass_counter-- == 0)
+			if (pass_counter-- == 0) {
+				if (uap->interrupt_may_hang)
+					tasklet_schedule(&pl011_lockup_tlet);
 				break;
+			}
 
 			status = readw(uap->port.membase + UART011_MIS);
 		} while (status != 0);
@@ -1339,6 +1434,14 @@ static int pl011_startup(struct uart_port *port)
 	writew(uap->im, uap->port.membase + UART011_IMSC);
 	spin_unlock_irq(&uap->port.lock);
 
+	if (uap->port.dev->platform_data) {
+		struct amba_pl011_data *plat;
+
+		plat = uap->port.dev->platform_data;
+		if (plat->init)
+			plat->init();
+	}
+
 	return 0;
 
  clk_dis:
@@ -1394,6 +1497,15 @@ static void pl011_shutdown(struct uart_port *port)
 	 * Shut down the clock producer
 	 */
 	clk_disable(uap->clk);
+
+	if (uap->port.dev->platform_data) {
+		struct amba_pl011_data *plat;
+
+		plat = uap->port.dev->platform_data;
+		if (plat->exit)
+			plat->exit();
+	}
+
 }
 
 static void
@@ -1700,6 +1812,14 @@ static int __init pl011_console_setup(struct console *co, char *options)
 	if (!uap)
 		return -ENODEV;
 
+	if (uap->port.dev->platform_data) {
+		struct amba_pl011_data *plat;
+
+		plat = uap->port.dev->platform_data;
+		if (plat->init)
+			plat->init();
+	}
+
 	uap->port.uartclk = clk_get_rate(uap->clk);
 
 	if (options)
@@ -1774,6 +1894,7 @@ static int pl011_probe(struct amba_device *dev, const struct amba_id *id)
 	uap->lcrh_rx = vendor->lcrh_rx;
 	uap->lcrh_tx = vendor->lcrh_tx;
 	uap->fifosize = vendor->fifosize;
+	uap->interrupt_may_hang = vendor->interrupt_may_hang;
 	uap->port.dev = &dev->dev;
 	uap->port.mapbase = dev->res.start;
 	uap->port.membase = base;
diff --git a/include/linux/amba/serial.h b/include/linux/amba/serial.h
index 5479fdc..514ed45 100644
--- a/include/linux/amba/serial.h
+++ b/include/linux/amba/serial.h
@@ -201,6 +201,9 @@ struct amba_pl011_data {
 	bool (*dma_filter)(struct dma_chan *chan, void *filter_param);
 	void *dma_rx_param;
 	void *dma_tx_param;
+        void (*init) (void);
+	void (*exit) (void);
+	void (*reset) (void);
 };
 #endif
 
-- 
1.7.2.dirty

