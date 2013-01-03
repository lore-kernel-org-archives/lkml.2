Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab3ACOyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 09:54:46 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:60984 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab3ACOxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 09:53:18 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 03/10] TTY: switch tty_insert_flip_char
Date: Thu,  3 Jan 2013 15:53:03 +0100
Message-Id: <1357224789-2853-4-git-send-email-jslaby@suse.cz>
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

tty_insert_flip_char is the next one to proceed. This one is used all
over the code, so the patch is huge.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/alpha/kernel/srmcons.c                 |  3 ++-
 arch/ia64/hp/sim/simserial.c                |  3 ++-
 arch/mn10300/kernel/mn10300-serial.c        |  4 +--
 arch/parisc/kernel/pdc_cons.c               |  2 +-
 arch/um/drivers/chan_kern.c                 |  8 +-----
 arch/xtensa/platforms/iss/console.c         |  3 ++-
 drivers/char/pcmcia/synclink_cs.c           |  2 +-
 drivers/ipack/devices/ipoctal.c             |  5 ++--
 drivers/isdn/i4l/isdn_common.c              |  8 +++---
 drivers/isdn/i4l/isdn_tty.c                 | 12 ++++-----
 drivers/mmc/card/sdio_uart.c                |  5 ++--
 drivers/s390/char/con3215.c                 |  3 ++-
 drivers/s390/char/keyboard.h                |  4 +--
 drivers/s390/char/sclp_tty.c                |  4 +--
 drivers/staging/dgrp/dgrp_net_ops.c         |  2 +-
 drivers/staging/fwserial/fwserial.c         |  2 +-
 drivers/staging/serqt_usb2/serqt_usb2.c     | 13 +++++----
 drivers/tty/amiserial.c                     |  4 +--
 drivers/tty/cyclades.c                      | 24 ++++++++---------
 drivers/tty/hvc/hvc_console.c               |  2 +-
 drivers/tty/hvc/hvsi.c                      | 22 +++++++--------
 drivers/tty/isicom.c                        |  4 +--
 drivers/tty/moxa.c                          |  2 +-
 drivers/tty/mxser.c                         |  4 +--
 drivers/tty/n_gsm.c                         | 24 ++++++++++-------
 drivers/tty/nozomi.c                        |  2 +-
 drivers/tty/rocket.c                        |  3 ++-
 drivers/tty/serial/68328serial.c            |  2 +-
 drivers/tty/serial/ar933x_uart.c            | 10 +++----
 drivers/tty/serial/bcm63xx_uart.c           |  7 ++---
 drivers/tty/serial/bfin_sport_uart.c        | 10 ++++---
 drivers/tty/serial/cpm_uart/cpm_uart_core.c |  2 +-
 drivers/tty/serial/crisv10.c                | 10 +++----
 drivers/tty/serial/efm32-uart.c             | 15 +++++------
 drivers/tty/serial/icom.c                   |  7 ++---
 drivers/tty/serial/imx.c                    |  5 ++--
 drivers/tty/serial/jsm/jsm_tty.c            |  8 +++---
 drivers/tty/serial/kgdb_nmi.c               |  2 +-
 drivers/tty/serial/lantiq.c                 |  7 ++---
 drivers/tty/serial/lpc32xx_hs.c             | 12 +++++----
 drivers/tty/serial/m32r_sio.c               |  7 ++---
 drivers/tty/serial/mpc52xx_uart.c           |  7 ++---
 drivers/tty/serial/mpsc.c                   |  4 +--
 drivers/tty/serial/msm_serial.c             | 12 +++++----
 drivers/tty/serial/msm_serial_hs.c          | 12 ++++-----
 drivers/tty/serial/mux.c                    |  5 ++--
 drivers/tty/serial/nwpserial.c              |  5 ++--
 drivers/tty/serial/pmac_zilog.c             |  8 +++---
 drivers/tty/serial/sc26xx.c                 | 10 ++++---
 drivers/tty/serial/serial_core.c            |  6 ++---
 drivers/tty/serial/sh-sci.c                 | 34 ++++++++++++-----------
 drivers/tty/serial/sn_console.c             |  6 +++--
 drivers/tty/serial/sunhv.c                  |  4 +--
 drivers/tty/serial/sunsab.c                 | 16 +++++------
 drivers/tty/serial/sunsu.c                  |  7 ++---
 drivers/tty/serial/sunzilog.c               | 17 +++++-------
 drivers/tty/serial/timbuart.c               |  4 +--
 drivers/tty/serial/uartlite.c               |  8 +++---
 drivers/tty/serial/ucc_uart.c               |  4 +--
 drivers/tty/serial/vt8500_serial.c          |  7 ++---
 drivers/tty/synclink.c                      |  4 +--
 drivers/tty/synclink_gt.c                   |  8 +++---
 drivers/tty/synclinkmp.c                    | 42 +++++++++++++----------------
 drivers/tty/vt/keyboard.c                   |  6 ++---
 drivers/tty/vt/vt.c                         |  2 +-
 drivers/usb/serial/ark3116.c                |  2 +-
 drivers/usb/serial/belkin_sa.c              |  2 +-
 drivers/usb/serial/digi_acceleport.c        |  2 +-
 drivers/usb/serial/f81232.c                 |  5 ++--
 drivers/usb/serial/ftdi_sio.c               | 11 ++++----
 drivers/usb/serial/generic.c                |  2 +-
 drivers/usb/serial/keyspan.c                | 21 ++++++++-------
 drivers/usb/serial/pl2303.c                 |  5 ++--
 drivers/usb/serial/spcp8x5.c                |  2 +-
 drivers/usb/serial/ssu100.c                 | 10 +++----
 include/linux/tty_flip.h                    |  6 ++---
 76 files changed, 297 insertions(+), 287 deletions(-)

diff --git a/arch/alpha/kernel/srmcons.c b/arch/alpha/kernel/srmcons.c
index 59b7bba..21b57a6 100644
--- a/arch/alpha/kernel/srmcons.c
+++ b/arch/alpha/kernel/srmcons.c
@@ -46,13 +46,14 @@ typedef union _srmcons_result {
 static int
 srmcons_do_receive_chars(struct tty_struct *tty)
 {
+	struct tty_port *port = tty->port;
 	srmcons_result result;
 	int count = 0, loops = 0;
 
 	do {
 		result.as_long = callback_getc(0);
 		if (result.bits.status < 2) {
-			tty_insert_flip_char(tty, (char)result.bits.c, 0);
+			tty_insert_flip_char(port, (char)result.bits.c, 0);
 			count++;
 		}
 	} while((result.bits.status & 1) && (++loops < 10));
diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index fc3924d..f8ae5d8 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -55,6 +55,7 @@ static struct console *console;
 
 static void receive_chars(struct tty_struct *tty)
 {
+	struct tty_port *port = tty->port;
 	unsigned char ch;
 	static unsigned char seen_esc = 0;
 
@@ -81,7 +82,7 @@ static void receive_chars(struct tty_struct *tty)
 		}
 		seen_esc = 0;
 
-		if (tty_insert_flip_char(tty, ch, TTY_NORMAL) == 0)
+		if (tty_insert_flip_char(port, ch, TTY_NORMAL) == 0)
 			break;
 	}
 	tty_flip_buffer_push(tty);
diff --git a/arch/mn10300/kernel/mn10300-serial.c b/arch/mn10300/kernel/mn10300-serial.c
index 9b2232a..54ef40c 100644
--- a/arch/mn10300/kernel/mn10300-serial.c
+++ b/arch/mn10300/kernel/mn10300-serial.c
@@ -667,14 +667,14 @@ insert:
 		else
 			flag = TTY_NORMAL;
 
-		tty_insert_flip_char(tty, ch, flag);
+		tty_insert_flip_char(port, ch, flag);
 	}
 
 	/* overrun is special, since it's reported immediately, and doesn't
 	 * affect the current character
 	 */
 	if (overrun)
-		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+		tty_insert_flip_char(port, 0, TTY_OVERRUN);
 
 	count--;
 	if (count <= 0) {
diff --git a/arch/parisc/kernel/pdc_cons.c b/arch/parisc/kernel/pdc_cons.c
index efc5e7d..4d92a37 100644
--- a/arch/parisc/kernel/pdc_cons.c
+++ b/arch/parisc/kernel/pdc_cons.c
@@ -147,7 +147,7 @@ static void pdc_console_poll(unsigned long unused)
 		data = pdc_console_poll_key(NULL);
 		if (data == -1)
 			break;
-		tty_insert_flip_char(tty, data & 0xFF, TTY_NORMAL);
+		tty_insert_flip_char(&tty_port, data & 0xFF, TTY_NORMAL);
 		count ++;
 	}
 
diff --git a/arch/um/drivers/chan_kern.c b/arch/um/drivers/chan_kern.c
index 4ff2503..795bd81 100644
--- a/arch/um/drivers/chan_kern.c
+++ b/arch/um/drivers/chan_kern.c
@@ -81,12 +81,6 @@ static const struct chan_ops not_configged_ops = {
 };
 #endif /* CONFIG_NOCONFIG_CHAN */
 
-static void tty_receive_char(struct tty_struct *tty, char ch)
-{
-	if (tty)
-		tty_insert_flip_char(tty, ch, TTY_NORMAL);
-}
-
 static int open_one_chan(struct chan *chan)
 {
 	int fd, err;
@@ -569,7 +563,7 @@ void chan_interrupt(struct line *line, struct tty_struct *tty, int irq)
 		}
 		err = chan->ops->read(chan->fd, &c, chan->data);
 		if (err > 0)
-			tty_receive_char(tty, c);
+			tty_insert_flip_char(port, c, TTY_NORMAL);
 	} while (err > 0);
 
 	if (err == 0)
diff --git a/arch/xtensa/platforms/iss/console.c b/arch/xtensa/platforms/iss/console.c
index 8207a11..62447d6 100644
--- a/arch/xtensa/platforms/iss/console.c
+++ b/arch/xtensa/platforms/iss/console.c
@@ -98,6 +98,7 @@ static int rs_write(struct tty_struct * tty,
 static void rs_poll(unsigned long priv)
 {
 	struct tty_struct* tty = (struct tty_struct*) priv;
+	struct tty_port *port = tty->port;
 
 	struct timeval tv = { .tv_sec = 0, .tv_usec = 0 };
 	int i = 0;
@@ -107,7 +108,7 @@ static void rs_poll(unsigned long priv)
 
 	while (__simc(SYS_select_one, 0, XTISS_SELECT_ONE_READ, (int)&tv,0,0)){
 		__simc (SYS_read, 0, (unsigned long)&c, 1, 0, 0);
-		tty_insert_flip_char(tty, c, TTY_NORMAL);
+		tty_insert_flip_char(port, c, TTY_NORMAL);
 		i++;
 	}
 
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 7a4370c..f125f35 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -945,7 +945,7 @@ static void rx_ready_async(MGSLPC_INFO *info, int tcd, struct tty_struct *tty)
 			else if (status & BIT6)
 				flag = TTY_FRAME;
 		}
-		work += tty_insert_flip_char(tty, data, flag);
+		work += tty_insert_flip_char(port, data, flag);
 	}
 	issue_command(info, CHA, CMD_RXFIFO);
 
diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 576d53d..8e0ed66 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -136,6 +136,7 @@ static int ipoctal_get_icount(struct tty_struct *tty,
 static void ipoctal_irq_rx(struct ipoctal_channel *channel,
 			   struct tty_struct *tty, u8 sr)
 {
+	struct tty_port *port = &channel->tty_port;
 	unsigned char value;
 	unsigned char flag = TTY_NORMAL;
 	u8 isr;
@@ -149,7 +150,7 @@ static void ipoctal_irq_rx(struct ipoctal_channel *channel,
 			if (sr & SR_OVERRUN_ERROR) {
 				channel->stats.overrun_err++;
 				/* Overrun doesn't affect the current character*/
-				tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+				tty_insert_flip_char(port, 0, TTY_OVERRUN);
 			}
 			if (sr & SR_PARITY_ERROR) {
 				channel->stats.parity_err++;
@@ -165,7 +166,7 @@ static void ipoctal_irq_rx(struct ipoctal_channel *channel,
 				flag = TTY_BREAK;
 			}
 		}
-		tty_insert_flip_char(tty, value, flag);
+		tty_insert_flip_char(port, value, flag);
 
 		/* Check if there are more characters in RX FIFO
 		 * If there are more, the isr register for this channel
diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index 7093169..4a387ec 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -913,7 +913,7 @@ isdn_readbchan_tty(int di, int channel, struct tty_struct *tty, int cisco_hack)
 			while ((count_pull < skb->len) && (len > 0)) {
 				/* push every character but the last to the tty buffer directly */
 				if (count_put)
-					tty_insert_flip_char(tty, last, TTY_NORMAL);
+					tty_insert_flip_char(port, last, TTY_NORMAL);
 				len--;
 				if (dev->drv[di]->DLEflag & DLEmask) {
 					last = DLE;
@@ -953,16 +953,16 @@ isdn_readbchan_tty(int di, int channel, struct tty_struct *tty, int cisco_hack)
 			 * Now we can dequeue it.
 			 */
 			if (cisco_hack)
-				tty_insert_flip_char(tty, last, 0xFF);
+				tty_insert_flip_char(port, last, 0xFF);
 			else
-				tty_insert_flip_char(tty, last, TTY_NORMAL);
+				tty_insert_flip_char(port, last, TTY_NORMAL);
 #ifdef CONFIG_ISDN_AUDIO
 			ISDN_AUDIO_SKB_LOCK(skb) = 0;
 #endif
 			skb = skb_dequeue(&dev->drv[di]->rpqueue[channel]);
 			dev_kfree_skb(skb);
 		} else {
-			tty_insert_flip_char(tty, last, TTY_NORMAL);
+			tty_insert_flip_char(port, last, TTY_NORMAL);
 			/* Not yet emptied this buff, so it
 			 * must stay in the queue, for further calls
 			 * but we pull off the data we got until now.
diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index 4f5bcee..32d65d4 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -92,11 +92,11 @@ isdn_tty_try_read(modem_info *info, struct sk_buff *skb)
 		unsigned char *dp = skb->data;
 		while (--l) {
 			if (*dp == DLE)
-				tty_insert_flip_char(tty, DLE, 0);
-			tty_insert_flip_char(tty, *dp++, 0);
+				tty_insert_flip_char(port, DLE, 0);
+			tty_insert_flip_char(port, *dp++, 0);
 		}
 		if (*dp == DLE)
-			tty_insert_flip_char(tty, DLE, 0);
+			tty_insert_flip_char(port, DLE, 0);
 		last = *dp;
 	} else {
 #endif
@@ -107,9 +107,9 @@ isdn_tty_try_read(modem_info *info, struct sk_buff *skb)
 	}
 #endif
 	if (info->emu.mdmreg[REG_CPPP] & BIT_CPPP)
-		tty_insert_flip_char(tty, last, 0xFF);
+		tty_insert_flip_char(port, last, 0xFF);
 	else
-		tty_insert_flip_char(tty, last, TTY_NORMAL);
+		tty_insert_flip_char(port, last, TTY_NORMAL);
 	tty_flip_buffer_push(tty);
 	kfree_skb(skb);
 
@@ -2287,7 +2287,7 @@ isdn_tty_at_cout(char *msg, modem_info *info)
 		if (skb) {
 			*sp++ = c;
 		} else {
-			if (tty_insert_flip_char(tty, c, TTY_NORMAL) == 0)
+			if (tty_insert_flip_char(port, c, TTY_NORMAL) == 0)
 				break;
 		}
 	}
diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index bd57a11..894078b 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -419,7 +419,7 @@ static void sdio_uart_receive_chars(struct sdio_uart_port *port,
 
 		if ((*status & port->ignore_status_mask & ~UART_LSR_OE) == 0)
 			if (tty)
-				tty_insert_flip_char(tty, ch, flag);
+				tty_insert_flip_char(&port->port, ch, flag);
 
 		/*
 		 * Overrun is special.  Since it's reported immediately,
@@ -427,7 +427,8 @@ static void sdio_uart_receive_chars(struct sdio_uart_port *port,
 		 */
 		if (*status & ~port->ignore_status_mask & UART_LSR_OE)
 			if (tty)
-				tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+				tty_insert_flip_char(&port->port, 0,
+						TTY_OVERRUN);
 
 		*status = sdio_in(port, UART_LSR);
 	} while ((*status & UART_LSR_DR) && (max_count-- > 0));
diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 4008450..7c72945 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -411,7 +411,8 @@ static void raw3215_irq(struct ccw_device *cdev, unsigned long intparm,
 				break;
 
 			case CTRLCHAR_CTRL:
-				tty_insert_flip_char(tty, cchar, TTY_NORMAL);
+				tty_insert_flip_char(&raw->port, cchar,
+						TTY_NORMAL);
 				tty_flip_buffer_push(tty);
 				break;
 
diff --git a/drivers/s390/char/keyboard.h b/drivers/s390/char/keyboard.h
index d0ae2be..acab28d 100644
--- a/drivers/s390/char/keyboard.h
+++ b/drivers/s390/char/keyboard.h
@@ -46,7 +46,7 @@ kbd_put_queue(struct tty_port *port, int ch)
 	struct tty_struct *tty = tty_port_tty_get(port);
 	if (!tty)
 		return;
-	tty_insert_flip_char(tty, ch, 0);
+	tty_insert_flip_char(port, ch, 0);
 	tty_schedule_flip(tty);
 	tty_kref_put(tty);
 }
@@ -58,7 +58,7 @@ kbd_puts_queue(struct tty_port *port, char *cp)
 	if (!tty)
 		return;
 	while (*cp)
-		tty_insert_flip_char(tty, *cp++, 0);
+		tty_insert_flip_char(port, *cp++, 0);
 	tty_schedule_flip(tty);
 	tty_kref_put(tty);
 }
diff --git a/drivers/s390/char/sclp_tty.c b/drivers/s390/char/sclp_tty.c
index 877fbc3..c03863a 100644
--- a/drivers/s390/char/sclp_tty.c
+++ b/drivers/s390/char/sclp_tty.c
@@ -342,7 +342,7 @@ sclp_tty_input(unsigned char* buf, unsigned int count)
 	case CTRLCHAR_SYSRQ:
 		break;
 	case CTRLCHAR_CTRL:
-		tty_insert_flip_char(tty, cchar, TTY_NORMAL);
+		tty_insert_flip_char(&sclp_port, cchar, TTY_NORMAL);
 		tty_flip_buffer_push(tty);
 		break;
 	case CTRLCHAR_NONE:
@@ -352,7 +352,7 @@ sclp_tty_input(unsigned char* buf, unsigned int count)
 		     strncmp((const char *) buf + count - 2, "\252n", 2))) {
 			/* add the auto \n */
 			tty_insert_flip_string(tty, buf, count);
-			tty_insert_flip_char(tty, '\n', TTY_NORMAL);
+			tty_insert_flip_char(&sclp_port, '\n', TTY_NORMAL);
 		} else
 			tty_insert_flip_string(tty, buf, count - 2);
 		tty_flip_buffer_push(tty);
diff --git a/drivers/staging/dgrp/dgrp_net_ops.c b/drivers/staging/dgrp/dgrp_net_ops.c
index df3ebcd..e618a66 100644
--- a/drivers/staging/dgrp/dgrp_net_ops.c
+++ b/drivers/staging/dgrp/dgrp_net_ops.c
@@ -2957,7 +2957,7 @@ check_query:
 			    !(I_IGNBRK(ch->ch_tun.un_tty))) {
 
 				tty_buffer_request_room(&ch->port, 1);
-				tty_insert_flip_char(ch->ch_tun.un_tty, 0, TTY_BREAK);
+				tty_insert_flip_char(&ch->port, 0, TTY_BREAK);
 				tty_flip_buffer_push(ch->ch_tun.un_tty);
 
 			}
diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index 85dbdc1..a2a0c43 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -617,7 +617,7 @@ static int fwtty_rx(struct fwtty_port *port, unsigned char *data, size_t len)
 
 	lsr &= port->status_mask;
 	if (lsr & ~port->ignore_mask & UART_LSR_OE) {
-		if (!tty_insert_flip_char(tty, 0, TTY_OVERRUN)) {
+		if (!tty_insert_flip_char(&port->port, 0, TTY_OVERRUN)) {
 			err = -EIO;
 			goto out;
 		}
diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 1b3e995..1496566 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -255,12 +255,11 @@ static void ProcessModemStatus(struct quatech_port *qt_port,
 	wake_up_interruptible(&qt_port->wait);
 }
 
-static void ProcessRxChar(struct tty_struct *tty, struct usb_serial_port *port,
-						unsigned char data)
+static void ProcessRxChar(struct usb_serial_port *port, unsigned char data)
 {
 	struct urb *urb = port->read_urb;
 	if (urb->actual_length)
-		tty_insert_flip_char(tty, data, TTY_NORMAL);
+		tty_insert_flip_char(&port->port, data, TTY_NORMAL);
 }
 
 static void qt_write_bulk_callback(struct urb *urb)
@@ -335,8 +334,8 @@ static void qt_status_change_check(struct tty_struct *tty,
 			case 0xff:
 				dev_dbg(&port->dev, "No status sequence.\n");
 
-				ProcessRxChar(tty, port, data[i]);
-				ProcessRxChar(tty, port, data[i + 1]);
+				ProcessRxChar(port, data[i]);
+				ProcessRxChar(port, data[i + 1]);
 
 				i += 2;
 				break;
@@ -345,8 +344,8 @@ static void qt_status_change_check(struct tty_struct *tty,
 				continue;
 		}
 
-		if (tty && urb->actual_length)
-			tty_insert_flip_char(tty, data[i], TTY_NORMAL);
+		if (urb->actual_length)
+			tty_insert_flip_char(&port->port, data[i], TTY_NORMAL);
 
 	}
 	tty_flip_buffer_push(tty);
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 9d7d00c..2e670d0 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -328,9 +328,9 @@ static void receive_chars(struct serial_state *info)
 	     oe = 1;
 	  }
 	}
-	tty_insert_flip_char(tty, ch, flag);
+	tty_insert_flip_char(&info->tport, ch, flag);
 	if (oe == 1)
-		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+		tty_insert_flip_char(&info->tport, 0, TTY_OVERRUN);
 	tty_flip_buffer_push(tty);
 out:
 	return;
diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index 0b7573d..d1fe9a1 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -492,34 +492,34 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 		if (tty_buffer_request_room(port, 1)) {
 			if (data & info->read_status_mask) {
 				if (data & CyBREAK) {
-					tty_insert_flip_char(tty,
+					tty_insert_flip_char(port,
 						cyy_readb(info, CyRDSR),
 						TTY_BREAK);
 					info->icount.rx++;
 					if (port->flags & ASYNC_SAK)
 						do_SAK(tty);
 				} else if (data & CyFRAME) {
-					tty_insert_flip_char(tty,
+					tty_insert_flip_char(port,
 						cyy_readb(info, CyRDSR),
 						TTY_FRAME);
 					info->icount.rx++;
 					info->idle_stats.frame_errs++;
 				} else if (data & CyPARITY) {
 					/* Pieces of seven... */
-					tty_insert_flip_char(tty,
+					tty_insert_flip_char(port,
 						cyy_readb(info, CyRDSR),
 						TTY_PARITY);
 					info->icount.rx++;
 					info->idle_stats.parity_errs++;
 				} else if (data & CyOVERRUN) {
-					tty_insert_flip_char(tty, 0,
+					tty_insert_flip_char(port, 0,
 							TTY_OVERRUN);
 					info->icount.rx++;
 					/* If the flip buffer itself is
 					   overflowing, we still lose
 					   the next incoming character.
 					 */
-					tty_insert_flip_char(tty,
+					tty_insert_flip_char(port,
 						cyy_readb(info, CyRDSR),
 						TTY_FRAME);
 					info->icount.rx++;
@@ -529,12 +529,12 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 				/* } else if(data & CyTIMEOUT) { */
 				/* } else if(data & CySPECHAR) { */
 				} else {
-					tty_insert_flip_char(tty, 0,
+					tty_insert_flip_char(port, 0,
 							TTY_NORMAL);
 					info->icount.rx++;
 				}
 			} else {
-				tty_insert_flip_char(tty, 0, TTY_NORMAL);
+				tty_insert_flip_char(port, 0, TTY_NORMAL);
 				info->icount.rx++;
 			}
 		} else {
@@ -557,7 +557,7 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 		len = tty_buffer_request_room(port, char_count);
 		while (len--) {
 			data = cyy_readb(info, CyRDSR);
-			tty_insert_flip_char(tty, data, TTY_NORMAL);
+			tty_insert_flip_char(port, data, TTY_NORMAL);
 			info->idle_stats.recv_bytes++;
 			info->icount.rx++;
 #ifdef CY_16Y_HACK
@@ -992,7 +992,7 @@ static void cyz_handle_rx(struct cyclades_port *info, struct tty_struct *tty)
 						new_rx_get);
 				new_rx_get = (new_rx_get + 1) &
 							(rx_bufsize - 1);
-				tty_insert_flip_char(tty, data, TTY_NORMAL);
+				tty_insert_flip_char(port, data, TTY_NORMAL);
 				info->idle_stats.recv_bytes++;
 				info->icount.rx++;
 			}
@@ -1117,17 +1117,17 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
 
 		switch (cmd) {
 		case C_CM_PR_ERROR:
-			tty_insert_flip_char(tty, 0, TTY_PARITY);
+			tty_insert_flip_char(&info->port, 0, TTY_PARITY);
 			info->icount.rx++;
 			special_count++;
 			break;
 		case C_CM_FR_ERROR:
-			tty_insert_flip_char(tty, 0, TTY_FRAME);
+			tty_insert_flip_char(&info->port, 0, TTY_FRAME);
 			info->icount.rx++;
 			special_count++;
 			break;
 		case C_CM_RXBRK:
-			tty_insert_flip_char(tty, 0, TTY_BREAK);
+			tty_insert_flip_char(&info->port, 0, TTY_BREAK);
 			info->icount.rx++;
 			special_count++;
 			break;
diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index 3d2ea92..8c2fe3a 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -672,7 +672,7 @@ int hvc_poll(struct hvc_struct *hp)
 				}
 			}
 #endif /* CONFIG_MAGIC_SYSRQ */
-			tty_insert_flip_char(tty, buf[i], 0);
+			tty_insert_flip_char(&hp->port, buf[i], 0);
 		}
 
 		read_total += n;
diff --git a/drivers/tty/hvc/hvsi.c b/drivers/tty/hvc/hvsi.c
index 68357a6..1f528b8 100644
--- a/drivers/tty/hvc/hvsi.c
+++ b/drivers/tty/hvc/hvsi.c
@@ -329,8 +329,7 @@ static void hvsi_recv_query(struct hvsi_struct *hp, uint8_t *packet)
 	}
 }
 
-static void hvsi_insert_chars(struct hvsi_struct *hp, struct tty_struct *tty,
-		const char *buf, int len)
+static void hvsi_insert_chars(struct hvsi_struct *hp, const char *buf, int len)
 {
 	int i;
 
@@ -346,7 +345,7 @@ static void hvsi_insert_chars(struct hvsi_struct *hp, struct tty_struct *tty,
 			continue;
 		}
 #endif /* CONFIG_MAGIC_SYSRQ */
-		tty_insert_flip_char(tty, c, 0);
+		tty_insert_flip_char(&hp->port, c, 0);
 	}
 }
 
@@ -359,8 +358,7 @@ static void hvsi_insert_chars(struct hvsi_struct *hp, struct tty_struct *tty,
  * revisited.
  */
 #define TTY_THRESHOLD_THROTTLE 128
-static bool hvsi_recv_data(struct hvsi_struct *hp, struct tty_struct *tty,
-		const uint8_t *packet)
+static bool hvsi_recv_data(struct hvsi_struct *hp, const uint8_t *packet)
 {
 	const struct hvsi_header *header = (const struct hvsi_header *)packet;
 	const uint8_t *data = packet + sizeof(struct hvsi_header);
@@ -377,7 +375,7 @@ static bool hvsi_recv_data(struct hvsi_struct *hp, struct tty_struct *tty,
 		datalen = TTY_THRESHOLD_THROTTLE;
 	}
 
-	hvsi_insert_chars(hp, tty, data, datalen);
+	hvsi_insert_chars(hp, data, datalen);
 
 	if (overflow > 0) {
 		/*
@@ -438,9 +436,7 @@ static int hvsi_load_chunk(struct hvsi_struct *hp, struct tty_struct *tty,
 			case VS_DATA_PACKET_HEADER:
 				if (!is_open(hp))
 					break;
-				if (tty == NULL)
-					break; /* no tty buffer to put data in */
-				flip = hvsi_recv_data(hp, tty, packet);
+				flip = hvsi_recv_data(hp, packet);
 				break;
 			case VS_CONTROL_PACKET_HEADER:
 				hvsi_recv_control(hp, packet, tty, handshake);
@@ -474,12 +470,12 @@ static int hvsi_load_chunk(struct hvsi_struct *hp, struct tty_struct *tty,
 	return 1;
 }
 
-static void hvsi_send_overflow(struct hvsi_struct *hp, struct tty_struct *tty)
+static void hvsi_send_overflow(struct hvsi_struct *hp)
 {
 	pr_debug("%s: delivering %i bytes overflow\n", __func__,
 			hp->n_throttle);
 
-	hvsi_insert_chars(hp, tty, hp->throttle_buf, hp->n_throttle);
+	hvsi_insert_chars(hp, hp->throttle_buf, hp->n_throttle);
 	hp->n_throttle = 0;
 }
 
@@ -514,7 +510,7 @@ static irqreturn_t hvsi_interrupt(int irq, void *arg)
 	if (tty && hp->n_throttle && !test_bit(TTY_THROTTLED, &tty->flags)) {
 		/* we weren't hung up and we weren't throttled, so we can
 		 * deliver the rest now */
-		hvsi_send_overflow(hp, tty);
+		hvsi_send_overflow(hp);
 		tty_flip_buffer_push(tty);
 	}
 	spin_unlock_irqrestore(&hp->lock, flags);
@@ -1001,7 +997,7 @@ static void hvsi_unthrottle(struct tty_struct *tty)
 
 	spin_lock_irqsave(&hp->lock, flags);
 	if (hp->n_throttle) {
-		hvsi_send_overflow(hp, tty);
+		hvsi_send_overflow(hp);
 		tty_flip_buffer_push(tty);
 	}
 	spin_unlock_irqrestore(&hp->lock, flags);
diff --git a/drivers/tty/isicom.c b/drivers/tty/isicom.c
index e9fc15f..c70144f 100644
--- a/drivers/tty/isicom.c
+++ b/drivers/tty/isicom.c
@@ -634,7 +634,7 @@ static irqreturn_t isicom_interrupt(int irq, void *dev_id)
 			break;
 
 		case 1:	/* Received Break !!! */
-			tty_insert_flip_char(tty, 0, TTY_BREAK);
+			tty_insert_flip_char(&port->port, 0, TTY_BREAK);
 			if (port->port.flags & ASYNC_SAK)
 				do_SAK(tty);
 			tty_flip_buffer_push(tty);
@@ -658,7 +658,7 @@ static irqreturn_t isicom_interrupt(int irq, void *dev_id)
 		insw(base, rp, word_count);
 		byte_count -= (word_count << 1);
 		if (count & 0x0001) {
-			tty_insert_flip_char(tty,  inw(base) & 0xff,
+			tty_insert_flip_char(&port->port, inw(base) & 0xff,
 				TTY_NORMAL);
 			byte_count -= 2;
 		}
diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index fcaac48..f42492d 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -1429,7 +1429,7 @@ static int moxa_poll_port(struct moxa_port *p, unsigned int handle,
 		goto put;
 
 	if (tty && (intr & IntrBreak) && !I_IGNBRK(tty)) { /* BREAK */
-		tty_insert_flip_char(tty, 0, TTY_BREAK);
+		tty_insert_flip_char(&p->port, 0, TTY_BREAK);
 		tty_schedule_flip(tty);
 	}
 
diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 4011386..450c450 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -2079,7 +2079,7 @@ static void mxser_receive_chars(struct tty_struct *tty,
 		}
 		while (gdl--) {
 			ch = inb(port->ioaddr + UART_RX);
-			tty_insert_flip_char(tty, ch, 0);
+			tty_insert_flip_char(&port->port, ch, 0);
 			cnt++;
 		}
 		goto end_intr;
@@ -2118,7 +2118,7 @@ intr_old:
 				} else
 					flag = TTY_BREAK;
 			}
-			tty_insert_flip_char(tty, ch, flag);
+			tty_insert_flip_char(&port->port, ch, flag);
 			cnt++;
 			if (cnt >= recv_room) {
 				if (!port->ldisc_stop_rx)
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index dcc0430..e1e7459 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1067,9 +1067,9 @@ static void gsm_process_modem(struct tty_struct *tty, struct gsm_dlci *dlci,
 		if ((mlines & TIOCM_CD) == 0 && (dlci->modem_rx & TIOCM_CD))
 			if (!(tty->termios.c_cflag & CLOCAL))
 				tty_hangup(tty);
-		if (brk & 0x01)
-			tty_insert_flip_char(tty, 0, TTY_BREAK);
 	}
+	if (brk & 0x01)
+		tty_insert_flip_char(&dlci->port, 0, TTY_BREAK);
 	dlci->modem_rx = mlines;
 }
 
@@ -1137,6 +1137,7 @@ static void gsm_control_modem(struct gsm_mux *gsm, u8 *data, int clen)
 
 static void gsm_control_rls(struct gsm_mux *gsm, u8 *data, int clen)
 {
+	struct tty_port *port;
 	struct tty_struct *tty;
 	unsigned int addr = 0 ;
 	u8 bits;
@@ -1160,16 +1161,19 @@ static void gsm_control_rls(struct gsm_mux *gsm, u8 *data, int clen)
 	bits = *dp;
 	if ((bits & 1) == 0)
 		return;
-	/* See if we have an uplink tty */
-	tty = tty_port_tty_get(&gsm->dlci[addr]->port);
 
+	port = &gsm->dlci[addr]->port;
+
+	if (bits & 2)
+		tty_insert_flip_char(port, 0, TTY_OVERRUN);
+	if (bits & 4)
+		tty_insert_flip_char(port, 0, TTY_PARITY);
+	if (bits & 8)
+		tty_insert_flip_char(port, 0, TTY_FRAME);
+
+	/* See if we have an uplink tty */
+	tty = tty_port_tty_get(port);
 	if (tty) {
-		if (bits & 2)
-			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
-		if (bits & 4)
-			tty_insert_flip_char(tty, 0, TTY_PARITY);
-		if (bits & 8)
-			tty_insert_flip_char(tty, 0, TTY_FRAME);
 		tty_flip_buffer_push(tty);
 		tty_kref_put(tty);
 	}
diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index a0c69ab..437a6366 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -855,7 +855,7 @@ static int receive_data(enum port_type index, struct nozomi *dc)
 		read_mem32((u32 *) buf, addr + offset, RECEIVE_BUF_MAX);
 
 		if (size == 1) {
-			tty_insert_flip_char(tty, buf[0], TTY_NORMAL);
+			tty_insert_flip_char(&port->port, buf[0], TTY_NORMAL);
 			size = 0;
 		} else if (size < RECEIVE_BUF_MAX) {
 			size -= tty_insert_flip_string(tty, (char *) buf, size);
diff --git a/drivers/tty/rocket.c b/drivers/tty/rocket.c
index 77d7bc9..5848a76 100644
--- a/drivers/tty/rocket.c
+++ b/drivers/tty/rocket.c
@@ -379,7 +379,8 @@ static void rp_do_receive(struct r_port *info,
 				flag = TTY_OVERRUN;
 			else
 				flag = TTY_NORMAL;
-			tty_insert_flip_char(tty, CharNStat & 0xff, flag);
+			tty_insert_flip_char(&info->port, CharNStat & 0xff,
+					flag);
 			ToRecv--;
 		}
 
diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
index f99a845..3719273 100644
--- a/drivers/tty/serial/68328serial.c
+++ b/drivers/tty/serial/68328serial.c
@@ -305,7 +305,7 @@ static void receive_chars(struct m68k_serial *info, struct tty_struct *tty,
 		else if (rx & URX_FRAME_ERROR)
 			flag = TTY_FRAME;
 
-		tty_insert_flip_char(tty, ch, flag);
+		tty_insert_flip_char(&info->tport, ch, flag);
 #ifndef CONFIG_XCOPILOT_BUGS
 	} while((rx = uart->urx.w) & URX_DATA_READY);
 #endif
diff --git a/drivers/tty/serial/ar933x_uart.c b/drivers/tty/serial/ar933x_uart.c
index 505c490..6ca5dd6 100644
--- a/drivers/tty/serial/ar933x_uart.c
+++ b/drivers/tty/serial/ar933x_uart.c
@@ -297,10 +297,11 @@ static void ar933x_uart_set_termios(struct uart_port *port,
 
 static void ar933x_uart_rx_chars(struct ar933x_uart_port *up)
 {
+	struct tty_port *port = &up->port.state->port;
 	struct tty_struct *tty;
 	int max_count = 256;
 
-	tty = tty_port_tty_get(&up->port.state->port);
+	tty = tty_port_tty_get(port);
 	do {
 		unsigned int rdata;
 		unsigned char ch;
@@ -313,11 +314,6 @@ static void ar933x_uart_rx_chars(struct ar933x_uart_port *up)
 		ar933x_uart_write(up, AR933X_UART_DATA_REG,
 				  AR933X_UART_DATA_RX_CSR);
 
-		if (!tty) {
-			/* discard the data if no tty available */
-			continue;
-		}
-
 		up->port.icount.rx++;
 		ch = rdata & AR933X_UART_DATA_TX_RX_MASK;
 
@@ -325,7 +321,7 @@ static void ar933x_uart_rx_chars(struct ar933x_uart_port *up)
 			continue;
 
 		if ((up->port.ignore_status_mask & AR933X_DUMMY_STATUS_RD) == 0)
-			tty_insert_flip_char(tty, ch, TTY_NORMAL);
+			tty_insert_flip_char(port, ch, TTY_NORMAL);
 	} while (max_count-- > 0);
 
 	if (tty) {
diff --git a/drivers/tty/serial/bcm63xx_uart.c b/drivers/tty/serial/bcm63xx_uart.c
index c76a226..de30b19 100644
--- a/drivers/tty/serial/bcm63xx_uart.c
+++ b/drivers/tty/serial/bcm63xx_uart.c
@@ -235,6 +235,7 @@ static const char *bcm_uart_type(struct uart_port *port)
  */
 static void bcm_uart_do_rx(struct uart_port *port)
 {
+	struct tty_port *port = &port->state->port;
 	struct tty_struct *tty;
 	unsigned int max_count;
 
@@ -242,7 +243,7 @@ static void bcm_uart_do_rx(struct uart_port *port)
 	 * higher than fifo size anyway since we're much faster than
 	 * serial port */
 	max_count = 32;
-	tty = port->state->port.tty;
+	tty = port->tty;
 	do {
 		unsigned int iestat, c, cstat;
 		char flag;
@@ -261,7 +262,7 @@ static void bcm_uart_do_rx(struct uart_port *port)
 			bcm_uart_writel(port, val, UART_CTL_REG);
 
 			port->icount.overrun++;
-			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+			tty_insert_flip_char(port, 0, TTY_OVERRUN);
 		}
 
 		if (!(iestat & UART_IR_STAT(UART_IR_RXNOTEMPTY)))
@@ -300,7 +301,7 @@ static void bcm_uart_do_rx(struct uart_port *port)
 
 
 		if ((cstat & port->ignore_status_mask) == 0)
-			tty_insert_flip_char(tty, c, flag);
+			tty_insert_flip_char(port, c, flag);
 
 	} while (--max_count);
 
diff --git a/drivers/tty/serial/bfin_sport_uart.c b/drivers/tty/serial/bfin_sport_uart.c
index f5d1173..e4d3ac2 100644
--- a/drivers/tty/serial/bfin_sport_uart.c
+++ b/drivers/tty/serial/bfin_sport_uart.c
@@ -149,7 +149,8 @@ static int sport_uart_setup(struct sport_uart_port *up, int size, int baud_rate)
 static irqreturn_t sport_uart_rx_irq(int irq, void *dev_id)
 {
 	struct sport_uart_port *up = dev_id;
-	struct tty_struct *tty = up->port.state->port.tty;
+	struct tty_port *port = &up->port.state->port;
+	struct tty_struct *tty = tport->tty;
 	unsigned int ch;
 
 	spin_lock(&up->port.lock);
@@ -159,7 +160,7 @@ static irqreturn_t sport_uart_rx_irq(int irq, void *dev_id)
 		up->port.icount.rx++;
 
 		if (!uart_handle_sysrq_char(&up->port, ch))
-			tty_insert_flip_char(tty, ch, TTY_NORMAL);
+			tty_insert_flip_char(port, ch, TTY_NORMAL);
 	}
 	tty_flip_buffer_push(tty);
 
@@ -182,7 +183,6 @@ static irqreturn_t sport_uart_tx_irq(int irq, void *dev_id)
 static irqreturn_t sport_uart_err_irq(int irq, void *dev_id)
 {
 	struct sport_uart_port *up = dev_id;
-	struct tty_struct *tty = up->port.state->port.tty;
 	unsigned int stat = SPORT_GET_STAT(up);
 
 	spin_lock(&up->port.lock);
@@ -190,7 +190,7 @@ static irqreturn_t sport_uart_err_irq(int irq, void *dev_id)
 	/* Overflow in RX FIFO */
 	if (stat & ROVF) {
 		up->port.icount.overrun++;
-		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+		tty_insert_flip_char(&up->port.state->port, 0, TTY_OVERRUN);
 		SPORT_PUT_STAT(up, ROVF); /* Clear ROVF bit */
 	}
 	/* These should not happen */
@@ -205,6 +205,8 @@ static irqreturn_t sport_uart_err_irq(int irq, void *dev_id)
 	SSYNC();
 
 	spin_unlock(&up->port.lock);
+	/* XXX we don't push the overrun bit to TTY? */
+
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_core.c b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
index 42d5eb0..108122f 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -303,7 +303,7 @@ static void cpm_uart_int_rx(struct uart_port *port)
 			}
 #endif
 		      error_return:
-			tty_insert_flip_char(tty, ch, flg);
+			tty_insert_flip_char(tport, ch, flg);
 
 		}		/* End while (i--) */
 
diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index 35ee6a2..d123066 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -1760,8 +1760,7 @@ add_char_and_flag(struct e100_serial *info, unsigned char data, unsigned char fl
 
 		info->icount.rx++;
 	} else {
-		struct tty_struct *tty = info->port.tty;
-		tty_insert_flip_char(tty, data, flag);
+		tty_insert_flip_char(&info->port, data, flag);
 		info->icount.rx++;
 	}
 
@@ -2338,8 +2337,7 @@ more_data:
 					data_in, data_read);
 				char flag = TTY_NORMAL;
 				if (info->errorcode == ERRCODE_INSERT_BREAK) {
-					struct tty_struct *tty = info->port.tty;
-					tty_insert_flip_char(tty, 0, flag);
+					tty_insert_flip_char(&info->port, 0, flag);
 					info->icount.rx++;
 				}
 
@@ -2353,7 +2351,7 @@ more_data:
 					info->icount.frame++;
 					flag = TTY_FRAME;
 				}
-				tty_insert_flip_char(tty, data, flag);
+				tty_insert_flip_char(&info->port, data, flag);
 				info->errorcode = 0;
 			}
 			info->break_detected_cnt = 0;
@@ -2369,7 +2367,7 @@ more_data:
 			log_int(rdpc(), 0, 0);
 		}
 		);
-		tty_insert_flip_char(tty,
+		tty_insert_flip_char(&info->port,
 			IO_EXTRACT(R_SERIAL0_READ, data_in, data_read),
 			TTY_NORMAL);
 	} else {
diff --git a/drivers/tty/serial/efm32-uart.c b/drivers/tty/serial/efm32-uart.c
index a8cbb26..bdf67b0 100644
--- a/drivers/tty/serial/efm32-uart.c
+++ b/drivers/tty/serial/efm32-uart.c
@@ -194,8 +194,7 @@ static void efm32_uart_break_ctl(struct uart_port *port, int ctl)
 	/* not possible without fiddling with gpios */
 }
 
-static void efm32_uart_rx_chars(struct efm32_uart_port *efm_port,
-		struct tty_struct *tty)
+static void efm32_uart_rx_chars(struct efm32_uart_port *efm_port)
 {
 	struct uart_port *port = &efm_port->port;
 
@@ -237,8 +236,8 @@ static void efm32_uart_rx_chars(struct efm32_uart_port *efm_port,
 					rxdata & UARTn_RXDATAX_RXDATA__MASK))
 			continue;
 
-		if (tty && (rxdata & port->ignore_status_mask) == 0)
-			tty_insert_flip_char(tty,
+		if ((rxdata & port->ignore_status_mask) == 0)
+			tty_insert_flip_char(&port->state->port,
 					rxdata & UARTn_RXDATAX_RXDATA__MASK, flag);
 	}
 }
@@ -249,15 +248,16 @@ static irqreturn_t efm32_uart_rxirq(int irq, void *data)
 	u32 irqflag = efm32_uart_read32(efm_port, UARTn_IF);
 	int handled = IRQ_NONE;
 	struct uart_port *port = &efm_port->port;
+	struct tty_port *tport = &port->state->port;
 	struct tty_struct *tty;
 
 	spin_lock(&port->lock);
 
-	tty = tty_kref_get(port->state->port.tty);
+	tty = tty_kref_get(tport->tty);
 
 	if (irqflag & UARTn_IF_RXDATAV) {
 		efm32_uart_write32(efm_port, UARTn_IF_RXDATAV, UARTn_IFC);
-		efm32_uart_rx_chars(efm_port, tty);
+		efm32_uart_rx_chars(efm_port);
 
 		handled = IRQ_HANDLED;
 	}
@@ -265,8 +265,7 @@ static irqreturn_t efm32_uart_rxirq(int irq, void *data)
 	if (irqflag & UARTn_IF_RXOF) {
 		efm32_uart_write32(efm_port, UARTn_IF_RXOF, UARTn_IFC);
 		port->icount.overrun++;
-		if (tty)
-			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+		tty_insert_flip_char(tport, 0, TTY_OVERRUN);
 
 		handled = IRQ_HANDLED;
 	}
diff --git a/drivers/tty/serial/icom.c b/drivers/tty/serial/icom.c
index 72b6334..2b0b60f 100644
--- a/drivers/tty/serial/icom.c
+++ b/drivers/tty/serial/icom.c
@@ -734,7 +734,8 @@ static void xmit_interrupt(u16 port_int_reg, struct icom_port *icom_port)
 static void recv_interrupt(u16 port_int_reg, struct icom_port *icom_port)
 {
 	short int count, rcv_buff;
-	struct tty_struct *tty = icom_port->uart_port.state->port.tty;
+	struct tty_port *port = &icom_port->uart_port.state->port;
+	struct tty_struct *tty = port->tty;
 	unsigned short int status;
 	struct uart_icount *icount;
 	unsigned long offset;
@@ -812,7 +813,7 @@ static void recv_interrupt(u16 port_int_reg, struct icom_port *icom_port)
 
 		}
 
-		tty_insert_flip_char(tty, *(icom_port->recv_buf + offset + count - 1), flag);
+		tty_insert_flip_char(port, *(icom_port->recv_buf + offset + count - 1), flag);
 
 		if (status & SA_FLAGS_OVERRUN)
 			/*
@@ -820,7 +821,7 @@ static void recv_interrupt(u16 port_int_reg, struct icom_port *icom_port)
 			 * reported immediately, and doesn't
 			 * affect the current character
 			 */
-			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+			tty_insert_flip_char(port, 0, TTY_OVERRUN);
 ignore_char:
 		icom_port->statStg->rcv[rcv_buff].flags = 0;
 		icom_port->statStg->rcv[rcv_buff].leLength = 0;
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 5981912..3a7f0ef 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -517,7 +517,8 @@ static irqreturn_t imx_rxint(int irq, void *dev_id)
 {
 	struct imx_port *sport = dev_id;
 	unsigned int rx,flg,ignored = 0;
-	struct tty_struct *tty = sport->port.state->port.tty;
+	struct tty_port *port = &sport->port.state->port;
+	struct tty_struct *tty = port->tty;
 	unsigned long flags, temp;
 
 	spin_lock_irqsave(&sport->port.lock,flags);
@@ -570,7 +571,7 @@ static irqreturn_t imx_rxint(int irq, void *dev_id)
 #endif
 		}
 
-		tty_insert_flip_char(tty, rx, flg);
+		tty_insert_flip_char(port, rx, flg);
 	}
 
 out:
diff --git a/drivers/tty/serial/jsm/jsm_tty.c b/drivers/tty/serial/jsm/jsm_tty.c
index 3969e54..ac1d36c 100644
--- a/drivers/tty/serial/jsm/jsm_tty.c
+++ b/drivers/tty/serial/jsm/jsm_tty.c
@@ -631,13 +631,13 @@ void jsm_input(struct jsm_channel *ch)
 				 * format it likes.
 				 */
 				if (*(ch->ch_equeue +tail +i) & UART_LSR_BI)
-					tty_insert_flip_char(tp, *(ch->ch_rqueue +tail +i),  TTY_BREAK);
+					tty_insert_flip_char(port, *(ch->ch_rqueue +tail +i),  TTY_BREAK);
 				else if (*(ch->ch_equeue +tail +i) & UART_LSR_PE)
-					tty_insert_flip_char(tp, *(ch->ch_rqueue +tail +i), TTY_PARITY);
+					tty_insert_flip_char(port, *(ch->ch_rqueue +tail +i), TTY_PARITY);
 				else if (*(ch->ch_equeue +tail +i) & UART_LSR_FE)
-					tty_insert_flip_char(tp, *(ch->ch_rqueue +tail +i), TTY_FRAME);
+					tty_insert_flip_char(port, *(ch->ch_rqueue +tail +i), TTY_FRAME);
 				else
-					tty_insert_flip_char(tp, *(ch->ch_rqueue +tail +i), TTY_NORMAL);
+					tty_insert_flip_char(port, *(ch->ch_rqueue +tail +i), TTY_NORMAL);
 			}
 		} else {
 			tty_insert_flip_string(tp, ch->ch_rqueue + tail, s) ;
diff --git a/drivers/tty/serial/kgdb_nmi.c b/drivers/tty/serial/kgdb_nmi.c
index 6ac2b79..ba2ef62 100644
--- a/drivers/tty/serial/kgdb_nmi.c
+++ b/drivers/tty/serial/kgdb_nmi.c
@@ -216,7 +216,7 @@ static void kgdb_nmi_tty_receiver(unsigned long data)
 		return;
 
 	while (kfifo_out(&priv->fifo, &ch, 1))
-		tty_insert_flip_char(priv->port.tty, ch, TTY_NORMAL);
+		tty_insert_flip_char(&priv->port, ch, TTY_NORMAL);
 	tty_flip_buffer_push(priv->port.tty);
 
 	tty_kref_put(tty);
diff --git a/drivers/tty/serial/lantiq.c b/drivers/tty/serial/lantiq.c
index 02da071..1933fe3 100644
--- a/drivers/tty/serial/lantiq.c
+++ b/drivers/tty/serial/lantiq.c
@@ -162,7 +162,8 @@ lqasc_enable_ms(struct uart_port *port)
 static int
 lqasc_rx_chars(struct uart_port *port)
 {
-	struct tty_struct *tty = tty_port_tty_get(&port->state->port);
+	struct tty_port *tport = &port->state->port;
+	struct tty_struct *tty = tty_port_tty_get(tport);
 	unsigned int ch = 0, rsr = 0, fifocnt;
 
 	if (!tty) {
@@ -208,7 +209,7 @@ lqasc_rx_chars(struct uart_port *port)
 		}
 
 		if ((rsr & port->ignore_status_mask) == 0)
-			tty_insert_flip_char(tty, ch, flag);
+			tty_insert_flip_char(tport, ch, flag);
 
 		if (rsr & ASCSTATE_ROE)
 			/*
@@ -216,7 +217,7 @@ lqasc_rx_chars(struct uart_port *port)
 			 * immediately, and doesn't affect the current
 			 * character
 			 */
-			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+			tty_insert_flip_char(tport, 0, TTY_OVERRUN);
 	}
 	if (ch != 0)
 		tty_flip_buffer_push(tty);
diff --git a/drivers/tty/serial/lpc32xx_hs.c b/drivers/tty/serial/lpc32xx_hs.c
index 0e86bff..5cd1805 100644
--- a/drivers/tty/serial/lpc32xx_hs.c
+++ b/drivers/tty/serial/lpc32xx_hs.c
@@ -257,8 +257,9 @@ static void __serial_uart_flush(struct uart_port *port)
 
 static void __serial_lpc32xx_rx(struct uart_port *port)
 {
+	struct tty_port *tport = &port->state->port;
 	unsigned int tmp, flag;
-	struct tty_struct *tty = tty_port_tty_get(&port->state->port);
+	struct tty_struct *tty = tty_port_tty_get(tport);
 
 	if (!tty) {
 		/* Discard data: no tty available */
@@ -281,10 +282,10 @@ static void __serial_lpc32xx_rx(struct uart_port *port)
 			       LPC32XX_HSUART_IIR(port->membase));
 			port->icount.frame++;
 			flag = TTY_FRAME;
-			tty_insert_flip_char(tty, 0, TTY_FRAME);
+			tty_insert_flip_char(tport, 0, TTY_FRAME);
 		}
 
-		tty_insert_flip_char(tty, (tmp & 0xFF), flag);
+		tty_insert_flip_char(tport, (tmp & 0xFF), flag);
 
 		tmp = readl(LPC32XX_HSUART_FIFO(port->membase));
 	}
