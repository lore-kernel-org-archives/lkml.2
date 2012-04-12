Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762807Ab2DLVN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:13:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849Ab2DLVNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:13:23 -0400
Date: Thu, 12 Apr 2012 23:12:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Gordeev <agordeev@redhat.com>, Chris Zankel <chris@zankel.net>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/3] cred: change keyctl_session_to_parent() to use
	task_work_queue()
Message-ID: <20120412211226.GB30456@redhat.com>
References: <20120412211146.GA30448@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412211146.GA30448@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change keyctl_session_to_parent() to use task_work_queue() and
move key_replace_session_keyring() logic into task_work->func().

Note that we do task_work_cancel() before task_work_queue() to
ensure that only one work can be pending at any time. This is
important, we must not allow user-space to abuse the parent's
->task_works list.

The callback, replace_session_keyring(), checks PF_EXITING.
I guess this is not really needed but looks better.

As a side effect, this fixes the (unlikely) race. The callers
of key_replace_session_keyring() and keyctl_session_to_parent()
lack the necessary barriers, the parent can miss the request.

Now we can remove task_struct->replacement_session_keyring and
related code.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/key.h          |    6 +--
 security/keys/internal.h     |    3 +-
 security/keys/keyctl.c       |   76 ++++++++++++++++++++----------------------
 security/keys/process_keys.c |   25 ++++----------
 4 files changed, 47 insertions(+), 63 deletions(-)

diff --git a/include/linux/key.h b/include/linux/key.h
index 96933b1..0c263d6 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -33,6 +33,8 @@ typedef uint32_t key_perm_t;
 
 struct key;
 
+#define key_replace_session_keyring()	do { } while (0)
+
 #ifdef CONFIG_KEYS
 
 #undef KEY_DEBUGGING
@@ -302,9 +304,6 @@ static inline bool key_is_instantiated(const struct key *key)
 #ifdef CONFIG_SYSCTL
 extern ctl_table key_sysctls[];
 #endif
-
-extern void key_replace_session_keyring(void);
-
 /*
  * the userspace interface
  */
@@ -327,7 +326,6 @@ extern void key_init(void);
 #define key_fsuid_changed(t)		do { } while(0)
 #define key_fsgid_changed(t)		do { } while(0)
 #define key_init()			do { } while(0)
-#define key_replace_session_keyring()	do { } while(0)
 
 #endif /* CONFIG_KEYS */
 #endif /* __KERNEL__ */
diff --git a/security/keys/internal.h b/security/keys/internal.h
index 65647f8..a81c319 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -12,7 +12,7 @@
 #ifndef _INTERNAL_H
 #define _INTERNAL_H
 
-#include <linux/sched.h>
+#include <linux/task_work.h>
 #include <linux/key-type.h>
 
 #ifdef __KDEBUG
