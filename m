Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab0EWVVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 17:21:07 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:58142 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab0EWVVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 17:21:03 -0400
Subject: Re: [Regression] Negative time on Acer Ferrari One with current
 -git
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005230815220.3368@localhost.localdomain>
References: <201005212343.25184.rjw@sisk.pl>
	 <alpine.LFD.2.00.1005222032080.3368@localhost.localdomain>
	 <201005222255.27301.rjw@sisk.pl> <201005222320.01506.rjw@sisk.pl>
	 <alpine.LFD.2.00.1005230815220.3368@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 May 2010 14:20:58 -0700
Message-ID: <1274649658.1932.13.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-05-23 at 08:40 +0200, Thomas Gleixner wrote:
> On Sat, 22 May 2010, Rafael J. Wysocki wrote:
> > After reverting commit 64ce4c2f above things work again.
> > 
> > To be precise, I reverted both commit 64ce4c2f and commit 6a867a3 (time: 
> > Remove xtime_cache), but since the symptoms continued to apprear after
> > reverting the latter alone, it's quite clear that commit 64ce4c2f breaks things
> > on this box.
> 
> I assume the cmos clock of this machine is not on UTC, right ? Does
> the patch below fix the issue ?

Oof. Thanks for catching that. 


> @John: Can you please check the other users of timespec_add_safe() in
> timekeeping as well ?

So monotonic_to_bootbased() looks ok, as total_sleep_time should always
be positive. 

timekeeping_resume() also looks ok, since it we make sure the delta
between the resume time and the suspend time is positive.

That said, it may be worth open coding the:
	set_normalized_timespec(&ret, a.tv_sec + b.tv_sec, 
				a.tv_nsec + b.tv_nsec);

just so we don't have similar mix ups in the future, since
timespec_add_safe is just such a reassuring and comforting name :)



> Thanks,
> 
> 	tglx
> 
> ---------->
> Subject: timekeeping: Fix timezone update
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Sun, 23 May 2010 08:14:45 +0200
> 
> commit 64ce4c2f (time: Clean up warp_clock()) breaks the timezone
> update in a very subtle way. To avoid the direct access to timekeeping
> internals it adds the timezone delta to the current time with
> timespec_add_safe(). This works nicely when the timezone delta is > 0.
> If timezone delta is < 0 then the wrap check in timespec_add_safe()
> triggers and timespec_add_safe() returns TIME_MAX and screws up
> timekeeping completely. 
> 
> This is not surprising as the comment above timespec_add_safe() says:
>     It's assumed that both values are valid (>= 0)
> 
> The function was created to avoid overflow issues when adding the
> select() timeout to current time, where the above applies.
> 
> Add the timezone seconds adjustment directly.
> 
> Reported-by: Rafael J. Wysocki <rjw@sisk.pl>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>\

Acked-by: John Stultz <johnstul@us.ibm.com>

> ---
>  kernel/time.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/kernel/time.c
> ===================================================================
> --- linux-2.6.orig/kernel/time.c
> +++ linux-2.6/kernel/time.c
> @@ -132,10 +132,10 @@ SYSCALL_DEFINE2(gettimeofday, struct tim
>   */
>  static inline void warp_clock(void)
>  {
> -	struct timespec delta, adjust;
> -	delta.tv_sec = sys_tz.tz_minuteswest * 60;
> -	delta.tv_nsec = 0;
> -	adjust = timespec_add_safe(current_kernel_time(), delta);
> +	struct timespec adjust;
> +
> +	adjust = current_kernel_time();
> +	adjust.tv_sec += sys_tz.tz_minuteswest * 60;
>  	do_settimeofday(&adjust);
>  }
> 


