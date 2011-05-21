Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab1EUDd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 23:33:58 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36450 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab1EUDdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 23:33:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EkopogjnscQ3QchePfiKIQp172A4cIyp8iJyuIkpHS4X9QfY8DP7sQQYsRjNiFPYn/
         UQ/GGGjt3DWWIbTL1vm06/1hnlwQ8/IwLjT6PWAxCkBiE+Mk8khocEoI03/bcnEvIv6M
         6iZmvBTR3NYGbjjO9nmL/8obvKGPLcEwnxfv4=
Message-ID: <4DD7329F.80900@gmail.com>
Date: Fri, 20 May 2011 22:33:51 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: smp_twd: Reconfigure clockevents after cpufreq
 change
References: <1305851091-10096-1-git-send-email-ccross@android.com>
In-Reply-To: <1305851091-10096-1-git-send-email-ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2011 07:24 PM, Colin Cross wrote:
> The localtimer's clock changes with the cpu clock.  After a
> cpufreq transition, update the clockevent's frequency and
> reprogram the next clock event.
>
> Adds a clock called "smp_twd" that is used to determine the
> twd frequency, which can also be used at init time to
> avoid calibrating the twd frequency.
>
> Clock changes are based on Rob Herring's work.
>
> Change-Id: I413b5cd07fb2b79bc9fad8b4bf257332d1da7bcd
> Signed-off-by: Colin Cross<ccross@android.com>
> Cc: Thomas Gleixner<tglx@linutronix.de>
> Cc: Russell King<linux@arm.linux.org.uk>
> Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
> Cc: Rob Herring<robherring2@gmail.com>
> Tested-by: Linus Walleij<linus.walleij@linaro.org>

Acked-by: Rob Herring <rob.herring@calxeda.com>

> ---
>   arch/arm/kernel/smp_twd.c |   86 +++++++++++++++++++++++++++++++++++++++++---
>   1 files changed, 80 insertions(+), 6 deletions(-)
>
> This patch depends on Thomas Gleixner's patch to add clockevents_update_freq
>
> v2: Squash in changes from Linus Wallej, enable smp_twd clock during init
>
> diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
> index 60636f4..b5bd303 100644
> --- a/arch/arm/kernel/smp_twd.c
> +++ b/arch/arm/kernel/smp_twd.c
> @@ -10,13 +10,17 @@
>    */
>   #include<linux/init.h>
>   #include<linux/kernel.h>
> +#include<linux/clk.h>
> +#include<linux/cpufreq.h>
>   #include<linux/delay.h>
>   #include<linux/device.h>
> +#include<linux/err.h>
>   #include<linux/smp.h>
>   #include<linux/jiffies.h>
>   #include<linux/clockchips.h>
>   #include<linux/irq.h>
>   #include<linux/io.h>
> +#include<linux/percpu.h>
>
>   #include<asm/smp_twd.h>
>   #include<asm/hardware/gic.h>
> @@ -24,7 +28,9 @@
>   /* set up by the platform code */
>   void __iomem *twd_base;
>
> +static struct clk *twd_clk;
>   static unsigned long twd_timer_rate;
> +static DEFINE_PER_CPU(struct clock_event_device *, twd_ce);
>
>   static void twd_set_mode(enum clock_event_mode mode,
>   			struct clock_event_device *clk)
> @@ -80,6 +86,48 @@ int twd_timer_ack(void)
>   	return 0;
>   }
>
> +/*
> + * Updates clockevent frequency when the cpu frequency changes.
> + * Called on the cpu that is changing frequency with interrupts disabled.
> + */
> +static void twd_update_frequency(void *data)
> +{
> +	twd_timer_rate = clk_get_rate(twd_clk);
> +
> +	clockevents_update_freq(__get_cpu_var(twd_ce), twd_timer_rate);
> +}
> +
> +static int twd_cpufreq_transition(struct notifier_block *nb,
> +	unsigned long state, void *data)
> +{
> +	struct cpufreq_freqs *freqs = data;
> +
> +	/*
> +	 * The twd clock events must be reprogrammed to account for the new
> +	 * frequency.  The timer is local to a cpu, so cross-call to the
> +	 * changing cpu.
> +	 */
> +	if (state == CPUFREQ_POSTCHANGE || state == CPUFREQ_RESUMECHANGE)
> +		smp_call_function_single(freqs->cpu, twd_update_frequency,
> +			NULL, 1);
> +
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block twd_cpufreq_nb = {
> +	.notifier_call = twd_cpufreq_transition,
> +};
> +
> +static int twd_cpufreq_init(void)
> +{
> +	if (!IS_ERR_OR_NULL(twd_clk))
> +		return cpufreq_register_notifier(&twd_cpufreq_nb,
> +			CPUFREQ_TRANSITION_NOTIFIER);
> +
> +	return 0;
> +}
> +core_initcall(twd_cpufreq_init);
> +
>   static void __cpuinit twd_calibrate_rate(void)
>   {
>   	unsigned long count;
> @@ -119,12 +167,39 @@ static void __cpuinit twd_calibrate_rate(void)
>   	}
>   }
>
> +static struct clk *twd_get_clock(void)
> +{
> +	struct clk *clk;
> +	int err;
> +
> +	clk = clk_get_sys("smp_twd", NULL);
> +	if (IS_ERR(clk)) {
> +		pr_err("smp_twd: clock not found: %d\n", (int)PTR_ERR(clk));
> +		return clk;
> +	}
> +
> +	err = clk_enable(clk);
> +	if (err) {
> +		pr_err("smp_twd: clock failed to enable: %d\n", err);
> +		clk_put(clk);
> +		return ERR_PTR(err);
> +	}
> +
> +	return clk;
> +}
> +
>   /*
>    * Setup the local clock events for a CPU.
>    */
>   void __cpuinit twd_timer_setup(struct clock_event_device *clk)
>   {
> -	twd_calibrate_rate();
> +	if (!twd_clk)
> +		twd_clk = twd_get_clock();
> +
> +	if (!IS_ERR_OR_NULL(twd_clk))
> +		twd_timer_rate = clk_get_rate(twd_clk);
> +	else
> +		twd_calibrate_rate();
>
>   	clk->name = "local_timer";
>   	clk->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT |
> @@ -132,13 +207,12 @@ void __cpuinit twd_timer_setup(struct clock_event_device *clk)
>   	clk->rating = 350;
>   	clk->set_mode = twd_set_mode;
>   	clk->set_next_event = twd_set_next_event;
> -	clk->shift = 20;
> -	clk->mult = div_sc(twd_timer_rate, NSEC_PER_SEC, clk->shift);
> -	clk->max_delta_ns = clockevent_delta2ns(0xffffffff, clk);
> -	clk->min_delta_ns = clockevent_delta2ns(0xf, clk);
>
>   	/* Make sure our local interrupt controller has this enabled */
>   	gic_enable_ppi(clk->irq);
>
> -	clockevents_register_device(clk);
> +	__get_cpu_var(twd_ce) = clk;
> +
> +	clockevents_config_and_register(clk, twd_timer_rate,
> +					0xf, 0xffffffff);
>   }

