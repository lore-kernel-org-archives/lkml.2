Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab2CJW0r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 17:26:47 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab2CJW0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 17:26:45 -0500
Message-ID: <4F5BD51B.7030907@nod.at>
Date: Sat, 10 Mar 2012 23:26:35 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Jiri Slaby <jslaby@suse.cz>, alan@lxorguk.ukuu.org.uk,
        gregkh@linuxfoundation.org
Subject: TTY: tty_port questions
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigADD6A60A30AC0288B708A962"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigADD6A60A30AC0288B708A962
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi!

While moving UML's console driver to tty_port some strange things happene=
d.
So, I have a few questions. :-)

The original driver did not implement tty_operations->hangup().
If I implement it and call tty_port_hangup(), as Alan suggested,
the login fails on all TTYs except tty0.
It fails because the opened TTY returns EIO upon read()/write() after /bi=
n/login
called vhangup().

The call chain is:
vhangup() -> tty_vhangup_self() -> tty_vhangup() -> __tty_hangup()

Within __tty_hangup() something happens that I don't fully understand:

if (cons_filp) {
        if (tty->ops->close)
                for (n =3D 0; n < closecount; n++)
                        tty->ops->close(tty, cons_filp);
} else if (tty->ops->hangup)
        (tty->ops->hangup)(tty);

Login on tty0 works because cons_filp is not NULL and tty->ops->close() i=
s called.
On the other hand login fails on every other TTY because cons_filp remain=
s NULL
and the TTY hangs up.

Is there something missing in my hangup function?

If I omit tty_operations->hangup() and leave it, like the old driver, NUL=
L non-tty0 TTYs cannot
be opened. (getty terminates immediately because it cannot open any TTY.)=

open() retuns -EIO because the TTY_CLOSING is set in tty->flags.

How can this be?

Another fun fact is that the above noted problems do not happen on Debian=
=2E
Because Debian's /bin/login does not call vhangup().

Thanks,
//richard

