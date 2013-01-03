Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab3ACOyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 09:54:39 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:60985 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab3ACOxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 09:53:18 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 06/10] TTY: switch tty_flip_buffer_push
Date: Thu,  3 Jan 2013 15:53:06 +0100
Message-Id: <1357224789-2853-7-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
References: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, we start converting tty buffer functions to actually use
tty_port. This will allow us to get rid of the need of tty in many
call sites. Only tty_port will needed and hence no more
tty_port_tty_get in those paths.

Now, the one where most of tty_port_tty_get gets removed:
tty_flip_buffer_push.

IOW we also closed all the races in drivers not using tty_port_tty_get
at all yet.

Also we move tty_flip_buffer_push declaration from include/linux/tty.h
to include/linux/tty_flip.h to all others while we are changing it
anyway.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/ia64/hp/sim/simserial.c                | 18 ++-------
 arch/mn10300/kernel/mn10300-serial.c        |  7 ++--
 arch/parisc/kernel/pdc_cons.c               |  8 +---
 arch/um/drivers/chan.h                      |  3 +-
 arch/um/drivers/chan_kern.c                 | 14 +++----
 arch/um/drivers/line.c                      |  7 ++--
 arch/xtensa/platforms/iss/console.c         |  9 ++---
 drivers/char/pcmcia/synclink_cs.c           | 14 ++-----
 drivers/ipack/devices/ipoctal.c             | 14 ++-----
 drivers/isdn/gigaset/interface.c            | 10 +----
 drivers/isdn/i4l/isdn_tty.c                 | 39 ++++++++-----------
 drivers/mmc/card/sdio_uart.c                | 14 ++-----
 drivers/net/usb/hso.c                       | 31 ++++++++-------
 drivers/s390/char/con3215.c                 |  4 +-
 drivers/s390/char/sclp_tty.c                |  4 +-
 drivers/s390/char/sclp_vt220.c              |  8 +---
 drivers/staging/ccg/u_serial.c              | 11 ++----
 drivers/staging/dgrp/dgrp_net_ops.c         |  4 +-
 drivers/staging/fwserial/fwserial.c         | 41 ++++++++------------
 drivers/staging/serqt_usb2/serqt_usb2.c     |  9 ++---
 drivers/tty/amiserial.c                     |  5 +--
 drivers/tty/bfin_jtag_comm.c                | 22 +++++------
 drivers/tty/ehv_bytechan.c                  |  9 +----
 drivers/tty/hvc/hvc_console.c               |  2 +-
 drivers/tty/hvc/hvcs.c                      |  2 +-
 drivers/tty/hvc/hvsi.c                      |  6 +--
 drivers/tty/ipwireless/tty.c                |  8 +---
 drivers/tty/isicom.c                        |  4 +-
 drivers/tty/mxser.c                         |  2 +-
 drivers/tty/n_gsm.c                         | 58 ++++++++++++++---------------
 drivers/tty/nozomi.c                        | 14 +++----
 drivers/tty/pty.c                           |  2 +-
 drivers/tty/rocket.c                        | 25 ++++++-------
 drivers/tty/serial/21285.c                  |  3 +-
 drivers/tty/serial/8250/8250.c              |  3 +-
 drivers/tty/serial/altera_jtaguart.c        |  2 +-
 drivers/tty/serial/altera_uart.c            |  2 +-
 drivers/tty/serial/amba-pl010.c             |  3 +-
 drivers/tty/serial/amba-pl011.c             |  7 +---
 drivers/tty/serial/apbuart.c                |  3 +-
 drivers/tty/serial/ar933x_uart.c            |  7 +---
 drivers/tty/serial/arc_uart.c               |  8 +---
 drivers/tty/serial/atmel_serial.c           |  5 +--
 drivers/tty/serial/bcm63xx_uart.c           |  4 +-
 drivers/tty/serial/bfin_sport_uart.c        |  4 +-
 drivers/tty/serial/bfin_uart.c              | 10 ++---
 drivers/tty/serial/clps711x.c               |  8 +---
 drivers/tty/serial/cpm_uart/cpm_uart_core.c |  3 +-
 drivers/tty/serial/crisv10.c                | 17 +--------
 drivers/tty/serial/dz.c                     |  4 +-
 drivers/tty/serial/efm32-uart.c             |  8 +---
 drivers/tty/serial/icom.c                   |  3 +-
 drivers/tty/serial/ifx6x60.c                |  6 +--
 drivers/tty/serial/imx.c                    |  3 +-
 drivers/tty/serial/ioc3_serial.c            |  6 +--
 drivers/tty/serial/ioc4_serial.c            |  6 +--
 drivers/tty/serial/jsm/jsm_tty.c            |  2 +-
 drivers/tty/serial/kgdb_nmi.c               | 10 +----
 drivers/tty/serial/lantiq.c                 | 15 +++-----
 drivers/tty/serial/lpc32xx_hs.c             | 16 +-------
 drivers/tty/serial/m32r_sio.c               |  3 +-
 drivers/tty/serial/max3100.c                |  8 ++--
 drivers/tty/serial/max310x.c                |  8 +---
 drivers/tty/serial/mcf.c                    |  2 +-
 drivers/tty/serial/mfd.c                    | 12 +-----
 drivers/tty/serial/mpc52xx_uart.c           |  3 +-
 drivers/tty/serial/mpsc.c                   |  5 +--
 drivers/tty/serial/mrst_max3110.c           | 11 +-----
 drivers/tty/serial/msm_serial.c             |  6 +--
 drivers/tty/serial/msm_serial_hs.c          |  3 +-
 drivers/tty/serial/msm_smd_tty.c            |  2 +-
 drivers/tty/serial/mux.c                    |  6 +--
 drivers/tty/serial/mxs-auart.c              |  6 +--
 drivers/tty/serial/netx-serial.c            |  4 +-
 drivers/tty/serial/nwpserial.c              |  3 +-
 drivers/tty/serial/omap-serial.c            |  3 +-
 drivers/tty/serial/pch_uart.c               | 19 +---------
 drivers/tty/serial/pmac_zilog.c             | 30 +++++++--------
 drivers/tty/serial/pnx8xxx_uart.c           |  3 +-
 drivers/tty/serial/pxa.c                    |  3 +-
 drivers/tty/serial/sa1100.c                 |  3 +-
 drivers/tty/serial/samsung.c                |  3 +-
 drivers/tty/serial/sb1250-duart.c           |  2 +-
 drivers/tty/serial/sc26xx.c                 | 27 ++++++--------
 drivers/tty/serial/sccnxp.c                 |  8 +---
 drivers/tty/serial/serial_ks8695.c          |  3 +-
 drivers/tty/serial/serial_txx9.c            |  3 +-
 drivers/tty/serial/sh-sci.c                 | 18 +++------
 drivers/tty/serial/sirfsoc_uart.c           |  8 +---
 drivers/tty/serial/sn_console.c             | 12 ++----
 drivers/tty/serial/sunhv.c                  | 16 ++++----
 drivers/tty/serial/sunsab.c                 | 20 ++++------
 drivers/tty/serial/sunsu.c                  | 13 ++-----
 drivers/tty/serial/sunzilog.c               | 28 ++++++--------
 drivers/tty/serial/timbuart.c               |  2 +-
 drivers/tty/serial/uartlite.c               |  2 +-
 drivers/tty/serial/ucc_uart.c               |  3 +-
 drivers/tty/serial/vr41xx_siu.c             |  4 +-
 drivers/tty/serial/vt8500_serial.c          | 12 +-----
 drivers/tty/serial/xilinx_uartps.c          | 14 ++-----
 drivers/tty/serial/zs.c                     |  2 +-
 drivers/tty/synclink.c                      |  5 +--
 drivers/tty/synclink_gt.c                   |  5 +--
 drivers/tty/synclinkmp.c                    |  4 +-
 drivers/tty/tty_buffer.c                    |  8 ++--
 drivers/usb/class/cdc-acm.c                 | 10 +----
 drivers/usb/gadget/u_serial.c               |  4 +-
 drivers/usb/serial/aircable.c               |  8 +---
 drivers/usb/serial/ark3116.c                |  8 +---
 drivers/usb/serial/belkin_sa.c              |  8 +---
 drivers/usb/serial/cyberjack.c              |  9 +----
 drivers/usb/serial/cypress_m8.c             |  4 +-
 drivers/usb/serial/digi_acceleport.c        |  8 +---
 drivers/usb/serial/f81232.c                 |  8 +---
 drivers/usb/serial/ftdi_sio.c               |  8 +---
 drivers/usb/serial/garmin_gps.c             |  7 +---
 drivers/usb/serial/generic.c                |  8 +---
 drivers/usb/serial/io_edgeport.c            | 35 +++++++----------
 drivers/usb/serial/io_ti.c                  | 27 +++++---------
 drivers/usb/serial/ir-usb.c                 |  7 +---
 drivers/usb/serial/iuu_phoenix.c            |  7 +---
 drivers/usb/serial/keyspan.c                | 31 ++++-----------
 drivers/usb/serial/keyspan_pda.c            |  7 +---
 drivers/usb/serial/kl5kusb105.c             |  8 +---
 drivers/usb/serial/kobil_sct.c              |  7 +---
 drivers/usb/serial/mct_u232.c               | 11 ++----
 drivers/usb/serial/metro-usb.c              |  7 +---
 drivers/usb/serial/mos7720.c                |  7 +---
 drivers/usb/serial/mos7840.c                |  9 +----
 drivers/usb/serial/navman.c                 |  7 +---
 drivers/usb/serial/omninet.c                | 11 ++----
 drivers/usb/serial/opticon.c                |  9 +----
 drivers/usb/serial/oti6858.c                |  7 +---
 drivers/usb/serial/pl2303.c                 |  8 +---
 drivers/usb/serial/quatech2.c               | 19 +---------
 drivers/usb/serial/safe_serial.c            | 13 ++-----
 drivers/usb/serial/sierra.c                 | 17 +++------
 drivers/usb/serial/spcp8x5.c                | 18 ++++-----
 drivers/usb/serial/ssu100.c                 | 23 ++----------
 drivers/usb/serial/symbolserial.c           | 10 +----
 drivers/usb/serial/ti_usb_3410_5052.c       | 39 ++++++++-----------
 drivers/usb/serial/usb_wwan.c               | 17 +++------
 include/linux/tty.h                         |  1 -
 include/linux/tty_flip.h                    |  1 +
 net/bluetooth/rfcomm/tty.c                  | 16 +++-----
 net/irda/ircomm/ircomm_tty.c                |  4 +-
 146 files changed, 446 insertions(+), 988 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 942022a..da2f319 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -53,9 +53,8 @@ struct tty_driver *hp_simserial_driver;
 
 static struct console *console;
 
-static void receive_chars(struct tty_struct *tty)
+static void receive_chars(struct tty_port *port)
 {
-	struct tty_port *port = tty->port;
 	unsigned char ch;
 	static unsigned char seen_esc = 0;
 
@@ -85,7 +84,7 @@ static void receive_chars(struct tty_struct *tty)
 		if (tty_insert_flip_char(port, ch, TTY_NORMAL) == 0)
 			break;
 	}
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(port);
 }
 
 /*
@@ -94,18 +93,9 @@ static void receive_chars(struct tty_struct *tty)
 static irqreturn_t rs_interrupt_single(int irq, void *dev_id)
 {
 	struct serial_state *info = dev_id;
-	struct tty_struct *tty = tty_port_tty_get(&info->port);
 
-	if (!tty) {
-		printk(KERN_INFO "%s: tty=0 problem\n", __func__);
-		return IRQ_NONE;
-	}
-	/*
-	 * pretty simple in our case, because we only get interrupts
-	 * on inbound traffic
-	 */
-	receive_chars(tty);
-	tty_kref_put(tty);
+	receive_chars(&info->port);
+
 	return IRQ_HANDLED;
 }
 
diff --git a/arch/mn10300/kernel/mn10300-serial.c b/arch/mn10300/kernel/mn10300-serial.c
index ae61bd6..1dd20db 100644
--- a/arch/mn10300/kernel/mn10300-serial.c
+++ b/arch/mn10300/kernel/mn10300-serial.c
@@ -525,7 +525,6 @@ static void mn10300_serial_receive_interrupt(struct mn10300_serial_port *port)
 {
 	struct uart_icount *icount = &port->uart.icount;
 	struct tty_port *port = &port->uart.state->port;
-	struct tty_struct *tty = port->tty;
 	unsigned ix;
 	int count;
 	u8 st, ch, push, status, overrun;
@@ -538,7 +537,7 @@ static void mn10300_serial_receive_interrupt(struct mn10300_serial_port *port)
 	count = tty_buffer_request_room(port, count);
 	if (count == 0) {
 		if (!port->low_latency)
-			tty_flip_buffer_push(tty);
+			tty_flip_buffer_push(port);
 		return;
 	}
 
@@ -547,7 +546,7 @@ try_again:
 	ix = ACCESS_ONCE(port->rx_outp);
 	if (CIRC_CNT(port->rx_inp, ix, MNSC_BUFFER_SIZE) == 0) {
 		if (push && !port->low_latency)
-			tty_flip_buffer_push(tty);
+			tty_flip_buffer_push(port);
 		return;
 	}
 
@@ -679,7 +678,7 @@ insert:
 	count--;
 	if (count <= 0) {
 		if (!port->low_latency)
-			tty_flip_buffer_push(tty);
+			tty_flip_buffer_push(port);
 		return;
 	}
 
diff --git a/arch/parisc/kernel/pdc_cons.c b/arch/parisc/kernel/pdc_cons.c
index 4d92a37..d5cae55 100644
--- a/arch/parisc/kernel/pdc_cons.c
+++ b/arch/parisc/kernel/pdc_cons.c
@@ -138,10 +138,6 @@ static const struct tty_operations pdc_console_tty_ops = {
 static void pdc_console_poll(unsigned long unused)
 {
 	int data, count = 0;
-	struct tty_struct *tty = tty_port_tty_get(&tty_port);
-
-	if (!tty)
-		return;
 
 	while (1) {
 		data = pdc_console_poll_key(NULL);
@@ -152,9 +148,7 @@ static void pdc_console_poll(unsigned long unused)
 	}
 
 	if (count)
-		tty_flip_buffer_push(tty);
-
-	tty_kref_put(tty);
+		tty_flip_buffer_push(&tty_port);
 
 	if (pdc_cons.flags & CON_ENABLED)
 		mod_timer(&pdc_console_timer, jiffies + PDC_CONS_POLL_DELAY);
diff --git a/arch/um/drivers/chan.h b/arch/um/drivers/chan.h
index 02b5a76..78f1b89 100644
--- a/arch/um/drivers/chan.h
+++ b/arch/um/drivers/chan.h
@@ -27,8 +27,7 @@ struct chan {
 	void *data;
 };
 
-extern void chan_interrupt(struct line *line,
-			   struct tty_struct *tty, int irq);
+extern void chan_interrupt(struct line *line, int irq);
 extern int parse_chan_pair(char *str, struct line *line, int device,
 			   const struct chan_opts *opts, char **error_out);
 extern int write_chan(struct chan *chan, const char *buf, int len,
diff --git a/arch/um/drivers/chan_kern.c b/arch/um/drivers/chan_kern.c
index 795bd81..15c553c 100644
--- a/arch/um/drivers/chan_kern.c
+++ b/arch/um/drivers/chan_kern.c
@@ -131,11 +131,9 @@ void chan_enable_winch(struct chan *chan, struct tty_struct *tty)
 static void line_timer_cb(struct work_struct *work)
 {
 	struct line *line = container_of(work, struct line, task.work);
-	struct tty_struct *tty = tty_port_tty_get(&line->port);
 
 	if (!line->throttled)
-		chan_interrupt(line, tty, line->driver->read_irq);
-	tty_kref_put(tty);
+		chan_interrupt(line, line->driver->read_irq);
 }
 
 int enable_chan(struct line *line)
@@ -546,7 +544,7 @@ int parse_chan_pair(char *str, struct line *line, int device,
 	return 0;
 }
 
-void chan_interrupt(struct line *line, struct tty_struct *tty, int irq)
+void chan_interrupt(struct line *line, int irq)
 {
 	struct tty_port *port = &line->port;
 	struct chan *chan = line->chan_in;
@@ -570,8 +568,11 @@ void chan_interrupt(struct line *line, struct tty_struct *tty, int irq)
 		reactivate_fd(chan->fd, irq);
 	if (err == -EIO) {
 		if (chan->primary) {
-			if (tty != NULL)
+			struct tty_struct *tty = tty_port_tty_get(&line->port);
+			if (tty != NULL) {
 				tty_hangup(tty);
+				tty_kref_put(tty);
+			}
 			if (line->chan_out != chan)
 				close_one_chan(line->chan_out, 1);
 		}
@@ -580,6 +581,5 @@ void chan_interrupt(struct line *line, struct tty_struct *tty, int irq)
 			return;
 	}
  out:
-	if (tty)
-		tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(port);
 }
diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 9ffc28b..f1b3857 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -19,11 +19,10 @@ static irqreturn_t line_interrupt(int irq, void *data)
 {
 	struct chan *chan = data;
 	struct line *line = chan->line;
-	struct tty_struct *tty = tty_port_tty_get(&line->port);
 
 	if (line)
-		chan_interrupt(line, tty, irq);
-	tty_kref_put(tty);
+		chan_interrupt(line, irq);
+
 	return IRQ_HANDLED;
 }
 
@@ -234,7 +233,7 @@ void line_unthrottle(struct tty_struct *tty)
 	struct line *line = tty->driver_data;
 
 	line->throttled = 0;
-	chan_interrupt(line, tty, line->driver->read_irq);
+	chan_interrupt(line, line->driver->read_irq);
 
 	/*
 	 * Maybe there is enough stuff pending that calling the interrupt
diff --git a/arch/xtensa/platforms/iss/console.c b/arch/xtensa/platforms/iss/console.c
index 62447d6..da9866f 100644
--- a/arch/xtensa/platforms/iss/console.c
+++ b/arch/xtensa/platforms/iss/console.c
@@ -58,7 +58,8 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 	tty->port = &serial_port;
 	spin_lock(&timer_lock);
 	if (tty->count == 1) {
-		setup_timer(&serial_timer, rs_poll, (unsigned long)tty);
+		setup_timer(&serial_timer, rs_poll,
+				(unsigned long)&serial_port);
 		mod_timer(&serial_timer, jiffies + SERIAL_TIMER_VALUE);
 	}
 	spin_unlock(&timer_lock);
@@ -97,9 +98,7 @@ static int rs_write(struct tty_struct * tty,
 
 static void rs_poll(unsigned long priv)
 {
-	struct tty_struct* tty = (struct tty_struct*) priv;
-	struct tty_port *port = tty->port;
-
+	struct tty_port *port = (struct tty_port *)priv;
 	struct timeval tv = { .tv_sec = 0, .tv_usec = 0 };
 	int i = 0;
 	unsigned char c;
@@ -113,7 +112,7 @@ static void rs_poll(unsigned long priv)
 	}
 
 	if (i)
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(port);
 
 
 	mod_timer(&serial_timer, jiffies + SERIAL_TIMER_VALUE);
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 47cbacf..a046b17 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -886,7 +886,7 @@ static void rx_ready_hdlc(MGSLPC_INFO *info, int eom)
 	issue_command(info, CHA, CMD_RXFIFO);
 }
 
-static void rx_ready_async(MGSLPC_INFO *info, int tcd, struct tty_struct *tty)
+static void rx_ready_async(MGSLPC_INFO *info, int tcd)
 {
 	struct tty_port *port = &info->port;
 	unsigned char data, status, flag;
@@ -894,14 +894,6 @@ static void rx_ready_async(MGSLPC_INFO *info, int tcd, struct tty_struct *tty)
 	int work = 0;
  	struct mgsl_icount *icount = &info->icount;
 
-	if (!tty) {
-		/* tty is not available anymore */
-		issue_command(info, CHA, CMD_RXRESET);
-		if (debug_level >= DEBUG_LEVEL_ISR)
-			printk("%s(%d):rx_ready_async(tty=NULL)\n",__FILE__,__LINE__);
-		return;
-	}
-
 	if (tcd) {
 		/* early termination, get FIFO count from RBCL register */
 		fifo_count = (unsigned char)(read_reg(info, CHA+RBCL) & 0x1f);
@@ -958,7 +950,7 @@ static void rx_ready_async(MGSLPC_INFO *info, int tcd, struct tty_struct *tty)
 	}
 
 	if (work)
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(port);
 }
 
 
@@ -1218,7 +1210,7 @@ static irqreturn_t mgslpc_isr(int dummy, void *dev_id)
 				if (info->params.mode == MGSL_MODE_HDLC)
 					rx_ready_hdlc(info, isr & IRQ_RXEOM);
 				else
-					rx_ready_async(info, isr & IRQ_RXEOM, tty);
+					rx_ready_async(info, isr & IRQ_RXEOM);
 			}
 
 			/* transmit IRQs */
diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 8e0ed66..ab20a085 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -133,8 +133,7 @@ static int ipoctal_get_icount(struct tty_struct *tty,
 	return 0;
 }
 
-static void ipoctal_irq_rx(struct ipoctal_channel *channel,
-			   struct tty_struct *tty, u8 sr)
+static void ipoctal_irq_rx(struct ipoctal_channel *channel, u8 sr)
 {
 	struct tty_port *port = &channel->tty_port;
 	unsigned char value;
@@ -176,7 +175,7 @@ static void ipoctal_irq_rx(struct ipoctal_channel *channel,
 		sr = ioread8(&channel->regs->r.sr);
 	} while (isr & channel->isr_rx_rdy_mask);
 
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(port);
 }
 
 static void ipoctal_irq_tx(struct ipoctal_channel *channel)
@@ -209,15 +208,11 @@ static void ipoctal_irq_tx(struct ipoctal_channel *channel)
 static void ipoctal_irq_channel(struct ipoctal_channel *channel)
 {
 	u8 isr, sr;
-	struct tty_struct *tty;
 
 	/* If there is no client, skip the check */
 	if (!atomic_read(&channel->open))
 		return;
 
-	tty = tty_port_tty_get(&channel->tty_port);
-	if (!tty)
-		return;
 	/* The HW is organized in pair of channels.  See which register we need
 	 * to read from */
 	isr = ioread8(&channel->block_regs->r.isr);
@@ -236,14 +231,13 @@ static void ipoctal_irq_channel(struct ipoctal_channel *channel)
 
 	/* RX data */
 	if ((isr & channel->isr_rx_rdy_mask) && (sr & SR_RX_READY))
-		ipoctal_irq_rx(channel, tty, sr);
+		ipoctal_irq_rx(channel, sr);
 
 	/* TX of each character */
 	if ((isr & channel->isr_tx_rdy_mask) && (sr & SR_TX_READY))
 		ipoctal_irq_tx(channel);
 
-	tty_flip_buffer_push(tty);
-	tty_kref_put(tty);
+	tty_flip_buffer_push(&channel->tty_port);
 }
 
 static irqreturn_t ipoctal_irq_handler(void *arg)
diff --git a/drivers/isdn/gigaset/interface.c b/drivers/isdn/gigaset/interface.c
index 6dcecd4..0fbf4f2 100644
--- a/drivers/isdn/gigaset/interface.c
+++ b/drivers/isdn/gigaset/interface.c
@@ -562,16 +562,8 @@ void gigaset_if_free(struct cardstate *cs)
 void gigaset_if_receive(struct cardstate *cs,
 			unsigned char *buffer, size_t len)
 {
-	struct tty_struct *tty = tty_port_tty_get(&cs->port);
-
-	if (tty == NULL) {
-		gig_dbg(DEBUG_IF, "receive on closed device");
-		return;
-	}
-
 	tty_insert_flip_string(&cs->port, buffer, len);
-	tty_flip_buffer_push(tty);
-	tty_kref_put(tty);
+	tty_flip_buffer_push(&cs->port);
 }
 EXPORT_SYMBOL_GPL(gigaset_if_receive);
 
diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index 9bb9986..d8a7d83 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -63,16 +63,11 @@ isdn_tty_try_read(modem_info *info, struct sk_buff *skb)
 	struct tty_port *port = &info->port;
 	int c;
 	int len;
-	struct tty_struct *tty;
 	char last;
 
 	if (!info->online)
 		return 0;
 
-	tty = port->tty;
-	if (!tty)
-		return 0;
-
 	if (!(info->mcr & UART_MCR_RTS))
 		return 0;
 
@@ -110,7 +105,7 @@ isdn_tty_try_read(modem_info *info, struct sk_buff *skb)
 		tty_insert_flip_char(port, last, 0xFF);
 	else
 		tty_insert_flip_char(port, last, TTY_NORMAL);
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(port);
 	kfree_skb(skb);
 
 	return 1;
@@ -127,7 +122,6 @@ isdn_tty_readmodem(void)
 	int midx;
 	int i;
 	int r;
-	struct tty_struct *tty;
 	modem_info *info;
 
 	for (i = 0; i < ISDN_MAX_CHANNELS; i++) {
@@ -145,20 +139,21 @@ isdn_tty_readmodem(void)
 		if ((info->vonline & 1) && (info->emu.vpar[1]))
 			isdn_audio_eval_silence(info);
 #endif
-		tty = info->port.tty;
-		if (tty) {
-			if (info->mcr & UART_MCR_RTS) {
-				/* CISCO AsyncPPP Hack */
-				if (!(info->emu.mdmreg[REG_CPPP] & BIT_CPPP))
-					r = isdn_readbchan_tty(info->isdn_driver, info->isdn_channel, &info->port, 0);
-				else
-					r = isdn_readbchan_tty(info->isdn_driver, info->isdn_channel, &info->port, 1);
-				if (r)
-					tty_flip_buffer_push(tty);
-			} else
-				r = 1;
+		if (info->mcr & UART_MCR_RTS) {
+			/* CISCO AsyncPPP Hack */
+			if (!(info->emu.mdmreg[REG_CPPP] & BIT_CPPP))
+				r = isdn_readbchan_tty(info->isdn_driver,
+						info->isdn_channel,
+						&info->port, 0);
+			else
+				r = isdn_readbchan_tty(info->isdn_driver,
+						info->isdn_channel,
+						&info->port, 1);
+			if (r)
+				tty_flip_buffer_push(&info->port);
 		} else
 			r = 1;
+
 		if (r) {
 			info->rcvsched = 0;
 			resched = 1;
@@ -2230,7 +2225,6 @@ isdn_tty_stat_callback(int i, isdn_ctrl *c)
 void
 isdn_tty_at_cout(char *msg, modem_info *info)
 {
-	struct tty_struct *tty;
 	struct tty_port *port = &info->port;
 	atemu *m = &info->emu;
 	char *p;
@@ -2248,8 +2242,7 @@ isdn_tty_at_cout(char *msg, modem_info *info)
 	l = strlen(msg);
 
 	spin_lock_irqsave(&info->readlock, flags);
-	tty = port->tty;
-	if ((port->flags & ASYNC_CLOSING) || (!tty)) {
+	if (port->flags & ASYNC_CLOSING) {
 		spin_unlock_irqrestore(&info->readlock, flags);
 		return;
 	}
@@ -2301,7 +2294,7 @@ isdn_tty_at_cout(char *msg, modem_info *info)
 
 	} else {
 		spin_unlock_irqrestore(&info->readlock, flags);
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(port);
 	}
 }
 
diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index 894078b..c931dfe 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -381,7 +381,6 @@ static void sdio_uart_stop_rx(struct sdio_uart_port *port)
 static void sdio_uart_receive_chars(struct sdio_uart_port *port,
 				    unsigned int *status)
 {
-	struct tty_struct *tty = tty_port_tty_get(&port->port);
 	unsigned int ch, flag;
 	int max_count = 256;
 
@@ -418,24 +417,19 @@ static void sdio_uart_receive_chars(struct sdio_uart_port *port,
 		}
 
 		if ((*status & port->ignore_status_mask & ~UART_LSR_OE) == 0)
-			if (tty)
-				tty_insert_flip_char(&port->port, ch, flag);
+			tty_insert_flip_char(&port->port, ch, flag);
 
 		/*
 		 * Overrun is special.  Since it's reported immediately,
 		 * it doesn't affect the current character.
 		 */
 		if (*status & ~port->ignore_status_mask & UART_LSR_OE)
-			if (tty)
-				tty_insert_flip_char(&port->port, 0,
-						TTY_OVERRUN);
+			tty_insert_flip_char(&port->port, 0, TTY_OVERRUN);
 
 		*status = sdio_in(port, UART_LSR);
 	} while ((*status & UART_LSR_DR) && (max_count-- > 0));
-	if (tty) {
-		tty_flip_buffer_push(tty);
-		tty_kref_put(tty);
-	}
+
+	tty_flip_buffer_push(&port->port);
 }
 
 static void sdio_uart_transmit_chars(struct sdio_uart_port *port)
diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index d235ca0..f902a14 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2035,24 +2035,23 @@ static int put_rxbuf_data(struct urb *urb, struct hso_serial *serial)
 	tty = tty_port_tty_get(&serial->port);
 
 	/* Push data to tty */
-	if (tty) {
-		write_length_remaining = urb->actual_length -
-			serial->curr_rx_urb_offset;
-		D1("data to push to tty");
-		while (write_length_remaining) {
-			if (test_bit(TTY_THROTTLED, &tty->flags)) {
-				tty_kref_put(tty);
-				return -1;
-			}
-			curr_write_len = tty_insert_flip_string(&serial->port,
-				urb->transfer_buffer + serial->curr_rx_urb_offset,
-				write_length_remaining);
-			serial->curr_rx_urb_offset += curr_write_len;
-			write_length_remaining -= curr_write_len;
-			tty_flip_buffer_push(tty);
+	write_length_remaining = urb->actual_length -
+		serial->curr_rx_urb_offset;
+	D1("data to push to tty");
+	while (write_length_remaining) {
+		if (tty && test_bit(TTY_THROTTLED, &tty->flags)) {
+			tty_kref_put(tty);
+			return -1;
 		}
-		tty_kref_put(tty);
+		curr_write_len = tty_insert_flip_string(&serial->port,
+			urb->transfer_buffer + serial->curr_rx_urb_offset,
+			write_length_remaining);
+		serial->curr_rx_urb_offset += curr_write_len;
+		write_length_remaining -= curr_write_len;
+		tty_flip_buffer_push(&serial->port);
 	}
+	tty_kref_put(tty);
+
 	if (write_length_remaining == 0) {
 		serial->curr_rx_urb_offset = 0;
 		serial->rx_urb_filled[hso_urb_to_index(serial, urb)] = 0;
diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 41b75c5..2f58e9f 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -413,7 +413,7 @@ static void raw3215_irq(struct ccw_device *cdev, unsigned long intparm,
 			case CTRLCHAR_CTRL:
 				tty_insert_flip_char(&raw->port, cchar,
 						TTY_NORMAL);
-				tty_flip_buffer_push(tty);
+				tty_flip_buffer_push(&raw->port);
 				break;
 
 			case CTRLCHAR_NONE:
@@ -427,7 +427,7 @@ static void raw3215_irq(struct ccw_device *cdev, unsigned long intparm,
 					count -= 2;
 				tty_insert_flip_string(&raw->port, raw->inbuf,
 						count);
-				tty_flip_buffer_push(tty);
+				tty_flip_buffer_push(&raw->port);
 				break;
 			}
 		} else if (req->type == RAW3215_WRITE) {
diff --git a/drivers/s390/char/sclp_tty.c b/drivers/s390/char/sclp_tty.c
index 19b7c51..14b4cb8 100644
--- a/drivers/s390/char/sclp_tty.c
+++ b/drivers/s390/char/sclp_tty.c
@@ -343,7 +343,7 @@ sclp_tty_input(unsigned char* buf, unsigned int count)
 		break;
 	case CTRLCHAR_CTRL:
 		tty_insert_flip_char(&sclp_port, cchar, TTY_NORMAL);
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&sclp_port);
 		break;
 	case CTRLCHAR_NONE:
 		/* send (normal) input to line discipline */
@@ -355,7 +355,7 @@ sclp_tty_input(unsigned char* buf, unsigned int count)
 			tty_insert_flip_char(&sclp_port, '\n', TTY_NORMAL);
 		} else
 			tty_insert_flip_string(&sclp_port, buf, count - 2);
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&sclp_port);
 		break;
 	}
 	tty_kref_put(tty);
diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index 0eca99b..6c92f62 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -461,14 +461,9 @@ sclp_vt220_write(struct tty_struct *tty, const unsigned char *buf, int count)
 static void
 sclp_vt220_receiver_fn(struct evbuf_header *evbuf)
 {
-	struct tty_struct *tty = tty_port_tty_get(&sclp_vt220_port);
 	char *buffer;
 	unsigned int count;
 
-	/* Ignore input if device is not open */
-	if (tty == NULL)
-		return;
-
 	buffer = (char *) ((addr_t) evbuf + sizeof(struct evbuf_header));
 	count = evbuf->length - sizeof(struct evbuf_header);
 
@@ -481,10 +476,9 @@ sclp_vt220_receiver_fn(struct evbuf_header *evbuf)
 		buffer++;
 		count--;
 		tty_insert_flip_string(&sclp_vt220_port, buffer, count);
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&sclp_vt220_port);
 		break;
 	}
-	tty_kref_put(tty);
 }
 
 /*
diff --git a/drivers/staging/ccg/u_serial.c b/drivers/staging/ccg/u_serial.c
index 7df2c02..b10947a 100644
--- a/drivers/staging/ccg/u_serial.c
+++ b/drivers/staging/ccg/u_serial.c
@@ -491,12 +491,8 @@ static void gs_rx_push(unsigned long _port)
 
 		req = list_first_entry(queue, struct usb_request, list);
 
-		/* discard data if tty was closed */
-		if (!tty)
-			goto recycle;
-
 		/* leave data queued if tty was rx throttled */
-		if (test_bit(TTY_THROTTLED, &tty->flags))
+		if (tty && test_bit(TTY_THROTTLED, &tty->flags))
 			break;
 
 		switch (req->status) {
@@ -542,7 +538,6 @@ static void gs_rx_push(unsigned long _port)
 			}
 			port->n_read = 0;
 		}
