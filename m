Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab1I1UX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 16:23:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733Ab1I1UX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 16:23:57 -0400
Date: Wed, 28 Sep 2011 22:20:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stephen Wilson <wilsons@start.ca>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org
Subject: Q: proc: hold cred_guard_mutex in check_mem_permission()
Message-ID: <20110928202020.GA3164@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another change we probably need to backport, 18f661bc
"proc: hold cred_guard_mutex in check_mem_permission()".

>From the changelog:

    Avoid a potential race when task exec's and we get a new ->mm but
    check against the old credentials in ptrace_may_access().

Could you please explain? How can we race with exec?

This task is either current, or it is TASK_TRACED and we are the
tracer. In the latter case nobody can resume it except SIGKILL.
And the killed task obviously can't exec.

Afaics, all we need is: we should read task->mm after the
task_is_traced() check, we do not need the mutex.

IOW, what do you think about the patch below? I have no idea how
can I test it (and it wasn't even applied/compiled).

Also, I'd appreciate if you can explain the PTRACE_MODE_ATTACH
check. Again, we are already the tracer.

Oleg.

--- x/fs/proc/base.c
+++ x/fs/proc/base.c
@@ -194,38 +194,31 @@ static int proc_root_link(struct inode *
 	return result;
 }
 
-static struct mm_struct *__check_mem_permission(struct task_struct *task)
+static int __check_mem_permission(struct task_struct *task)
 {
-	struct mm_struct *mm;
-
-	mm = get_task_mm(task);
-	if (!mm)
-		return ERR_PTR(-EINVAL);
-
 	/*
 	 * A task can always look at itself, in case it chooses
 	 * to use system calls instead of load instructions.
 	 */
 	if (task == current)
-		return mm;
+		return 0;
 
 	/*
 	 * If current is actively ptrace'ing, and would also be
 	 * permitted to freshly attach with ptrace now, permit it.
 	 */
-	if (task_is_stopped_or_traced(task)) {
+	if (task_is_traced(task)) {
 		int match;
 		rcu_read_lock();
 		match = (ptrace_parent(task) == current);
 		rcu_read_unlock();
 		if (match && ptrace_may_access(task, PTRACE_MODE_ATTACH))
-			return mm;
+			return 0;
 	}
 
 	/*
 	 * No one else is allowed.
 	 */
-	mmput(mm);
 	return ERR_PTR(-EPERM);
 }
 
@@ -238,18 +231,11 @@ static struct mm_struct *check_mem_permi
 	struct mm_struct *mm;
 	int err;
 
-	/*
-	 * Avoid racing if task exec's as we might get a new mm but validate
-	 * against old credentials.
-	 */
-	err = mutex_lock_killable(&task->signal->cred_guard_mutex);
+	err = __check_mem_permission(task);
 	if (err)
 		return ERR_PTR(err);
 
-	mm = __check_mem_permission(task);
-	mutex_unlock(&task->signal->cred_guard_mutex);
-
-	return mm;
+	return get_task_mm(task) ?: ERR_PTR(-EINVAL);
 }
 
 struct mm_struct *mm_for_maps(struct task_struct *task)

