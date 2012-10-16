Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab2JPWf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 18:35:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52160 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab2JPWf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 18:35:26 -0400
Date: Tue, 16 Oct 2012 23:35:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: linus-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>, Jonas Bonn <jonas@southpole.se>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Richard Kuo <rkuo@codeaurora.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Lennox Wu <lennox.wu@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Mundt <lethal@linux-sh.org>, Chris Zankel <chris@zankel.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: new execve/kernel_thread design
Message-ID: <20121016223508.GR2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[apologies for enormous Cc; I've talked to some of you in private mail
and after being politely asked to explain WTF was all that thing for
and how was it supposed to work, well...]

	Below is an attempt to describe how kernel threads work now.  I'm
going to put a cleaned up variant into Documentation/something, so any
questions, suggestions of improvements, etc. are very welcome.

	1.  Basic rules for process lifetime.
Except for the initial process (init_task, eventual idle thread on the boot
CPU) all processes are created by do_fork().  There are three classes of
those: kernel threads, userland processes and idle threads to be.  There are
few low-level operations involved:
	* a kernel thread can spawn a new kernel thread; the primitive
doing that is kernel_thread().
	* a userland process can spawn a new userland process; that's
done by sys_fork()/sys_vfork()/sys_clone()/sys_clone2().
	* a kernel thread can become a userland process.  The primitive
is kernel_execve().
	* a kernel thread can spawn a future idle thread; that's done
by fork_idle().  Result is *not* scheduled until the secondary CPU gets
initialized and its state is heavily overwritten in process.
Under no circumstances a userland process can become a kernel thread or
spawn one.  And kernel threads never do fork(2) et.al.

Note that kernel_thread() and kernel_execve() are really very low-level.
In particular, any process, be it a userland one or a kernel thread, can
ask a dedicated kernel thread (kthreadd) to spawn a kernel thread and
have a given function executed in it.  Or to stop a thread that had been
spawned that way.  Or ask to spawn it tied to given CPU, etc.  The public
interfaces are in linux/kthread.h and the code implementing them is in
kernel/kthread.c; kernel_thread() is what it uses internally.  Another
group of related public APIs deals with spawning a userland process from
kernel - call_usermodehelper() and friends in linux/kmod.h and kernel/kmod.c.
These two groups cover everything kernel-thread-related we care about in
the kernel and I'm not going to deal with them here.  What I'm going to
describe is the primitives used to implement those mechanisms.

Historically the situation used to be different - kernel_thread() used to
be a fairly widely used public API until 2006 or so.  Some out-of-tree
code might still be using it; the proper fix is to switch to use of
kthread_run() and be done with that.  kthread_run() has calling conventions
and rules for callback similar to what kernel_thread() used to have, so
conversion tends to be trivial.

The rules for kernel_thread() callbacks (all 6 of them ;-) have changed,
though.  What we currently have is
	kernel_thread(fn, arg)
where arg is void * and fn is an int-returning function with void * as
argument.  New kernel thread is created and fn(arg) is called in it.
It should either never return (run forever, as kthreadd or call something
that would terminate the thread - do_exit() or, in one case, panic())
or return 0.  That is done after kernel_execve() has returned 0 and
then the thread will proceed into userland context created by that execve.
Note that some architectures still have kernel_execve() itself switch
to userland upon success; that's fine - this is just another case of
callback never returning to caller.  In other words, this switchover
to new model isn't a flagday affair - all callbacks are already in the
form that works both for converted and unconverted architectures.

	2. How should kernel_thread() and kernel_execve() work for
converted architecture?

Recall how the fork() works.  We have the syscall call do_fork(), passing
it the pointer to struct pt_regs created on syscall entry and holding the
userland state of caller.  do_fork() has new task_struct and new kernel
stack allocated; then it calls copy_thread(), which sets the arch-dependent
things for new process.  Then it makes the new task_struct visible to
scheduler and once it's picked for execution, it'll be woken up and proceed
to return to userland, restoring the userland state copied from the parent.
The work of copy_thread() is to arrange the things up for that.

