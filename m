Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab2LHHoe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 02:44:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54037 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757948Ab2LHHob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 02:44:31 -0500
Date: Sat, 8 Dec 2012 07:44:29 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [braindump][RFC] signals and syscall restarts (Re: [PATCH v2
 19/44] metag: Signal handling)
Message-ID: <20121208074429.GC4939@ZenIV.linux.org.uk>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
 <1354723742-6195-20-git-send-email-james.hogan@imgtec.com>
 <20121205171609.GW4939@ZenIV.linux.org.uk>
 <50C07ECE.9070602@imgtec.com>
 <20121206220955.GZ4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121206220955.GZ4939@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 10:09:55PM +0000, Al Viro wrote:
> 	"Subtle and undocumented" is an extremely polite way to describe that.
> By now we had at least a dozen architectures step on that trap, simply because
> they had different calling conventions and the same logics did *not* "just
> work" there.  
> 
> 	What we need to guarantee is
> * restarts do not happen on signals caught in interrupts or exceptions
> * restarts do not happen on signals caught in sigreturn()
> * restart should happen only once, even if we get through do_signal() many
> times.

FWIW, here's the current situation:

alpha: works.  Double restarts are prevented by the loop in do_work_pending()
resetting 'r0' (syscall number or 0 if restarts should not be done)
to 0 after the first call of do_signal(); all restart logics is conditional
on r0 != 0.  The logics making sure that we get the right value passed
to do_work_pending() is convoluted and had cost us at least one bug
(sigreturn/rt_sigreturn had stopped only once in case of straced process;
strace(1) got seriously confused and produced garbage).

arm: works.  Double restarts are prevented by logics similar to alpha
do_work_pending(); prevention of restarts on non-syscalls and sigreturn is
done by asm glue setting r8 ('why', aka 'tbl') to 0 in non-syscall entry points
and to syscall table address in syscall entry; zeroed in asm wrappers for
sigreturn/rt_sigreturn.  Used to be broken until several years ago.

arm64: works.  Syscall number is in pt_regs (->syscallno); -1 for non-syscall
ones.  Reaching do_signal() the first time around will set it to -1 and so will
sigreturn (in restore_sigframe()).  Restart logics is conditional on
->syscallno being non-negative.

