Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250Ab2AKPzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 10:55:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757614Ab2AKPzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 10:55:35 -0500
Date: Wed, 11 Jan 2012 16:49:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: cross memory attach && security check
Message-ID: <20120111154941.GA23974@redhat.com>
References: <20120105151012.GA25671@redhat.com> <20120109174124.0d588b5b@Gantu.yeoh.info> <20120109145342.GA1777@redhat.com> <20120111114730.3e1fcf4d@Gantu.yeoh.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120111114730.3e1fcf4d@Gantu.yeoh.info>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11, Christopher Yeoh wrote:
>
> On Mon, 9 Jan 2012 15:53:42 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Yes, I think this works, but I don't think you should play with
> > task_lock() or ->mm_users, just use get_task_mm(). Better yet, can't
> > we do
> >
>
> I agree with the consolidation with mm_for_maps (though we might need
> to argue over EPERM vs EACCES. However, I originally broke out
> get_task_mm and ptrace_may_access using __ptrace_may_access instead
> because both these functions grab the task lock at the start and
> release it at the end. Seemed better just to take it once.
>
> +struct mm_struct *get_check_task_mm(struct task_struct *task, unsigned int mode)
> +{
> +	struct mm_struct *mm;
> +	int err;
> +
> +	err =  mutex_lock_killable(&task->signal->cred_guard_mutex);
> +	if (err)
> +		return ERR_PTR(err);
> +
> +	task_lock(task);
> +	if (__ptrace_may_access(task, mode)) {
> +		mm = ERR_PTR(-EPERM);
> +		goto out;
> +	}
> +
> +	mm = task->mm;
> +	if (mm) {
> +		if (task->flags & PF_KTHREAD)
> +			mm = NULL;
> +		else
> +			atomic_inc(&mm->mm_users);
> +	}
> +
> +out:
> +	task_unlock(task);

Well, this saves unlock+lock, but adds more copy-and-paste code.
Personally I'd prefer to consolidate.

> > Without FOLL_FORCE, say, gdb can't use the new syscall to set the
> > breakpoint or to read the !VM_READ mappings. OK, process_vm_rw() has
> > flags, we can add PROCESS_VM_FORCE if needed.
> >
>
> It wasn't really intended for gdb, but perhaps it could be
> used/consolidated with other ptrace stuff (I don't know). I'm not
> really sure what the best thing to do here is. As I mentioned there is
> a level of cooperation where I am using it and honouring mprotect may
> help pickup inadvertent application errors. Perhaps a PROCESS_VM_FORCE
> flag would be the more conservative option.

OK, agreed.

> > 	--- x/fs/read_write.c
> > 	+++ x/fs/read_write.c
> > 	@@ -633,8 +633,7 @@ ssize_t do_loop_readv_writev(struct file
> > 	 ssize_t rw_copy_check_uvector(int type, const struct iovec
> > __user * uvector, unsigned long nr_segs, unsigned long fast_segs,
> > 				      struct iovec *fast_pointer,
> > 	-			      struct iovec **ret_pointer,
> > 	-			      int check_access)
> > 	+			      struct iovec **ret_pointer)
> > 	 {
> > 		unsigned long seg;
> > 		ssize_t ret;
> > 	@@ -690,8 +689,8 @@ ssize_t rw_copy_check_uvector(int type,
> > 				ret = -EINVAL;
> > 				goto out;
> > 			}
> > 	-		if (check_access
> > 	-		    && unlikely(!access_ok(vrfy_dir(type),
> > buf, len))) {
> > 	+		if (type >= 0 &&
> > 	+		    unlikely(!access_ok(vrfy_dir(type), buf,
> > len))) { ret = -EFAULT;
> > 				goto out;
> > 			}
> >
> > and update the callers? In this case all callers just lose the
> > unneeded argument and the code above does
> >
> > 	rw_copy_check_uvector(-1, rvec);
> >
> > Perhaps we can add another NOCHECK (or whatever) define near
> > READ/WRITE.
> >
> > What do you think?
>
> Yes, this is much better. I think for readability we do need a define.
>
> rw_copy_check_uvector(NOCHECK, rvec)
>
> looks a bit odd (why am I passing NOCHECK to a function with the
> word check in it?).

But it also has "copy" in the name. However, I agree that NOCHECK doesn't
look very good, and

> So perhaps maybe IOVEC_ONLY or something like that?

I agree with any naming ;)

Oleg.

