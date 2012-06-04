Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab2FDU14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 16:27:56 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47839 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab2FDU1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 16:27:54 -0400
From: Richard Weinberger <richard@nod.at>
To: jslaby@suse.cz
Cc: user-mode-linux-devel@lists.sourceforge.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        alan@linux.intel.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 5/6] um: fully use tty_port
Date: Mon,  4 Jun 2012 22:27:36 +0200
Message-Id: <1338841657-30358-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1338841657-30358-1-git-send-email-richard@nod.at>
References: <1338841657-30358-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... use all tty_port helpers

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/drivers/line.c          |  102 +++++++++++++++++----------------------
 arch/um/drivers/line.h          |    6 ++-
 arch/um/drivers/ssl.c           |   15 ++----
 arch/um/drivers/stdio_console.c |   20 ++++----
 4 files changed, 65 insertions(+), 78 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 131129a..95d5e78 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -296,43 +296,14 @@ int line_setup_irq(int fd, int input, int output, struct line *line, void *data)
 	return err;
 }
 
-/*
- * Normally, a driver like this can rely mostly on the tty layer
- * locking, particularly when it comes to the driver structure.
- * However, in this case, mconsole requests can come in "from the
- * side", and race with opens and closes.
- *
- * mconsole config requests will want to be sure the device isn't in
- * use, and get_config, open, and close will want a stable
- * configuration.  The checking and modification of the configuration
- * is done under a spinlock.  Checking whether the device is in use is
- * line->tty->count > 1, also under the spinlock.
- *
- * line->count serves to decide whether the device should be enabled or
- * disabled on the host.  If it's equal to 0, then we are doing the
- * first open or last close.  Otherwise, open and close just return.
- */
-
-int line_open(struct line *lines, struct tty_struct *tty)
+static int line_activate(struct tty_port *port, struct tty_struct *tty)
 {
-	struct line *line = &lines[tty->index];
-	int err = -ENODEV;
-
-	mutex_lock(&line->count_lock);
-	if (!line->valid)
-		goto out_unlock;
-
-	err = 0;
-	if (line->port.count++)
-		goto out_unlock;
-
-	BUG_ON(tty->driver_data);
-	tty->driver_data = line;
-	tty_port_tty_set(&line->port, tty);
+	int ret;
+	struct line *line = tty->driver_data;
 
-	err = enable_chan(line);
-	if (err) /* line_close() will be called by our caller */
-		goto out_unlock;
+	ret = enable_chan(line);
+	if (ret)
+		return ret;
 
 	if (!line->sigio) {
 		chan_enable_winch(line->chan_out, tty);
@@ -340,44 +311,60 @@ int line_open(struct line *lines, struct tty_struct *tty)
 	}
 
 	chan_window_size(line, &tty->winsize.ws_row,
-			 &tty->winsize.ws_col);
-out_unlock:
-	mutex_unlock(&line->count_lock);
-	return err;
+		&tty->winsize.ws_col);
+
+	return 0;
 }
 
-static void unregister_winch(struct tty_struct *tty);
+static const struct tty_port_operations line_port_ops = {
+	.activate = line_activate,
+};
 
-void line_close(struct tty_struct *tty, struct file * filp)
+int line_open(struct tty_struct *tty, struct file *filp)
 {
 	struct line *line = tty->driver_data;
 
-	/*
-	 * If line_open fails (and tty->driver_data is never set),
-	 * tty_open will call line_close.  So just return in this case.
-	 */
-	if (line == NULL)
-		return;
+	return tty_port_open(&line->port, tty, filp);
+}
 
-	/* We ignore the error anyway! */
-	flush_buffer(line);
+int line_install(struct tty_driver *driver, struct tty_struct *tty,
+		 struct line *line)
+{
+	int ret;
 
-	mutex_lock(&line->count_lock);
-	BUG_ON(!line->valid);
+	ret = tty_standard_install(driver, tty);
+	if (ret)
+		return ret;
+
+	tty->driver_data = line;
 
-	if (--line->port.count)
-		goto out_unlock;
+	return 0;
+}
+
+static void unregister_winch(struct tty_struct *tty);
 
-	tty_port_tty_set(&line->port, NULL);
-	tty->driver_data = NULL;
+void line_cleanup(struct tty_struct *tty)
+{
+	struct line *line = tty->driver_data;
 
 	if (line->sigio) {
 		unregister_winch(tty);
 		line->sigio = 0;
 	}
+}
 
