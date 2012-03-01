Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab2CAS1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 13:27:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964Ab2CAS07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 13:26:59 -0500
Date: Thu, 1 Mar 2012 19:06:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file
Message-ID: <20120301180616.GA7652@redhat.com>
References: <20120229151634.GE4796@moon> <20120229192400.GA13194@redhat.com> <20120229200103.GJ11326@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120229200103.GJ11326@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01, Cyrill Gorcunov wrote:
>
> On Wed, Feb 29, 2012 at 08:24:00PM +0100, Oleg Nesterov wrote:
> > On 02/29, Cyrill Gorcunov wrote:
> > >
> > > +static int prctl_set_mm_exe_file(struct mm_struct *mm,
> > > +				 const void __user *path,
> > > +				 size_t size)
> > > +{
> > > +	struct file *new_exe_file;
> > > +	char *pathbuf;
> > > +	int ret = 0;
> > > +
> > > +	if (size >= PATH_MAX)
> > > +		return -EINVAL;
> > > +
> > > +	/*
> > > +	 * We allow to change only those exe's which
> > > +	 * are not mapped several times. This one
> > > +	 * is early test while mmap_sem is taken.
> > > +	 */
> > > +	if (mm->num_exe_file_vmas > 1)
> > > +		return -EBUSY;
> >
> > I don't really understand this check, but it is racy. Another thread
> > can change ->num_exe_file_vmas right after the check.
> >
> > > +       up_read(&mm->mmap_sem);
> >
> > up? I do not see down...
>
> down is taken in calling routine (as pointed in comment on
> prctl_set_mm_exe_file),

Ah, indeed, stupid me. Somehow I thought that the caller is sys_prctl().
So it is called by prctl_set_mm() which holds ->mmap_sem for reading.

> thus I suppose I miss something since
> the calling functions which increment/decrement num_exe_file_vmas
> (such as mremap) do down_write(mmap_sem) first.

Yes, so ->num_exe_file_vmas is stable under mmap_sem. But it can
be changed right after up_read(), so I don't underastand this check
anyway.

OK, you recheck this counter later, under mmap_sem.

> > I simply can't understand why set_mm_exe_file() is safe. What
> > if we race with another thread doing set_mm_exe_file() too?
> > Or it can race with added_exe_file_vma/removed_exe_file_vma.
>
> really, Oleg, I don't see race here since this routine is
> caller under down_read and I've been releasing mmap_sem for
> short time then reacquiring it, and recheck for number of
> num_exe_file_vmas. so I presume I miss something obvious
> here.

OK, now that I understand the locking, we can't race with
added_exe_file_vma/removed_exe_file_vma. But I still think we
can race with set_mm_exe_file().

And yes, I think you missed something obvious ;) Suppose that
2 threads call prctl_set_mm(PR_SET_MM_EXE_FILE) at the same
time. Both threads can take ->mmap_sem for reading and do
set_mm_exe_file() at the same time.

> > And. set_mm_exe_file() sets ->num_exe_file_vmas = 0, this is
> > simply wrong? It should match the number of VM_EXECUTABLE
> > vmas.
> >
>
> yes, it's a nit which sould be fixed. thanks!

OK, but then you do not need to check ->num_exe_file_vmas at all?

Except, of course, I think we should fail if this counter is zero.

The changelog says:

	Note, if mm_struct::exe_file already mapped more than once
	we refuse to change anything (which prevents kernel from
	potential problems).

why? which problems?

> > In short, I do not understand the patch at all. It seems, you
> > only need to replace mm->exe_file under down_write(mmap_sem)
> > and nothing else.
>
> I can't just replace it, I wanted to check it the new symlink
> will indeed point to executable

I meant I see no reason to play with num_exe_file_vmas, you only
need to replace ->exe_file.

As for additional checks, I have no opinion. I don't know if it
really makes sense to verify it is executable.

But, hmm. There is another problem with your patch. open_exec()
does deny_write_access(), and I do not see who does the necessary
allow_write_access().

> and I actually wonted to replace
> only freshly created executables which didn't have any
> remaps on executable VMA

I don't really understand what do you mean.

In any case, PR_SET_MM_EXE_FILE is cheating. The new file doesn't
match ->vm_file of VM_EXECUTABLE vmas. And it can be writable.

But why do we require num_exe_file_vmas == 1?

Oleg.

