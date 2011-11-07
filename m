Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab1KGHcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 02:32:53 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:33346 "EHLO
	dnet.ilyx.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab1KGHcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 02:32:52 -0500
Message-ID: <4EB7899E.5090006@ilyx.ru>
Date: Mon, 07 Nov 2011 11:32:46 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110929 Iceape/2.0.11
MIME-Version: 1.0
To: Paul Fulghum <paulkf@microgate.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Ilya Zykov <ilya@ilyx.ru>
Subject: PROBLEM: n_hdlc not atomic use tty->flags.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

N_HDLC can spoil tty->flags because use not atomic operations on tty->flags.
I use n_hdlc line discipline and it happens.

Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
---
diff -uprN -X ../../dontdiff a/drivers/tty/n_hdlc.c b/drivers/tty/n_hdlc.c
--- a/drivers/tty/n_hdlc.c	2011-05-19 08:06:34.000000000 +0400
+++ b/drivers/tty/n_hdlc.c	2011-11-06 16:30:13.000000000 +0400
@@ -417,7 +417,7 @@ static void n_hdlc_send_frames(struct n_
 				__FILE__,__LINE__,tbuf,tbuf->count);
 			
 		/* Send the next block of data to device */
-		tty->flags |= (1 << TTY_DO_WRITE_WAKEUP);
+		set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
 		actual = tty->ops->write(tty, tbuf->buf, tbuf->count);
 
 		/* rollback was possible and has been done */
@@ -459,7 +459,7 @@ static void n_hdlc_send_frames(struct n_
 	}
 	
 	if (!tbuf)
-		tty->flags  &= ~(1 << TTY_DO_WRITE_WAKEUP);
+		clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
 	
 	/* Clear the re-entry flag */
 	spin_lock_irqsave(&n_hdlc->tx_buf_list.spinlock, flags);
@@ -491,7 +491,7 @@ static void n_hdlc_tty_wakeup(struct tty
 		return;
 
 	if (tty != n_hdlc->tty) {
-		tty->flags &= ~(1 << TTY_DO_WRITE_WAKEUP);
+		clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
 		return;
 	}
