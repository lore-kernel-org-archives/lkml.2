Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834Ab2DYDHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 23:07:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35824 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157Ab2DYDHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 23:07:03 -0400
Date: Wed, 25 Apr 2012 04:06:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120425030659.GE6871@ZenIV.linux.org.uk>
References: <20120420025438.GD6871@ZenIV.linux.org.uk>
 <CA+55aFzinX_6DVvDTyxrsP6VEHVY2Q+Y=e+qksnAjR+oT3GZew@mail.gmail.com>
 <20120420080914.GF6871@ZenIV.linux.org.uk>
 <CA+55aFxia+u3VAf0qN-2wv7DyAQZK-Z8=n=cqUvo--+C905aFg@mail.gmail.com>
 <20120420160848.GG6871@ZenIV.linux.org.uk>
 <20120420164239.GH6871@ZenIV.linux.org.uk>
 <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com>
 <20120420180748.GI6871@ZenIV.linux.org.uk>
 <20120423180150.GA6871@ZenIV.linux.org.uk>
 <20120424072617.GB6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424072617.GB6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> And then there's a lovely issue of what syscall restarts - both on multiple
> arriving signals (we want the restart to apply on the _first_ signal being
> processed, TYVM, since the rest of those signals are not interrupting
> a syscall - conceptually, they are interrupting the previous signal handlers
> at the point of entry) and on {rt_,}sigreturn(2) (where we might get a value
> in the register normally used to return sys_whatever() value that would look
> like one of restart-related special errors, except that it's simply what that
> register used to have when e.g. a timer interrupt had hit while we had a signal
> pending; hell to debug, since it looks e.g. like one register in userland
> process getting its value randomly replaced with -EINTR if it happened to
> contain -ERESTARTSYS when an interrupt had happened).  I'd fixed one like
> that on arm a couple of years ago, but AFAICS we still have several on
> other architectures ;-/

FWIW, there's an interesting question rmk has brought up.  Consider the
following scenario (on any architecture):
	sigsuspend(2) sees a signal and returns ERESTARTNOHAND.
	do_signal() is called and calls get_signal_to_deliver() and gets 0,
for whatever reason.
	We decide to restart, return address adjusted, syscall number
returned to the right register in pt_regs.  In the meanwhile, no matter what
state interrupts used to have before, get_signal_to_deliver() has enabled
them when returning, so we'll need to reload thread flags.  And we find that
another signal has arrived in the meanwhile.
	OK, do_signal() is called again, and this time we have a handler for
the arrived signal.  We form a stack frame and return to userland, into the
beginning of the handler.  We don't even look at the restart-related logics
this time around, due to the usual logics protecting us from double restarts.
	Handler is executed, up to rt_sigreturn(2).
	We decode the sigcontext, restore pt_regs and return to userland.
	Right into the beginning of interrupted sigsuspend()

So we have sigsuspend() hit by a signal we have a handler for.  Handler is
executed and we are stuck is sigsuspend() again, all because a signal without
a handler has arrived just before that one - close enough for our signal to
come right after get_signal_to_deliver() has returned zero to do_signal().

AFAICS, that's a clear bug.  Arrival of a signal that has userland handler
and that isn't blocked by the mask given to sigsuspend() should terminate
sigsuspend().  Sure, we can weasel around the wording in POSIX (it says
"sigsuspend() will return after the signal-catching function returns" without
explicitly saying that it shouldn't sit around waiting for another signals
to arrive), but it's obviously against the intent of standard (as well as
expectations of any programmer).  Note that if the handler-less signal had
arrived a bit earlier, we would've returned to userland and reenter the
kernel before the arrival of our signal.  Then it *would* terminate
sigsuspend() - handler would be executed and we would've returned to caller
of sigsuspend() with EINTR as return value.  If they came simultaneously,
the same thing would've happened - get_signal_to_deliver() would have
returned non-zero the first time around and that would be it.  It's just the
right timing for the second signal that triggers that race.

Solution proposed last summer when that had been noticed by arm folks was
more or less along the lines of
	* new thread flag, checked after we'd seen that no SIGPENDING et.al.
is there.  If it's set, we clear it, do syscall restart work as we would for
handlerless signal and recheck the flags if we had to do something like
__put_user() in process (arm might have to do that for ERESTART_RESTARTBLOCK)[1]
	* do_signal() would set that flag if
		+ anti double-restart logics would not have prevented
		  restarts
		+ error value was ERESTART_...
	* no restart work on "no signal" path in do_signal()
	* if we have a handler and the flag is set, clear it and do what
we normally do for restarts (including the "has ptrace mangled registers
in a way that would prevent restarts in the current code" logics for
architectures that have such logics - arm and sparc, at least).

I would've probably made that TS_... instead of TIF_... at least for something
like x86 - it's obviously thread-synchronous.

[1] it wasn't covered in that thread, but if a signal arrives during that
__put_user() we really won't care - the usual logics in sigreturn() will
make sure that when we return from handler into the resulting restart_syscall(2)
we'll have it immediately fail with -EINTR.

Comments?  AFAICS, the bug is arch-independent; it's not just arm and it's
worse than the example mentioned last year - sigsuspend() is a lot more
common than ppoll() and behaviour clearly goes against what sigsuspend()
exists for.