@@ -148,6 +148,7 @@ extern key_ref_t lookup_user_key(key_serial_t id, unsigned long flags,
 #define KEY_LOOKUP_FOR_UNLINK	0x04
 
 extern long join_session_keyring(const char *name);
+extern void key_change_session_keyring(struct task_work *twork);
 
 extern struct work_struct key_gc_work;
 extern unsigned key_gc_delay;
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index fb767c6..5ccfff5 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1423,50 +1423,57 @@ long keyctl_get_security(key_serial_t keyid,
  */
 long keyctl_session_to_parent(void)
 {
-#ifdef TIF_NOTIFY_RESUME
 	struct task_struct *me, *parent;
 	const struct cred *mycred, *pcred;
-	struct cred *cred, *oldcred;
+	struct task_work *newwork, *oldwork;
 	key_ref_t keyring_r;
-	int ret;
+	struct cred *cred;
+	int err;
 
 	keyring_r = lookup_user_key(KEY_SPEC_SESSION_KEYRING, 0, KEY_LINK);
 	if (IS_ERR(keyring_r))
 		return PTR_ERR(keyring_r);
 
+	err = -ENOMEM;
+	newwork = kmalloc(sizeof(struct task_work), GFP_KERNEL);
+	if (!newwork)
+		goto error_keyring;
+
 	/* our parent is going to need a new cred struct, a new tgcred struct
 	 * and new security data, so we allocate them here to prevent ENOMEM in
 	 * our parent */
-	ret = -ENOMEM;
 	cred = cred_alloc_blank();
 	if (!cred)
 		goto error_keyring;
 
 	cred->tgcred->session_keyring = key_ref_to_ptr(keyring_r);
-	keyring_r = NULL;
+	init_task_work(newwork, key_change_session_keyring, cred);
 
 	me = current;
 	rcu_read_lock();
 	write_lock_irq(&tasklist_lock);
 
+	err = -EPERM;
+	oldwork = NULL;
 	parent = me->real_parent;
-	ret = -EPERM;
 
 	/* the parent mustn't be init and mustn't be a kernel thread */
 	if (parent->pid <= 1 || !parent->mm)
-		goto not_permitted;
+		goto unlock;
 
 	/* the parent must be single threaded */
 	if (!thread_group_empty(parent))
-		goto not_permitted;
+		goto unlock;
 
 	/* the parent and the child must have different session keyrings or
 	 * there's no point */
 	mycred = current_cred();
 	pcred = __task_cred(parent);
 	if (mycred == pcred ||
-	    mycred->tgcred->session_keyring == pcred->tgcred->session_keyring)
-		goto already_same;
+	    mycred->tgcred->session_keyring == pcred->tgcred->session_keyring) {
+		err = 0;
+		goto unlock;
+	}
 
 	/* the parent must have the same effective ownership and mustn't be
 	 * SUID/SGID */
@@ -1476,50 +1483,39 @@ long keyctl_session_to_parent(void)
 	    pcred->gid	!= mycred->egid	||
 	    pcred->egid	!= mycred->egid	||
 	    pcred->sgid	!= mycred->egid)
-		goto not_permitted;
+		goto unlock;
 
 	/* the keyrings must have the same UID */
 	if ((pcred->tgcred->session_keyring &&
 	     pcred->tgcred->session_keyring->uid != mycred->euid) ||
 	    mycred->tgcred->session_keyring->uid != mycred->euid)
-		goto not_permitted;
+		goto unlock;
 
-	/* if there's an already pending keyring replacement, then we replace
-	 * that */
-	oldcred = parent->replacement_session_keyring;
+	/* cancel an already pending keyring replacement */
+	oldwork = task_work_cancel(parent, key_change_session_keyring);
 
 	/* the replacement session keyring is applied just prior to userspace
 	 * restarting */
-	parent->replacement_session_keyring = cred;
-	cred = NULL;
-	set_ti_thread_flag(task_thread_info(parent), TIF_NOTIFY_RESUME);
-
-	write_unlock_irq(&tasklist_lock);
-	rcu_read_unlock();
-	if (oldcred)
-		put_cred(oldcred);
-	return 0;
-
-already_same:
-	ret = 0;
-not_permitted:
+	err = task_work_queue(parent, newwork, true);
+	if (!err)
+		newwork = NULL;
+unlock:
 	write_unlock_irq(&tasklist_lock);
 	rcu_read_unlock();
-	put_cred(cred);
-	return ret;
+	if (oldwork) {
+		put_cred(oldwork->data);
+		kfree(oldwork);
+	}
+	if (newwork) {
+		put_cred(newwork->data);
+		kfree(newwork);
+	}
+	return err;
 
 error_keyring:
+	kfree(newwork);
 	key_ref_put(keyring_r);
-	return ret;
-
-#else /* !TIF_NOTIFY_RESUME */
-	/*
-	 * To be removed when TIF_NOTIFY_RESUME has been implemented on
-	 * m68k/xtensa
-	 */
-#warning TIF_NOTIFY_RESUME not implemented
-	return -EOPNOTSUPP;
-#endif /* !TIF_NOTIFY_RESUME */
+	return err;
 }
 
 /*
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index be7ecb2..eb6d804 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -828,27 +828,17 @@ error:
 	return ret;
 }
 
-/*
- * Replace a process's session keyring on behalf of one of its children when
- * the target  process is about to resume userspace execution.
- */
-void key_replace_session_keyring(void)
+void key_change_session_keyring(struct task_work *twork)
 {
-	const struct cred *old;
-	struct cred *new;
+	const struct cred *old = current_cred();
+	struct cred *new = twork->data;
 
-	if (!current->replacement_session_keyring)
-		return;
-
-	write_lock_irq(&tasklist_lock);
-	new = current->replacement_session_keyring;
-	current->replacement_session_keyring = NULL;
-	write_unlock_irq(&tasklist_lock);
-
-	if (!new)
+	kfree(twork);
+	if (unlikely(current->flags & PF_EXITING)) {
+		put_cred(new);
 		return;
+	}
 
-	old = current_cred();
 	new->  uid	= old->  uid;
 	new-> euid	= old-> euid;
 	new-> suid	= old-> suid;
@@ -873,6 +863,5 @@ void key_replace_session_keyring(void)
 	new->tgcred->process_keyring = key_get(old->tgcred->process_keyring);
 
 	security_transfer_creds(new, old);
-
 	commit_creds(new);
 }
-- 
1.5.5.1


