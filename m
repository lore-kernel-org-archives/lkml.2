Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491Ab2AMX1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 18:27:03 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:50979 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab2AMX1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 18:27:00 -0500
Date: Sat, 14 Jan 2012 09:56:33 +1030
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Fix race in process_vm_rw_core
Message-ID: <20120114095633.139119b2@Gantu.yeoh.info>
In-Reply-To: <20120113160442.GA20137@redhat.com>
References: <20120113220028.4ba7cead@Gantu.yeoh.info>
	<20120113160442.GA20137@redhat.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12011313-6102-0000-0000-000000A2E4D2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jan 2012 17:04:42 +0100
Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/13, Christopher Yeoh wrote:
> > ...
> > +struct mm_struct *get_check_task_mm(struct task_struct *task,
> > unsigned int mode) +{
> > +	struct mm_struct *mm;
> > +	int err;
> > +
> > +	err =
> > mutex_lock_killable(&task->signal->cred_guard_mutex);
> > +	if (err)
> > +		return ERR_PTR(err);
> > +
> > +	task_lock(task);
> > +	if (__ptrace_may_access(task, mode)) {
> > +		mm = ERR_PTR(-EACCES);
> > +		goto out;
> > +	}
> 
> Probably you should check "mm != current->mm" before
> __ptrace_may_access(), otherwise this changes the rules for,
> say, /proc/pid/maps.

__ptrace_may_access has a check for task == current already - 
Is that sufficient?

	/* Don't let security modules deny introspection */
	if (task == current)
		return 0;

> > @@ -298,23 +298,15 @@ static ssize_t process_vm_rw_core(pid_t pid,
> > const struct iovec *lvec, goto free_proc_pages;
> >  	}
> >
> > -	task_lock(task);
> > -	if (__ptrace_may_access(task, PTRACE_MODE_ATTACH)) {
> > -		task_unlock(task);
> > -		rc = -EPERM;
> > -		goto put_task_struct;
> > -	}
> > -	mm = task->mm;
> > -
> > -	if (!mm || (task->flags & PF_KTHREAD)) {
> > -		task_unlock(task);
> > -		rc = -EINVAL;
> > +	mm = get_check_task_mm(task, PTRACE_MODE_ATTACH);
> > +	if (!mm || IS_ERR(mm)) {
> > +		if (!mm)
> > +			rc = -EINVAL;
> > +		else
> > +			rc = -EPERM;
> 
> Cosmetic nit. I won't insist, but why -EPERM is better than -EACCES
> returned by get_check_task_mm()? IOW, why not rc = PTR_ERR() ?

Maybe I should just convert EACCES to EPERM for process_vm_rw_core. I
left get_check_task_mm with EACCESS to preserve existing behaviour
for mm_for_maps.

SUSv3 defines EACCES and EPERM as 

[EACCES]
Permission denied. An attempt was made to access a file in a way
forbidden by its file access permissions.

[EPERM]
Operation not permitted. An attempt was made to perform an operation
limited to processes with appropriate privileges or to the owner of a
file or other resource.

So EPERM is more appropriate for process_vm_readv/writev

Chris
-- 
cyeoh@au.ibm.com