@@ -332,7 +333,8 @@ exit_tx:
 static irqreturn_t serial_lpc32xx_interrupt(int irq, void *dev_id)
 {
 	struct uart_port *port = dev_id;
-	struct tty_struct *tty = tty_port_tty_get(&port->state->port);
+	struct tty_port *port = &port->state->port;
+	struct tty_struct *tty = tty_port_tty_get(tport);
 	u32 status;
 
 	spin_lock(&port->lock);
@@ -356,8 +358,8 @@ static irqreturn_t serial_lpc32xx_interrupt(int irq, void *dev_id)
 		writel(LPC32XX_HSU_RX_OE_INT,
 		       LPC32XX_HSUART_IIR(port->membase));
 		port->icount.overrun++;
+		tty_insert_flip_char(tport, 0, TTY_OVERRUN);
 		if (tty) {
-			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
 			tty_schedule_flip(tty);
 		}
 	}
diff --git a/drivers/tty/serial/m32r_sio.c b/drivers/tty/serial/m32r_sio.c
index b13949a..2e9a390 100644
--- a/drivers/tty/serial/m32r_sio.c
+++ b/drivers/tty/serial/m32r_sio.c
@@ -300,7 +300,8 @@ static void m32r_sio_enable_ms(struct uart_port *port)
 
 static void receive_chars(struct uart_sio_port *up, int *status)
 {
-	struct tty_struct *tty = up->port.state->port.tty;
+	struct tty_port *port = &up->port.state->port;
+	struct tty_struct *tty = tport->tty;
 	unsigned char ch;
 	unsigned char flag;
 	int max_count = 256;
@@ -355,7 +356,7 @@ static void receive_chars(struct uart_sio_port *up, int *status)
 		if (uart_handle_sysrq_char(&up->port, ch))
 			goto ignore_char;
 		if ((*status & up->port.ignore_status_mask) == 0)
-			tty_insert_flip_char(tty, ch, flag);
+			tty_insert_flip_char(port, ch, flag);
 
 		if (*status & UART_LSR_OE) {
 			/*
@@ -363,7 +364,7 @@ static void receive_chars(struct uart_sio_port *up, int *status)
 			 * immediately, and doesn't affect the current
 			 * character.
 			 */
-			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+			tty_insert_flip_char(port, 0, TTY_OVERRUN);
 		}
 	ignore_char:
 		*status = serial_in(up, UART_LSR);
diff --git a/drivers/tty/serial/mpc52xx_uart.c b/drivers/tty/serial/mpc52xx_uart.c
index 7c23c4f..0145aeb 100644
--- a/drivers/tty/serial/mpc52xx_uart.c
+++ b/drivers/tty/serial/mpc52xx_uart.c
@@ -941,7 +941,8 @@ static struct uart_ops mpc52xx_uart_ops = {
 static inline int
 mpc52xx_uart_int_rx_chars(struct uart_port *port)
 {
-	struct tty_struct *tty = port->state->port.tty;
+	struct tty_port *tport = &port->state->port;
+	struct tty_struct *tty = tport->tty;
 	unsigned char ch, flag;
 	unsigned short status;
 
@@ -986,14 +987,14 @@ mpc52xx_uart_int_rx_chars(struct uart_port *port)
 			out_8(&PSC(port)->command, MPC52xx_PSC_RST_ERR_STAT);
 
 		}
-		tty_insert_flip_char(tty, ch, flag);
+		tty_insert_flip_char(tport, ch, flag);
 		if (status & MPC52xx_PSC_SR_OE) {
 			/*
 			 * Overrun is special, since it's
 			 * reported immediately, and doesn't
 			 * affect the current character
 			 */
-			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+			tty_insert_flip_char(tport, 0, TTY_OVERRUN);
 			port->icount.overrun++;
 		}
 	}
diff --git a/drivers/tty/serial/mpsc.c b/drivers/tty/serial/mpsc.c
index 5036686..4bcbc66 100644
--- a/drivers/tty/serial/mpsc.c
+++ b/drivers/tty/serial/mpsc.c
@@ -1040,10 +1040,10 @@ static int mpsc_rx_intr(struct mpsc_port_info *pi)
 						| SDMA_DESC_CMDSTAT_FR
 						| SDMA_DESC_CMDSTAT_OR)))
 				&& !(cmdstat & pi->port.ignore_status_mask)) {
-			tty_insert_flip_char(tty, *bp, flag);
+			tty_insert_flip_char(port, *bp, flag);
 		} else {
 			for (i=0; i<bytes_in; i++)
-				tty_insert_flip_char(tty, *bp++, TTY_NORMAL);
+				tty_insert_flip_char(port, *bp++, TTY_NORMAL);
 
 			pi->port.icount.rx += bytes_in;
 		}
diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 95fd39b..e4eb81a 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -91,14 +91,15 @@ static void msm_enable_ms(struct uart_port *port)
 
 static void handle_rx_dm(struct uart_port *port, unsigned int misr)
 {
-	struct tty_struct *tty = port->state->port.tty;
+	struct tty_port *tport = &port->state->port;
+	struct tty_struct *tty = tport->tty;
 	unsigned int sr;
 	int count = 0;
 	struct msm_port *msm_port = UART_TO_MSM(port);
 
 	if ((msm_read(port, UART_SR) & UART_SR_OVERRUN)) {
 		port->icount.overrun++;
-		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+		tty_insert_flip_char(tport, 0, TTY_OVERRUN);
 		msm_write(port, UART_CR_CMD_RESET_ERR, UART_CR);
 	}
 
@@ -146,7 +147,8 @@ static void handle_rx_dm(struct uart_port *port, unsigned int misr)
 
 static void handle_rx(struct uart_port *port)
 {
-	struct tty_struct *tty = port->state->port.tty;
+	struct tty_port *tport = &port->state->port;
+	struct tty_struct *tty = tport->tty;
 	unsigned int sr;
 
 	/*
@@ -155,7 +157,7 @@ static void handle_rx(struct uart_port *port)
 	 */
 	if ((msm_read(port, UART_SR) & UART_SR_OVERRUN)) {
 		port->icount.overrun++;
-		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+		tty_insert_flip_char(tport, 0, TTY_OVERRUN);
 		msm_write(port, UART_CR_CMD_RESET_ERR, UART_CR);
 	}
 
@@ -186,7 +188,7 @@ static void handle_rx(struct uart_port *port)
 		}
 
 		if (!uart_handle_sysrq_char(port, c))
-			tty_insert_flip_char(tty, c, flag);
+			tty_insert_flip_char(tport, c, flag);
 	}
 
 	tty_flip_buffer_push(tty);