It copies pt_regs to wherever the child would expect to find them on return
from syscall (usually on child's kernel stack) and sets things up so that
when the scheduler finally does switch_to() into the newborn, it will be
woken up in the code that will drive it to userland.  Normally switch_to()
wakes the next process up in the place where it has given the CPU last time,
i.e. in the same switch_to().  We could, in principle, set the things up
for newborn so that they would look that way.  No architecture goes to
such pains, though - no point faking a fairly deep call chain, especially
since changes in scheduler might require modifying all such fakers.  What's
done instead is a much shorter call chain - we act as if we had given CPU
up in the very beginning of ret_from_fork(), called from the syscall entry
glue.  Since we won't be going through the parts of schedule() done after
switch_to(), ret_from_fork() starts with calling schedule_tail() to mop
up.  Then it's off to the normal return from syscall.

Old implementation of kernel_thread() had been rather convoluted.  In the
best case, it filled struct pt_regs according to its arguments and passed
them to do_fork().  The goal was to fool the code doing return from
syscall into *not* leaving the kernel mode, so that newborn would have
(after emptying its kernel stack) end up in a helper function with the
right values in registers.  Running in kernel mode.  The helper took
fn and arg, and called the former passing it the latter.  Then it called
do_exit(), assuming it got that far.  Contortions came from the "fool
the return from syscall into leaving us in kernel mode" part.

New implementation is much simpler.  Generic kernel_thread() still does
do_fork(), but instead of filling pt_regs it passes fn and arg in a couple
of arguments that are blindly passed to copy_thread() and passes NULL as
pt_regs pointer.  In that case copy_thread() should still arrange the things
up for switch_to(), but instead of ret_from_fork() we want to wake up in
a slightly different function.  The name (just as in case of ret_from_fork)
is entirely up to the architecture; I've called it ret_from_kernel_thread
in most of the cases.  What it does is almost identical to what ret_from_fork()
does; it calls schedule_tail() to mop up, then it does fn(arg), using the
information left to it by copy_thread(), then it's off to return from syscall.
Note the difference between that and the old one: instead of
	* schedule_tail() finishes the things for scheduler
	* return to userland, fooled into leaving us in kernel mode; registers
are set from what we'd left in pt_regs.
	* we are in helper() (and still in kernel mode, with empty kernel
stack), which calls fn(arg)
	* fn(arg) either never returns or does successful kernel_execve(),
which does magic to switch to user mode and jump into the image we got from
the binary loaded by kernel_execve()
we have
	* schedule_tail() finishes the things for scheduler
	* fn(arg) is called
	* fn(arg) either never returns or does successful kernel_execve(),
which doesn't have to do any magic - it has pt_regs on kernel stack in
the right position, so filling them up as usual and returning 0 to caller
is just fine
	* we proceed to return to userland.  Nobody needs to be fooled,
everything happens as on normal return from execve(2) - registers are
set as needed by the contents of pt_regs, as filled by do_execve() and
we are off to user mode at the entry point of new binary.

The new variant is obviously nowhere near as hairy.  Moreover, kernel_execve()
can be completely generic as well.  Even better, we don't have to cope with
clone(2) or execve(2) done with non-empty kernel stack (which was a fairly
common way to do aforementioned black magic in kernel_execve()), so sys_execve()
doesn't need anything convoluted to find the pt_regs to pass to do_execve().
In other words, on converted platforms we can switch sys_execve() to
completely generic version as well.

	3.  Gory details.
As I mentioned above, there's a couple of do_fork() arguments that are passed
to copy_thread() as-is, without even looking at them.  Those we use to pass
fn and arg.  It's the second and the third argument resp.; for userland
clone2(2) we'd be passing userland stack pointer and stack size in them.
Only ia64 has clone2() wired, so usually copy_thread() instance names them
'usp' and 'unused' resp. - fork()/vfork()/clone() pass userland stack pointer
to do_fork(), but pass 0 as the 3rd argument.  In any case, for copy_thread()
it's something like
	if (unlikely(!regs)) {
		set the things up, expecting (unsigned long)fn in argument 2
and (unsigned long)arg in argument 3
	} else {
		copy *regs to child, etc.
	}
How to set the things up depends mostly on the way switch_to() is implemented.
In any case, we need to clean the child's pt_regs - it wouldn't do to leak
random kernel data in to userland registers if the child eventually becomes
a userland process.  If switch_to() restores callee-saved registers of the
process it switches to before jumping to the place where that process should
be woken up (i.e. if the processes appear to sleep at the very end of
switch_to() and not in the middle), it's probably the best to pass fn and
arg in a pair of callee-saved registers; then ret_from_kernel_thread() will
find them already loaded into those registers by switch_to().  If switch_to()
is something like
	save callee-saved registers of last process
	save stack pointer
	save l as wakep location
	restore stack pointer of the next process
	jump to wakeup location of the next process
l:	restore callee-saved registers of the next process
(i.e. the wakeup location is in the middle of switch_to), it's probably best
to save fn and arg in child's pt_regs and read them explicitly in
ret_from_kernel_thread(), since switch_to() won't get to restoring callee-saved
registers when it switches to newborn.  Stack pointer is almost certainly
switched before the jump; if it isn't, we are going to notice that as soon
as you look at ret_from_fork() - it would be in the same situation and it
would have to set the stack pointer itself, so we can just duplicate that.

In any case, ret_from_fork() and ret_from_kernel_thread() will be very
similar.  So much that on a predicated architecture it might make sense
to merge them and just make the call of payload predicated on "is it
a kernel thread" or something equivalent.  I'd done that for arm (and
fucked up the call setup in case of thumb-mode kernel, which rmk had fun
to debug) and ia64.  Probably the same could be done for parisc as well.

