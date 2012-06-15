Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab2FOAKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:10:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:20656 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756439Ab2FOAKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:10:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="112292279"
Subject: Re: [RFC] x86, fpu: unify signal handling code paths for x86 and
 x86_64 kernels
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        robert.richter@amd.com, andreas.herrmann3@amd.com
Date: Thu, 14 Jun 2012 17:10:35 -0700
References: <1339545814.28766.148.camel@sbsiddha-desk.sc.intel.com>
	 <20120614143727.GF7922@escobedo.osrc.amd.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1339719035.3475.52.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 13:45 -0700, Suresh Siddha wrote:
> On Thu, 2012-06-14 at 16:37 +0200, Hans Rosenfeld wrote:
> > Thank you for working on this.
> > 
> > I didn't see anything obviously wrong in a quick review of this code,
> > but this stuff is too complex for this to mean anything :)
> > 
> > I ran a quick test of your code. I found a signal frame corruption when
> > running a 32bit test program on a 64bit kernel. I didn't try to find out
> > why it failed, but I'll send you the test program in a private mail so
> > you can look at it yourself.
> > 
> 
> Ok. The problem was that I was using is_ia32_task() (which uses
> TS_COMPAT) to check if the task is a compat task or not. And that flag
> is not set during the signal delivery paths for the compat task.
> 
> I guess I should be using TIF_IA32 check instead. Using TIF_IA32 check
> makes your test case run fine.
> 
> Will update it accordingly.
> 

For the above mentioned reason, I guess the current usage of
is_ia32_task() in copy_siginfo_to_user32() (added recently for x32
support) is broken, as the TS_COMPAT flag may not be set for the x86
compat mode apps in those paths.

Peter offline suggested that the signal  delivery path should probably
set/clear the TS_COMPAT flag (just like we do it for syscall paths), so
that is_ia32_task() will work in those paths.

But the exception paths for the 32bit and 64bit apps in the 64-bit
kernel is same. So I really need to use something like TIF_IA32 to find
out the compat mode of the task. Anyways, the comment in the below patch
explains the problem ;) What should we do? Just remove the
is_ia32_task() checks in signal paths and just use TIF_IA32 or do
something like below.

My personal preference is to use TIF_IA32 check and avoid  the usage of
is_ia32_task() in the signal delivery paths.

Signal return goes through a system call which already sets the
TS_COMPAT. It is the signal delivery that is causing the asymmetry.
---

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index b280908..d7f01fc 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -791,9 +791,39 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 	}
 
 	/* deal with pending signal delivery */
-	if (thread_info_flags & _TIF_SIGPENDING)
+	if (thread_info_flags & _TIF_SIGPENDING) {
+		bool compat_flag = false;
+
+		/*
+		 * Check if the task is a compat task and we are here
+		 * in a non-syscall path. If so, set TS_COMPAT explicitly
+		 * so that do_signal() can use is_compat_task()/is_ia32_task().
+		 *
+		 * Or Should we just use test_thread_flag(TIF_IA32) check
+		 * (which is called just 'is_ia32' in this file) instead of
+		 * using is_ia32_task() in signal delivery paths.
+		 *
+		 * BTW, ideally is_[ia32|x32|compat]_task() should be really
+		 * called as is_[ia32|x32|compat]_syscall() and the
+		 * TIF_IA32 check can then be called as is_ia32_task etc..
+		 *
+		 * Sigh...
+		 *
+		 */
+		if (is_ia32 && !is_ia32_task()) {
+			current_thread_info()->status |= TS_COMPAT;
+			compat_flag = true;
+		}
+
 		do_signal(regs);
 
+		/*
+		 * Clear the TS_COMPAT only if we set it above.
+		 */
+		if (compat_flag)
+			current_thread_info()->status &= ~TS_COMPAT;
+	}
+
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);