-recycle:
 		list_move(&req->list, &port->read_pool);
 		port->read_started--;
 	}
@@ -550,8 +545,8 @@ recycle:
 	/* Push from tty to ldisc; without low_latency set this is handled by
 	 * a workqueue, so we won't get callbacks and can hold port_lock
 	 */
-	if (tty && do_push)
-		tty_flip_buffer_push(tty);
+	if (do_push)
+		tty_flip_buffer_push(&port->port);
 
 
 	/* We want our data queue to become empty ASAP, keeping data
diff --git a/drivers/staging/dgrp/dgrp_net_ops.c b/drivers/staging/dgrp/dgrp_net_ops.c
index e618a66..4c7abfa 100644
--- a/drivers/staging/dgrp/dgrp_net_ops.c
+++ b/drivers/staging/dgrp/dgrp_net_ops.c
@@ -234,7 +234,7 @@ static void dgrp_input(struct ch_struct *ch)
 
 		tty_insert_flip_string_flags(&ch->port, myflipbuf,
 					     myflipflagbuf, len);
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&ch->port);
 
 		ch->ch_rxcount += len;
 	}
@@ -2958,7 +2958,7 @@ check_query:
 
 				tty_buffer_request_room(&ch->port, 1);
 				tty_insert_flip_char(&ch->port, 0, TTY_BREAK);
-				tty_flip_buffer_push(ch->ch_tun.un_tty);
+				tty_flip_buffer_push(&ch->port);
 
 			}
 
diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index a2a0c43..b403393 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -489,16 +489,11 @@ static void fwtty_do_hangup(struct work_struct *work)
 static void fwtty_emit_breaks(struct work_struct *work)
 {
 	struct fwtty_port *port = to_port(to_delayed_work(work), emit_breaks);
-	struct tty_struct *tty;
 	static const char buf[16];
 	unsigned long now = jiffies;
 	unsigned long elapsed = now - port->break_last;
 	int n, t, c, brk = 0;
 
-	tty = tty_port_tty_get(&port->port);
-	if (!tty)
-		return;
-
 	/* generate breaks at the line rate (but at least 1) */
 	n = (elapsed * port->cps) / HZ + 1;
 	port->break_last = now;
@@ -514,9 +509,7 @@ static void fwtty_emit_breaks(struct work_struct *work)
 		if (c < t)
 			break;
 	}
-	tty_flip_buffer_push(tty);
-
-	tty_kref_put(tty);
+	tty_flip_buffer_push(&port->port);
 
 	if (port->mstatus & (UART_LSR_BI << 24))
 		schedule_delayed_work(&port->emit_breaks, FREQ_BREAKS);
@@ -530,10 +523,6 @@ static void fwtty_pushrx(struct work_struct *work)
 	struct buffered_rx *buf, *next;
 	int n, c = 0;
 
-	tty = tty_port_tty_get(&port->port);
-	if (!tty)
-		return;
-
 	spin_lock_bh(&port->lock);
 	list_for_each_entry_safe(buf, next, &port->buf_list, list) {
 		n = tty_insert_flip_string_fixed_flag(&port->port, buf->data,
@@ -545,7 +534,11 @@ static void fwtty_pushrx(struct work_struct *work)
 				memmove(buf->data, buf->data + n, buf->n - n);
 				buf->n -= n;
 			}
-			__fwtty_throttle(port, tty);
+			tty = tty_port_tty_get(&port->port);
+			if (tty) {
+				__fwtty_throttle(port, tty);
+				tty_kref_put(tty);
+			}
 			break;
 		} else {
 			list_del(&buf->list);
@@ -553,13 +546,11 @@ static void fwtty_pushrx(struct work_struct *work)
 		}
 	}
 	if (c > 0)
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&port->port);
 
 	if (list_empty(&port->buf_list))
 		clear_bit(BUFFERING_RX, &port->flags);
 	spin_unlock_bh(&port->lock);
-
-	tty_kref_put(tty);
 }
 
 static int fwtty_buffer_rx(struct fwtty_port *port, unsigned char *d, size_t n)
@@ -594,10 +585,6 @@ static int fwtty_rx(struct fwtty_port *port, unsigned char *data, size_t len)
 	unsigned lsr;
 	int err = 0;
 
-	tty = tty_port_tty_get(&port->port);
-	if (!tty)
-		return -ENOENT;
-
 	fwtty_dbg(port, "%d", n);
 	profile_size_distrib(port->stats.reads, n);
 
@@ -634,16 +621,20 @@ static int fwtty_rx(struct fwtty_port *port, unsigned char *data, size_t len)
 		c = tty_insert_flip_string_fixed_flag(&port->port, data,
 				TTY_NORMAL, n);
 		if (c > 0)
-			tty_flip_buffer_push(tty);
+			tty_flip_buffer_push(&port->port);
 		n -= c;
 
 		if (n) {
 			/* start buffering and throttling */
 			n -= fwtty_buffer_rx(port, &data[c], n);
 
-			spin_lock_bh(&port->lock);
-			__fwtty_throttle(port, tty);
-			spin_unlock_bh(&port->lock);
+			tty = tty_port_tty_get(&port->port);
+			if (tty) {
+				spin_lock_bh(&port->lock);
+				__fwtty_throttle(port, tty);
+				spin_unlock_bh(&port->lock);
+				tty_kref_put(tty);
+			}
 		}
 	} else
 		n -= fwtty_buffer_rx(port, data, n);
@@ -654,8 +645,6 @@ static int fwtty_rx(struct fwtty_port *port, unsigned char *data, size_t len)
 	}
 
 out:
-	tty_kref_put(tty);
-
 	port->icount.rx += len;
 	port->stats.lost += n;
 	return err;
diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 1496566..df29a3d 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -290,8 +290,7 @@ static void qt_interrupt_callback(struct urb *urb)
 	/* FIXME */
 }
 
-static void qt_status_change_check(struct tty_struct *tty,
-				   struct urb *urb,
+static void qt_status_change_check(struct urb *urb,
 				   struct quatech_port *qt_port,
 				   struct usb_serial_port *port)
 {
@@ -348,7 +347,7 @@ static void qt_status_change_check(struct tty_struct *tty,
 			tty_insert_flip_char(&port->port, data[i], TTY_NORMAL);
 
 	}
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&port->port);
 }
 
 static void qt_read_bulk_callback(struct urb *urb)
@@ -411,7 +410,7 @@ static void qt_read_bulk_callback(struct urb *urb)
 	}
 
 	if (urb->actual_length)
-		qt_status_change_check(tty, urb, qt_port, port);
+		qt_status_change_check(urb, qt_port, port);
 
 	/* Continue trying to always read  */
 	usb_fill_bulk_urb(port->read_urb, serial->dev,
@@ -427,7 +426,7 @@ static void qt_read_bulk_callback(struct urb *urb)
 			__func__, result);
 	else {
 		if (urb->actual_length) {
-			tty_flip_buffer_push(tty);
+			tty_flip_buffer_push(&port->port);
 			tty_schedule_flip(tty);
 		}
 	}
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 2d1357a..4c7d701 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -251,7 +251,6 @@ static void receive_chars(struct serial_state *info)
 {
         int status;
 	int serdatr;
-	struct tty_struct *tty = info->tport.tty;
 	unsigned char ch, flag;
 	struct	async_icount *icount;
 	int oe = 0;
@@ -314,7 +313,7 @@ static void receive_chars(struct serial_state *info)
 #endif
 	    flag = TTY_BREAK;
 	    if (info->tport.flags & ASYNC_SAK)
-	      do_SAK(tty);
+	      do_SAK(info->tport.tty);
 	  } else if (status & UART_LSR_PE)
 	    flag = TTY_PARITY;
 	  else if (status & UART_LSR_FE)
@@ -331,7 +330,7 @@ static void receive_chars(struct serial_state *info)
 	tty_insert_flip_char(&info->tport, ch, flag);
 	if (oe == 1)
 		tty_insert_flip_char(&info->tport, 0, TTY_OVERRUN);
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&info->tport);
 out:
 	return;
 }
diff --git a/drivers/tty/bfin_jtag_comm.c b/drivers/tty/bfin_jtag_comm.c
index 143c385..a93a424 100644
--- a/drivers/tty/bfin_jtag_comm.c
+++ b/drivers/tty/bfin_jtag_comm.c
@@ -95,18 +95,16 @@ bfin_jc_emudat_manager(void *arg)
 
 		/* if incoming data is ready, eat it */
 		if (bfin_read_DBGSTAT() & EMUDIF) {
-			if (tty != NULL) {
-				uint32_t emudat = bfin_read_emudat();
-				if (inbound_len == 0) {
-					pr_debug("incoming length: 0x%08x\n", emudat);
-					inbound_len = emudat;
-				} else {
-					size_t num_chars = (4 <= inbound_len ? 4 : inbound_len);
-					pr_debug("  incoming data: 0x%08x (pushing %zu)\n", emudat, num_chars);
-					inbound_len -= num_chars;
-					tty_insert_flip_string(&port, (unsigned char *)&emudat, num_chars);
-					tty_flip_buffer_push(tty);
-				}
+			uint32_t emudat = bfin_read_emudat();
+			if (inbound_len == 0) {
+				pr_debug("incoming length: 0x%08x\n", emudat);
+				inbound_len = emudat;
+			} else {
+				size_t num_chars = (4 <= inbound_len ? 4 : inbound_len);
+				pr_debug("  incoming data: 0x%08x (pushing %zu)\n", emudat, num_chars);
+				inbound_len -= num_chars;
+				tty_insert_flip_string(&port, (unsigned char *)&emudat, num_chars);
+				tty_flip_buffer_push(&port);
 			}
 		}
 
diff --git a/drivers/tty/ehv_bytechan.c b/drivers/tty/ehv_bytechan.c
index 5164f9a..ed92622 100644
--- a/drivers/tty/ehv_bytechan.c
+++ b/drivers/tty/ehv_bytechan.c
@@ -371,16 +371,11 @@ console_initcall(ehv_bc_console_init);
 static irqreturn_t ehv_bc_tty_rx_isr(int irq, void *data)
 {
 	struct ehv_bc_data *bc = data;
-	struct tty_struct *ttys = tty_port_tty_get(&bc->port);
 	unsigned int rx_count, tx_count, len;
 	int count;
 	char buffer[EV_BYTE_CHANNEL_MAX_BYTES];
 	int ret;
 
-	/* ttys could be NULL during a hangup */
-	if (!ttys)
-		return IRQ_HANDLED;
-
 	/* Find out how much data needs to be read, and then ask the TTY layer
 	 * if it can handle that much.  We want to ensure that every byte we
 	 * read from the byte channel will be accepted by the TTY layer.
@@ -422,9 +417,7 @@ static irqreturn_t ehv_bc_tty_rx_isr(int irq, void *data)
 	}
 
 	/* Tell the tty layer that we're done. */
-	tty_flip_buffer_push(ttys);
-
-	tty_kref_put(ttys);
+	tty_flip_buffer_push(&bc->port);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index 8c2fe3a..eb255e8 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -691,7 +691,7 @@ int hvc_poll(struct hvc_struct *hp)
 		   a minimum for performance. */
 		timeout = MIN_TIMEOUT;
 
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&hp->port);
 	}
 	tty_kref_put(tty);
 
diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index 7bfc0a9..1956593 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -623,7 +623,7 @@ static int hvcs_io(struct hvcs_struct *hvcsd)
 	spin_unlock_irqrestore(&hvcsd->lock, flags);
 	/* This is synch because tty->low_latency == 1 */
 	if(got)
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&hvcsd->port);
 
 	if (!got) {
 		/* Do this _after_ the flip_buffer_push */
diff --git a/drivers/tty/hvc/hvsi.c b/drivers/tty/hvc/hvsi.c
index 1f528b8..dc59129 100644
--- a/drivers/tty/hvc/hvsi.c
+++ b/drivers/tty/hvc/hvsi.c
@@ -465,7 +465,7 @@ static int hvsi_load_chunk(struct hvsi_struct *hp, struct tty_struct *tty,
 	compact_inbuf(hp, packet);
 
 	if (flip)
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&hp->port);
 
 	return 1;
 }
@@ -511,7 +511,7 @@ static irqreturn_t hvsi_interrupt(int irq, void *arg)
 		/* we weren't hung up and we weren't throttled, so we can
 		 * deliver the rest now */
 		hvsi_send_overflow(hp);
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&hp->port);
 	}
 	spin_unlock_irqrestore(&hp->lock, flags);
 
@@ -998,7 +998,7 @@ static void hvsi_unthrottle(struct tty_struct *tty)
 	spin_lock_irqsave(&hp->lock, flags);
 	if (hp->n_throttle) {
 		hvsi_send_overflow(hp);
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&hp->port);
 	}
 	spin_unlock_irqrestore(&hp->lock, flags);
 
diff --git a/drivers/tty/ipwireless/tty.c b/drivers/tty/ipwireless/tty.c
index c43da74..8fd72ff 100644
--- a/drivers/tty/ipwireless/tty.c
+++ b/drivers/tty/ipwireless/tty.c
@@ -160,15 +160,9 @@ static void ipw_close(struct tty_struct *linux_tty, struct file *filp)
 void ipwireless_tty_received(struct ipw_tty *tty, unsigned char *data,
 			unsigned int length)
 {
-	struct tty_struct *linux_tty;
 	int work = 0;
 
 	mutex_lock(&tty->ipw_tty_mutex);
-	linux_tty = tty->port.tty;
-	if (linux_tty == NULL) {
-		mutex_unlock(&tty->ipw_tty_mutex);
-		return;
-	}
 
 	if (!tty->port.count) {
 		mutex_unlock(&tty->ipw_tty_mutex);
@@ -187,7 +181,7 @@ void ipwireless_tty_received(struct ipw_tty *tty, unsigned char *data,
 	 * This may sleep if ->low_latency is set
 	 */
 	if (work)
-		tty_flip_buffer_push(linux_tty);
+		tty_flip_buffer_push(&tty->port);
 }
 
 static void ipw_write_packet_sent_callback(void *callback_data,
diff --git a/drivers/tty/isicom.c b/drivers/tty/isicom.c
index c70144f..858291c 100644
--- a/drivers/tty/isicom.c
+++ b/drivers/tty/isicom.c
@@ -637,7 +637,7 @@ static irqreturn_t isicom_interrupt(int irq, void *dev_id)
 			tty_insert_flip_char(&port->port, 0, TTY_BREAK);
 			if (port->port.flags & ASYNC_SAK)
 				do_SAK(tty);
-			tty_flip_buffer_push(tty);
+			tty_flip_buffer_push(&port->port);
 			break;
 
 		case 2:	/* Statistics		 */
@@ -671,7 +671,7 @@ static irqreturn_t isicom_interrupt(int irq, void *dev_id)
 				byte_count -= 2;
 			}
 		}
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&port->port);
 	}
 	outw(0x0000, base+0x04); /* enable interrupts */
 	spin_unlock(&card->card_lock);
diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index e9cdfdf..ad34a20 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -2145,7 +2145,7 @@ end_intr:
 	 * recursive locking.
 	 */
 	spin_unlock(&port->slock);
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&port->port);
 	spin_lock(&port->slock);
 }
 
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 67f8472..e0f80ce 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1138,7 +1138,6 @@ static void gsm_control_modem(struct gsm_mux *gsm, u8 *data, int clen)
 static void gsm_control_rls(struct gsm_mux *gsm, u8 *data, int clen)
 {
 	struct tty_port *port;
-	struct tty_struct *tty;
 	unsigned int addr = 0 ;
 	u8 bits;
 	int len = clen;
@@ -1171,12 +1170,8 @@ static void gsm_control_rls(struct gsm_mux *gsm, u8 *data, int clen)
 	if (bits & 8)
 		tty_insert_flip_char(port, 0, TTY_FRAME);
 
-	/* See if we have an uplink tty */
-	tty = tty_port_tty_get(port);
-	if (tty) {
-		tty_flip_buffer_push(tty);
-		tty_kref_put(tty);
-	}
+	tty_flip_buffer_push(port);
+
 	gsm_control_reply(gsm, CMD_RLS, data, clen);
 }
 
@@ -1549,36 +1544,37 @@ static void gsm_dlci_data(struct gsm_dlci *dlci, u8 *data, int clen)
 {
 	/* krefs .. */
 	struct tty_port *port = &dlci->port;
-	struct tty_struct *tty = tty_port_tty_get(port);
+	struct tty_struct *tty;
 	unsigned int modem = 0;
 	int len = clen;
 
 	if (debug & 16)
-		pr_debug("%d bytes for tty %p\n", len, tty);
-	if (tty) {
-		switch (dlci->adaption)  {
-		/* Unsupported types */
-		/* Packetised interruptible data */
-		case 4:
-			break;
-		/* Packetised uininterruptible voice/data */
-		case 3:
-			break;
-		/* Asynchronous serial with line state in each frame */
-		case 2:
-			while (gsm_read_ea(&modem, *data++) == 0) {
-				len--;
-				if (len == 0)
-					return;
-			}
+		pr_debug("%d bytes for tty\n", len);
+	switch (dlci->adaption)  {
+	/* Unsupported types */
+	/* Packetised interruptible data */
+	case 4:
+		break;
+	/* Packetised uininterruptible voice/data */
+	case 3:
+		break;
+	/* Asynchronous serial with line state in each frame */
+	case 2:
+		while (gsm_read_ea(&modem, *data++) == 0) {
+			len--;
+			if (len == 0)
+				return;
+		}
+		tty = tty_port_tty_get(port);
+		if (tty) {
 			gsm_process_modem(tty, dlci, modem, clen);
-		/* Line state will go via DLCI 0 controls only */
-		case 1:
-		default:
-			tty_insert_flip_string(port, data, len);
-			tty_flip_buffer_push(tty);
+			tty_kref_put(tty);
 		}
-		tty_kref_put(tty);
+	/* Line state will go via DLCI 0 controls only */
+	case 1:
+	default:
+		tty_insert_flip_string(port, data, len);
+		tty_flip_buffer_push(port);
 	}
 }
 
diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index 941fe80..afdd773 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -1272,15 +1272,11 @@ static irqreturn_t interrupt_handler(int irq, void *dev_id)
 
 exit_handler:
 	spin_unlock(&dc->spin_mutex);
-	for (a = 0; a < NOZOMI_MAX_PORTS; a++) {
-		struct tty_struct *tty;
-		if (test_and_clear_bit(a, &dc->flip)) {
-			tty = tty_port_tty_get(&dc->port[a].port);
-			if (tty)
-				tty_flip_buffer_push(tty);
-			tty_kref_put(tty);
-		}
-	}
+
+	for (a = 0; a < NOZOMI_MAX_PORTS; a++)
+		if (test_and_clear_bit(a, &dc->flip))
+			tty_flip_buffer_push(&dc->port[a].port);
+
 	return IRQ_HANDLED;
 none:
 	spin_unlock(&dc->spin_mutex);
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 3c285d3..32d027c 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -123,7 +123,7 @@ static int pty_write(struct tty_struct *tty, const unsigned char *buf, int c)
 		c = tty_insert_flip_string(to->port, buf, c);
 		/* And shovel */
 		if (c) {
-			tty_flip_buffer_push(to);
+			tty_flip_buffer_push(to->port);
 			tty_wakeup(tty);
 		}
 	}
diff --git a/drivers/tty/rocket.c b/drivers/tty/rocket.c
index 5848a76..8073cc0 100644
--- a/drivers/tty/rocket.c
+++ b/drivers/tty/rocket.c
@@ -315,9 +315,8 @@ static inline int rocket_paranoia_check(struct r_port *info,
  *  that receive data is present on a serial port.  Pulls data from FIFO, moves it into the 
  *  tty layer.  
  */
-static void rp_do_receive(struct r_port *info,
-			  struct tty_struct *tty,
-			  CHANNEL_t * cp, unsigned int ChanStatus)
+static void rp_do_receive(struct r_port *info, CHANNEL_t *cp,
+		unsigned int ChanStatus)
 {
 	unsigned int CharNStat;
 	int ToRecv, wRecv, space;
@@ -416,7 +415,7 @@ static void rp_do_receive(struct r_port *info,
 			cbuf[ToRecv - 1] = sInB(sGetTxRxDataIO(cp));
 	}
 	/*  Push the data up to the tty layer */
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&info->port);
 }
 
 /*
@@ -495,7 +494,6 @@ static void rp_do_transmit(struct r_port *info)
 static void rp_handle_port(struct r_port *info)
 {
 	CHANNEL_t *cp;
-	struct tty_struct *tty;
 	unsigned int IntMask, ChanStatus;
 
 	if (!info)
@@ -506,12 +504,7 @@ static void rp_handle_port(struct r_port *info)
 				"info->flags & NOT_INIT\n");
 		return;
 	}
-	tty = tty_port_tty_get(&info->port);
-	if (!tty) {
-		printk(KERN_WARNING "rp: WARNING: rp_handle_port called with "
-				"tty==NULL\n");
-		return;
-	}
+
 	cp = &info->channel;
 
 	IntMask = sGetChanIntID(cp) & info->intmask;
@@ -520,7 +513,7 @@ static void rp_handle_port(struct r_port *info)
 #endif
 	ChanStatus = sGetChanStatus(cp);
 	if (IntMask & RXF_TRIG) {	/* Rx FIFO trigger level */
-		rp_do_receive(info, tty, cp, ChanStatus);
+		rp_do_receive(info, cp, ChanStatus);
 	}
 	if (IntMask & DELTA_CD) {	/* CD change  */
 #if (defined(ROCKET_DEBUG_OPEN) || defined(ROCKET_DEBUG_INTR) || defined(ROCKET_DEBUG_HANGUP))
@@ -528,10 +521,15 @@ static void rp_handle_port(struct r_port *info)
 		       (ChanStatus & CD_ACT) ? "on" : "off");
 #endif
 		if (!(ChanStatus & CD_ACT) && info->cd_status) {
+			struct tty_struct *tty;
 #ifdef ROCKET_DEBUG_HANGUP
 			printk(KERN_INFO "CD drop, calling hangup.\n");
 #endif
-			tty_hangup(tty);
+			tty = tty_port_tty_get(&info->port);
+			if (tty) {
+				tty_hangup(tty);
+				tty_kref_put(tty);
+			}
 		}
 		info->cd_status = (ChanStatus & CD_ACT) ? 1 : 0;
 		wake_up_interruptible(&info->port.open_wait);
@@ -544,7 +542,6 @@ static void rp_handle_port(struct r_port *info)
 		printk(KERN_INFO "DSR change...\n");
 	}
 #endif
-	tty_kref_put(tty);
 }
 
 /*
diff --git a/drivers/tty/serial/21285.c b/drivers/tty/serial/21285.c
index a44345a..c7e8b60 100644
--- a/drivers/tty/serial/21285.c
+++ b/drivers/tty/serial/21285.c
@@ -85,7 +85,6 @@ static void serial21285_enable_ms(struct uart_port *port)
 static irqreturn_t serial21285_rx_chars(int irq, void *dev_id)
 {
 	struct uart_port *port = dev_id;
-	struct tty_struct *tty = port->state->port.tty;
 	unsigned int status, ch, flag, rxs, max_count = 256;
 
 	status = *CSR_UARTFLG;
@@ -115,7 +114,7 @@ static irqreturn_t serial21285_rx_chars(int irq, void *dev_id)
 
 		status = *CSR_UARTFLG;
 	}
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&port->state->port);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index d085e3a..64cbcb9 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -1391,7 +1391,6 @@ unsigned char
 serial8250_rx_chars(struct uart_8250_port *up, unsigned char lsr)
 {
 	struct uart_port *port = &up->port;
-	struct tty_struct *tty = port->state->port.tty;
 	unsigned char ch;
 	int max_count = 256;
 	char flag;
@@ -1456,7 +1455,7 @@ ignore_char:
 		lsr = serial_in(up, UART_LSR);
 	} while ((lsr & (UART_LSR_DR | UART_LSR_BI)) && (max_count-- > 0));
 	spin_unlock(&port->lock);
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&port->state->port);
 	spin_lock(&port->lock);
 	return lsr;
 }
diff --git a/drivers/tty/serial/altera_jtaguart.c b/drivers/tty/serial/altera_jtaguart.c
index 872f14a..84b90fd 100644
--- a/drivers/tty/serial/altera_jtaguart.c
+++ b/drivers/tty/serial/altera_jtaguart.c
@@ -139,7 +139,7 @@ static void altera_jtaguart_rx_chars(struct altera_jtaguart *pp)
 		uart_insert_char(port, 0, 0, ch, flag);
 	}
 
-	tty_flip_buffer_push(port->state->port.tty);
+	tty_flip_buffer_push(&port->state->port);
 }
 
 static void altera_jtaguart_tx_chars(struct altera_jtaguart *pp)
diff --git a/drivers/tty/serial/altera_uart.c b/drivers/tty/serial/altera_uart.c
index 684a080..e133c88 100644
--- a/drivers/tty/serial/altera_uart.c
+++ b/drivers/tty/serial/altera_uart.c
@@ -231,7 +231,7 @@ static void altera_uart_rx_chars(struct altera_uart *pp)
 				 flag);
 	}
 
-	tty_flip_buffer_push(port->state->port.tty);
+	tty_flip_buffer_push(&port->state->port);
 }
 
 static void altera_uart_tx_chars(struct altera_uart *pp)
diff --git a/drivers/tty/serial/amba-pl010.c b/drivers/tty/serial/amba-pl010.c
index 22317dd..c368405 100644
--- a/drivers/tty/serial/amba-pl010.c
+++ b/drivers/tty/serial/amba-pl010.c
@@ -116,7 +116,6 @@ static void pl010_enable_ms(struct uart_port *port)
 
 static void pl010_rx_chars(struct uart_amba_port *uap)
 {
-	struct tty_struct *tty = uap->port.state->port.tty;
 	unsigned int status, ch, flag, rsr, max_count = 256;
 
 	status = readb(uap->port.membase + UART01x_FR);
@@ -165,7 +164,7 @@ static void pl010_rx_chars(struct uart_amba_port *uap)
 		status = readb(uap->port.membase + UART01x_FR);
 	}
 	spin_unlock(&uap->port.lock);
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&uap->port.state->port);
 	spin_lock(&uap->port.lock);
 }
 
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index e1257d1..3ea5408 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -699,7 +699,6 @@ static void pl011_dma_rx_chars(struct uart_amba_port *uap,
 			       bool readfifo)
 {
 	struct tty_port *port = &uap->port.state->port;
-	struct tty_struct *tty = port->tty;
 	struct pl011_sgbuf *sgbuf = use_buf_b ?
 		&uap->dmarx.sgbuf_b : &uap->dmarx.sgbuf_a;
 	struct device *dev = uap->dmarx.chan->device->dev;
@@ -754,7 +753,7 @@ static void pl011_dma_rx_chars(struct uart_amba_port *uap,
 	dev_vdbg(uap->port.dev,
 		 "Took %d chars from DMA buffer and %d chars from the FIFO\n",
 		 dma_count, fifotaken);
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(port);
 	spin_lock(&uap->port.lock);
 }
 
@@ -1076,12 +1075,10 @@ static void pl011_enable_ms(struct uart_port *port)
 
 static void pl011_rx_chars(struct uart_amba_port *uap)
 {
-	struct tty_struct *tty = uap->port.state->port.tty;
-
 	pl011_fifo_to_tty(uap);
 
 	spin_unlock(&uap->port.lock);
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&uap->port.state->port);
 	/*
 	 * If we were temporarily out of DMA mode for a while,
 	 * attempt to switch back to DMA mode again.
diff --git a/drivers/tty/serial/apbuart.c b/drivers/tty/serial/apbuart.c
index 59ae2b5..6331464 100644
--- a/drivers/tty/serial/apbuart.c
+++ b/drivers/tty/serial/apbuart.c
@@ -78,7 +78,6 @@ static void apbuart_enable_ms(struct uart_port *port)
 
 static void apbuart_rx_chars(struct uart_port *port)
 {
-	struct tty_struct *tty = port->state->port.tty;
 	unsigned int status, ch, rsr, flag;
 	unsigned int max_chars = port->fifosize;
 
@@ -126,7 +125,7 @@ static void apbuart_rx_chars(struct uart_port *port)
 		status = UART_GET_STATUS(port);
 	}
 
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&port->state->port);
 }
 
 static void apbuart_tx_chars(struct uart_port *port)
diff --git a/drivers/tty/serial/ar933x_uart.c b/drivers/tty/serial/ar933x_uart.c
index 6ca5dd6..27f20c5 100644
--- a/drivers/tty/serial/ar933x_uart.c
+++ b/drivers/tty/serial/ar933x_uart.c
@@ -298,10 +298,8 @@ static void ar933x_uart_set_termios(struct uart_port *port,
 static void ar933x_uart_rx_chars(struct ar933x_uart_port *up)
 {
 	struct tty_port *port = &up->port.state->port;
-	struct tty_struct *tty;
 	int max_count = 256;
 
-	tty = tty_port_tty_get(port);
 	do {
 		unsigned int rdata;
 		unsigned char ch;
@@ -324,10 +322,7 @@ static void ar933x_uart_rx_chars(struct ar933x_uart_port *up)
 			tty_insert_flip_char(port, ch, TTY_NORMAL);
 	} while (max_count-- > 0);
 
-	if (tty) {
-		tty_flip_buffer_push(tty);
-		tty_kref_put(tty);
-	}
+	tty_flip_buffer_push(port);
 }
 
 static void ar933x_uart_tx_chars(struct ar933x_uart_port *up)
diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
index 3e0b3fa..41b5cb2 100644
--- a/drivers/tty/serial/arc_uart.c
+++ b/drivers/tty/serial/arc_uart.c
@@ -209,12 +209,8 @@ static void arc_serial_start_tx(struct uart_port *port)
 
 static void arc_serial_rx_chars(struct arc_uart_port *uart)
 {
-	struct tty_struct *tty = tty_port_tty_get(&uart->port.state->port);
 	unsigned int status, ch, flg = 0;
 
-	if (!tty)
-		return;
-
 	/*
 	 * UART has 4 deep RX-FIFO. Driver's recongnition of this fact
 	 * is very subtle. Here's how ...
@@ -250,10 +246,8 @@ static void arc_serial_rx_chars(struct arc_uart_port *uart)
 		uart_insert_char(&uart->port, status, RXOERR, ch, flg);
 
 done:
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&uart->port.state->port);
 	}
-
-	tty_kref_put(tty);
 }
 
 /*
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 9295670..d4a7c24 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -774,7 +774,7 @@ static void atmel_rx_from_ring(struct uart_port *port)
 	 * uart_start(), which takes the lock.
 	 */
 	spin_unlock(&port->lock);
-	tty_flip_buffer_push(port->state->port.tty);
+	tty_flip_buffer_push(&port->state->port);
 	spin_lock(&port->lock);
 }
 
@@ -782,7 +782,6 @@ static void atmel_rx_from_dma(struct uart_port *port)
 {
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	struct tty_port *tport = &port->state->port;
-	struct tty_struct *tty = tport->tty;
 	struct atmel_dma_buffer *pdc;
 	int rx_idx = atmel_port->pdc_rx_idx;
 	unsigned int head;
@@ -850,7 +849,7 @@ static void atmel_rx_from_dma(struct uart_port *port)
 	 * uart_start(), which takes the lock.
 	 */
 	spin_unlock(&port->lock);
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(tport);
 	spin_lock(&port->lock);
 
 	UART_PUT_IER(port, ATMEL_US_ENDRX | ATMEL_US_TIMEOUT);
diff --git a/drivers/tty/serial/bcm63xx_uart.c b/drivers/tty/serial/bcm63xx_uart.c
index de30b19..719594e 100644
--- a/drivers/tty/serial/bcm63xx_uart.c
+++ b/drivers/tty/serial/bcm63xx_uart.c
@@ -236,14 +236,12 @@ static const char *bcm_uart_type(struct uart_port *port)
 static void bcm_uart_do_rx(struct uart_port *port)
 {
 	struct tty_port *port = &port->state->port;
-	struct tty_struct *tty;
 	unsigned int max_count;
 
 	/* limit number of char read in interrupt, should not be
 	 * higher than fifo size anyway since we're much faster than
 	 * serial port */
 	max_count = 32;
-	tty = port->tty;
 	do {
 		unsigned int iestat, c, cstat;
 		char flag;
@@ -305,7 +303,7 @@ static void bcm_uart_do_rx(struct uart_port *port)
 
 	} while (--max_count);
 
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(port);
 }
 
 /*
diff --git a/drivers/tty/serial/bfin_sport_uart.c b/drivers/tty/serial/bfin_sport_uart.c
index e4d3ac2..487c173 100644
--- a/drivers/tty/serial/bfin_sport_uart.c
+++ b/drivers/tty/serial/bfin_sport_uart.c
@@ -150,7 +150,6 @@ static irqreturn_t sport_uart_rx_irq(int irq, void *dev_id)
 {
 	struct sport_uart_port *up = dev_id;
 	struct tty_port *port = &up->port.state->port;
-	struct tty_struct *tty = tport->tty;
 	unsigned int ch;
 
 	spin_lock(&up->port.lock);
@@ -162,7 +161,8 @@ static irqreturn_t sport_uart_rx_irq(int irq, void *dev_id)
 		if (!uart_handle_sysrq_char(&up->port, ch))
 			tty_insert_flip_char(port, ch, TTY_NORMAL);
 	}
-	tty_flip_buffer_push(tty);
+	/* XXX this won't deadlock with lowlat? */
+	tty_flip_buffer_push(port);
 
 	spin_unlock(&up->port.lock);
 
diff --git a/drivers/tty/serial/bfin_uart.c b/drivers/tty/serial/bfin_uart.c
index 2e2b2c1..12dceda 100644
--- a/drivers/tty/serial/bfin_uart.c
+++ b/drivers/tty/serial/bfin_uart.c
@@ -223,7 +223,6 @@ static void bfin_serial_enable_ms(struct uart_port *port)
 #ifdef CONFIG_SERIAL_BFIN_PIO
 static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
 {
-	struct tty_struct *tty = NULL;
 	unsigned int status, ch, flg;
 	static struct timeval anomaly_start = { .tv_sec = 0 };
 
@@ -242,11 +241,9 @@ static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
 			return;
 		}
 
-	if (!uart->port.state || !uart->port.state->port.tty)
+	if (!uart->port.state)
 		return;
 #endif
-	tty = uart->port.state->port.tty;
-
 	if (ANOMALY_05000363) {
 		/* The BF533 (and BF561) family of processors have a nice anomaly
 		 * where they continuously generate characters for a "single" break.
@@ -325,7 +322,7 @@ static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
 	uart_insert_char(&uart->port, status, OE, ch, flg);
 
  ignore_char:
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&uart->port.state->port);
 }
 
 static void bfin_serial_tx_chars(struct bfin_serial_port *uart)
@@ -426,7 +423,6 @@ static void bfin_serial_dma_tx_chars(struct bfin_serial_port *uart)
 
 static void bfin_serial_dma_rx_chars(struct bfin_serial_port *uart)
 {
-	struct tty_struct *tty = uart->port.state->port.tty;
 	int i, flg, status;
 
 	status = UART_GET_LSR(uart);
@@ -471,7 +467,7 @@ static void bfin_serial_dma_rx_chars(struct bfin_serial_port *uart)
 	}
 
  dma_ignore_char:
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&uart->port.state->port);
 }
 
 void bfin_serial_rx_dma_timeout(struct bfin_serial_port *uart)
diff --git a/drivers/tty/serial/clps711x.c b/drivers/tty/serial/clps711x.c
index 3fd2526..bfb1796 100644
--- a/drivers/tty/serial/clps711x.c
+++ b/drivers/tty/serial/clps711x.c
@@ -85,12 +85,8 @@ static void uart_clps711x_enable_ms(struct uart_port *port)
 static irqreturn_t uart_clps711x_int_rx(int irq, void *dev_id)
 {
 	struct uart_port *port = dev_id;
-	struct tty_struct *tty = tty_port_tty_get(&port->state->port);
 	unsigned int status, ch, flg;
 
-	if (!tty)
-		return IRQ_HANDLED;
-
 	for (;;) {
 		status = clps_readl(SYSFLG(port));
 		if (status & SYSFLG_URXFE)
@@ -130,9 +126,7 @@ static irqreturn_t uart_clps711x_int_rx(int irq, void *dev_id)
 		uart_insert_char(port, status, UARTDR_OVERR, ch, flg);
 	}
 
-	tty_flip_buffer_push(tty);
-
-	tty_kref_put(tty);
+	tty_flip_buffer_push(&port->state->port);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_core.c b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
index 0bb2437..97f4e18 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -246,7 +246,6 @@ static void cpm_uart_int_rx(struct uart_port *port)
 	unsigned char ch;
 	u8 *cp;
 	struct tty_port *tport = &port->state->port;
-	struct tty_struct *tty = tport->tty;
 	struct uart_cpm_port *pinfo = (struct uart_cpm_port *)port;
 	cbd_t __iomem *bdp;
 	u16 status;
@@ -323,7 +322,7 @@ static void cpm_uart_int_rx(struct uart_port *port)
 	pinfo->rx_cur = bdp;
 
 	/* activate BH processing */
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(tport);
 
 	return;
 
diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index 52449ad..45acf10 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -2104,17 +2104,10 @@ static int force_eop_if_needed(struct e100_serial *info)
 
 static void flush_to_flip_buffer(struct e100_serial *info)
 {
-	struct tty_struct *tty;
 	struct etrax_recv_buffer *buffer;
 	unsigned long flags;
 
 	local_irq_save(flags);
-	tty = info->port.tty;
-
-	if (!tty) {
-		local_irq_restore(flags);
-		return;
-	}
 
 	while ((buffer = info->first_recv_buffer) != NULL) {
 		unsigned int count = buffer->length;
@@ -2138,7 +2131,7 @@ static void flush_to_flip_buffer(struct e100_serial *info)
 	local_irq_restore(flags);
 
 	/* This includes a check for low-latency */
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&info->port);
 }
 
 static void check_flush_timeout(struct e100_serial *info)
@@ -2274,12 +2267,6 @@ static
 struct e100_serial * handle_ser_rx_interrupt_no_dma(struct e100_serial *info)
 {
 	unsigned long data_read;
-	struct tty_struct *tty = info->port.tty;
-
-	if (!tty) {
-		printk("!NO TTY!\n");
-		return info;
-	}
 
 	/* Read data and status at the same time */
 	data_read = *((unsigned long *)&info->ioport[REG_DATA_STATUS32]);
@@ -2382,7 +2369,7 @@ more_data:
 		goto more_data;
 	}
 
-	tty_flip_buffer_push(info->port.tty);
+	tty_flip_buffer_push(&info->port);
 	return info;
 }
 
diff --git a/drivers/tty/serial/dz.c b/drivers/tty/serial/dz.c
index 6491b86..2f2b2e5 100644
--- a/drivers/tty/serial/dz.c
+++ b/drivers/tty/serial/dz.c
@@ -187,7 +187,6 @@ static inline void dz_receive_chars(struct dz_mux *mux)
 {
 	struct uart_port *uport;
 	struct dz_port *dport = &mux->dport[0];
-	struct tty_struct *tty = NULL;
 	struct uart_icount *icount;
 	int lines_rx[DZ_NB_PORT] = { [0 ... DZ_NB_PORT - 1] = 0 };
 	unsigned char ch, flag;
@@ -197,7 +196,6 @@ static inline void dz_receive_chars(struct dz_mux *mux)
 	while ((status = dz_in(dport, DZ_RBUF)) & DZ_DVAL) {
 		dport = &mux->dport[LINE(status)];
 		uport = &dport->port;
-		tty = uport->state->port.tty;	/* point to the proper dev */
 
 		ch = UCHAR(status);		/* grab the char */
 		flag = TTY_NORMAL;
@@ -249,7 +247,7 @@ static inline void dz_receive_chars(struct dz_mux *mux)
 	}
 	for (i = 0; i < DZ_NB_PORT; i++)
 		if (lines_rx[i])
-			tty_flip_buffer_push(mux->dport[i].port.state->port.tty);
+			tty_flip_buffer_push(&mux->dport[i].port.state->port);
 }
 
 /*
diff --git a/drivers/tty/serial/efm32-uart.c b/drivers/tty/serial/efm32-uart.c
index bdf67b0..de14bd7 100644
--- a/drivers/tty/serial/efm32-uart.c
+++ b/drivers/tty/serial/efm32-uart.c
@@ -249,12 +249,9 @@ static irqreturn_t efm32_uart_rxirq(int irq, void *data)
 	int handled = IRQ_NONE;
 	struct uart_port *port = &efm_port->port;
 	struct tty_port *tport = &port->state->port;
-	struct tty_struct *tty;
 
 	spin_lock(&port->lock);
 
-	tty = tty_kref_get(tport->tty);
-
 	if (irqflag & UARTn_IF_RXDATAV) {
 		efm32_uart_write32(efm_port, UARTn_IF_RXDATAV, UARTn_IFC);
 		efm32_uart_rx_chars(efm_port);
@@ -270,10 +267,7 @@ static irqreturn_t efm32_uart_rxirq(int irq, void *data)
 		handled = IRQ_HANDLED;
 	}
 
-	if (tty) {
-		tty_flip_buffer_push(tty);
-		tty_kref_put(tty);
-	}
+	tty_flip_buffer_push(tport);
 
 	spin_unlock(&port->lock);
 
diff --git a/drivers/tty/serial/icom.c b/drivers/tty/serial/icom.c
index 54903ee..bc9e6b01 100644
--- a/drivers/tty/serial/icom.c
+++ b/drivers/tty/serial/icom.c
@@ -735,7 +735,6 @@ static void recv_interrupt(u16 port_int_reg, struct icom_port *icom_port)
 {
 	short int count, rcv_buff;
 	struct tty_port *port = &icom_port->uart_port.state->port;
-	struct tty_struct *tty = port->tty;
 	unsigned short int status;
 	struct uart_icount *icount;
 	unsigned long offset;
@@ -835,7 +834,7 @@ ignore_char:
 		status = cpu_to_le16(icom_port->statStg->rcv[rcv_buff].flags);
 	}
 	icom_port->next_rcv = rcv_buff;
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(port);
 }
 
 static void process_interrupt(u16 port_int_reg,
diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index 4bc6e47..6a6668b 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -669,12 +669,8 @@ static const struct tty_operations ifx_spi_serial_ops = {
 static void ifx_spi_insert_flip_string(struct ifx_spi_device *ifx_dev,
 				    unsigned char *chars, size_t size)
 {
-	struct tty_struct *tty = tty_port_tty_get(&ifx_dev->tty_port);
-	if (!tty)
-		return;
 	tty_insert_flip_string(&ifx_dev->tty_port, chars, size);
-	tty_flip_buffer_push(tty);
-	tty_kref_put(tty);
+	tty_flip_buffer_push(&ifx_dev->tty_port);
 }
 
 /**
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 3a7f0ef..17b79ae 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -518,7 +518,6 @@ static irqreturn_t imx_rxint(int irq, void *dev_id)
 	struct imx_port *sport = dev_id;
 	unsigned int rx,flg,ignored = 0;
 	struct tty_port *port = &sport->port.state->port;
-	struct tty_struct *tty = port->tty;
 	unsigned long flags, temp;
 
 	spin_lock_irqsave(&sport->port.lock,flags);
@@ -576,7 +575,7 @@ static irqreturn_t imx_rxint(int irq, void *dev_id)
 
 out:
 	spin_unlock_irqrestore(&sport->port.lock,flags);
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(port);
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/tty/serial/ioc3_serial.c b/drivers/tty/serial/ioc3_serial.c
index edbdc4e..6e4c715 100644
--- a/drivers/tty/serial/ioc3_serial.c
+++ b/drivers/tty/serial/ioc3_serial.c
@@ -1393,7 +1393,6 @@ static inline int do_read(struct uart_port *the_port, char *buf, int len)
  */
 static int receive_chars(struct uart_port *the_port)
 {
-	struct tty_struct *tty;
 	unsigned char ch[MAX_CHARS];
 	int read_count = 0, read_room, flip = 0;
 	struct uart_state *state = the_port->state;
@@ -1403,14 +1402,11 @@ static int receive_chars(struct uart_port *the_port)
 	/* Make sure all the pointers are "good" ones */
 	if (!state)
 		return 0;
-	if (!state->port.tty)
-		return 0;
 
 	if (!(port->ip_flags & INPUT_ENABLE))
 		return 0;
 
 	spin_lock_irqsave(&the_port->lock, pflags);
-	tty = state->port.tty;
 
 	read_count = do_read(the_port, ch, MAX_CHARS);
 	if (read_count > 0) {
@@ -1422,7 +1418,7 @@ static int receive_chars(struct uart_port *the_port)
 	spin_unlock_irqrestore(&the_port->lock, pflags);
 
 	if (flip)
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&state->port);
 
 	return read_count;
 }
diff --git a/drivers/tty/serial/ioc4_serial.c b/drivers/tty/serial/ioc4_serial.c
index bd53669..db3b203 100644
--- a/drivers/tty/serial/ioc4_serial.c
+++ b/drivers/tty/serial/ioc4_serial.c
@@ -2340,7 +2340,6 @@ static inline int do_read(struct uart_port *the_port, unsigned char *buf,
  */
 static void receive_chars(struct uart_port *the_port)
 {
-	struct tty_struct *tty;
 	unsigned char ch[IOC4_MAX_CHARS];
 	int read_count, request_count = IOC4_MAX_CHARS;
 	struct uart_icount *icount;
@@ -2350,11 +2349,8 @@ static void receive_chars(struct uart_port *the_port)
 	/* Make sure all the pointers are "good" ones */
 	if (!state)
 		return;
-	if (!state->port.tty)
-		return;
 
 	spin_lock_irqsave(&the_port->lock, pflags);
-	tty = state->port.tty;
 
 	request_count = tty_buffer_request_room(&state->port, IOC4_MAX_CHARS);
 
@@ -2369,7 +2365,7 @@ static void receive_chars(struct uart_port *the_port)
 
 	spin_unlock_irqrestore(&the_port->lock, pflags);
 
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&state->port);
 }
 
 /**
diff --git a/drivers/tty/serial/jsm/jsm_tty.c b/drivers/tty/serial/jsm/jsm_tty.c
index c9ce00d..00f250a 100644
--- a/drivers/tty/serial/jsm/jsm_tty.c
+++ b/drivers/tty/serial/jsm/jsm_tty.c
@@ -654,7 +654,7 @@ void jsm_input(struct jsm_channel *ch)
 	spin_unlock_irqrestore(&ch->ch_lock, lock_flags);
 
 	/* Tell the tty layer its okay to "eat" the data now */
-	tty_flip_buffer_push(tp);
+	tty_flip_buffer_push(port);
 
 	jsm_dbg(IOCTL, &ch->ch_bd->pci_dev, "finish\n");
 }
