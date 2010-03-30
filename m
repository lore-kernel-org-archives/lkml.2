Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab0C3U4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:56:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52451 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab0C3U4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:56:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 3/9] tty: make tty_port->mutex nest under tty_lock
Date: Tue, 30 Mar 2010 22:56:14 +0200
Message-Id: <1269982580-9361-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269982580-9361-1-git-send-email-arnd@arndb.de>
References: <1269982580-9361-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/4b4qBgQh258vXIjdxgvLkcj2p9kDU2VA7DL0
 VyGElJPwdIjHE9v2kdbAihOypY55n3SRecjZOLHnBmwe9/I2jD
 e1OgElU3PQJ02IOwYo3AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/mxser.c         |   10 +++++-----
 drivers/char/tty_port.c      |    4 ++--
 drivers/serial/serial_core.c |   32 ++++++++++++++++----------------
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index e0c5d2a..25ff7e6 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -1078,7 +1078,7 @@ static void mxser_close(struct tty_struct *tty, struct file *filp)
 		return;
 	if (tty_port_close_start(port, tty, filp) == 0)
 		return;
-	mutex_lock(&port->mutex);
+	mutex_lock_tty(&port->mutex);
 	mxser_close_port(port);
 	mxser_flush_buffer(tty);
 	mxser_shutdown_port(port);
@@ -1512,7 +1512,7 @@ static int mxser_ioctl_special(unsigned int cmd, void __user *argp)
 				port = &ip->port;
 				memset(&ms, 0, sizeof(ms));
 
-				mutex_lock(&port->mutex);
+				mutex_lock_tty_off(&port->mutex);
 				if (!ip->ioaddr)
 					goto copy;
 				
@@ -1558,7 +1558,7 @@ static int mxser_ioctl_special(unsigned int cmd, void __user *argp)
 				ip = &mxser_boards[i].ports[j];
 				port = &ip->port;
 
