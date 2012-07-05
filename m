Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792Ab2GEO3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:29:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932423Ab2GEO3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:29:21 -0400
Message-ID: <4FF5A4B3.3020709@redhat.com>
Date: Thu, 05 Jul 2012 10:29:07 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux@openhuawei.org
Subject: Re: [PATCH 1/3] [RFC] hrtimer: Fix clock_was_set so it is safe to
 call from irq context
References: <1341382890-42324-1-git-send-email-johnstul@us.ibm.com> <1341382890-42324-2-git-send-email-johnstul@us.ibm.com>
In-Reply-To: <1341382890-42324-2-git-send-email-johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/04/2012 02:21 AM, John Stultz wrote:
> NOTE:This is a prerequisite patch that's required to
> address the widely observed leap-second related futex/hrtimer
> issues.
> 
> Currently clock_was_set() is unsafe to be called from irq
> context, as it calls on_each_cpu(). This causes problems when
> we need to adjust the time from update_wall_time().
> 
> To fix this, if clock_was_set is called when irqs are
> disabled, we schedule a timer to fire for immedately after
> we're out of interrupt context to then notify the hrtimer
> subsystem.
> 
> CC: Prarit Bhargava <prarit@redhat.com>
> CC: stable@vger.kernel.org
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: linux@openhuawei.org
> Reported-by: Jan Engelhardt <jengelh@inai.de>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> ---
>  kernel/hrtimer.c |   17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index ae34bf5..d730678 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -746,7 +746,7 @@ static inline void retrigger_next_event(void *arg) { }
>   * resolution timer interrupts. On UP we just disable interrupts and
>   * call the high resolution interrupt code.
>   */
> -void clock_was_set(void)
> +static void do_clock_was_set(unsigned long data)
>  {
>  #ifdef CONFIG_HIGH_RES_TIMERS
>  	/* Retrigger the CPU local events everywhere */
> @@ -755,6 +755,21 @@ void clock_was_set(void)
>  	timerfd_clock_was_set();
>  }
>  
> +static DEFINE_TIMER(clock_was_set_timer, do_clock_was_set , 0, 0);
> +
> +void clock_was_set(void)
> +{
> +	/*
> +	 * We can't call on_each_cpu() from irq context,
> +	 * so if irqs are disabled , schedule the clock_was_set
> +	 * via a timer_list timer for right after.
> +	 */
> +	if (irqs_disabled())

I was wondering about this in earlier versions of the patchset.  I thought it
was supposed to be irqs_disabled.  Thanks for changing this.

Acked-by: Prarit Bhargava <prarit@redhat.com>

P.
