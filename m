Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789Ab1KIUd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:33:57 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:37387 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707Ab1KIUdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:33:55 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 01/10] TTY: serial, cleanup include file
Date: Wed,  9 Nov 2011 21:33:43 +0100
Message-Id: <1320870831-23778-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some functions (uart_handle_dcd_change, _handle_cts_change,
_insert_char) which are big enough to not be inlined. So move them
from .h to .c. We need to export them so that modules can actually use
them.

They will be even bigger when we introduce tty refcounting to them.

While at it, cleanup the "Proud member of Uglyhacks'R'US". It means,
define uart_handle_sysrq_char only when SUPPORT_SYSRQ is set.
Otherwise define it as a macro. This is needed for some arm driver
where the second parameter is undefined if expanded.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
---
So I decided to do the cleanup stepwise. Hence this patchset only
does some preparatory work. But it also converts one part of the close
to the tty port helper.

I have more serial patches in the queue. Mainly to convert the code to
hangup and open tty port helpers. But they need the rest of the code
to be converted to use tty refcounting properly. And I have not
finished yet. It is because all serial drivers needs to be revisited
and I have only a limited time I can spend on that.

In those patches I add uart helpers (like uart_push_chars). They take
a tty reference, do the requested operation (like
tty_flip_buffer_push) and put the reference.

This may increase number of reference count operations and I am
thinking about some ticketing. A ticket would contain a tty with
reference count increased unless put. Like
tkt = uart_ticket_get(uart);
uart_insert_char(tkt, char...);
uart_push_chars(tkt);
uart_ticket_put(tkt);

...instead of taking and dropping a reference in both uart_insert_char
and uart_push_chars there. But it may be as well an overkill, as this
stuff is not time critical. So any opinions? (If not I will proceed
without ticketing having tty_port_tty_get/put in every call. Like I
have it now.)

 drivers/tty/serial/serial_core.c |   82 +++++++++++++++++++++++++++++++
 include/linux/serial_core.h      |   99 +++++---------------------------------
 2 files changed, 94 insertions(+), 87 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 0406d7f..8d825a3 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -22,6 +22,7 @@
  */
 #include <linux/module.h>
 #include <linux/tty.h>
+#include <linux/tty_flip.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/console.h>
@@ -2467,6 +2468,87 @@ int uart_match_port(struct uart_port *port1, struct uart_port *port2)
 }
 EXPORT_SYMBOL(uart_match_port);
 
