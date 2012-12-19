Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab2LSUN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:13:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab2LSUNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:13:53 -0500
Date: Wed, 19 Dec 2012 15:13:36 -0500
From: Don Zickus <dzickus@redhat.com>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Norbert Warmuth <nwarmuth@t-online.de>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RESEND][PATCH v3] watchdog: Fix disable/enable regression
Message-ID: <20121219201336.GK88797@redhat.com>
References: <87y5h1c70y.fsf@nemi.mork.no>
 <1355946691-7969-1-git-send-email-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1355946691-7969-1-git-send-email-bjorn@mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 08:51:31PM +0100, Bjørn Mork wrote:
> commit 8d451690 ("watchdog: Fix CPU hotplug regression") cause
> an oops or hard lockup when doing
> 
>  echo 0 > /proc/sys/kernel/nmi_watchdog
>  echo 1 > /proc/sys/kernel/nmi_watchdog
> 
> and the kernel is booted with nmi_watchdog=1 (default)
> 
> Running laptop-mode-tools and disconnecting/connecting AC power
> will cause this to trigger, making it a common failure scenario
> on laptops.
> 
> Instead of bailing out of watchdog_disable() when !watchdog_enabled
> we can initialize the hrtimer regardless of watchdog_enabled status.
> This makes it safe to call watchdog_disable() in the nmi_watchdog=0
> case, without the negative effect on the enabled => disabled =>
> enabled case.
> 
> All these tests pass with this patch:
> - nmi_watchdog=1
>   echo 0 > /proc/sys/kernel/nmi_watchdog
>   echo 1 > /proc/sys/kernel/nmi_watchdog
> 
> - nmi_watchdog=0
>   echo 0 > /sys/devices/system/cpu/cpu1/online
> 
> - nmi_watchdog=0
>   echo mem > /sys/power/state

What about the opposite cases?  
nmi_watchdog=1
echo 1 > /sys/devices/system/cpu/cpu1/online

Are we going to leak memory by re-initing hrtimer?  Or is that caught
somewhere?

Other than that, the patch seems reasonable to me.  Basically just forcing
the init of hrtimer so there is something to cancel on the disable side.
Then again, I don't fully understand the original problem.

Cheers,
Don

> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=51661
> 
> Cc: <stable@vger.kernel.org> # v3.7
> Cc: Norbert Warmuth <nwarmuth@t-online.de>
> Cc: Joseph Salisbury <joseph.salisbury@canonical.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> ---
> Hello Linus,
> 
> This post v3.7-rc8 regression kills any machine with laptop-mode-tools
> using default config, making it somewhat critical to get a fix into the
> v3.7.x stable series ASAP.  I was hoping for some response from Thomas
> or the reporters of the original bug, either verifying that my proposal
> is OK or providing a better fix.  But I believe that this cannot wait
> much longer.
> 
> Please apply.  Thanks,
> 
> Bjørn
> 
> 
> Patch history:
> 
> v3:
>   added Bugzilla reference and additional recipients
>   rebased on current mainline
> v2:
>   implemented an alternate workaround for the original problem.
> v1:
>   plain revert of 8d451690
> 
> 
>  kernel/watchdog.c |   11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 997c6a1..75a2ab3 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -344,6 +344,10 @@ static void watchdog_enable(unsigned int cpu)
>  {
>  	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
>  
> +	/* kick off the timer for the hardlockup detector */
> +	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +	hrtimer->function = watchdog_timer_fn;
> +
>  	if (!watchdog_enabled) {
>  		kthread_park(current);
>  		return;
> @@ -352,10 +356,6 @@ static void watchdog_enable(unsigned int cpu)
>  	/* Enable the perf event */
>  	watchdog_nmi_enable(cpu);
>  
> -	/* kick off the timer for the hardlockup detector */
> -	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> -	hrtimer->function = watchdog_timer_fn;
> -
>  	/* done here because hrtimer_start can only pin to smp_processor_id() */
>  	hrtimer_start(hrtimer, ns_to_ktime(sample_period),
>  		      HRTIMER_MODE_REL_PINNED);
> @@ -369,9 +369,6 @@ static void watchdog_disable(unsigned int cpu)
>  {
>  	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
>  
> -	if (!watchdog_enabled)
> -		return;
> -
>  	watchdog_set_prio(SCHED_NORMAL, 0);
>  	hrtimer_cancel(hrtimer);
>  	/* disable the perf event */
> -- 
> 1.7.10.4
> 