One note about clearing the child's pt_regs: we won't be using it to
fool the return from syscall into anything, so most of the convolutions
go away.  It's probably a good idea to set it so that user_mode(child_regs)
would be false - more robust that way.  The only case when they end up
anywhere near return from syscall codepath is if we'd done successful
do_execve(), so we can count on at least start_thread() having been done.
Usually that's enough; in one case (ppc64) I ended up with a lovely
detection job finding out why it wasn't.  Turned out that there was a
field (childregs->softe) that was set to 1 by kernel_execve() black
magic; return from syscall logics relied on it being non-zero.  Something
similar might easily be true elsewhere; that's a potential pitfall that
might be useful to keep in mind debugging that stuff.

	4. What is done?
I've done the conversions for almost all architectures, but quite a few
are completely untested.

I'm fairly sure about alpha, x86 and um.  Tested and I understand the
architecture well enough.  arm, mips and c6x had been tested by architecture
maintainers.  This stuff also works.  alpha, arm, x86 and um are fully
converted in mainline by now.

Next group: m68k, ppc, s390, arm64, parisc.  I'm reasonably sure those
are OK, but I'd like the maintainers to take a look.

sparc: Dave said he'll look it through.  I'm still in one piece and not
charred, so either it's OK or he didn't have time to read it yet.  Works
here, anyway.

Next comes the pile of embedded architectures where the best that can be said
about what I have is that it might serve as a starting point for producing
something that works.  I've no hardware, no emulated setups and my
knowledge of architecture comes from architecture manuals and nothing
else.  Those are
	avr32
	blackfin
	cris
	frv
	h8300
	m32r
	microblaze
	mn10300
	score
	sh
	unicore32
Maintainers are Cc'd.  My (very, _very_ tentative) patchsets are in
git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal arch-$ARCH

Nearly in the same state: ia64.  The only difference is that I've tested
it under ski(1) and it seems to work.  Accuracy of ski(1) for the purposes
of finding bugs in asm glue is not inspiring, though.

Not even a tentative patchset: hexagon, openrisc, tile, xtensa.

I would very much appreciate ACKs/testing/fixes/outright replacements/etc.
for this stuff.  Right now all infrastructure is in the mainline and
per-architecture bits are entirely independent from each other.  As soon
as maintainer in question is OK with what's in such per-architecture branch,
I'll be quite happy to put it into never-rebased mode, so that it would be
safe to pull.  There are some fun things that'll become possible once
all architectures are converted, but let's handle that stuff first, OK?
