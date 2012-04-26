Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239Ab2DZXTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 19:19:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56059 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2DZXTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 19:19:45 -0400
Date: Fri, 27 Apr 2012 00:19:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120426231942.GJ6871@ZenIV.linux.org.uk>
References: <CA+55aFzinX_6DVvDTyxrsP6VEHVY2Q+Y=e+qksnAjR+oT3GZew@mail.gmail.com>
 <20120420080914.GF6871@ZenIV.linux.org.uk>
 <CA+55aFxia+u3VAf0qN-2wv7DyAQZK-Z8=n=cqUvo--+C905aFg@mail.gmail.com>
 <20120420160848.GG6871@ZenIV.linux.org.uk>
 <20120420164239.GH6871@ZenIV.linux.org.uk>
 <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com>
 <20120420180748.GI6871@ZenIV.linux.org.uk>
 <20120423180150.GA6871@ZenIV.linux.org.uk>
 <20120424072617.GB6871@ZenIV.linux.org.uk>
 <20120426183742.GA324@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120426183742.GA324@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 08:37:42PM +0200, Oleg Nesterov wrote:
> b4b620b87fd2f388cf4c13fea21f31bed7c9a1b0 new helper: sigsuspend()
> 
> Looks obviously correct but I do not understand this chunk in kernel.c,
> 
> 	+ #ifndef __ARCH_HAS_SYS_RT_SIGSUSPEND
> 	+ /**
> 	+  *  sys_rt_sigsuspend - replace the signal mask for a value with the
> 	+
> 	 #ifdef __ARCH_WANT_SYS_RT_SIGSUSPEND
> 
> So this checks the (never used/defined?) __ARCH_HAS_SYS_RT_SIGSUSPEND
> but comments out __ARCH_WANT_SYS_RT_SIGSUSPEND. Looks like a typo.

	Buggered manual cherry-pick - earlier there was a patch inverting
__ARCH_WANT_SYS_RT_SIGSUSPEND (only mips did _not_ have it after the
whole series, and only because it has sys_rt_sigsuspend() of its own
with unusual prototype).  I ended up dropping it and mishandled conflict
resolution.  Fixed.

> 6b78370886e4f61187404b7737a831281bde35e8 xtensa: switch to generic rt_sigsuspend(2)
> and
> d978bf9dd41728dd60fe2269493fe8f21d28eef3 h8300: switch to saved_sigmask-based sigsuspend/rt_sigsuspend
> 
> (off-topic, but do_signal()->try_to_freeze() looks unneeded and wrong)

Yes, get_signal_to_deliver() will do it.  I'd killed some instances in the
last round of signal fixes (2010), but never got around to doing that for
all architectures.

> 	+       /* If there's no signal to deliver, we just restore the saved mask.  */
> 	+       if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
> 	+               clear_thread_flag(TIF_RESTORE_SIGMASK);
> 	+               sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
> 			^^^^^^^^^^^
> 
> set_current_blocked(&current->saved_sigmask) looks better.

In principle, yes.  FWIW, I think that the entire thing should be a helper
to go along with set_restore_sigmask().  With
	if (test_and_clear_thread_flag(TIF_RESTORE_SIGMASK))
		set_current_blocked(&current->saved_sigmask);
as default implementation.  The only question is where should it go -
asm/thread_info.h is not a good place due to header dependencies.
Kinda-sorta solution - in thread_info.h
{set,clear,test,test_and_clear}_restore_sigmask()
and in linux/signal.h
#ifdef HAVE_SET_RESTORE_SIGMASK
static inline void restore_saved_sigmask(void)
{
	if (test_and_clear_restore_sigmask())
		set_current_blocked(&current->saved_mask);
}
static inline sigset_t *sigmask_to_save(void)
{
	struct sigset *res = &current->blocked;
	if (unlikely(test_restore_sigmask()))
		res = current->saved_sigmask;
	return res;
}
#endif

Speaking of other helpers, pulling ppc restore_sigmask() into signal.h
(as static inline) might be a good idea.  Every sigreturn instance is
open-coding it...  We need saner names, though; this set is too easy to
confuse with each other.

> f1fcb14721b4f1e65387d4563311f15f0bd33684 alpha: tidy signal delivery up
> 
> Everything looks fine, but I have the off-topic question. The changelog
> says:
> 
> 	* checking for TIF_SIGPENDING is enough; set_restart_sigmask() sets this
> 	one as well.
> 
> Agreed, but why set_restore_sigmask() sets TIF_SIGPENDING? It should be
> never used without signal_pending() == T.

Umm...  Probably, and as far as I can see all callers are only reached if
we have SIGPENDING, but that requires at least documenting what's going on.
