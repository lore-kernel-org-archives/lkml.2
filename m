Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab2BLAV1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 19:21:27 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175Ab2BLAVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 19:21:25 -0500
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: user-mode-linux-devel@lists.sourceforge.net, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        gregkh@linuxfoundation.org, Richard Weinberger <richard@nod.at>
Subject: 
Date: Sun, 12 Feb 2012 01:21:10 +0100
Message-Id: <1329006070-4275-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you please review this patch?

Thanks,
//richard

---
>From d8f5e7953def150bcc1e6a39dbbe589f1c68bcbd Mon Sep 17 00:00:00 2001
From: Richard Weinberger <richard@nod.at>
Date: Sun, 12 Feb 2012 01:12:49 +0100
Subject: [PATCH] um: Use tty_port

UML's line driver has to use tty_port.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/drivers/line.c          |  212 +++++++++++---------------------------
 arch/um/drivers/line.h          |   13 ++-
 arch/um/drivers/ssl.c           |   16 +++-
 arch/um/drivers/stdio_console.c |   14 ++-
 4 files changed, 94 insertions(+), 161 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index c1cf220..c789748 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -19,19 +19,29 @@ static irqreturn_t line_interrupt(int irq, void *data)
 {
 	struct chan *chan = data;
 	struct line *line = chan->line;
+	struct tty_struct *tty;
+
+	if (line) {
+		tty = tty_port_tty_get(&line->port);
+		chan_interrupt(&line->chan_list, &line->task, tty, irq);
+		tty_kref_put(tty);
+	}
 
-	if (line)
-		chan_interrupt(&line->chan_list, &line->task, line->tty, irq);
 	return IRQ_HANDLED;
 }
 
 static void line_timer_cb(struct work_struct *work)
 {
 	struct line *line = container_of(work, struct line, task.work);
+	struct tty_struct *tty;
 
-	if (!line->throttled)
-		chan_interrupt(&line->chan_list, &line->task, line->tty,
+	if (!line->throttled) {
+		tty = tty_port_tty_get(&line->port);
+		chan_interrupt(&line->chan_list, &line->task, tty,
 			       line->driver->read_irq);
+
+		tty_kref_put(tty);
+	}
 }
 
 /*
@@ -228,92 +238,6 @@ void line_set_termios(struct tty_struct *tty, struct ktermios * old)
 	/* nothing */
 }
 
