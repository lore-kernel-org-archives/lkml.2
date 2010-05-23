Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0EWGlJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 02:41:09 -0400
Received: from www.tglx.de ([62.245.132.106]:37021 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029Ab0EWGlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 02:41:05 -0400
Date: Sun, 23 May 2010 08:40:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: John Stultz <johnstul@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Regression] Negative time on Acer Ferrari One with current
 -git
In-Reply-To: <201005222320.01506.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1005230815220.3368@localhost.localdomain>
References: <201005212343.25184.rjw@sisk.pl> <alpine.LFD.2.00.1005222032080.3368@localhost.localdomain> <201005222255.27301.rjw@sisk.pl> <201005222320.01506.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 May 2010, Rafael J. Wysocki wrote:
> After reverting commit 64ce4c2f above things work again.
> 
> To be precise, I reverted both commit 64ce4c2f and commit 6a867a3 (time: 
> Remove xtime_cache), but since the symptoms continued to apprear after
> reverting the latter alone, it's quite clear that commit 64ce4c2f breaks things
> on this box.

I assume the cmos clock of this machine is not on UTC, right ? Does
the patch below fix the issue ?

@John: Can you please check the other users of timespec_add_safe() in
timekeeping as well ?

Thanks,

	tglx

---------->
Subject: timekeeping: Fix timezone update
From: Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 23 May 2010 08:14:45 +0200

commit 64ce4c2f (time: Clean up warp_clock()) breaks the timezone
update in a very subtle way. To avoid the direct access to timekeeping
internals it adds the timezone delta to the current time with
timespec_add_safe(). This works nicely when the timezone delta is > 0.
If timezone delta is < 0 then the wrap check in timespec_add_safe()
triggers and timespec_add_safe() returns TIME_MAX and screws up
timekeeping completely. 

This is not surprising as the comment above timespec_add_safe() says:
    It's assumed that both values are valid (>= 0)

The function was created to avoid overflow issues when adding the
select() timeout to current time, where the above applies.

Add the timezone seconds adjustment directly.

Reported-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/time.c
===================================================================
--- linux-2.6.orig/kernel/time.c
+++ linux-2.6/kernel/time.c
@@ -132,10 +132,10 @@ SYSCALL_DEFINE2(gettimeofday, struct tim
  */
 static inline void warp_clock(void)
 {
-	struct timespec delta, adjust;
-	delta.tv_sec = sys_tz.tz_minuteswest * 60;
-	delta.tv_nsec = 0;
-	adjust = timespec_add_safe(current_kernel_time(), delta);
+	struct timespec adjust;
+
+	adjust = current_kernel_time();
+	adjust.tv_sec += sys_tz.tz_minuteswest * 60;
 	do_settimeofday(&adjust);
 }
 
