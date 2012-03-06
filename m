Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030253Ab2CFEKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 23:10:33 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60906 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895Ab2CFEKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 23:10:32 -0500
Date: Tue, 6 Mar 2012 04:10:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, airlied@linux.ie, carsteno@de.ibm.com,
        steiner@sgi.com
Subject: Re: [patches] VM-related fixes
Message-ID: <20120306041015.GP23916@ZenIV.linux.org.uk>
References: <20120305063707.GH23916@ZenIV.linux.org.uk>
 <CAMP5XgeWQpMP2Q_29aybHwfMJ1_k5GkGozqocSVVYDoRTpKD2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP5XgeWQpMP2Q_29aybHwfMJ1_k5GkGozqocSVVYDoRTpKD2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 07:38:21PM -0800, Arve Hj?nnev?g wrote:
> > [unsolved] binder is insane, even more than usual for drivers/staging.
> > It stores a reference to mm at open() time,
> 
> It stores a reference to the task struct, not the mm.

Equivalent, for our purposes.  OK, almost - strictly speaking that avoids
some extra nasty scenarios with open/exec/mmap, but the real PITA comes from
much simpler open/fork/mmap in child anyway...

> > then it stores a reference to
> > vma at mmap() time, then it cheerfully works with that ->vma assuming that
> > ->mmap_sem on stored reference to ->mm would suffice. ?Guess what happens
> > if somebody opens it and then forks and does mmap in child?
> 
> mmap succeeds, but binder_update_page_range will fail when trying to
> create a transaction? (assuming you are talking about the current
> version of the driver)
 
Sorry, no.
                down_write(&mm->mmap_sem);
                vma = proc->vma;
                if (vma && mm != vma->vm_mm) {
does *not* do what you seem to describe; there's nothing to protect you
from proc->vma getting freed under you right between load from proc->vma
and check of vma->mm.  ->mmap_sem on the right mm would prevent that,
but this one doesn't guarantee anything.  Get preempted after the second
line quoted above and by the time you get the timeslice back, you might
have had munmap() done by another thread, with vma freed, its memory
recycled, etc.

> > ?Moreover, if
> > we fork() and have child exit(), we get ->close() called on each VMA we'd
> > copied into child.
> 
> The driver sets VM_DONTCOPY which should avoid this.

Umm...  Point taken - missed that.

> > ?Since they have stored reference to vma invalidated by
> > ->close(), that has unpleasant side effects, to put it mildly.
> 
> The side effect of ->close() should be the same as when the process
> that opened the driver exits. In other words, the process that
> misbehaved is considered dying. It does not however send death
> notifications until the driver is closed, so other processes do not
> notice until they try to talk to it.
> 
> > ?And yes,
> > I realize that android userland probably doesn't do anything of that kind;
> > fat lot of good it does us...
> >
> 
> What usage case do you have in mind? The binder driver uses the file
> pointer as the binder process identifier, so you need to open and mmap
> the driver in every process that want to use the driver. While it is
> not common to fork a process in android, the driver should work as
> expected if you do (assuming each process opens and mmaps the driver
> on its own and don't share the file).

Except that we can't make that assumption...