-static const struct {
-	int  cmd;
-	char *level;
-	char *name;
-} tty_ioctls[] = {
-	/* don't print these, they flood the log ... */
-	{ TCGETS,      NULL,       "TCGETS"      },
-	{ TCSETS,      NULL,       "TCSETS"      },
-	{ TCSETSW,     NULL,       "TCSETSW"     },
-	{ TCFLSH,      NULL,       "TCFLSH"      },
-	{ TCSBRK,      NULL,       "TCSBRK"      },
-
-	/* general tty stuff */
-	{ TCSETSF,     KERN_DEBUG, "TCSETSF"     },
-	{ TCGETA,      KERN_DEBUG, "TCGETA"      },
-	{ TIOCMGET,    KERN_DEBUG, "TIOCMGET"    },
-	{ TCSBRKP,     KERN_DEBUG, "TCSBRKP"     },
-	{ TIOCMSET,    KERN_DEBUG, "TIOCMSET"    },
-
-	/* linux-specific ones */
-	{ TIOCLINUX,   KERN_INFO,  "TIOCLINUX"   },
-	{ KDGKBMODE,   KERN_INFO,  "KDGKBMODE"   },
-	{ KDGKBTYPE,   KERN_INFO,  "KDGKBTYPE"   },
-	{ KDSIGACCEPT, KERN_INFO,  "KDSIGACCEPT" },
-};
-
-int line_ioctl(struct tty_struct *tty, unsigned int cmd,
-				unsigned long arg)
-{
-	int ret;
-	int i;
-
-	ret = 0;
-	switch(cmd) {
-#ifdef TIOCGETP
-	case TIOCGETP:
-	case TIOCSETP:
-	case TIOCSETN:
-#endif
-#ifdef TIOCGETC
-	case TIOCGETC:
-	case TIOCSETC:
-#endif
-#ifdef TIOCGLTC
-	case TIOCGLTC:
-	case TIOCSLTC:
-#endif
-	/* Note: these are out of date as we now have TCGETS2 etc but this
-	   whole lot should probably go away */
-	case TCGETS:
-	case TCSETSF:
-	case TCSETSW:
-	case TCSETS:
-	case TCGETA:
-	case TCSETAF:
-	case TCSETAW:
-	case TCSETA:
-	case TCXONC:
-	case TCFLSH:
-	case TIOCOUTQ:
-	case TIOCINQ:
-	case TIOCGLCKTRMIOS:
-	case TIOCSLCKTRMIOS:
-	case TIOCPKT:
-	case TIOCGSOFTCAR:
-	case TIOCSSOFTCAR:
-		return -ENOIOCTLCMD;
-#if 0
-	case TCwhatever:
-		/* do something */
-		break;
-#endif
-	default:
-		for (i = 0; i < ARRAY_SIZE(tty_ioctls); i++)
-			if (cmd == tty_ioctls[i].cmd)
-				break;
-		if (i == ARRAY_SIZE(tty_ioctls)) {
-			printk(KERN_ERR "%s: %s: unknown ioctl: 0x%x\n",
-			       __func__, tty->name, cmd);
-		}
-		ret = -ENOIOCTLCMD;
-		break;
-	}
-	return ret;
-}
-
 void line_throttle(struct tty_struct *tty)
 {
 	struct line *line = tty->driver_data;
@@ -343,7 +267,7 @@ static irqreturn_t line_write_interrupt(int irq, void *data)
 {
 	struct chan *chan = data;
 	struct line *line = chan->line;
-	struct tty_struct *tty = line->tty;
+	struct tty_struct *tty = tty_port_tty_get(&line->port);
 	int err;
 
 	/*
@@ -354,6 +278,9 @@ static irqreturn_t line_write_interrupt(int irq, void *data)
 	spin_lock(&line->lock);
 	err = flush_buffer(line);
 	if (err == 0) {
+		tty_kref_put(tty);
+
+		spin_unlock(&line->lock);
 		return IRQ_NONE;
 	} else if (err < 0) {
 		line->head = line->buffer;
@@ -365,9 +292,12 @@ static irqreturn_t line_write_interrupt(int irq, void *data)
 		return IRQ_NONE;
 
 	tty_wakeup(tty);
+	tty_kref_put(tty);
 	return IRQ_HANDLED;
 }
 
+static const struct tty_port_operations line_port_ops;
+
 int line_setup_irq(int fd, int input, int output, struct line *line, void *data)
 {
 	const struct line_driver *driver = line->driver;
@@ -404,27 +334,27 @@ int line_setup_irq(int fd, int input, int output, struct line *line, void *data)
  * first open or last close.  Otherwise, open and close just return.
  */
 
-int line_open(struct line *lines, struct tty_struct *tty)
+int line_open(struct tty_struct *tty, struct file *filp)
 {
-	struct line *line = &lines[tty->index];
-	int err = -ENODEV;
+	struct line *line = tty->driver_data;
+	return tty_port_open(&line->port, tty, filp);
+}
 
-	spin_lock(&line->count_lock);
-	if (!line->valid)
-		goto out_unlock;
+int line_install(struct tty_driver *driver, struct tty_struct *tty, struct line *line)
+{
+	int ret = tty_init_termios(tty);
 
-	err = 0;
-	if (line->count++)
-		goto out_unlock;
+	if (ret)
+		return ret;
 
-	BUG_ON(tty->driver_data);
+	tty_driver_kref_get(driver);
+	tty->count++;
 	tty->driver_data = line;
-	line->tty = tty;
+	driver->ttys[tty->index] = tty;
 
-	spin_unlock(&line->count_lock);
-	err = enable_chan(line);
-	if (err) /* line_close() will be called by our caller */
-		return err;
+	ret = enable_chan(line);
+	if (ret)
+		return ret;
 
 	INIT_DELAYED_WORK(&line->task, line_timer_cb);
 
@@ -437,48 +367,36 @@ int line_open(struct line *lines, struct tty_struct *tty)
 			 &tty->winsize.ws_col);
 
 	return 0;
-
-out_unlock:
-	spin_unlock(&line->count_lock);
-	return err;
 }
 
 static void unregister_winch(struct tty_struct *tty);
 
-void line_close(struct tty_struct *tty, struct file * filp)
+void line_cleanup(struct tty_struct *tty)
 {
 	struct line *line = tty->driver_data;
 
-	/*
-	 * If line_open fails (and tty->driver_data is never set),
-	 * tty_open will call line_close.  So just return in this case.
-	 */
-	if (line == NULL)
-		return;
-
-	/* We ignore the error anyway! */
-	flush_buffer(line);
-
-	spin_lock(&line->count_lock);
-	BUG_ON(!line->valid);
-
-	if (--line->count)
-		goto out_unlock;
-
-	line->tty = NULL;
-	tty->driver_data = NULL;
-
-	spin_unlock(&line->count_lock);
-
 	if (line->sigio) {
 		unregister_winch(tty);
 		line->sigio = 0;
 	}
 
-	return;
+	tty->driver_data = NULL;
+}
+
+void line_close(struct tty_struct *tty, struct file * filp)
+{
+	struct line *line = tty->driver_data;
+
+	if (!line)
+		return;
+
+	tty_port_close(&line->port, tty, filp);
+}
 
-out_unlock:
-	spin_unlock(&line->count_lock);
+void line_hangup(struct tty_struct *tty)
+{
+	struct line *line = tty->driver_data;
+	tty_port_hangup(&line->port);
 }
 
 void close_lines(struct line *lines, int nlines)
@@ -495,13 +413,6 @@ static int setup_one_line(struct line *lines, int n, char *init, int init_prio,
 	struct line *line = &lines[n];
 	int err = -EINVAL;
 
-	spin_lock(&line->count_lock);
-
-	if (line->count) {
-		*error_out = "Device is already open";
-		goto out;
-	}
-
 	if (line->init_pri <= init_prio) {
 		line->init_pri = init_prio;
 		if (!strcmp(init, "none"))
@@ -512,8 +423,7 @@ static int setup_one_line(struct line *lines, int n, char *init, int init_prio,
 		}
 	}
 	err = 0;
-out:
-	spin_unlock(&line->count_lock);
+
 	return err;
 }
 
@@ -598,6 +508,7 @@ int line_get_config(char *name, struct line *lines, unsigned int num, char *str,
 	struct line *line;
 	char *end;
 	int dev, n = 0;
+	struct tty_struct *tty;
 
 	dev = simple_strtoul(name, &end, 0);
 	if ((*end != '\0') || (end == name)) {
@@ -612,13 +523,15 @@ int line_get_config(char *name, struct line *lines, unsigned int num, char *str,
 
 	line = &lines[dev];
 
-	spin_lock(&line->count_lock);
+	tty = tty_port_tty_get(&line->port);
+
 	if (!line->valid)
 		CONFIG_CHUNK(str, size, n, "none", 1);
-	else if (line->tty == NULL)
+	else if (tty == NULL)
 		CONFIG_CHUNK(str, size, n, line->init_str, 1);
 	else n = chan_config_string(&line->chan_list, str, size, error_out);
-	spin_unlock(&line->count_lock);
+
+	tty_kref_put(tty);
 
 	return n;
 }
@@ -678,8 +591,8 @@ struct tty_driver *register_lines(struct line_driver *line_driver,
 	}
 
 	for(i = 0; i < nlines; i++) {
-		if (!lines[i].valid)
-			tty_unregister_device(driver, i);
+		tty_port_init(&lines[i].port);
+		lines[i].port.ops = &line_port_ops;
 	}
 
 	mconsole_register_dev(&line_driver->mc);
@@ -805,7 +718,6 @@ void register_winch_irq(int fd, int tty_fd, int pid, struct tty_struct *tty,
 				   .pid  	= pid,
 				   .tty 	= tty,
 				   .stack	= stack });
-
 	if (um_request_irq(WINCH_IRQ, fd, IRQ_READ, winch_interrupt,
 			   IRQF_DISABLED | IRQF_SHARED | IRQF_SAMPLE_RANDOM,
 			   "winch", winch) < 0) {
diff --git a/arch/um/drivers/line.h b/arch/um/drivers/line.h
index 63df3ca..54adfc6 100644
--- a/arch/um/drivers/line.h
+++ b/arch/um/drivers/line.h
@@ -31,9 +31,8 @@ struct line_driver {
 };
 
 struct line {
-	struct tty_struct *tty;
-	spinlock_t count_lock;
-	unsigned long count;
+	struct tty_port port;
+
 	int valid;
 
 	char *init_str;
@@ -59,15 +58,17 @@ struct line {
 };
 
 #define LINE_INIT(str, d) \
-	{ .count_lock =	__SPIN_LOCK_UNLOCKED((str).count_lock), \
-	  .init_str =	str,	\
+	{ .init_str =	str,	\
 	  .init_pri =	INIT_STATIC, \
 	  .valid =	1, \
 	  .lock =	__SPIN_LOCK_UNLOCKED((str).lock), \
 	  .driver =	d }
 
 extern void line_close(struct tty_struct *tty, struct file * filp);
-extern int line_open(struct line *lines, struct tty_struct *tty);
+extern int line_open(struct tty_struct *tty, struct file *filp);
+extern int line_install(struct tty_driver *driver, struct tty_struct *tty, struct line *line);
+extern void line_cleanup(struct tty_struct *tty);
+extern void line_hangup(struct tty_struct *tty);
 extern int line_setup(struct line *lines, unsigned int sizeof_lines,
 		      char *init, char **error_out);
 extern int line_write(struct tty_struct *tty, const unsigned char *buf,
diff --git a/arch/um/drivers/ssl.c b/arch/um/drivers/ssl.c
index 9d8c20a..89e4e75 100644
--- a/arch/um/drivers/ssl.c
+++ b/arch/um/drivers/ssl.c
@@ -92,6 +92,7 @@ static int ssl_remove(int n, char **error_out)
 			   error_out);
 }
 
+#if 0
 static int ssl_open(struct tty_struct *tty, struct file *filp)
 {
 	int err = line_open(serial_lines, tty);
@@ -103,7 +104,6 @@ static int ssl_open(struct tty_struct *tty, struct file *filp)
 	return err;
 }
 
-#if 0
 static void ssl_flush_buffer(struct tty_struct *tty)
 {
 	return;
@@ -124,8 +124,16 @@ void ssl_hangup(struct tty_struct *tty)
 }
 #endif
 
+static int ssl_install(struct tty_driver *driver, struct tty_struct *tty)
+{
+	if (tty->index < NR_PORTS)
+		return line_install(driver, tty, &serial_lines[tty->index]);
+	else
+		return -ENODEV;
+}
+
 static const struct tty_operations ssl_ops = {
-	.open 	 		= ssl_open,
+	.open 	 		= line_open,
 	.close 	 		= line_close,
 	.write 	 		= line_write,
 	.put_char 		= line_put_char,
@@ -134,9 +142,11 @@ static const struct tty_operations ssl_ops = {
 	.flush_buffer 		= line_flush_buffer,
 	.flush_chars 		= line_flush_chars,
 	.set_termios 		= line_set_termios,
-	.ioctl 	 		= line_ioctl,
 	.throttle 		= line_throttle,
 	.unthrottle 		= line_unthrottle,
+	.install		= ssl_install,
+	.cleanup		= line_cleanup,
+	.hangup			= line_hangup,
 #if 0
 	.stop 	 		= ssl_stop,
 	.start 	 		= ssl_start,
diff --git a/arch/um/drivers/stdio_console.c b/arch/um/drivers/stdio_console.c
index 088776f..014f3ee 100644
--- a/arch/um/drivers/stdio_console.c
+++ b/arch/um/drivers/stdio_console.c
@@ -97,7 +97,7 @@ static int con_remove(int n, char **error_out)
 
 static int con_open(struct tty_struct *tty, struct file *filp)
 {
-	int err = line_open(vts, tty);
+	int err = line_open(tty, filp);
 	if (err)
 		printk(KERN_ERR "Failed to open console %d, err = %d\n",
 		       tty->index, err);
@@ -105,6 +105,14 @@ static int con_open(struct tty_struct *tty, struct file *filp)
 	return err;
 }
 
+static int con_install(struct tty_driver *driver, struct tty_struct *tty)
+{
+	if (tty->index < MAX_TTYS)
+		return line_install(driver, tty, &vts[tty->index]);
+	else
+		return -ENODEV;
+}
+
 /* Set in an initcall, checked in an exitcall */
 static int con_init_done = 0;
 
@@ -118,9 +126,11 @@ static const struct tty_operations console_ops = {
 	.flush_buffer 		= line_flush_buffer,
 	.flush_chars 		= line_flush_chars,
 	.set_termios 		= line_set_termios,
-	.ioctl 	 		= line_ioctl,
 	.throttle 		= line_throttle,
 	.unthrottle 		= line_unthrottle,
+	.cleanup		= line_cleanup,
+	.install		= con_install,
+	.hangup			= line_hangup,
 };
 
 static void uml_console_write(struct console *console, const char *string,
-- 
1.7.7.3

