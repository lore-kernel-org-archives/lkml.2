Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918Ab0EAOiI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 10:38:08 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:64195 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab0EAOhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 10:37:39 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Oren Laadan <orenl@cs.columbia.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH v21 078/100] c/r: support for controlling terminal and job control
Date: Sat,  1 May 2010 10:16:00 -0400
Message-Id: <1272723382-19470-79-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add checkpoint/restart of controlling terminal: current->signal->tty.
This is only done for session leaders.

If the session leader belongs to the ancestor pid-ns, then checkpoint
skips this tty; On restart, it will not be restored, and whatever tty
is in place from parent pid-ns (at restart) will be inherited.

Chagnelog [v1]:
  - Don't restore tty_old_pgrp it pgid is CKPT_PID_NULL
  - Initialize pgrp to NULL in restore_signal

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Serge E. Hallyn <serue@us.ibm.com>
---
 drivers/char/tty_io.c          |   33 +++++++++++++----
 include/linux/checkpoint.h     |    1 +
 include/linux/checkpoint_hdr.h |    6 +++
 include/linux/tty.h            |    5 +++
 kernel/signal.c                |   79 +++++++++++++++++++++++++++++++++++++++-
 5 files changed, 115 insertions(+), 9 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 093f522..d264000 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2175,7 +2175,7 @@ static int fionbio(struct file *file, int __user *p)
  *		Takes ->siglock() when updating signal->tty
  */
 
