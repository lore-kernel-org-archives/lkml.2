Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391Ab0FQVtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 17:49:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63459 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757658Ab0FQVtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 17:49:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v3 00/10] BKL conversion in tty layer
Date: Thu, 17 Jun 2010 23:48:07 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.35-rc1-00090-g358f4b6; KDE/4.4.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de> <201006172140.46203.arnd@arndb.de> <AANLkTinGJJJ4vWvDGCqSPpMnYyE5WKALVmBUAJ_72y-G@mail.gmail.com>
In-Reply-To: <AANLkTinGJJJ4vWvDGCqSPpMnYyE5WKALVmBUAJ_72y-G@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006172348.08180.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/TPW4RBEGtvyi3r7VugWLOqBQVFcLJ+D1OueL
 Svk5dtUm+u1VpcagepUOti5tGxeqOrBdeskte2g9Vh+C76vSs3
 ZX/SnheEEskv7eDDjNEiA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 June 2010 22:15:32 Tony Luck wrote:
> Call Trace:
>  [<a000000100015990>] show_stack+0x50/0xa0
>  [<a00000010090f1f0>] dump_stack+0x30/0x50
>  [<a00000010008e280>] warn_slowpath_common+0xc0/0x120
>  [<a00000010008e320>] warn_slowpath_null+0x40/0x60
>  [<a00000010053d910>] tty_release+0x90/0xbc0
>  [<a0000001001ab200>] __fput+0x260/0x420
>  [<a0000001001ab400>] fput+0x40/0x60
>  [<a00000010053b3b0>] tty_vhangup_locked+0x870/0x8a0
>  [<a00000010054f3f0>] pty_close+0x350/0x3a0
>  [<a00000010053ddd0>] tty_release+0x550/0xbc0
>  [<a0000001001ab200>] __fput+0x260/0x420
>  [<a0000001001ab400>] fput+0x40/0x60
>  [<a0000001001a4dc0>] filp_close+0x120/0x140
>  [<a0000001001a4f90>] sys_close+0x1b0/0x2c0
>  [<a00000010000b940>] ia64_ret_from_syscall+0x0/0x20
> 

Ah, this sucks. I think Alan actually tried to warn me of this problem and I
thought I had it right, but obviously I got it wrong in the end. I really
should have run into this during testing though, not sure why I didn't.

The good news is that the warning message is harmless for the normal
case where CONFIG_TTY_MUTEX remains disabled, it's only debugging code
to warn that there is a bug once the option gets turned on.

Unfortunately however the only fix I see is to push the BTM further down
into the hangup function, which makes the pty code slightly more complex
and which I'm sure is an equivalent transformation.

I'll try doing some more tests with this patch and CONFIG_TTY_LOCK disabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index c9af9ff..0902127 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -62,7 +62,9 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 		if (tty->driver == ptm_driver)
 			devpts_pty_kill(tty->link);
 #endif
-		tty_vhangup_locked(tty->link);
+		unlock_kernel();
+		tty_vhangup(tty->link);
+		lock_kernel();
 	}
 }
 
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 5db354d..852ccb4 100644
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
