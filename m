Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab0EWNUM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 09:20:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59858 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468Ab0EWNUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 09:20:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Regression] Negative time on Acer Ferrari One with current -git
Date: Sun, 23 May 2010 15:21:02 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: John Stultz <johnstul@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <201005212343.25184.rjw@sisk.pl> <201005222320.01506.rjw@sisk.pl> <alpine.LFD.2.00.1005230815220.3368@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005230815220.3368@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005231521.02817.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 May 2010, Thomas Gleixner wrote:
> On Sat, 22 May 2010, Rafael J. Wysocki wrote:
> > After reverting commit 64ce4c2f above things work again.
> > 
> > To be precise, I reverted both commit 64ce4c2f and commit 6a867a3 (time: 
> > Remove xtime_cache), but since the symptoms continued to apprear after
> > reverting the latter alone, it's quite clear that commit 64ce4c2f breaks things
> > on this box.
> 
> I assume the cmos clock of this machine is not on UTC, right ?

Yup.

> Does the patch below fix the issue ?

Yes, it does, thanks!

> @John: Can you please check the other users of timespec_add_safe() in
> timekeeping as well ?
> 
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
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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

Rafael
