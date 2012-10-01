Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab2JAViO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 17:38:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35454 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab2JAViK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 17:38:10 -0400
Date: Mon, 1 Oct 2012 22:38:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [RFC][CFT][CFReview] execve and kernel_thread unification work
Message-ID: <20121001213809.GA31155@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[with apologies for folks Cc'd, resent due to mis-autoexpanded l-k address
on the original posting ;-/  Mea culpa...]

	There's an interesting ongoing project around kernel_thread() and
friends, including execve() variants.  I really need help from architecture
maintainers on that one; I'd been able to handle (and test) quite a few
architectures on my own [alpha, arm, m68k, powerpc, s390, sparc, x86, um]
plus two more untested [frv, mn10300].  c6x patches had been supplied by
Mark Salter; everything else remains to be done.  Right now it's at
minus 1.2KLoC, quite a bit of that removed from asm glue and other black magic.

	What it promises:
* unified kernel_thread() implementation
* unified sys_execve() implementation
* no more struct pt_regs * passing for execve/fork/vfork/clone and stuff
called by those (do_execve(), do_fork() and downstream from those)
* unified kernel_execve() implementation (if we leave that function alive
at all; see below for details)
* much simpler and more uniform logics around kernel thread creation.
* lots and lots of code removed.

	Some notes on kernel_thread() are needed to explain the rest;
first of all, it's really a very low-level interface with few users.
Practically everything is using either kthread_run() and its friends
(linux/kthread.h stuff, for things that really do work as kernel threads)
or call_usermode_helper() (linux/kmod.h stuff, for things that are
intended to set things up and exec, turning into a userland process).
Both are implemented via kernel_thread(), of course, but that's about
all we use kernel_thread() for.  Outside of those mechanisms there are
only 3 users:
	* original thread spawns future init via kernel_thread() before
turning itself into idle thread for boot CPU
	* /linuxrc from initramfs is spawned via kernel_thread(); that's
trivially converted to call_usermodehelper_fns().
	* powerpc has one kernel thread that should've been done via
kthread_run(), but is implemented via raw kernel_thread() instead.
That's all.  Everything else is about kthread.c and kmod.c machinery.

In other words, kernel_thread() should be strictly kernel-internal.
Moreover, *becoming* a kernel thread is inherently racy and while we
have a leftover primitive for that (daemonize()), it's practically
unused.  The only remaining caller is in drivers/staging and it can
easily be eliminated; it's done in kernel thread (kthread.h variety),
so all it does is change of thread name.  I think we ought to kill
daemonize() and be done with that.

kernel_execve() is also very limited in visibility - it's used by kmod.c
machinery and pretty much everything else is using that instead.
The only exceptions right now is exec of userland init and exec of
/linuxrc; the latter actually should be using kmod.c stuff.

In other words, the desired situation is
	* kernel threads spawn kernel threads via kernel_thread(); it
happens in a very limited number of places, everything else uses
kthread.h and kmod.h functions.
	* userland processes spawn only userland processes.  It's done
by sys_fork/sys_vfork/sys_clone/sys_clone2; none of those is ever called
by a kernel thread.  No userland process ever calls kernel_thread().
	* a kernel thread either runs forever or calls do_exit() or
does successful kernel_execve().  In the last case it becomes a userland
process.
	* a userland process cannot become a kernel thread; it can ask
