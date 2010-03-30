Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab0C3U5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:57:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52849 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab0C3U5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:57:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 4/9] tty: make termios mutex nest under tty_lock
Date: Tue, 30 Mar 2010 22:56:15 +0200
Message-Id: <1269982580-9361-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269982580-9361-1-git-send-email-arnd@arndb.de>
References: <1269982580-9361-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19Bzal5Ditad0bS5y8sNrbWT57AOMnjGxjIyky
 4ONe19bWecC4q5cFLzC4gVb8oIAXT/rF+SIqFDCkCZMHOccBa9
 Me5bnmmK+ol8E+I5TAgPA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/pty.c            |    2 +-
 drivers/char/tty_io.c         |    4 ++--
 drivers/char/tty_ioctl.c      |   34 +++++++++++++++++-----------------
 drivers/char/tty_ldisc.c      |    4 ++--
 drivers/net/irda/irtty-sir.c  |    5 +++--
 drivers/staging/strip/strip.c |    2 +-
 6 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index f02ff21..72fb501 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -231,7 +231,7 @@ int pty_resize(struct tty_struct *tty,  struct winsize *ws)
 	struct tty_struct *pty = tty->link;
 
 	/* For a PTY we need to lock the tty side */
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty_off(&tty->termios_mutex);
 	if (!memcmp(ws, &tty->winsize, sizeof(*ws)))
 		goto done;
 
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index ef21e1d..91cc978 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2028,7 +2028,7 @@ static int tiocgwinsz(struct tty_struct *tty, struct winsize __user *arg)
 {
 	int err;
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty_off(&tty->termios_mutex);
 	err = copy_to_user(arg, &tty->winsize, sizeof(*arg));
 	mutex_unlock(&tty->termios_mutex);
 
@@ -2051,7 +2051,7 @@ int tty_do_resize(struct tty_struct *tty, struct winsize *ws)
 	unsigned long flags;
 
 	/* Lock the tty */
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty_off(&tty->termios_mutex);
 	if (!memcmp(ws, &tty->winsize, sizeof(*ws)))
 		goto done;
 	/* Get the PID values and reference them so we can
diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index 6bd5f88..c9b385e 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -103,7 +103,7 @@ EXPORT_SYMBOL(tty_driver_flush_buffer);
 
 void tty_throttle(struct tty_struct *tty)
 {
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty(&tty->termios_mutex);
 	/* check TTY_THROTTLED first so it indicates our state */
 	if (!test_and_set_bit(TTY_THROTTLED, &tty->flags) &&
 	    tty->ops->throttle)
@@ -127,7 +127,7 @@ EXPORT_SYMBOL(tty_throttle);
 
 void tty_unthrottle(struct tty_struct *tty)
 {
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty(&tty->termios_mutex);
 	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags) &&
 	    tty->ops->unthrottle)
 		tty->ops->unthrottle(tty);
@@ -510,7 +510,7 @@ static void change_termios(struct tty_struct *tty, struct ktermios *new_termios)
 
 	/* FIXME: we need to decide on some locking/ordering semantics
 	   for the set_termios notification eventually */
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty(&tty->termios_mutex);
 	old_termios = *tty->termios;
 	*tty->termios = *new_termios;
 	unset_locked_termios(tty->termios, &old_termios, tty->termios_locked);
@@ -571,7 +571,7 @@ static int set_termios(struct tty_struct *tty, void __user *arg, int opt)
 	if (retval)
 		return retval;
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty(&tty->termios_mutex);
 	memcpy(&tmp_termios, tty->termios, sizeof(struct ktermios));
 	mutex_unlock(&tty->termios_mutex);
 
@@ -625,14 +625,14 @@ static int set_termios(struct tty_struct *tty, void __user *arg, int opt)
 
 static void copy_termios(struct tty_struct *tty, struct ktermios *kterm)
 {
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty(&tty->termios_mutex);
 	memcpy(kterm, tty->termios, sizeof(struct ktermios));
 	mutex_unlock(&tty->termios_mutex);
 }
 
 static void copy_termios_locked(struct tty_struct *tty, struct ktermios *kterm)
 {
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty(&tty->termios_mutex);
 	memcpy(kterm, tty->termios_locked, sizeof(struct ktermios));
 	mutex_unlock(&tty->termios_mutex);
 }
@@ -681,7 +681,7 @@ static int set_termiox(struct tty_struct *tty, void __user *arg, int opt)
 			return -EINTR;
 	}
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty(&tty->termios_mutex);
 	if (tty->ops->set_termiox)
 		tty->ops->set_termiox(tty, &tnew);
 	mutex_unlock(&tty->termios_mutex);
