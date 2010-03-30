Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab0C3XIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:08:50 -0400
Received: from kroah.org ([198.145.64.141]:48360 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937Ab0C3XIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:08:48 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:41 2010
Message-Id: <20100330224941.118008490@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Greg Kroah-Hartman <gregkh@suse.de>,
       =?ISO-8859-15?q?Am=C3=A9rico=20Wang?= <xiyou.wangcong@gmail.com>
Subject: [03/45] Fix race in tty_fasync() properly
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 80e1e823989ec44d8e35bdfddadbddcffec90424 upstream.

This reverts commit 703625118069 ("tty: fix race in tty_fasync") and
commit b04da8bfdfbb ("fnctl: f_modown should call write_lock_irqsave/
restore") that tried to fix up some of the fallout but was incomplete.

It turns out that we really cannot hold 'tty->ctrl_lock' over calling
__f_setown, because not only did that cause problems with interrupt
disables (which the second commit fixed), it also causes a potential
ABBA deadlock due to lock ordering.

Thanks to Tetsuo Handa for following up on the issue, and running
lockdep to show the problem.  It goes roughly like this:

 - f_getown gets filp->f_owner.lock for reading without interrupts
   disabled, so an interrupt that happens while that lock is held can
   cause a lockdep chain from f_owner.lock -> sighand->siglock.

 - at the same time, the tty->ctrl_lock -> f_owner.lock chain that
   commit 703625118069 introduced, together with the pre-existing
   sighand->siglock -> tty->ctrl_lock chain means that we have a lock
   dependency the other way too.

So instead of extending tty->ctrl_lock over the whole __f_setown() call,
we now just take a reference to the 'pid' structure while holding the
lock, and then release it after having done the __f_setown.  That still
guarantees that 'struct pid' won't go away from under us, which is all
we really ever needed.

Reported-and-tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Américo Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tty_io.c |    4 +++-
 fs/fcntl.c            |    6 ++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2437,8 +2437,10 @@ static int tty_fasync(int fd, struct fil
 			pid = task_pid(current);
 			type = PIDTYPE_PID;
 		}
-		retval = __f_setown(filp, pid, type, 0);
+		get_pid(pid);
 		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+		retval = __f_setown(filp, pid, type, 0);
+		put_pid(pid);
 		if (retval)
 			goto out;
 	} else {
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -200,9 +200,7 @@ static int setfl(int fd, struct file * f
 static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
                      uid_t uid, uid_t euid, int force)
 {
-	unsigned long flags;
-
-	write_lock_irqsave(&filp->f_owner.lock, flags);
+	write_lock_irq(&filp->f_owner.lock);
 	if (force || !filp->f_owner.pid) {
 		put_pid(filp->f_owner.pid);
 		filp->f_owner.pid = get_pid(pid);
@@ -210,7 +208,7 @@ static void f_modown(struct file *filp,
 		filp->f_owner.uid = uid;
 		filp->f_owner.euid = euid;
 	}
-	write_unlock_irqrestore(&filp->f_owner.lock, flags);
+	write_unlock_irq(&filp->f_owner.lock);
 }
 
 int __f_setown(struct file *filp, struct pid *pid, enum pid_type type,


