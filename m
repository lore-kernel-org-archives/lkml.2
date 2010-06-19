Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab0FSUaA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 16:30:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55720 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab0FSU37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 16:29:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Luck <tony.luck@intel.com>
Subject: [PATCH] serial: revert "Use block_til_ready helper"
Date: Sat, 19 Jun 2010 22:29:21 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.35-rc3-00053-g34ffc96; KDE/4.4.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de> <AANLkTim4dHj_3ftAVD35DD-Cc7ZntHRi1YTRPup2wfJc@mail.gmail.com> <201006191432.04685.arnd@arndb.de>
In-Reply-To: <201006191432.04685.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006192229.21971.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/sNFRcVQ08zqrdt6wnXX8jjqG2n12UiV7M3S/
 z4mOnY9fD2tNRz0qUzz+yW6dsjMC3z5K2wnDrHmWahj2UfMrJZ
 meyqd3RzEJzjTQo6Nmkow==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 June 2010 14:32:04 Arnd Bergmann wrote:
> > I boot with a "console=uart,io,0x3f8" argument, so I start out using
> > 8250_early.c. Looks like it switched to 8250.c based on seeing
> > this:
> > 
> > Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> > 
> > on the console log.
> 
> Good, so it's something I should be able to reproduce on a PC.

I could reproduce the problem now and bisected it down to a cleanup
patch that can fortunately get reverted. The symptom that I saw
is that when I open a serial port for the second time (e.g. starting
getty and logging in), the output gets garbled, while the first one
worked fine. This does not rely on the console code at all.

Original commit message:
    Our code now rather closely resembles the helper, so switch to it.

Apparently, the two functions are not really doing the same,
so revert the commit for now. This includes the addition of
a tty_unlock()/tty_lock() pair when blocking on the wait queue.

Greg, do you want to apply this patch on top of the series, or
do you prefer to get a replacement for the original patch, once
we know what's wrong with it?

Tony, can you confirm that with this patch added, everything's
fine for you?

Alan, any idea where the problem may be with the broken patch?

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/serial/serial_core.c |   89 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 88 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 78b1eac..55e5769 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1539,6 +1539,93 @@ static void uart_dtr_rts(struct tty_port *port, int onoff)
 		uart_clear_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
 }
 
+/*
+ * Block the open until the port is ready.  We must be called with
+ * the per-port semaphore held.
+ */
+static int
+uart_block_til_ready(struct file *filp, struct uart_state *state)
+{
+	DECLARE_WAITQUEUE(wait, current);
+	struct tty_port *port = &state->port;
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->lock, flags);
+	if (!tty_hung_up_p(filp))
+		port->count--;
+	port->blocked_open++;
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	add_wait_queue(&port->open_wait, &wait);
+	while (1) {
+		set_current_state(TASK_INTERRUPTIBLE);
+
+		/*
+		 * If we have been hung up, tell userspace/restart open.
+		 */
+		if (tty_hung_up_p(filp) || port->tty == NULL)
+			break;
+
+		/*
+		 * If the port has been closed, tell userspace/restart open.
+		 */
+		if (!(port->flags & ASYNC_INITIALIZED))
+			break;
+
+		/*
+		 * If non-blocking mode is set, or CLOCAL mode is set,
+		 * we don't want to wait for the modem status lines to
+		 * indicate that the port is ready.
+		 *
+		 * Also, if the port is not enabled/configured, we want
+		 * to allow the open to succeed here.  Note that we will
+		 * have set TTY_IO_ERROR for a non-existant port.
+		 */
+		if ((filp->f_flags & O_NONBLOCK) ||
+		    (port->tty->termios->c_cflag & CLOCAL) ||
+		    (port->tty->flags & (1 << TTY_IO_ERROR)))
+			break;
+
+		/*
+		 * Set DTR to allow modem to know we're waiting.  Do
+		 * not set RTS here - we want to make sure we catch
+		 * the data from the modem.
+		 */
+		if (port->tty->termios->c_cflag & CBAUD)
+			tty_port_raise_dtr_rts(port);
+
+		/*
+		 * and wait for the carrier to indicate that the
+		 * modem is ready for us.
+		 */
+		if (tty_port_carrier_raised(port))
+			break;
+
+		tty_unlock();
+		schedule();
+		tty_lock();
+
+		if (signal_pending(current))
+			break;
+	}
+	set_current_state(TASK_RUNNING);
+	remove_wait_queue(&port->open_wait, &wait);
+
+	spin_lock_irqsave(&port->lock, flags);
+	if (!tty_hung_up_p(filp))
+		port->count++;
+	port->blocked_open--;
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	if (signal_pending(current))
+		return -ERESTARTSYS;
+
+	if (!port->tty || tty_hung_up_p(filp))
+		return -EAGAIN;
+
+	return 0;
+}
+
 static struct uart_state *uart_get(struct uart_driver *drv, int line)
 {
 	struct uart_state *state;
@@ -1647,7 +1734,7 @@ static int uart_open(struct tty_struct *tty, struct file *filp)
 	 */
 	mutex_unlock(&port->mutex);
 	if (retval == 0)
-		retval = tty_port_block_til_ready(port, tty, filp);
+		retval = uart_block_til_ready(filp, state);
 
 	/*
 	 * If this is the first open to succeed, adjust things to suit.
-- 
1.7.0.4