avr32: _very_ odd logics used to decide whether to do restarts or not and
frankly, I do not believe that it could possibly work correctly - whatever
we do when building a sigframe, we don't touch SYSREG_SR in process, so
that won't prevent double restarts.  And if we had r12 (first argument of
syscall) restart-worthy at the entry, setup_syscall_restart() will leave
us with restart-worthy value in ->r12.  So e.g. pause(2) called when
r12 happened to contain -514 (it's a zero-argument syscall, so calling it
doesn't involve assignments to r12) will happily hit double restarts if
we have e.g. SIGCHLD coming often enough.  If that thing works, I would
really appreciate a detailed explanation of how it manages to do that - it
definitely deserves one.

blackfin: doesn't handle multiple signals; if you get a SIGSEGV generated
by failing attempt to set a sigframe up, too bad - you'll pass to userland
and coredump will hit at some later point when a hardware interrupt happend.
Restarts on sigreturn and non-syscalls are prevented by checking if
->orig_p0 is non-negative (similar to arm64 solution above) and it's easy to
turn into prevention of double restarts, which will become necessary as soon
as multiple signal handling gets fixed.  Actually, it's almost OK as is -
ERESTART_RESTARTBLOCK case is the only problematic one.

c6x: there's a flag next to pt_regs on stack and it's non-zero if and only
if we have a syscall.  Passed explicitly to do_notify_resume() to tell if
restarts are allowed.  As far as I can see, it is vulnerable to bogus
restarts on sigreturn (can be fixed by clearing the same flag in
do_rt_sigreturn() - simple *(long *)(regs + 1) = 0 in there will do).
It might be vulnerable to double restarts as well - pause(2) is not
enabled there, but it's not much comfort.  In the best case we are relying
on the following property:
	no syscall can return -ERESTART... when called with the first
argument equal to that value.
Might be true (the usual suspects are pause() and ancient sigsuspend() of
3-argument variety and neither is used here), but it's brittle as hell.
Come to think of that, clone(2) would probably fit the bill - we ignore
all unknown bits in the mask and clone(2) *can* return -ERESTARTNOINTR.
So it's almost certainly vulnerable.  The same fix would do, but explicit
loop a-la arm might be better.

cris: same lossage as on blackfin (quits after the first signal).  Vulnerable
to bogus restarts on sigreturn.  Would be vulnerable to double restarts if it
handled multiple signals.

frv: works (similar to the situation on arm64.  Used to be broken until a
couple of years ago.

h8300: works.  Prevention of restarts on sigreturn and non-syscalls based
on sign of ->orig_er0; the first pass through syscall restart logics renders
regs->er0 (return value) non-restart-worthy - anything that used to be
restart-worthy becomes either non-negative (->orig_er0 has to be, or we
won't touch that at all) or -EINTR.  In other words, we can't hit that
sucker twice.

hexagon: broken.  Prevention of restarts on non-syscalls is based on
sign of ->syscall_nr.  sigreturn carefully sets it *positive* and that
makes it vulnerable to bogus restarts.  Moreover, double restarts are
possible as well, same as on c6x.

ia64: really, really weird.  The main source of weirdness is that in
addition to usual cleanup on return from handle, it has very non-trivial
work done on *entry* to handle (register stack manipulations) and its
asm glue is really a thing to behold - from a safe distance, preferably
with warranty that you won't need to touch it.  I *think* it avoids the
restart-related holes, but...

m32r: works.  regs->syscall_nr is used in more or less usual fashion;
sigreturn and non-syscalls set it to -1 and so does the shiftback
logics in case of do_signal().  I would probably move setting it to -1
from prev_insn() to just before both switches by return value, but that's
cosmetical.  Used to be broken until a couple of years ago...

m68k: works.  Same situation as for x86 - ->orig_d0 set to -1 by non-syscalls
and sigreturn, restart-worthy return value (in ->d0) can be had only if
the syscall number (in ->orig_d0) was non-negative and that's enough to
make it non-restart-worthy after handle_restart().

microblaze: broken, fixes await an ACK from maintainer.

mips: works.  regs->regs[0] is used more or less as ->syscall and friends
are on other architectures.  Explicitly cleaned on syscall restart.
sigreturn bypasses the codepath on the normal way out of syscall where
the thing is set to non-zero (we do it only on sys_something() returning
an error there).  Used to be broken...

mn10300: works.  Usual story, ->orig_d0 set to -1 by non-syscalls, by
sigreturn and by restart logics.  This approach is possible on architectures
where the register clobbered by return value is used for syscall number;
preserved value can't be negative, or we'll never get a restart-worthy
return value in the first place.  Used to be broken...

openrisc: broken.  regs->orig_gpr11 can be easily used to fix - it fits the
usual model, but isn't set by sigreturn/restarts.  BTW, the comment around
the call of do_notify_resume() in the asm glue is deeply confused - we *do*
want the userspace pt_regs; fortunately, there can't be any on top of those
at that point.

parisc: works.  regs->orig_r28 is used as a flag suppressing restarts (used
by sigreturn and restart).  Used to be broken...

powerpc: works.  regs->trap is used to tell syscalls from non-syscalls and
it's tweaked by sigreturn/restarts.  Used to be broken...

s390: works.  This one uses thread flag (TIF_SYSCALL) as an indicator,
clearing it in sigreturn and restarts.  In reality, it uses the same
"handlerless restarts without stepping out into userland" model as
arm does (well, the other way round, really), but the loop is done in
asm glue instead of taking it into C...  The things are slightly complicated
because the same flag is used to tell the caller of do_signal() that it
ought to do restart-without-stepping-out right now.  IMO taking the
damn thing into C would make it at least easier to review, but there might
be some dragons elsewhere in that loop.

score: works (well, in that respect, at least).  Explicit regs->in_syscall
handled in usual fashion.  Used to be broken (double restarts prevented,
but sigreturn missed).

sh32: regs->tra < 0 used to suppress restarts on non-syscalls and sigreturn,
but it seems to be vulnerable to double restarts.

sh64: similar, but this one actually works - regs->syscall_nr is used in a
similar way, but there the register clobbered by return value seems to be
the one used to pass the syscall number.

sparc: works.  syscall is indicated by a bit stolen from psr or tstate,
cleared in sigreturn/restarts.  Used to be broken...

tile: works.  regs->faultnum is used to suppress restarts - sigreturn
flips it from "I'm a syscall" to "I'm a sigreturn" and so does do_signal().
Used to be broken...

unicore32: works, but would really benefit from switch to *current* arm
variant (it's very obviously modelled after arch/arm, but the changes
done on arm hadn't propagated there).

x86: works.  The usual "we are using the same register for syscall number
and for return value, so we can't go through restart and keep a restart-worthy
return value" situation.

um/x86: same ABI as x86, same solution...

xtensa: works.  regs->syscall is used, solution based on having the same
register used for syscall number and return value.

The sad part is, those "used to be broken" bits are about the pile of fixes
done about two years ago (some by me, some - by architecture maintainers).
Since then we got
	* arm64 - modelled after arm, inherited the fixes
	* c6x - stepped on that minefield
	* hexagon - stepped on that minefield
	* openrisc - stepped on that minefield
	* unicore32 - modelled after arm, inherited the fixes
and a bunch of embedded architectures are *still* broken the same way they
had been back then ;-/  Sigh...
