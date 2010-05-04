Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934547Ab0EDWfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:35:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57129 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934532Ab0EDWfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:35:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 11/13] tty: remove tty_lock_nested
Date: Wed,  5 May 2010 00:33:50 +0200
Message-Id: <1273012433-6125-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273012433-6125-1-git-send-email-arnd@arndb.de>
References: <1273012433-6125-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18UW56djERjhiX0D/gYeRaNuNoTXZyqBUjlSbk
 G2QONN2c7fxDEZlsCNGYAF3XAEvCLQZ5HIHio5ju6KRtN0u/il
 zYhHWkdtiyN3RDoKqDhIA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes all remaining users of tty_lock_nested
to be non-recursive, which lets us kill this function.
As a consequence, we won't need to keep the lock count
any more, which allows more simplifications later.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/pty.c       |    2 +-
 drivers/char/selection.c |    4 ++--
 drivers/char/tty_io.c    |   41 ++++++++++++++++++++---------------------
 drivers/char/tty_ldisc.c |    3 +--
 drivers/char/tty_mutex.c |   15 ---------------
 drivers/serial/crisv10.c |    7 ++++---
 include/linux/tty.h      |   17 +----------------
 7 files changed, 29 insertions(+), 60 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 889de89..76de961 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -62,7 +62,7 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 		if (tty->driver == ptm_driver)
 			devpts_pty_kill(tty->link);
 #endif
-		tty_vhangup(tty->link);
+		tty_vhangup_locked(tty->link);
 	}
 }
 
diff --git a/drivers/char/selection.c b/drivers/char/selection.c
index 85211a3..8e314bb 100644
--- a/drivers/char/selection.c
+++ b/drivers/char/selection.c
@@ -313,7 +313,8 @@ int paste_selection(struct tty_struct *tty)
 	struct  tty_ldisc *ld;
 	DECLARE_WAITQUEUE(wait, current);
 
-	tty_lock_nested(); /* always called with BTM from vt_ioctl */
+	/* always called with BTM from vt_ioctl */
+	WARN_ON(!tty_locked());
 
 	acquire_console_sem();
 	poke_blanked_console();
@@ -338,6 +339,5 @@ int paste_selection(struct tty_struct *tty)
 	__set_current_state(TASK_RUNNING);
 
 	tty_ldisc_deref(ld);
-	tty_unlock();
 	return 0;
 }
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index e1b2fca..4e16b34 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -492,10 +492,8 @@ EXPORT_SYMBOL_GPL(tty_wakeup);
  *		  tasklist_lock to walk task list for hangup event
  *		    ->siglock to protect ->signal/->sighand
  */
-static void do_tty_hangup(struct work_struct *work)
+void tty_vhangup_locked(struct tty_struct *tty)
 {
-	struct tty_struct *tty =
-		container_of(work, struct tty_struct, hangup_work);
 	struct file *cons_filp = NULL;
 	struct file *filp, *f = NULL;
 	struct task_struct *p;
@@ -517,8 +515,6 @@ static void do_tty_hangup(struct work_struct *work)
 	/* inuse_filps is protected by the single tty lock,
 	   this really needs to change if we want to flush the
 	   workqueue with the lock held */
-	tty_lock_nested(); /* called with BTM held from pty_close and
-				others */
 	check_tty_count(tty, "do_tty_hangup");
 
 	file_list_lock();
@@ -598,11 +594,20 @@ static void do_tty_hangup(struct work_struct *work)
 	 */
 	set_bit(TTY_HUPPED, &tty->flags);
 	tty_ldisc_enable(tty);
-	tty_unlock();
 	if (f)
 		fput(f);
 }
 
