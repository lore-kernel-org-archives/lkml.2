Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424Ab2AMQKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 11:10:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab2AMQKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 11:10:39 -0500
Date: Fri, 13 Jan 2012 17:04:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Fix race in process_vm_rw_core
Message-ID: <20120113160442.GA20137@redhat.com>
References: <20120113220028.4ba7cead@Gantu.yeoh.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120113220028.4ba7cead@Gantu.yeoh.info>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13, Christopher Yeoh wrote:
>
> Hi Linus,
>
> Below is a patch which fixes the race in process_vm_core found by
> Oleg (http://article.gmane.org/gmane.linux.kernel/1235667/).
> It consolidates some code with mm_for_maps since what they do is almost
> identical.
>
> Oleg - I've kept the breakout of ptrace_may_attach and get_task_mm to
> preserve only having to take the task lock once. I see some performance
> difference with a microbenchmark but haven't had a chance to test with
> some HPC benchmarks yet so for the moment I'd like to leave it in.

I still think we should avoid the copy-and-paste code, we can do this
without the extra unlock+lock if it hurts.

However,

> At
> this stage I think its more important to get the race fixed and I'm at
> Linux.conf.au all next week. I'll send a patch out for the
> rw_copy_check_uvector cleanup after I get back from LCA.

OK, lets fix the bug first.

>  struct mm_struct *mm_for_maps(struct task_struct *task)
>  {
> -	struct mm_struct *mm;
> -	int err;
> -
> -	err =  mutex_lock_killable(&task->signal->cred_guard_mutex);
> -	if (err)
> -		return ERR_PTR(err);
> -
> -	mm = get_task_mm(task);
> -	if (mm && mm != current->mm &&
> -			!ptrace_may_access(task, PTRACE_MODE_READ)) {
> -		mmput(mm);
> -		mm = ERR_PTR(-EACCES);
> -	}
> -	mutex_unlock(&task->signal->cred_guard_mutex);
> -
> -	return mm;
> +	return get_check_task_mm(task, PTRACE_MODE_READ);
>  }
> ...
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
> +		mm = ERR_PTR(-EACCES);
> +		goto out;
> +	}

Probably you should check "mm != current->mm" before __ptrace_may_access(),
otherwise this changes the rules for, say, /proc/pid/maps.

> @@ -298,23 +298,15 @@ static ssize_t process_vm_rw_core(pid_t pid, const struct iovec *lvec,
>  		goto free_proc_pages;
>  	}
>
> -	task_lock(task);
> -	if (__ptrace_may_access(task, PTRACE_MODE_ATTACH)) {
> -		task_unlock(task);
> -		rc = -EPERM;
> -		goto put_task_struct;
> -	}
> -	mm = task->mm;
> -
> -	if (!mm || (task->flags & PF_KTHREAD)) {
> -		task_unlock(task);
> -		rc = -EINVAL;
> +	mm = get_check_task_mm(task, PTRACE_MODE_ATTACH);
> +	if (!mm || IS_ERR(mm)) {
> +		if (!mm)
> +			rc = -EINVAL;
> +		else
> +			rc = -EPERM;

Cosmetic nit. I won't insist, but why -EPERM is better than -EACCES
returned by get_check_task_mm()? IOW, why not rc = PTR_ERR() ?

Note that get_check_task_mm() can return -EINTR, in this case -EPERM
looks confusing even if this doesn't really materr (the killed task
can't return to usermode).

Oleg.