diff --git a/drivers/tty/serial/msm_serial_hs.c b/drivers/tty/serial/msm_serial_hs.c
index 1fa9228..6aa9d47 100644
--- a/drivers/tty/serial/msm_serial_hs.c
+++ b/drivers/tty/serial/msm_serial_hs.c
@@ -908,6 +908,7 @@ static void msm_hs_dmov_rx_callback(struct msm_dmov_cmd *cmd_ptr,
 	unsigned long flags;
 	unsigned int flush;
 	struct tty_struct *tty;
+	struct tty_port *port;
 	struct uart_port *uport;
 	struct msm_hs_port *msm_uport;
 
@@ -917,7 +918,8 @@ static void msm_hs_dmov_rx_callback(struct msm_dmov_cmd *cmd_ptr,
 	spin_lock_irqsave(&uport->lock, flags);
 	clk_enable(msm_uport->clk);
 
-	tty = uport->state->port.tty;
+	port = &uport->state->port;
+	tty = port->tty;
 
 	msm_hs_write(uport, UARTDM_CR_ADDR, STALE_EVENT_DISABLE);
 
@@ -926,7 +928,7 @@ static void msm_hs_dmov_rx_callback(struct msm_dmov_cmd *cmd_ptr,
 	/* overflow is not connect to data in a FIFO */
 	if (unlikely((status & UARTDM_SR_OVERRUN_BMSK) &&
 		     (uport->read_status_mask & CREAD))) {
-		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+		tty_insert_flip_char(port, 0, TTY_OVERRUN);
 		uport->icount.buf_overrun++;
 		error_f = 1;
 	}
@@ -939,7 +941,7 @@ static void msm_hs_dmov_rx_callback(struct msm_dmov_cmd *cmd_ptr,
 		uport->icount.parity++;
 		error_f = 1;
 		if (uport->ignore_status_mask & IGNPAR)
-			tty_insert_flip_char(tty, 0, TTY_PARITY);
+			tty_insert_flip_char(port, 0, TTY_PARITY);
 	}
 
 	if (error_f)
@@ -1344,7 +1346,6 @@ static irqreturn_t msm_hs_rx_wakeup_isr(int irq, void *dev)
 	unsigned long flags;
 	struct msm_hs_port *msm_uport = dev;
 	struct uart_port *uport = &msm_uport->uport;
-	struct tty_struct *tty = NULL;
 
 	spin_lock_irqsave(&uport->lock, flags);
 	if (msm_uport->clk_state == MSM_HS_CLK_OFF) {
@@ -1361,8 +1362,7 @@ static irqreturn_t msm_hs_rx_wakeup_isr(int irq, void *dev)
 		 * optionally inject char into tty rx */
 		msm_hs_request_clock_on_locked(uport);
 		if (msm_uport->rx_wakeup.inject_rx) {
-			tty = uport->state->port.tty;
-			tty_insert_flip_char(tty,
+			tty_insert_flip_char(&uport->state->port,
 					     msm_uport->rx_wakeup.rx_to_inject,
 					     TTY_NORMAL);
 			queue_work(msm_hs_workqueue, &msm_uport->rx.tty_work);
diff --git a/drivers/tty/serial/mux.c b/drivers/tty/serial/mux.c
index e2775b6..83b2168 100644
--- a/drivers/tty/serial/mux.c
+++ b/drivers/tty/serial/mux.c
@@ -242,8 +242,9 @@ static void mux_write(struct uart_port *port)
  */
 static void mux_read(struct uart_port *port)
 {
+	struct tty_port *tport = &port->state->port;
 	int data;
-	struct tty_struct *tty = port->state->port.tty;
+	struct tty_struct *tty = tport->tty;
 	__u32 start_count = port->icount.rx;
 
 	while(1) {
@@ -266,7 +267,7 @@ static void mux_read(struct uart_port *port)
 		if (uart_handle_sysrq_char(port, data & 0xffu))
 			continue;
 
-		tty_insert_flip_char(tty, data & 0xFF, TTY_NORMAL);
+		tty_insert_flip_char(tport, data & 0xFF, TTY_NORMAL);
 	}
 	
 	if (start_count != port->icount.rx) {
diff --git a/drivers/tty/serial/nwpserial.c b/drivers/tty/serial/nwpserial.c
index dd4c31d..10d64a3 100644
--- a/drivers/tty/serial/nwpserial.c
+++ b/drivers/tty/serial/nwpserial.c
@@ -128,7 +128,8 @@ static void nwpserial_config_port(struct uart_port *port, int flags)
 static irqreturn_t nwpserial_interrupt(int irq, void *dev_id)
 {
 	struct nwpserial_port *up = dev_id;
-	struct tty_struct *tty = up->port.state->port.tty;
+	struct tty_port *port = &up->port.state->port;
+	struct tty_struct *tty = port->tty;
 	irqreturn_t ret;
 	unsigned int iir;
 	unsigned char ch;
@@ -146,7 +147,7 @@ static irqreturn_t nwpserial_interrupt(int irq, void *dev_id)
 		up->port.icount.rx++;
 		ch = dcr_read(up->dcr_host, UART_RX);
 		if (up->port.ignore_status_mask != NWPSERIAL_STATUS_RXVALID)
-			tty_insert_flip_char(tty, ch, TTY_NORMAL);
+			tty_insert_flip_char(port, ch, TTY_NORMAL);
 	} while (dcr_read(up->dcr_host, UART_LSR) & UART_LSR_DR);
 
 	tty_flip_buffer_push(tty);
diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index 333c8d0..73a3f29 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -229,6 +229,7 @@ static void pmz_interrupt_control(struct uart_pmac_port *uap, int enable)
 
 static struct tty_struct *pmz_receive_chars(struct uart_pmac_port *uap)
 {
+	struct tty_port *port;
 	struct tty_struct *tty = NULL;
 	unsigned char ch, r1, drop, error, flag;
 	int loops = 0;
@@ -239,7 +240,8 @@ static struct tty_struct *pmz_receive_chars(struct uart_pmac_port *uap)
 		(void)read_zsdata(uap);
 		return NULL;
 	}
-	tty = uap->port.state->port.tty;
+	port = &uap->port.state->port;
+	tty = port->tty; /* TOCTOU above */
 
 	while (1) {
 		error = 0;
@@ -309,10 +311,10 @@ static struct tty_struct *pmz_receive_chars(struct uart_pmac_port *uap)
 
 		if (uap->port.ignore_status_mask == 0xff ||
 		    (r1 & uap->port.ignore_status_mask) == 0) {
-			tty_insert_flip_char(tty, ch, flag);
+			tty_insert_flip_char(port, ch, flag);
 		}
 		if (r1 & Rx_OVR)
-			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+			tty_insert_flip_char(port, 0, TTY_OVERRUN);
 	next_char:
 		/* We can get stuck in an infinite loop getting char 0 when the
 		 * line is in a wrong HW state, we break that here.
diff --git a/drivers/tty/serial/sc26xx.c b/drivers/tty/serial/sc26xx.c
index aced1dd..0cd0e4a 100644
--- a/drivers/tty/serial/sc26xx.c
+++ b/drivers/tty/serial/sc26xx.c
@@ -138,14 +138,18 @@ static void sc26xx_disable_irq(struct uart_port *port, int mask)
 
 static struct tty_struct *receive_chars(struct uart_port *port)
 {
+	struct tty_port *tport = NULL;
 	struct tty_struct *tty = NULL;
 	int limit = 10000;
 	unsigned char ch;
 	char flag;
 	u8 status;
 
-	if (port->state != NULL)		/* Unopened serial console */
-		tty = port->state->port.tty;
+	/* FIXME what is this trying to achieve? */
+	if (port->state != NULL) {		/* Unopened serial console */
+		tport = &port->state->port;
+		tty = tport->tty;
+	}
 
 	while (limit-- > 0) {
 		status = READ_SC_PORT(port, SR);
@@ -185,7 +189,7 @@ static struct tty_struct *receive_chars(struct uart_port *port)
 		if (status & port->ignore_status_mask)
 			continue;
 
-		tty_insert_flip_char(tty, ch, flag);
+		tty_insert_flip_char(tport, ch, flag);
 	}
 	return tty;
 }
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 2c7230a..7805609 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2790,10 +2790,10 @@ EXPORT_SYMBOL_GPL(uart_handle_cts_change);
 void uart_insert_char(struct uart_port *port, unsigned int status,
 		 unsigned int overrun, unsigned int ch, unsigned int flag)
 {
-	struct tty_struct *tty = port->state->port.tty;
+	struct tty_port *tport = &port->state->port;
 
 	if ((status & port->ignore_status_mask & ~overrun) == 0)
-		if (tty_insert_flip_char(tty, ch, flag) == 0)
+		if (tty_insert_flip_char(tport, ch, flag) == 0)
 			++port->icount.buf_overrun;
 
 	/*
@@ -2801,7 +2801,7 @@ void uart_insert_char(struct uart_port *port, unsigned int status,
 	 * it doesn't affect the current character.
 	 */
 	if (status & ~port->ignore_status_mask & overrun)
-		if (tty_insert_flip_char(tty, 0, TTY_OVERRUN) == 0)
+		if (tty_insert_flip_char(tport, 0, TTY_OVERRUN) == 0)
 			++port->icount.buf_overrun;
 }
 EXPORT_SYMBOL_GPL(uart_insert_char);
diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index cf96314..ecef748 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -620,7 +620,7 @@ static void sci_receive_chars(struct uart_port *port)
 			    sci_port->break_flag)
 				count = 0;
 			else
-				tty_insert_flip_char(tty, c, TTY_NORMAL);
+				tty_insert_flip_char(tport, c, TTY_NORMAL);
 		} else {
 			for (i = 0; i < count; i++) {
 				char c = serial_port_in(port, SCxRDR);
@@ -662,7 +662,7 @@ static void sci_receive_chars(struct uart_port *port)
 				} else
 					flag = TTY_NORMAL;
 
-				tty_insert_flip_char(tty, c, flag);
+				tty_insert_flip_char(tport, c, flag);
 			}
 		}
 
@@ -721,7 +721,8 @@ static int sci_handle_errors(struct uart_port *port)
 {
 	int copied = 0;
 	unsigned short status = serial_port_in(port, SCxSR);
-	struct tty_struct *tty = port->state->port.tty;
+	struct tty_port *tport = &port->state->port;
+	struct tty_struct *tty = tport->tty;
 	struct sci_port *s = to_sci_port(port);
 
 	/*
@@ -732,7 +733,7 @@ static int sci_handle_errors(struct uart_port *port)
 			port->icount.overrun++;
 
 			/* overrun error */
-			if (tty_insert_flip_char(tty, 0, TTY_OVERRUN))
+			if (tty_insert_flip_char(tport, 0, TTY_OVERRUN))
 				copied++;
 
 			dev_notice(port->dev, "overrun error");
@@ -756,7 +757,7 @@ static int sci_handle_errors(struct uart_port *port)
 
 				dev_dbg(port->dev, "BREAK detected\n");
 
-				if (tty_insert_flip_char(tty, 0, TTY_BREAK))
+				if (tty_insert_flip_char(tport, 0, TTY_BREAK))
 					copied++;
 			}
 
@@ -764,7 +765,7 @@ static int sci_handle_errors(struct uart_port *port)
 			/* frame error */
 			port->icount.frame++;
 
-			if (tty_insert_flip_char(tty, 0, TTY_FRAME))
+			if (tty_insert_flip_char(tport, 0, TTY_FRAME))
 				copied++;
 
 			dev_notice(port->dev, "frame error\n");
@@ -775,7 +776,7 @@ static int sci_handle_errors(struct uart_port *port)
 		/* parity error */
 		port->icount.parity++;
 
-		if (tty_insert_flip_char(tty, 0, TTY_PARITY))
+		if (tty_insert_flip_char(tport, 0, TTY_PARITY))
 			copied++;
 
 		dev_notice(port->dev, "parity error");
@@ -789,7 +790,8 @@ static int sci_handle_errors(struct uart_port *port)
 
 static int sci_handle_fifo_overrun(struct uart_port *port)
 {
-	struct tty_struct *tty = port->state->port.tty;
+	struct tty_port *tport = &port->state->port;
+	struct tty_struct *tty = tport->tty;
 	struct sci_port *s = to_sci_port(port);
 	struct plat_sci_reg *reg;
 	int copied = 0;
@@ -803,7 +805,7 @@ static int sci_handle_fifo_overrun(struct uart_port *port)
 
 		port->icount.overrun++;
 
-		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+		tty_insert_flip_char(tport, 0, TTY_OVERRUN);
 		tty_flip_buffer_push(tty);
 
 		dev_notice(port->dev, "overrun error\n");
@@ -817,7 +819,8 @@ static int sci_handle_breaks(struct uart_port *port)
 {
 	int copied = 0;
 	unsigned short status = serial_port_in(port, SCxSR);
-	struct tty_struct *tty = port->state->port.tty;
+	struct tty_port *tport = &port->state->port;
+	struct tty_struct *tty = tport->tty;
 	struct sci_port *s = to_sci_port(port);
 
 	if (uart_handle_break(port))
@@ -832,7 +835,7 @@ static int sci_handle_breaks(struct uart_port *port)
 		port->icount.brk++;
 
 		/* Notify of BREAK */
-		if (tty_insert_flip_char(tty, 0, TTY_BREAK))
+		if (tty_insert_flip_char(tport, 0, TTY_BREAK))
 			copied++;
 
 		dev_dbg(port->dev, "BREAK detected\n");
@@ -1260,8 +1263,7 @@ static void sci_dma_tx_complete(void *arg)
 }
 
 /* Locking: called with port lock held */
-static int sci_dma_rx_push(struct sci_port *s, struct tty_struct *tty,
-			   size_t count)
+static int sci_dma_rx_push(struct sci_port *s, size_t count)
 {
 	struct uart_port *port = &s->port;
 	struct tty_port *tport = &port->state->port;
@@ -1285,7 +1287,7 @@ static int sci_dma_rx_push(struct sci_port *s, struct tty_struct *tty,
 		return room;
 
 	for (i = 0; i < room; i++)
-		tty_insert_flip_char(tty, ((u8 *)sg_virt(&s->sg_rx[active]))[i],
+		tty_insert_flip_char(tport, ((u8 *)sg_virt(&s->sg_rx[active]))[i],
 				     TTY_NORMAL);
 
 	port->icount.rx += room;
@@ -1305,7 +1307,7 @@ static void sci_dma_rx_complete(void *arg)
 
 	spin_lock_irqsave(&port->lock, flags);
 
-	count = sci_dma_rx_push(s, tty, s->buf_len_rx);
+	count = sci_dma_rx_push(s, s->buf_len_rx);
 
 	mod_timer(&s->rx_timer, jiffies + s->rx_timeout);
 
@@ -1418,7 +1420,7 @@ static void work_fn_rx(struct work_struct *work)
 			sh_desc->partial, sh_desc->cookie);
 
 		spin_lock_irqsave(&port->lock, flags);
-		count = sci_dma_rx_push(s, tty, sh_desc->partial);
+		count = sci_dma_rx_push(s, sh_desc->partial);
 		spin_unlock_irqrestore(&port->lock, flags);
 
 		if (count)
diff --git a/drivers/tty/serial/sn_console.c b/drivers/tty/serial/sn_console.c
index 1c6de9f..283232c 100644
--- a/drivers/tty/serial/sn_console.c
+++ b/drivers/tty/serial/sn_console.c
@@ -457,6 +457,7 @@ static int sn_debug_printf(const char *fmt, ...)
 static void
 sn_receive_chars(struct sn_cons_port *port, unsigned long flags)
 {
+	struct tty_port *tport = NULL;
 	int ch;
 	struct tty_struct *tty;
 
@@ -472,7 +473,8 @@ sn_receive_chars(struct sn_cons_port *port, unsigned long flags)
 
 	if (port->sc_port.state) {
 		/* The serial_core stuffs are initialized, use them */
-		tty = port->sc_port.state->port.tty;
+		tport = &port->sc_port.state->port;
+		tty = tport->tty;
 	}
 	else {
 		/* Not registered yet - can't pass to tty layer.  */
@@ -517,7 +519,7 @@ sn_receive_chars(struct sn_cons_port *port, unsigned long flags)
 
 		/* record the character to pass up to the tty layer */
 		if (tty) {
-			if(tty_insert_flip_char(tty, ch, TTY_NORMAL) == 0)
+			if (tty_insert_flip_char(tport, ch, TTY_NORMAL) == 0)
 				break;
 		}
 		port->sc_port.icount.rx++;
diff --git a/drivers/tty/serial/sunhv.c b/drivers/tty/serial/sunhv.c
index b9bf9c5..bbb102e 100644
--- a/drivers/tty/serial/sunhv.c
+++ b/drivers/tty/serial/sunhv.c
@@ -99,7 +99,7 @@ static int receive_chars_getchar(struct uart_port *port, struct tty_struct *tty)
 			uart_handle_dcd_change(port, 1);
 		}
 
-		if (tty == NULL) {
+		if (port->state == NULL) {
 			uart_handle_sysrq_char(port, c);
 			continue;
 		}
@@ -109,7 +109,7 @@ static int receive_chars_getchar(struct uart_port *port, struct tty_struct *tty)
 		if (uart_handle_sysrq_char(port, c))
 			continue;
 
-		tty_insert_flip_char(tty, c, TTY_NORMAL);
+		tty_insert_flip_char(&port->state->port, c, TTY_NORMAL);
 	}
 
 	return saw_console_brk;
diff --git a/drivers/tty/serial/sunsab.c b/drivers/tty/serial/sunsab.c
index bd8b3b6..4abc4d4 100644
--- a/drivers/tty/serial/sunsab.c
+++ b/drivers/tty/serial/sunsab.c
@@ -111,6 +111,7 @@ static struct tty_struct *
 receive_chars(struct uart_sunsab_port *up,
 	      union sab82532_irq_status *stat)
 {
+	struct tty_port *port = NULL;
 	struct tty_struct *tty = NULL;
 	unsigned char buf[32];
 	int saw_console_brk = 0;
@@ -118,8 +119,10 @@ receive_chars(struct uart_sunsab_port *up,
 	int count = 0;
 	int i;
 
-	if (up->port.state != NULL)		/* Unopened serial console */
-		tty = up->port.state->port.tty;
+	if (up->port.state != NULL) {		/* Unopened serial console */
+		port = &up->port.state->port;
+		tty = port->tty;
+	}
 
 	/* Read number of BYTES (Character + Status) available. */
 	if (stat->sreg.isr0 & SAB82532_ISR0_RPF) {
@@ -160,11 +163,6 @@ receive_chars(struct uart_sunsab_port *up,
 	for (i = 0; i < count; i++) {
 		unsigned char ch = buf[i], flag;
 
-		if (tty == NULL) {
-			uart_handle_sysrq_char(&up->port, ch);
-			continue;
-		}
-
 		flag = TTY_NORMAL;
 		up->port.icount.rx++;
 
@@ -213,9 +211,9 @@ receive_chars(struct uart_sunsab_port *up,
 
 		if ((stat->sreg.isr0 & (up->port.ignore_status_mask & 0xff)) == 0 &&
 		    (stat->sreg.isr1 & ((up->port.ignore_status_mask >> 8) & 0xff)) == 0)
-			tty_insert_flip_char(tty, ch, flag);
+			tty_insert_flip_char(port, ch, flag);
 		if (stat->sreg.isr0 & SAB82532_ISR0_RFO)
-			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+			tty_insert_flip_char(port, 0, TTY_OVERRUN);
 	}
 
 	if (saw_console_brk)
diff --git a/drivers/tty/serial/sunsu.c b/drivers/tty/serial/sunsu.c
index 220da3f..5232596 100644
--- a/drivers/tty/serial/sunsu.c
+++ b/drivers/tty/serial/sunsu.c
@@ -318,7 +318,8 @@ static void sunsu_enable_ms(struct uart_port *port)
 static struct tty_struct *
 receive_chars(struct uart_sunsu_port *up, unsigned char *status)
 {
-	struct tty_struct *tty = up->port.state->port.tty;
+	struct tty_port *port = &up->port.state->port;
+	struct tty_struct *tty = port->tty;
 	unsigned char ch, flag;
 	int max_count = 256;
 	int saw_console_brk = 0;
@@ -376,14 +377,14 @@ receive_chars(struct uart_sunsu_port *up, unsigned char *status)
 		if (uart_handle_sysrq_char(&up->port, ch))
 			goto ignore_char;
 		if ((*status & up->port.ignore_status_mask) == 0)
-			tty_insert_flip_char(tty, ch, flag);
+			tty_insert_flip_char(port, ch, flag);
 		if (*status & UART_LSR_OE)
 			/*
 			 * Overrun is special, since it's reported
 			 * immediately, and doesn't affect the current
 			 * character.
 			 */
-			 tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+			 tty_insert_flip_char(port, 0, TTY_OVERRUN);
 	ignore_char:
 		*status = serial_inp(up, UART_LSR);
 	} while ((*status & UART_LSR_DR) && (max_count-- > 0));
diff --git a/drivers/tty/serial/sunzilog.c b/drivers/tty/serial/sunzilog.c
index aef4fab..4a11be3 100644
--- a/drivers/tty/serial/sunzilog.c
+++ b/drivers/tty/serial/sunzilog.c
@@ -327,13 +327,15 @@ static struct tty_struct *
 sunzilog_receive_chars(struct uart_sunzilog_port *up,
 		       struct zilog_channel __iomem *channel)
 {
+	struct tty_port *port = NULL;
 	struct tty_struct *tty;
 	unsigned char ch, r1, flag;
 
 	tty = NULL;
-	if (up->port.state != NULL &&		/* Unopened serial console */
-	    up->port.state->port.tty != NULL)	/* Keyboard || mouse */
-		tty = up->port.state->port.tty;
+	if (up->port.state != NULL) {		/* Unopened serial console */
+		port = &up->port.state->port;
+		tty = port->tty;		/* mouse => tty is NULL */
+	}
 
 	for (;;) {
 
@@ -366,11 +368,6 @@ sunzilog_receive_chars(struct uart_sunzilog_port *up,
 			continue;
 		}
 
-		if (tty == NULL) {
-			uart_handle_sysrq_char(&up->port, ch);
-			continue;
-		}
-
 		/* A real serial line, record the character and status.  */
 		flag = TTY_NORMAL;
 		up->port.icount.rx++;
@@ -400,10 +397,10 @@ sunzilog_receive_chars(struct uart_sunzilog_port *up,
 
 		if (up->port.ignore_status_mask == 0xff ||
 		    (r1 & up->port.ignore_status_mask) == 0) {
-		    	tty_insert_flip_char(tty, ch, flag);
+		    	tty_insert_flip_char(port, ch, flag);
 		}
 		if (r1 & Rx_OVR)
-			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+			tty_insert_flip_char(port, 0, TTY_OVERRUN);
 	}
 
 	return tty;
diff --git a/drivers/tty/serial/timbuart.c b/drivers/tty/serial/timbuart.c
index 5be0d68..f40c634 100644
--- a/drivers/tty/serial/timbuart.c
+++ b/drivers/tty/serial/timbuart.c
@@ -91,12 +91,12 @@ static void timbuart_flush_buffer(struct uart_port *port)
 
 static void timbuart_rx_chars(struct uart_port *port)
 {
-	struct tty_struct *tty = port->state->port.tty;
+	struct tty_port *tport = &port->state->port;
 
 	while (ioread32(port->membase + TIMBUART_ISR) & RXDP) {
 		u8 ch = ioread8(port->membase + TIMBUART_RXFIFO);
 		port->icount.rx++;
-		tty_insert_flip_char(tty, ch, TTY_NORMAL);
+		tty_insert_flip_char(tport, ch, TTY_NORMAL);
 	}
 
 	spin_unlock(&port->lock);
diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uartlite.c
index 89eee43..5caf1f0 100644
--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -66,7 +66,7 @@ static struct uart_port ulite_ports[ULITE_NR_UARTS];
 
 static int ulite_receive(struct uart_port *port, int stat)
 {
-	struct tty_struct *tty = port->state->port.tty;
+	struct tty_port *tport = &port->state->port;
 	unsigned char ch = 0;
 	char flag = TTY_NORMAL;
 
@@ -103,13 +103,13 @@ static int ulite_receive(struct uart_port *port, int stat)
 	stat &= ~port->ignore_status_mask;
 
 	if (stat & ULITE_STATUS_RXVALID)
-		tty_insert_flip_char(tty, ch, flag);
+		tty_insert_flip_char(tport, ch, flag);
 
 	if (stat & ULITE_STATUS_FRAME)
-		tty_insert_flip_char(tty, 0, TTY_FRAME);
+		tty_insert_flip_char(tport, 0, TTY_FRAME);
 
 	if (stat & ULITE_STATUS_OVERRUN)
-		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+		tty_insert_flip_char(tport, 0, TTY_OVERRUN);
 
 	return 1;
 }
diff --git a/drivers/tty/serial/ucc_uart.c b/drivers/tty/serial/ucc_uart.c
index ed047d9..7a23786 100644
--- a/drivers/tty/serial/ucc_uart.c
+++ b/drivers/tty/serial/ucc_uart.c
@@ -513,7 +513,7 @@ static void qe_uart_int_rx(struct uart_qe_port *qe_port)
 				continue;
 
 error_return:
-			tty_insert_flip_char(tty, ch, flg);
+			tty_insert_flip_char(tport, ch, flg);
 
 		}
 
@@ -561,7 +561,7 @@ handle_error:
 
 	/* Overrun does not affect the current character ! */
 	if (status & BD_SC_OV)
-		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+		tty_insert_flip_char(tport, 0, TTY_OVERRUN);
 #ifdef SUPPORT_SYSRQ
 	port->sysrq = 0;
 #endif
diff --git a/drivers/tty/serial/vt8500_serial.c b/drivers/tty/serial/vt8500_serial.c
index 8fd1814..7f41124 100644
--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -136,7 +136,8 @@ static void vt8500_enable_ms(struct uart_port *port)
 
 static void handle_rx(struct uart_port *port)
 {
-	struct tty_struct *tty = tty_port_tty_get(&port->state->port);
+	struct tty_port *tport = &port->state->port;
+	struct tty_struct *tty = tty_port_tty_get(tport);
 	if (!tty) {
 		/* Discard data: no tty available */
 		int count = (vt8500_read(port, VT8500_URFIDX) & 0x1f00) >> 8;
@@ -151,7 +152,7 @@ static void handle_rx(struct uart_port *port)
 	 */
 	if ((vt8500_read(port, VT8500_URISR) & RXOVER)) {
 		port->icount.overrun++;
-		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+		tty_insert_flip_char(tport, 0, TTY_OVERRUN);
 	}
 
 	/* and now the main RX loop */
@@ -174,7 +175,7 @@ static void handle_rx(struct uart_port *port)
 		port->icount.rx++;
 
 		if (!uart_handle_sysrq_char(port, c))
-			tty_insert_flip_char(tty, c, flag);
+			tty_insert_flip_char(tport, c, flag);
 	}
 
 	tty_flip_buffer_push(tty);
diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index 9e071f6..b5686b5 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -1508,13 +1508,13 @@ static void mgsl_isr_receive_data( struct mgsl_struct *info )
 			else if (status & RXSTATUS_FRAMING_ERROR)
 				flag = TTY_FRAME;
 		}	/* end of if (error) */
-		tty_insert_flip_char(tty, DataByte, flag);
+		tty_insert_flip_char(&info->port, DataByte, flag);
 		if (status & RXSTATUS_OVERRUN) {
 			/* Overrun is special, since it's
 			 * reported immediately, and doesn't
 			 * affect the current character
 			 */
-			work += tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+			work += tty_insert_flip_char(&info->port, 0, TTY_OVERRUN);
 		}
 	}
 
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index aba1e59..a0639a0 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -1894,10 +1894,8 @@ static void rx_async(struct slgt_info *info)
 				else if (status & BIT0)
 					stat = TTY_FRAME;
 			}
-			if (tty) {
-				tty_insert_flip_char(tty, ch, stat);
-				chars++;
-			}
+			tty_insert_flip_char(&info->port, ch, stat);
+			chars++;
 		}
 
 		if (i < count) {
@@ -2183,7 +2181,7 @@ static void isr_serial(struct slgt_info *info)
 			if (info->port.tty) {
 				if (!(status & info->ignore_status_mask)) {
 					if (info->read_status_mask & MASK_BREAK) {
-						tty_insert_flip_char(info->port.tty, 0, TTY_BREAK);
+						tty_insert_flip_char(&info->port, 0, TTY_BREAK);
 						if (info->port.flags & ASYNC_SAK)
 							do_SAK(info->port.tty);
 					}
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index fd43fb6..0afabc0 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -2132,13 +2132,11 @@ static void isr_rxint(SLMP_INFO * info)
 			/* process break detection if tty control
 			 * is not set to ignore it
 			 */
-			if ( tty ) {
-				if (!(status & info->ignore_status_mask1)) {
-					if (info->read_status_mask1 & BRKD) {
-						tty_insert_flip_char(tty, 0, TTY_BREAK);
-						if (info->port.flags & ASYNC_SAK)
-							do_SAK(tty);
-					}
+			if (!(status & info->ignore_status_mask1)) {
+				if (info->read_status_mask1 & BRKD) {
+					tty_insert_flip_char(&info->port, 0, TTY_BREAK);
+					if (tty && (info->port.flags & ASYNC_SAK))
+						do_SAK(tty);
 				}
 			}
 		}
@@ -2203,26 +2201,22 @@ static void isr_rxrdy(SLMP_INFO * info)
 
 			status &= info->read_status_mask2;
 
-			if ( tty ) {
-				if (status & PE)
-					flag = TTY_PARITY;
-				else if (status & FRME)
-					flag = TTY_FRAME;
-				if (status & OVRN) {
-					/* Overrun is special, since it's
-					 * reported immediately, and doesn't
-					 * affect the current character
-					 */
-					over = true;
-				}
+			if (status & PE)
+				flag = TTY_PARITY;
+			else if (status & FRME)
+				flag = TTY_FRAME;
+			if (status & OVRN) {
+				/* Overrun is special, since it's
+				 * reported immediately, and doesn't
+				 * affect the current character
+				 */
+				over = true;
 			}
 		}	/* end of if (error) */
 
-		if ( tty ) {
-			tty_insert_flip_char(tty, DataByte, flag);
-			if (over)
-				tty_insert_flip_char(tty, 0, TTY_OVERRUN);
-		}
+		tty_insert_flip_char(&info->port, DataByte, flag);
+		if (over)
+			tty_insert_flip_char(&info->port, 0, TTY_OVERRUN);
 	}
 
 	if ( debug_level >= DEBUG_LEVEL_ISR ) {
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 681765b..5aace4d 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -309,8 +309,8 @@ static void put_queue(struct vc_data *vc, int ch)
 {
 	struct tty_struct *tty = vc->port.tty;
 
+	tty_insert_flip_char(&vc->port, ch, 0);
 	if (tty) {
-		tty_insert_flip_char(tty, ch, 0);
 		tty_schedule_flip(tty);
 	}
 }
@@ -323,7 +323,7 @@ static void puts_queue(struct vc_data *vc, char *cp)
 		return;
 
 	while (*cp) {
-		tty_insert_flip_char(tty, *cp, 0);
+		tty_insert_flip_char(&vc->port, *cp, 0);
 		cp++;
 	}
 	tty_schedule_flip(tty);
@@ -586,7 +586,7 @@ static void fn_send_intr(struct vc_data *vc)
 
 	if (!tty)
 		return;
-	tty_insert_flip_char(tty, 0, TTY_BREAK);
+	tty_insert_flip_char(&vc->port, 0, TTY_BREAK);
 	tty_schedule_flip(tty);
 }
 
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index f307196..2c465bb 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1336,7 +1336,7 @@ static void csi_m(struct vc_data *vc)
 static void respond_string(const char *p, struct tty_struct *tty)
 {
 	while (*p) {
-		tty_insert_flip_char(tty, *p, 0);
+		tty_insert_flip_char(tty->port, *p, 0);
 		p++;
 	}
 	tty_schedule_flip(tty);
diff --git a/drivers/usb/serial/ark3116.c b/drivers/usb/serial/ark3116.c
index e2d653d..1614feb 100644
--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -703,7 +703,7 @@ static void ark3116_process_read_urb(struct urb *urb)
 
 		/* overrun is special, not associated with a char */
 		if (lsr & UART_LSR_OE)
-			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+			tty_insert_flip_char(&port->port, 0, TTY_OVERRUN);
 	}
 	tty_insert_flip_string_fixed_flag(&port->port, data, tty_flag,
 							urb->actual_length);
diff --git a/drivers/usb/serial/belkin_sa.c b/drivers/usb/serial/belkin_sa.c
index a213d1b..7ba2c0b 100644
--- a/drivers/usb/serial/belkin_sa.c
+++ b/drivers/usb/serial/belkin_sa.c
@@ -276,7 +276,7 @@ static void belkin_sa_process_read_urb(struct urb *urb)
 
 		/* Overrun is special, not associated with a char. */
 		if (status & BELKIN_SA_LSR_OE)
-			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+			tty_insert_flip_char(&port->port, 0, TTY_OVERRUN);
 	}
 
 	tty_insert_flip_string_fixed_flag(&port->port, data, tty_flag,
diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index efbc403..b5fa738 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -1441,7 +1441,7 @@ static int digi_read_inb_callback(struct urb *urb)
 
 		/* overrun is special, not associated with a char */
 		if (port_status & DIGI_OVERRUN_ERROR)
-			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+			tty_insert_flip_char(&port->port, 0, TTY_OVERRUN);
 
 		/* break takes precedence over parity, */
 		/* which takes precedence over framing errors */
diff --git a/drivers/usb/serial/f81232.c b/drivers/usb/serial/f81232.c
index a8c6430..6b880c3 100644
--- a/drivers/usb/serial/f81232.c
+++ b/drivers/usb/serial/f81232.c
@@ -133,12 +133,13 @@ static void f81232_process_read_urb(struct urb *urb)
 
 	/* overrun is special, not associated with a char */
 	if (line_status & UART_OVERRUN_ERROR)
-		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+		tty_insert_flip_char(&port->port, 0, TTY_OVERRUN);
 
 	if (port->port.console && port->sysrq) {
 		for (i = 0; i < urb->actual_length; ++i)
 			if (!usb_serial_handle_sysrq_char(port, data[i]))
-				tty_insert_flip_char(tty, data[i], tty_flag);
+				tty_insert_flip_char(&port->port, data[i],
+						tty_flag);
 	} else {
 		tty_insert_flip_string_fixed_flag(&port->port, data, tty_flag,
 							urb->actual_length);
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 0416d95..eb59ba3 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1958,9 +1958,8 @@ static int ftdi_prepare_write_buffer(struct usb_serial_port *port,
 
 #define FTDI_RS_ERR_MASK (FTDI_RS_BI | FTDI_RS_PE | FTDI_RS_FE | FTDI_RS_OE)
 
-static int ftdi_process_packet(struct tty_struct *tty,
-		struct usb_serial_port *port, struct ftdi_private *priv,
-		char *packet, int len)
+static int ftdi_process_packet(struct usb_serial_port *port,
+		struct ftdi_private *priv, char *packet, int len)
 {
 	int i;
 	char status;
@@ -2010,7 +2009,7 @@ static int ftdi_process_packet(struct tty_struct *tty,
 		/* Overrun is special, not associated with a char */
 		if (packet[1] & FTDI_RS_OE) {
 			priv->icount.overrun++;
-			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+			tty_insert_flip_char(&port->port, 0, TTY_OVERRUN);
 		}
 	}
 
@@ -2029,7 +2028,7 @@ static int ftdi_process_packet(struct tty_struct *tty,
 	if (port->port.console && port->sysrq) {
 		for (i = 0; i < len; i++, ch++) {
 			if (!usb_serial_handle_sysrq_char(port, *ch))
-				tty_insert_flip_char(tty, *ch, flag);
+				tty_insert_flip_char(&port->port, *ch, flag);
 		}
 	} else {
 		tty_insert_flip_string_fixed_flag(&port->port, ch, flag, len);
@@ -2054,7 +2053,7 @@ static void ftdi_process_read_urb(struct urb *urb)
 
 	for (i = 0; i < urb->actual_length; i += priv->max_packet_size) {
 		len = min_t(int, urb->actual_length - i, priv->max_packet_size);
-		count += ftdi_process_packet(tty, port, priv, &data[i], len);
+		count += ftdi_process_packet(port, priv, &data[i], len);
 	}
 
 	if (count)
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 2ea70a6..b00110c 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -332,7 +332,7 @@ void usb_serial_generic_process_read_urb(struct urb *urb)
 	else {
 		for (i = 0; i < urb->actual_length; i++, ch++) {
 			if (!usb_serial_handle_sysrq_char(port, *ch))
-				tty_insert_flip_char(tty, *ch, TTY_NORMAL);
+				tty_insert_flip_char(&port->port, *ch, TTY_NORMAL);
 		}
 	}
 	tty_flip_buffer_push(tty);
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 97bc49f..a4f5cae 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -315,7 +315,7 @@ static void	usa26_indat_callback(struct urb *urb)
 			else
 				err = 0;
 			for (i = 1; i < urb->actual_length ; ++i)
-				tty_insert_flip_char(tty, data[i], err);
+				tty_insert_flip_char(&port->port, data[i], err);
 		} else {
 			/* some bytes had errors, every byte has status */
 			dev_dbg(&port->dev, "%s - RX error!!!!\n", __func__);
@@ -328,7 +328,8 @@ static void	usa26_indat_callback(struct urb *urb)
 				if (stat & RXERROR_PARITY)
 					flag |= TTY_PARITY;
 				/* XXX should handle break (0x10) */
-				tty_insert_flip_char(tty, data[i+1], flag);
+				tty_insert_flip_char(&port->port, data[i+1],
+						flag);
 			}
 		}
 		tty_flip_buffer_push(tty);
@@ -700,7 +701,8 @@ static void	usa49_indat_callback(struct urb *urb)
 				if (stat & RXERROR_PARITY)
 					flag |= TTY_PARITY;
 				/* XXX should handle break (0x10) */
-				tty_insert_flip_char(tty, data[i+1], flag);
+				tty_insert_flip_char(&port->port, data[i+1],
+						flag);
 			}
 		}
 		tty_flip_buffer_push(tty);
@@ -751,7 +753,8 @@ static void usa49wg_indat_callback(struct urb *urb)
 				/* no error on any byte */
 				i++;
 				for (x = 1; x < len ; ++x)
-					tty_insert_flip_char(tty, data[i++], 0);
+					tty_insert_flip_char(&port->port,
+							data[i++], 0);
 			} else {
 				/*
 				 * some bytes had errors, every byte has status
@@ -765,7 +768,7 @@ static void usa49wg_indat_callback(struct urb *urb)
 					if (stat & RXERROR_PARITY)
 						flag |= TTY_PARITY;
 					/* XXX should handle break (0x10) */
-					tty_insert_flip_char(tty,
+					tty_insert_flip_char(&port->port,
 							data[i+1], flag);
 					i += 2;
 				}
@@ -824,8 +827,8 @@ static void usa90_indat_callback(struct urb *urb)
 				else
 					err = 0;
 				for (i = 1; i < urb->actual_length ; ++i)
-					tty_insert_flip_char(tty, data[i],
-									err);
+					tty_insert_flip_char(&port->port,
+							data[i], err);
 			}  else {
 			/* some bytes had errors, every byte has status */
 				dev_dbg(&port->dev, "%s - RX error!!!!\n", __func__);
@@ -838,8 +841,8 @@ static void usa90_indat_callback(struct urb *urb)
 					if (stat & RXERROR_PARITY)
 						flag |= TTY_PARITY;
 					/* XXX should handle break (0x10) */
-					tty_insert_flip_char(tty, data[i+1],
-									flag);
+					tty_insert_flip_char(&port->port,
+							data[i+1], flag);
 				}
 			}
 		}
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 86789b0..00047f3 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -805,12 +805,13 @@ static void pl2303_process_read_urb(struct urb *urb)
 
 	/* overrun is special, not associated with a char */
 	if (line_status & UART_OVERRUN_ERROR)
-		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+		tty_insert_flip_char(&port->port, 0, TTY_OVERRUN);
 
 	if (port->port.console && port->sysrq) {
 		for (i = 0; i < urb->actual_length; ++i)
 			if (!usb_serial_handle_sysrq_char(port, data[i]))
-				tty_insert_flip_char(tty, data[i], tty_flag);
+				tty_insert_flip_char(&port->port, data[i],
+						tty_flag);
 	} else {
 		tty_insert_flip_string_fixed_flag(&port->port, data, tty_flag,
 							urb->actual_length);
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index fa42f1b..04e3731 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -498,7 +498,7 @@ static void spcp8x5_process_read_urb(struct urb *urb)
 
 		/* overrun is special, not associated with a char */
 		if (status & UART_OVERRUN_ERROR)
-			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+			tty_insert_flip_char(&port->port, 0, TTY_OVERRUN);
 
 		if (status & UART_DCD)
 			usb_serial_handle_dcd_change(port, tty,
diff --git a/drivers/usb/serial/ssu100.c b/drivers/usb/serial/ssu100.c
index 37476c6..3871315 100644
--- a/drivers/usb/serial/ssu100.c
+++ b/drivers/usb/serial/ssu100.c
@@ -582,8 +582,7 @@ static void ssu100_update_lsr(struct usb_serial_port *port, u8 lsr,
 
 }
 
-static int ssu100_process_packet(struct urb *urb,
-				 struct tty_struct *tty)
+static int ssu100_process_packet(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	char *packet = (char *)urb->transfer_buffer;
@@ -598,7 +597,8 @@ static int ssu100_process_packet(struct urb *urb,
 		if (packet[2] == 0x00) {
 			ssu100_update_lsr(port, packet[3], &flag);
 			if (flag == TTY_OVERRUN)
-				tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+				tty_insert_flip_char(&port->port, 0,
+						TTY_OVERRUN);
 		}
 		if (packet[2] == 0x01)
 			ssu100_update_msr(port, packet[3]);
@@ -614,7 +614,7 @@ static int ssu100_process_packet(struct urb *urb,
 	if (port->port.console && port->sysrq) {
 		for (i = 0; i < len; i++, ch++) {
 			if (!usb_serial_handle_sysrq_char(port, *ch))
-				tty_insert_flip_char(tty, *ch, flag);
+				tty_insert_flip_char(&port->port, *ch, flag);
 		}
 	} else
 		tty_insert_flip_string_fixed_flag(&port->port, ch, flag, len);
@@ -632,7 +632,7 @@ static void ssu100_process_read_urb(struct urb *urb)
 	if (!tty)
 		return;
 
-	count = ssu100_process_packet(urb, tty);
+	count = ssu100_process_packet(urb);
 
 	if (count)
 		tty_flip_buffer_push(tty);
diff --git a/include/linux/tty_flip.h b/include/linux/tty_flip.h
index 743f1d0..f9acb578 100644
--- a/include/linux/tty_flip.h
+++ b/include/linux/tty_flip.h
@@ -12,16 +12,16 @@ extern int tty_prepare_flip_string_flags(struct tty_port *port,
 		unsigned char **chars, char **flags, size_t size);
 void tty_schedule_flip(struct tty_struct *tty);
 
-static inline int tty_insert_flip_char(struct tty_struct *tty,
+static inline int tty_insert_flip_char(struct tty_port *port,
 					unsigned char ch, char flag)
 {
-	struct tty_buffer *tb = tty->port->buf.tail;
+	struct tty_buffer *tb = port->buf.tail;
 	if (tb && tb->used < tb->size) {
 		tb->flag_buf_ptr[tb->used] = flag;
 		tb->char_buf_ptr[tb->used++] = ch;
 		return 1;
 	}
-	return tty_insert_flip_string_flags(tty->port, &ch, &flag, 1);
+	return tty_insert_flip_string_flags(port, &ch, &flag, 1);
 }
 
 static inline int tty_insert_flip_string(struct tty_struct *tty, const unsigned char *chars, size_t size)
-- 
1.8.1


