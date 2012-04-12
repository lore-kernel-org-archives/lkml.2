Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934944Ab2DLWRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:17:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934784Ab2DLWRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:17:33 -0400
Date: Fri, 13 Apr 2012 00:17:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cred: remove task_is_dead() from __task_cred() validation
Message-ID: <20120412221705.GA853@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 8f92054e:

    add the following validation condition:

        task->exit_state >= 0

    to permit the access if the target task is dead and therefore
    unable to change its own credentials.

OK, but afaics currently this can only help wait_task_zombie() which
calls __task_cred() without rcu lock.

Remove this validation and change wait_task_zombie() to use task_uid()
instead. This means we do rcu_read_lock() only to shut up the lockdep,
but we already do the same in, say, wait_task_stopped().

task_is_dead() should die, task->exit_state != 0 means that this task
has passed exit_notify(), only do_wait-like code paths should use this.

Unfortunately, we can't kill task_is_dead() right now, it has already
acquired buggy users in drivers/staging. The fix already exists.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: David Howells <dhowells@redhat.com>
---
 include/linux/cred.h |   10 +++-------
 kernel/exit.c        |    2 +-
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index adadf71..1b64c72 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -276,17 +276,13 @@ static inline void put_cred(const struct cred *_cred)
  * @task: The task to query
  *
  * Access the objective credentials of a task.  The caller must hold the RCU
- * readlock or the task must be dead and unable to change its own credentials.
+ * readlock.
  *
  * The result of this function should not be passed directly to get_cred();
  * rather get_task_cred() should be used instead.
  */
-#define __task_cred(task)						\
-	({								\
-		const struct task_struct *__t = (task);			\
-		rcu_dereference_check(__t->real_cred,			\
-				      task_is_dead(__t));		\
-	})
+#define __task_cred(task)	\
+	rcu_dereference((task)->real_cred)
 
 /**
  * get_current_cred - Get the current task's subjective credentials
diff --git a/kernel/exit.c b/kernel/exit.c
index 4b4042f..7b36288 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1214,7 +1213,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 	unsigned long state;
 	int retval, status, traced;
 	pid_t pid = task_pid_vnr(p);
-	uid_t uid = __task_cred(p)->uid;
+	uid_t uid = task_uid(p);
 	struct siginfo __user *infop;
 
 	if (!likely(wo->wo_flags & WEXITED))
-- 
1.5.5.1


