Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965245Ab2JAXf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:35:59 -0400
Received: from 1wt.eu ([62.212.114.60]:35085 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932575Ab2JAXAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:07 -0400
Message-Id: <20121001225159.437069092@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:40 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Louis Rilling <louis.rilling@kerlabs.com>,
        Jens Axboe <jens.axboe@oracle.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 043/180] block: Fix io_context leak after failure of clone with CLONE_IO
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Louis Rilling <louis.rilling@kerlabs.com>

commit b69f2292063d2caf37ca9aec7d63ded203701bf3 upstream

With CLONE_IO, parent's io_context->nr_tasks is incremented, but never
decremented whenever copy_process() fails afterwards, which prevents
exit_io_context() from calling IO schedulers exit functions.

Give a task_struct to exit_io_context(), and call exit_io_context() instead of
put_io_context() in copy_process() cleanup path.

Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 block/blk-ioc.c           |   10 +++++-----
 include/linux/iocontext.h |    5 +++--
 kernel/exit.c             |    2 +-
 kernel/fork.c             |    3 ++-
 4 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index dcd0412..cbdabb0 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -66,14 +66,14 @@ static void cfq_exit(struct io_context *ioc)
 }
 
 /* Called by the exitting task */
-void exit_io_context(void)
+void exit_io_context(struct task_struct *task)
 {
 	struct io_context *ioc;
 
-	task_lock(current);
-	ioc = current->io_context;
-	current->io_context = NULL;
-	task_unlock(current);
+	task_lock(task);
+	ioc = task->io_context;
+	task->io_context = NULL;
+	task_unlock(task);
 
 	if (atomic_dec_and_test(&ioc->nr_tasks)) {
 		if (ioc->aic && ioc->aic->exit)
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index eb73632..19abfc1 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -94,14 +94,15 @@ static inline struct io_context *ioc_task_link(struct io_context *ioc)
 	return NULL;
 }
 
+struct task_struct;
 #ifdef CONFIG_BLOCK
 int put_io_context(struct io_context *ioc);
-void exit_io_context(void);
+void exit_io_context(struct task_struct *task);
 struct io_context *get_io_context(gfp_t gfp_flags, int node);
 struct io_context *alloc_io_context(gfp_t gfp_flags, int node);
 void copy_io_context(struct io_context **pdst, struct io_context **psrc);
 #else
-static inline void exit_io_context(void)
+static inline void exit_io_context(struct task_struct *task)
 {
 }
 
diff --git a/kernel/exit.c b/kernel/exit.c
index 0f8fae3..a2a1659 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1020,7 +1020,7 @@ NORET_TYPE void do_exit(long code)
 	tsk->flags |= PF_EXITPIDONE;
 
 	if (tsk->io_context)
-		exit_io_context();
+		exit_io_context(tsk);
 
 	if (tsk->splice_pipe)
 		__free_pipe_info(tsk->splice_pipe);
diff --git a/kernel/fork.c b/kernel/fork.c
index 4bde56f..cd075bc 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1299,7 +1299,8 @@ bad_fork_free_pid:
 	if (pid != &init_struct_pid)
 		free_pid(pid);
 bad_fork_cleanup_io:
-	put_io_context(p->io_context);
+	if (p->io_context)
+		exit_io_context(p);
 bad_fork_cleanup_namespaces:
 	exit_task_namespaces(p);
 bad_fork_cleanup_mm:
-- 
1.7.2.1.45.g54fbc



