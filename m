Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab2IWAqp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 20:46:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55849 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab2IWAqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 20:46:43 -0400
Date: Sun, 23 Sep 2012 01:46:36 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Greg Ungerer <gregungerer@westnet.com.au>
Cc: Mark Salter <msalter@redhat.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [RFC] status of execve() work - per-architecture patches
 solicited
Message-ID: <20120923004636.GL13973@ZenIV.linux.org.uk>
References: <20120917032651.GU13973@ZenIV.linux.org.uk>
 <1348244799-16013-1-git-send-email-msalter@redhat.com>
 <20120921183934.GK13973@ZenIV.linux.org.uk>
 <505D9DFB.8080002@westnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505D9DFB.8080002@westnet.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2012 at 09:16:11PM +1000, Greg Ungerer wrote:
> I sent the patch to the m68k-linux list. Its been acked by Geert.
> 
>  http://marc.info/?l=linux-m68k&m=134742688015639&w=2
> 
> I was going to push it through the m68knommu git tree, but I don't mind
> if you would rather take it with your changes.

Applied.  Other changes since the last update:
	* ppc breakage debugged and fixed
	* kernel_thread() unified on all converted architectures.
An architecture can add select GENERIC_KERNEL_THREAD to its Kconfig
if it's ready to handle that in its copy_thread() - regs will be
NULL, usp - (unsigned long)fn, stck_size - (unsigned long)arg.  It
should set things up for ret_from_kernel_thread, so that the sucker
would call given function on given argument.  See what e.g. m68k
does in #experimental-kernel_thread() in its copy_thread() and
ret_from_kernel_thread; it's a fairly typical situation if you have
enough callee-saved registers to play with.  If not, put these
values somewhere in childregs and pick them in ret_from_kernel_thread -
see i386 for example of that.

Eventually I hope to merge all kernel_thread() instances; then
CONFIG_GENERIC_KERNEL_THREAD will be gone.  Note, BTW, that having
killed all in-kernel syscalls-via-trap on given architecture we
get a chance to optimize the syscall glue; for instance, on ppc64
we could just go ahead and set stack pointer from %r13->kstack
unconditionally, rather than playing with "if we are coming from
the kernel mode, push stack pointer down by INT_FRAME_SIZE, otherwise
pick it from per-CPU data structure pointed to by r13" as we do now.
And that's just the most obvious bit in the very beginning of their
system_call_common; there's more.  I haven't touched that stuff -
this kind of work belongs in architecture trees, not in this series.

FWIW, if we do that conversion for all kernel_thread(), we get another
nice thing pretty much for free - do_fork() won't need pt_regs passed
to it anymore.  Note that after that we have two possible values passed
there - NULL (for kernel_thread()) and current_pt_regs() (from sys_fork()
and friends).  I.e. it's 1 bit of information, *and* we already have
that bit - it's current->flags & PF_KTHREAD (it's actually a bit more
convenient to check its copy in p->flags).  Only kernel threads call
kernel_thread(); only userland processes call sys_fork/sys_clone/sys_vfork().
IOW, all architectures are converted to generic kernel_thread() implementation,
we can
	* stop passing pt_regs to do_fork()
	* stop passing pt_regs to copy_process()
	* stop passing pt_regs to copy_thread() - it can bloody well be
calculated there.  And it's not used until that point.
