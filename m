Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab0G2LrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 07:47:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404Ab0G2LrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 07:47:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] CRED: Fix __task_cred()'s lockdep check and banner comment
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 29 Jul 2010 12:45:55 +0100
Message-ID: <20100729114555.29508.4525.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100729114549.29508.44899.stgit@warthog.procyon.org.uk>
References: <20100729114549.29508.44899.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix __task_cred()'s lockdep check by removing the following validation
condition:

	lockdep_tasklist_lock_is_held()

as commit_creds() does not take the tasklist_lock, and nor do most of the
functions that call it, so this check is pointless and it can prevent
detection of the RCU lock not being held if the tasklist_lock is held.

Instead, add the following validation condition:

	task->exit_state >= 0

to permit the access if the target task is dead and therefore unable to change
its own credentials.


Fix __task_cred()'s comment to:

 (1) discard the bit that says that the caller must prevent the target task
     from being deleted.  That shouldn't need saying.

 (2) Add a comment indicating the result of __task_cred() should not be passed
     directly to get_cred(), but rather than get_task_cred() should be used
     instead.

Also put a note into the documentation to enforce this point there too.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 Documentation/credentials.txt |    3 +++
 include/linux/cred.h          |   15 ++++++++++-----
 include/linux/sched.h         |    1 +
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/Documentation/credentials.txt b/Documentation/credentials.txt
index a2db352..995baf3 100644
--- a/Documentation/credentials.txt
+++ b/Documentation/credentials.txt
@@ -417,6 +417,9 @@ reference on them using:
 This does all the RCU magic inside of it.  The caller must call put_cred() on
 the credentials so obtained when they're finished with.
 
+ [*] Note: The result of __task_cred() should not be passed directly to
+     get_cred() as this may race with commit_cred().
+
 There are a couple of convenience functions to access bits of another task's
 credentials, hiding the RCU magic from the caller:
 
diff --git a/include/linux/cred.h b/include/linux/cred.h
index ce40cbc..4d2c395 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -274,13 +274,18 @@ static inline void put_cred(const struct cred *_cred)
  * @task: The task to query
  *
  * Access the objective credentials of a task.  The caller must hold the RCU
- * readlock.
+ * readlock or the task must be dead and unable to change its own credentials.
  *
- * The caller must make sure task doesn't go away, either by holding a ref on
- * task or by holding tasklist_lock to prevent it from being unlinked.
+ * The result of this function should not be passed directly to get_cred();
+ * rather get_task_cred() should be used instead.
  */
-#define __task_cred(task) \
-	((const struct cred *)(rcu_dereference_check((task)->real_cred, rcu_read_lock_held() || lockdep_tasklist_lock_is_held())))
+#define __task_cred(task)						\
+	({								\
+		const struct task_struct *__t = (task);			\
+		rcu_dereference_check(__t->real_cred,			\
+				      rcu_read_lock_held() ||		\
+				      task_is_dead(__t));		\
+	})
 
 /**
  * get_current_cred - Get the current task's subjective credentials
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 747fcae..0478888 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -214,6 +214,7 @@ extern char ___assert_task_state[1 - 2*!!(
 
 #define task_is_traced(task)	((task->state & __TASK_TRACED) != 0)
 #define task_is_stopped(task)	((task->state & __TASK_STOPPED) != 0)
+#define task_is_dead(task)	((task)->exit_state != 0)
 #define task_is_stopped_or_traced(task)	\
 			((task->state & (__TASK_STOPPED | __TASK_TRACED)) != 0)
 #define task_contributes_to_load(task)	\