diff --git a/drivers/tty/serial/kgdb_nmi.c b/drivers/tty/serial/kgdb_nmi.c
index ba2ef62..26a50b0 100644
--- a/drivers/tty/serial/kgdb_nmi.c
+++ b/drivers/tty/serial/kgdb_nmi.c
@@ -202,7 +202,6 @@ bool kgdb_nmi_poll_knock(void)
 static void kgdb_nmi_tty_receiver(unsigned long data)
 {
 	struct kgdb_nmi_tty_priv *priv = (void *)data;
-	struct tty_struct *tty;
 	char ch;
 
 	tasklet_schedule(&priv->tlet);
@@ -210,16 +209,9 @@ static void kgdb_nmi_tty_receiver(unsigned long data)
 	if (likely(!kgdb_nmi_tty_enabled || !kfifo_len(&priv->fifo)))
 		return;
 
-	/* Port is there, but tty might be hung up, check. */
-	tty = tty_port_tty_get(kgdb_nmi_port);
-	if (!tty)
-		return;
-
 	while (kfifo_out(&priv->fifo, &ch, 1))
 		tty_insert_flip_char(&priv->port, ch, TTY_NORMAL);
-	tty_flip_buffer_push(priv->port.tty);
-
-	tty_kref_put(tty);
+	tty_flip_buffer_push(&priv->port);
 }
 
 static int kgdb_nmi_tty_activate(struct tty_port *port, struct tty_struct *tty)
diff --git a/drivers/tty/serial/lantiq.c b/drivers/tty/serial/lantiq.c
index 1933fe3..15733da 100644
--- a/drivers/tty/serial/lantiq.c
+++ b/drivers/tty/serial/lantiq.c
@@ -163,21 +163,15 @@ static int
 lqasc_rx_chars(struct uart_port *port)
 {
 	struct tty_port *tport = &port->state->port;
-	struct tty_struct *tty = tty_port_tty_get(tport);
 	unsigned int ch = 0, rsr = 0, fifocnt;
 
-	if (!tty) {
-		dev_dbg(port->dev, "%s:tty is busy now", __func__);
-		return -EBUSY;
-	}
-	fifocnt =
-		ltq_r32(port->membase + LTQ_ASC_FSTAT) & ASCFSTAT_RXFFLMASK;
+	fifocnt = ltq_r32(port->membase + LTQ_ASC_FSTAT) & ASCFSTAT_RXFFLMASK;
 	while (fifocnt--) {
 		u8 flag = TTY_NORMAL;
 		ch = ltq_r8(port->membase + LTQ_ASC_RBUF);
 		rsr = (ltq_r32(port->membase + LTQ_ASC_STATE)
 			& ASCSTATE_ANY) | UART_DUMMY_UER_RX;
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(tport);
 		port->icount.rx++;
 
 		/*
@@ -219,9 +213,10 @@ lqasc_rx_chars(struct uart_port *port)
 			 */
 			tty_insert_flip_char(tport, 0, TTY_OVERRUN);
 	}
+
 	if (ch != 0)
-		tty_flip_buffer_push(tty);
-	tty_kref_put(tty);
+		tty_flip_buffer_push(tport);
+
 	return 0;
 }
 
diff --git a/drivers/tty/serial/lpc32xx_hs.c b/drivers/tty/serial/lpc32xx_hs.c
index 5cd1805..c8448e6 100644
--- a/drivers/tty/serial/lpc32xx_hs.c
+++ b/drivers/tty/serial/lpc32xx_hs.c
@@ -259,16 +259,6 @@ static void __serial_lpc32xx_rx(struct uart_port *port)
 {
 	struct tty_port *tport = &port->state->port;
 	unsigned int tmp, flag;
-	struct tty_struct *tty = tty_port_tty_get(tport);
-
-	if (!tty) {
-		/* Discard data: no tty available */
-		while (!(readl(LPC32XX_HSUART_FIFO(port->membase)) &
-			 LPC32XX_HSU_RX_EMPTY))
-			;
-
-		return;
-	}
 
 	/* Read data from FIFO and push into terminal */
 	tmp = readl(LPC32XX_HSUART_FIFO(port->membase));
@@ -289,8 +279,7 @@ static void __serial_lpc32xx_rx(struct uart_port *port)
 
 		tmp = readl(LPC32XX_HSUART_FIFO(port->membase));
 	}
-	tty_flip_buffer_push(tty);
-	tty_kref_put(tty);
+	tty_flip_buffer_push(tport);
 }
 
 static void __serial_lpc32xx_tx(struct uart_port *port)
@@ -367,8 +356,7 @@ static irqreturn_t serial_lpc32xx_interrupt(int irq, void *dev_id)
 	/* Data received? */
 	if (status & (LPC32XX_HSU_RX_TIMEOUT_INT | LPC32XX_HSU_RX_TRIG_INT)) {
 		__serial_lpc32xx_rx(port);
-		if (tty)
-			tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(tport);
 	}
 
 	/* Transmit data request? */
diff --git a/drivers/tty/serial/m32r_sio.c b/drivers/tty/serial/m32r_sio.c
index 2e9a390..bb1afa0 100644
--- a/drivers/tty/serial/m32r_sio.c
+++ b/drivers/tty/serial/m32r_sio.c
@@ -301,7 +301,6 @@ static void m32r_sio_enable_ms(struct uart_port *port)
 static void receive_chars(struct uart_sio_port *up, int *status)
 {
 	struct tty_port *port = &up->port.state->port;
-	struct tty_struct *tty = tport->tty;
 	unsigned char ch;
 	unsigned char flag;
 	int max_count = 256;
@@ -369,7 +368,7 @@ static void receive_chars(struct uart_sio_port *up, int *status)
 	ignore_char:
 		*status = serial_in(up, UART_LSR);
 	} while ((*status & UART_LSR_DR) && (max_count-- > 0));
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(port);
 }
 
 static void transmit_chars(struct uart_sio_port *up)
diff --git a/drivers/tty/serial/max3100.c b/drivers/tty/serial/max3100.c
index cdc74bc..32517d4 100644
--- a/drivers/tty/serial/max3100.c
+++ b/drivers/tty/serial/max3100.c
@@ -310,8 +310,8 @@ static void max3100_work(struct work_struct *w)
 			}
 		}
 
-		if (rxchars > 16 && s->port.state->port.tty != NULL) {
-			tty_flip_buffer_push(s->port.state->port.tty);
+		if (rxchars > 16) {
+			tty_flip_buffer_push(&s->port.state->port);
 			rxchars = 0;
 		}
 		if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
@@ -323,8 +323,8 @@ static void max3100_work(struct work_struct *w)
 		  (!uart_circ_empty(xmit) &&
 		   !uart_tx_stopped(&s->port))));
 
-	if (rxchars > 0 && s->port.state->port.tty != NULL)
-		tty_flip_buffer_push(s->port.state->port.tty);
+	if (rxchars > 0)
+		tty_flip_buffer_push(&s->port.state->port);
 }
 
 static irqreturn_t max3100_irq(int irqno, void *dev_id)
diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index a801f68..0c2422c 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -460,10 +460,6 @@ static int max310x_set_ref_clk(struct max310x_port *s)
 static void max310x_handle_rx(struct max310x_port *s, unsigned int rxlen)
 {
 	unsigned int sts = 0, ch = 0, flag;
-	struct tty_struct *tty = tty_port_tty_get(&s->port.state->port);
-
-	if (!tty)
-		return;
 
 	if (unlikely(rxlen >= MAX310X_FIFO_SIZE)) {
 		dev_warn(s->port.dev, "Possible RX FIFO overrun %d\n", rxlen);
@@ -516,9 +512,7 @@ static void max310x_handle_rx(struct max310x_port *s, unsigned int rxlen)
 				 ch, flag);
 	}
 
-	tty_flip_buffer_push(tty);
-
-	tty_kref_put(tty);
+	tty_flip_buffer_push(&s->port.state->port);
 }
 
 static void max310x_handle_tx(struct max310x_port *s)
diff --git a/drivers/tty/serial/mcf.c b/drivers/tty/serial/mcf.c
index fcd56ab..7ed9927 100644
--- a/drivers/tty/serial/mcf.c
+++ b/drivers/tty/serial/mcf.c
@@ -310,7 +310,7 @@ static void mcf_rx_chars(struct mcf_uart *pp)
 		uart_insert_char(port, status, MCFUART_USR_RXOVERRUN, ch, flag);
 	}
 
-	tty_flip_buffer_push(port->state->port.tty);
+	tty_flip_buffer_push(&port->state->port);
 }
 
 /****************************************************************************/
diff --git a/drivers/tty/serial/mfd.c b/drivers/tty/serial/mfd.c
index 60d585a..5f4765a 100644
--- a/drivers/tty/serial/mfd.c
+++ b/drivers/tty/serial/mfd.c
@@ -388,12 +388,8 @@ void hsu_dma_rx(struct uart_hsu_port *up, u32 int_sts)
 	struct hsu_dma_chan *chan = up->rxc;
 	struct uart_port *port = &up->port;
 	struct tty_port *tport = &port->state->port;
-	struct tty_struct *tty = tport->tty;
 	int count;
 
-	if (!tty)
-		return;
-
 	/*
 	 * First need to know how many is already transferred,
 	 * then check if its a timeout DMA irq, and return
@@ -438,7 +434,7 @@ void hsu_dma_rx(struct uart_hsu_port *up, u32 int_sts)
 					 | (0x1 << 16)
 					 | (0x1 << 24)	/* timeout bit, see HSU Errata 1 */
 					 );
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(tport);
 
 	chan_writel(chan, HSU_CH_CR, 0x3);
 
@@ -461,13 +457,9 @@ static void serial_hsu_stop_rx(struct uart_port *port)
 
 static inline void receive_chars(struct uart_hsu_port *up, int *status)
 {
-	struct tty_struct *tty = up->port.state->port.tty;
 	unsigned int ch, flag;
 	unsigned int max_count = 256;
 
-	if (!tty)
-		return;
-
 	do {
 		ch = serial_in(up, UART_RX);
 		flag = TTY_NORMAL;
@@ -523,7 +515,7 @@ static inline void receive_chars(struct uart_hsu_port *up, int *status)
 	ignore_char:
 		*status = serial_in(up, UART_LSR);
 	} while ((*status & UART_LSR_DR) && max_count--);
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&up->port.state->port);
 }
 
 static void transmit_chars(struct uart_hsu_port *up)
diff --git a/drivers/tty/serial/mpc52xx_uart.c b/drivers/tty/serial/mpc52xx_uart.c
index 0145aeb..c0e1fad 100644
--- a/drivers/tty/serial/mpc52xx_uart.c
+++ b/drivers/tty/serial/mpc52xx_uart.c
@@ -942,7 +942,6 @@ static inline int
 mpc52xx_uart_int_rx_chars(struct uart_port *port)
 {
 	struct tty_port *tport = &port->state->port;
-	struct tty_struct *tty = tport->tty;
 	unsigned char ch, flag;
 	unsigned short status;
 
@@ -1000,7 +999,7 @@ mpc52xx_uart_int_rx_chars(struct uart_port *port)
 	}
 
 	spin_unlock(&port->lock);
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(tport);
 	spin_lock(&port->lock);
 
 	return psc_ops->raw_rx_rdy(port);
