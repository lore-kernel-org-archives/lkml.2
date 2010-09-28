Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab0I1Nfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:35:30 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47083 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab0I1Nf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:35:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ZJJmMS4HnCvqPKNgk12bCEdkH6WdknWQPimGmX0K/bb2Oa7qvxt/obc/+cpRMQv7M6
         eKVBFO5wGrjskRyG7vQlz/MjsEAIryBfzs/UxHA45xl+uhX382IeMxgDnkZ0nQmYNwWC
         g6I9bS9/P7rTg0IV+TCwGu7TuONjv2zqyTPzg=
Date: Tue, 28 Sep 2010 17:35:11 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Tobias Klauser <tklauser@distanz.ch>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] serial: Factor out uart_poll_timeout() from 8250 driver
Message-ID: <20100928133511.GA8289@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soon we will use that handy function in the altera_uart driver.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/serial/8250.c        |   14 ++++----------
 drivers/serial/serial_core.c |    9 +++++++++
 include/linux/serial_core.h  |    1 +
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 24110f6..61e95dd 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1722,12 +1722,6 @@ static void serial_unlink_irq_chain(struct uart_8250_port *up)
 	mutex_unlock(&hash_mutex);
 }
 
-/* Base timer interval for polling */
-static inline int poll_timeout(int timeout)
-{
-	return timeout > 6 ? (timeout / 2 - 2) : 1;
-}
-
 /*
  * This function is used to handle ports that do not have an
  * interrupt.  This doesn't work very well for 16450's, but gives
@@ -1742,7 +1736,7 @@ static void serial8250_timeout(unsigned long data)
 	iir = serial_in(up, UART_IIR);
 	if (!(iir & UART_IIR_NO_INT))
 		serial8250_handle_port(up);
-	mod_timer(&up->timer, jiffies + poll_timeout(up->port.timeout));
+	mod_timer(&up->timer, jiffies + uart_poll_timeout(&up->port));
 }
 
 static void serial8250_backup_timeout(unsigned long data)
@@ -1787,7 +1781,7 @@ static void serial8250_backup_timeout(unsigned long data)
 
 	/* Standard timer interval plus 0.2s to keep the port running */
 	mod_timer(&up->timer,
-		jiffies + poll_timeout(up->port.timeout) + HZ / 5);
+		jiffies + uart_poll_timeout(&up->port) + HZ / 5);
 }
 
 static unsigned int serial8250_tx_empty(struct uart_port *port)
@@ -2069,7 +2063,7 @@ static int serial8250_startup(struct uart_port *port)
 		up->timer.function = serial8250_backup_timeout;
 		up->timer.data = (unsigned long)up;
 		mod_timer(&up->timer, jiffies +
-			  poll_timeout(up->port.timeout) + HZ / 5);
+			uart_poll_timeout(port) + HZ / 5);
 	}
 
 	/*
@@ -2079,7 +2073,7 @@ static int serial8250_startup(struct uart_port *port)
 	 */
 	if (!is_real_interrupt(up->port.irq)) {
 		up->timer.data = (unsigned long)up;
-		mod_timer(&up->timer, jiffies + poll_timeout(up->port.timeout));
+		mod_timer(&up->timer, jiffies + uart_poll_timeout(port));
 	} else {
 		retval = serial_link_irq_chain(up);
 		if (retval)
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index cd85112..0889957 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -428,6 +428,15 @@ uart_get_divisor(struct uart_port *port, unsigned int baud)
 
 EXPORT_SYMBOL(uart_get_divisor);
 
+/* Base timer interval for polling */
+int uart_poll_timeout(struct uart_port *port)
+{
+	int timeout = port->timeout;
+
+	return timeout > 6 ? (timeout / 2 - 2) : 1;
+}
+EXPORT_SYMBOL(uart_poll_timeout);
+
 /* FIXME: Consistent locking policy */
 static void uart_change_speed(struct tty_struct *tty, struct uart_state *state,
 					struct ktermios *old_termios)
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 563e234..7e90ef4 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -410,6 +410,7 @@ unsigned int uart_get_baud_rate(struct uart_port *port, struct ktermios *termios
 				struct ktermios *old, unsigned int min,
 				unsigned int max);
 unsigned int uart_get_divisor(struct uart_port *port, unsigned int baud);
+int uart_poll_timeout(struct uart_port *port);
 
 /*
  * Console helpers.
-- 
1.7.0.5

