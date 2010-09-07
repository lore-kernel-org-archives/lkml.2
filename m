Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab0IGOAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:00:33 -0400
Received: from www.tglx.de ([62.245.132.106]:58758 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756181Ab0IGOA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:00:28 -0400
Message-Id: <20100907111349.782893465@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:00:00 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [patch 1/3] audit: Call tty_audit_push_task() outside preempt disabled
References: <20100907111326.202980881@linutronix.de>
Content-Disposition: inline;
	filename=audit-call-tty_audit_push_task-outside-preempt-disabled.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While auditing all tasklist_lock read_lock sites I stumbled over the
following call chain:

audit_prepare_user_tty()
  read_lock(&tasklist_lock);
  tty_audit_push_task();
     mutex_lock(&buf->mutex);

     --> buf->mutex is locked with preemption disabled.

Solve this by acquiring a reference to the task struct under
rcu_read_lock and call tty_audit_push_task outside of the preempt
disabled region.

Move all code which needs to be protected by sighand lock into
tty_audit_push_task() and use lock/unlock_sighand as we do not hold
tasklist_lock.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>

---
drivers/char/tty_audit.c |   38 ++++++++++++++++++++++++++++----------
 drivers/char/tty_audit.c |   38 ++++++++++++++++++++++++++++----------
 include/linux/tty.h      |    8 ++------
 kernel/audit.c           |   25 +++++++++----------------
 3 files changed, 39 insertions(+), 32 deletions(-)
Index: linux-2.6/drivers/char/tty_audit.c
===================================================================
--- linux-2.6.orig/drivers/char/tty_audit.c
+++ linux-2.6/drivers/char/tty_audit.c
@@ -188,25 +188,43 @@ void tty_audit_tiocsti(struct tty_struct
 }
 
 /**
- *	tty_audit_push_task	-	Flush task's pending audit data
+ * tty_audit_push_task	-	Flush task's pending audit data
+ * @tsk:		task pointer
+ * @loginuid:		sender login uid
+ * @sessionid:		sender session id
+ *
+ * Called with a ref on @tsk held. Try to lock sighand and get a
+ * reference to the tty audit buffer if available.
+ * Flush the buffer or return an appropriate error code.
  */
-void tty_audit_push_task(struct task_struct *tsk, uid_t loginuid, u32 sessionid)
+int tty_audit_push_task(struct task_struct *tsk, uid_t loginuid, u32 sessionid)
 {
-	struct tty_audit_buf *buf;
+	struct tty_audit_buf *buf = ERR_PTR(-EPERM);
+	unsigned long flags;
 
-	spin_lock_irq(&tsk->sighand->siglock);
-	buf = tsk->signal->tty_audit_buf;
-	if (buf)
-		atomic_inc(&buf->count);
-	spin_unlock_irq(&tsk->sighand->siglock);
-	if (!buf)
-		return;
+	if (!lock_task_sighand(tsk, &flags))
+		return -ESRCH;
+
+	if (tsk->signal->audit_tty) {
+		buf = tsk->signal->tty_audit_buf;
+		if (buf)
+			atomic_inc(&buf->count);
+	}
+	unlock_task_sighand(tsk, &flags);
+
+	/*
+	 * Return 0 when signal->audit_tty set
+	 * but tsk->signal->tty_audit_buf == NULL.
+	 */
+	if (!buf || IS_ERR(buf))
+		return PTR_ERR(buf);
 
 	mutex_lock(&buf->mutex);
 	tty_audit_buf_push(tsk, loginuid, sessionid, buf);
 	mutex_unlock(&buf->mutex);
 
 	tty_audit_buf_put(buf);
+	return 0;
 }
 
 /**
Index: linux-2.6/include/linux/tty.h
===================================================================
--- linux-2.6.orig/include/linux/tty.h
+++ linux-2.6/include/linux/tty.h
@@ -539,8 +539,8 @@ extern void tty_audit_exit(void);
 extern void tty_audit_fork(struct signal_struct *sig);
 extern void tty_audit_tiocsti(struct tty_struct *tty, char ch);
 extern void tty_audit_push(struct tty_struct *tty);
-extern void tty_audit_push_task(struct task_struct *tsk,
-					uid_t loginuid, u32 sessionid);
+extern int tty_audit_push_task(struct task_struct *tsk,
+			       uid_t loginuid, u32 sessionid);
 #else
 static inline void tty_audit_add_data(struct tty_struct *tty,
 				      unsigned char *data, size_t size)
@@ -558,10 +558,6 @@ static inline void tty_audit_fork(struct
 static inline void tty_audit_push(struct tty_struct *tty)
 {
 }
-static inline void tty_audit_push_task(struct task_struct *tsk,
-					uid_t loginuid, u32 sessionid)
-{
-}
 #endif
 
 /* tty_io.c */
Index: linux-2.6/kernel/audit.c
===================================================================
--- linux-2.6.orig/kernel/audit.c
+++ linux-2.6/kernel/audit.c
@@ -467,23 +467,16 @@ static int audit_prepare_user_tty(pid_t 
 	struct task_struct *tsk;
 	int err;
 
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	tsk = find_task_by_vpid(pid);
-	err = -ESRCH;
-	if (!tsk)
-		goto out;
-	err = 0;
-
-	spin_lock_irq(&tsk->sighand->siglock);
-	if (!tsk->signal->audit_tty)
-		err = -EPERM;
-	spin_unlock_irq(&tsk->sighand->siglock);
-	if (err)
-		goto out;
-
-	tty_audit_push_task(tsk, loginuid, sessionid);
-out:
-	read_unlock(&tasklist_lock);
+	if (!tsk) {
+		rcu_read_unlock();
+		return -ESRCH;
+	}
+	get_task_struct(tsk);
+	rcu_read_unlock();
+	err = tty_audit_push_task(tsk, loginuid, sessionid);
+	put_task_struct(tsk);
 	return err;
 }
 