+static void do_tty_hangup(struct work_struct *work)
+{
+	struct tty_struct *tty =
+		container_of(work, struct tty_struct, hangup_work);
+
+	tty_lock();
+	tty_vhangup_locked(tty);
+	tty_unlock();
+}
+
 /**
  *	tty_hangup		-	trigger a hangup event
  *	@tty: tty to hangup
@@ -638,7 +643,9 @@ void tty_vhangup(struct tty_struct *tty)
 
 	printk(KERN_DEBUG "%s vhangup...\n", tty_name(tty, buf));
 #endif
-	do_tty_hangup(&tty->hangup_work);
+	tty_lock();
+	tty_vhangup_locked(tty);
+	tty_unlock();
 }
 
 EXPORT_SYMBOL(tty_vhangup);
@@ -719,10 +726,12 @@ void disassociate_ctty(int on_exit)
 	tty = get_current_tty();
 	if (tty) {
 		tty_pgrp = get_pid(tty->pgrp);
-		tty_lock_nested(); /* see above */
-		if (on_exit && tty->driver->type != TTY_DRIVER_TYPE_PTY)
-			tty_vhangup(tty);
-		tty_unlock();
+		if (on_exit) {
+			tty_lock();
+			if (tty->driver->type != TTY_DRIVER_TYPE_PTY)
+				tty_vhangup_locked(tty);
+			tty_unlock();
+		}
 		tty_kref_put(tty);
 	} else if (on_exit) {
 		struct pid *old_pgrp;
@@ -1218,18 +1227,14 @@ static int tty_driver_install_tty(struct tty_driver *driver,
 	int ret;
 
 	if (driver->ops->install) {
-		tty_lock_nested(); /* already called with BTM held */
 		ret = driver->ops->install(driver, tty);
-		tty_unlock();
 		return ret;
 	}
 
 	if (tty_init_termios(tty) == 0) {
-		tty_lock_nested();
 		tty_driver_kref_get(driver);
 		tty->count++;
 		driver->ttys[idx] = tty;
-		tty_unlock();
 		return 0;
 	}
 	return -ENOMEM;
@@ -1322,15 +1327,11 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
 	struct tty_struct *tty;
 	int retval;
 
-	tty_lock_nested(); /* always called with tty lock held already */
-
 	/* Check if pty master is being opened multiple times */
 	if (driver->subtype == PTY_TYPE_MASTER &&
 		(driver->flags & TTY_DRIVER_DEVPTS_MEM) && !first_ok) {
-		tty_unlock();
 		return ERR_PTR(-EIO);
 	}
-	tty_unlock();
 
 	/*
 	 * First time open is complex, especially for PTY devices.
@@ -1374,9 +1375,7 @@ release_mem_out:
 	if (printk_ratelimit())
 		printk(KERN_INFO "tty_init_dev: ldisc open failed, "
 				 "clearing slot %d\n", idx);
-	tty_lock_nested();
 	release_tty(tty, idx);
-	tty_unlock();
 	return ERR_PTR(retval);
 }
 
diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index d4259cf..c71a94a 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -458,9 +458,8 @@ static int tty_ldisc_open(struct tty_struct *tty, struct tty_ldisc *ld)
 	if (ld->ops->open) {
 		int ret;
                 /* BTM here locks versus a hangup event */
-		tty_lock_nested(); /* always held here already */
+		WARN_ON(!tty_locked());
 		ret = ld->ops->open(tty);
-		tty_unlock();
 		return ret;
 	}
 	return 0;
diff --git a/drivers/char/tty_mutex.c b/drivers/char/tty_mutex.c
index 51e0852..6bd47e1 100644
--- a/drivers/char/tty_mutex.c
+++ b/drivers/char/tty_mutex.c
@@ -73,21 +73,6 @@ void __lockfunc tty_lock(void)
 }
 EXPORT_SYMBOL(tty_lock);
 
-void __lockfunc tty_lock_nested(void)
-{
-	struct task_struct *task = current;
-	int depth = task->tty_lock_depth + 1;
-
-	if (likely(!depth))
-		/*
-		 * No recursion worries - we set up tty_lock_depth _after_
-		 */
-		mutex_lock(&big_tty_mutex);
-
-	task->tty_lock_depth = depth;
-}
-EXPORT_SYMBOL(tty_lock_nested);
-
 void __lockfunc tty_unlock(void)
 {
 	struct task_struct *task = current;
diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index 9047384..28ff46a 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -3254,9 +3254,10 @@ rs_write(struct tty_struct *tty,
 		 */
 
 		/* Sleep until all sent */
-		tty_lock_nested();
-		tty_wait_until_sent_locked(tty, 0);
-		tty_unlock();
+		if (tty_locked())
+			tty_wait_until_sent_locked(tty, 0);
+		else
+			tty_wait_until_sent(tty, 0);
 #ifdef CONFIG_ETRAX_FAST_TIMER
 		/* Now sleep a little more so that shift register is empty */
 		schedule_usleep(info->char_time_usec * 2);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 8ddd952..3cf4556 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -416,6 +416,7 @@ extern int is_ignored(int sig);
 extern int tty_signal(int sig, struct tty_struct *tty);
 extern void tty_hangup(struct tty_struct *tty);
 extern void tty_vhangup(struct tty_struct *tty);
+extern void tty_vhangup_locked(struct tty_struct *tty);
 extern void tty_vhangup_self(void);
 extern void tty_unhangup(struct file *filp);
 extern int tty_hung_up_p(struct file *filp);
@@ -575,19 +576,7 @@ extern long vt_compat_ioctl(struct tty_struct *tty, struct file * file,
 
 /* tty_mutex.c */
 /* functions for preparation of BKL removal */
-
-/*
- * tty_lock_nested get the tty_lock while potentially holding it
- *
- * The Big TTY Mutex is a recursive lock, meaning you can take it
- * from a thread that is already holding it.
- * This is bad for a number of reasons, so tty_lock_nested should
- * really be used as rarely as possible. If a code location can
- * be shown to never get called with this held already, it should
- * use tty_lock() instead.
- */ 
 #ifdef CONFIG_TTY_MUTEX
-extern void __lockfunc tty_lock_nested(void) __acquires(tty_lock);
 extern void __lockfunc tty_lock(void) __acquires(tty_lock);
 extern void __lockfunc tty_unlock(void) __releases(tty_lock);
 #define tty_locked()		(current->tty_lock_depth >= 0)
@@ -602,10 +591,6 @@ void __lockfunc __release_tty_lock(void);
                 __reacquire_tty_lock() : 0 )
 
 #else
-static inline void __lockfunc tty_lock_nested(void) __acquires(kernel_lock)
-{
-	lock_kernel();
-}
 static inline void tty_lock(void) __acquires(kernel_lock)
 {
 	WARN_ON(kernel_locked());
-- 
1.7.0.4

