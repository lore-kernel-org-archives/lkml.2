Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab0G1NRn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 09:17:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab0G1NRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 09:17:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <18537.1280318862@redhat.com>
References: <18537.1280318862@redhat.com> <AANLkTikB9Msot4m_oaw+V+dvEg+SzyXHb0cqhKQqUtC2@mail.gmail.com> <20100727155023.GF1967@jolsa.brq.redhat.com> <AANLkTineVrcffFWGxQ+EzYno6xvcNS9=M7hn_KddASnQ@mail.gmail.com> <24865.1280249187@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] cred - synchronize rcu before releasing cred
Date: Wed, 28 Jul 2010 14:17:27 +0100
Message-ID: <19398.1280323047@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The attached patch should suffice to fix get_task_cred(), and should render
Jiri's patch unnecessary.

David
---
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CRED: Move get_task_cred() out of line and make it use atomic_inc_not_zero()

It's possible for get_task_cred() as it currently stands to 'corrupt' a set of
credentials by incrementing their usage count after their replacement by the
task being accessed.

What happens is that get_task_cred() engages the RCU read lock, accesses the cred


	TASK_1			TASK_2			RCU_CLEANER
	-->get_task_cred(TASK_2)
	rcu_read_lock()
	__cred = __task_cred(TASK_2)
				-->commit_creds()
				old_cred = TASK_2->real_cred
				TASK_2->real_cred = ...
				put_cred(old_cred)
				  call_rcu(old_cred)
		[__cred->usage == 0]
	get_cred(__cred)
		[__cred->usage == 1]
	rcu_read_unlock()
							-->put_cred_rcu()
							[__cred->usage == 1]
							panic()

However, since a tasks credentials are generally not changed very often, we can
reasonably make use of a loop involving reading the creds pointer and using
atomic_inc_not_zero() to attempt to increment it if it hasn't already hit zero.

If successful, we can safely return the credentials in the knowledge that, even
if the task we're accessing has released them, they haven't gone to the RCU
cleanup code.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/cred.h |   21 +--------------------
 kernel/cred.c        |   25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 20 deletions(-)


diff --git a/include/linux/cred.h b/include/linux/cred.h
index 75c0fa8..ce40cbc 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -153,6 +153,7 @@ struct cred {
 extern void __put_cred(struct cred *);
 extern void exit_creds(struct task_struct *);
 extern int copy_creds(struct task_struct *, unsigned long);
+extern const struct cred *get_task_cred(struct task_struct *);
 extern struct cred *cred_alloc_blank(void);
 extern struct cred *prepare_creds(void);
 extern struct cred *prepare_exec_creds(void);
@@ -282,26 +283,6 @@ static inline void put_cred(const struct cred *_cred)
 	((const struct cred *)(rcu_dereference_check((task)->real_cred, rcu_read_lock_held() || lockdep_tasklist_lock_is_held())))
 
 /**
- * get_task_cred - Get another task's objective credentials
- * @task: The task to query
- *
- * Get the objective credentials of a task, pinning them so that they can't go
- * away.  Accessing a task's credentials directly is not permitted.
- *
- * The caller must make sure task doesn't go away, either by holding a ref on
- * task or by holding tasklist_lock to prevent it from being unlinked.
- */
-#define get_task_cred(task)				\
-({							\
-	struct cred *__cred;				\
-	rcu_read_lock();				\
-	__cred = (struct cred *) __task_cred((task));	\
-	get_cred(__cred);				\
-	rcu_read_unlock();				\
-	__cred;						\
-})
-
-/**
  * get_current_cred - Get the current task's subjective credentials
  *
  * Get the subjective credentials of the current task, pinning them so that
diff --git a/kernel/cred.c b/kernel/cred.c
index a2d5504..60bc8b1 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -209,6 +209,31 @@ void exit_creds(struct task_struct *tsk)
 	}
 }
 
+/**
+ * get_task_cred - Get another task's objective credentials
+ * @task: The task to query
+ *
+ * Get the objective credentials of a task, pinning them so that they can't go
+ * away.  Accessing a task's credentials directly is not permitted.
+ *
+ * The caller must also make sure task doesn't get deleted, either by holding a
+ * ref on task or by holding tasklist_lock to prevent it from being unlinked.
+ */
+const struct cred *get_task_cred(struct task_struct *task)
+{
+	const struct cred *cred;
+
+	rcu_read_lock();
+
+	do {
+		cred = __task_cred((task));
+		BUG_ON(!cred);
+	} while (!atomic_inc_not_zero(&((struct cred *)cred)->usage));
+
+	rcu_read_unlock();
+	return cred;
+}
+
 /*
  * Allocate blank credentials, such that the credentials can be filled in at a
  * later date without risk of ENOMEM.