diff --git a/drivers/tty/serial/mpsc.c b/drivers/tty/serial/mpsc.c
index 6f2d2ce..bc24f49 100644
--- a/drivers/tty/serial/mpsc.c
+++ b/drivers/tty/serial/mpsc.c
@@ -938,7 +938,6 @@ static int mpsc_rx_intr(struct mpsc_port_info *pi)
 {
 	struct mpsc_rx_desc *rxre;
 	struct tty_port *port = &pi->port.state->port;
-	struct tty_struct *tty = port->tty;
 	u32	cmdstat, bytes_in, i;
 	int	rc = 0;
 	u8	*bp;
@@ -971,7 +970,7 @@ static int mpsc_rx_intr(struct mpsc_port_info *pi)
 		/* Following use of tty struct directly is deprecated */
 		if (tty_buffer_request_room(port, bytes_in) < bytes_in) {
 			if (port->low_latency)
-				tty_flip_buffer_push(tty);
+				tty_flip_buffer_push(port);
 			/*
 			 * If this failed then we will throw away the bytes
 			 * but must do so to clear interrupts.
@@ -1081,7 +1080,7 @@ next_frame:
 	if ((readl(pi->sdma_base + SDMA_SDCM) & SDMA_SDCM_ERD) == 0)
 		mpsc_start_rx(pi);
 
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(port);
 	return rc;
 }
 
diff --git a/drivers/tty/serial/mrst_max3110.c b/drivers/tty/serial/mrst_max3110.c
index 4632db7..f641c23 100644
--- a/drivers/tty/serial/mrst_max3110.c
+++ b/drivers/tty/serial/mrst_max3110.c
@@ -340,7 +340,6 @@ receive_chars(struct uart_max3110 *max, unsigned short *str, int len)
 {
 	struct uart_port *port = &max->port;
 	struct tty_port *tport;
-	struct tty_struct *tty;
 	char buf[M3110_RX_FIFO_DEPTH];
 	int r, w, usable;
 
@@ -349,9 +348,6 @@ receive_chars(struct uart_max3110 *max, unsigned short *str, int len)
 		return 0;
 
 	tport = &port->state->port;
-	tty = tty_port_tty_get(tport);
-	if (!tty)
-		return 0;
 
 	for (r = 0, w = 0; r < len; r++) {
 		if (str[r] & MAX3110_BREAK &&
@@ -366,10 +362,8 @@ receive_chars(struct uart_max3110 *max, unsigned short *str, int len)
 		}
 	}
 
-	if (!w) {
-		tty_kref_put(tty);
+	if (!w)
 		return 0;
-	}
 
 	for (r = 0; w; r += usable, w -= usable) {
 		usable = tty_buffer_request_room(tport, w);
@@ -378,8 +372,7 @@ receive_chars(struct uart_max3110 *max, unsigned short *str, int len)
 			port->icount.rx += usable;
 		}
 	}
-	tty_flip_buffer_push(tty);
-	tty_kref_put(tty);
+	tty_flip_buffer_push(tport);
 
 	return r;
 }
diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index cb787c0..b11e997 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -92,7 +92,6 @@ static void msm_enable_ms(struct uart_port *port)
 static void handle_rx_dm(struct uart_port *port, unsigned int misr)
 {
 	struct tty_port *tport = &port->state->port;
-	struct tty_struct *tty = tport->tty;
 	unsigned int sr;
 	int count = 0;
 	struct msm_port *msm_port = UART_TO_MSM(port);
@@ -138,7 +137,7 @@ static void handle_rx_dm(struct uart_port *port, unsigned int misr)
 		count -= 4;
 	}
 
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(tport);
 	if (misr & (UART_IMR_RXSTALE))
 		msm_write(port, UART_CR_CMD_RESET_STALE_INT, UART_CR);
 	msm_write(port, 0xFFFFFF, UARTDM_DMRX);
@@ -148,7 +147,6 @@ static void handle_rx_dm(struct uart_port *port, unsigned int misr)
 static void handle_rx(struct uart_port *port)
 {
 	struct tty_port *tport = &port->state->port;
-	struct tty_struct *tty = tport->tty;
 	unsigned int sr;
 
 	/*
@@ -191,7 +189,7 @@ static void handle_rx(struct uart_port *port)
 			tty_insert_flip_char(tport, c, flag);
 	}
 
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(tport);
 }
 
 static void reset_dm_count(struct uart_port *port)
diff --git a/drivers/tty/serial/msm_serial_hs.c b/drivers/tty/serial/msm_serial_hs.c
index c356fff..4a942c7 100644
--- a/drivers/tty/serial/msm_serial_hs.c
+++ b/drivers/tty/serial/msm_serial_hs.c
@@ -981,9 +981,8 @@ static void msm_hs_tty_flip_buffer_work(struct work_struct *work)
 {
 	struct msm_hs_port *msm_uport =
 			container_of(work, struct msm_hs_port, rx.tty_work);
-	struct tty_struct *tty = msm_uport->uport.state->port.tty;
 
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&msm_uport->uport.state->port);
 }
 
 /*
diff --git a/drivers/tty/serial/msm_smd_tty.c b/drivers/tty/serial/msm_smd_tty.c
index b43b4ec..e722ff1 100644
--- a/drivers/tty/serial/msm_smd_tty.c
+++ b/drivers/tty/serial/msm_smd_tty.c
@@ -80,7 +80,7 @@ static void smd_tty_notify(void *priv, unsigned event)
 			pr_err("OOPS - smd_tty_buffer mismatch?!");
 		}
 
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&info->port);
 	}
 
 	/* XXX only when writable and necessary */
diff --git a/drivers/tty/serial/mux.c b/drivers/tty/serial/mux.c
index 83b2168..7fd6aaa 100644
--- a/drivers/tty/serial/mux.c
+++ b/drivers/tty/serial/mux.c
@@ -244,7 +244,6 @@ static void mux_read(struct uart_port *port)
 {
 	struct tty_port *tport = &port->state->port;
 	int data;
-	struct tty_struct *tty = tport->tty;
 	__u32 start_count = port->icount.rx;
 
 	while(1) {
@@ -270,9 +269,8 @@ static void mux_read(struct uart_port *port)
 		tty_insert_flip_char(tport, data & 0xFF, TTY_NORMAL);
 	}
 	
-	if (start_count != port->icount.rx) {
-		tty_flip_buffer_push(tty);
-	}
+	if (start_count != port->icount.rx)
+		tty_flip_buffer_push(tport);
 }
 
 /**
diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index f8426bf..beb46f4 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -364,7 +364,6 @@ out:
 
 static void mxs_auart_rx_chars(struct mxs_auart_port *s)
 {
-	struct tty_struct *tty = s->port.state->port.tty;
 	u32 stat = 0;
 
 	for (;;) {
@@ -375,7 +374,7 @@ static void mxs_auart_rx_chars(struct mxs_auart_port *s)
 	}
 
 	writel(stat, s->port.membase + AUART_STAT);
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&s->port.state->port);
 }
 
 static int mxs_auart_request_port(struct uart_port *u)
@@ -458,7 +457,6 @@ static void dma_rx_callback(void *arg)
 {
 	struct mxs_auart_port *s = (struct mxs_auart_port *) arg;
 	struct tty_port *port = &s->port.state->port;
-	struct tty_struct *tty = port->tty;
 	int count;
 	u32 stat;
 
@@ -472,7 +470,7 @@ static void dma_rx_callback(void *arg)
 	tty_insert_flip_string(port, s->rx_dma_buf, count);
 
 	writel(stat, s->port.membase + AUART_STAT);
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(port);
 
 	/* start the next DMA for RX. */
 	mxs_auart_dma_prep_rx(s);
diff --git a/drivers/tty/serial/netx-serial.c b/drivers/tty/serial/netx-serial.c
index d40da78..b9a40ed 100644
--- a/drivers/tty/serial/netx-serial.c
+++ b/drivers/tty/serial/netx-serial.c
@@ -199,7 +199,6 @@ static void netx_txint(struct uart_port *port)
 static void netx_rxint(struct uart_port *port)
 {
 	unsigned char rx, flg, status;
-	struct tty_struct *tty = port->state->port.tty;
 
 	while (!(readl(port->membase + UART_FR) & FR_RXFE)) {
 		rx = readl(port->membase + UART_DR);
@@ -237,8 +236,7 @@ static void netx_rxint(struct uart_port *port)
 		uart_insert_char(port, status, SR_OE, rx, flg);
 	}
 
-	tty_flip_buffer_push(tty);
-	return;
+	tty_flip_buffer_push(&port->state->port);
 }
 
 static irqreturn_t netx_int(int irq, void *dev_id)
diff --git a/drivers/tty/serial/nwpserial.c b/drivers/tty/serial/nwpserial.c
index 10d64a3..77287c5 100644
--- a/drivers/tty/serial/nwpserial.c
+++ b/drivers/tty/serial/nwpserial.c
@@ -129,7 +129,6 @@ static irqreturn_t nwpserial_interrupt(int irq, void *dev_id)
 {
 	struct nwpserial_port *up = dev_id;
 	struct tty_port *port = &up->port.state->port;
-	struct tty_struct *tty = port->tty;
 	irqreturn_t ret;
 	unsigned int iir;
 	unsigned char ch;
@@ -150,7 +149,7 @@ static irqreturn_t nwpserial_interrupt(int irq, void *dev_id)
 			tty_insert_flip_char(port, ch, TTY_NORMAL);
 	} while (dcr_read(up->dcr_host, UART_LSR) & UART_LSR_DR);
 
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(port);
 	ret = IRQ_HANDLED;
 
 	/* clear interrupt */
diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 57d6b29..3e9749b 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -483,7 +483,6 @@ static void serial_omap_rdi(struct uart_omap_port *up, unsigned int lsr)
 static irqreturn_t serial_omap_irq(int irq, void *dev_id)
 {
 	struct uart_omap_port *up = dev_id;
-	struct tty_struct *tty = up->port.state->port.tty;
 	unsigned int iir, lsr;
 	unsigned int type;
 	irqreturn_t ret = IRQ_NONE;
@@ -530,7 +529,7 @@ static irqreturn_t serial_omap_irq(int irq, void *dev_id)
 
 	spin_unlock(&up->port.lock);
 
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&up->port.state->port);
 
 	pm_runtime_mark_last_busy(up->dev);
 	pm_runtime_put_autosuspend(up->dev);
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 967f1cb..8b40a1f 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -593,17 +593,9 @@ static int push_rx(struct eg20t_port *priv, const unsigned char *buf,
 {
 	struct uart_port *port = &priv->port;
 	struct tty_port *tport = &port->state->port;
-	struct tty_struct *tty;
-
-	tty = tty_port_tty_get(tport);
-	if (!tty) {
-		dev_dbg(priv->port.dev, "%s:tty is busy now", __func__);
-		return -EBUSY;
-	}
 
 	tty_insert_flip_string(tport, buf, size);
-	tty_flip_buffer_push(tty);
-	tty_kref_put(tty);
+	tty_flip_buffer_push(tport);
 
 	return 0;
 }
@@ -744,19 +736,12 @@ static void pch_dma_rx_complete(void *arg)
 {
 	struct eg20t_port *priv = arg;
 	struct uart_port *port = &priv->port;
-	struct tty_struct *tty = tty_port_tty_get(&port->state->port);
 	int count;
 
-	if (!tty) {
-		dev_dbg(priv->port.dev, "%s:tty is busy now", __func__);
-		return;
-	}
-
 	dma_sync_sg_for_cpu(port->dev, &priv->sg_rx, 1, DMA_FROM_DEVICE);
 	count = dma_push_rx(priv, priv->trigger_level);
 	if (count)
-		tty_flip_buffer_push(tty);
-	tty_kref_put(tty);
+		tty_flip_buffer_push(&port->state->port);
 	async_tx_ack(priv->desc_rx);
 	pch_uart_hal_enable_interrupt(priv, PCH_UART_HAL_RX_INT |
 					    PCH_UART_HAL_RX_ERR_INT);
diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index 73a3f29..b1785f5 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -227,21 +227,19 @@ static void pmz_interrupt_control(struct uart_pmac_port *uap, int enable)
 	write_zsreg(uap, R1, uap->curregs[1]);
 }
 
-static struct tty_struct *pmz_receive_chars(struct uart_pmac_port *uap)
+static bool pmz_receive_chars(struct uart_pmac_port *uap)
 {
 	struct tty_port *port;
-	struct tty_struct *tty = NULL;
 	unsigned char ch, r1, drop, error, flag;
 	int loops = 0;
 
 	/* Sanity check, make sure the old bug is no longer happening */
-	if (uap->port.state == NULL || uap->port.state->port.tty == NULL) {
+	if (uap->port.state == NULL) {
 		WARN_ON(1);
 		(void)read_zsdata(uap);
-		return NULL;
+		return false;
 	}
 	port = &uap->port.state->port;
-	tty = port->tty; /* TOCTOU above */
 
 	while (1) {
 		error = 0;
@@ -330,11 +328,11 @@ static struct tty_struct *pmz_receive_chars(struct uart_pmac_port *uap)
 			break;
 	}
 
-	return tty;
+	return true;
  flood:
 	pmz_interrupt_control(uap, 0);
 	pmz_error("pmz: rx irq flood !\n");
-	return tty;
+	return true;
 }
 
 static void pmz_status_handle(struct uart_pmac_port *uap)
@@ -455,7 +453,7 @@ static irqreturn_t pmz_interrupt(int irq, void *dev_id)
 	struct uart_pmac_port *uap_a;
 	struct uart_pmac_port *uap_b;
 	int rc = IRQ_NONE;
-	struct tty_struct *tty;
+	bool push;
 	u8 r3;
 
 	uap_a = pmz_get_port_A(uap);
@@ -468,7 +466,7 @@ static irqreturn_t pmz_interrupt(int irq, void *dev_id)
 	pmz_debug("irq, r3: %x\n", r3);
 #endif
 	/* Channel A */
-	tty = NULL;
+	push = false;
 	if (r3 & (CHAEXT | CHATxIP | CHARxIP)) {
 		if (!ZS_IS_OPEN(uap_a)) {
 			pmz_debug("ChanA interrupt while not open !\n");
@@ -479,21 +477,21 @@ static irqreturn_t pmz_interrupt(int irq, void *dev_id)
 		if (r3 & CHAEXT)
 			pmz_status_handle(uap_a);
 		if (r3 & CHARxIP)
-			tty = pmz_receive_chars(uap_a);
+			push = pmz_receive_chars(uap_a);
 		if (r3 & CHATxIP)
 			pmz_transmit_chars(uap_a);
 		rc = IRQ_HANDLED;
 	}
  skip_a:
 	spin_unlock(&uap_a->port.lock);
-	if (tty != NULL)
-		tty_flip_buffer_push(tty);
+	if (push)
+		tty_flip_buffer_push(&uap->port.state->port);
 
 	if (!uap_b)
 		goto out;
 
 	spin_lock(&uap_b->port.lock);
-	tty = NULL;
+	push = false;
 	if (r3 & (CHBEXT | CHBTxIP | CHBRxIP)) {
 		if (!ZS_IS_OPEN(uap_b)) {
 			pmz_debug("ChanB interrupt while not open !\n");
@@ -504,15 +502,15 @@ static irqreturn_t pmz_interrupt(int irq, void *dev_id)
 		if (r3 & CHBEXT)
 			pmz_status_handle(uap_b);
 		if (r3 & CHBRxIP)
-			tty = pmz_receive_chars(uap_b);
+			push = pmz_receive_chars(uap_b);
 		if (r3 & CHBTxIP)
 			pmz_transmit_chars(uap_b);
 		rc = IRQ_HANDLED;
 	}
  skip_b:
 	spin_unlock(&uap_b->port.lock);
-	if (tty != NULL)
-		tty_flip_buffer_push(tty);
+	if (push)
+		tty_flip_buffer_push(&uap->port.state->port);
 
  out:
 	return rc;
diff --git a/drivers/tty/serial/pnx8xxx_uart.c b/drivers/tty/serial/pnx8xxx_uart.c
index 0aa75a9..7e277a5 100644
--- a/drivers/tty/serial/pnx8xxx_uart.c
+++ b/drivers/tty/serial/pnx8xxx_uart.c
@@ -181,7 +181,6 @@ static void pnx8xxx_enable_ms(struct uart_port *port)
 
 static void pnx8xxx_rx_chars(struct pnx8xxx_port *sport)
 {
-	struct tty_struct *tty = sport->port.state->port.tty;
 	unsigned int status, ch, flg;
 
 	status = FIFO_TO_SM(serial_in(sport, PNX8XXX_FIFO)) |
@@ -238,7 +237,7 @@ static void pnx8xxx_rx_chars(struct pnx8xxx_port *sport)
 		status = FIFO_TO_SM(serial_in(sport, PNX8XXX_FIFO)) |
 			 ISTAT_TO_SM(serial_in(sport, PNX8XXX_ISTAT));
 	}
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&sport->port.state->port);
 }
 
 static void pnx8xxx_tx_chars(struct pnx8xxx_port *sport)
diff --git a/drivers/tty/serial/pxa.c b/drivers/tty/serial/pxa.c
index 2764828..3b671bc 100644
--- a/drivers/tty/serial/pxa.c
+++ b/drivers/tty/serial/pxa.c
@@ -98,7 +98,6 @@ static void serial_pxa_stop_rx(struct uart_port *port)
 
 static inline void receive_chars(struct uart_pxa_port *up, int *status)
 {
-	struct tty_struct *tty = up->port.state->port.tty;
 	unsigned int ch, flag;
 	int max_count = 256;
 
@@ -168,7 +167,7 @@ static inline void receive_chars(struct uart_pxa_port *up, int *status)
 	ignore_char:
 		*status = serial_in(up, UART_LSR);
 	} while ((*status & UART_LSR_DR) && (max_count-- > 0));
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&up->port.state->port);
 
 	/* work around Errata #20 according to
 	 * Intel(R) PXA27x Processor Family
diff --git a/drivers/tty/serial/sa1100.c b/drivers/tty/serial/sa1100.c
index 5d4b9b4..af6b3e3 100644
--- a/drivers/tty/serial/sa1100.c
+++ b/drivers/tty/serial/sa1100.c
@@ -188,7 +188,6 @@ static void sa1100_enable_ms(struct uart_port *port)
 static void
 sa1100_rx_chars(struct sa1100_port *sport)
 {
-	struct tty_struct *tty = sport->port.state->port.tty;
 	unsigned int status, ch, flg;
 
 	status = UTSR1_TO_SM(UART_GET_UTSR1(sport)) |
@@ -233,7 +232,7 @@ sa1100_rx_chars(struct sa1100_port *sport)
 		status = UTSR1_TO_SM(UART_GET_UTSR1(sport)) |
 			 UTSR0_TO_SM(UART_GET_UTSR0(sport));
 	}
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&sport->port.state->port);
 }
 
 static void sa1100_tx_chars(struct sa1100_port *sport)
diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 12e5249..4e52090 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -221,7 +221,6 @@ s3c24xx_serial_rx_chars(int irq, void *dev_id)
 {
 	struct s3c24xx_uart_port *ourport = dev_id;
 	struct uart_port *port = &ourport->port;
-	struct tty_struct *tty = port->state->port.tty;
 	unsigned int ufcon, ch, flag, ufstat, uerstat;
 	unsigned long flags;
 	int max_count = 64;
@@ -299,7 +298,7 @@ s3c24xx_serial_rx_chars(int irq, void *dev_id)
  ignore_char:
 		continue;
 	}
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&port->state->port);
 
  out:
 	spin_unlock_irqrestore(&port->lock, flags);
diff --git a/drivers/tty/serial/sb1250-duart.c b/drivers/tty/serial/sb1250-duart.c
index f76b1688..a7cdec2 100644
--- a/drivers/tty/serial/sb1250-duart.c
+++ b/drivers/tty/serial/sb1250-duart.c
@@ -384,7 +384,7 @@ static void sbd_receive_chars(struct sbd_port *sport)
 		uart_insert_char(uport, status, M_DUART_OVRUN_ERR, ch, flag);
 	}
 
-	tty_flip_buffer_push(uport->state->port.tty);
+	tty_flip_buffer_push(&uport->state->port);
 }
 
 static void sbd_transmit_chars(struct sbd_port *sport)
diff --git a/drivers/tty/serial/sc26xx.c b/drivers/tty/serial/sc26xx.c
index 0cd0e4a..c973568 100644
--- a/drivers/tty/serial/sc26xx.c
+++ b/drivers/tty/serial/sc26xx.c
@@ -136,20 +136,17 @@ static void sc26xx_disable_irq(struct uart_port *port, int mask)
 	WRITE_SC(port, IMR, up->imr);
 }
 
-static struct tty_struct *receive_chars(struct uart_port *port)
+static bool receive_chars(struct uart_port *port)
 {
 	struct tty_port *tport = NULL;
-	struct tty_struct *tty = NULL;
 	int limit = 10000;
 	unsigned char ch;
 	char flag;
 	u8 status;
 
 	/* FIXME what is this trying to achieve? */
-	if (port->state != NULL) {		/* Unopened serial console */
+	if (port->state != NULL)		/* Unopened serial console */
 		tport = &port->state->port;
-		tty = tport->tty;
-	}
 
 	while (limit-- > 0) {
 		status = READ_SC_PORT(port, SR);
@@ -191,7 +188,7 @@ static struct tty_struct *receive_chars(struct uart_port *port)
 
 		tty_insert_flip_char(tport, ch, flag);
 	}
-	return tty;
+	return !!tport;
 }
 
 static void transmit_chars(struct uart_port *port)
@@ -221,36 +218,36 @@ static void transmit_chars(struct uart_port *port)
 static irqreturn_t sc26xx_interrupt(int irq, void *dev_id)
 {
 	struct uart_sc26xx_port *up = dev_id;
-	struct tty_struct *tty;
 	unsigned long flags;
+	bool push;
 	u8 isr;
 
 	spin_lock_irqsave(&up->port[0].lock, flags);
 
-	tty = NULL;
+	push = false;
 	isr = READ_SC(&up->port[0], ISR);
 	if (isr & ISR_TXRDYA)
 	    transmit_chars(&up->port[0]);
 	if (isr & ISR_RXRDYA)
-	    tty = receive_chars(&up->port[0]);
+	    push = receive_chars(&up->port[0]);
 
 	spin_unlock(&up->port[0].lock);
 
-	if (tty)
-		tty_flip_buffer_push(tty);
+	if (push)
+		tty_flip_buffer_push(&up->port[0].state->port);
 
 	spin_lock(&up->port[1].lock);
 
-	tty = NULL;
+	push = false;
 	if (isr & ISR_TXRDYB)
 	    transmit_chars(&up->port[1]);
 	if (isr & ISR_RXRDYB)
-	    tty = receive_chars(&up->port[1]);
+	    push = receive_chars(&up->port[1]);
 
 	spin_unlock_irqrestore(&up->port[1].lock, flags);
 
-	if (tty)
-		tty_flip_buffer_push(tty);
+	if (push)
+		tty_flip_buffer_push(&up->port[1].state->port);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/tty/serial/sccnxp.c b/drivers/tty/serial/sccnxp.c
index 418b495..2ced871 100644
--- a/drivers/tty/serial/sccnxp.c
+++ b/drivers/tty/serial/sccnxp.c
@@ -285,10 +285,6 @@ static void sccnxp_handle_rx(struct uart_port *port)
 {
 	u8 sr;
 	unsigned int ch, flag;
-	struct tty_struct *tty = tty_port_tty_get(&port->state->port);
-
-	if (!tty)
-		return;
 
 	for (;;) {
 		sr = sccnxp_port_read(port, SCCNXP_SR_REG);
@@ -333,9 +329,7 @@ static void sccnxp_handle_rx(struct uart_port *port)
 		uart_insert_char(port, sr, SR_OVR, ch, flag);
 	}
 
-	tty_flip_buffer_push(tty);
-
-	tty_kref_put(tty);
+	tty_flip_buffer_push(&port->state->port);
 }
 
 static void sccnxp_handle_tx(struct uart_port *port)
diff --git a/drivers/tty/serial/serial_ks8695.c b/drivers/tty/serial/serial_ks8695.c
index 9bd004f..e1caa99 100644
--- a/drivers/tty/serial/serial_ks8695.c
+++ b/drivers/tty/serial/serial_ks8695.c
@@ -153,7 +153,6 @@ static void ks8695uart_disable_ms(struct uart_port *port)
 static irqreturn_t ks8695uart_rx_chars(int irq, void *dev_id)
 {
 	struct uart_port *port = dev_id;
-	struct tty_struct *tty = port->state->port.tty;
 	unsigned int status, ch, lsr, flg, max_count = 256;
 
 	status = UART_GET_LSR(port);		/* clears pending LSR interrupts */
@@ -200,7 +199,7 @@ static irqreturn_t ks8695uart_rx_chars(int irq, void *dev_id)
 ignore_char:
 		status = UART_GET_LSR(port);
 	}
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&port->state->port);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/tty/serial/serial_txx9.c b/drivers/tty/serial/serial_txx9.c
index b52b21a..fe48a0c 100644
--- a/drivers/tty/serial/serial_txx9.c
+++ b/drivers/tty/serial/serial_txx9.c
@@ -277,7 +277,6 @@ static void serial_txx9_initialize(struct uart_port *port)
 static inline void
 receive_chars(struct uart_txx9_port *up, unsigned int *status)
 {
-	struct tty_struct *tty = up->port.state->port.tty;
 	unsigned char ch;
 	unsigned int disr = *status;
 	int max_count = 256;
@@ -346,7 +345,7 @@ receive_chars(struct uart_txx9_port *up, unsigned int *status)
 		disr = sio_in(up, TXX9_SIDISR);
 	} while (!(disr & TXX9_SIDISR_UVALID) && (max_count-- > 0));
 	spin_unlock(&up->port.lock);
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&up->port.state->port);
 	spin_lock(&up->port.lock);
 	*status = disr;
 }
diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index ecef748..1564186 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -597,7 +597,6 @@ static void sci_receive_chars(struct uart_port *port)
 {
 	struct sci_port *sci_port = to_sci_port(port);
 	struct tty_port *tport = &port->state->port;
-	struct tty_struct *tty = tport->tty;
 	int i, count, copied = 0;
 	unsigned short status;
 	unsigned char flag;
@@ -675,7 +674,7 @@ static void sci_receive_chars(struct uart_port *port)
 
 	if (copied) {
 		/* Tell the rest of the system the news. New characters! */
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(tport);
 	} else {
 		serial_port_in(port, SCxSR); /* dummy read */
 		serial_port_out(port, SCxSR, SCxSR_RDxF_CLEAR(port));
@@ -722,7 +721,6 @@ static int sci_handle_errors(struct uart_port *port)
 	int copied = 0;
 	unsigned short status = serial_port_in(port, SCxSR);
 	struct tty_port *tport = &port->state->port;
-	struct tty_struct *tty = tport->tty;
 	struct sci_port *s = to_sci_port(port);
 
 	/*
@@ -783,7 +781,7 @@ static int sci_handle_errors(struct uart_port *port)
 	}
 
 	if (copied)
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(tport);
 
 	return copied;
 }
@@ -791,7 +789,6 @@ static int sci_handle_errors(struct uart_port *port)
 static int sci_handle_fifo_overrun(struct uart_port *port)
 {
 	struct tty_port *tport = &port->state->port;
-	struct tty_struct *tty = tport->tty;
 	struct sci_port *s = to_sci_port(port);
 	struct plat_sci_reg *reg;
 	int copied = 0;
@@ -806,7 +803,7 @@ static int sci_handle_fifo_overrun(struct uart_port *port)
 		port->icount.overrun++;
 
 		tty_insert_flip_char(tport, 0, TTY_OVERRUN);
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(tport);
 
 		dev_notice(port->dev, "overrun error\n");
 		copied++;
@@ -820,7 +817,6 @@ static int sci_handle_breaks(struct uart_port *port)
 	int copied = 0;
 	unsigned short status = serial_port_in(port, SCxSR);
 	struct tty_port *tport = &port->state->port;
-	struct tty_struct *tty = tport->tty;
 	struct sci_port *s = to_sci_port(port);
 
 	if (uart_handle_break(port))
@@ -842,7 +838,7 @@ static int sci_handle_breaks(struct uart_port *port)
 	}
 
 	if (copied)
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(tport);
 
 	copied += sci_handle_fifo_overrun(port);
 
@@ -1299,7 +1295,6 @@ static void sci_dma_rx_complete(void *arg)
 {
 	struct sci_port *s = arg;
 	struct uart_port *port = &s->port;
-	struct tty_struct *tty = port->state->port.tty;
 	unsigned long flags;
 	int count;
 
@@ -1314,7 +1309,7 @@ static void sci_dma_rx_complete(void *arg)
 	spin_unlock_irqrestore(&port->lock, flags);
 
 	if (count)
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&port->state->port);
 
 	schedule_work(&s->work_rx);
 }
@@ -1408,7 +1403,6 @@ static void work_fn_rx(struct work_struct *work)
 	if (dma_async_is_tx_complete(s->chan_rx, s->active_rx, NULL, NULL) !=
 	    DMA_SUCCESS) {
 		/* Handle incomplete DMA receive */
-		struct tty_struct *tty = port->state->port.tty;
 		struct dma_chan *chan = s->chan_rx;
 		struct shdma_desc *sh_desc = container_of(desc,
 					struct shdma_desc, async_tx);
@@ -1424,7 +1418,7 @@ static void work_fn_rx(struct work_struct *work)
 		spin_unlock_irqrestore(&port->lock, flags);
 
 		if (count)
-			tty_flip_buffer_push(tty);
+			tty_flip_buffer_push(&port->state->port);
 
 		sci_submit_rx(s);
 
diff --git a/drivers/tty/serial/sirfsoc_uart.c b/drivers/tty/serial/sirfsoc_uart.c
index 5da5cb9..37fa931 100644
--- a/drivers/tty/serial/sirfsoc_uart.c
+++ b/drivers/tty/serial/sirfsoc_uart.c
@@ -192,11 +192,6 @@ static unsigned int
 sirfsoc_uart_pio_rx_chars(struct uart_port *port, unsigned int max_rx_count)
 {
 	unsigned int ch, rx_count = 0;
-	struct tty_struct *tty;
-
-	tty = tty_port_tty_get(&port->state->port);
-	if (!tty)
-		return -ENODEV;
 
 	while (!(rd_regl(port, SIRFUART_RX_FIFO_STATUS) &
 					SIRFUART_FIFOEMPTY_MASK(port))) {
@@ -210,8 +205,7 @@ sirfsoc_uart_pio_rx_chars(struct uart_port *port, unsigned int max_rx_count)
 	}
 
 	port->icount.rx += rx_count;
-	tty_flip_buffer_push(tty);
-	tty_kref_put(tty);
+	tty_flip_buffer_push(&port->state->port);
 
 	return rx_count;
 }
diff --git a/drivers/tty/serial/sn_console.c b/drivers/tty/serial/sn_console.c
index 283232c..f51ffdc 100644
--- a/drivers/tty/serial/sn_console.c
+++ b/drivers/tty/serial/sn_console.c
@@ -459,7 +459,6 @@ sn_receive_chars(struct sn_cons_port *port, unsigned long flags)
 {
 	struct tty_port *tport = NULL;
 	int ch;
-	struct tty_struct *tty;
 
 	if (!port) {
 		printk(KERN_ERR "sn_receive_chars - port NULL so can't receive\n");
@@ -474,11 +473,6 @@ sn_receive_chars(struct sn_cons_port *port, unsigned long flags)
 	if (port->sc_port.state) {
 		/* The serial_core stuffs are initialized, use them */
 		tport = &port->sc_port.state->port;
-		tty = tport->tty;
-	}
-	else {
-		/* Not registered yet - can't pass to tty layer.  */
-		tty = NULL;
 	}
 
 	while (port->sc_ops->sal_input_pending()) {
@@ -518,15 +512,15 @@ sn_receive_chars(struct sn_cons_port *port, unsigned long flags)
 #endif /* CONFIG_MAGIC_SYSRQ */
 
 		/* record the character to pass up to the tty layer */
-		if (tty) {
+		if (tport) {
 			if (tty_insert_flip_char(tport, ch, TTY_NORMAL) == 0)
 				break;
 		}
 		port->sc_port.icount.rx++;
 	}
 
-	if (tty)
-		tty_flip_buffer_push(tty);
+	if (tport)
+		tty_flip_buffer_push(tport);
 }
 
 /**
diff --git a/drivers/tty/serial/sunhv.c b/drivers/tty/serial/sunhv.c
index defe92b..ba60708 100644
--- a/drivers/tty/serial/sunhv.c
+++ b/drivers/tty/serial/sunhv.c
@@ -181,17 +181,17 @@ static struct sunhv_ops bywrite_ops = {
 
 static struct sunhv_ops *sunhv_ops = &bychar_ops;
 
-static struct tty_struct *receive_chars(struct uart_port *port)
+static struct tty_port *receive_chars(struct uart_port *port)
 {
-	struct tty_struct *tty = NULL;
+	struct tty_port *tport = NULL;
 
 	if (port->state != NULL)		/* Unopened serial console */
-		tty = port->state->port.tty;
+		tport = &port->state->port;
 
 	if (sunhv_ops->receive_chars(port))
 		sun_do_break();
 
-	return tty;
+	return tport;
 }
 
 static void transmit_chars(struct uart_port *port)
@@ -214,16 +214,16 @@ static void transmit_chars(struct uart_port *port)
 static irqreturn_t sunhv_interrupt(int irq, void *dev_id)
 {
 	struct uart_port *port = dev_id;
-	struct tty_struct *tty;
+	struct tty_port *tport;
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
-	tty = receive_chars(port);
+	tport = receive_chars(port);
 	transmit_chars(port);
 	spin_unlock_irqrestore(&port->lock, flags);
 
-	if (tty)
-		tty_flip_buffer_push(tty);
+	if (tport)
+		tty_flip_buffer_push(tport);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/tty/serial/sunsab.c b/drivers/tty/serial/sunsab.c
index 4abc4d4..8de2213 100644
--- a/drivers/tty/serial/sunsab.c
+++ b/drivers/tty/serial/sunsab.c
@@ -107,22 +107,19 @@ static __inline__ void sunsab_cec_wait(struct uart_sunsab_port *up)
 		udelay(1);
 }
 
-static struct tty_struct *
+static struct tty_port *
 receive_chars(struct uart_sunsab_port *up,
 	      union sab82532_irq_status *stat)
 {
 	struct tty_port *port = NULL;
-	struct tty_struct *tty = NULL;
 	unsigned char buf[32];
 	int saw_console_brk = 0;
 	int free_fifo = 0;
 	int count = 0;
 	int i;
 
-	if (up->port.state != NULL) {		/* Unopened serial console */
+	if (up->port.state != NULL)		/* Unopened serial console */
 		port = &up->port.state->port;
-		tty = port->tty;
-	}
 
 	/* Read number of BYTES (Character + Status) available. */
 	if (stat->sreg.isr0 & SAB82532_ISR0_RPF) {
@@ -139,7 +136,7 @@ receive_chars(struct uart_sunsab_port *up,
 	if (stat->sreg.isr0 & SAB82532_ISR0_TIME) {
 		sunsab_cec_wait(up);
 		writeb(SAB82532_CMDR_RFRD, &up->regs->w.cmdr);
-		return tty;
+		return port;
 	}
 
 	if (stat->sreg.isr0 & SAB82532_ISR0_RFO)
@@ -219,7 +216,7 @@ receive_chars(struct uart_sunsab_port *up,
 	if (saw_console_brk)
 		sun_do_break();
 
-	return tty;
+	return port;
 }
 
 static void sunsab_stop_tx(struct uart_port *);
@@ -302,7 +299,7 @@ static void check_status(struct uart_sunsab_port *up,
 static irqreturn_t sunsab_interrupt(int irq, void *dev_id)
 {
 	struct uart_sunsab_port *up = dev_id;
-	struct tty_struct *tty;
+	struct tty_port *port = NULL;
 	union sab82532_irq_status status;
 	unsigned long flags;
 	unsigned char gis;
@@ -316,12 +313,11 @@ static irqreturn_t sunsab_interrupt(int irq, void *dev_id)
 	if (gis & 2)
 		status.sreg.isr1 = readb(&up->regs->r.isr1);
 
-	tty = NULL;
 	if (status.stat) {
 		if ((status.sreg.isr0 & (SAB82532_ISR0_TCD | SAB82532_ISR0_TIME |
 					 SAB82532_ISR0_RFO | SAB82532_ISR0_RPF)) ||
 		    (status.sreg.isr1 & SAB82532_ISR1_BRK))
-			tty = receive_chars(up, &status);
+			port = receive_chars(up, &status);
 		if ((status.sreg.isr0 & SAB82532_ISR0_CDSC) ||
 		    (status.sreg.isr1 & SAB82532_ISR1_CSC))
 			check_status(up, &status);
@@ -331,8 +327,8 @@ static irqreturn_t sunsab_interrupt(int irq, void *dev_id)
 
 	spin_unlock_irqrestore(&up->port.lock, flags);
 
-	if (tty)
-		tty_flip_buffer_push(tty);
+	if (port)
+		tty_flip_buffer_push(port);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/tty/serial/sunsu.c b/drivers/tty/serial/sunsu.c
index 5232596..e343d66 100644
--- a/drivers/tty/serial/sunsu.c
+++ b/drivers/tty/serial/sunsu.c
@@ -315,11 +315,10 @@ static void sunsu_enable_ms(struct uart_port *port)
 	spin_unlock_irqrestore(&up->port.lock, flags);
 }
 
-static struct tty_struct *
+static void
 receive_chars(struct uart_sunsu_port *up, unsigned char *status)
 {
 	struct tty_port *port = &up->port.state->port;
-	struct tty_struct *tty = port->tty;
 	unsigned char ch, flag;
 	int max_count = 256;
 	int saw_console_brk = 0;
@@ -391,8 +390,6 @@ receive_chars(struct uart_sunsu_port *up, unsigned char *status)
 
 	if (saw_console_brk)
 		sun_do_break();
-
-	return tty;
 }
 
 static void transmit_chars(struct uart_sunsu_port *up)
@@ -461,20 +458,16 @@ static irqreturn_t sunsu_serial_interrupt(int irq, void *dev_id)
 	spin_lock_irqsave(&up->port.lock, flags);
 
 	do {
-		struct tty_struct *tty;
-
 		status = serial_inp(up, UART_LSR);
-		tty = NULL;
 		if (status & UART_LSR_DR)
-			tty = receive_chars(up, &status);
+			receive_chars(up, &status);
 		check_modem_status(up);
 		if (status & UART_LSR_THRE)
 			transmit_chars(up);
 
 		spin_unlock_irqrestore(&up->port.lock, flags);
 
-		if (tty)
-			tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&up->port.state->port);
 
 		spin_lock_irqsave(&up->port.lock, flags);
 
diff --git a/drivers/tty/serial/sunzilog.c b/drivers/tty/serial/sunzilog.c
index 4a11be3..27669ff 100644
--- a/drivers/tty/serial/sunzilog.c
+++ b/drivers/tty/serial/sunzilog.c
@@ -323,19 +323,15 @@ static void sunzilog_kbdms_receive_chars(struct uart_sunzilog_port *up,
 	}
 }
 
-static struct tty_struct *
+static struct tty_port *
 sunzilog_receive_chars(struct uart_sunzilog_port *up,
 		       struct zilog_channel __iomem *channel)
 {
 	struct tty_port *port = NULL;
-	struct tty_struct *tty;
 	unsigned char ch, r1, flag;
 
-	tty = NULL;
-	if (up->port.state != NULL) {		/* Unopened serial console */
+	if (up->port.state != NULL)		/* Unopened serial console */
 		port = &up->port.state->port;
-		tty = port->tty;		/* mouse => tty is NULL */
-	}
 
 	for (;;) {
 
@@ -403,7 +399,7 @@ sunzilog_receive_chars(struct uart_sunzilog_port *up,
 			tty_insert_flip_char(port, 0, TTY_OVERRUN);
 	}
 
-	return tty;
+	return port;
 }
 
 static void sunzilog_status_handle(struct uart_sunzilog_port *up,
@@ -536,21 +532,21 @@ static irqreturn_t sunzilog_interrupt(int irq, void *dev_id)
 	while (up) {
 		struct zilog_channel __iomem *channel
 			= ZILOG_CHANNEL_FROM_PORT(&up->port);
-		struct tty_struct *tty;
+		struct tty_port *port;
 		unsigned char r3;
 
 		spin_lock(&up->port.lock);
 		r3 = read_zsreg(channel, R3);
 
 		/* Channel A */
-		tty = NULL;
+		port = NULL;
 		if (r3 & (CHAEXT | CHATxIP | CHARxIP)) {
 			writeb(RES_H_IUS, &channel->control);
 			ZSDELAY();
 			ZS_WSYNC(channel);
 
 			if (r3 & CHARxIP)
-				tty = sunzilog_receive_chars(up, channel);
+				port = sunzilog_receive_chars(up, channel);
 			if (r3 & CHAEXT)
 				sunzilog_status_handle(up, channel);
 			if (r3 & CHATxIP)
@@ -558,22 +554,22 @@ static irqreturn_t sunzilog_interrupt(int irq, void *dev_id)
 		}
 		spin_unlock(&up->port.lock);
 
-		if (tty)
-			tty_flip_buffer_push(tty);
+		if (port)
+			tty_flip_buffer_push(port);
 
 		/* Channel B */
 		up = up->next;
 		channel = ZILOG_CHANNEL_FROM_PORT(&up->port);
 
 		spin_lock(&up->port.lock);
-		tty = NULL;
+		port = NULL;
 		if (r3 & (CHBEXT | CHBTxIP | CHBRxIP)) {
 			writeb(RES_H_IUS, &channel->control);
 			ZSDELAY();
 			ZS_WSYNC(channel);
 
 			if (r3 & CHBRxIP)
-				tty = sunzilog_receive_chars(up, channel);
+				port = sunzilog_receive_chars(up, channel);
 			if (r3 & CHBEXT)
 				sunzilog_status_handle(up, channel);
 			if (r3 & CHBTxIP)
@@ -581,8 +577,8 @@ static irqreturn_t sunzilog_interrupt(int irq, void *dev_id)
 		}
 		spin_unlock(&up->port.lock);
 
-		if (tty)
-			tty_flip_buffer_push(tty);
+		if (port)
+			tty_flip_buffer_push(port);
 
 		up = up->next;
 	}
diff --git a/drivers/tty/serial/timbuart.c b/drivers/tty/serial/timbuart.c
index f40c634..6818410 100644
--- a/drivers/tty/serial/timbuart.c
+++ b/drivers/tty/serial/timbuart.c
@@ -100,7 +100,7 @@ static void timbuart_rx_chars(struct uart_port *port)
 	}
 
 	spin_unlock(&port->lock);
-	tty_flip_buffer_push(port->state->port.tty);
+	tty_flip_buffer_push(tport);
 	spin_lock(&port->lock);
 
 	dev_dbg(port->dev, "%s - total read %d bytes\n",
diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uartlite.c
index 5caf1f0..5486505 100644
--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -156,7 +156,7 @@ static irqreturn_t ulite_isr(int irq, void *dev_id)
 
 	/* work done? */
 	if (n > 1) {
-		tty_flip_buffer_push(port->state->port.tty);
+		tty_flip_buffer_push(&port->state->port);
 		return IRQ_HANDLED;
 	} else {
 		return IRQ_NONE;
diff --git a/drivers/tty/serial/ucc_uart.c b/drivers/tty/serial/ucc_uart.c
index 7a23786..7355303 100644
--- a/drivers/tty/serial/ucc_uart.c
+++ b/drivers/tty/serial/ucc_uart.c
@@ -470,7 +470,6 @@ static void qe_uart_int_rx(struct uart_qe_port *qe_port)
 	unsigned char ch, *cp;
 	struct uart_port *port = &qe_port->port;
 	struct tty_port *tport = &port->state->port;
-	struct tty_struct *tty = tport->tty;
 	struct qe_bd *bdp;
 	u16 status;
 	unsigned int flg;
@@ -531,7 +530,7 @@ error_return:
 	qe_port->rx_cur = bdp;
 
 	/* Activate BH processing */
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(tport);
 
 	return;
 
diff --git a/drivers/tty/serial/vr41xx_siu.c b/drivers/tty/serial/vr41xx_siu.c
index 62ee016..f655997 100644
--- a/drivers/tty/serial/vr41xx_siu.c
+++ b/drivers/tty/serial/vr41xx_siu.c
@@ -313,12 +313,10 @@ static void siu_break_ctl(struct uart_port *port, int ctl)
 
 static inline void receive_chars(struct uart_port *port, uint8_t *status)
 {
-	struct tty_struct *tty;
 	uint8_t lsr, ch;
 	char flag;
 	int max_count = RX_MAX_COUNT;
 
-	tty = port->state->port.tty;
 	lsr = *status;
 
 	do {
@@ -365,7 +363,7 @@ static inline void receive_chars(struct uart_port *port, uint8_t *status)
 		lsr = siu_read(port, UART_LSR);
 	} while ((lsr & UART_LSR_DR) && (max_count-- > 0));
 
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&port->state->port);
 
 	*status = lsr;
 }
diff --git a/drivers/tty/serial/vt8500_serial.c b/drivers/tty/serial/vt8500_serial.c
index 7f41124..f1a398c 100644
--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -137,15 +137,6 @@ static void vt8500_enable_ms(struct uart_port *port)
 static void handle_rx(struct uart_port *port)
 {
 	struct tty_port *tport = &port->state->port;
-	struct tty_struct *tty = tty_port_tty_get(tport);
-	if (!tty) {
-		/* Discard data: no tty available */
-		int count = (vt8500_read(port, VT8500_URFIDX) & 0x1f00) >> 8;
-		u16 ch;
-		while (count--)
-			ch = readw(port->membase + VT8500_RXFIFO);
-		return;
-	}
 
 	/*
 	 * Handle overrun
@@ -178,8 +169,7 @@ static void handle_rx(struct uart_port *port)
 			tty_insert_flip_char(tport, c, flag);
 	}
 
-	tty_flip_buffer_push(tty);
-	tty_kref_put(tty);
+	tty_flip_buffer_push(tport);
 }
 
 static void handle_tx(struct uart_port *port)
diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 1eb4657..e426603 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -148,15 +148,11 @@
 static irqreturn_t xuartps_isr(int irq, void *dev_id)
 {
 	struct uart_port *port = (struct uart_port *)dev_id;
-	struct tty_struct *tty;
 	unsigned long flags;
 	unsigned int isrstatus, numbytes;
 	unsigned int data;
 	char status = TTY_NORMAL;
 
-	/* Get the tty which could be NULL so don't assume it's valid */
-	tty = tty_port_tty_get(&port->state->port);
-
 	spin_lock_irqsave(&port->lock, flags);
 
 	/* Read the interrupt status register to determine which
@@ -188,14 +184,11 @@ static irqreturn_t xuartps_isr(int irq, void *dev_id)
 			} else if (isrstatus & XUARTPS_IXR_OVERRUN)
 				port->icount.overrun++;
 
-			if (tty)
-				uart_insert_char(port, isrstatus,
-						XUARTPS_IXR_OVERRUN, data,
-						status);
+			uart_insert_char(port, isrstatus, XUARTPS_IXR_OVERRUN,
+					data, status);
 		}
 		spin_unlock(&port->lock);
-		if (tty)
-			tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&port->state->port);
 		spin_lock(&port->lock);
 	}
 
@@ -238,7 +231,6 @@ static irqreturn_t xuartps_isr(int irq, void *dev_id)
 
 	/* be sure to release the lock and tty before leaving */
 	spin_unlock_irqrestore(&port->lock, flags);
-	tty_kref_put(tty);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/tty/serial/zs.c b/drivers/tty/serial/zs.c
index 92c00b2..6a16987 100644
--- a/drivers/tty/serial/zs.c
+++ b/drivers/tty/serial/zs.c
@@ -603,7 +603,7 @@ static void zs_receive_chars(struct zs_port *zport)
 		uart_insert_char(uport, status, Rx_OVR, ch, flag);
 	}
 
-	tty_flip_buffer_push(uport->state->port.tty);
+	tty_flip_buffer_push(&uport->state->port);
 }
 
 static void zs_raw_transmit_chars(struct zs_port *zport)
diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index a1891ef..aeb5bf2 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -1440,7 +1440,6 @@ static void mgsl_isr_receive_data( struct mgsl_struct *info )
 	u16 status;
 	int work = 0;
 	unsigned char DataByte;
- 	struct tty_struct *tty = info->port.tty;
  	struct	mgsl_icount *icount = &info->icount;
 	
 	if ( debug_level >= DEBUG_LEVEL_ISR )	
@@ -1502,7 +1501,7 @@ static void mgsl_isr_receive_data( struct mgsl_struct *info )
 			if (status & RXSTATUS_BREAK_RECEIVED) {
 				flag = TTY_BREAK;
 				if (info->port.flags & ASYNC_SAK)
-					do_SAK(tty);
+					do_SAK(info->port.tty);
 			} else if (status & RXSTATUS_PARITY_ERROR)
 				flag = TTY_PARITY;
 			else if (status & RXSTATUS_FRAMING_ERROR)
@@ -1525,7 +1524,7 @@ static void mgsl_isr_receive_data( struct mgsl_struct *info )
 	}
 			
 	if(work)
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&info->port);
 }
 
 /* mgsl_isr_misc()
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index a7790b5..1654b7e 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -1855,7 +1855,6 @@ static void hdlcdev_exit(struct slgt_info *info)
  */
 static void rx_async(struct slgt_info *info)
 {
- 	struct tty_struct *tty = info->port.tty;
  	struct mgsl_icount *icount = &info->icount;
 	unsigned int start, end;
 	unsigned char *p;
@@ -1916,8 +1915,8 @@ static void rx_async(struct slgt_info *info)
 			break;
 	}
 
-	if (tty && chars)
-		tty_flip_buffer_push(tty);
+	if (chars)
+		tty_flip_buffer_push(&info->port);
 }
 
 /*
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index 27a29b5..22d94a1 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -2168,7 +2168,6 @@ static void isr_rxrdy(SLMP_INFO * info)
 {
 	u16 status;
 	unsigned char DataByte;
- 	struct tty_struct *tty = info->port.tty;
  	struct	mgsl_icount *icount = &info->icount;
 
 	if ( debug_level >= DEBUG_LEVEL_ISR )
@@ -2226,8 +2225,7 @@ static void isr_rxrdy(SLMP_INFO * info)
 			icount->frame,icount->overrun);
 	}
 
-	if ( tty )
-		tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&info->port);
 }
 
 static void isr_txeom(SLMP_INFO * info, unsigned char status)
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 1bfe97a..b6efaca 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -544,7 +544,7 @@ void tty_flush_to_ldisc(struct tty_struct *tty)
 
 /**
  *	tty_flip_buffer_push	-	terminal
- *	@tty: tty to push
+ *	@port: tty port to push
  *
  *	Queue a push of the terminal flip buffers to the line discipline. This
  *	function must not be called from IRQ context if port->low_latency is
@@ -556,9 +556,9 @@ void tty_flush_to_ldisc(struct tty_struct *tty)
  *	Locking: tty buffer lock. Driver locks in low latency mode.
  */
 
-void tty_flip_buffer_push(struct tty_struct *tty)
+void tty_flip_buffer_push(struct tty_port *port)
 {
-	struct tty_bufhead *buf = &tty->port->buf;
+	struct tty_bufhead *buf = &port->buf;
 	unsigned long flags;
 
 	spin_lock_irqsave(&buf->lock, flags);
@@ -566,7 +566,7 @@ void tty_flip_buffer_push(struct tty_struct *tty)
 		buf->tail->commit = buf->tail->used;
 	spin_unlock_irqrestore(&buf->lock, flags);
 
-	if (tty->port->low_latency)
+	if (port->low_latency)
 		flush_to_ldisc(&buf->work);
 	else
 		schedule_work(&buf->work);
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 20dc2ad..15b36e2 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -410,20 +410,12 @@ static int acm_submit_read_urbs(struct acm *acm, gfp_t mem_flags)
 
 static void acm_process_read_urb(struct acm *acm, struct urb *urb)
 {
-	struct tty_struct *tty;
-
 	if (!urb->actual_length)
 		return;
 
-	tty = tty_port_tty_get(&acm->port);
-	if (!tty)
-		return;
-
 	tty_insert_flip_string(&acm->port, urb->transfer_buffer,
 			urb->actual_length);
-	tty_flip_buffer_push(tty);
-
-	tty_kref_put(tty);
+	tty_flip_buffer_push(&acm->port);
 }
 
 static void acm_read_bulk_callback(struct urb *urb)
diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
index 3560799..ca4fc3d 100644
--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -551,8 +551,8 @@ static void gs_rx_push(unsigned long _port)
 	/* Push from tty to ldisc; without low_latency set this is handled by
 	 * a workqueue, so we won't get callbacks and can hold port_lock
 	 */
-	if (tty && do_push)
-		tty_flip_buffer_push(tty);
+	if (do_push)
+		tty_flip_buffer_push(&port->port);
 
 
 	/* We want our data queue to become empty ASAP, keeping data
diff --git a/drivers/usb/serial/aircable.c b/drivers/usb/serial/aircable.c
index 3bb1f8f..6e320ce 100644
--- a/drivers/usb/serial/aircable.c
+++ b/drivers/usb/serial/aircable.c
@@ -140,16 +140,11 @@ static void aircable_process_read_urb(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	char *data = (char *)urb->transfer_buffer;
-	struct tty_struct *tty;
 	int has_headers;
 	int count;
 	int len;
 	int i;
 
-	tty = tty_port_tty_get(&port->port);
-	if (!tty)
-		return;
-
 	has_headers = (urb->actual_length > 2 && data[0] == RX_HEADER_0);
 
 	count = 0;
@@ -160,8 +155,7 @@ static void aircable_process_read_urb(struct urb *urb)
 	}
 
 	if (count)
-		tty_flip_buffer_push(tty);
-	tty_kref_put(tty);
+		tty_flip_buffer_push(&port->port);
 }
 
 static struct usb_serial_driver aircable_device = {
diff --git a/drivers/usb/serial/ark3116.c b/drivers/usb/serial/ark3116.c
index 1614feb..cbd904b 100644
--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -674,7 +674,6 @@ static void ark3116_process_read_urb(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	struct ark3116_private *priv = usb_get_serial_port_data(port);
-	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
 	char tty_flag = TTY_NORMAL;
 	unsigned long flags;
@@ -689,10 +688,6 @@ static void ark3116_process_read_urb(struct urb *urb)
 	if (!urb->actual_length)
 		return;
 
-	tty = tty_port_tty_get(&port->port);
-	if (!tty)
-		return;
-
 	if (lsr & UART_LSR_BRK_ERROR_BITS) {
 		if (lsr & UART_LSR_BI)
 			tty_flag = TTY_BREAK;
@@ -707,8 +702,7 @@ static void ark3116_process_read_urb(struct urb *urb)
 	}
 	tty_insert_flip_string_fixed_flag(&port->port, data, tty_flag,
 							urb->actual_length);
-	tty_flip_buffer_push(tty);
-	tty_kref_put(tty);
+	tty_flip_buffer_push(&port->port);
 }
 
 static struct usb_serial_driver ark3116_device = {
diff --git a/drivers/usb/serial/belkin_sa.c b/drivers/usb/serial/belkin_sa.c
index 7ba2c0b..84217e7 100644
--- a/drivers/usb/serial/belkin_sa.c
+++ b/drivers/usb/serial/belkin_sa.c
@@ -242,7 +242,6 @@ static void belkin_sa_process_read_urb(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	struct belkin_sa_private *priv = usb_get_serial_port_data(port);
-	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
 	unsigned long flags;
 	unsigned char status;
@@ -259,10 +258,6 @@ static void belkin_sa_process_read_urb(struct urb *urb)
 	if (!urb->actual_length)
 		return;
 
-	tty = tty_port_tty_get(&port->port);
-	if (!tty)
-		return;
-
 	if (status & BELKIN_SA_LSR_ERR) {
 		/* Break takes precedence over parity, which takes precedence
 		 * over framing errors. */
@@ -281,8 +276,7 @@ static void belkin_sa_process_read_urb(struct urb *urb)
 
 	tty_insert_flip_string_fixed_flag(&port->port, data, tty_flag,
 							urb->actual_length);
-	tty_flip_buffer_push(tty);
-	tty_kref_put(tty);
+	tty_flip_buffer_push(&port->port);
 }
 
 static void belkin_sa_set_termios(struct tty_struct *tty,
diff --git a/drivers/usb/serial/cyberjack.c b/drivers/usb/serial/cyberjack.c
index e6976a9..629bd28 100644
--- a/drivers/usb/serial/cyberjack.c
+++ b/drivers/usb/serial/cyberjack.c
@@ -324,7 +324,6 @@ static void cyberjack_read_bulk_callback(struct urb *urb)
 	struct usb_serial_port *port = urb->context;
 	struct cyberjack_private *priv = usb_get_serial_port_data(port);
 	struct device *dev = &port->dev;
-	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
 	short todo;
 	int result;
@@ -337,16 +336,10 @@ static void cyberjack_read_bulk_callback(struct urb *urb)
 		return;
 	}
 
-	tty = tty_port_tty_get(&port->port);
-	if (!tty) {
-		dev_dbg(dev, "%s - ignoring since device not open\n", __func__);
-		return;
-	}
 	if (urb->actual_length) {
 		tty_insert_flip_string(&port->port, data, urb->actual_length);
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&port->port);
 	}
-	tty_kref_put(tty);
 
 	spin_lock(&priv->lock);
 
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index ac14e3e..8efa19d 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -1214,10 +1214,10 @@ static void cypress_read_int_callback(struct urb *urb)
 		spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* process read if there is data other than line status */
-	if (tty && bytes > i) {
+	if (bytes > i) {
 		tty_insert_flip_string_fixed_flag(&port->port, data + i,
 				tty_flag, bytes - i);
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&port->port);
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index b5fa738..ebe45fa 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -1399,9 +1399,7 @@ static void digi_read_bulk_callback(struct urb *urb)
 
 static int digi_read_inb_callback(struct urb *urb)
 {
-
 	struct usb_serial_port *port = urb->context;
-	struct tty_struct *tty;
 	struct digi_port *priv = usb_get_serial_port_data(port);
 	int opcode = ((unsigned char *)urb->transfer_buffer)[0];
 	int len = ((unsigned char *)urb->transfer_buffer)[1];
@@ -1425,7 +1423,6 @@ static int digi_read_inb_callback(struct urb *urb)
 		return -1;
 	}
 
-	tty = tty_port_tty_get(&port->port);
 	spin_lock(&priv->dp_port_lock);
 
 	/* check for throttle; if set, do not resubmit read urb */
@@ -1435,7 +1432,7 @@ static int digi_read_inb_callback(struct urb *urb)
 		priv->dp_throttle_restart = 1;
 
 	/* receive data */
-	if (tty && opcode == DIGI_CMD_RECEIVE_DATA) {
+	if (opcode == DIGI_CMD_RECEIVE_DATA) {
 		/* get flag from port_status */
 		flag = 0;
 
@@ -1457,11 +1454,10 @@ static int digi_read_inb_callback(struct urb *urb)
 		if (len > 0) {
 			tty_insert_flip_string_fixed_flag(&port->port, data,
 					flag, len);
-			tty_flip_buffer_push(tty);
+			tty_flip_buffer_push(&port->port);
 		}
 	}
 	spin_unlock(&priv->dp_port_lock);
-	tty_kref_put(tty);
 
 	if (opcode == DIGI_CMD_RECEIVE_DISABLE)
 		dev_dbg(&port->dev, "%s: got RECEIVE_DISABLE\n", __func__);
diff --git a/drivers/usb/serial/f81232.c b/drivers/usb/serial/f81232.c
index 6b880c3..b1b2dc6 100644
--- a/drivers/usb/serial/f81232.c
+++ b/drivers/usb/serial/f81232.c
@@ -100,7 +100,6 @@ static void f81232_process_read_urb(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	struct f81232_private *priv = usb_get_serial_port_data(port);
-	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
 	char tty_flag = TTY_NORMAL;
 	unsigned long flags;
@@ -117,10 +116,6 @@ static void f81232_process_read_urb(struct urb *urb)
 	if (!urb->actual_length)
 		return;
 
-	tty = tty_port_tty_get(&port->port);
-	if (!tty)
-		return;
-
 	/* break takes precedence over parity, */
 	/* which takes precedence over framing errors */
 	if (line_status & UART_BREAK_ERROR)
@@ -145,8 +140,7 @@ static void f81232_process_read_urb(struct urb *urb)
 							urb->actual_length);
 	}
 
-	tty_flip_buffer_push(tty);
-	tty_kref_put(tty);
+	tty_flip_buffer_push(&port->port);
 }
 
 static int set_control_lines(struct usb_device *dev, u8 value)
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index eb59ba3..a96083b 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2040,25 +2040,19 @@ static int ftdi_process_packet(struct usb_serial_port *port,
 static void ftdi_process_read_urb(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
-	struct tty_struct *tty;
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	char *data = (char *)urb->transfer_buffer;
 	int i;
 	int len;
 	int count = 0;
 
-	tty = tty_port_tty_get(&port->port);
-	if (!tty)
-		return;
-
 	for (i = 0; i < urb->actual_length; i += priv->max_packet_size) {
 		len = min_t(int, urb->actual_length - i, priv->max_packet_size);
 		count += ftdi_process_packet(port, priv, &data[i], len);
 	}
 
 	if (count)
-		tty_flip_buffer_push(tty);
-	tty_kref_put(tty);
+		tty_flip_buffer_push(&port->port);
 }
 
 static void ftdi_break_ctl(struct tty_struct *tty, int break_state)
diff --git a/drivers/usb/serial/garmin_gps.c b/drivers/usb/serial/garmin_gps.c
index 498b5f0..1a07b12 100644
--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -252,14 +252,11 @@ static inline int isAbortTrfCmnd(const unsigned char *buf)
 static void send_to_tty(struct usb_serial_port *port,
 			char *data, unsigned int actual_length)
 {
-	struct tty_struct *tty = tty_port_tty_get(&port->port);
-
-	if (tty && actual_length) {
+	if (actual_length) {
 		usb_serial_debug_data(&port->dev, __func__, actual_length, data);
 		tty_insert_flip_string(&port->port, data, actual_length);
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&port->port);
 	}
-	tty_kref_put(tty);
 }
 
 
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 3780f6a..4c5c23f 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -313,17 +313,12 @@ EXPORT_SYMBOL_GPL(usb_serial_generic_submit_read_urbs);
 void usb_serial_generic_process_read_urb(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
-	struct tty_struct *tty;
 	char *ch = (char *)urb->transfer_buffer;
 	int i;
 
 	if (!urb->actual_length)
 		return;
 
-	tty = tty_port_tty_get(&port->port);
-	if (!tty)
-		return;
-
 	/* The per character mucking around with sysrq path it too slow for
 	   stuff like 3G modems, so shortcircuit it in the 99.9999999% of cases
 	   where the USB serial is not a console anyway */
@@ -335,8 +330,7 @@ void usb_serial_generic_process_read_urb(struct urb *urb)
 				tty_insert_flip_char(&port->port, *ch, TTY_NORMAL);
 		}
 	}
-	tty_flip_buffer_push(tty);
-	tty_kref_put(tty);
+	tty_flip_buffer_push(&port->port);
 }
 EXPORT_SYMBOL_GPL(usb_serial_generic_process_read_urb);
 
diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index f96b91d..b00e5cb 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -232,8 +232,8 @@ static void  process_rcvd_data(struct edgeport_serial *edge_serial,
 				unsigned char *buffer, __u16 bufferLength);
 static void process_rcvd_status(struct edgeport_serial *edge_serial,
 				__u8 byte2, __u8 byte3);
-static void edge_tty_recv(struct usb_serial_port *port, struct tty_struct *tty,
-				unsigned char *data, int length);
+static void edge_tty_recv(struct usb_serial_port *port, unsigned char *data,
+		int length);
 static void handle_new_msr(struct edgeport_port *edge_port, __u8 newMsr);
 static void handle_new_lsr(struct edgeport_port *edge_port, __u8 lsrData,
 				__u8 lsr, __u8 data);
@@ -1752,7 +1752,6 @@ static void process_rcvd_data(struct edgeport_serial *edge_serial,
 	struct device *dev = &edge_serial->serial->dev->dev;
 	struct usb_serial_port *port;
 	struct edgeport_port *edge_port;
-	struct tty_struct *tty;
 	__u16 lastBufferLength;
 	__u16 rxLen;
 
@@ -1860,14 +1859,11 @@ static void process_rcvd_data(struct edgeport_serial *edge_serial,
 							edge_serial->rxPort];
 				edge_port = usb_get_serial_port_data(port);
 				if (edge_port->open) {
-					tty = tty_port_tty_get(
-						&edge_port->port->port);
-					if (tty) {
-						dev_dbg(dev, "%s - Sending %d bytes to TTY for port %d\n",
-							__func__, rxLen, edge_serial->rxPort);
-						edge_tty_recv(edge_port->port, tty, buffer, rxLen);
-						tty_kref_put(tty);
-					}
+					dev_dbg(dev, "%s - Sending %d bytes to TTY for port %d\n",
+						__func__, rxLen,
+						edge_serial->rxPort);
+					edge_tty_recv(edge_port->port, buffer,
+							rxLen);
 					edge_port->icount.rx += rxLen;
 				}
 				buffer += rxLen;
@@ -2017,8 +2013,8 @@ static void process_rcvd_status(struct edgeport_serial *edge_serial,
  * edge_tty_recv
  *	this function passes data on to the tty flip buffer
  *****************************************************************************/
-static void edge_tty_recv(struct usb_serial_port *port, struct tty_struct *tty,
-					unsigned char *data, int length)
+static void edge_tty_recv(struct usb_serial_port *port, unsigned char *data,
+		int length)
 {
 	int cnt;
 
@@ -2030,7 +2026,7 @@ static void edge_tty_recv(struct usb_serial_port *port, struct tty_struct *tty,
 	data += cnt;
 	length -= cnt;
 
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&port->port);
 }
 
 
@@ -2086,14 +2082,9 @@ static void handle_new_lsr(struct edgeport_port *edge_port, __u8 lsrData,
 	}
 
 	/* Place LSR data byte into Rx buffer */
-	if (lsrData) {
-		struct tty_struct *tty =
-				tty_port_tty_get(&edge_port->port->port);
-		if (tty) {
-			edge_tty_recv(edge_port->port, tty, &data, 1);
-			tty_kref_put(tty);
-		}
-	}
+	if (lsrData)
+		edge_tty_recv(edge_port->port, &data, 1);
+
 	/* update input line counters */
 	icount = &edge_port->icount;
 	if (newLsr & LSR_BREAK)
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index 1286a0b..d6485be 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -201,8 +201,8 @@ static int closing_wait = EDGE_CLOSING_WAIT;
 static bool ignore_cpu_rev;
 static int default_uart_mode;		/* RS232 */
 
-static void edge_tty_recv(struct usb_serial_port *port, struct tty_struct *tty,
-			  unsigned char *data, int length);
+static void edge_tty_recv(struct usb_serial_port *port, unsigned char *data,
+		int length);
 
 static void stop_read(struct edgeport_port *edge_port);
 static int restart_read(struct edgeport_port *edge_port);
@@ -1540,7 +1540,6 @@ static void handle_new_lsr(struct edgeport_port *edge_port, int lsr_data,
 	struct async_icount *icount;
 	__u8 new_lsr = (__u8)(lsr & (__u8)(LSR_OVER_ERR | LSR_PAR_ERR |
 						LSR_FRM_ERR | LSR_BREAK));
-	struct tty_struct *tty;
 
 	dev_dbg(&edge_port->port->dev, "%s - %02x\n", __func__, new_lsr);
 
@@ -1554,13 +1553,8 @@ static void handle_new_lsr(struct edgeport_port *edge_port, int lsr_data,
 		new_lsr &= (__u8)(LSR_OVER_ERR | LSR_BREAK);
 
 	/* Place LSR data byte into Rx buffer */
-	if (lsr_data) {
-		tty = tty_port_tty_get(&edge_port->port->port);
-		if (tty) {
-			edge_tty_recv(edge_port->port, tty, &data, 1);
-			tty_kref_put(tty);
-		}
-	}
+	if (lsr_data)
+		edge_tty_recv(edge_port->port, &data, 1);
 
 	/* update input line counters */
 	icount = &edge_port->icount;
@@ -1676,7 +1670,6 @@ static void edge_bulk_in_callback(struct urb *urb)
 	struct edgeport_port *edge_port = urb->context;
 	struct device *dev = &edge_port->port->dev;
 	unsigned char *data = urb->transfer_buffer;
-	struct tty_struct *tty;
 	int retval = 0;
 	int port_number;
 	int status = urb->status;
@@ -1715,18 +1708,16 @@ static void edge_bulk_in_callback(struct urb *urb)
 		++data;
 	}
 
-	tty = tty_port_tty_get(&edge_port->port->port);
-	if (tty && urb->actual_length) {
+	if (urb->actual_length) {
 		usb_serial_debug_data(dev, __func__, urb->actual_length, data);
 		if (edge_port->close_pending)
 			dev_dbg(dev, "%s - close pending, dropping data on the floor\n",
 								__func__);
 		else
-			edge_tty_recv(edge_port->port, tty, data,
+			edge_tty_recv(edge_port->port, data,
 					urb->actual_length);
 		edge_port->icount.rx += urb->actual_length;
 	}
-	tty_kref_put(tty);
 
 exit:
 	/* continue read unless stopped */
@@ -1741,8 +1732,8 @@ exit:
 		dev_err(dev, "%s - usb_submit_urb failed with result %d\n", __func__, retval);
 }
 
-static void edge_tty_recv(struct usb_serial_port *port, struct tty_struct *tty,
-					unsigned char *data, int length)
+static void edge_tty_recv(struct usb_serial_port *port, unsigned char *data,
+		int length)
 {
 	int queued;
 
@@ -1750,7 +1741,7 @@ static void edge_tty_recv(struct usb_serial_port *port, struct tty_struct *tty,
 	if (queued < length)
 		dev_err(&port->dev, "%s - dropping data, %d bytes lost\n",
 			__func__, length - queued);
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&port->port);
 }
 
 static void edge_bulk_out_callback(struct urb *urb)
diff --git a/drivers/usb/serial/ir-usb.c b/drivers/usb/serial/ir-usb.c
index 171dae1..716930a 100644
--- a/drivers/usb/serial/ir-usb.c
+++ b/drivers/usb/serial/ir-usb.c
@@ -287,7 +287,6 @@ static void ir_process_read_urb(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	unsigned char *data = urb->transfer_buffer;
-	struct tty_struct *tty;
 
 	if (!urb->actual_length)
 		return;
@@ -302,12 +301,8 @@ static void ir_process_read_urb(struct urb *urb)
 	if (urb->actual_length == 1)
 		return;
 
-	tty = tty_port_tty_get(&port->port);
-	if (!tty)
-		return;
 	tty_insert_flip_string(&port->port, data + 1, urb->actual_length - 1);
-	tty_flip_buffer_push(tty);
-	tty_kref_put(tty);
+	tty_flip_buffer_push(&port->port);
 }
 
 static void ir_set_termios_callback(struct urb *urb)
diff --git a/drivers/usb/serial/iuu_phoenix.c b/drivers/usb/serial/iuu_phoenix.c
index dd0d910..ff77027 100644
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -581,7 +581,6 @@ static void read_buf_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	unsigned char *data = urb->transfer_buffer;
-	struct tty_struct *tty;
 	int status = urb->status;
 
 	if (status) {
@@ -592,14 +591,12 @@ static void read_buf_callback(struct urb *urb)
 	}
 
 	dev_dbg(&port->dev, "%s - %i chars to write\n", __func__, urb->actual_length);
-	tty = tty_port_tty_get(&port->port);
 	if (data == NULL)
 		dev_dbg(&port->dev, "%s - data is NULL !!!\n", __func__);
-	if (tty && urb->actual_length && data) {
+	if (urb->actual_length && data) {
 		tty_insert_flip_string(&port->port, data, urb->actual_length);
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&port->port);
 	}
-	tty_kref_put(tty);
 	iuu_led_activity_on(urb);
 }
 
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 14a219b..f6d7f68 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -291,7 +291,6 @@ static void	usa26_indat_callback(struct urb *urb)
 	int			i, err;
 	int			endpoint;
 	struct usb_serial_port	*port;
-	struct tty_struct	*tty;
 	unsigned char 		*data = urb->transfer_buffer;
 	int status = urb->status;
 
@@ -304,8 +303,7 @@ static void	usa26_indat_callback(struct urb *urb)
 	}
 
 	port =  urb->context;
-	tty = tty_port_tty_get(&port->port);
-	if (tty && urb->actual_length) {
+	if (urb->actual_length) {
 		/* 0x80 bit is error flag */
 		if ((data[0] & 0x80) == 0) {
 			/* no errors on individual bytes, only
@@ -332,9 +330,8 @@ static void	usa26_indat_callback(struct urb *urb)
 						flag);
 			}
 		}
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&port->port);
 	}
-	tty_kref_put(tty);
 
 	/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
@@ -447,7 +444,6 @@ static void usa28_indat_callback(struct urb *urb)
 {
 	int                     err;
 	struct usb_serial_port  *port;
-	struct tty_struct       *tty;
 	unsigned char           *data;
 	struct keyspan_port_private             *p_priv;
 	int status = urb->status;
@@ -470,13 +466,11 @@ static void usa28_indat_callback(struct urb *urb)
 		p_priv = usb_get_serial_port_data(port);
 		data = urb->transfer_buffer;
 
-		tty = tty_port_tty_get(&port->port);
-		if (tty && urb->actual_length) {
+		if (urb->actual_length) {
 			tty_insert_flip_string(&port->port, data,
 					urb->actual_length);
-			tty_flip_buffer_push(tty);
+			tty_flip_buffer_push(&port->port);
 		}
-		tty_kref_put(tty);
 
 		/* Resubmit urb so we continue receiving */
 		err = usb_submit_urb(urb, GFP_ATOMIC);
@@ -671,7 +665,6 @@ static void	usa49_indat_callback(struct urb *urb)
 	int			i, err;
 	int			endpoint;
 	struct usb_serial_port	*port;
-	struct tty_struct	*tty;
 	unsigned char 		*data = urb->transfer_buffer;
 	int status = urb->status;
 
@@ -684,8 +677,7 @@ static void	usa49_indat_callback(struct urb *urb)
 	}
 
 	port =  urb->context;
-	tty = tty_port_tty_get(&port->port);
-	if (tty && urb->actual_length) {
+	if (urb->actual_length) {
 		/* 0x80 bit is error flag */
 		if ((data[0] & 0x80) == 0) {
 			/* no error on any byte */
@@ -706,9 +698,8 @@ static void	usa49_indat_callback(struct urb *urb)
 						flag);
 			}
 		}
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&port->port);
 	}
-	tty_kref_put(tty);
 
 	/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
@@ -721,7 +712,6 @@ static void usa49wg_indat_callback(struct urb *urb)
 	int			i, len, x, err;
 	struct usb_serial	*serial;
 	struct usb_serial_port	*port;
-	struct tty_struct	*tty;
 	unsigned char 		*data = urb->transfer_buffer;
 	int status = urb->status;
 
@@ -746,7 +736,6 @@ static void usa49wg_indat_callback(struct urb *urb)
 				return;
 			}
 			port = serial->port[data[i++]];
-			tty = tty_port_tty_get(&port->port);
 			len = data[i++];
 
 			/* 0x80 bit is error flag */
@@ -774,8 +763,7 @@ static void usa49wg_indat_callback(struct urb *urb)
 					i += 2;
 				}
 			}
-			tty_flip_buffer_push(tty);
-			tty_kref_put(tty);
+			tty_flip_buffer_push(&port->port);
 		}
 	}
 
