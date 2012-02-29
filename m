Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab2B2UBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:01:10 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58588 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab2B2UBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:01:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gorcunov@gmail.com designates 10.204.152.88 as permitted sender) smtp.mail=gorcunov@gmail.com; dkim=pass header.i=gorcunov@gmail.com
Date: Thu, 1 Mar 2012 00:01:03 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file
Message-ID: <20120229200103.GJ11326@moon>
References: <20120229151634.GE4796@moon>
 <20120229192400.GA13194@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120229192400.GA13194@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 08:24:00PM +0100, Oleg Nesterov wrote:
> On 02/29, Cyrill Gorcunov wrote:
> >
> > +static int prctl_set_mm_exe_file(struct mm_struct *mm,
> > +				 const void __user *path,
> > +				 size_t size)
> > +{
> > +	struct file *new_exe_file;
> > +	char *pathbuf;
> > +	int ret = 0;
> > +
> > +	if (size >= PATH_MAX)
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * We allow to change only those exe's which
> > +	 * are not mapped several times. This one
> > +	 * is early test while mmap_sem is taken.
> > +	 */
> > +	if (mm->num_exe_file_vmas > 1)
> > +		return -EBUSY;
> 
> I don't really understand this check, but it is racy. Another thread
> can change ->num_exe_file_vmas right after the check.
> 
> > +       up_read(&mm->mmap_sem);
> 
> up? I do not see down...

down is taken in calling routine (as pointed in comment on
prctl_set_mm_exe_file), thus I suppose I miss something since
the calling functions which increment/decrement num_exe_file_vmas
(such as mremap) do down_write(mmap_sem) first.

> 
> > +	new_exe_file = open_exec(pathbuf);
> > +	kfree(pathbuf);
> > +
> > +	down_read(&mm->mmap_sem);
> 
> probably you meant "up" here. OK, I am ignoring ->mmap_sem, I can't
> understand what did you really mean ;)
> 

nop, down instead ;)

> > +	if (IS_ERR(new_exe_file))
> > +		return PTR_ERR(new_exe_file);
> > +
> > +	/*
> > +	 * We allow to change only those exe's which
> > +	 * are not mapped several times.
> > +	 */
> > +	if (mm->num_exe_file_vmas < 2) {
> > +		set_mm_exe_file(mm, new_exe_file);
> > +		ret = 0;
> > +	} else
> > +		ret = -EBUSY;
> > +
> > +	return ret;
> 
> Both success/EBUSY leak new_exe_file. And I agree with Pavel,

yeah, will fix, thanks!

> prctl_set_mm_exe_file() should take fd, not filename.
> 

yes, i'll switch to this idea

> I simply can't understand why set_mm_exe_file() is safe. What
> if we race with another thread doing set_mm_exe_file() too?
> Or it can race with added_exe_file_vma/removed_exe_file_vma.

really, Oleg, I don't see race here since this routine is
caller under down_read and I've been releasing mmap_sem for
short time then reacquiring it, and recheck for number of
num_exe_file_vmas. so I presume I miss something obvious
here.

> 
> And. set_mm_exe_file() sets ->num_exe_file_vmas = 0, this is
> simply wrong? It should match the number of VM_EXECUTABLE
> vmas.
> 

yes, it's a nit which sould be fixed. thanks!

> In short, I do not understand the patch at all. It seems, you
> only need to replace mm->exe_file under down_write(mmap_sem)
> and nothing else.

I can't just replace it, I wanted to check it the new symlink
will indeed point to executable (such ceheck btw is done
in open_exec() helper) and I actually wonted to replace
only freshly created executables which didn't have any
remaps on executable VMA (still I might be wrong
here and it's indeed safe just to replace old exe_file).

That's why I posted it as RFC and really appreciate
feedback (so, thanks a lot, Oleg!).

	Cyrill
