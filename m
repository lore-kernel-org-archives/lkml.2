Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab2CZU1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:27:12 -0400
Received: from proxima.lp0.eu ([81.2.80.65]:51966 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709Ab2CZU1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:27:11 -0400
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Mar 2012 16:27:11 EDT
Message-ID: <4F70CF5C.7030004@simon.arlott.org.uk>
Date: Mon, 26 Mar 2012 21:19:40 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110823 Thunderbird/5.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org
CC: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>,
        USB list <linux-usb@vger.kernel.org>
Subject: ftdi_sio: fix status line change handling for TIOCMIWAIT and TIOCGICOUNT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handling of TIOCMIWAIT was changed by commit 1d749f9afa657f6ee9336b2bc1fcd750a647d157
 USB: ftdi_sio.c: Use ftdi async_icount structure for TIOCMIWAIT, as in other drivers

FTDI_STATUS_B0_MASK does not indicate the changed modem status lines,
it indicates the value of the current modem status lines. An xor is
still required to determine which lines have changed.

The count was only being incremented if the line was high. The only
reason TIOCMIWAIT still worked was because the status packet is
repeated every 1ms, so the count was always changing. The wakeup
itself still ran based on the status lines changing.

This change fixes handling of updates to the modem status lines and
allows multiple processes to use TIOCMIWAIT concurrently.

Tested with two processes waiting on different status lines being
toggled independently.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
---
 drivers/usb/serial/ftdi_sio.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index f770415..d260b79 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -75,7 +75,7 @@ struct ftdi_private {
 	unsigned long last_dtr_rts;	/* saved modem control outputs */
 	struct async_icount	icount;
 	wait_queue_head_t delta_msr_wait; /* Used for TIOCMIWAIT */
-	char prev_status, diff_status;        /* Used for TIOCMIWAIT */
+	char prev_status;        /* Used for TIOCMIWAIT */
 	char transmit_empty;	/* If transmitter is empty or not */
 	struct usb_serial_port *port;
 	__u16 interface;	/* FT2232C, FT2232H or FT4232H port interface
@@ -1962,17 +1962,19 @@ static int ftdi_process_packet(struct tty_struct *tty,
 	   N.B. packet may be processed more than once, but differences
 	   are only processed once.  */
 	status = packet[0] & FTDI_STATUS_B0_MASK;
-	if (status & FTDI_RS0_CTS)
-		priv->icount.cts++;
-	if (status & FTDI_RS0_DSR)
-		priv->icount.dsr++;
-	if (status & FTDI_RS0_RI)
-		priv->icount.rng++;
-	if (status & FTDI_RS0_RLSD)
-		priv->icount.dcd++;
 	if (status != priv->prev_status) {
-		priv->diff_status |= status ^ priv->prev_status;
-		wake_up_interruptible(&priv->delta_msr_wait);
+		char diff_status = status ^ priv->prev_status;
+
+		if (diff_status & FTDI_RS0_CTS)
+			priv->icount.cts++;
+		if (diff_status & FTDI_RS0_DSR)
+			priv->icount.dsr++;
+		if (diff_status & FTDI_RS0_RI)
+			priv->icount.rng++;
+		if (diff_status & FTDI_RS0_RLSD)
+			priv->icount.dcd++;
+
+		wake_up_interruptible_all(&priv->delta_msr_wait);
 		priv->prev_status = status;
 	}
 
-- 
1.7.4.1

-- 
Simon Arlott
