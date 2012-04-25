Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab2DYMiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:38:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab2DYMit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:38:49 -0400
Date: Wed, 25 Apr 2012 14:37:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120425123746.GA15560@redhat.com>
References: <CA+55aFzinX_6DVvDTyxrsP6VEHVY2Q+Y=e+qksnAjR+oT3GZew@mail.gmail.com> <20120420080914.GF6871@ZenIV.linux.org.uk> <CA+55aFxia+u3VAf0qN-2wv7DyAQZK-Z8=n=cqUvo--+C905aFg@mail.gmail.com> <20120420160848.GG6871@ZenIV.linux.org.uk> <20120420164239.GH6871@ZenIV.linux.org.uk> <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com> <20120420180748.GI6871@ZenIV.linux.org.uk> <20120423180150.GA6871@ZenIV.linux.org.uk> <20120424072617.GB6871@ZenIV.linux.org.uk> <20120425030659.GE6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425030659.GE6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Al Viro wrote:
>
> FWIW, there's an interesting question rmk has brought up.  Consider the
> following scenario (on any architecture):
> 	sigsuspend(2) sees a signal and returns ERESTARTNOHAND.
> 	do_signal() is called and calls get_signal_to_deliver() and gets 0,
> for whatever reason.
> 	We decide to restart, return address adjusted, syscall number
> returned to the right register in pt_regs.  In the meanwhile, no matter what
> state interrupts used to have before, get_signal_to_deliver() has enabled
> them when returning

Afaics this doesn't really matter, TIF_SIGPENDING can be set by another CPU
once get_signal_to_deliver() drops ->siglock.

> , so we'll need to reload thread flags.  And we find that
> another signal has arrived in the meanwhile.
> 	OK, do_signal() is called again, and this time we have a handler for
> the arrived signal.  We form a stack frame and return to userland, into the
> beginning of the handler.  We don't even look at the restart-related logics
> this time around, due to the usual logics protecting us from double restarts.
> 	Handler is executed, up to rt_sigreturn(2).
> 	We decode the sigcontext, restore pt_regs and return to userland.
> 	Right into the beginning of interrupted sigsuspend()
>
> So we have sigsuspend() hit by a signal we have a handler for.  Handler is
> executed and we are stuck is sigsuspend() again, all because a signal without
> a handler has arrived just before that one - close enough for our signal to
> come right after get_signal_to_deliver() has returned zero to do_signal().

Yes, this (and the similar races) were already discussed a couple of times.
In short, regs->ax = -ERESTART* and ->ip doesn't survive after do_signal().
In this case the syscall was already restarted after the first do_signal()
even if we do not return to user-mode yet.

> AFAICS, that's a clear bug.

I do not know. So far it was decided that we do not really care, but
I won't argue if we decide to change the current behaviour.

As for sys_sigsuspend() and this race in particular:

> Arrival of a signal that has userland handler
> and that isn't blocked by the mask given to sigsuspend() should terminate
> sigsuspend().

Yes. But note that do_signal() restores the old sigmask. This means that
the signal we get after the first do_signal() was not blocked before
sigsuspend() was called. So, to some extent, we can pretend that the
handler was executed before sigsuspend() and it was never restarted.

IOW, I tend to agree with the comments from Roland, see for example

	HR timers prevent an itimer from generating EINTR?
	http://marc.info/?t=125210012600005

	[RESEND] [RFC][PATCH X86_32 1/2]: Call do_notify_resume() with interrupts enabled
	http://marc.info/?t=131955450100004

But let me repeat that I never really understood if this is "by design"
or not.

> Solution proposed last summer when that had been noticed by arm folks was
> more or less along the lines of
> 	* new thread flag, checked after we'd seen that no SIGPENDING et.al.
> is there.  If it's set, we clear it, do syscall restart work as we would for
> handlerless signal and recheck the flags if we had to do something like
> __put_user() in process (arm might have to do that for ERESTART_RESTARTBLOCK)[1]
> 	* do_signal() would set that flag if
> 		+ anti double-restart logics would not have prevented
> 		  restarts
> 		+ error value was ERESTART_...
> 	* no restart work on "no signal" path in do_signal()
> 	* if we have a handler and the flag is set, clear it and do what
> we normally do for restarts (including the "has ptrace mangled registers
> in a way that would prevent restarts in the current code" logics for
> architectures that have such logics - arm and sparc, at least).

Hmm. Not sure I understand this in details. But at first glance,
"do_signal() would set that flag" is not enough. We have the similar problem
if we dequeue a SA_RESTART signal first, then another signal without SA_RESTART.
Or I simply misunderstood.

Oleg.

