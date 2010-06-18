Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761182Ab0FRM6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 08:58:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63729 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758549Ab0FRM6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 08:58:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] tty: avoid recursive BTM in pty_close
Date: Fri, 18 Jun 2010 14:58:07 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Tony Luck <tony.luck@intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de> <201006172348.08180.arnd@arndb.de> <20100617220926.GC5345@nowhere>
In-Reply-To: <20100617220926.GC5345@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006181458.07687.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18WqYs2qirS5Y2L9gTpO90TZV6BIGIALdcs7DG
 CixBI3LJuvy1bDSYPA7jkRZ4WTSOK/RXdZqhXJs3IaZwavh2p6
 J3qp/C1QD1jqrf+Z782cw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the console has been redirected, a hangup of the tty
will cause tty_release to be called under the big tty_mutex,
which leads to a deadlock because hangup is also called
under the BTM.

This moves the BTM deeper into the tty_hangup function so
we can close the redirected tty without holding the BTM.
In case of pty, we now need to drop the BTM before
calling tty_vhangup.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/pty.c    |    4 +++-
 drivers/char/tty_io.c |   24 ++++++++++++------------
 2 files changed, 15 insertions(+), 13 deletions(-)

---
On Friday 18 June 2010, Frederic Weisbecker wrote:
> > -             tty_vhangup_locked(tty->link);
> > +             unlock_kernel();
> > +             tty_vhangup(tty->link);
> > +             lock_kernel();
> 
> 
> 
> Don't you mean tty_unlock / tty_lock there?

Yes, thanks for catching this.

I did test this patch yesterday night (it was late) with CONFIG_TTY_MUTEX
disabled, as in Tony's configuration, but I did not realize that I
broke the other configuration in turn.

I'd like to get Alan's opinion on whether he considers the change in
pty.c safe.

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index c9af9ff..acff19f 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -62,7 +62,9 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 		if (tty->driver == ptm_driver)
 			devpts_pty_kill(tty->link);
 #endif
-		tty_vhangup_locked(tty->link);
+		tty_unlock();
+		tty_vhangup(tty->link);
+		tty_lock();
 	}
 }
 
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 5db354d..6bf6d36 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -471,7 +471,7 @@ void tty_wakeup(struct tty_struct *tty)
 EXPORT_SYMBOL_GPL(tty_wakeup);
 
 /**
- *	do_tty_hangup		-	actual handler for hangup events
+ *	__tty_hangup		-	actual handler for hangup events
  *	@work: tty device
  *
  *	This can be called by the "eventd" kernel thread.  That is process
@@ -492,7 +492,7 @@ EXPORT_SYMBOL_GPL(tty_wakeup);
  *		  tasklist_lock to walk task list for hangup event
  *		    ->siglock to protect ->signal/->sighand
  */
-void tty_vhangup_locked(struct tty_struct *tty)
+void __tty_hangup(struct tty_struct *tty)
 {
 	struct file *cons_filp = NULL;
 	struct file *filp, *f = NULL;
@@ -512,10 +512,12 @@ void tty_vhangup_locked(struct tty_struct *tty)
 	}
 	spin_unlock(&redirect_lock);
 
+	tty_lock();
+
 	/* inuse_filps is protected by the single tty lock,
 	   this really needs to change if we want to flush the
 	   workqueue with the lock held */
-	check_tty_count(tty, "do_tty_hangup");
+	check_tty_count(tty, "tty_hangup");
 
 	file_list_lock();
 	/* This breaks for file handles being sent over AF_UNIX sockets ? */
@@ -594,6 +596,9 @@ void tty_vhangup_locked(struct tty_struct *tty)
 	 */
 	set_bit(TTY_HUPPED, &tty->flags);
 	tty_ldisc_enable(tty);
+
+	tty_unlock();
+
 	if (f)
 		fput(f);
 }
@@ -603,9 +608,7 @@ static void do_tty_hangup(struct work_struct *work)
 	struct tty_struct *tty =
 		container_of(work, struct tty_struct, hangup_work);
 
-	tty_lock();
-	tty_vhangup_locked(tty);
-	tty_unlock();
+	__tty_hangup(tty);
 }
 
 /**
@@ -643,13 +646,12 @@ void tty_vhangup(struct tty_struct *tty)
 
 	printk(KERN_DEBUG "%s vhangup...\n", tty_name(tty, buf));
 #endif
-	tty_lock();
-	tty_vhangup_locked(tty);
-	tty_unlock();
+	__tty_hangup(tty);
 }
 
 EXPORT_SYMBOL(tty_vhangup);
 
+
 /**
  *	tty_vhangup_self	-	process vhangup for own ctty
  *
@@ -727,10 +729,8 @@ void disassociate_ctty(int on_exit)
 	if (tty) {
 		tty_pgrp = get_pid(tty->pgrp);
 		if (on_exit) {
-			tty_lock();
 			if (tty->driver->type != TTY_DRIVER_TYPE_PTY)
-				tty_vhangup_locked(tty);
-			tty_unlock();
+				tty_vhangup(tty);
 		}
 		tty_kref_put(tty);
 	} else if (on_exit) {
-- 
1.7.0.4

