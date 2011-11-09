Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929Ab1KIUeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:34:19 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:37398 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932739Ab1KIUd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:33:57 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 07/10] TTY: serial, inline uart_get
Date: Wed,  9 Nov 2011 21:33:49 +0100
Message-Id: <1320870831-23778-7-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320870831-23778-1-git-send-email-jslaby@suse.cz>
References: <1320870831-23778-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to expand uart_get into uart_open. We need it to move on with
conversion to use tty_port_open helper. After we do this, the code
will be much more similar to what tty_port_open does.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/tty/serial/serial_core.c |   66 ++++++++++++-------------------------
 1 files changed, 22 insertions(+), 44 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 4b1dcd3..2ca4df4 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1429,33 +1429,6 @@ static void uart_dtr_rts(struct tty_port *port, int onoff)
 		uart_clear_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
 }
 
-static struct uart_state *uart_get(struct uart_driver *drv, int line)
-{
-	struct uart_state *state;
-	struct tty_port *port;
-	int ret = 0;
-
-	state = drv->state + line;
-	port = &state->port;
-	if (mutex_lock_interruptible(&port->mutex)) {
-		ret = -ERESTARTSYS;
-		goto err;
-	}
-
-	port->count++;
-	if (!state->uart_port || state->uart_port->flags & UPF_DEAD) {
-		ret = -ENXIO;
-		goto err_unlock;
-	}
-	return state;
-
- err_unlock:
-	port->count--;
-	mutex_unlock(&port->mutex);
- err:
-	return ERR_PTR(ret);
-}
-
 /*
  * calls to uart_open are serialised by the BKL in
  *   fs/char_dev.c:chrdev_open()
@@ -1469,26 +1442,29 @@ static struct uart_state *uart_get(struct uart_driver *drv, int line)
 static int uart_open(struct tty_struct *tty, struct file *filp)
 {
 	struct uart_driver *drv = (struct uart_driver *)tty->driver->driver_state;
-	struct uart_state *state;
-	struct tty_port *port;
 	int retval, line = tty->index;
+	struct uart_state *state = drv->state + line;
+	struct tty_port *port = &state->port;
 
 	pr_debug("uart_open(%d) called\n", line);
 
 	/*
-	 * We take the semaphore inside uart_get to guarantee that we won't
-	 * be re-entered while allocating the state structure, or while we
-	 * request any IRQs that the driver may need.  This also has the nice
-	 * side-effect that it delays the action of uart_hangup, so we can
-	 * guarantee that state->port.tty will always contain something
-	 * reasonable.
+	 * We take the semaphore here to guarantee that we won't be re-entered
+	 * while allocating the state structure, or while we request any IRQs
+	 * that the driver may need.  This also has the nice side-effect that
+	 * it delays the action of uart_hangup, so we can guarantee that
+	 * state->port.tty will always contain something reasonable.
 	 */
-	state = uart_get(drv, line);
-	if (IS_ERR(state)) {
-		retval = PTR_ERR(state);
-		goto fail;
+	if (mutex_lock_interruptible(&port->mutex)) {
+		retval = -ERESTARTSYS;
+		goto end;
+	}
+
+	port->count++;
+	if (!state->uart_port || state->uart_port->flags & UPF_DEAD) {
+		retval = -ENXIO;
+		goto err_dec_count;
 	}
-	port = &state->port;
 
 	/*
 	 * Once we set tty->driver_data here, we are guaranteed that
@@ -1505,9 +1481,7 @@ static int uart_open(struct tty_struct *tty, struct file *filp)
 	 */
 	if (tty_hung_up_p(filp)) {
 		retval = -EAGAIN;
-		port->count--;
-		mutex_unlock(&port->mutex);
-		goto fail;
+		goto err_dec_count;
 	}
 
 	/*
@@ -1528,8 +1502,12 @@ static int uart_open(struct tty_struct *tty, struct file *filp)
 	if (retval == 0)
 		retval = tty_port_block_til_ready(port, tty, filp);
 
-fail:
+end:
 	return retval;
+err_dec_count:
+	port->count--;
+	mutex_unlock(&port->mutex);
+	goto end;
 }
 
 static const char *uart_type(struct uart_port *port)
-- 
1.7.7


