Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288Ab2DJTrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 15:47:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab2DJTrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 15:47:10 -0400
Date: Tue, 10 Apr 2012 21:46:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] creds: kill __task_cred()->task_is_dead() validation
Message-ID: <20120410194625.GB7196@redhat.com>
References: <20120410194554.GA7196@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410194554.GA7196@redhat.com>
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
found the bugy users in drivers/staging/, the fix already exists.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
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