@@ -719,7 +719,7 @@ static int get_sgttyb(struct tty_struct *tty, struct sgttyb __user *sgttyb)
 {
 	struct sgttyb tmp;
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty(&tty->termios_mutex);
 	tmp.sg_ispeed = tty->termios->c_ispeed;
 	tmp.sg_ospeed = tty->termios->c_ospeed;
 	tmp.sg_erase = tty->termios->c_cc[VERASE];
@@ -780,7 +780,7 @@ static int set_sgttyb(struct tty_struct *tty, struct sgttyb __user *sgttyb)
 	if (copy_from_user(&tmp, sgttyb, sizeof(tmp)))
 		return -EFAULT;
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty(&tty->termios_mutex);
 	termios = *tty->termios;
 	termios.c_cc[VERASE] = tmp.sg_erase;
 	termios.c_cc[VKILL] = tmp.sg_kill;
@@ -801,7 +801,7 @@ static int get_tchars(struct tty_struct *tty, struct tchars __user *tchars)
 {
 	struct tchars tmp;
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty(&tty->termios_mutex);
 	tmp.t_intrc = tty->termios->c_cc[VINTR];
 	tmp.t_quitc = tty->termios->c_cc[VQUIT];
 	tmp.t_startc = tty->termios->c_cc[VSTART];
@@ -818,7 +818,7 @@ static int set_tchars(struct tty_struct *tty, struct tchars __user *tchars)
 
 	if (copy_from_user(&tmp, tchars, sizeof(tmp)))
 		return -EFAULT;
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty(&tty->termios_mutex);
 	tty->termios->c_cc[VINTR] = tmp.t_intrc;
 	tty->termios->c_cc[VQUIT] = tmp.t_quitc;
 	tty->termios->c_cc[VSTART] = tmp.t_startc;
@@ -835,7 +835,7 @@ static int get_ltchars(struct tty_struct *tty, struct ltchars __user *ltchars)
 {
 	struct ltchars tmp;
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty(&tty->termios_mutex);
 	tmp.t_suspc = tty->termios->c_cc[VSUSP];
 	/* what is dsuspc anyway? */
 	tmp.t_dsuspc = tty->termios->c_cc[VSUSP];
@@ -855,7 +855,7 @@ static int set_ltchars(struct tty_struct *tty, struct ltchars __user *ltchars)
 	if (copy_from_user(&tmp, ltchars, sizeof(tmp)))
 		return -EFAULT;
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty(&tty->termios_mutex);
 	tty->termios->c_cc[VSUSP] = tmp.t_suspc;
 	/* what is dsuspc anyway? */
 	tty->termios->c_cc[VEOL2] = tmp.t_dsuspc;
@@ -913,7 +913,7 @@ static int tty_change_softcar(struct tty_struct *tty, int arg)
 	int bit = arg ? CLOCAL : 0;
 	struct ktermios old;
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty(&tty->termios_mutex);
 	old = *tty->termios;
 	tty->termios->c_cflag &= ~CLOCAL;
 	tty->termios->c_cflag |= bit;
@@ -1022,7 +1022,7 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 		if (user_termios_to_kernel_termios(&kterm,
 					       (struct termios __user *) arg))
 			return -EFAULT;
-		mutex_lock(&real_tty->termios_mutex);
+		mutex_lock_tty(&real_tty->termios_mutex);
 		memcpy(real_tty->termios_locked, &kterm, sizeof(struct ktermios));
 		mutex_unlock(&real_tty->termios_mutex);
 		return 0;
@@ -1039,7 +1039,7 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 		if (user_termios_to_kernel_termios_1(&kterm,
 					       (struct termios __user *) arg))
 			return -EFAULT;
-		mutex_lock(&real_tty->termios_mutex);
+		mutex_lock_tty(&real_tty->termios_mutex);
 		memcpy(real_tty->termios_locked, &kterm, sizeof(struct ktermios));
 		mutex_unlock(&real_tty->termios_mutex);
 		return ret;
@@ -1049,7 +1049,7 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 		struct termiox ktermx;
 		if (real_tty->termiox == NULL)
 			return -EINVAL;
-		mutex_lock(&real_tty->termios_mutex);
+		mutex_lock_tty(&real_tty->termios_mutex);
 		memcpy(&ktermx, real_tty->termiox, sizeof(struct termiox));
 		mutex_unlock(&real_tty->termios_mutex);
 		if (copy_to_user(p, &ktermx, sizeof(struct termiox)))
diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index bddbe62..af5b4a7 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -428,7 +428,7 @@ EXPORT_SYMBOL_GPL(tty_ldisc_flush);
 
 static void tty_set_termios_ldisc(struct tty_struct *tty, int num)
 {
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty(&tty->termios_mutex);
 	tty->termios->c_line = num;
 	mutex_unlock(&tty->termios_mutex);
 }
@@ -695,7 +695,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 static void tty_reset_termios(struct tty_struct *tty)
 {
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty(&tty->termios_mutex);
 	*tty->termios = tty->driver->init_termios;
 	tty->termios->c_ispeed = tty_termios_input_baud_rate(tty->termios);
 	tty->termios->c_ospeed = tty_termios_baud_rate(tty->termios);
diff --git a/drivers/net/irda/irtty-sir.c b/drivers/net/irda/irtty-sir.c
index 20f9bc6..8938193 100644
--- a/drivers/net/irda/irtty-sir.c
+++ b/drivers/net/irda/irtty-sir.c
@@ -33,6 +33,7 @@
 #include <asm/uaccess.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
+#include <linux/sched.h>
 
 #include <net/irda/irda.h>
 #include <net/irda/irda_device.h>
@@ -122,7 +123,7 @@ static int irtty_change_speed(struct sir_dev *dev, unsigned speed)
 
 	tty = priv->tty;
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty(&tty->termios_mutex);
 	old_termios = *(tty->termios);
 	cflag = tty->termios->c_cflag;
 	tty_encode_baud_rate(tty, speed, speed);
@@ -279,7 +280,7 @@ static inline void irtty_stop_receiver(struct tty_struct *tty, int stop)
 	struct ktermios old_termios;
 	int cflag;
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty(&tty->termios_mutex);
 	old_termios = *(tty->termios);
 	cflag = tty->termios->c_cflag;
 	
diff --git a/drivers/staging/strip/strip.c b/drivers/staging/strip/strip.c
index 698aade..f7a90bc 100644
--- a/drivers/staging/strip/strip.c
+++ b/drivers/staging/strip/strip.c
@@ -775,7 +775,7 @@ static void set_baud(struct tty_struct *tty, speed_t baudrate)
 {
 	struct ktermios old_termios;
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty_off(&tty->termios_mutex);
 	old_termios =*(tty->termios);
 	tty_encode_baud_rate(tty, baudrate, baudrate);
 	tty->ops->set_termios(tty, &old_termios);
-- 
1.7.0

