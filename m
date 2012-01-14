Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab2ANSE2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 13:04:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031Ab2ANSE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 13:04:27 -0500
Date: Sat, 14 Jan 2012 18:58:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Fix race in process_vm_rw_core
Message-ID: <20120114175829.GA32638@redhat.com>
References: <20120113220028.4ba7cead@Gantu.yeoh.info> <20120113160442.GA20137@redhat.com> <20120114095633.139119b2@Gantu.yeoh.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120114095633.139119b2@Gantu.yeoh.info>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14, Christopher Yeoh wrote:
>
> On Fri, 13 Jan 2012 17:04:42 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
> > On 01/13, Christopher Yeoh wrote:
> > > ...
> > > +struct mm_struct *get_check_task_mm(struct task_struct *task,
> > > unsigned int mode) +{
> > > +	struct mm_struct *mm;
> > > +	int err;
> > > +
> > > +	err =
> > > mutex_lock_killable(&task->signal->cred_guard_mutex);
> > > +	if (err)
> > > +		return ERR_PTR(err);
> > > +
> > > +	task_lock(task);
> > > +	if (__ptrace_may_access(task, mode)) {
> > > +		mm = ERR_PTR(-EACCES);
> > > +		goto out;
> > > +	}
> >
> > Probably you should check "mm != current->mm" before
> > __ptrace_may_access(), otherwise this changes the rules for,
> > say, /proc/pid/maps.
>
> __ptrace_may_access has a check for task == current already -
> Is that sufficient?
>
> 	/* Don't let security modules deny introspection */
> 	if (task == current)
> 		return 0;

I don't think this is sufficient in the multithreaded or CLONE_VM case,
task_cred/etc is per-thread.

It is not that I think that this "current->mm != mm" check is important,
in fact personally I think it shouldn't exist.

But we shouldn't add the subtle and not documented behavioural change, and
obviously process_vm_rw() has no security problems if mm == current->mm.

> > > +	mm = get_check_task_mm(task, PTRACE_MODE_ATTACH);
> > > +	if (!mm || IS_ERR(mm)) {
> > > +		if (!mm)
> > > +			rc = -EINVAL;
> > > +		else
> > > +			rc = -EPERM;
> >
> > Cosmetic nit. I won't insist, but why -EPERM is better than -EACCES
> > returned by get_check_task_mm()? IOW, why not rc = PTR_ERR() ?
>
> Maybe I should just convert EACCES to EPERM for process_vm_rw_core. I
> left get_check_task_mm with EACCESS to preserve existing behaviour
> for mm_for_maps.
>
> SUSv3 defines EACCES and EPERM as
>
> [EACCES]
> Permission denied. An attempt was made to access a file in a way
> forbidden by its file access permissions.
>
> [EPERM]
> Operation not permitted. An attempt was made to perform an operation
> limited to processes with appropriate privileges or to the owner of a
> file or other resource.
>
> So EPERM is more appropriate for process_vm_readv/writev

Well, imho EACCES would be fine too and my point was s/EINTR/EPERM/
looks a bit confusing.

But OK, this is subjective and minor, I won't argue.

Oleg.

