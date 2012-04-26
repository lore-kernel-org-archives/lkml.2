Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab2DZSi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:38:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284Ab2DZSi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:38:26 -0400
Date: Thu, 26 Apr 2012 20:37:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120426183742.GA324@redhat.com>
References: <20120420025438.GD6871@ZenIV.linux.org.uk> <CA+55aFzinX_6DVvDTyxrsP6VEHVY2Q+Y=e+qksnAjR+oT3GZew@mail.gmail.com> <20120420080914.GF6871@ZenIV.linux.org.uk> <CA+55aFxia+u3VAf0qN-2wv7DyAQZK-Z8=n=cqUvo--+C905aFg@mail.gmail.com> <20120420160848.GG6871@ZenIV.linux.org.uk> <20120420164239.GH6871@ZenIV.linux.org.uk> <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com> <20120420180748.GI6871@ZenIV.linux.org.uk> <20120423180150.GA6871@ZenIV.linux.org.uk> <20120424072617.GB6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424072617.GB6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24, Al Viro wrote:
>
> Untested variants pushed into signal.git#master; will test tomorrow.  In
> the meanwhile, any code review (and testing of the entire thing on as many
> targets as possible) would be very welcome.

I started to read these patches today, will continue tomorrow. Somehow
I got stuck at f1fcb14721b4f1e65387d4563311f15f0bd33684, please see the
question below. And a couple of minor nits.




b4b620b87fd2f388cf4c13fea21f31bed7c9a1b0 new helper: sigsuspend()

Looks obviously correct but I do not understand this chunk in kernel.c,

	+ #ifndef __ARCH_HAS_SYS_RT_SIGSUSPEND
	+ /**
	+  *  sys_rt_sigsuspend - replace the signal mask for a value with the
	+
	 #ifdef __ARCH_WANT_SYS_RT_SIGSUSPEND

So this checks the (never used/defined?) __ARCH_HAS_SYS_RT_SIGSUSPEND
but comments out __ARCH_WANT_SYS_RT_SIGSUSPEND. Looks like a typo.





6b78370886e4f61187404b7737a831281bde35e8 xtensa: switch to generic rt_sigsuspend(2)
and
d978bf9dd41728dd60fe2269493fe8f21d28eef3 h8300: switch to saved_sigmask-based sigsuspend/rt_sigsuspend

(off-topic, but do_signal()->try_to_freeze() looks unneeded and wrong)

	+       /* If there's no signal to deliver, we just restore the saved mask.  */
	+       if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
	+               clear_thread_flag(TIF_RESTORE_SIGMASK);
	+               sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
			^^^^^^^^^^^

set_current_blocked(&current->saved_sigmask) looks better.






f1fcb14721b4f1e65387d4563311f15f0bd33684 alpha: tidy signal delivery up

Everything looks fine, but I have the off-topic question. The changelog
says:

	* checking for TIF_SIGPENDING is enough; set_restart_sigmask() sets this
	one as well.

Agreed, but why set_restore_sigmask() sets TIF_SIGPENDING? It should be
never used without signal_pending() == T.

IOW, do you know a reason why this patch

	--- x/arch/x86/include/asm/thread_info.h
	+++ x/arch/x86/include/asm/thread_info.h
	@@ -264,7 +264,7 @@ static inline void set_restore_sigmask(v
	 {
		struct thread_info *ti = current_thread_info();
		ti->status |= TS_RESTORE_SIGMASK;
	-	set_bit(TIF_SIGPENDING, (unsigned long *)&ti->flags);
	+	WARN_ON(!test_bit(TIF_SIGPENDING, (unsigned long *)&ti->flags));
	 }
	 
	 static inline bool is_ia32_task(void)

is not correct?

OK, say, sys_sigsuspend() does

	current->state = TASK_INTERRUPTIBLE;
	schedule();
	set_restore_sigmask();
	return -ERESTARTNOHAND;

so set_bit(TIF_SIGPENDING) saves us from the "spurious wakeup". But is
it really possible?

We had the bugs in ptrace some time ago (and iirc this is why sys_pause
checks signal_pending), but is there any reason today why the
TASK_INTERRUPTIBLE task can return from schedule() without SIGPENDING?
(of course, ignoring the case when this task was added to some
 wait_queue_head_t).


I am just curious. Perhaps set_restore_sigmask() sets SIGPENDING just
to be safer, but otoh this can hide the problem.

Oleg.

