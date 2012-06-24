Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab2FXPXG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 11:23:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab2FXPXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 11:23:02 -0400
Date: Sun, 24 Jun 2012 17:20:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: deferring __fput()
Message-ID: <20120624152050.GA24596@redhat.com>
References: <1340369098.2464.20.camel@falcor> <20120623092049.GH14083@ZenIV.linux.org.uk> <20120623194505.GI14083@ZenIV.linux.org.uk> <20120623205755.GJ14083@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120623205755.GJ14083@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23, Al Viro wrote:
>
> You know what...  Let's dump that "reverse the list" thing completely.

Yes, it was never really needed for fifo.

> What we ought to
> do instead of that is honestly keeping both the head of the (single-linked) list and
> pointer to pointer to its last element.  Sure, that'll eat one more word in task_struct.
> And it doesn't matter, since we'll be able to kill something else in there - namely,
> ->scm_work_list.

Still it is better to not add the second pointer, task->task_works can
point to the last work, and last_work->next points to the first one.

> 1) kill task_work->data; the only user that cares will allocate task_work + struct cred * and
> use container_of() to get to it.

OK. See the patch below. I need to cleanup it somehow (and test of course),
cred.h needs task_work.h but task_work.h needs task_struct.

And, David, can you suggest the good name for cred->xxx?

> 2) replace current->task_works with struct task_work *task_works, **last_work and replace
> hlist_node in task_work with struct task_work *next;

Yes, but see above.

> 3) at that point task_work is equal in size (and layout, BTW) to rcu_head.

Yep.

> [... snip ...]

I'll try to understand fput/scm issues later ;)

Oleg.


diff --git a/include/linux/cred.h b/include/linux/cred.h
index ebbed2c..d364255 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -18,6 +18,7 @@
 #include <linux/selinux.h>
 #include <linux/atomic.h>
 #include <linux/uidgid.h>
+#include <linux/task_work.h>
 
 struct user_struct;
 struct cred;
@@ -149,7 +150,10 @@ struct cred {
 	struct user_struct *user;	/* real user ID subscription */
 	struct user_namespace *user_ns; /* user_ns the caps and keyrings are relative to. */
 	struct group_info *group_info;	/* supplementary groups for euid/fsgid */
-	struct rcu_head	rcu;		/* RCU deletion hook */
+	union {
+		struct rcu_head	rcu;	/* RCU deletion hook */
+		struct task_work xxx; 	/* keyctl_session_to_parent() */
+	};
 };
 
 extern void __put_cred(struct cred *);
diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index 294d5d5..f834e38 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -1,9 +1,6 @@
 #ifndef _LINUX_TASK_WORK_H
 #define _LINUX_TASK_WORK_H
 
-#include <linux/list.h>
-#include <linux/sched.h>
-
 struct task_work;
 typedef void (*task_work_func_t)(struct task_work *);
 
@@ -24,10 +21,14 @@ int task_work_add(struct task_struct *task, struct task_work *twork, bool);
 struct task_work *task_work_cancel(struct task_struct *, task_work_func_t);
 void task_work_run(void);
 
-static inline void exit_task_work(struct task_struct *task)
-{
-	if (unlikely(!hlist_empty(&task->task_works)))
-		task_work_run();
-}
+#define exit_task_work(__task)	\
+	do {							\
+		struct task_struct *task = (__task);		\
+		if (unlikely(!hlist_empty(&task->task_works)))	\
+			task_work_run();			\
+	} while (0)
+
+#include <linux/list.h>
+#include <linux/sched.h>
 
 #endif	/* _LINUX_TASK_WORK_H */
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 0f5b3f0..cc428c9 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1456,8 +1456,8 @@ long keyctl_session_to_parent(void)
 {
 	struct task_struct *me, *parent;
 	const struct cred *mycred, *pcred;
-	struct task_work *newwork, *oldwork;
 	key_ref_t keyring_r;
+	struct task_work *oldwork;
 	struct cred *cred;
 	int ret;
 
@@ -1465,20 +1465,16 @@ long keyctl_session_to_parent(void)
 	if (IS_ERR(keyring_r))
 		return PTR_ERR(keyring_r);
 
-	ret = -ENOMEM;
-	newwork = kmalloc(sizeof(struct task_work), GFP_KERNEL);
-	if (!newwork)
-		goto error_keyring;
-
 	/* our parent is going to need a new cred struct, a new tgcred struct
 	 * and new security data, so we allocate them here to prevent ENOMEM in
 	 * our parent */
+	ret = -ENOMEM;
 	cred = cred_alloc_blank();
 	if (!cred)
-		goto error_newwork;
+		goto error_keyring;
 
 	cred->tgcred->session_keyring = key_ref_to_ptr(keyring_r);
-	init_task_work(newwork, key_change_session_keyring, cred);
+	init_task_work(&cred->xxx, key_change_session_keyring, NULL);
 
 	me = current;
 	rcu_read_lock();
@@ -1527,24 +1523,19 @@ long keyctl_session_to_parent(void)
 
 	/* the replacement session keyring is applied just prior to userspace
 	 * restarting */
-	ret = task_work_add(parent, newwork, true);
+	ret = task_work_add(parent, &cred->xxx, true);
 	if (!ret)
-		newwork = NULL;
+		cred = NULL;
 unlock:
 	write_unlock_irq(&tasklist_lock);
 	rcu_read_unlock();
-	if (oldwork) {
-		put_cred(oldwork->data);
-		kfree(oldwork);
-	}
-	if (newwork) {
-		put_cred(newwork->data);
-		kfree(newwork);
-	}
+
+	if (oldwork)
+		put_cred(container_of(oldwork, struct cred, xxx));
+	if (cred)
+		put_cred(cred);
 	return ret;
 
-error_newwork:
-	kfree(newwork);
 error_keyring:
 	key_ref_put(keyring_r);
 	return ret;
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 4ad54ee..5596caf 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -837,9 +837,8 @@ error:
 void key_change_session_keyring(struct task_work *twork)
 {
 	const struct cred *old = current_cred();
-	struct cred *new = twork->data;
+	struct cred *new = container_of(twork, struct cred, xxx);
 
-	kfree(twork);
 	if (unlikely(current->flags & PF_EXITING)) {
 		put_cred(new);
 		return;

