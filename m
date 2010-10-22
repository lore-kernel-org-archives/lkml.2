Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694Ab0JVSWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:22:44 -0400
Received: from kroah.org ([198.145.64.141]:41946 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794Ab0JVSWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:22:42 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 34/49] serial: Factor out uart_poll_timeout() from 8250 driver
Date: Fri, 22 Oct 2010 11:21:13 -0700
Message-Id: <1287771688-14805-34-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <cbouatmailru@gmail.com>

Soon we will use that handy function in the altera_uart driver.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250.c       |   14 ++++----------
 include/linux/serial_core.h |    8 ++++++++
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 31b8cca..b586406 100644
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
@@ -2071,7 +2065,7 @@ static int serial8250_startup(struct uart_port *port)
 		up->timer.function = serial8250_backup_timeout;
 		up->timer.data = (unsigned long)up;
 		mod_timer(&up->timer, jiffies +
-			  poll_timeout(up->port.timeout) + HZ / 5);
+			uart_poll_timeout(port) + HZ / 5);
 	}
 
 	/*
@@ -2081,7 +2075,7 @@ static int serial8250_startup(struct uart_port *port)
 	 */
 	if (!is_real_interrupt(up->port.irq)) {
 		up->timer.data = (unsigned long)up;
-		mod_timer(&up->timer, jiffies + poll_timeout(up->port.timeout));
+		mod_timer(&up->timer, jiffies + uart_poll_timeout(port));
 	} else {
 		retval = serial_link_irq_chain(up);
 		if (retval)
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 563e234..ac48082 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -411,6 +411,14 @@ unsigned int uart_get_baud_rate(struct uart_port *port, struct ktermios *termios
 				unsigned int max);
 unsigned int uart_get_divisor(struct uart_port *port, unsigned int baud);
 
+/* Base timer interval for polling */
+static inline int uart_poll_timeout(struct uart_port *port)
+{
+	int timeout = port->timeout;
+
+	return timeout > 6 ? (timeout / 2 - 2) : 1;
+}
+
 /*
  * Console helpers.
  */
-- 
1.7.2

