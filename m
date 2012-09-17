Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab2IQD05 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 23:26:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56636 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab2IQD0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 23:26:54 -0400
Date: Mon, 17 Sep 2012 04:26:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] status of execve() work - per-architecture patches
 solicited
Message-ID: <20120917032651.GU13973@ZenIV.linux.org.uk>
References: <20120907182004.GE13973@ZenIV.linux.org.uk>
 <1347315603-30027-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347315603-30027-1-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 06:20:01PM -0400, Mark Salter wrote:
> C6X works fine with these patches to switch over to generic code.
> 
> 
> Mark Salter (2):
>   c6x: implement ret_from_kernel_execve() and switch to generic
>     kernel_execve()
>   c6x: switch to generic sys_execve()
> 
>  arch/c6x/include/asm/syscalls.h |    5 ---
>  arch/c6x/include/asm/unistd.h   |    3 ++
>  arch/c6x/kernel/entry.S         |   54 +++++++++++++++++---------------------
>  arch/c6x/kernel/process.c       |   22 ----------------
>  4 files changed, 27 insertions(+), 57 deletions(-)

Applied.  There's an alternative variant of that branch; see
#experimental-kernel_thread in the same tree.  I have *not* attempted
to port those patches over there - I don't have anything to test on
and architecture is too unfamiliar for me to even attempt it blindly.

The main differences between those branches are:
	* ret_from_fork is usually split in two - ret_from_fork
is used for normal processes and ret_from_kernel_thread is its
analog for kernel threads; copy_thread() chooses one to use based
on user_mode(regs).
	* ret_from_kernel_thread does *not* go through the normal
return-from-syscall codepath; instead of doing that it simply
does an equivalent of kernel_thread_helper() itself - i.e. calls
the function we'd passed to kernel_thread(), followed by sys_exit().
	* ret_from_kernel_execve does *not* bother with memmove();
it's done by generic kernel_execve() itself.  Note that the first
two changes guarantee that kernel threads will have pt_regs at the
bottom of their stack, so we won't have any overlaps - not between
the source and destination of copying pt_regs and not between the
stack frame and that destination.  I.e. that copying can safely
be done by generic C implementation of kernel_execve().

I've ported (and tested) execve2 stuff to that model; it's done for
alpha, arm, m68k, s390, powerpc, x86 and um.  I think it's a better
approach:
	* ret_from_kernel_execve() is simpler that way - one argument,
no memmove() call to implement in there.
	* we get to kill the last remnants of "syscall instruction
from the kernel mode" crap (c6x kernel_thread() is free from that
already, but for many architectures it's not so) 
	* syscall return codepath is only taken for return to userland
now; succeeding kernel_thread() is not sharing it.  Seeing that a bunch
of things on that path should be avoided when returning to kernel mode,
that allows for nice optimizations and simpler logics in the asm glue.
	* it removes more code.  BTW, right now the contents of
experimental-kernel_thread + for-next sans execve2 counterparts is
probably getting close to Linus' "it removes 1KLoC, piss on all merge window
rules and pull it now" threshold ;-)

The price is that kernel threads are in the same boat as userland processes
now wrt kernel stack consumption - they get pt_regs in the bottom of kernel
stack, same as for normal syscall path.  That makes for _much_ simpler life,
but if there's a kernel thread with really borderline stack footprint, that
might push it over the edge.  Note, however, that syscalls are where the
worst stack footprints tend to happen and for those we can't get rid of
pt_regs on stack, no matter what we do.

Just as with #execve2 it's not a flagday conversion; however, switching
from one to another probably would be messy, so we'd better decide which
one we'll be doing before the merge window.  Comments?
