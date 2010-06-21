Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578Ab0FUU6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:58:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65264 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758520Ab0FUU6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:58:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] serial: revert "Use block_til_ready helper"
Date: Mon, 21 Jun 2010 22:57:03 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.35-rc3-00068-g1931a4d-dirty; KDE/4.4.2; x86_64; ; )
Cc: Tony Luck <tony.luck@intel.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de> <201006202254.34530.arnd@arndb.de> <20100621151309.334f6645@lxorguk.ukuu.org.uk>
In-Reply-To: <20100621151309.334f6645@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006212257.03436.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/lMaLkefnOnx1mD61Op5P5ShxgVgP14oGRmpy
 eXXHQSQ4EtnKedOHeKfXhWj755YIw8DjV+k/6URa3k8mZCIEhz
 xg7ZRMQQM5WuZDkCCaaWw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 June 2010 16:13:09 Alan Cox wrote:

> and paste it into
> 
> void tty_port_raise_dtr_rts(struct tty_port *port)
> {
>         if (port->ops->dtr_rts)
>                 port->ops->dtr_rts(port, 1);
> 
> 		-->> HERE <<--
> }
> 
> 
> (the mutex is held by the caller)
> 
> That should cure it and then we can think about doing it more elegantly
> by getting the serial layer to use tty_port_open, kfifo and the like and
> removing the tons of repeated crap in all the drivers.

I had to do it slightly different, see below. This patch also fixes
the garbled output and lets me run cat> and getty on the onboard 16550a,
but unlike the previous patch, I can't get a minicom connection between
the two ports using hardware flow control now, so it seems that there
is still another problem.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 78b1eac..cd85112 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1533,8 +1533,16 @@ static void uart_dtr_rts(struct tty_port *port, int onoff)
 	struct uart_state *state = container_of(port, struct uart_state, port);
 	struct uart_port *uport = state->uart_port;
 
-	if (onoff)
+	if (onoff) {
 		uart_set_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
+
+		/*
+		 * If this is the first open to succeed,
+		 * adjust things to suit.
+		 */
+		if (!test_and_set_bit(ASYNCB_NORMAL_ACTIVE, &port->flags))
+			uart_update_termios(port->tty, state);
+	}
 	else
 		uart_clear_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
 }
@@ -1649,15 +1657,6 @@ static int uart_open(struct tty_struct *tty, struct file *filp)
 	if (retval == 0)
 		retval = tty_port_block_til_ready(port, tty, filp);
 
-	/*
-	 * If this is the first open to succeed, adjust things to suit.
-	 */
-	if (retval == 0 && !(port->flags & ASYNC_NORMAL_ACTIVE)) {
-		set_bit(ASYNCB_NORMAL_ACTIVE, &port->flags);
-
-		uart_update_termios(tty, state);
-	}
-
 fail:
 	return retval;
 }