-				mutex_lock(&port->mutex);
+				mutex_lock_tty_off(&port->mutex);
 				if (!ip->ioaddr) {
 					mutex_unlock(&port->mutex);
 					continue;
@@ -1705,12 +1705,12 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 
 	switch (cmd) {
 	case TIOCGSERIAL:
-		mutex_lock(&port->mutex);
+		mutex_lock_tty_off(&port->mutex);
 		retval = mxser_get_serial_info(tty, argp);
 		mutex_unlock(&port->mutex);
 		return retval;
 	case TIOCSSERIAL:
-		mutex_lock(&port->mutex);
+		mutex_lock_tty_off(&port->mutex);
 		retval = mxser_set_serial_info(tty, argp);
 		mutex_unlock(&port->mutex);
 		return retval;
diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index a3bd1d0..5ad1446 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -118,7 +118,7 @@ EXPORT_SYMBOL(tty_port_tty_set);
 
 static void tty_port_shutdown(struct tty_port *port)
 {
-	mutex_lock(&port->mutex);
+	mutex_lock_tty(&port->mutex);
 	if (port->ops->shutdown && !port->console &&
 		test_and_clear_bit(ASYNCB_INITIALIZED, &port->flags))
 			port->ops->shutdown(port);
@@ -424,7 +424,7 @@ int tty_port_open(struct tty_port *port, struct tty_struct *tty,
 	 * port mutex.
 	 */
 
-	mutex_lock(&port->mutex);
+	mutex_lock_tty(&port->mutex);
 
 	if (!test_bit(ASYNCB_INITIALIZED, &port->flags)) {
 		clear_bit(TTY_IO_ERROR, &tty->flags);
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 1bc580b..81be0c9 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -647,7 +647,7 @@ static int uart_get_info(struct uart_state *state,
 
 	/* Ensure the state we copy is consistent and no hardware changes
 	   occur as we go */
-	mutex_lock(&port->mutex);
+	mutex_lock_tty_off(&port->mutex);
 
 	tmp.type	    = uport->type;
 	tmp.line	    = uport->line;
@@ -706,7 +706,7 @@ static int uart_set_info(struct uart_state *state,
 	 * module insertion/removal doesn't change anything
 	 * under us.
 	 */
-	mutex_lock(&port->mutex);
+	mutex_lock_tty_off(&port->mutex);
 
 	change_irq  = !(uport->flags & UPF_FIXED_PORT)
 		&& new_serial.irq != uport->irq;
@@ -913,7 +913,7 @@ static int uart_tiocmget(struct tty_struct *tty, struct file *file)
 	struct uart_port *uport = state->uart_port;
 	int result = -EIO;
 
-	mutex_lock(&port->mutex);
+	mutex_lock_tty_off(&port->mutex);
 	if ((!file || !tty_hung_up_p(file)) &&
 	    !(tty->flags & (1 << TTY_IO_ERROR))) {
 		result = uport->mctrl;
@@ -936,7 +936,7 @@ uart_tiocmset(struct tty_struct *tty, struct file *file,
 	struct tty_port *port = &state->port;
 	int ret = -EIO;
 
-	mutex_lock(&port->mutex);
+	mutex_lock_tty_off(&port->mutex);
 	if ((!file || !tty_hung_up_p(file)) &&
 	    !(tty->flags & (1 << TTY_IO_ERROR))) {
 		uart_update_mctrl(uport, set, clear);
@@ -952,7 +952,7 @@ static int uart_break_ctl(struct tty_struct *tty, int break_state)
 	struct tty_port *port = &state->port;
 	struct uart_port *uport = state->uart_port;
 
-	mutex_lock(&port->mutex);
+	mutex_lock_tty_off(&port->mutex);
 
 	if (uport->type != PORT_UNKNOWN)
 		uport->ops->break_ctl(uport, break_state);
@@ -975,7 +975,7 @@ static int uart_do_autoconfig(struct uart_state *state)
 	 * changing, and hence any extra opens of the port while
 	 * we're auto-configuring.
 	 */
-	if (mutex_lock_interruptible(&port->mutex))
+	if (mutex_lock_interruptible_tty(&port->mutex))
 		return -ERESTARTSYS;
 
 	ret = -EBUSY;
@@ -1159,7 +1159,7 @@ uart_ioctl(struct tty_struct *tty, struct file *filp, unsigned int cmd,
 	if (ret != -ENOIOCTLCMD)
 		goto out;
 
-	mutex_lock(&port->mutex);
+	mutex_lock_tty_off(&port->mutex);
 
 	if (tty_hung_up_p(filp)) {
 		ret = -EIO;
@@ -1283,7 +1283,7 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 
 	pr_debug("uart_close(%d) called\n", uport->line);
 
-	mutex_lock(&port->mutex);
+	mutex_lock_tty(&port->mutex);
 
 	if (tty_hung_up_p(filp))
 		goto done;
@@ -1433,7 +1433,7 @@ static void uart_hangup(struct tty_struct *tty)
 	BUG_ON(!tty_locked());
 	pr_debug("uart_hangup(%d)\n", state->uart_port->line);
 
-	mutex_lock(&port->mutex);
+	mutex_lock_tty(&port->mutex);
 	if (port->flags & ASYNC_NORMAL_ACTIVE) {
 		uart_flush_buffer(tty);
 		uart_shutdown(state);
@@ -1547,7 +1547,7 @@ uart_block_til_ready(struct file *filp, struct uart_state *state)
 
 		mutex_unlock(&port->mutex);
 		schedule();
-		mutex_lock(&port->mutex);
+		mutex_lock_tty(&port->mutex);
 
 		if (signal_pending(current))
 			break;
@@ -1575,7 +1575,7 @@ static struct uart_state *uart_get(struct uart_driver *drv, int line)
 
 	state = drv->state + line;
 	port = &state->port;
-	if (mutex_lock_interruptible(&port->mutex)) {
+	if (mutex_lock_interruptible_tty(&port->mutex)) {
 		ret = -ERESTARTSYS;
 		goto err;
 	}
@@ -1732,7 +1732,7 @@ static void uart_line_info(struct seq_file *m, struct uart_driver *drv, int i)
 	}
 
 	if (capable(CAP_SYS_ADMIN)) {
-		mutex_lock(&port->mutex);
+		mutex_lock_tty_off(&port->mutex);
 		pm_state = state->pm_state;
 		if (pm_state)
 			uart_change_pm(state, 0);
@@ -2011,7 +2011,7 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
 	struct device *tty_dev;
 	struct uart_match match = {uport, drv};
 
-	mutex_lock(&port->mutex);
+	mutex_lock_tty(&port->mutex);
 
 	tty_dev = device_find_child(uport->dev, &match, serial_match_port);
 	if (device_may_wakeup(tty_dev)) {
@@ -2077,7 +2077,7 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 	struct uart_match match = {uport, drv};
 	struct ktermios termios;
 
-	mutex_lock(&port->mutex);
+	mutex_lock_tty(&port->mutex);
 
 	tty_dev = device_find_child(uport->dev, &match, serial_match_port);
 	if (!uport->suspended && device_may_wakeup(tty_dev)) {
@@ -2436,7 +2436,7 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 	port = &state->port;
 
 	mutex_lock(&port_mutex);
-	mutex_lock(&port->mutex);
+	mutex_lock_tty(&port->mutex);
 	if (state->uart_port) {
 		ret = -EINVAL;
 		goto out;
@@ -2509,7 +2509,7 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *uport)
 	 * Mark the port "dead" - this prevents any opens from
 	 * succeeding while we shut down the port.
 	 */
-	mutex_lock(&port->mutex);
+	mutex_lock_tty(&port->mutex);
 	uport->flags |= UPF_DEAD;
 	mutex_unlock(&port->mutex);
 
-- 
1.7.0

