Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab2EAFwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 01:52:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41974 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2EAFwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 01:52:30 -0400
Date: Tue, 1 May 2012 06:52:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120501055226.GH6871@ZenIV.linux.org.uk>
References: <20120426231942.GJ6871@ZenIV.linux.org.uk>
 <20120429180535.GZ6871@ZenIV.linux.org.uk>
 <20120501043129.GF6871@ZenIV.linux.org.uk>
 <201205010106.38495.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205010106.38495.vapier@gentoo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 01:06:36AM -0400, Mike Frysinger wrote:
> > blackfin: no loop (== multiple signals handling is fucked); no check either
> >         ret_from_fork doesn't handle signals, etc., userland or not.
> >         kernel_execve doesn't handle signals, etc., success or no success
> >         conclusion: check is probably not needed, multiple pending signals
> > are screwed
> 
> to be honest, i haven't been following this thread as Blackfin wasn't mentioned 
> in the initial summary.  now it seems we have ;).  i tried going back through 
> this TIF_NOTIFY_RESUME thread but haven't quite got a bead on what needs to be 
> done.
> 
> seems like you're only referring to ret_from_fork here and not the normal 
> syscall return path ?  in the Blackfin case, we don't have a fork(), so we only 
> have to handle the supervisor mode case (spawning kthreads), so i don't think 
> we're quite as fucked as you might think :).

*anything* that goes through do_fork() (fork(2), clone(2), vfork(2)) will
hit ret_from_fork.  And kernel_execve() in case of success returns into
userland (on failure it stays in kernel).  So handling signals et.al.
on those would be nice.

In any case, the fucked up part is about handling of multiple pending
signals.

> what is it you're suggesting we add ?  in the past, i found documentation on 
> the arch TIF_*/notify requirements to be pretty much non-existent.  so some 
> parts of the Blackfin paths are what i found from my eyes bleeding x86 asm 

Tell me about that...  I've spent the last couple of weeks sniffing the
asm glue all over arch/* ;-/

> paths, and from single testing some random tests (like strace or gdb).  things 
> seem to run & be debugable, and no one has complained thus far, so we ship it!
> -mike

The main issue with blackfin, AFAICS, is that if you get several signals
pending, you need to build sigframes for all of them.  Especially since
you might have generated one yourself (SIGSEGV on failure to create a userland
stack frame for signal handler).  Leaving that SIGSEGV to be picked at
more or less random moment when you enter the kernel next time (e.g. the
next timer interrupt) is Not Nice(tm)...

So the normal logics looks like this:
loop:
	disable interrupts
	read thread flags
	if nothing had been set, you are done.  Restore registers and return
wherever your pt_regs would have you return.
	if NEED_RESCHED is set
		enable interrupts unless your context switch does that for you
		schedule();
		goto loop;
	at that point you don't need interrupts anymore; enable them
	if SIGPENDING or NOTIFY_RESUME is set
		do_notify_resume();
		goto loop;
	// maybe arch-specific flags handled the same way - before or
	// after SIGPENDING/NOTIFY_RESUME, also jumping back to the
	// beginning of the loop

The trouble is, you *really* don't want to get into that loop when
returning to kernel mode.  You can't process signals in that case,
so SIGPENDING will stay there and you'll loop forever.  One way to
deal with that one is to avoid going there if you are returning to
kernel mode; I think it'll be the easiest variant in case of blackfin.
Another way would be to check that just before we'd call do_notify_resume() -
again, buggering off if we are returning to the kernel.

Another thing you'll need is regs->orig_p0 = -1; in handle_restart() -
with multiple signals being handled you want restarts happening only
with the first one.  In your case the "I don't need to bother
with restarts" check is simple - something like arm has it much more
painfully...

IOW, here's what I'd suggest doing:

* add that regs->orig_p0 = -1; to handle_restart()
* add jump .Lresume_userspace_1 after the call of do_notify_resume()
* instead of RESTORE_CONTEXT/rti in ret_from_fork and kernel_execve()
have them jump to .Lresume_userspace.

and that'll be it.  BTW, 
 do_restart:   
                regs->p0 = regs->orig_p0;
                regs->r0 = regs->orig_r0;
                regs->pc -= 2;
in handle_restart() looks excessive, so you might want to trim it a bit
while you are there ;-)
