Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab1I2OUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:20:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab1I2OUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:20:46 -0400
Date: Thu, 29 Sep 2011 16:17:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stephen Wilson <wilsons@start.ca>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org
Subject: Q: proc: disable mem_write after exec
Message-ID: <20110929141706.GA17119@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

The last question, I promise ;)

Another change we probably need to backport,

    commit 26947f8c8f9598209001cdcd31bb2162a2e54691
    proc: disable mem_write after exec

    This change makes mem_write() observe the same constraints as mem_read().

mem_read() looks equally confusing to me, may be Linus can explain.
This self_exec_id check was added in 29f279c7 (history tree)
"v2.4.5.5 -> v2.4.5.6", the changelog can't help.

    This
    is particularly important for mem_write as an accidental leak of the fd across
    an exec could result in arbitrary modification of the target process' memory.

    ...

	@@ -850,6 +850,10 @@ static ssize_t mem_write(struct file * file, const char __user *buf,
		if (check_mem_permission(task))
			goto out;
	 
	+	copied = -EIO;
	+	if (file->private_data != (void *)((long)current->self_exec_id))
	+		goto out;
	+
		copied = -ENOMEM;
		page = (char *)__get_free_page(GFP_TEMPORARY);
		if (!page)


Could you explain this? Why this is wrong from the security pov? We are
the tracer, this was checked by check_mem_permission(). We can modify
this memory even without /proc/pid/mem.

And in any case, why do we check current's self_exec_id? I'd understand
if mem_open/mem_read/mem_writed used task->self_exec_id, see the trivial
patch below. With this patch this check means: this task has changed its
->mm after /proc/pid/mem was opened, abort. And perhaps this was the
actual intent. May be makes sense.

But the real question is, why (from the security pov) we can't simply kill
these self_exec_id checks?

Not to mention, it would be nice to remove self_exec_id/parent_exec_id too.
Ignoring mem_open(), afaics the _only_ reason we need these id's is that
linux allows clone(CLONE_PARENT | SIGKILL).

Thanks,

Oleg.


--- x/fs/proc/base.c
+++ x/fs/proc/base.c
@@ -816,7 +816,17 @@ static const struct file_operations proc
 
 static int mem_open(struct inode* inode, struct file* file)
 {
-	file->private_data = (void*)((long)current->self_exec_id);
+	struct task_struct *task;
+
+	rcu_read_lock();
+	task = pid_task(proc_pid(file->f_path.dentry->d_inode), PIDTYPE_PID);
+	if (task)
+		file->private_data = (void*)((long)task->self_exec_id);
+	rcu_read_unlock();
+
+	if (!task)
+		return -EINVAL;
+
 	/* OK to pass negative loff_t, we can catch out-of-range */
 	file->f_mode |= FMODE_UNSIGNED_OFFSET;
 	return 0;
@@ -846,7 +856,7 @@ static ssize_t mem_read(struct file * fi
 
 	ret = -EIO;
  
-	if (file->private_data != (void*)((long)current->self_exec_id))
+	if (file->private_data != (void*)((long)task->self_exec_id))
 		goto out_put;
 
 	ret = 0;
@@ -908,7 +918,7 @@ static ssize_t mem_write(struct file * f
 		goto out_free;
 
 	copied = -EIO;
-	if (file->private_data != (void *)((long)current->self_exec_id))
+	if (file->private_data != (void *)((long)task->self_exec_id))
 		goto out_mm;
 
 	copied = 0;

