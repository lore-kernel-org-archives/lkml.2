Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303Ab2EWKJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 06:09:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:43304 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2EWKJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 06:09:45 -0400
Date: Wed, 23 May 2012 12:09:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gong <gong.chen@linux.intel.com>
cc: Tony Luck <tony.luck@intel.com>, bp@amd64.org, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] x86: auto poll/interrupt mode switch for CMC to stop
 CMC storm
In-Reply-To: <1337740341-26711-1-git-send-email-gong.chen@linux.intel.com>
Message-ID: <alpine.LFD.2.02.1205230859190.3231@ionos>
References: <1337740341-26711-1-git-send-email-gong.chen@linux.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Chen Gong wrote:

> This idea is inspired from IA64 implementation. It is like
> NAPI for network stack. When CMCI is too many to handle,
> this interrupt can be disabled and then poll mode will take
> over the events handle. When no more events happen in the
> system, CMC interrupt can be enabled automatically.

>  /*
>   * CPU/chipset specific EDAC code can register a notifier call here to print
>   * MCE errors in a human-readable form.
> @@ -582,6 +603,37 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
>  {
>  	struct mce m;
>  	int i;
> +	unsigned long flag;
> +
> +	spin_lock_irqsave(&cmc_poll_lock, flag);
> +	if (cmci_storm_detected == 0) {
> +		unsigned long now = jiffies;
> +		int *count = &__get_cpu_var(cmci_storm_warning);
> +		unsigned long *history = &__get_cpu_var(first_cmci_jiffie);
> +
> +		if (time_before_eq(now, *history + HZ))
> +			(*count)++;

So that means if you get more than 5 mces per second you switch to
polling mode and risk losing data. How was this number chosen?

> +		else {
> +			*count = 0;
> +			*history = now;
> +		}
> +
> +		if (*count >= CMC_STORM) {
> +			cmci_storm_detected = 1;

So this variable is global and does what? Signalling all the per cpu
poll timers to check for silence. How is that supposed to work? See
below.

> +			/* If we're being hit with CMC interrupts, we won't
> +			 * ever execute the schedule_work() below.  Need to
> +			 * disable CMC interrupts on this processor now.
> +			 */
> +			mce_disable_cmci(NULL);
> +			if (!work_pending(&cmc_disable_work))
> +				schedule_work(&cmc_disable_work);

What's the point of doing this work? Why can't we just do that on the
CPU which got hit by the MCE storm and leave the others alone? They
either detect it themself or are just not affected. 

> +			spin_unlock_irqrestore(&cmc_poll_lock, flag);
> +			printk(KERN_WARNING "WARNING: Switching to polling "\
> +				"CMC handler; error records may be lost\n");
>  
> @@ -1253,8 +1320,19 @@ static void mce_start_timer(unsigned long data)
>  	n = &__get_cpu_var(mce_next_interval);
>  	if (mce_notify_irq())
>  		*n = max(*n/2, HZ/100);
> -	else
> +	else {
>  		*n = min(*n*2, (int)round_jiffies_relative(check_interval*HZ));
> +		/* if no CMC event, switch out of polling mode */
> +		spin_lock_irqsave(&cmc_poll_lock, flags);
> +		if (cmci_storm_detected == 1) {
> +			printk(KERN_WARNING "Returning to interrupt driven "\
> +					"CMC handler\n");
> +			if (!work_pending(&cmc_enable_work))
> +				schedule_work(&cmc_enable_work);
> +			cmci_storm_detected = 0;
> +		}
> +		spin_unlock_irqrestore(&cmc_poll_lock, flags);
> +	}

This is really brilliant.

CPU0                                 CPU1
lock(poll_lock);
cmci_storm_detected = 1
mce_disable_cmci();
schedule_work(disable_work);
unlock(poll_lock);          
			             mce_timer runs
                                       lock(poll_lock);
                                       if (cmci_storm_detected) {
                                          schedule_work(cmc_enable_work);
                                       	  cmci_storm_detected = 0;
                                       }
				       unlock(poll_lock);
.....

disable_work()                       enable_work()
   on_each_cpu(mce_disable_cmci);       on_each_cpu(mce_enable_cmci);

The approach for this polling mode is horribly broken. You are mixing
global and per cpu states, how is that supposed to work reliably?

What's wrong with doing that strictly per cpu and avoid the whole
global state horror?

Thanks,

	tglx
