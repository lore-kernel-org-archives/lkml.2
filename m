Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab2LFWKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 17:10:00 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45231 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab2LFWJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 17:09:57 -0500
Date: Thu, 6 Dec 2012 22:09:55 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [braindump][RFC] signals and syscall restarts (Re: [PATCH v2 19/44]
 metag: Signal handling)
Message-ID: <20121206220955.GZ4939@ZenIV.linux.org.uk>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
 <1354723742-6195-20-git-send-email-james.hogan@imgtec.com>
 <20121205171609.GW4939@ZenIV.linux.org.uk>
 <50C07ECE.9070602@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C07ECE.9070602@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 11:17:34AM +0000, James Hogan wrote:

> Agreed, it looks wrong. Looking at the sh version, is there a particular
> reason to only check for -EFAULT and not the other errors that
> do_sigaltstack can return (-EPERM, -EINVAL, and -ENOMEM)?

See commit fae2ae2a900a5c7bb385fe4075f343e7e2d5daa2

> > BTW, what's to stop the syscall restart triggering if you catch a signal
> > while in rt_sigreturn(2)?
> 
> I'm not sure I understand how that could cause a problem. Could you
> elaborate the sequence of events?
> 
> The signal restart is triggered by the return value register, so
> rt_sigreturn would have to return -ERESTART*. This could happen if the
> signal handler overwrote the return value in the sigcontext (which as
> far as I can tell could also happen on ARM), or if the syscall that was
> originally interrupted by the signal has -ERESTARTNOINTR ||
> (-ERESTARTSYS && SA_RESTART), but in that case rt_sigreturn has already
> switched back to the context of the original syscall so that's the right
> thing to do isn't it? I've probably missed something important :-)

