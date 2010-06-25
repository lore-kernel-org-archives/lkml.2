Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab0FYTWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 15:22:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab0FYTWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 15:22:51 -0400
Date: Fri, 25 Jun 2010 21:20:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Darren Hart <dvhltc@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Schwab <schwab@redhat.com>, Danny Feng <dfeng@redhat.com>,
       Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Q: sys_futex() && timespec_valid()
Message-ID: <20100625192008.GA25337@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Another stupid question about the trivial problem I am going to ask,
just to report the authoritative answer back to bugzilla. The problem
is, personally I am not sure we should/can add the user-visible change
required by glibc maintainers, and I am in no position to suggest them
to fix the user-space code instead.


In short, glibc developers believe that sys_futex(ts) is buggy and
needs the fix to return -ETIMEDOUT instead of -EINVAL in case when
ts->tv_sec < 0 and the timeout is absolute.

Ignoring the possible cleanups/microoptimizations, something like this:

--- x/kernel/futex.c
+++ x/kernel/futex.c
@@ -2625,6 +2625,16 @@ SYSCALL_DEFINE6(futex, u32 __user *, uad
 		      cmd == FUTEX_WAIT_REQUEUE_PI)) {
 		if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
 			return -EFAULT;
+
+		// absolute timeout
+		if (cmd != FUTEX_WAIT) {
+			if (ts->tv_nsec >= NSEC_PER_SEC)
+				return -EINVAL;
+			if (ts->tv_sec < 0)
+				return -ETIMEDOUT;
+		}
+
+
 		if (!timespec_valid(&ts))
 			return -EINVAL;
 
------------------------------------------------------------------------

Otherwise, pthread_rwlock_timedwrlock(ts) hangs spinning in user-space
forever if ts->tv_sec < 0.

To clarify: this depends on libc version and arch.

This happens because pthread_rwlock_timedwrlock(rwlock, ts) on x86_64
roughly does:

	for (;;) {
		if (fast_path_succeeds(rwlock))
			return 0;

		if (ts->tv_nsec >= NSEC_PER_SEC)
			return EINVAL;

		errcode = sys_futex(FUTEX_WAIT_BITSET_PRIVATE, ts);
		if (errcode == ETIMEDOUT)
			return ETIMEDOUT;
	}

and since the kernel return EINVAL due to !timespec_valid(ts), the
code above loops forever.

(btw, we have same problem with EFAULT, and this is considered as
 a caller's problem).

IOW, pthread_rwlock_timedwrlock() assumes that in this case
sys_futex() can return nothing interesting except 0 or ETIMEDOUT.
I guess pthread_rwlock_timedwrlock() is not alone, but I didn't check.



So, the question: do you think we can change sys_futex() to make
glibc happy?

Or, do you think it is user-space who should check tv_sec < 0 if
it wants ETIMEDOUT with the negative timeout ?

Thanks,

Oleg.