-static int tiocsctty(struct tty_struct *tty, int arg)
+int tiocsctty(struct tty_struct *tty, int arg)
 {
 	int ret = 0;
 	if (current->signal->leader && (task_session(current) == tty->session))
@@ -2264,10 +2264,10 @@ static int tiocgpgrp(struct tty_struct *tty, struct tty_struct *real_tty, pid_t
 }
 
 /**
- *	tiocspgrp		-	attempt to set process group
+ *	do_tiocspgrp		-	attempt to set process group
  *	@tty: tty passed by user
  *	@real_tty: tty side device matching tty passed by user
- *	@p: pid pointer
+ *	@pid: pgrp_nr
  *
  *	Set the process group of the tty to the session passed. Only
  *	permitted where the tty session is our session.
@@ -2275,10 +2275,10 @@ static int tiocgpgrp(struct tty_struct *tty, struct tty_struct *real_tty, pid_t
  *	Locking: RCU, ctrl lock
  */
 
-static int tiocspgrp(struct tty_struct *tty, struct tty_struct *real_tty, pid_t __user *p)
+int do_tiocspgrp(struct tty_struct *tty,
+		 struct tty_struct *real_tty, pid_t pgrp_nr)
 {
 	struct pid *pgrp;
-	pid_t pgrp_nr;
 	int retval = tty_check_change(real_tty);
 	unsigned long flags;
 
@@ -2290,8 +2290,6 @@ static int tiocspgrp(struct tty_struct *tty, struct tty_struct *real_tty, pid_t
 	    (current->signal->tty != real_tty) ||
 	    (real_tty->session != task_session(current)))
 		return -ENOTTY;
-	if (get_user(pgrp_nr, p))
-		return -EFAULT;
 	if (pgrp_nr < 0)
 		return -EINVAL;
 	rcu_read_lock();
@@ -2313,6 +2311,27 @@ out_unlock:
 }
 
 /**
+ *	tiocspgrp		-	attempt to set process group
+ *	@tty: tty passed by user
+ *	@real_tty: tty side device matching tty passed by user
+ *	@p: pid pointer
+ *
+ *	Set the process group of the tty to the session passed. Only
+ *	permitted where the tty session is our session.
+ *
+ *	Locking: RCU, ctrl lock
+ */
+
+static int tiocspgrp(struct tty_struct *tty, struct tty_struct *real_tty, pid_t __user *p)
+{
+	pid_t pgrp_nr;
+
+	if (get_user(pgrp_nr, p))
+		return -EFAULT;
+	return do_tiocspgrp(tty, real_tty, pgrp_nr);
+}
+
+/**
  *	tiocgsid		-	get session id
  *	@tty: tty passed by user
  *	@real_tty: tty side of the tty pased by the user if a pty else the tty
diff --git a/include/linux/checkpoint.h b/include/linux/checkpoint.h
index adf5ca6..09fbb59 100644
--- a/include/linux/checkpoint.h
+++ b/include/linux/checkpoint.h
@@ -99,6 +99,7 @@ extern int restore_read_page(struct ckpt_ctx *ctx, struct page *page);
 
 /* pids */
 extern pid_t ckpt_pid_nr(struct ckpt_ctx *ctx, struct pid *pid);
+extern struct pid *_ckpt_find_pgrp(struct ckpt_ctx *ctx, pid_t pgid);
 
 /* socket functions */
 extern int ckpt_sock_getnames(struct ckpt_ctx *ctx,
diff --git a/include/linux/checkpoint_hdr.h b/include/linux/checkpoint_hdr.h
index 50138a0..79e8e2d 100644
--- a/include/linux/checkpoint_hdr.h
+++ b/include/linux/checkpoint_hdr.h
@@ -816,13 +816,19 @@ struct ckpt_rlimit {
 
 struct ckpt_hdr_signal {
 	struct ckpt_hdr h;
+	/* rlimit */
 	struct ckpt_rlimit rlim[CKPT_RLIM_NLIMITS];
+	/* itimer */
 	__u64 it_real_value;
 	__u64 it_real_incr;
 	__u64 it_virt_value;
 	__u64 it_virt_incr;
 	__u64 it_prof_value;
 	__u64 it_prof_incr;
+	/* tty */
+	__s32 tty_objref;
+	__s32 tty_pgrp;
+	__s32 tty_old_pgrp;
 } __attribute__((aligned(8)));
 
 struct ckpt_hdr_signal_task {
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 3b7d8eb..b511c7f 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -513,6 +513,11 @@ extern void tty_ldisc_begin(void);
 /* This last one is just for the tty layer internals and shouldn't be used elsewhere */
 extern void tty_ldisc_enable(struct tty_struct *tty);
 
+/* These are for checkpoint/restart */
+extern int tiocsctty(struct tty_struct *tty, int arg);
+extern int do_tiocspgrp(struct tty_struct *tty,
+			struct tty_struct *real_tty, pid_t pgrp_nr);
+
 #ifdef CONFIG_CHECKPOINT
 struct ckpt_ctx;
 struct ckpt_hdr_file;
diff --git a/kernel/signal.c b/kernel/signal.c
index 1d511e7..e4ca9a6 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3063,9 +3063,10 @@ static int checkpoint_signal(struct ckpt_ctx *ctx, struct task_struct *t)
 	struct timeval tval;
 	struct rlimit *rlim;
 	struct cpu_itimer *it;
+	struct tty_struct *tty = NULL;
 	cputime_t cputime;
 	unsigned long flags;
-	int i, ret;
+	int i, ret = 0;
 
 	h = ckpt_hdr_get_type(ctx, sizeof(*h), CKPT_HDR_SIGNAL);
 	if (!h)
@@ -3147,9 +3148,34 @@ static int checkpoint_signal(struct ckpt_ctx *ctx, struct task_struct *t)
 	cputime_to_timeval(it->incr, &tval);
 	h->it_prof_incr = timeval_to_ns(&tval);
 
+	/* tty */
+	if (signal->leader) {
+		h->tty_old_pgrp = ckpt_pid_nr(ctx, signal->tty_old_pgrp);
+		tty = tty_kref_get(signal->tty);
+		if (tty) {
+			/* irq is already disabled */
+			spin_lock(&tty->ctrl_lock);
+			h->tty_pgrp = ckpt_pid_nr(ctx, tty->pgrp);
+			spin_unlock(&tty->ctrl_lock);
+			tty_kref_put(tty);
+		}
+	}
+
 	unlock_task_sighand(t, &flags);
 
-	ret = ckpt_write_obj(ctx, &h->h);
+	/*
+	 * If the session is in an ancestor namespace, skip this tty
+	 * and set tty_objref = 0. It will not be explicitly restored,
+	 * but rather inherited from parent pid-ns at restart time.
+	 */
+	if (tty && ckpt_pid_nr(ctx, tty->session) > 0) {
+		h->tty_objref = checkpoint_obj(ctx, tty, CKPT_OBJ_TTY);
+		if (h->tty_objref < 0)
+			ret = h->tty_objref;
+	}
+
+	if (!ret)
+		ret = ckpt_write_obj(ctx, &h->h);
 	if (!ret)
 		ret = checkpoint_sigpending(ctx, &shared_pending);
 
@@ -3221,6 +3247,8 @@ static int restore_signal(struct ckpt_ctx *ctx)
 	struct ckpt_hdr_signal *h;
 	struct sigpending new_pending;
 	struct sigpending *pending;
+	struct tty_struct *tty = NULL;
+	struct pid *pgrp = NULL;
 	struct rlimit rlim;
 	int i, ret;
 
@@ -3241,6 +3269,40 @@ static int restore_signal(struct ckpt_ctx *ctx)
 	if (ret < 0)
 		goto out;
 
+	/* tty - session */
+	if (h->tty_objref) {
+		tty = ckpt_obj_fetch(ctx, h->tty_objref, CKPT_OBJ_TTY);
+		if (IS_ERR(tty)) {
+			ret = PTR_ERR(tty);
+			goto out;
+		}
+		/* this will fail unless we're the session leader */
+		ret = tiocsctty(tty, 0);
+		if (ret < 0)
+			goto out;
+		/* now restore the foreground group (job control) */
+		if (h->tty_pgrp) {
+			/*
+			 * If tty_pgrp == CKPT_PID_NULL, below will
+			 * fail, so no need for explicit test
+			 */
+			ret = do_tiocspgrp(tty, tty_pair_get_tty(tty),
+					   h->tty_pgrp);
+			if (ret < 0)
+				goto out;
+		}
+	} else {
+		/*
+		 * If tty_objref isn't set, we _keep_ whatever tty we
+		 * already have as a ctty. Why does this make sense ?
+		 * - If our session is "within" the restart context,
+		 * then that session has no controlling terminal.
+		 * - If out session is "outside" the restart context,
+		 * then we're like to keep whatever we inherit from
+		 * the parent pid-ns.
+		 */
+	}
+
 	/*
 	 * Reset real/virt/prof itimer (in case they were set), to
 	 * prevent unwanted signals after flushing current signals
@@ -3252,7 +3314,20 @@ static int restore_signal(struct ckpt_ctx *ctx)
 	do_setitimer(ITIMER_VIRTUAL, &itimer, NULL);
 	do_setitimer(ITIMER_PROF, &itimer, NULL);
 
+	/* tty - tty_old_pgrp */
+	if (current->signal->leader && h->tty_old_pgrp != CKPT_PID_NULL) {
+		rcu_read_lock();
+		pgrp = get_pid(_ckpt_find_pgrp(ctx, h->tty_old_pgrp));
+		rcu_read_unlock();
+		if (!pgrp)
+			goto out;
+	}
+
 	spin_lock_irq(&current->sighand->siglock);
+	/* tty - tty_old_pgrp */
+	put_pid(current->signal->tty_old_pgrp);
+	current->signal->tty_old_pgrp = pgrp;
+	/* pending signals */
 	pending = &current->signal->shared_pending;
 	flush_sigqueue(pending);
 	pending->signal = new_pending.signal;
-- 
1.6.3.3