[we probably need something along the lines of braindump below in 
somewhere in Documentation/*; comments and improvements are very
welcome - this is just a starting point.  We *do* need some coherent
explanation of signal semantics, judging by how often people step on
the same landmines...]

	To understand what's going on with the signals, it's better
to think of crossing the kernel boundary not as of function call and
return from it, but as of coroutines passing control back and forth.

	When we enter the kernel mode, we start with saving CPU state.
Usually (and you are going to hate that word well before you read to
the end) it's stored in struct pt_regs, but it might be more complicated.
For our purposes it's better to think of it as abstract saved state,
leaving aside the question of how it's represented.

	What happens next depends on why we'd been called - it might
have been an interrupt or exception or it might have been a syscall.
The main difference is, of course, that on return from interrupt or
exception we want registers unchanged while on return from syscall we
expect to find return value in a register.  Another thing is that
after syscall we want to advance to the next instruction, while e.g.
a page fault usually wants to repeat the instruction that had triggered
it.  It's _very_ architecture-dependent; in any case, we usually know
very early which userland instruction would we normally have executed
next, so let's consider that knowledge a part of saved state.

	For now I'm going to ignore ptrace-related horrors; it's a
separate story (and an ugly one).  In absense of that, the syscall
execution is conceptually simple -
	* choose which function to call and what arguments to pass
to it (both derived from saved state; usually that's picked directly
from values left in registers by userland, but there might be more
convoluted cases when e.g. syscall number is encoded as part of
instruction or some arguments are passed on userland stack, etc.)
	* do a function call
	* shove return value into the saved state
At that point we are ready to resume the execution of userland code.
Usually.  Unless a signal had arrived.  So far it looked pretty much
like a function call - sure, we had been using the kernel stack instead
of the userland one, the calling sequence had been unusual and the call
chain included a nasty glob of assembler glue, but as far as control
flow is concerned, everything looks as if we'd called a function and
returned from it.  It's about to get more complicated, though.

	Signal arrival is indicated by TIF_SIGPENDING flag set on the
target process.  If we see it set when we are about to resume the
execution in userland, we find out which signal has it been and what
handler (if any) do we have for it.  For now I'm going to leave the
syscall restart logics aside; we'll get back to it shortly.  Suppose
we had a successful call of open(2) or e.g. just handled a page fault.
We have saved state ready for resuming the userland execution.  It
contains the address of next instruction to execute and, in case of
open(2), has the return value of sys_open() already reflected in it.
Now we find ourselves wanting to have a signal handler executed; it's
a userland function and we can't have that run in kernel mode.
Here's what we normally do:
	* create a new userland coroutine context - that's what sigframe
is about.
	* encode the saved state and store it in sigframe
	* modify the saved state so that the next instruction to execute
would be at the beginning of signal handler, registers would look as if
we were passing the right arguments to that handler and return address
(either in register or in stack frame built for the handler - depends on
ABI) would point to a small piece of code that would do cleanup and
terminate that coroutine (more on that in a minute).
	* resume userland execution from the modified saved state.

	Note that signal handler will have a call chain all of its own;
it does *not* continue the call chain we used to have before we'd caught
that interrupt or issued the syscall.  Something like gdb(1) will have
the smarts to recognize the bottom of handler call chain and locate the
end of the old call chain by the data encoded into the sigframe, so
if you ask to show the trace you'll see both, but it's still the separate
coroutine activation with the call chain of its own.

	If we catch and handle a signal while we are in our handler,
the nested handler will get a coroutine of its own, complete with sigframe,
call chain, etc.  That, BTW, explains what we ought to do if we find that
more than one signal is pending - just create more sigframes, encoding
the saved states as we'd done for the first one, updating them, etc.
I.e. act as if we had an interrupt arriving just as we were entering the
first handler, with the second signal found on the way out of that interrupt
and so on.

	OK, so after all that fun we finally run out of the work to be
done kernel-side and resume userland execution.  We are in signal handler
now.  What happens when it runs to the end?  We return, obviously, but
where?  The kernel call chain is long gone; signal handler is *not* called
from it.  We also can't just return to the main program.  We are not called
from there either.  For a lot of very good reasons, starting with "who's
going to restore the registers that are not callee-saved?".  Suppose the
thing that has started all that joy was a page fault.  We really, really
do not want to find some register used for holding intermediate values and
not preserved by function calls suddenly losing whatever value we used to
have there.  It's OK to have that happen when we do explicit function
call (compiler knows of those), but having it happen at any read from
memory, or, better yet, hardware interrupt arrival?
	In other words, we need to do some work upon return from handler.
At the bare minimum, we need to use the saved state encoded in sigframe
to set the registers as they ought to be if we had *not* been hit by
that signal.  In principle, that could be doable entirely in the userland,
but usually that code is kept kernel-side.  That's what sigreturn(2) is;
the small piece of userland code I've mentioned above consists of just
issuing one syscall.  It might live in libc, it might live in read-only
user-accessible page mapped by the kernel into any process (i.e. in vdso),
it might even live directly in struct sigframe itself.

	sigreturn(2) decodes the saved state from sigframe.  If we resume
userland execution from that state, we'll end up where we would be if the
signal hadn't arrived.  If we have more signals arrive at that point (e.g.
SIGSEGV from failed attempt to read the sigframe), we just handle them as
usual.  I'm cheating a bit here - it's not quite the normal syscall, even
though we usually are able to reuse most of the syscall-related codepath
for it; more on that after we deal with syscall restart mess.

	And a mess it is.  Consider a system call that might take indefinitely
long time - e.g. read(2) waiting for something to be typed.  We obviously don't
want to have signal handling held back indefinitely; if a signal arrives when
we'd already have something to return, we can just return from read(2) with
whatever we'd already got and handle it on the way out as usual.  The program
ought to be able to cope with read() returning less than full buffer.  But what
do we do if nothing had been typed in yet?  Returning 0 is out of question -
that's the end of file indicator.  One solution is to return -EINTR ("syscall
had been interrupted by a signal") and having userland treat it as "call read(2)
again".  Simple, except that it relies on userland doing the right thing, which
is an assumption best avoided.  4BSD hack: let's move the instruction pointer
in saved state back to the syscall instruction before encoding it into sigframe.
When the handler finishes and does sigreturn, we'll end up picking that saved
state from sigframe and resume the execution, which will immediately issue the
same syscall again.  No need to check -EINTR in userland, no need to have loop
there, Everything Just Works(tm).  If only...

	For one thing, SVR3 had introduced its own set of signal-related
changes, incompatible with BSD ones.  And SVR4 had reconciled those two
with its usual, er, elegance.  Which is to say, introduced flags for
simulating either.  SA_RESTART in flags passed to sigaction(2) => BSD
behaviour, no SA_RESTART => SVR3 one.  Moreover, there are syscalls that
never allowed -EINTR as return value and some of them really want restarts.
The most obvious case is clone(2) - the rules for signal delivery to threads
are convoluted enough, so before making new thread visible to send_signal()
we check if there are pending signals and proceed only if there isn't any.
Otherwise we just have clone(2) transparently restarted.  Another complication
is sigsuspend(2) - there we want any signal with handler to have us return
-EINTR (and have the handler executed, of course), with any handlerless
signal restarting the damn thing.  The worst horror is poll(2) and friends;
it's similar to sigsuspend(2), but we don't want to have the timeout reset
on restart.

	So we have 4 different kinds of behaviour, to start with.  OK,
sys_whatever() may return one of the 4 magical error values
(ERESTART<something>), selecting the kind of restart it wants.  Ugly,
but tolerable.  Since they only make sense when we have a pending signal, we
can delay dealing with that crap until we get to do_signal() and friends -
well off the fast path.  They are never returned to userland - it either gets
-EINTR or has the syscall restarted anyway.

	The next problem is that shifting the saved instruction pointer
back to the syscall insn is not enough - if the syscall return value goes
into a register used to pass syscall number or one of syscall arguments,
we'd better have a way to restore it.  Architecture-dependent, obviously,
since the calling conventions are.  Generally we either save the original
value somewhere in pt_regs or just have it explicitly passed to do_signal()
and friends as an argument.

	The way it's done in Linux:
	* sys_something() may return one of the 4 magic return values -
-ERESTART{SYS,NOHAND,NOINTR,_RESTARTBLOCK}.  That should be done *only*
if there's a signal pending.
	* on the way out of syscall the signal is noticed; then
		* -ERESTARTSYS is interpreted as "shift the instruction pointer
		  back to syscall instruction" if SA_RESTART had been set when
		  we'd installed the handler and turned into -EINTR otherwise
		  (read(2) and friends)
		* -ERESTARTNOHAND is "shift back" if no handler is set, -EINTR
		  otherwise (sigsuspend(2))
		* -ERESTARTNOINTR is unconditional "shift back" (fork(2) et.al.)
		* -ERESTART_RESTARTBLOCK is -EINTR if there's a handler and
		  a horrible pile of hacks otherwise (timeout-related ones).

	There are rather subtle bugs possible^Wprobable^Wcommon in
implementations of the above.  Let's consider several cases:

	1a) suppose we have two pending signals, both with handlers, and the
return value of syscall is restart-worthy.  We want to shift the instruction
pointer in saved state back to the syscall instruction and encode that state
into the first sigframe.  Then we set the saved state for entry into the
handler.  Allocate the second sigframe and save that state in there.  Then
set the saved state for entry into the second handler and to the userland we
go.  The second handler executes first and eventually gets to sigreturn().
Then the saved state is decoded from the second sigframe and we resume in
the entry to the first handler.  When *that* finishes and gets to sigreturn(),
we pick the state saved in the first sigframe and resume from it, hitting the
original syscall instruction again.  Note that we want only ONE shift back -
before we set the first sigframe.  If we do the shift back for the second
signal as well, we'll end up with the state encoded in the second sigframe
pointing one instruction prior to the entry point of the first handler.

	1b) suppose we have only one signal pending (e.g. SIGCHLD) and it has
no handler.  We'd done the default action and decided to restart the syscall.
Between that and other work we needed to do on the way out, we had another
signal arrive, this time - with handler.  We do NOT want the instruction
pointer to be shifted back one more time.

	2) suppose we caught a signal in hardware interrupt or in exception.
Even if the register used for syscall return value happens to contain one of
those magic values, we don't want any of that restart logics to trigger,
obviously.

	3) suppose we have a signal caught, its handler executed to the end and
another signal caught just as we'd been doing sigreturn().  We do NOT want any
of the restart logics to trigger.  It's quite obvious if the first signal had
been caught in interrupt handler (no syscall to repeat), but it's just as true
if we *were* in syscall when we'd caught the first signal.  We had done the
shift back before encoding the saved state into sigframe; now sigreturn has
read it from there and we really don't want it to happen once more.

	i386 solution is to set regs->orig_ax to eax on syscall entry, to -1
on interrupt and exceptions and to have sigreturn set it to -1.  That works,
all right, but the reason it works is subtle and completely undocumented.
The reason why (1a) avoids double restart is that we use the same register
for syscall return value and the first argument of signal handler.  After
we'd set the first sigframe, the value in regs->ax (which is where the syscall
return value goes) doesn't look restart-worthy anymore - it's something in
range 1..64, not -512 or so.  (1b) works correctly because the same register
is used for syscall numbers.  So after we'd done the shift back, we have
regs->ax equal to the original syscall number and those are all positive and
thus are not restart-worthy (anything negative would've resulted in -ENOSYS,
and we wouldn't have hit the restart logics in the first place).  (2) and
(3) avoid the breakage since we use regs->orig_ax >= 0 as "is it a syscall?"
test in there.

	"Subtle and undocumented" is an extremely polite way to describe that.
By now we had at least a dozen architectures step on that trap, simply because
they had different calling conventions and the same logics did *not* "just
work" there.  

	What we need to guarantee is
* restarts do not happen on signals caught in interrupts or exceptions
* restarts do not happen on signals caught in sigreturn()
* restart should happen only once, even if we get through do_signal() many
times.

	Unfortunately, potential problems do not stop there.
4) suppose we are sitting in sigsuspend() and get SIGCHLD; we have no signal
handler for it, so we just get a restart.  Off to userland we go, only to
have two things happen just as we had been about to reenter the syscalls:
	* SIGUSR1 is sent to us (and we do have a handler for it)
	* hardware interrupt hits
OK, we handle the damn thing and return to the interrupted activity - namely,
reentering the kernel in sigsuspend(2).  Had that interrupt arrived a cycle
later, we would have sigsuspend(2) notice that we have a pending signal and
since it has a handler, -EINTR we get (and handler is executed).  One can
argue that POSIX allows it (and it had been done), but arguments both rely
on things like "a program can't assume it won't just lose CPU for a day" *and*
have actual gaps in them if ptrace(2) enters the picture.

	The real problem here is handlerless restart going through the
userland.  It's nowhere near as nasty as double-restart kind of bugs,
but it's best avoided, for QoI reasons if nothing else.  I think that
what we currently do on arm makes a good approximation to sane semantics,
at least for architectures that have everything saved in pt_regs.

	As for sigreturn(2) complications, beside the one already mentioned
(no signal restarts in it)...  For one thing, on at least one architecture
(m68k) there are different types of stack frames created when on exceptions.
And the type of stack frame is a part of saved state there - sigreturn()
needs to set the correct one up for instruction restart to work.  The trouble
is, they might be bigger than the frame created on syscall *and* kernel
stack pointer is preserved while we are in user mode, so we must leave with
the same value in kernel stack pointer we had when we entered, or it'll
eventually drift out of stack page.  And no, you don't want to look at the
things the poor sucker ends up doing - essentially, memmove() on kernel
stack to open up the gap we need.  Another complication is far more common:
quite a few architectures don't bother to save everything in pt_regs and
leave the callee-saved registers alone.  Whatever we do in C code in the
kernel, that stuff will be restored by the time we return to asm glue.
Strictly speaking, we don't have to save those suckers in sigcontext; after
all, signal handler is supposed to preserve them as well.  For example, itanic
deliberately does not save them.  However, most of such architectures do
save them in sigcontext and that's a part of ABI.  See sys_{rt_,}sigreturn()
on alpha for more or less readable example of consequences...