an existing kernel thread to spawn a new one (that's how kthread.h mechanism
works), but that's it.
	* kernel_execve() is limited to kernel/*.c - not even seen in
linux/*.h

We are fairly close to that already.  Now, let's recall how process creation
of any kind works.  Any thing other than an idle thread is created by
do_fork(), called one way or another.  do_fork() gets a new task_struct
and kernel stack allocated and calls copy_thread() to do the arch-dependent
work.  Eventually, do_fork() makes the new process visible to scheduler
and off we go.  New process is set up (by copy_thread()) so that it looks
as if it's just lost CPU in the middle of switch_to().  When scheduler
decides to pick it for execution, switch_to() done in a process losing CPU
resumes the execution of the newborn.  However, it's *not* in the middle
of switch_to() - it doesn't have a call chain on its stack that would
contain schedule(), etc.  Instead of faking all that, we pretend that
all we have in our call chain is ret_from_fork() and we are resuming the
execution in the beginning of ret_from_fork(), which does what schedule
would've done after calling switch_to() (i.e. calls
schedule_tail(previous_task)) and proceeds to normal return from syscall
codepath.  There are variations on that, but they are fairly minor (e.g.
amd64 recognizes that there are only two addresses where execution could
be resumed after switch_to(), one much more frequent than another.  So
instead of storing an address where we'll resume the task and jumping
to such address picked from the new task, it checks a thread flag and
does conditional branch to ret_from_fork, where the flag is immediately
removed.  It's still the same logics, just much nicer on branch predictor
in CPU).

That's fine for fork()/clone()/vfork(); we have saved the register state
on syscall entry (into struct pt_regs on caller's kernel stack), we pass
it to copy_thread() and slap it on child's stack.  When the child gets
born, it'll wake up in ret_from_fork() and proceed to return from syscall.
Which will pick said copy of registers from its stack, restore them as
usual and return to userland.  If we have callee-saved registers we don't
bother to put into pt_regs (C part of the kernel won't have them changed
anyway, so why bother?) we just do a wrapper for sys_fork() that saves
those registers next to pt_regs on stack, so that copy_thread() would pick
them as well and arranged for them set up - either on by switch_to() or
by ret_from_fork.  The only painful part is finding those pt_regs...

For kernel threads it gets more hairy.  Some (thankfully very few now - only
2 such architectures left in my tree) just issue a syscall instruction right
in the kernel mode.  Another variant: set struct pt_regs in a local variable,
fill it so that it would look like one set by e.g. interrupt taken in kernel,
shove the kernel_thread() callback and its argument into a couple of registers,
set the "return address" at a helper function and call do_fork().  We are
still relying on the following convoluted sequence of events:
	* copy_thread() sets the child's kernel stack according to what
we'd set in pt_regs.  Would be nice if it could just do what it does for
normal fork(), but in practice it needs to check whether it's going to be
a kernel thread or not anyway.
	* child gets woken up at the ret_from_fork() entry, does that
schedule_tail() call and goes to the path that would normally lead to
userland.
	* due to the way we'd set pt_regs up, we'll actually do nothing
on that path other than setting all registers according to what's in
pt_regs, *NOT* switching out of the kernel mode and jumping to helper that'll
call the callback we'd passed to kernel_thread().  Taking its address (and
the value of its argument) from the registers we'd just set.  Assuming we
didn't have a bug somewhere.
It's *way* too convoluted.
	Simpler variant: have copy_thread() set things up to resume in
a separate function (ret_from_kernel_thread()) if we are dealing with the
kernel thread.  Which function will call schudule_tail(), then call the
callback, then call do_exit().  Without going through the
return-to-userland-but-not-really contortions.
	Even simpler: if we are spawning a kernel thread (which can be
checked as current->flags & PF_KTHREAD), don't even look at pt_regs we'd
got - it has been filled based on kernel_thread() callback and argument
anyway.  Just pass those in two unsigned long arguments do_fork() blindly
passes to copy_thread() (normally one is used for userland stack pointer
and another is not used at all, other than on itanic sys_clone2()) and have
copy_thread() use them in kthread case.  That variant has an additional
benefit of kernel_thread() being 100% identical on all architectures using it.
	I have that done on architectures listed above; the rest needs
to be done.

	The next thing is kernel_execve().  Some architectures do a syscall
instruction in the kernel approach.  It kinda-sorta works, but it complicates
the things a lot on syscall exit path, as well as for do_execve() and friends.
	Another variant: set empty pt_regs in local variable, pass them to
do_execve() and if it succeeds, do black magic.  Namely, copy them to normal
location, reset stack pointer so that it'll look like return from syscall
and jump to return from syscall.  And black magic it is - *everything* starting
from "copy to normal location" has to be in assembler, since the normal
location might bloody well overlap the current stack frame!  And you'd
better pray that nothing like unwinder sees the poor abused stack in the
middle of that fun.
	Simpler variant: do the aforementioned conversion of kernel_thread()
and set the kernel stack pointer of child the same way whether it's a
kthread or not.  Then we are guaranteed to have the normal pt_regs at the
location normal for process in the middle of syscall.  Under the kernel
thread stack.  Just pass the normal location of pt_regs to do_execve()
and the only black magic left is essentially a longjmp() all way out to
stack frame of ret_from_kernel_thread().  I.e. reset the stack pointer
and off we go to return from syscall.  I've gone that way; the remaining
bit of black magic is called ret_from_kernel_execve() and it's fairly
simple.  Same architectures converted, the rest needs help.
	If we get all architectures converted wrt kernel_thread(), we'll
be able to do even simpler:
	* step 1: take do_exit() calls from the 30-odd assembler functions
into 3 or 4 places in thread payloads where they can return without calling
do_exit() themselves.  All of which are in init/*.c and kernel/*.c
	* step 2: turn ret_from_kernel_thread() instances into
"call schedule_tail(), call the callback, jump to return from syscall",
killing all ret_from_kernel_execve, turning kernel_execve() callers
(all 2 or 3 of them) into "call do_execve() on normal pt_regs" and letting
the kernel_thread() callbacks return if and only if they'd succeeded in
do_execve().
At that point we'll have all longjmp-like crap gone and ret_from_kernel_thread
becomes really very similar to ret_from_fork - the only difference is the
call of kernel_thread() callback before going to userland.  If that callback
returns, that is, rather than doing do_exit()...

	Further benefits of that will be that *all* do_execve() callers will
be passing it the normal location of pt_regs.  So we can bloody well get rid
of that argument and just use current_pt_regs() when something like
elf_load_binary() really needs to access pt_regs.  There goes struct pt_regs *
argument of do_execve(), ->load_binary(), etc.

	A bit more about the black magic: the ways sys_execve() and friends
locate struct pt_regs to pass to do_{execve,fork} are definitely not fit
for describing in polite company.  They are architecture-dependent and bloody
kludgy more often than not.  Large part of the kludginess comes from the
architectures doing kernel_execve()/kernel_thread() as syscall-in-kernel-mode,
since you get pt_regs in unusual location.  Switching to generic variants
gets rid of that, of course.
	I've introduced a new helper in that series - current_pt_regs().
Usually it's the same thing as task_pt_regs(current), but it should
work at any time (task_pt_regs() is guaranteed to work only when the task
is stopped by ptrace).  That, of course, allowed to merge sys_execve()
on all converted architectures, with the result living in fs/exec.c and
having no magical struct pt_regs * arguments.  The same thing happens
to compat variant of execve() on biarch targets, of course.

	We could also get rid of struct pt_regs * in do_fork() once we are
done with the conversion; copy_thread() can bloody well do current_pt_regs()
itself.  And yes, the cost of calculating it is going to be lower than
passing it through at least 3 function calls.  On anything.  We also can
do architecture-agnostic variants of sys_fork()/sys_clone()/sys_vfork(),
getting rid of another load of black magic and code duplication.

	I've some further plans for that series, but that's really a separate
story; the above is more than enough for the coming cycle.

	Right now the tree lives in
git.kernel.org/pub/scm/linux/kernel/git/viro/signal experimental-kernel_thread
Some of that had been in -next for a while.

	Folks, help with review, testing and filling the missing bits, please.  
