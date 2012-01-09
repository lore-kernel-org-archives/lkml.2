Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab2AIO7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 09:59:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854Ab2AIO7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 09:59:34 -0500
Date: Mon, 9 Jan 2012 15:53:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, Chris Yeoh <yeohc@au1.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: cross memory attach && security check
Message-ID: <20120109145342.GA1777@redhat.com>
References: <20120105151012.GA25671@redhat.com> <20120109174124.0d588b5b@Gantu.yeoh.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109174124.0d588b5b@Gantu.yeoh.info>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09, Christopher Yeoh wrote:
>
> On Thu, 5 Jan 2012 16:10:12 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Just noticed the new file in mm/ ;) A couple of questions.
> >
> > process_vm_rw_core() does
> >
> > 	task_lock(task);
> > 	if (__ptrace_may_access(task, PTRACE_MODE_ATTACH)) {
> > 		task_unlock(task);
> > 		rc = -EPERM;
> > 		goto put_task_struct;
> > 	}
> > 	mm = task->mm;
> >
> > this is racy, task_lock() can't help. And I don't think you should
> > use it directly.
> >
> > execve() does exec_mmap() first, this switches to the new ->mm.
> > After that install_exec_creds() changes task->cred. The window
> > is not that small.
> >
> > I guess you need ->cred_guard_mutex, please look at mm_for_maps().
> >
>
> Thanks, agreed this looks like it's a problem. Need to do a bit more
> testing, but I think the following patch fixes the race?
>
> @@ -298,9 +298,14 @@ static ssize_t process_vm_rw_core(pid_t pid, const struct iovec *lvec,
>  		goto free_proc_pages;
>  	}
>
> +	rc = mutex_lock_interruptible(&task->signal->cred_guard_mutex);
> +	if (rc)
> +		goto put_task_struct;
> +
>  	task_lock(task);
>  	if (__ptrace_may_access(task, PTRACE_MODE_ATTACH)) {
>  		task_unlock(task);
> +		mutex_unlock(&task->signal->cred_guard_mutex);

Yes, I think this works, but I don't think you should play with task_lock()
or ->mm_users, just use get_task_mm(). Better yet, can't we do

	--- x/fs/proc/base.c
	+++ x/fs/proc/base.c
	@@ -254,22 +254,7 @@ static struct mm_struct *check_mem_permission(struct task_struct *task)
	 
	 struct mm_struct *mm_for_maps(struct task_struct *task)
	 {
	-	struct mm_struct *mm;
	-	int err;
	-
	-	err =  mutex_lock_killable(&task->signal->cred_guard_mutex);
	-	if (err)
	-		return ERR_PTR(err);
	-
	-	mm = get_task_mm(task);
	-	if (mm && mm != current->mm &&
	-			!ptrace_may_access(task, PTRACE_MODE_READ)) {
	-		mmput(mm);
	-		mm = ERR_PTR(-EACCES);
	-	}
	-	mutex_unlock(&task->signal->cred_guard_mutex);
	-
	-	return mm;
	+	return get_check_task_mm(task, PTRACE_MODE_READ);
	 }
	 
	 static int proc_pid_cmdline(struct task_struct *task, char * buffer)
	--- x/kernel/fork.c
	+++ x/kernel/fork.c
	@@ -644,6 +644,25 @@ struct mm_struct *get_task_mm(struct task_struct *task)
	 }
	 EXPORT_SYMBOL_GPL(get_task_mm);
	 
	+struct mm_struct *get_check_task_mm(struct task_struct *task, unsigned int mode)
	+{
	+	struct mm_struct *mm;
	+	int err;
	+
	+	err =  mutex_lock_killable(&task->signal->cred_guard_mutex);
	+	if (err)
	+		return ERR_PTR(err);
	+
	+	mm = get_task_mm(task);
	+	if (mm && mm != current->mm && !ptrace_may_access(task, mode)) {
	+		mmput(mm);
	+		mm = ERR_PTR(-EACCES);
	+	}
	+	mutex_unlock(&task->signal->cred_guard_mutex);
	+
	+	return mm;
	+}
	+
	 /* Please note the differences between mmput and mm_release.
	  * mmput is called whenever we stop holding onto a mm_struct,
	  * error success whatever.

?

Then process_vm_rw_core() can use get_check_task_mm(PTRACE_MODE_ATTACH).

> Other than reading the comment for get_user_pages saying that I don't want
> to set the force flag, I didn't really consider it. The use cases where I'm
> interested (intranode communication) has the cooperation of the target process
> anyway so its not needed. Any downsides to having FOLL_FORCE enabled?

Without FOLL_FORCE, say, gdb can't use the new syscall to set the breakpoint
or to read the !VM_READ mappings. OK, process_vm_rw() has flags, we can
add PROCESS_VM_FORCE if needed.

> > Hmm. And could you please explain the change in
> > rw_copy_check_uvector()? Why process_vm_rw() does
> > rw_copy_check_uvector(READ, rvec, check_access => 0) ?
>
> process_vm_readv/writev get passed an iovec for another process

Ah. Thanks I see. And I didn't realize that rvec means "remote vec".
Partly I was confused because (I guess) there is another minor bug in
process_vm_rw(), I think we need

	--- x/mm/process_vm_access.c
	+++ x/mm/process_vm_access.c
	@@ -375,10 +375,10 @@ static ssize_t process_vm_rw(pid_t pid,
	 
		/* Check iovecs */
		if (vm_write)
	-		rc = rw_copy_check_uvector(WRITE, lvec, liovcnt, UIO_FASTIOV,
	+		rc = rw_copy_check_uvector(READ, lvec, liovcnt, UIO_FASTIOV,
						   iovstack_l, &iov_l, 1);
		else
	-		rc = rw_copy_check_uvector(READ, lvec, liovcnt, UIO_FASTIOV,
	+		rc = rw_copy_check_uvector(WRITE, lvec, liovcnt, UIO_FASTIOV,
						   iovstack_l, &iov_l, 1);
		if (rc <= 0)
			goto free_iovecs;


However. Yes, this is subjective, but imho the new argument looks a bit
ugly. Please look at this code again,

	rw_copy_check_uvector(READ, rvec, check_access => 0);

what does this READ means without check_access? Plus we need another
argument. Can't we do

	--- x/fs/read_write.c
	+++ x/fs/read_write.c
	@@ -633,8 +633,7 @@ ssize_t do_loop_readv_writev(struct file
	 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
				      unsigned long nr_segs, unsigned long fast_segs,
				      struct iovec *fast_pointer,
	-			      struct iovec **ret_pointer,
	-			      int check_access)
	+			      struct iovec **ret_pointer)
	 {
		unsigned long seg;
		ssize_t ret;
	@@ -690,8 +689,8 @@ ssize_t rw_copy_check_uvector(int type, 
				ret = -EINVAL;
				goto out;
			}
	-		if (check_access
	-		    && unlikely(!access_ok(vrfy_dir(type), buf, len))) {
	+		if (type >= 0 &&
	+		    unlikely(!access_ok(vrfy_dir(type), buf, len))) {
				ret = -EFAULT;
				goto out;
			}

and update the callers? In this case all callers just lose the unneeded
argument and the code above does

	rw_copy_check_uvector(-1, rvec);

Perhaps we can add another NOCHECK (or whatever) define near READ/WRITE.

What do you think?

Oleg.