+/**
+ *	uart_handle_dcd_change - handle a change of carrier detect state
+ *	@uport: uart_port structure for the open port
+ *	@status: new carrier detect status, nonzero if active
+ */
+void uart_handle_dcd_change(struct uart_port *uport, unsigned int status)
+{
+	struct uart_state *state = uport->state;
+	struct tty_port *port = &state->port;
+	struct tty_ldisc *ld = tty_ldisc_ref(port->tty);
+	struct pps_event_time ts;
+
+	if (ld && ld->ops->dcd_change)
+		pps_get_ts(&ts);
+
+	uport->icount.dcd++;
+#ifdef CONFIG_HARD_PPS
+	if ((uport->flags & UPF_HARDPPS_CD) && status)
+		hardpps();
+#endif
+
+	if (port->flags & ASYNC_CHECK_CD) {
+		if (status)
+			wake_up_interruptible(&port->open_wait);
+		else if (port->tty)
+			tty_hangup(port->tty);
+	}
+
+	if (ld && ld->ops->dcd_change)
+		ld->ops->dcd_change(port->tty, status, &ts);
+	if (ld)
+		tty_ldisc_deref(ld);
+}
+EXPORT_SYMBOL_GPL(uart_handle_dcd_change);
+
+/**
+ *	uart_handle_cts_change - handle a change of clear-to-send state
+ *	@uport: uart_port structure for the open port
+ *	@status: new clear to send status, nonzero if active
+ */
+void uart_handle_cts_change(struct uart_port *uport, unsigned int status)
+{
+	struct tty_port *port = &uport->state->port;
+	struct tty_struct *tty = port->tty;
+
+	uport->icount.cts++;
+
+	if (port->flags & ASYNC_CTS_FLOW) {
+		if (tty->hw_stopped) {
+			if (status) {
+				tty->hw_stopped = 0;
+				uport->ops->start_tx(uport);
+				uart_write_wakeup(uport);
+			}
+		} else {
+			if (!status) {
+				tty->hw_stopped = 1;
+				uport->ops->stop_tx(uport);
+			}
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(uart_handle_cts_change);
+
+void uart_insert_char(struct uart_port *port, unsigned int status,
+		 unsigned int overrun, unsigned int ch, unsigned int flag)
+{
+	struct tty_struct *tty = port->state->port.tty;
+
+	if ((status & port->ignore_status_mask & ~overrun) == 0)
+		tty_insert_flip_char(tty, ch, flag);
+
+	/*
+	 * Overrun is special.  Since it's reported immediately,
+	 * it doesn't affect the current character.
+	 */
+	if (status & ~port->ignore_status_mask & overrun)
+		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+}
+EXPORT_SYMBOL_GPL(uart_insert_char);
+
 EXPORT_SYMBOL(uart_write_wakeup);
 EXPORT_SYMBOL(uart_register_driver);
 EXPORT_SYMBOL(uart_unregister_driver);
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index eadf33d..945e02c 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -483,10 +483,19 @@ static inline int uart_tx_stopped(struct uart_port *port)
 /*
  * The following are helper functions for the low level drivers.
  */
+
+extern void uart_handle_dcd_change(struct uart_port *uport,
+		unsigned int status);
+extern void uart_handle_cts_change(struct uart_port *uport,
+		unsigned int status);
+
+extern void uart_insert_char(struct uart_port *port, unsigned int status,
+		 unsigned int overrun, unsigned int ch, unsigned int flag);
+
+#ifdef SUPPORT_SYSRQ
 static inline int
 uart_handle_sysrq_char(struct uart_port *port, unsigned int ch)
 {
-#ifdef SUPPORT_SYSRQ
 	if (port->sysrq) {
 		if (ch && time_before(jiffies, port->sysrq)) {
 			handle_sysrq(ch);
@@ -495,11 +504,10 @@ uart_handle_sysrq_char(struct uart_port *port, unsigned int ch)
 		}
 		port->sysrq = 0;
 	}
-#endif
 	return 0;
 }
-#ifndef SUPPORT_SYSRQ
-#define uart_handle_sysrq_char(port,ch) uart_handle_sysrq_char(port, 0)
+#else
+#define uart_handle_sysrq_char(port,ch) ({ (void)port; 0; })
 #endif
 
 /*
@@ -522,89 +530,6 @@ static inline int uart_handle_break(struct uart_port *port)
 	return 0;
 }
 
-/**
- *	uart_handle_dcd_change - handle a change of carrier detect state
- *	@uport: uart_port structure for the open port
- *	@status: new carrier detect status, nonzero if active
- */
-static inline void
-uart_handle_dcd_change(struct uart_port *uport, unsigned int status)
-{
-	struct uart_state *state = uport->state;
-	struct tty_port *port = &state->port;
-	struct tty_ldisc *ld = tty_ldisc_ref(port->tty);
-	struct pps_event_time ts;
-
-	if (ld && ld->ops->dcd_change)
-		pps_get_ts(&ts);
-
-	uport->icount.dcd++;
-#ifdef CONFIG_HARD_PPS
-	if ((uport->flags & UPF_HARDPPS_CD) && status)
-		hardpps();
-#endif
-
-	if (port->flags & ASYNC_CHECK_CD) {
-		if (status)
-			wake_up_interruptible(&port->open_wait);
-		else if (port->tty)
-			tty_hangup(port->tty);
-	}
-
-	if (ld && ld->ops->dcd_change)
-		ld->ops->dcd_change(port->tty, status, &ts);
-	if (ld)
-		tty_ldisc_deref(ld);
-}
-
-/**
- *	uart_handle_cts_change - handle a change of clear-to-send state
- *	@uport: uart_port structure for the open port
- *	@status: new clear to send status, nonzero if active
- */
-static inline void
-uart_handle_cts_change(struct uart_port *uport, unsigned int status)
-{
-	struct tty_port *port = &uport->state->port;
-	struct tty_struct *tty = port->tty;
-
-	uport->icount.cts++;
-
-	if (port->flags & ASYNC_CTS_FLOW) {
-		if (tty->hw_stopped) {
-			if (status) {
-				tty->hw_stopped = 0;
-				uport->ops->start_tx(uport);
-				uart_write_wakeup(uport);
-			}
-		} else {
-			if (!status) {
-				tty->hw_stopped = 1;
-				uport->ops->stop_tx(uport);
-			}
-		}
-	}
-}
-
-#include <linux/tty_flip.h>
-
-static inline void
-uart_insert_char(struct uart_port *port, unsigned int status,
-		 unsigned int overrun, unsigned int ch, unsigned int flag)
-{
-	struct tty_struct *tty = port->state->port.tty;
-
-	if ((status & port->ignore_status_mask & ~overrun) == 0)
-		tty_insert_flip_char(tty, ch, flag);
-
-	/*
-	 * Overrun is special.  Since it's reported immediately,
-	 * it doesn't affect the current character.
-	 */
-	if (status & ~port->ignore_status_mask & overrun)
-		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
-}
-
 /*
  *	UART_ENABLE_MS - determine if port should enable modem status irqs
  */
-- 
1.7.7


