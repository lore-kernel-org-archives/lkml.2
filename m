Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934551Ab0EDWf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:35:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50352 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934526Ab0EDWfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:35:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 04/13] tty: make termios mutex nest under tty_lock
Date: Wed,  5 May 2010 00:33:43 +0200
Message-Id: <1273012433-6125-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273012433-6125-1-git-send-email-arnd@arndb.de>
References: <1273012433-6125-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX199Cq2iBrh5yq25IFUgixp9GIUSaYBFpxzTRVf
 jG7sGwTJEges6zLHt9lWVCohyUc3A9irIKC1pyOZwJ9IB8e9Za
 Z8elpQSTzarmK/Y+qPEWg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of these are always called without the BTM held.
Annotate them so we know in the future which places
to look at. If we can change the code to never
get termios_mutex while holding the BTM, this
will solve all lock-order problems between the two.

tty_set_termios_ldisc and tty_reset_termios are currently
the only functions that always get termios_mutex while
already holding the BTM.

tty_throttle and tty_unthrottle are called from
receive_buf which in turn is called from a lot
of places. It needs more investigation to prove
that we never hold the BTM while calling these
two.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/pty.c            |    2 +-
 drivers/char/tty_io.c         |    4 ++--
 drivers/char/tty_ioctl.c      |   37 ++++++++++++++++++++-----------------
 drivers/char/tty_ldisc.c      |    4 ++--
 drivers/net/irda/irtty-sir.c  |    5 +++--
 drivers/staging/strip/strip.c |    2 +-
 6 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 384e79f..dbb144b 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -232,7 +232,7 @@ int pty_resize(struct tty_struct *tty,  struct winsize *ws)
 	struct tty_struct *pty = tty->link;
 
 	/* For a PTY we need to lock the tty side */
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty_off(&tty->termios_mutex);
 	if (!memcmp(ws, &tty->winsize, sizeof(*ws)))
 		goto done;
 
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 8331dd3..b1a40a1 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2035,7 +2035,7 @@ static int tiocgwinsz(struct tty_struct *tty, struct winsize __user *arg)
 {
 	int err;
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty_off(&tty->termios_mutex);
 	err = copy_to_user(arg, &tty->winsize, sizeof(*arg));
 	mutex_unlock(&tty->termios_mutex);
 
@@ -2058,7 +2058,7 @@ int tty_do_resize(struct tty_struct *tty, struct winsize *ws)
 	unsigned long flags;
 
 	/* Lock the tty */
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty_off(&tty->termios_mutex);
 	if (!memcmp(ws, &tty->winsize, sizeof(*ws)))
 		goto done;
 	/* Get the PID values and reference them so we can
diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index 6bd5f88..4b57e73 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -99,11 +99,14 @@ EXPORT_SYMBOL(tty_driver_flush_buffer);
  *	Takes the termios mutex to protect against parallel throttle/unthrottle
  *	and also to ensure the driver can consistently reference its own
  *	termios data at this point when implementing software flow control.
+ *
+ *	Locking: potentially called with BTM from n_tty_receive_buf, needs
+ *		 investigation.
  */
 
 void tty_throttle(struct tty_struct *tty)
 {
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty(&tty->termios_mutex); /* BTM unknown */
 	/* check TTY_THROTTLED first so it indicates our state */
 	if (!test_and_set_bit(TTY_THROTTLED, &tty->flags) &&
 	    tty->ops->throttle)
@@ -127,7 +130,7 @@ EXPORT_SYMBOL(tty_throttle);
 
 void tty_unthrottle(struct tty_struct *tty)
 {
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty(&tty->termios_mutex); /* BTM unknown */
 	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags) &&
 	    tty->ops->unthrottle)
 		tty->ops->unthrottle(tty);
@@ -510,7 +513,7 @@ static void change_termios(struct tty_struct *tty, struct ktermios *new_termios)
 
 	/* FIXME: we need to decide on some locking/ordering semantics
 	   for the set_termios notification eventually */
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty_off(&tty->termios_mutex);
 	old_termios = *tty->termios;
 	*tty->termios = *new_termios;
 	unset_locked_termios(tty->termios, &old_termios, tty->termios_locked);
@@ -571,7 +574,7 @@ static int set_termios(struct tty_struct *tty, void __user *arg, int opt)
 	if (retval)
 		return retval;
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty_off(&tty->termios_mutex);
 	memcpy(&tmp_termios, tty->termios, sizeof(struct ktermios));
 	mutex_unlock(&tty->termios_mutex);
 
@@ -625,14 +628,14 @@ static int set_termios(struct tty_struct *tty, void __user *arg, int opt)
 
 static void copy_termios(struct tty_struct *tty, struct ktermios *kterm)
 {
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty_off(&tty->termios_mutex);
 	memcpy(kterm, tty->termios, sizeof(struct ktermios));
 	mutex_unlock(&tty->termios_mutex);
 }
 
 static void copy_termios_locked(struct tty_struct *tty, struct ktermios *kterm)
 {
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty_off(&tty->termios_mutex);
 	memcpy(kterm, tty->termios_locked, sizeof(struct ktermios));
 	mutex_unlock(&tty->termios_mutex);
 }
@@ -681,7 +684,7 @@ static int set_termiox(struct tty_struct *tty, void __user *arg, int opt)
 			return -EINTR;
 	}
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty_off(&tty->termios_mutex);
 	if (tty->ops->set_termiox)
 		tty->ops->set_termiox(tty, &tnew);
 	mutex_unlock(&tty->termios_mutex);
