Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab2F0Sko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 14:40:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606Ab2F0Skl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 14:40:41 -0400
Date: Wed, 27 Jun 2012 20:38:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 4/4] task_work: kill task_work->data
Message-ID: <20120627183828.GE23086@redhat.com>
References: <1340369098.2464.20.camel@falcor> <20120623092049.GH14083@ZenIV.linux.org.uk> <20120623194505.GI14083@ZenIV.linux.org.uk> <20120623203800.GA10306@redhat.com> <20120623210141.GK14083@ZenIV.linux.org.uk> <20120624041652.GN14083@ZenIV.linux.org.uk> <20120624153310.GB24596@redhat.com> <20120625060357.GT14083@ZenIV.linux.org.uk> <20120625151812.GA16062@redhat.com> <20120627183721.GA23086@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627183721.GA23086@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill task_work->data, this makes sizeof(task_work) == sizeof(rcu_head).

Turn cred->rcu into rcu_head/task_work union for keyctl_session_to_parent().

Suggested-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/cred.h         |    6 +++++-
 include/linux/task_work.h    |    4 +---
 kernel/irq/manage.c          |    2 +-
 security/keys/keyctl.c       |   31 +++++++++++--------------------
 security/keys/process_keys.c |    3 +--
 5 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index ebbed2c..a24c353 100644
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
+		struct task_work twork;	/* keyctl_session_to_parent() */
+	};
 };
 
 extern void __put_cred(struct cred *);
diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index ef70b01..09e470d 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -8,14 +8,12 @@ typedef void (*task_work_func_t)(struct task_work *);
 struct task_work {
 	struct task_work *next;
 	task_work_func_t func;
-	void *data;
 };
 
 static inline void
-init_task_work(struct task_work *twork, task_work_func_t func, void *data)
+init_task_work(struct task_work *twork, task_work_func_t func)
 {
 	twork->func = func;
-	twork->data = data;
 }
 
 int task_work_add(struct task_struct *task, struct task_work *twork, bool);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 8c54823..d1dd547 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -830,7 +830,7 @@ static int irq_thread(void *data)
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
 
-	init_task_work(&on_exit_work, irq_thread_dtor, NULL);
+	init_task_work(&on_exit_work, irq_thread_dtor);
 	task_work_add(current, &on_exit_work, false);
 
 	while (!irq_wait_for_interrupt(action)) {
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 0f5b3f0..f221cab 100644
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
+	init_task_work(&cred->twork, key_change_session_keyring);
 
 	me = current;
 	rcu_read_lock();
@@ -1527,24 +1523,19 @@ long keyctl_session_to_parent(void)
 
 	/* the replacement session keyring is applied just prior to userspace
 	 * restarting */
-	ret = task_work_add(parent, newwork, true);
+	ret = task_work_add(parent, &cred->twork, true);
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
+		put_cred(container_of(oldwork, struct cred, twork));
+	if (cred)
+		put_cred(cred);
 	return ret;
 
-error_newwork:
-	kfree(newwork);
 error_keyring:
 	key_ref_put(keyring_r);
 	return ret;
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 4ad54ee..01303c2 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -837,9 +837,8 @@ error:
 void key_change_session_keyring(struct task_work *twork)
 {
 	const struct cred *old = current_cred();
-	struct cred *new = twork->data;
+	struct cred *new = container_of(twork, struct cred, twork);
 
-	kfree(twork);
 	if (unlikely(current->flags & PF_EXITING)) {
 		put_cred(new);
 		return;
-- 
1.5.5.1


