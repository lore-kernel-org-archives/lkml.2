Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab2J1KtS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 06:49:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49337 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750785Ab2J1KtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 06:49:14 -0400
Message-ID: <1351421337.2008.3.camel@joe-AO722>
Subject: [PATCH] jsm: Convert jsm_printk to jsm_dbg
From: Joe Perches <joe@perches.com>
To: Lucas Tavares <lucaskt@linux.vnet.ibm.com>
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sun, 28 Oct 2012 03:48:57 -0700
Mime-Version: 1.0
X-Mailer: Evolution 3.6.0-0ubuntu3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These printks should all be emitted at KERN_DEBUG level.
Make them dependent on CONFIG_DEBUG or (#define DEBUG)
simplify the code a bit.

Add missing newlines where appropriate.

Most all of these messages could be deleted too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/tty/serial/jsm/jsm.h        |    8 ++-
 drivers/tty/serial/jsm/jsm_driver.c |    3 +-
 drivers/tty/serial/jsm/jsm_neo.c    |  116 +++++++++++++++++++----------------
 drivers/tty/serial/jsm/jsm_tty.c    |  102 ++++++++++++++++---------------
 4 files changed, 120 insertions(+), 109 deletions(-)

diff --git a/drivers/tty/serial/jsm/jsm.h b/drivers/tty/serial/jsm/jsm.h
index 529bec6..844d5e4 100644
--- a/drivers/tty/serial/jsm/jsm.h
+++ b/drivers/tty/serial/jsm/jsm.h
@@ -57,9 +57,11 @@ enum {
 	DBG_CARR	= 0x10000,
 };
 
-#define jsm_printk(nlevel, klevel, pdev, fmt, args...)	\
-	if ((DBG_##nlevel & jsm_debug))			\
-	dev_printk(KERN_##klevel, pdev->dev, fmt, ## args)
+#define jsm_dbg(nlevel, pdev, fmt, ...)				\
+do {								\
+	if (DBG_##nlevel & jsm_debug)				\
+		dev_dbg(pdev->dev, fmt, ##__VA_ARGS__);		\
+} while (0)
 
 #define	MAXLINES	256
 #define MAXPORTS	8
diff --git a/drivers/tty/serial/jsm/jsm_driver.c b/drivers/tty/serial/jsm/jsm_driver.c
index 5ab3c3b..8e05ce9 100644
--- a/drivers/tty/serial/jsm/jsm_driver.c
+++ b/drivers/tty/serial/jsm/jsm_driver.c
@@ -107,8 +107,7 @@ static int __devinit jsm_probe_one(struct pci_dev *pdev, const struct pci_device
 
 	brd->irq = pdev->irq;
 
-	jsm_printk(INIT, INFO, &brd->pci_dev,
-		"jsm_found_board - NEO adapter\n");
+	jsm_dbg(INIT, &brd->pci_dev, "jsm_found_board - NEO adapter\n");
 
 	/* get the PCI Base Address Registers */
 	brd->membase	= pci_resource_start(pdev, 0);
diff --git a/drivers/tty/serial/jsm/jsm_neo.c b/drivers/tty/serial/jsm/jsm_neo.c
index 81dfafa..dfaf488 100644
--- a/drivers/tty/serial/jsm/jsm_neo.c
+++ b/drivers/tty/serial/jsm/jsm_neo.c
@@ -52,7 +52,7 @@ static void neo_set_cts_flow_control(struct jsm_channel *ch)
 	ier = readb(&ch->ch_neo_uart->ier);
 	efr = readb(&ch->ch_neo_uart->efr);
 
-	jsm_printk(PARAM, INFO, &ch->ch_bd->pci_dev, "Setting CTSFLOW\n");
+	jsm_dbg(PARAM, &ch->ch_bd->pci_dev, "Setting CTSFLOW\n");
 
 	/* Turn on auto CTS flow control */
 	ier |= (UART_17158_IER_CTSDSR);
@@ -83,7 +83,7 @@ static void neo_set_rts_flow_control(struct jsm_channel *ch)
 	ier = readb(&ch->ch_neo_uart->ier);
 	efr = readb(&ch->ch_neo_uart->efr);
 
-	jsm_printk(PARAM, INFO, &ch->ch_bd->pci_dev, "Setting RTSFLOW\n");
+	jsm_dbg(PARAM, &ch->ch_bd->pci_dev, "Setting RTSFLOW\n");
 
 	/* Turn on auto RTS flow control */
 	ier |= (UART_17158_IER_RTSDTR);
@@ -123,7 +123,7 @@ static void neo_set_ixon_flow_control(struct jsm_channel *ch)
 	ier = readb(&ch->ch_neo_uart->ier);
 	efr = readb(&ch->ch_neo_uart->efr);
 
-	jsm_printk(PARAM, INFO, &ch->ch_bd->pci_dev, "Setting IXON FLOW\n");
+	jsm_dbg(PARAM, &ch->ch_bd->pci_dev, "Setting IXON FLOW\n");
 
 	/* Turn off auto CTS flow control */
 	ier &= ~(UART_17158_IER_CTSDSR);
@@ -160,7 +160,7 @@ static void neo_set_ixoff_flow_control(struct jsm_channel *ch)
 	ier = readb(&ch->ch_neo_uart->ier);
 	efr = readb(&ch->ch_neo_uart->efr);
 
-	jsm_printk(PARAM, INFO, &ch->ch_bd->pci_dev, "Setting IXOFF FLOW\n");
+	jsm_dbg(PARAM, &ch->ch_bd->pci_dev, "Setting IXOFF FLOW\n");
 
 	/* Turn off auto RTS flow control */
 	ier &= ~(UART_17158_IER_RTSDTR);
@@ -198,7 +198,7 @@ static void neo_set_no_input_flow_control(struct jsm_channel *ch)
 	ier = readb(&ch->ch_neo_uart->ier);
 	efr = readb(&ch->ch_neo_uart->efr);
 
-	jsm_printk(PARAM, INFO, &ch->ch_bd->pci_dev, "Unsetting Input FLOW\n");
+	jsm_dbg(PARAM, &ch->ch_bd->pci_dev, "Unsetting Input FLOW\n");
 
 	/* Turn off auto RTS flow control */
 	ier &= ~(UART_17158_IER_RTSDTR);
@@ -237,7 +237,7 @@ static void neo_set_no_output_flow_control(struct jsm_channel *ch)
 	ier = readb(&ch->ch_neo_uart->ier);
 	efr = readb(&ch->ch_neo_uart->efr);
 
-	jsm_printk(PARAM, INFO, &ch->ch_bd->pci_dev, "Unsetting Output FLOW\n");
+	jsm_dbg(PARAM, &ch->ch_bd->pci_dev, "Unsetting Output FLOW\n");
 
 	/* Turn off auto CTS flow control */
 	ier &= ~(UART_17158_IER_CTSDSR);
@@ -276,7 +276,7 @@ static inline void neo_set_new_start_stop_chars(struct jsm_channel *ch)
 	if (ch->ch_c_cflag & CRTSCTS)
 		return;
 
-	jsm_printk(PARAM, INFO, &ch->ch_bd->pci_dev, "start\n");
+	jsm_dbg(PARAM, &ch->ch_bd->pci_dev, "start\n");
 
 	/* Tell UART what start/stop chars it should be looking for */
 	writeb(ch->ch_startc, &ch->ch_neo_uart->xonchar1);
@@ -455,7 +455,7 @@ static void neo_copy_data_from_uart_to_queue(struct jsm_channel *ch)
 		 * I hope thats okay with everyone? Yes? Good.
 		 */
 		while (qleft < 1) {
-			jsm_printk(READ, INFO, &ch->ch_bd->pci_dev,
+			jsm_dbg(READ, &ch->ch_bd->pci_dev,
 				"Queue full, dropping DATA:%x LSR:%x\n",
 				ch->ch_rqueue[tail], ch->ch_equeue[tail]);
 
@@ -467,8 +467,8 @@ static void neo_copy_data_from_uart_to_queue(struct jsm_channel *ch)
 		memcpy_fromio(ch->ch_rqueue + head, &ch->ch_neo_uart->txrxburst, 1);
 		ch->ch_equeue[head] = (u8) linestatus;
 
-		jsm_printk(READ, INFO, &ch->ch_bd->pci_dev,
-				"DATA/LSR pair: %x %x\n", ch->ch_rqueue[head], ch->ch_equeue[head]);
+		jsm_dbg(READ, &ch->ch_bd->pci_dev, "DATA/LSR pair: %x %x\n",
+			ch->ch_rqueue[head], ch->ch_equeue[head]);
 
 		/* Ditch any remaining linestatus value. */
 		linestatus = 0;
@@ -521,8 +521,8 @@ static void neo_copy_data_from_queue_to_uart(struct jsm_channel *ch)
 			ch->ch_cached_lsr &= ~(UART_LSR_THRE);
 
 			writeb(circ->buf[circ->tail], &ch->ch_neo_uart->txrx);
-			jsm_printk(WRITE, INFO, &ch->ch_bd->pci_dev,
-					"Tx data: %x\n", circ->buf[circ->tail]);
+			jsm_dbg(WRITE, &ch->ch_bd->pci_dev,
+				"Tx data: %x\n", circ->buf[circ->tail]);
 			circ->tail = (circ->tail + 1) & (UART_XMIT_SIZE - 1);
 			ch->ch_txcount++;
 		}
@@ -575,8 +575,9 @@ static void neo_parse_modem(struct jsm_channel *ch, u8 signals)
 {
 	u8 msignals = signals;
 
-	jsm_printk(MSIGS, INFO, &ch->ch_bd->pci_dev,
-			"neo_parse_modem: port: %d msignals: %x\n", ch->ch_portnum, msignals);
+	jsm_dbg(MSIGS, &ch->ch_bd->pci_dev,
+		"neo_parse_modem: port: %d msignals: %x\n",
+		ch->ch_portnum, msignals);
 
 	/* Scrub off lower bits. They signify delta's, which I don't care about */
 	/* Keep DDCD and DDSR though */
@@ -606,8 +607,8 @@ static void neo_parse_modem(struct jsm_channel *ch, u8 signals)
 	else
 		ch->ch_mistat &= ~UART_MSR_CTS;
 
-	jsm_printk(MSIGS, INFO, &ch->ch_bd->pci_dev,
-			"Port: %d DTR: %d RTS: %d CTS: %d DSR: %d " "RI: %d CD: %d\n",
+	jsm_dbg(MSIGS, &ch->ch_bd->pci_dev,
+		"Port: %d DTR: %d RTS: %d CTS: %d DSR: %d " "RI: %d CD: %d\n",
 		ch->ch_portnum,
 		!!((ch->ch_mistat | ch->ch_mostat) & UART_MCR_DTR),
 		!!((ch->ch_mistat | ch->ch_mostat) & UART_MCR_RTS),
@@ -649,8 +650,8 @@ static void neo_flush_uart_write(struct jsm_channel *ch)
 		/* Check to see if the UART feels it completely flushed the FIFO. */
 		tmp = readb(&ch->ch_neo_uart->isr_fcr);
 		if (tmp & 4) {
-			jsm_printk(IOCTL, INFO, &ch->ch_bd->pci_dev,
-					"Still flushing TX UART... i: %d\n", i);
+			jsm_dbg(IOCTL, &ch->ch_bd->pci_dev,
+				"Still flushing TX UART... i: %d\n", i);
 			udelay(10);
 		}
 		else
@@ -681,8 +682,8 @@ static void neo_flush_uart_read(struct jsm_channel *ch)
 		/* Check to see if the UART feels it completely flushed the FIFO. */
 		tmp = readb(&ch->ch_neo_uart->isr_fcr);
 		if (tmp & 2) {
-			jsm_printk(IOCTL, INFO, &ch->ch_bd->pci_dev,
-					"Still flushing RX UART... i: %d\n", i);
+			jsm_dbg(IOCTL, &ch->ch_bd->pci_dev,
+				"Still flushing RX UART... i: %d\n", i);
 			udelay(10);
 		}
 		else
@@ -705,8 +706,9 @@ static void neo_clear_break(struct jsm_channel *ch, int force)
 		writeb((temp & ~UART_LCR_SBC), &ch->ch_neo_uart->lcr);
 
 		ch->ch_flags &= ~(CH_BREAK_SENDING);
-		jsm_printk(IOCTL, INFO, &ch->ch_bd->pci_dev,
-				"clear break Finishing UART_LCR_SBC! finished: %lx\n", jiffies);
+		jsm_dbg(IOCTL, &ch->ch_bd->pci_dev,
+			"clear break Finishing UART_LCR_SBC! finished: %lx\n",
+			jiffies);
 
 		/* flush write operation */
 		neo_pci_posting_flush(ch->ch_bd);
@@ -748,8 +750,8 @@ static inline void neo_parse_isr(struct jsm_board *brd, u32 port)
 		 */
 		isr &= ~(UART_17158_IIR_FIFO_ENABLED);
 
-		jsm_printk(INTR, INFO, &ch->ch_bd->pci_dev,
-				"%s:%d isr: %x\n", __FILE__, __LINE__, isr);
+		jsm_dbg(INTR, &ch->ch_bd->pci_dev, "%s:%d isr: %x\n",
+			__FILE__, __LINE__, isr);
 
 		if (isr & (UART_17158_IIR_RDI_TIMEOUT | UART_IIR_RDI)) {
 			/* Read data from uart -> queue */
@@ -772,8 +774,9 @@ static inline void neo_parse_isr(struct jsm_board *brd, u32 port)
 		if (isr & UART_17158_IIR_XONXOFF) {
 			cause = readb(&ch->ch_neo_uart->xoffchar1);
 
-			jsm_printk(INTR, INFO, &ch->ch_bd->pci_dev,
-					"Port %d. Got ISR_XONXOFF: cause:%x\n", port, cause);
+			jsm_dbg(INTR, &ch->ch_bd->pci_dev,
+				"Port %d. Got ISR_XONXOFF: cause:%x\n",
+				port, cause);
 
 			/*
 			 * Since the UART detected either an XON or
@@ -786,17 +789,19 @@ static inline void neo_parse_isr(struct jsm_board *brd, u32 port)
 				if (brd->channels[port]->ch_flags & CH_STOP) {
 					ch->ch_flags &= ~(CH_STOP);
 				}
-				jsm_printk(INTR, INFO, &ch->ch_bd->pci_dev,
-						"Port %d. XON detected in incoming data\n", port);
+				jsm_dbg(INTR, &ch->ch_bd->pci_dev,
+					"Port %d. XON detected in incoming data\n",
+					port);
 			}
 			else if (cause == UART_17158_XOFF_DETECT) {
 				if (!(brd->channels[port]->ch_flags & CH_STOP)) {
 					ch->ch_flags |= CH_STOP;
-					jsm_printk(INTR, INFO, &ch->ch_bd->pci_dev,
-							"Setting CH_STOP\n");
+					jsm_dbg(INTR, &ch->ch_bd->pci_dev,
+						"Setting CH_STOP\n");
 				}
-				jsm_printk(INTR, INFO, &ch->ch_bd->pci_dev,
-						"Port: %d. XOFF detected in incoming data\n", port);
+				jsm_dbg(INTR, &ch->ch_bd->pci_dev,
+					"Port: %d. XOFF detected in incoming data\n",
+					port);
 			}
 			spin_unlock_irqrestore(&ch->ch_lock, lock_flags);
 		}
@@ -825,8 +830,8 @@ static inline void neo_parse_isr(struct jsm_board *brd, u32 port)
 		}
 
 		/* Parse any modem signal changes */
-		jsm_printk(INTR, INFO, &ch->ch_bd->pci_dev,
-				"MOD_STAT: sending to parse_modem_sigs\n");
+		jsm_dbg(INTR, &ch->ch_bd->pci_dev,
+			"MOD_STAT: sending to parse_modem_sigs\n");
 		neo_parse_modem(ch, readb(&ch->ch_neo_uart->msr));
 	}
 }
@@ -849,8 +854,8 @@ static inline void neo_parse_lsr(struct jsm_board *brd, u32 port)
 
 	linestatus = readb(&ch->ch_neo_uart->lsr);
 
-	jsm_printk(INTR, INFO, &ch->ch_bd->pci_dev,
-			"%s:%d port: %d linestatus: %x\n", __FILE__, __LINE__, port, linestatus);
+	jsm_dbg(INTR, &ch->ch_bd->pci_dev, "%s:%d port: %d linestatus: %x\n",
+		__FILE__, __LINE__, port, linestatus);
 
 	ch->ch_cached_lsr |= linestatus;
 
@@ -869,7 +874,7 @@ static inline void neo_parse_lsr(struct jsm_board *brd, u32 port)
 	 *to do the special RX+LSR read for this FIFO load.
 	 */
 	if (linestatus & UART_17158_RX_FIFO_DATA_ERROR)
-		jsm_printk(INTR, DEBUG, &ch->ch_bd->pci_dev,
+		jsm_dbg(INTR, &ch->ch_bd->pci_dev,
 			"%s:%d Port: %d Got an RX error, need to parse LSR\n",
 			__FILE__, __LINE__, port);
 
@@ -880,20 +885,21 @@ static inline void neo_parse_lsr(struct jsm_board *brd, u32 port)
 
 	if (linestatus & UART_LSR_PE) {
 		ch->ch_err_parity++;
-		jsm_printk(INTR, DEBUG, &ch->ch_bd->pci_dev,
-			"%s:%d Port: %d. PAR ERR!\n", __FILE__, __LINE__, port);
+		jsm_dbg(INTR, &ch->ch_bd->pci_dev, "%s:%d Port: %d. PAR ERR!\n",
+			__FILE__, __LINE__, port);
 	}
 
 	if (linestatus & UART_LSR_FE) {
 		ch->ch_err_frame++;
-		jsm_printk(INTR, DEBUG, &ch->ch_bd->pci_dev,
-			"%s:%d Port: %d. FRM ERR!\n", __FILE__, __LINE__, port);
+		jsm_dbg(INTR, &ch->ch_bd->pci_dev, "%s:%d Port: %d. FRM ERR!\n",
+			__FILE__, __LINE__, port);
 	}
 
 	if (linestatus & UART_LSR_BI) {
 		ch->ch_err_break++;
-		jsm_printk(INTR, DEBUG, &ch->ch_bd->pci_dev,
-			"%s:%d Port: %d. BRK INTR!\n", __FILE__, __LINE__, port);
+		jsm_dbg(INTR, &ch->ch_bd->pci_dev,
+			"%s:%d Port: %d. BRK INTR!\n",
+			__FILE__, __LINE__, port);
 	}
 
 	if (linestatus & UART_LSR_OE) {
@@ -904,8 +910,9 @@ static inline void neo_parse_lsr(struct jsm_board *brd, u32 port)
 		 * Probably we should eventually have an orun stat in our driver...
 		 */
 		ch->ch_err_overrun++;
-		jsm_printk(INTR, DEBUG, &ch->ch_bd->pci_dev,
-			"%s:%d Port: %d. Rx Overrun!\n", __FILE__, __LINE__, port);
+		jsm_dbg(INTR, &ch->ch_bd->pci_dev,
+			"%s:%d Port: %d. Rx Overrun!\n",
+			__FILE__, __LINE__, port);
 	}
 
 	if (linestatus & UART_LSR_THRE) {
@@ -1128,11 +1135,11 @@ static irqreturn_t neo_intr(int irq, void *voidbrd)
 	 */
 	uart_poll = readl(brd->re_map_membase + UART_17158_POLL_ADDR_OFFSET);
 
-	jsm_printk(INTR, INFO, &brd->pci_dev,
-		"%s:%d uart_poll: %x\n", __FILE__, __LINE__, uart_poll);
+	jsm_dbg(INTR, &brd->pci_dev, "%s:%d uart_poll: %x\n",
+		__FILE__, __LINE__, uart_poll);
 
 	if (!uart_poll) {
-		jsm_printk(INTR, INFO, &brd->pci_dev,
+		jsm_dbg(INTR, &brd->pci_dev,
 			"Kernel interrupted to me, but no pending interrupts...\n");
 		spin_unlock_irqrestore(&brd->bd_intr_lock, lock_flags);
 		return IRQ_NONE;
@@ -1158,15 +1165,15 @@ static irqreturn_t neo_intr(int irq, void *voidbrd)
 			continue;
 		}
 
-		jsm_printk(INTR, INFO, &brd->pci_dev,
-		"%s:%d port: %x type: %x\n", __FILE__, __LINE__, port, type);
+		jsm_dbg(INTR, &brd->pci_dev, "%s:%d port: %x type: %x\n",
+			__FILE__, __LINE__, port, type);
 
 		/* Remove this port + type from uart_poll */
 		uart_poll &= ~(jsm_offset_table[port]);
 
 		if (!type) {
 			/* If no type, just ignore it, and move onto next port */
-			jsm_printk(INTR, ERR, &brd->pci_dev,
+			jsm_dbg(INTR, &brd->pci_dev,
 				"Interrupt with no type! port: %d\n", port);
 			continue;
 		}
@@ -1231,15 +1238,16 @@ static irqreturn_t neo_intr(int irq, void *voidbrd)
 			 * these once and awhile.
 			 * Its harmless, just ignore it and move on.
 			 */
-			jsm_printk(INTR, ERR, &brd->pci_dev,
-				"%s:%d Unknown Interrupt type: %x\n", __FILE__, __LINE__, type);
+			jsm_dbg(INTR, &brd->pci_dev,
+				"%s:%d Unknown Interrupt type: %x\n",
+				__FILE__, __LINE__, type);
 			continue;
 		}
 	}
 
 	spin_unlock_irqrestore(&brd->bd_intr_lock, lock_flags);
 
-	jsm_printk(INTR, INFO, &brd->pci_dev, "finish.\n");
+	jsm_dbg(INTR, &brd->pci_dev, "finish\n");
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/tty/serial/jsm/jsm_tty.c b/drivers/tty/serial/jsm/jsm_tty.c
index 7139796..7d2c1f3 100644
--- a/drivers/tty/serial/jsm/jsm_tty.c
+++ b/drivers/tty/serial/jsm/jsm_tty.c
@@ -43,7 +43,7 @@ static inline int jsm_get_mstat(struct jsm_channel *ch)
 	unsigned char mstat;
 	unsigned result;
 
-	jsm_printk(IOCTL, INFO, &ch->ch_bd->pci_dev, "start\n");
+	jsm_dbg(IOCTL, &ch->ch_bd->pci_dev, "start\n");
 
 	mstat = (ch->ch_mostat | ch->ch_mistat);
 
@@ -62,7 +62,7 @@ static inline int jsm_get_mstat(struct jsm_channel *ch)
 	if (mstat & UART_MSR_DCD)
 		result |= TIOCM_CD;
 
-	jsm_printk(IOCTL, INFO, &ch->ch_bd->pci_dev, "finish\n");
+	jsm_dbg(IOCTL, &ch->ch_bd->pci_dev, "finish\n");
 	return result;
 }
 
@@ -79,14 +79,14 @@ static unsigned int jsm_tty_get_mctrl(struct uart_port *port)
 	int result;
 	struct jsm_channel *channel = (struct jsm_channel *)port;
 
-	jsm_printk(IOCTL, INFO, &channel->ch_bd->pci_dev, "start\n");
+	jsm_dbg(IOCTL, &channel->ch_bd->pci_dev, "start\n");
 
 	result = jsm_get_mstat(channel);
 
 	if (result < 0)
 		return -ENXIO;
 
-	jsm_printk(IOCTL, INFO, &channel->ch_bd->pci_dev, "finish\n");
+	jsm_dbg(IOCTL, &channel->ch_bd->pci_dev, "finish\n");
 
 	return result;
 }
@@ -100,7 +100,7 @@ static void jsm_tty_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
 	struct jsm_channel *channel = (struct jsm_channel *)port;
 
-	jsm_printk(IOCTL, INFO, &channel->ch_bd->pci_dev, "start\n");
+	jsm_dbg(IOCTL, &channel->ch_bd->pci_dev, "start\n");
 
 	if (mctrl & TIOCM_RTS)
 		channel->ch_mostat |= UART_MCR_RTS;
@@ -114,7 +114,7 @@ static void jsm_tty_set_mctrl(struct uart_port *port, unsigned int mctrl)
 
 	channel->ch_bd->bd_ops->assert_modem_signals(channel);
 
-	jsm_printk(IOCTL, INFO, &channel->ch_bd->pci_dev, "finish\n");
+	jsm_dbg(IOCTL, &channel->ch_bd->pci_dev, "finish\n");
 	udelay(10);
 }
 
@@ -135,23 +135,23 @@ static void jsm_tty_start_tx(struct uart_port *port)
 {
 	struct jsm_channel *channel = (struct jsm_channel *)port;
 
-	jsm_printk(IOCTL, INFO, &channel->ch_bd->pci_dev, "start\n");
+	jsm_dbg(IOCTL, &channel->ch_bd->pci_dev, "start\n");
 
 	channel->ch_flags &= ~(CH_STOP);
 	jsm_tty_write(port);
 
-	jsm_printk(IOCTL, INFO, &channel->ch_bd->pci_dev, "finish\n");
+	jsm_dbg(IOCTL, &channel->ch_bd->pci_dev, "finish\n");
 }
 
 static void jsm_tty_stop_tx(struct uart_port *port)
 {
 	struct jsm_channel *channel = (struct jsm_channel *)port;
 
-	jsm_printk(IOCTL, INFO, &channel->ch_bd->pci_dev, "start\n");
+	jsm_dbg(IOCTL, &channel->ch_bd->pci_dev, "start\n");
 
 	channel->ch_flags |= (CH_STOP);
 
-	jsm_printk(IOCTL, INFO, &channel->ch_bd->pci_dev, "finish\n");
+	jsm_dbg(IOCTL, &channel->ch_bd->pci_dev, "finish\n");
 }
 
 static void jsm_tty_send_xchar(struct uart_port *port, char ch)
@@ -216,16 +216,16 @@ static int jsm_tty_open(struct uart_port *port)
 	if (!channel->ch_rqueue) {
 		channel->ch_rqueue = kzalloc(RQUEUESIZE, GFP_KERNEL);
 		if (!channel->ch_rqueue) {
-			jsm_printk(INIT, ERR, &channel->ch_bd->pci_dev,
-				"unable to allocate read queue buf");
+			jsm_dbg(INIT, &channel->ch_bd->pci_dev,
+				"unable to allocate read queue buf\n");
 			return -ENOMEM;
 		}
 	}
 	if (!channel->ch_equeue) {
 		channel->ch_equeue = kzalloc(EQUEUESIZE, GFP_KERNEL);
 		if (!channel->ch_equeue) {
-			jsm_printk(INIT, ERR, &channel->ch_bd->pci_dev,
-				"unable to allocate error queue buf");
+			jsm_dbg(INIT, &channel->ch_bd->pci_dev,
+				"unable to allocate error queue buf\n");
 			return -ENOMEM;
 		}
 	}
@@ -234,7 +234,7 @@ static int jsm_tty_open(struct uart_port *port)
 	/*
 	 * Initialize if neither terminal is open.
 	 */
-	jsm_printk(OPEN, INFO, &channel->ch_bd->pci_dev,
+	jsm_dbg(OPEN, &channel->ch_bd->pci_dev,
 		"jsm_open: initializing channel in open...\n");
 
 	/*
@@ -270,7 +270,7 @@ static int jsm_tty_open(struct uart_port *port)
 
 	channel->ch_open_count++;
 
-	jsm_printk(OPEN, INFO, &channel->ch_bd->pci_dev, "finish\n");
+	jsm_dbg(OPEN, &channel->ch_bd->pci_dev, "finish\n");
 	return 0;
 }
 
@@ -280,7 +280,7 @@ static void jsm_tty_close(struct uart_port *port)
 	struct ktermios *ts;
 	struct jsm_channel *channel = (struct jsm_channel *)port;
 
-	jsm_printk(CLOSE, INFO, &channel->ch_bd->pci_dev, "start\n");
+	jsm_dbg(CLOSE, &channel->ch_bd->pci_dev, "start\n");
 
 	bd = channel->ch_bd;
 	ts = &port->state->port.tty->termios;
@@ -293,7 +293,7 @@ static void jsm_tty_close(struct uart_port *port)
 	 * If we have HUPCL set, lower DTR and RTS
 	 */
 	if (channel->ch_c_cflag & HUPCL) {
-		jsm_printk(CLOSE, INFO, &channel->ch_bd->pci_dev,
+		jsm_dbg(CLOSE, &channel->ch_bd->pci_dev,
 			"Close. HUPCL set, dropping DTR/RTS\n");
 
 		/* Drop RTS/DTR */
@@ -304,7 +304,7 @@ static void jsm_tty_close(struct uart_port *port)
 	/* Turn off UART interrupts for this port */
 	channel->ch_bd->bd_ops->uart_off(channel);
 
-	jsm_printk(CLOSE, INFO, &channel->ch_bd->pci_dev, "finish\n");
+	jsm_dbg(CLOSE, &channel->ch_bd->pci_dev, "finish\n");
 }
 
 static void jsm_tty_set_termios(struct uart_port *port,
@@ -380,7 +380,7 @@ int __devinit jsm_tty_init(struct jsm_board *brd)
 	if (!brd)
 		return -ENXIO;
 
-	jsm_printk(INIT, INFO, &brd->pci_dev, "start\n");
+	jsm_dbg(INIT, &brd->pci_dev, "start\n");
 
 	/*
 	 * Initialize board structure elements.
@@ -401,9 +401,9 @@ int __devinit jsm_tty_init(struct jsm_board *brd)
 			 */
 			brd->channels[i] = kzalloc(sizeof(struct jsm_channel), GFP_KERNEL);
 			if (!brd->channels[i]) {
-				jsm_printk(CORE, ERR, &brd->pci_dev,
+				jsm_dbg(CORE, &brd->pci_dev,
 					"%s:%d Unable to allocate memory for channel struct\n",
-							 __FILE__, __LINE__);
+					__FILE__, __LINE__);
 			}
 		}
 	}
@@ -431,7 +431,7 @@ int __devinit jsm_tty_init(struct jsm_board *brd)
 		init_waitqueue_head(&ch->ch_flags_wait);
 	}
 
-	jsm_printk(INIT, INFO, &brd->pci_dev, "finish\n");
+	jsm_dbg(INIT, &brd->pci_dev, "finish\n");
 	return 0;
 }
 
@@ -444,7 +444,7 @@ int jsm_uart_port_init(struct jsm_board *brd)
 	if (!brd)
 		return -ENXIO;
 
-	jsm_printk(INIT, INFO, &brd->pci_dev, "start\n");
+	jsm_dbg(INIT, &brd->pci_dev, "start\n");
 
 	/*
 	 * Initialize board structure elements.
@@ -481,7 +481,7 @@ int jsm_uart_port_init(struct jsm_board *brd)
 			printk(KERN_INFO "jsm: Port %d added\n", i);
 	}
 
-	jsm_printk(INIT, INFO, &brd->pci_dev, "finish\n");
+	jsm_dbg(INIT, &brd->pci_dev, "finish\n");
 	return 0;
 }
 
@@ -493,7 +493,7 @@ int jsm_remove_uart_port(struct jsm_board *brd)
 	if (!brd)
 		return -ENXIO;
 
-	jsm_printk(INIT, INFO, &brd->pci_dev, "start\n");
+	jsm_dbg(INIT, &brd->pci_dev, "start\n");
 
 	/*
 	 * Initialize board structure elements.
@@ -513,7 +513,7 @@ int jsm_remove_uart_port(struct jsm_board *brd)
 		uart_remove_one_port(&jsm_uart_driver, &brd->channels[i]->uart_port);
 	}
 
-	jsm_printk(INIT, INFO, &brd->pci_dev, "finish\n");
+	jsm_dbg(INIT, &brd->pci_dev, "finish\n");
 	return 0;
 }
 
@@ -531,7 +531,7 @@ void jsm_input(struct jsm_channel *ch)
 	int s = 0;
 	int i = 0;
 
-	jsm_printk(READ, INFO, &ch->ch_bd->pci_dev, "start\n");
+	jsm_dbg(READ, &ch->ch_bd->pci_dev, "start\n");
 
 	if (!ch)
 		return;
@@ -560,7 +560,7 @@ void jsm_input(struct jsm_channel *ch)
 		return;
 	}
 
-	jsm_printk(READ, INFO, &ch->ch_bd->pci_dev, "start\n");
+	jsm_dbg(READ, &ch->ch_bd->pci_dev, "start\n");
 
 	/*
 	 *If the device is not open, or CREAD is off, flush
@@ -569,8 +569,9 @@ void jsm_input(struct jsm_channel *ch)
 	if (!tp ||
 		!(tp->termios.c_cflag & CREAD) ) {
 
-		jsm_printk(READ, INFO, &ch->ch_bd->pci_dev,
-			"input. dropping %d bytes on port %d...\n", data_len, ch->ch_portnum);
+		jsm_dbg(READ, &ch->ch_bd->pci_dev,
+			"input. dropping %d bytes on port %d...\n",
+			data_len, ch->ch_portnum);
 		ch->ch_r_head = tail;
 
 		/* Force queue flow control to be released, if needed */
@@ -585,17 +586,17 @@ void jsm_input(struct jsm_channel *ch)
 	 */
 	if (ch->ch_flags & CH_STOPI) {
 		spin_unlock_irqrestore(&ch->ch_lock, lock_flags);
-		jsm_printk(READ, INFO, &ch->ch_bd->pci_dev,
+		jsm_dbg(READ, &ch->ch_bd->pci_dev,
 			"Port %d throttled, not reading any data. head: %x tail: %x\n",
 			ch->ch_portnum, head, tail);
 		return;
 	}
 
-	jsm_printk(READ, INFO, &ch->ch_bd->pci_dev, "start 2\n");
+	jsm_dbg(READ, &ch->ch_bd->pci_dev, "start 2\n");
 
 	if (data_len <= 0) {
 		spin_unlock_irqrestore(&ch->ch_lock, lock_flags);
-		jsm_printk(READ, INFO, &ch->ch_bd->pci_dev, "jsm_input 1\n");
+		jsm_dbg(READ, &ch->ch_bd->pci_dev, "jsm_input 1\n");
 		return;
 	}
 
@@ -653,7 +654,7 @@ void jsm_input(struct jsm_channel *ch)
 	/* Tell the tty layer its okay to "eat" the data now */
 	tty_flip_buffer_push(tp);
 
-	jsm_printk(IOCTL, INFO, &ch->ch_bd->pci_dev, "finish\n");
+	jsm_dbg(IOCTL, &ch->ch_bd->pci_dev, "finish\n");
 }
 
 static void jsm_carrier(struct jsm_channel *ch)
@@ -663,7 +664,7 @@ static void jsm_carrier(struct jsm_channel *ch)
 	int virt_carrier = 0;
 	int phys_carrier = 0;
 
-	jsm_printk(CARR, INFO, &ch->ch_bd->pci_dev, "start\n");
+	jsm_dbg(CARR, &ch->ch_bd->pci_dev, "start\n");
 	if (!ch)
 		return;
 
@@ -673,16 +674,16 @@ static void jsm_carrier(struct jsm_channel *ch)
 		return;
 
 	if (ch->ch_mistat & UART_MSR_DCD) {
-		jsm_printk(CARR, INFO, &ch->ch_bd->pci_dev,
-			"mistat: %x D_CD: %x\n", ch->ch_mistat, ch->ch_mistat & UART_MSR_DCD);
+		jsm_dbg(CARR, &ch->ch_bd->pci_dev, "mistat: %x D_CD: %x\n",
+			ch->ch_mistat, ch->ch_mistat & UART_MSR_DCD);
 		phys_carrier = 1;
 	}
 
 	if (ch->ch_c_cflag & CLOCAL)
 		virt_carrier = 1;
 
-	jsm_printk(CARR, INFO, &ch->ch_bd->pci_dev,
-		"DCD: physical: %d virt: %d\n", phys_carrier, virt_carrier);
+	jsm_dbg(CARR, &ch->ch_bd->pci_dev, "DCD: physical: %d virt: %d\n",
+		phys_carrier, virt_carrier);
 
 	/*
 	 * Test for a VIRTUAL carrier transition to HIGH.
@@ -694,8 +695,7 @@ static void jsm_carrier(struct jsm_channel *ch)
 		 * for carrier in the open routine.
 		 */
 
-		jsm_printk(CARR, INFO, &ch->ch_bd->pci_dev,
-			"carrier: virt DCD rose\n");
+		jsm_dbg(CARR, &ch->ch_bd->pci_dev, "carrier: virt DCD rose\n");
 
 		if (waitqueue_active(&(ch->ch_flags_wait)))
 			wake_up_interruptible(&ch->ch_flags_wait);
@@ -711,7 +711,7 @@ static void jsm_carrier(struct jsm_channel *ch)
 		 * for carrier in the open routine.
 		 */
 
-		jsm_printk(CARR, INFO, &ch->ch_bd->pci_dev,
+		jsm_dbg(CARR, &ch->ch_bd->pci_dev,
 			"carrier: physical DCD rose\n");
 
 		if (waitqueue_active(&(ch->ch_flags_wait)))
@@ -790,8 +790,8 @@ void jsm_check_queue_flow_control(struct jsm_channel *ch)
 			if(!(ch->ch_flags & CH_RECEIVER_OFF)) {
 				bd_ops->disable_receiver(ch);
 				ch->ch_flags |= (CH_RECEIVER_OFF);
-				jsm_printk(READ, INFO, &ch->ch_bd->pci_dev,
-					"Internal queue hit hilevel mark (%d)! Turning off interrupts.\n",
+				jsm_dbg(READ, &ch->ch_bd->pci_dev,
+					"Internal queue hit hilevel mark (%d)! Turning off interrupts\n",
 					qleft);
 			}
 		}
@@ -800,8 +800,9 @@ void jsm_check_queue_flow_control(struct jsm_channel *ch)
 			if (ch->ch_stops_sent <= MAX_STOPS_SENT) {
 				bd_ops->send_stop_character(ch);
 				ch->ch_stops_sent++;
-				jsm_printk(READ, INFO, &ch->ch_bd->pci_dev,
-					"Sending stop char! Times sent: %x\n", ch->ch_stops_sent);
+				jsm_dbg(READ, &ch->ch_bd->pci_dev,
+					"Sending stop char! Times sent: %x\n",
+					ch->ch_stops_sent);
 			}
 		}
 	}
@@ -827,8 +828,8 @@ void jsm_check_queue_flow_control(struct jsm_channel *ch)
 			if (ch->ch_flags & CH_RECEIVER_OFF) {
 				bd_ops->enable_receiver(ch);
 				ch->ch_flags &= ~(CH_RECEIVER_OFF);
-				jsm_printk(READ, INFO, &ch->ch_bd->pci_dev,
-					"Internal queue hit lowlevel mark (%d)! Turning on interrupts.\n",
+				jsm_dbg(READ, &ch->ch_bd->pci_dev,
+					"Internal queue hit lowlevel mark (%d)! Turning on interrupts\n",
 					qleft);
 			}
 		}
@@ -836,7 +837,8 @@ void jsm_check_queue_flow_control(struct jsm_channel *ch)
 		else if (ch->ch_c_iflag & IXOFF && ch->ch_stops_sent) {
 			ch->ch_stops_sent = 0;
 			bd_ops->send_start_character(ch);
-			jsm_printk(READ, INFO, &ch->ch_bd->pci_dev, "Sending start char!\n");
+			jsm_dbg(READ, &ch->ch_bd->pci_dev,
+				"Sending start char!\n");
 		}
 	}
 }


