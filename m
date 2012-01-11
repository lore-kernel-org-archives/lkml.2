Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028Ab2AKBRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 20:17:44 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:60223 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab2AKBRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 20:17:42 -0500
Date: Wed, 11 Jan 2012 11:47:30 +1030
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: cross memory attach && security check
Message-ID: <20120111114730.3e1fcf4d@Gantu.yeoh.info>
In-Reply-To: <20120109145342.GA1777@redhat.com>
References: <20120105151012.GA25671@redhat.com>
	<20120109174124.0d588b5b@Gantu.yeoh.info>
	<20120109145342.GA1777@redhat.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12011015-5140-0000-0000-0000009279AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jan 2012 15:53:42 +0100
Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/09, Christopher Yeoh wrote:
> >
> > On Thu, 5 Jan 2012 16:10:12 +0100
> > Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > >
> > > I guess you need ->cred_guard_mutex, please look at mm_for_maps().
> > >
> >
> > Thanks, agreed this looks like it's a problem. Need to do a bit more
> > testing, but I think the following patch fixes the race?
> >
> > @@ -298,9 +298,14 @@ static ssize_t process_vm_rw_core(pid_t pid,
> > const struct iovec *lvec, goto free_proc_pages;
> >  	}
> >
> > +	rc =
> > mutex_lock_interruptible(&task->signal->cred_guard_mutex);
> > +	if (rc)
> > +		goto put_task_struct;
> > +
> >  	task_lock(task);
> >  	if (__ptrace_may_access(task, PTRACE_MODE_ATTACH)) {
> >  		task_unlock(task);
> > +		mutex_unlock(&task->signal->cred_guard_mutex);
> 
> Yes, I think this works, but I don't think you should play with
> task_lock() or ->mm_users, just use get_task_mm(). Better yet, can't
> we do
> 

I agree with the consolidation with mm_for_maps (though we might need
to argue over EPERM vs EACCES. However, I originally broke out
get_task_mm and ptrace_may_access using __ptrace_may_access instead
because both these functions grab the task lock at the start and
release it at the end. Seemed better just to take it once.

So maybe something like this (untested) instead? 

diff --git a/kernel/fork.c b/kernel/fork.c
index f34f894..162562d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -644,6 +644,37 @@ struct mm_struct *get_task_mm(struct task_struct *task)
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
+	task_lock(task);
+	if (__ptrace_may_access(task, mode)) {
+		mm = ERR_PTR(-EPERM);
+		goto out;
+	}
+
+	mm = task->mm;
+	if (mm) {
+		if (task->flags & PF_KTHREAD)
+			mm = NULL;
+		else
+			atomic_inc(&mm->mm_users);
+	}
+
+out:
+	task_unlock(task);
+	mutex_unlock(&task->signal->cred_guard_mutex);
+
+	return mm;
+}
+EXPORT_SYMBOL_GPL(get_check_task_mm);
+
 /* Please note the differences between mmput and mm_release.
  * mmput is called whenever we stop holding onto a mm_struct,
  * error success whatever.

> > Other than reading the comment for get_user_pages saying that I
> > don't want to set the force flag, I didn't really consider it. The
> > use cases where I'm interested (intranode communication) has the
> > cooperation of the target process anyway so its not needed. Any
> > downsides to having FOLL_FORCE enabled?
> 
> Without FOLL_FORCE, say, gdb can't use the new syscall to set the
> breakpoint or to read the !VM_READ mappings. OK, process_vm_rw() has
> flags, we can add PROCESS_VM_FORCE if needed.
> 

It wasn't really intended for gdb, but perhaps it could be
used/consolidated with other ptrace stuff (I don't know). I'm not
really sure what the best thing to do here is. As I mentioned there is
a level of cooperation where I am using it and honouring mprotect may
help pickup inadvertent application errors. Perhaps a PROCESS_VM_FORCE
flag would be the more conservative option.

> However. Yes, this is subjective, but imho the new argument looks a
> bit ugly. Please look at this code again,
> 
> 	rw_copy_check_uvector(READ, rvec, check_access => 0);
> 
> what does this READ means without check_access? Plus we need another
> argument. Can't we do
> 
> 	--- x/fs/read_write.c
> 	+++ x/fs/read_write.c
> 	@@ -633,8 +633,7 @@ ssize_t do_loop_readv_writev(struct file
> 	 ssize_t rw_copy_check_uvector(int type, const struct iovec
> __user * uvector, unsigned long nr_segs, unsigned long fast_segs,
> 				      struct iovec *fast_pointer,
> 	-			      struct iovec **ret_pointer,
> 	-			      int check_access)
> 	+			      struct iovec **ret_pointer)
> 	 {
> 		unsigned long seg;
> 		ssize_t ret;
> 	@@ -690,8 +689,8 @@ ssize_t rw_copy_check_uvector(int type, 
> 				ret = -EINVAL;
> 				goto out;
> 			}
> 	-		if (check_access
> 	-		    && unlikely(!access_ok(vrfy_dir(type),
> buf, len))) {
> 	+		if (type >= 0 &&
> 	+		    unlikely(!access_ok(vrfy_dir(type), buf,
> len))) { ret = -EFAULT;
> 				goto out;
> 			}
> 
> and update the callers? In this case all callers just lose the
> unneeded argument and the code above does
> 
> 	rw_copy_check_uvector(-1, rvec);
> 
> Perhaps we can add another NOCHECK (or whatever) define near
> READ/WRITE.
> 
> What do you think?

Yes, this is much better. I think for readability we do need a define.

rw_copy_check_uvector(NOCHECK, rvec) 

looks a bit odd (why am I passing NOCHECK to a function with the
word check in it?). So perhaps maybe IOVEC_ONLY or something like that?

Regards,

Chris
-- 
cyeoh@au.ibm.com

