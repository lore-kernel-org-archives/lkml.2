Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750848Ab0DMECt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 00:02:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711Ab0DMECs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 00:02:48 -0400
Date: Mon, 12 Apr 2010 21:00:44 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: John Stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Petr =?UTF-8?Q?Tit=C4=9Bra?= <P.Titera@century.cz>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] time: remove xtime_cache (take 2)
Message-Id: <20100412210044.2ebbc058.akpm@linux-foundation.org>
In-Reply-To: <1270589451-30773-1-git-send-email-johnstul@us.ibm.com>
References: <1270589451-30773-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  6 Apr 2010 14:30:51 -0700 John Stultz <johnstul@us.ibm.com> wrote:

> Thomas: Mind queueing this up for 2.6.35?
> 
> With the earlier logarithmic time accumulation patch, xtime will now
> always be within one "tick" of the current time, instead of possibly
> half a second off.
> 
> This removes the need for the xtime_cache value, which always stored the
> time at the last interrupt, so this patch cleans that up removing the
> xtime_cache related code.
> 
> This patch also addresses an issue with an earlier version of this change,
> where xtime_cache was normalizing xtime, which could in some cases be
> not valid (ie: tv_nsec == NSEC_PER_SEC). This is fixed by handling
> the edge case in update_wall_time().
> 
> ...
>
> --- a/kernel/time.c
> +++ b/kernel/time.c
> @@ -135,7 +135,6 @@ static inline void warp_clock(void)
>  	write_seqlock_irq(&xtime_lock);
>  	wall_to_monotonic.tv_sec -= sys_tz.tz_minuteswest * 60;
>  	xtime.tv_sec += sys_tz.tz_minuteswest * 60;
> -	update_xtime_cache(0);
>  	write_sequnlock_irq(&xtime_lock);
>  	clock_was_set();
>  }

This conflicts with your time-clean-up-warp_clock.patch, below.

Shrug, I simply ignored the rejected hunk.



From: John Stultz <johnstul@us.ibm.com>

warp_clock() currently accesses timekeeping internal state directly, which
is unnecessary.  Convert it to use the proper timekeeping interfaces.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN kernel/time.c~time-clean-up-warp_clock kernel/time.c
--- a/kernel/time.c~time-clean-up-warp_clock
+++ a/kernel/time.c
@@ -132,12 +132,11 @@ SYSCALL_DEFINE2(gettimeofday, struct tim
  */
 static inline void warp_clock(void)
 {
-	write_seqlock_irq(&xtime_lock);
-	wall_to_monotonic.tv_sec -= sys_tz.tz_minuteswest * 60;
-	xtime.tv_sec += sys_tz.tz_minuteswest * 60;
-	update_xtime_cache(0);
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
+	struct timespec delta, adjust;
+	delta.tv_sec = sys_tz.tz_minuteswest * 60;
+	delta.tv_nsec = 0;
+	adjust = timespec_add_safe(current_kernel_time(), delta);
+	do_settimeofday(&adjust);
 }
 
 /*
_