@@ -719,7 +722,7 @@ static int get_sgttyb(struct tty_struct *tty, struct sgttyb __user *sgttyb)
 {
 	struct sgttyb tmp;
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty_off(&tty->termios_mutex);
 	tmp.sg_ispeed = tty->termios->c_ispeed;
 	tmp.sg_ospeed = tty->termios->c_ospeed;
 	tmp.sg_erase = tty->termios->c_cc[VERASE];
@@ -780,7 +783,7 @@ static int set_sgttyb(struct tty_struct *tty, struct sgttyb __user *sgttyb)
 	if (copy_from_user(&tmp, sgttyb, sizeof(tmp)))
 		return -EFAULT;
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty_off(&tty->termios_mutex);
 	termios = *tty->termios;
 	termios.c_cc[VERASE] = tmp.sg_erase;
 	termios.c_cc[VKILL] = tmp.sg_kill;
@@ -801,7 +804,7 @@ static int get_tchars(struct tty_struct *tty, struct tchars __user *tchars)
 {
 	struct tchars tmp;
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty_off(&tty->termios_mutex);
 	tmp.t_intrc = tty->termios->c_cc[VINTR];
 	tmp.t_quitc = tty->termios->c_cc[VQUIT];
 	tmp.t_startc = tty->termios->c_cc[VSTART];
@@ -818,7 +821,7 @@ static int set_tchars(struct tty_struct *tty, struct tchars __user *tchars)
 
 	if (copy_from_user(&tmp, tchars, sizeof(tmp)))
 		return -EFAULT;
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty_off(&tty->termios_mutex);
 	tty->termios->c_cc[VINTR] = tmp.t_intrc;
 	tty->termios->c_cc[VQUIT] = tmp.t_quitc;
 	tty->termios->c_cc[VSTART] = tmp.t_startc;
@@ -835,7 +838,7 @@ static int get_ltchars(struct tty_struct *tty, struct ltchars __user *ltchars)
 {
 	struct ltchars tmp;
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty_off(&tty->termios_mutex);
 	tmp.t_suspc = tty->termios->c_cc[VSUSP];
 	/* what is dsuspc anyway? */
 	tmp.t_dsuspc = tty->termios->c_cc[VSUSP];
@@ -855,7 +858,7 @@ static int set_ltchars(struct tty_struct *tty, struct ltchars __user *ltchars)
 	if (copy_from_user(&tmp, ltchars, sizeof(tmp)))
 		return -EFAULT;
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty_off(&tty->termios_mutex);
 	tty->termios->c_cc[VSUSP] = tmp.t_suspc;
 	/* what is dsuspc anyway? */
 	tty->termios->c_cc[VEOL2] = tmp.t_dsuspc;
@@ -913,7 +916,7 @@ static int tty_change_softcar(struct tty_struct *tty, int arg)
 	int bit = arg ? CLOCAL : 0;
 	struct ktermios old;
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty_off(&tty->termios_mutex);
 	old = *tty->termios;
 	tty->termios->c_cflag &= ~CLOCAL;
 	tty->termios->c_cflag |= bit;
@@ -1022,7 +1025,7 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 		if (user_termios_to_kernel_termios(&kterm,
 					       (struct termios __user *) arg))
 			return -EFAULT;
-		mutex_lock(&real_tty->termios_mutex);
+		mutex_lock_tty_off(&real_tty->termios_mutex);
 		memcpy(real_tty->termios_locked, &kterm, sizeof(struct ktermios));
 		mutex_unlock(&real_tty->termios_mutex);
 		return 0;
@@ -1039,7 +1042,7 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 		if (user_termios_to_kernel_termios_1(&kterm,
 					       (struct termios __user *) arg))
 			return -EFAULT;
-		mutex_lock(&real_tty->termios_mutex);
+		mutex_lock_tty_off(&real_tty->termios_mutex);
 		memcpy(real_tty->termios_locked, &kterm, sizeof(struct ktermios));
 		mutex_unlock(&real_tty->termios_mutex);
 		return ret;
@@ -1049,7 +1052,7 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 		struct termiox ktermx;
 		if (real_tty->termiox == NULL)
 			return -EINVAL;
-		mutex_lock(&real_tty->termios_mutex);
+		mutex_lock_tty_off(&real_tty->termios_mutex);
 		memcpy(&ktermx, real_tty->termiox, sizeof(struct termiox));
 		mutex_unlock(&real_tty->termios_mutex);
 		if (copy_to_user(p, &ktermx, sizeof(struct termiox)))
diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 97681ff..f0efca2 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -428,7 +428,7 @@ EXPORT_SYMBOL_GPL(tty_ldisc_flush);
 
 static void tty_set_termios_ldisc(struct tty_struct *tty, int num)
 {
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty_on(&tty->termios_mutex);
 	tty->termios->c_line = num;
 	mutex_unlock(&tty->termios_mutex);
 }
@@ -697,7 +697,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 static void tty_reset_termios(struct tty_struct *tty)
 {
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty_on(&tty->termios_mutex);
 	*tty->termios = tty->driver->init_termios;
 	tty->termios->c_ispeed = tty_termios_input_baud_rate(tty->termios);
 	tty->termios->c_ospeed = tty_termios_baud_rate(tty->termios);
diff --git a/drivers/net/irda/irtty-sir.c b/drivers/net/irda/irtty-sir.c
index ee1dde5..26d8230 100644
--- a/drivers/net/irda/irtty-sir.c
+++ b/drivers/net/irda/irtty-sir.c
@@ -34,6 +34,7 @@
 #include <asm/uaccess.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
+#include <linux/sched.h>
 
 #include <net/irda/irda.h>
 #include <net/irda/irda_device.h>
@@ -123,7 +124,7 @@ static int irtty_change_speed(struct sir_dev *dev, unsigned speed)
 
 	tty = priv->tty;
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty_off(&tty->termios_mutex);
 	old_termios = *(tty->termios);
 	cflag = tty->termios->c_cflag;
 	tty_encode_baud_rate(tty, speed, speed);
@@ -280,7 +281,7 @@ static inline void irtty_stop_receiver(struct tty_struct *tty, int stop)
 	struct ktermios old_termios;
 	int cflag;
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty(&tty->termios_mutex); /* locked from tty->close */
 	old_termios = *(tty->termios);
 	cflag = tty->termios->c_cflag;
 	
diff --git a/drivers/staging/strip/strip.c b/drivers/staging/strip/strip.c
index c976c6b..85e00d9 100644
--- a/drivers/staging/strip/strip.c
+++ b/drivers/staging/strip/strip.c
@@ -776,7 +776,7 @@ static void set_baud(struct tty_struct *tty, speed_t baudrate)
 {
 	struct ktermios old_termios;
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock_tty_off(&tty->termios_mutex);
 	old_termios =*(tty->termios);
 	tty_encode_baud_rate(tty, baudrate, baudrate);
 	tty->ops->set_termios(tty, &old_termios);
-- 
1.7.0.4