--
diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index c1cf220..24de04c 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -19,19 +19,29 @@ static irqreturn_t line_interrupt(int irq, void *data=
)
 {
 	struct chan *chan =3D data;
 	struct line *line =3D chan->line;
+	struct tty_struct *tty;
+
+	if (line) {
+		tty =3D tty_port_tty_get(&line->port);
+		chan_interrupt(&line->chan_list, &line->task, tty, irq);
+		tty_kref_put(tty);
+	}

-	if (line)
-		chan_interrupt(&line->chan_list, &line->task, line->tty, irq);
 	return IRQ_HANDLED;
 }

 static void line_timer_cb(struct work_struct *work)
 {
 	struct line *line =3D container_of(work, struct line, task.work);
+	struct tty_struct *tty;

-	if (!line->throttled)
-		chan_interrupt(&line->chan_list, &line->task, line->tty,
+	if (!line->throttled) {
+		tty =3D tty_port_tty_get(&line->port);
+		chan_interrupt(&line->chan_list, &line->task, tty,
 			       line->driver->read_irq);
+
+		tty_kref_put(tty);
+	}
 }

 /*
@@ -343,7 +353,7 @@ static irqreturn_t line_write_interrupt(int irq, void=
 *data)
 {
 	struct chan *chan =3D data;
 	struct line *line =3D chan->line;
-	struct tty_struct *tty =3D line->tty;
+	struct tty_struct *tty =3D tty_port_tty_get(&line->port);
 	int err;

 	/*
@@ -354,6 +364,7 @@ static irqreturn_t line_write_interrupt(int irq, void=
 *data)
 	spin_lock(&line->lock);
 	err =3D flush_buffer(line);
 	if (err =3D=3D 0) {
+		tty_kref_put(tty);
 		return IRQ_NONE;
 	} else if (err < 0) {
 		line->head =3D line->buffer;
@@ -365,9 +376,36 @@ static irqreturn_t line_write_interrupt(int irq, voi=
d *data)
 		return IRQ_NONE;

 	tty_wakeup(tty);
+	tty_kref_put(tty);
 	return IRQ_HANDLED;
 }

+static int line_activate(struct tty_port *port, struct tty_struct *tty)
+{
+	int ret;
+	struct line *line =3D tty->driver_data;
+
+	ret =3D enable_chan(line);
+	if (ret)
+		return ret;
+
+	INIT_DELAYED_WORK(&line->task, line_timer_cb);
+
+	if (!line->sigio) {
+		chan_enable_winch(&line->chan_list, tty);
+		line->sigio =3D 1;
+	}
+
+	chan_window_size(&line->chan_list, &tty->winsize.ws_row,
+			 &tty->winsize.ws_col);
+
+	return 0;
+}
+
+static const struct tty_port_operations line_port_ops =3D {
+	.activate =3D line_activate,
+};
+
 int line_setup_irq(int fd, int input, int output, struct line *line, voi=
d *data)
 {
 	const struct line_driver *driver =3D line->driver;
@@ -404,81 +442,49 @@ int line_setup_irq(int fd, int input, int output, s=
truct line *line, void *data)
  * first open or last close.  Otherwise, open and close just return.
  */

-int line_open(struct line *lines, struct tty_struct *tty)
+int line_open(struct tty_struct *tty, struct file *filp)
 {
-	struct line *line =3D &lines[tty->index];
-	int err =3D -ENODEV;
+	struct line *line =3D tty->driver_data;
+	return tty_port_open(&line->port, tty, filp);
+}

-	spin_lock(&line->count_lock);
-	if (!line->valid)
-		goto out_unlock;
+int line_install(struct tty_driver *driver, struct tty_struct *tty, stru=
ct line *line)
+{
+	int ret =3D tty_init_termios(tty);
+	if (ret)
+		return ret;

-	err =3D 0;
-	if (line->count++)
-		goto out_unlock;
+	tty_driver_kref_get(driver);
+	tty->count++;
+	driver->ttys[tty->index] =3D tty;

-	BUG_ON(tty->driver_data);
 	tty->driver_data =3D line;
-	line->tty =3D tty;
-
-	spin_unlock(&line->count_lock);
-	err =3D enable_chan(line);
-	if (err) /* line_close() will be called by our caller */
-		return err;
-
-	INIT_DELAYED_WORK(&line->task, line_timer_cb);
-
-	if (!line->sigio) {
-		chan_enable_winch(&line->chan_list, tty);
-		line->sigio =3D 1;
-	}
-
-	chan_window_size(&line->chan_list, &tty->winsize.ws_row,
-			 &tty->winsize.ws_col);

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
 	struct line *line =3D tty->driver_data;

-	/*
-	 * If line_open fails (and tty->driver_data is never set),
-	 * tty_open will call line_close.  So just return in this case.
-	 */
-	if (line =3D=3D NULL)
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
-	line->tty =3D NULL;
-	tty->driver_data =3D NULL;
-
-	spin_unlock(&line->count_lock);
-
 	if (line->sigio) {
 		unregister_winch(tty);
 		line->sigio =3D 0;
 	}
+}

-	return;
+void line_close(struct tty_struct *tty, struct file * filp)
+{
+	struct line *line =3D tty->driver_data;
+	tty_port_close(&line->port, tty, filp);
+}

-out_unlock:
-	spin_unlock(&line->count_lock);
+void line_hangup(struct tty_struct *tty)
+{
+	struct line *line =3D tty->driver_data;
+	tty_port_hangup(&line->port);
 }

 void close_lines(struct line *lines, int nlines)
@@ -495,13 +501,6 @@ static int setup_one_line(struct line *lines, int n,=
 char *init, int init_prio,
 	struct line *line =3D &lines[n];
 	int err =3D -EINVAL;

-	spin_lock(&line->count_lock);
-
-	if (line->count) {
-		*error_out =3D "Device is already open";
-		goto out;
-	}
-
 	if (line->init_pri <=3D init_prio) {
 		line->init_pri =3D init_prio;
 		if (!strcmp(init, "none"))
@@ -512,8 +511,7 @@ static int setup_one_line(struct line *lines, int n, =
char *init, int init_prio,
 		}
 	}
 	err =3D 0;
-out:
-	spin_unlock(&line->count_lock);
+
 	return err;
 }

@@ -598,6 +596,7 @@ int line_get_config(char *name, struct line *lines, u=
nsigned int num, char *str,
 	struct line *line;
 	char *end;
 	int dev, n =3D 0;
+	struct tty_struct *tty;

 	dev =3D simple_strtoul(name, &end, 0);
 	if ((*end !=3D '\0') || (end =3D=3D name)) {
@@ -612,13 +611,15 @@ int line_get_config(char *name, struct line *lines,=
 unsigned int num, char *str,

 	line =3D &lines[dev];

-	spin_lock(&line->count_lock);
+	tty =3D tty_port_tty_get(&line->port);
+
 	if (!line->valid)
 		CONFIG_CHUNK(str, size, n, "none", 1);
-	else if (line->tty =3D=3D NULL)
+	else if (tty =3D=3D NULL)
 		CONFIG_CHUNK(str, size, n, line->init_str, 1);
 	else n =3D chan_config_string(&line->chan_list, str, size, error_out);
-	spin_unlock(&line->count_lock);
+
+	tty_kref_put(tty);

 	return n;
 }
@@ -678,8 +679,8 @@ struct tty_driver *register_lines(struct line_driver =
*line_driver,
 	}

 	for(i =3D 0; i < nlines; i++) {
-		if (!lines[i].valid)
-			tty_unregister_device(driver, i);
+		tty_port_init(&lines[i].port);
+		lines[i].port.ops =3D &line_port_ops;
 	}

 	mconsole_register_dev(&line_driver->mc);
@@ -805,7 +806,6 @@ void register_winch_irq(int fd, int tty_fd, int pid, =
struct tty_struct *tty,
 				   .pid  	=3D pid,
 				   .tty 	=3D tty,
 				   .stack	=3D stack });
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
-	{ .count_lock =3D	__SPIN_LOCK_UNLOCKED((str).count_lock), \
-	  .init_str =3D	str,	\
+	{ .init_str =3D	str,	\
 	  .init_pri =3D	INIT_STATIC, \
 	  .valid =3D	1, \
 	  .lock =3D	__SPIN_LOCK_UNLOCKED((str).lock), \
 	  .driver =3D	d }

 extern void line_close(struct tty_struct *tty, struct file * filp);
-extern int line_open(struct line *lines, struct tty_struct *tty);
+extern int line_open(struct tty_struct *tty, struct file *filp);
+extern int line_install(struct tty_driver *driver, struct tty_struct *tt=
y, struct line *line);
+extern void line_cleanup(struct tty_struct *tty);
+extern void line_hangup(struct tty_struct *tty);
 extern int line_setup(struct line *lines, unsigned int sizeof_lines,
 		      char *init, char **error_out);
 extern int line_write(struct tty_struct *tty, const unsigned char *buf,
diff --git a/arch/um/drivers/ssl.c b/arch/um/drivers/ssl.c
index 9d8c20a..89fdecb 100644
--- a/arch/um/drivers/ssl.c
+++ b/arch/um/drivers/ssl.c
@@ -92,17 +92,6 @@ static int ssl_remove(int n, char **error_out)
 			   error_out);
 }

-static int ssl_open(struct tty_struct *tty, struct file *filp)
-{
-	int err =3D line_open(serial_lines, tty);
-
-	if (err)
-		printk(KERN_ERR "Failed to open serial line %d, err =3D %d\n",
-		       tty->index, err);
-
-	return err;
-}
-
 #if 0
 static void ssl_flush_buffer(struct tty_struct *tty)
 {
@@ -124,8 +113,13 @@ void ssl_hangup(struct tty_struct *tty)
 }
 #endif

+static int ssl_install(struct tty_driver *driver, struct tty_struct *tty=
)
+{
+	return line_install(driver, tty, &serial_lines[tty->index]);
+}
+
 static const struct tty_operations ssl_ops =3D {
-	.open 	 		=3D ssl_open,
+	.open 	 		=3D line_open,
 	.close 	 		=3D line_close,
 	.write 	 		=3D line_write,
 	.put_char 		=3D line_put_char,
@@ -134,9 +128,12 @@ static const struct tty_operations ssl_ops =3D {
 	.flush_buffer 		=3D line_flush_buffer,
 	.flush_chars 		=3D line_flush_chars,
 	.set_termios 		=3D line_set_termios,
-	.ioctl 	 		=3D line_ioctl,
+	.ioctl			=3D line_ioctl,
 	.throttle 		=3D line_throttle,
 	.unthrottle 		=3D line_unthrottle,
+	.install		=3D ssl_install,
+	.cleanup		=3D line_cleanup,
+	.hangup			=3D line_hangup,
 #if 0
 	.stop 	 		=3D ssl_stop,
 	.start 	 		=3D ssl_start,
diff --git a/arch/um/drivers/stdio_console.c b/arch/um/drivers/stdio_cons=
ole.c
index 088776f..4c78c78 100644
--- a/arch/um/drivers/stdio_console.c
+++ b/arch/um/drivers/stdio_console.c
@@ -97,7 +97,7 @@ static int con_remove(int n, char **error_out)

 static int con_open(struct tty_struct *tty, struct file *filp)
 {
-	int err =3D line_open(vts, tty);
+	int err =3D line_open(tty, filp);
 	if (err)
 		printk(KERN_ERR "Failed to open console %d, err =3D %d\n",
 		       tty->index, err);
@@ -105,11 +105,17 @@ static int con_open(struct tty_struct *tty, struct =
file *filp)
 	return err;
 }

+static int con_install(struct tty_driver *driver, struct tty_struct *tty=
)
+{
+	return line_install(driver, tty, &vts[tty->index]);
+}
+
 /* Set in an initcall, checked in an exitcall */
 static int con_init_done =3D 0;

 static const struct tty_operations console_ops =3D {
 	.open 	 		=3D con_open,
+	.install		=3D con_install,
 	.close 	 		=3D line_close,
 	.write 	 		=3D line_write,
 	.put_char 		=3D line_put_char,
@@ -121,6 +127,8 @@ static const struct tty_operations console_ops =3D {
 	.ioctl 	 		=3D line_ioctl,
 	.throttle 		=3D line_throttle,
 	.unthrottle 		=3D line_unthrottle,
+	.cleanup		=3D line_cleanup,
+	.hangup			=3D line_hangup,
 };

 static void uml_console_write(struct console *console, const char *strin=
g,


--------------enigADD6A60A30AC0288B708A962
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPW9UbAAoJEN9758yqZn9e7oQH/1hXZlrHwPX8QtFOxEicLuEI
2KAzPGsm7IH3CCOGQC24yJq7KOGbInxDkvNFj9FtkWWRtDOk9fM1sP+Jz3K3DTza
AqzIZ4BujyrF1NMp8lFXbcRAtjNbfbuKLuZcah5oTWuSWa2G/AmDSaiBWWU5+vhp
jtHiIJGxXBaeKRX80QRILXXB6qAVnpgaW3kZdKWBgqxvcewPDUZmOFlW1KQngGgV
OIAE6jJFVTzS2CyfnVWnPTSpxjL/GK7CuMXh1PeacsJN++XCXda5HNAUqNLT8bqv
5eCqkxjuIqxTOwRxRGLzFl23EpCGckv/KWJzTuJhYgQ431FFtu3DeVeS3pyEQM0=
=9nF5
-----END PGP SIGNATURE-----

--------------enigADD6A60A30AC0288B708A962--
