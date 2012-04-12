Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761962Ab2DLCtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 22:49:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761829Ab2DLCtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 22:49:13 -0400
Date: Thu, 12 Apr 2012 04:48:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] cred: change keyctl_session_to_parent() to use
	task_work_queue()
Message-ID: <20120412024825.GB17984@redhat.com>
References: <20120412024751.GA17561@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412024751.GA17561@redhat.com>
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

We do not report the error if we race with the exiting parent
and task_work_queue() fails, this matches the current behaviour.

As a side effect, this fixes the (unlikely) race. The callers
of key_replace_session_keyring() and keyctl_session_to_parent()
lack the necessary barriers, the parent can miss the request.

Now we can remove task_struct->replacement_session_keyring and
related code.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/key.h          |    2 +-
 security/keys/keyctl.c       |   87 +++++++++++++++++++++++++++++++-----------
 security/keys/process_keys.c |   49 -----------------------
 3 files changed, 65 insertions(+), 73 deletions(-)

diff --git a/include/linux/key.h b/include/linux/key.h
index 96933b1..2f00c2a 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -303,7 +303,7 @@ static inline bool key_is_instantiated(const struct key *key)
 extern ctl_table key_sysctls[];
 #endif
 
-extern void key_replace_session_keyring(void);
+#define key_replace_session_keyring()	do { } while (0)
 
 /*
  * the userspace interface
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index fb767c6..00b2e02 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -22,6 +22,7 @@
 #include <linux/err.h>
 #include <linux/vmalloc.h>
 #include <linux/security.h>
+#include <linux/task_work.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -1409,6 +1410,53 @@ long keyctl_get_security(key_serial_t keyid,
 	return ret;
 }
 
+static void replace_session_keyring(struct task_work *twork)
+{
+	const struct cred *old = current_cred();
+	struct cred *new = twork->data;
+
+	kfree(twork);
+	if (unlikely(current->flags & PF_EXITING)) {
+		put_cred(new);
+		return;
+	}
+
+	new->  uid	= old->  uid;
+	new-> euid	= old-> euid;
+	new-> suid	= old-> suid;
+	new->fsuid	= old->fsuid;
+	new->  gid	= old->  gid;
+	new-> egid	= old-> egid;
+	new-> sgid	= old-> sgid;
+	new->fsgid	= old->fsgid;
+	new->user	= get_uid(old->user);
+	new->user_ns	= new->user->user_ns;
+	new->group_info	= get_group_info(old->group_info);
+
+	new->securebits	= old->securebits;
+	new->cap_inheritable	= old->cap_inheritable;
+	new->cap_permitted	= old->cap_permitted;
+	new->cap_effective	= old->cap_effective;
+	new->cap_bset		= old->cap_bset;
+
+	new->jit_keyring	= old->jit_keyring;
+	new->thread_keyring	= key_get(old->thread_keyring);
+	new->tgcred->tgid	= old->tgcred->tgid;
+	new->tgcred->process_keyring = key_get(old->tgcred->process_keyring);
+
+	security_transfer_creds(new, old);
+
+	commit_creds(new);
+}
+
+static void free_cred_work(struct task_work *twork)
+{
+	if (twork) {
+		put_cred(twork->data);
+		kfree(twork);
+	}
+}
+
 /*
  * Attempt to install the calling process's session keyring on the process's
  * parent process.
@@ -1423,27 +1471,31 @@ long keyctl_get_security(key_serial_t keyid,
  */
 long keyctl_session_to_parent(void)
 {
-#ifdef TIF_NOTIFY_RESUME
 	struct task_struct *me, *parent;
 	const struct cred *mycred, *pcred;
-	struct cred *cred, *oldcred;
+	struct task_work *newwork, *oldwork;
 	key_ref_t keyring_r;
+	struct cred *cred;
 	int ret;
 
 	keyring_r = lookup_user_key(KEY_SPEC_SESSION_KEYRING, 0, KEY_LINK);
 	if (IS_ERR(keyring_r))
 		return PTR_ERR(keyring_r);
 
+	ret = -ENOMEM;
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
+	init_task_work(newwork, replace_session_keyring, cred);
 
 	me = current;
 	rcu_read_lock();
@@ -1484,20 +1536,17 @@ long keyctl_session_to_parent(void)
 	    mycred->tgcred->session_keyring->uid != mycred->euid)
 		goto not_permitted;
 
