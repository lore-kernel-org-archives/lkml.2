Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab1LDXnq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 18:43:46 -0500
Received: from mail.windriver.com ([147.11.1.11]:63551 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665Ab1LDXmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 18:42:40 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: alan@linux.intel.com, gregkh@suse.de, scottwood@freescale.com,
        galak@kernel.crashing.org
Cc: linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] serial: manually inline serial8250_handle_port
Date: Sun,  4 Dec 2011 18:42:22 -0500
Message-Id: <1323042143-25330-6-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1323042143-25330-1-git-send-email-paul.gortmaker@windriver.com>
References: <1322783258-20443-1-git-send-email-paul.gortmaker@windriver.com>
 <1323042143-25330-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently serial8250_handle_irq is a trivial wrapper around
serial8250_handle_port, which actually does all the work.

Since there are no other callers of serial8250_handle_port, we
can just move it inline into serial8250_handle_irq.  This also
makes it more clear what functionality any custom IRQ handlers
need to provide if not using serial8250_default_handle_irq.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/tty/serial/8250.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index 9e7780d..23332cb 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -1528,10 +1528,15 @@ EXPORT_SYMBOL_GPL(serial8250_modem_status);
 /*
  * This handles the interrupt from one port.
  */
-static void serial8250_handle_port(struct uart_8250_port *up)
+int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
 {
 	unsigned char status;
 	unsigned long flags;
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
+
+	if (iir & UART_IIR_NO_INT)
+		return 0;
 
 	spin_lock_irqsave(&up->port.lock, flags);
 
@@ -1546,19 +1551,7 @@ static void serial8250_handle_port(struct uart_8250_port *up)
 		serial8250_tx_chars(up);
 
 	spin_unlock_irqrestore(&up->port.lock, flags);
-}
-
-int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
-{
-	struct uart_8250_port *up =
-		container_of(port, struct uart_8250_port, port);
-
-	if (!(iir & UART_IIR_NO_INT)) {
-		serial8250_handle_port(up);
-		return 1;
-	}
-
-	return 0;
+	return 1;
 }
 EXPORT_SYMBOL_GPL(serial8250_handle_irq);
 
@@ -2825,7 +2818,7 @@ serial8250_console_write(struct console *co, const char *s, unsigned int count)
 
 	local_irq_save(flags);
 	if (up->port.sysrq) {
-		/* serial8250_handle_port() already took the lock */
+		/* serial8250_handle_irq() already took the lock */
 		locked = 0;
 	} else if (oops_in_progress) {
 		locked = spin_trylock(&up->port.lock);
-- 
1.7.7