@@ -796,7 +784,6 @@ static void usa90_indat_callback(struct urb *urb)
 	int			endpoint;
 	struct usb_serial_port	*port;
 	struct keyspan_port_private	 	*p_priv;
-	struct tty_struct	*tty;
 	unsigned char 		*data = urb->transfer_buffer;
 	int status = urb->status;
 
@@ -812,7 +799,6 @@ static void usa90_indat_callback(struct urb *urb)
 	p_priv = usb_get_serial_port_data(port);
 
 	if (urb->actual_length) {
-		tty = tty_port_tty_get(&port->port);
 		/* if current mode is DMA, looks like usa28 format
 		   otherwise looks like usa26 data format */
 
@@ -848,8 +834,7 @@ static void usa90_indat_callback(struct urb *urb)
 				}
 			}
 		}
-		tty_flip_buffer_push(tty);
-		tty_kref_put(tty);
+		tty_flip_buffer_push(&port->port);
 	}
 
 	/* Resubmit urb so we continue receiving */
diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index 334b1a2..3b17d5d 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -138,7 +138,6 @@ static void keyspan_pda_request_unthrottle(struct work_struct *work)
 static void keyspan_pda_rx_interrupt(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
-	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
 	int retval;
 	int status = urb->status;
@@ -163,14 +162,12 @@ static void keyspan_pda_rx_interrupt(struct urb *urb)
 	/* see if the message is data or a status interrupt */
 	switch (data[0]) {
 	case 0:
-		tty = tty_port_tty_get(&port->port);
 		 /* rest of message is rx data */
-		if (tty && urb->actual_length) {
+		if (urb->actual_length) {
 			tty_insert_flip_string(&port->port, data + 1,
 						urb->actual_length - 1);
-			tty_flip_buffer_push(tty);
+			tty_flip_buffer_push(&port->port);
 		}
-		tty_kref_put(tty);
 		break;
 	case 1:
 		/* status interrupt */
diff --git a/drivers/usb/serial/kl5kusb105.c b/drivers/usb/serial/kl5kusb105.c
index 8ee0825..769d910 100644
--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@ -389,7 +389,6 @@ static void klsi_105_process_read_urb(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	unsigned char *data = urb->transfer_buffer;
-	struct tty_struct *tty;
 	unsigned len;
 
 	/* empty urbs seem to happen, we ignore them */
@@ -401,10 +400,6 @@ static void klsi_105_process_read_urb(struct urb *urb)
 		return;
 	}
 
-	tty = tty_port_tty_get(&port->port);
-	if (!tty)
-		return;
-
 	len = get_unaligned_le16(data);
 	if (len > urb->actual_length - KLSI_HDR_LEN) {
 		dev_dbg(&port->dev, "%s - packet length mismatch\n", __func__);
@@ -412,8 +407,7 @@ static void klsi_105_process_read_urb(struct urb *urb)
 	}
 
 	tty_insert_flip_string(&port->port, data + KLSI_HDR_LEN, len);
-	tty_flip_buffer_push(tty);
-	tty_kref_put(tty);
+	tty_flip_buffer_push(&port->port);
 }
 
 static void klsi_105_set_termios(struct tty_struct *tty,
diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
index 135c8b4..903d938 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -324,7 +324,6 @@ static void kobil_read_int_callback(struct urb *urb)
 {
 	int result;
 	struct usb_serial_port *port = urb->context;
-	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
 	int status = urb->status;
 
@@ -333,8 +332,7 @@ static void kobil_read_int_callback(struct urb *urb)
 		return;
 	}
 
-	tty = tty_port_tty_get(&port->port);
-	if (tty && urb->actual_length) {
+	if (urb->actual_length) {
 
 		/* BEGIN DEBUG */
 		/*
@@ -354,9 +352,8 @@ static void kobil_read_int_callback(struct urb *urb)
 		/* END DEBUG */
 
 		tty_insert_flip_string(&port->port, data, urb->actual_length);
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&port->port);
 	}
-	tty_kref_put(tty);
 
 	result = usb_submit_urb(port->interrupt_in_urb, GFP_ATOMIC);
 	dev_dbg(&port->dev, "%s - Send read URB returns: %i\n", __func__, result);
diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
index ba20bb0..f42528e 100644
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -531,7 +531,6 @@ static void mct_u232_read_int_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
-	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
 	int retval;
 	int status = urb->status;
@@ -561,13 +560,9 @@ static void mct_u232_read_int_callback(struct urb *urb)
 	 */
 	if (urb->transfer_buffer_length > 2) {
 		if (urb->actual_length) {
-			tty = tty_port_tty_get(&port->port);
-			if (tty) {
-				tty_insert_flip_string(&port->port, data,
-						urb->actual_length);
-				tty_flip_buffer_push(tty);
-			}
-			tty_kref_put(tty);
+			tty_insert_flip_string(&port->port, data,
+					urb->actual_length);
+			tty_flip_buffer_push(&port->port);
 		}
 		goto exit;
 	}
diff --git a/drivers/usb/serial/metro-usb.c b/drivers/usb/serial/metro-usb.c
index 6264f39..bf3c7a2 100644
--- a/drivers/usb/serial/metro-usb.c
+++ b/drivers/usb/serial/metro-usb.c
@@ -95,7 +95,6 @@ static void metrousb_read_int_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	struct metrousb_private *metro_priv = usb_get_serial_port_data(port);
-	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
 	int throttled = 0;
 	int result = 0;
@@ -124,15 +123,13 @@ static void metrousb_read_int_callback(struct urb *urb)
 
 
 	/* Set the data read from the usb port into the serial port buffer. */
-	tty = tty_port_tty_get(&port->port);
-	if (tty && urb->actual_length) {
+	if (urb->actual_length) {
 		/* Loop through the data copying each byte to the tty layer. */
 		tty_insert_flip_string(&port->port, data, urb->actual_length);
 
 		/* Force the data to the tty layer. */
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&port->port);
 	}
-	tty_kref_put(tty);
 
 	/* Set any port variables. */
 	spin_lock_irqsave(&metro_priv->lock, flags);
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 22818fb..e0ebec3 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -899,7 +899,6 @@ static void mos7720_bulk_in_callback(struct urb *urb)
 	int retval;
 	unsigned char *data ;
 	struct usb_serial_port *port;
-	struct tty_struct *tty;
 	int status = urb->status;
 
 	if (status) {
@@ -913,12 +912,10 @@ static void mos7720_bulk_in_callback(struct urb *urb)
 
 	data = urb->transfer_buffer;
 
-	tty = tty_port_tty_get(&port->port);
-	if (tty && urb->actual_length) {
+	if (urb->actual_length) {
 		tty_insert_flip_string(&port->port, data, urb->actual_length);
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&port->port);
 	}
-	tty_kref_put(tty);
 
 	if (port->read_urb->status != -EINPROGRESS) {
 		retval = usb_submit_urb(port->read_urb, GFP_ATOMIC);
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 3ddd7a1..809fb32 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -744,7 +744,6 @@ static void mos7840_bulk_in_callback(struct urb *urb)
 	struct usb_serial *serial;
 	struct usb_serial_port *port;
 	struct moschip_port *mos7840_port;
-	struct tty_struct *tty;
 	int status = urb->status;
 
 	mos7840_port = urb->context;
@@ -774,12 +773,8 @@ static void mos7840_bulk_in_callback(struct urb *urb)
 
 	if (urb->actual_length) {
 		struct tty_port *tport = &mos7840_port->port->port;
-		tty = tty_port_tty_get(tport);
-		if (tty) {
-			tty_insert_flip_string(tport, data, urb->actual_length);
-			tty_flip_buffer_push(tty);
-			tty_kref_put(tty);
-		}
+		tty_insert_flip_string(tport, data, urb->actual_length);
+		tty_flip_buffer_push(tport);
 		mos7840_port->icount.rx += urb->actual_length;
 		smp_wmb();
 		dev_dbg(&port->dev, "mos7840_port->icount.rx is %d:\n", mos7840_port->icount.rx);
diff --git a/drivers/usb/serial/navman.c b/drivers/usb/serial/navman.c
index 0d96a1a..38725fc 100644
--- a/drivers/usb/serial/navman.c
+++ b/drivers/usb/serial/navman.c
@@ -32,7 +32,6 @@ static void navman_read_int_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	unsigned char *data = urb->transfer_buffer;
-	struct tty_struct *tty;
 	int status = urb->status;
 	int result;
 
@@ -55,12 +54,10 @@ static void navman_read_int_callback(struct urb *urb)
 
 	usb_serial_debug_data(&port->dev, __func__, urb->actual_length, data);
 
-	tty = tty_port_tty_get(&port->port);
-	if (tty && urb->actual_length) {
+	if (urb->actual_length) {
 		tty_insert_flip_string(&port->port, data, urb->actual_length);
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&port->port);
 	}
-	tty_kref_put(tty);
 
 exit:
 	result = usb_submit_urb(urb, GFP_ATOMIC);
diff --git a/drivers/usb/serial/omninet.c b/drivers/usb/serial/omninet.c
index 338191b..1e1cafe 100644
--- a/drivers/usb/serial/omninet.c
+++ b/drivers/usb/serial/omninet.c
@@ -174,14 +174,9 @@ static void omninet_read_bulk_callback(struct urb *urb)
 	}
 
 	if (urb->actual_length && header->oh_len) {
-		struct tty_struct *tty = tty_port_tty_get(&port->port);
-		if (tty) {
-			tty_insert_flip_string(&port->port,
-					data + OMNINET_DATAOFFSET,
-					header->oh_len);
-			tty_flip_buffer_push(tty);
-			tty_kref_put(tty);
-		}
+		tty_insert_flip_string(&port->port, data + OMNINET_DATAOFFSET,
+				header->oh_len);
+		tty_flip_buffer_push(&port->port);
 	}
 
 	/* Continue trying to always read  */
diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index d3b74e5..e13e1a4 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -51,15 +51,8 @@ struct opticon_private {
 static void opticon_process_data_packet(struct usb_serial_port *port,
 					const unsigned char *buf, size_t len)
 {
-	struct tty_struct *tty;
-
-	tty = tty_port_tty_get(&port->port);
-	if (!tty)
-		return;
-
 	tty_insert_flip_string(&port->port, buf, len);
-	tty_flip_buffer_push(tty);
-	tty_kref_put(tty);
+	tty_flip_buffer_push(&port->port);
 }
 
 static void opticon_process_status_packet(struct usb_serial_port *port,
diff --git a/drivers/usb/serial/oti6858.c b/drivers/usb/serial/oti6858.c
index 7a53fe9..a958fd4 100644
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -820,7 +820,6 @@ static void oti6858_read_bulk_callback(struct urb *urb)
 {
 	struct usb_serial_port *port =  urb->context;
 	struct oti6858_private *priv = usb_get_serial_port_data(port);
-	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
 	unsigned long flags;
 	int status = urb->status;
@@ -835,12 +834,10 @@ static void oti6858_read_bulk_callback(struct urb *urb)
 		return;
 	}
 
-	tty = tty_port_tty_get(&port->port);
-	if (tty != NULL && urb->actual_length > 0) {
+	if (urb->actual_length > 0) {
 		tty_insert_flip_string(&port->port, data, urb->actual_length);
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&port->port);
 	}
-	tty_kref_put(tty);
 
 	/* schedule the interrupt urb */
 	result = usb_submit_urb(port->interrupt_in_urb, GFP_ATOMIC);
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 00047f3..54adc91 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -772,7 +772,6 @@ static void pl2303_process_read_urb(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	struct pl2303_private *priv = usb_get_serial_port_data(port);
-	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
 	char tty_flag = TTY_NORMAL;
 	unsigned long flags;
@@ -789,10 +788,6 @@ static void pl2303_process_read_urb(struct urb *urb)
 	if (!urb->actual_length)
 		return;
 
-	tty = tty_port_tty_get(&port->port);
-	if (!tty)
-		return;
-
 	/* break takes precedence over parity, */
 	/* which takes precedence over framing errors */
 	if (line_status & UART_BREAK_ERROR)
@@ -817,8 +812,7 @@ static void pl2303_process_read_urb(struct urb *urb)
 							urb->actual_length);
 	}
 
-	tty_flip_buffer_push(tty);
-	tty_kref_put(tty);
+	tty_flip_buffer_push(&port->port);
 }
 
 /* All of the device info needed for the PL2303 SIO serial converter */
diff --git a/drivers/usb/serial/quatech2.c b/drivers/usb/serial/quatech2.c
index 5dccc4f..6850745 100644
--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -609,7 +609,6 @@ void qt2_process_read_urb(struct urb *urb)
 	struct qt2_serial_private *serial_priv;
 	struct usb_serial_port *port;
 	struct qt2_port_private *port_priv;
-	struct tty_struct *tty;
 	bool escapeflag;
 	unsigned char *ch;
 	int i;
@@ -620,15 +619,11 @@ void qt2_process_read_urb(struct urb *urb)
 		return;
 
 	ch = urb->transfer_buffer;
-	tty = NULL;
 	serial = urb->context;
 	serial_priv = usb_get_serial_data(serial);
 	port = serial->port[serial_priv->current_port];
 	port_priv = usb_get_serial_port_data(port);
 
-	if (port_priv->is_open)
-		tty = tty_port_tty_get(&port->port);
-
 	for (i = 0; i < urb->actual_length; i++) {
 		ch = (unsigned char *)urb->transfer_buffer + i;
 		if ((i <= (len - 3)) &&
@@ -666,10 +661,7 @@ void qt2_process_read_urb(struct urb *urb)
 						 __func__);
 					break;
 				}
-				if (tty) {
-					tty_flip_buffer_push(tty);
-					tty_kref_put(tty);
-				}
+				tty_flip_buffer_push(&port->port);
 
 				newport = *(ch + 3);
 
@@ -683,10 +675,6 @@ void qt2_process_read_urb(struct urb *urb)
 				serial_priv->current_port = newport;
 				port = serial->port[serial_priv->current_port];
 				port_priv = usb_get_serial_port_data(port);
-				if (port_priv->is_open)
-					tty = tty_port_tty_get(&port->port);
-				else
-					tty = NULL;
 				i += 3;
 				escapeflag = true;
 				break;
@@ -716,10 +704,7 @@ void qt2_process_read_urb(struct urb *urb)
 		tty_insert_flip_string(&port->port, ch, 1);
 	}
 
-	if (tty) {
-		tty_flip_buffer_push(tty);
-		tty_kref_put(tty);
-	}
+	tty_flip_buffer_push(&port->port);
 }
 
 static void qt2_write_bulk_callback(struct urb *urb)
diff --git a/drivers/usb/serial/safe_serial.c b/drivers/usb/serial/safe_serial.c
index ad12e9e..21cd7bf 100644
--- a/drivers/usb/serial/safe_serial.c
+++ b/drivers/usb/serial/safe_serial.c
@@ -207,38 +207,31 @@ static void safe_process_read_urb(struct urb *urb)
 	unsigned char *data = urb->transfer_buffer;
 	unsigned char length = urb->actual_length;
 	int actual_length;
-	struct tty_struct *tty;
 	__u16 fcs;
 
 	if (!length)
 		return;
 
-	tty = tty_port_tty_get(&port->port);
-	if (!tty)
-		return;
-
 	if (!safe)
 		goto out;
 
 	fcs = fcs_compute10(data, length, CRC10_INITFCS);
 	if (fcs) {
 		dev_err(&port->dev, "%s - bad CRC %x\n", __func__, fcs);
-		goto err;
+		return;
 	}
 
 	actual_length = data[length - 2] >> 2;
 	if (actual_length > (length - 2)) {
 		dev_err(&port->dev, "%s - inconsistent lengths %d:%d\n",
 				__func__, actual_length, length);
-		goto err;
+		return;
 	}
 	dev_info(&urb->dev->dev, "%s - actual: %d\n", __func__, actual_length);
 	length = actual_length;
 out:
 	tty_insert_flip_string(&port->port, data, length);
-	tty_flip_buffer_push(tty);
-err:
-	tty_kref_put(tty);
+	tty_flip_buffer_push(&port->port);
 }
 
 static int safe_prepare_write_buffer(struct usb_serial_port *port,
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 64e53fd..70aee8d 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -569,7 +569,6 @@ static void sierra_indat_callback(struct urb *urb)
 	int err;
 	int endpoint;
 	struct usb_serial_port *port;
-	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
 	int status = urb->status;
 
@@ -581,16 +580,12 @@ static void sierra_indat_callback(struct urb *urb)
 			" endpoint %02x\n", __func__, status, endpoint);
 	} else {
 		if (urb->actual_length) {
-			tty = tty_port_tty_get(&port->port);
-			if (tty) {
-				tty_insert_flip_string(&port->port, data,
-					urb->actual_length);
-				tty_flip_buffer_push(tty);
-
-				tty_kref_put(tty);
-				usb_serial_debug_data(&port->dev, __func__,
-						      urb->actual_length, data);
-			}
+			tty_insert_flip_string(&port->port, data,
+				urb->actual_length);
+			tty_flip_buffer_push(&port->port);
+
+			usb_serial_debug_data(&port->dev, __func__,
+					      urb->actual_length, data);
 		} else {
 			dev_dbg(&port->dev, "%s: empty read urb"
 				" received\n", __func__);
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index 04e3731..91ff8e3 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -462,7 +462,6 @@ static void spcp8x5_process_read_urb(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
-	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
 	unsigned long flags;
 	u8 status;
@@ -481,9 +480,6 @@ static void spcp8x5_process_read_urb(struct urb *urb)
 	if (!urb->actual_length)
 		return;
 
-	tty = tty_port_tty_get(&port->port);
-	if (!tty)
-		return;
 
 	if (status & UART_STATE_TRANSIENT_MASK) {
 		/* break takes precedence over parity, which takes precedence
@@ -500,15 +496,19 @@ static void spcp8x5_process_read_urb(struct urb *urb)
 		if (status & UART_OVERRUN_ERROR)
 			tty_insert_flip_char(&port->port, 0, TTY_OVERRUN);
 
-		if (status & UART_DCD)
-			usb_serial_handle_dcd_change(port, tty,
-				   priv->line_status & MSR_STATUS_LINE_DCD);
+		if (status & UART_DCD) {
+			struct tty_struct *tty = tty_port_tty_get(&port->port);
+			if (tty) {
+				usb_serial_handle_dcd_change(port, tty,
+				       priv->line_status & MSR_STATUS_LINE_DCD);
+				tty_kref_put(tty);
+			}
+		}
 	}
 
 	tty_insert_flip_string_fixed_flag(&port->port, data, tty_flag,
 							urb->actual_length);
-	tty_flip_buffer_push(tty);
-	tty_kref_put(tty);
+	tty_flip_buffer_push(&port->port);
 }
 
 static int spcp8x5_wait_modem_info(struct usb_serial_port *port,
diff --git a/drivers/usb/serial/ssu100.c b/drivers/usb/serial/ssu100.c
index 3871315..58bc7e7 100644
--- a/drivers/usb/serial/ssu100.c
+++ b/drivers/usb/serial/ssu100.c
@@ -582,7 +582,7 @@ static void ssu100_update_lsr(struct usb_serial_port *port, u8 lsr,
 
 }
 
-static int ssu100_process_packet(struct urb *urb)
+static void ssu100_process_read_urb(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	char *packet = (char *)urb->transfer_buffer;
@@ -609,7 +609,7 @@ static int ssu100_process_packet(struct urb *urb)
 		ch = packet;
 
 	if (!len)
-		return 0;	/* status only */
+		return;	/* status only */
 
 	if (port->port.console && port->sysrq) {
 		for (i = 0; i < len; i++, ch++) {
@@ -619,24 +619,7 @@ static int ssu100_process_packet(struct urb *urb)
 	} else
 		tty_insert_flip_string_fixed_flag(&port->port, ch, flag, len);
 
-	return len;
-}
-
-static void ssu100_process_read_urb(struct urb *urb)
-{
-	struct usb_serial_port *port = urb->context;
-	struct tty_struct *tty;
-	int count;
-
-	tty = tty_port_tty_get(&port->port);
-	if (!tty)
-		return;
-
-	count = ssu100_process_packet(urb);
-
-	if (count)
-		tty_flip_buffer_push(tty);
-	tty_kref_put(tty);
+	tty_flip_buffer_push(&port->port);
 }
 
 static struct usb_serial_driver ssu100_device = {
diff --git a/drivers/usb/serial/symbolserial.c b/drivers/usb/serial/symbolserial.c
index 2ffa6ae..be05e6c 100644
--- a/drivers/usb/serial/symbolserial.c
+++ b/drivers/usb/serial/symbolserial.c
@@ -48,7 +48,6 @@ static void symbol_int_callback(struct urb *urb)
 	unsigned char *data = urb->transfer_buffer;
 	struct usb_serial_port *port = priv->port;
 	int status = urb->status;
-	struct tty_struct *tty;
 	int result;
 	int data_length;
 
@@ -82,13 +81,8 @@ static void symbol_int_callback(struct urb *urb)
 		 * we pretty much just ignore the size and send everything
 		 * else to the tty layer.
 		 */
-		tty = tty_port_tty_get(&port->port);
-		if (tty) {
-			tty_insert_flip_string(&port->port, &data[1],
-					data_length);
-			tty_flip_buffer_push(tty);
-			tty_kref_put(tty);
-		}
+		tty_insert_flip_string(&port->port, &data[1], data_length);
+		tty_flip_buffer_push(&port->port);
 	} else {
 		dev_dbg(&priv->udev->dev,
 			"Improper amount of data received from the device, "
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 05077e3..39cb9b8 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -121,8 +121,8 @@ static void ti_interrupt_callback(struct urb *urb);
 static void ti_bulk_in_callback(struct urb *urb);
 static void ti_bulk_out_callback(struct urb *urb);
 
-static void ti_recv(struct usb_serial_port *port, struct tty_struct *tty,
-	unsigned char *data, int length);
+static void ti_recv(struct usb_serial_port *port, unsigned char *data,
+		int length);
 static void ti_send(struct ti_port *tport);
 static int ti_set_mcr(struct ti_port *tport, unsigned int mcr);
 static int ti_get_lsr(struct ti_port *tport);
@@ -1118,7 +1118,6 @@ static void ti_bulk_in_callback(struct urb *urb)
 	struct device *dev = &urb->dev->dev;
 	int status = urb->status;
 	int retval = 0;
-	struct tty_struct *tty;
 
 	switch (status) {
 	case 0:
@@ -1145,23 +1144,18 @@ static void ti_bulk_in_callback(struct urb *urb)
 		return;
 	}
 
-	tty = tty_port_tty_get(&port->port);
-	if (tty) {
-		if (urb->actual_length) {
-			usb_serial_debug_data(dev, __func__, urb->actual_length,
-					      urb->transfer_buffer);
+	if (urb->actual_length) {
+		usb_serial_debug_data(dev, __func__, urb->actual_length,
+				      urb->transfer_buffer);
 
-			if (!tport->tp_is_open)
-				dev_dbg(dev, "%s - port closed, dropping data\n",
-					__func__);
-			else
-				ti_recv(port, tty, urb->transfer_buffer,
-						urb->actual_length);
-			spin_lock(&tport->tp_lock);
-			tport->tp_icount.rx += urb->actual_length;
-			spin_unlock(&tport->tp_lock);
-		}
-		tty_kref_put(tty);
+		if (!tport->tp_is_open)
+			dev_dbg(dev, "%s - port closed, dropping data\n",
+				__func__);
+		else
+			ti_recv(port, urb->transfer_buffer, urb->actual_length);
+		spin_lock(&tport->tp_lock);
+		tport->tp_icount.rx += urb->actual_length;
+		spin_unlock(&tport->tp_lock);
 	}
 
 exit:
@@ -1209,8 +1203,8 @@ static void ti_bulk_out_callback(struct urb *urb)
 }
 
 
-static void ti_recv(struct usb_serial_port *port, struct tty_struct *tty,
-	unsigned char *data, int length)
+static void ti_recv(struct usb_serial_port *port, unsigned char *data,
+		int length)
 {
 	int cnt;
 
@@ -1222,11 +1216,10 @@ static void ti_recv(struct usb_serial_port *port, struct tty_struct *tty,
 			if (cnt == 0)
 				break;
 		}
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&port->port);
 		data += cnt;
 		length -= cnt;
 	} while (length > 0);
-
 }
 
 
diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 293b460..a547c91 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -275,7 +275,6 @@ static void usb_wwan_indat_callback(struct urb *urb)
 	int err;
 	int endpoint;
 	struct usb_serial_port *port;
-	struct tty_struct *tty;
 	struct device *dev;
 	unsigned char *data = urb->transfer_buffer;
 	int status = urb->status;
@@ -288,16 +287,12 @@ static void usb_wwan_indat_callback(struct urb *urb)
 		dev_dbg(dev, "%s: nonzero status: %d on endpoint %02x.\n",
 			__func__, status, endpoint);
 	} else {
-		tty = tty_port_tty_get(&port->port);
-		if (tty) {
-			if (urb->actual_length) {
-				tty_insert_flip_string(&port->port, data,
-						urb->actual_length);
-				tty_flip_buffer_push(tty);
-			} else
-				dev_dbg(dev, "%s: empty read urb received\n", __func__);
-			tty_kref_put(tty);
-		}
+		if (urb->actual_length) {
+			tty_insert_flip_string(&port->port, data,
+					urb->actual_length);
+			tty_flip_buffer_push(&port->port);
+		} else
+			dev_dbg(dev, "%s: empty read urb received\n", __func__);
 
 		/* Resubmit urb so we continue receiving */
 		err = usb_submit_urb(urb, GFP_ATOMIC);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index f16a47a..f89acd1 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -387,7 +387,6 @@ extern void do_SAK(struct tty_struct *tty);
 extern void __do_SAK(struct tty_struct *tty);
 extern void disassociate_ctty(int priv);
 extern void no_tty(void);
-extern void tty_flip_buffer_push(struct tty_struct *tty);
 extern void tty_flush_to_ldisc(struct tty_struct *tty);
 extern void tty_buffer_free_all(struct tty_port *port);
 extern void tty_buffer_flush(struct tty_struct *tty);
diff --git a/include/linux/tty_flip.h b/include/linux/tty_flip.h
index 5cb694a..c557280 100644
--- a/include/linux/tty_flip.h
+++ b/include/linux/tty_flip.h
@@ -10,6 +10,7 @@ extern int tty_prepare_flip_string(struct tty_port *port,
 		unsigned char **chars, size_t size);
 extern int tty_prepare_flip_string_flags(struct tty_port *port,
 		unsigned char **chars, char **flags, size_t size);
+extern void tty_flip_buffer_push(struct tty_port *port);
 void tty_schedule_flip(struct tty_struct *tty);
 
 static inline int tty_insert_flip_char(struct tty_port *port,
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index cbec3b6..b6e44ad 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -541,23 +541,21 @@ int rfcomm_dev_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
 static void rfcomm_dev_data_ready(struct rfcomm_dlc *dlc, struct sk_buff *skb)
 {
 	struct rfcomm_dev *dev = dlc->owner;
-	struct tty_struct *tty;
 
 	if (!dev) {
 		kfree_skb(skb);
 		return;
 	}
 
-	tty = dev->port.tty;
-	if (!tty || !skb_queue_empty(&dev->pending)) {
+	if (!skb_queue_empty(&dev->pending)) {
 		skb_queue_tail(&dev->pending, skb);
 		return;
 	}
 
-	BT_DBG("dlc %p tty %p len %d", dlc, tty, skb->len);
+	BT_DBG("dlc %p len %d", dlc, skb->len);
 
 	tty_insert_flip_string(&dev->port, skb->data, skb->len);
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&dev->port);
 
 	kfree_skb(skb);
 }
@@ -621,14 +619,10 @@ static void rfcomm_dev_modem_status(struct rfcomm_dlc *dlc, u8 v24_sig)
 /* ---- TTY functions ---- */
 static void rfcomm_tty_copy_pending(struct rfcomm_dev *dev)
 {
-	struct tty_struct *tty = dev->port.tty;
 	struct sk_buff *skb;
 	int inserted = 0;
 
-	if (!tty)
-		return;
-
-	BT_DBG("dev %p tty %p", dev, tty);
+	BT_DBG("dev %p", dev);
 
 	rfcomm_dlc_lock(dev->dlc);
 
@@ -641,7 +635,7 @@ static void rfcomm_tty_copy_pending(struct rfcomm_dev *dev)
 	rfcomm_dlc_unlock(dev->dlc);
 
 	if (inserted > 0)
-		tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(&dev->port);
 }
 
 static int rfcomm_tty_open(struct tty_struct *tty, struct file *filp)
diff --git a/net/irda/ircomm/ircomm_tty.c b/net/irda/ircomm/ircomm_tty.c
index 2491f6f..9a5fd3c 100644
--- a/net/irda/ircomm/ircomm_tty.c
+++ b/net/irda/ircomm/ircomm_tty.c
@@ -1136,14 +1136,14 @@ static int ircomm_tty_data_indication(void *instance, void *sap,
 		ircomm_tty_send_initial_parameters(self);
 		ircomm_tty_link_established(self);
 	}
+	tty_kref_put(tty);
 
 	/*
 	 * Use flip buffer functions since the code may be called from interrupt
 	 * context
 	 */
 	tty_insert_flip_string(&self->port, skb->data, skb->len);
-	tty_flip_buffer_push(tty);
-	tty_kref_put(tty);
+	tty_flip_buffer_push(&self->port);
 
 	/* No need to kfree_skb - see ircomm_ttp_data_indication() */
 
-- 
1.8.1