-	/* if there's an already pending keyring replacement, then we replace
-	 * that */
-	oldcred = parent->replacement_session_keyring;
+	/* cancel an already pending keyring replacement */
+	oldwork = task_work_cancel(parent, replace_session_keyring);
 
 	/* the replacement session keyring is applied just prior to userspace
 	 * restarting */
-	parent->replacement_session_keyring = cred;
-	cred = NULL;
-	set_ti_thread_flag(task_thread_info(parent), TIF_NOTIFY_RESUME);
-
+	if (!task_work_queue(parent, newwork))
+		newwork = NULL;
 	write_unlock_irq(&tasklist_lock);
 	rcu_read_unlock();
-	if (oldcred)
-		put_cred(oldcred);
+	free_cred_work(oldwork);
+	free_cred_work(newwork);
 	return 0;
 
 already_same:
@@ -1505,21 +1554,13 @@ already_same:
 not_permitted:
 	write_unlock_irq(&tasklist_lock);
 	rcu_read_unlock();
-	put_cred(cred);
+	free_cred_work(newwork);
 	return ret;
 
 error_keyring:
+	kfree(newwork);
 	key_ref_put(keyring_r);
 	return ret;
-
-#else /* !TIF_NOTIFY_RESUME */
-	/*
-	 * To be removed when TIF_NOTIFY_RESUME has been implemented on
-	 * m68k/xtensa
-	 */
-#warning TIF_NOTIFY_RESUME not implemented
-	return -EOPNOTSUPP;
-#endif /* !TIF_NOTIFY_RESUME */
 }
 
 /*
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index be7ecb2..6629137 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -827,52 +827,3 @@ error:
 	abort_creds(new);
 	return ret;
 }
-
-/*
- * Replace a process's session keyring on behalf of one of its children when
- * the target  process is about to resume userspace execution.
- */
-void key_replace_session_keyring(void)
-{
-	const struct cred *old;
-	struct cred *new;
-
-	if (!current->replacement_session_keyring)
-		return;
-
-	write_lock_irq(&tasklist_lock);
-	new = current->replacement_session_keyring;
-	current->replacement_session_keyring = NULL;
-	write_unlock_irq(&tasklist_lock);
-
-	if (!new)
-		return;
-
-	old = current_cred();
-	new->  uid	= old->  uid;
-	new-> euid	= old-> euid;
-	new-> suid	= old-> suid;
-	new->fsuid	= old->fsuid;
-	new->  gid	= old->  gid;
-	new-> egid	= old-> egid;
-	new-> sgid	= old-> sgid;
-	new->fsgid	= old->fsgid;
-	new->user	= get_uid(old->user);
-	new->user_ns	= new->user->user_ns;
-	new->group_info	= get_group_info(old->group_info);
-
-	new->securebits	= old->securebits;
-	new->cap_inheritable	= old->cap_inheritable;
-	new->cap_permitted	= old->cap_permitted;
-	new->cap_effective	= old->cap_effective;
-	new->cap_bset		= old->cap_bset;
-
-	new->jit_keyring	= old->jit_keyring;
-	new->thread_keyring	= key_get(old->thread_keyring);
-	new->tgcred->tgid	= old->tgcred->tgid;
-	new->tgcred->process_keyring = key_get(old->tgcred->process_keyring);
-
-	security_transfer_creds(new, old);
-
-	commit_creds(new);
-}
-- 
1.5.5.1