-out_unlock:
-	mutex_unlock(&line->count_lock);
+void line_close(struct tty_struct *tty, struct file * filp)
+{
+	struct line *line = tty->driver_data;
+
+	tty_port_close(&line->port, tty, filp);
+}
+
+void line_hangup(struct tty_struct *tty)
+{
+	struct line *line = tty->driver_data;
+
+	tty_port_hangup(&line->port);
 }
 
 void close_lines(struct line *lines, int nlines)
@@ -589,6 +576,7 @@ int register_lines(struct line_driver *line_driver,
 	
 	for (i = 0; i < nlines; i++) {
 		tty_port_init(&lines[i].port);
+		lines[i].port.ops = &line_port_ops;
 		spin_lock_init(&lines[i].lock);
 		mutex_init(&lines[i].count_lock);
 		lines[i].driver = line_driver;
diff --git a/arch/um/drivers/line.h b/arch/um/drivers/line.h
index 6c3b252..ad00f3e 100644
--- a/arch/um/drivers/line.h
+++ b/arch/um/drivers/line.h
@@ -58,7 +58,11 @@ struct line {
 };
 
 extern void line_close(struct tty_struct *tty, struct file * filp);
-extern int line_open(struct line *lines, struct tty_struct *tty);
+extern int line_open(struct tty_struct *tty, struct file *filp);
+extern int line_install(struct tty_driver *driver, struct tty_struct *tty,
+	struct line *line);
+extern void line_cleanup(struct tty_struct *tty);
+extern void line_hangup(struct tty_struct *tty);
 extern int line_setup(char **conf, unsigned nlines, char **def,
 		      char *init, char *name);
 extern int line_write(struct tty_struct *tty, const unsigned char *buf,
diff --git a/arch/um/drivers/ssl.c b/arch/um/drivers/ssl.c
index cba95d9..7e86f00 100644
--- a/arch/um/drivers/ssl.c
+++ b/arch/um/drivers/ssl.c
@@ -87,19 +87,13 @@ static int ssl_remove(int n, char **error_out)
 			   error_out);
 }
 
-static int ssl_open(struct tty_struct *tty, struct file *filp)
+static int ssl_install(struct tty_driver *driver, struct tty_struct *tty)
 {
-	int err = line_open(serial_lines, tty);
-
-	if (err)
-		printk(KERN_ERR "Failed to open serial line %d, err = %d\n",
-		       tty->index, err);
-
-	return err;
+	return line_install(driver, tty, &serial_lines[tty->index]);
 }
 
 static const struct tty_operations ssl_ops = {
-	.open 	 		= ssl_open,
+	.open 	 		= line_open,
 	.close 	 		= line_close,
 	.write 	 		= line_write,
 	.put_char 		= line_put_char,
@@ -110,6 +104,9 @@ static const struct tty_operations ssl_ops = {
 	.set_termios 		= line_set_termios,
 	.throttle 		= line_throttle,
 	.unthrottle 		= line_unthrottle,
+	.install		= ssl_install,
+	.cleanup		= line_cleanup,
+	.hangup			= line_hangup,
 };
 
 /* Changed by ssl_init and referenced by ssl_exit, which are both serialized
diff --git a/arch/um/drivers/stdio_console.c b/arch/um/drivers/stdio_console.c
index 5cefdba..929b99a 100644
--- a/arch/um/drivers/stdio_console.c
+++ b/arch/um/drivers/stdio_console.c
@@ -89,21 +89,17 @@ static int con_remove(int n, char **error_out)
 	return line_remove(vts, ARRAY_SIZE(vts), n, error_out);
 }
 
-static int con_open(struct tty_struct *tty, struct file *filp)
-{
-	int err = line_open(vts, tty);
-	if (err)
-		printk(KERN_ERR "Failed to open console %d, err = %d\n",
-		       tty->index, err);
-
-	return err;
-}
-
 /* Set in an initcall, checked in an exitcall */
 static int con_init_done = 0;
 
+static int con_install(struct tty_driver *driver, struct tty_struct *tty)
+{
+	return line_install(driver, tty, &vts[tty->index]);
+}
+
 static const struct tty_operations console_ops = {
-	.open 	 		= con_open,
+	.open 	 		= line_open,
+	.install		= con_install,
 	.close 	 		= line_close,
 	.write 	 		= line_write,
 	.put_char 		= line_put_char,
@@ -114,6 +110,8 @@ static const struct tty_operations console_ops = {
 	.set_termios 		= line_set_termios,
 	.throttle 		= line_throttle,
 	.unthrottle 		= line_unthrottle,
+	.cleanup		= line_cleanup,
+	.hangup			= line_hangup,
 };
 
 static void uml_console_write(struct console *console, const char *string,
-- 
1.7.7.3

