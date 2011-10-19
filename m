Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab1JSSIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:08:13 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:7045
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759Ab1JSSIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:08:07 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzzz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LTBRPA-01-GPA-02
X-M-MSG: 
Date: Wed, 19 Oct 2011 20:07:41 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 4/5] oprofile: Remove exit function for timer mode
Message-ID: <20111019180741.GI24346@erda.amd.com>
References: <1318861624-715-1-git-send-email-robert.richter@amd.com>
 <1318861624-715-6-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1318861624-715-6-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See below for Some more comments after testing and reviewing the
code. Will send a new version with these comments incorporated.

-Robert

On 17.10.11 10:27:04, Robert Richter wrote:
> +static struct notifier_block __cpuinitdata nmi_timer_cpu_nb = {

The __cpuinitdata attribute causes a section mismatch, will fix it.

> +	.notifier_call = nmi_timer_cpu_notifier
> +};

> +static int nmi_timer_setup(void)
> +{
> +	int cpu, err;
> +
> +	/* clock cycles per tick: */
> +	nmi_timer_attr.sample_period = (u64)cpu_khz * TICK_NSEC / NSEC_PER_MSEC;

This is broken on 32 bit.

Will replace it with:

        /* clock cycles per tick: */
        period = (u64)cpu_khz * 1000;
        do_div(period, HZ);
        nmi_timer_attr.sample_period = period;

> +	pr_info("sample_period: %lld, cpu_khz: %d, nsec/tick: %ld\n",
> +		nmi_timer_attr.sample_period, cpu_khz, TICK_NSEC);

I will remove this pr_info().

> +
> +	get_online_cpus();
> +	err = register_cpu_notifier(&nmi_timer_cpu_nb);
> +	if (err)
> +		goto out;

> diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
> index f7cd069..af9cbea 100644
> --- a/drivers/oprofile/oprof.c
> +++ b/drivers/oprofile/oprof.c
> @@ -248,15 +248,21 @@ static int __init oprofile_init(void)
>  	/* always init architecture to setup backtrace support */
>  	err = oprofile_arch_init(&oprofile_ops);
>  
> -	timer_mode = err || timer;	/* fall back to timer mode on errors */
> +	timer_mode = err || timer;
>  	if (timer_mode) {
>  		if (!err)
>  			oprofile_arch_exit();
> -		err = oprofile_timer_init(&oprofile_ops);
> -		if (err)
> -			return err;
> +		/* no nmi timer mode if oprofile.timer is set: */
> +		if (!timer)
> +			err = op_nmi_timer_init(&oprofile_ops);

As nmi timer is initialized here, we can remove it in arch/x86. This
eases setup functions for x86.

> +		/* fall back to timer mode on errors: */
> +		if (err || timer)
> +			err = oprofile_timer_init(&oprofile_ops);
>  	}
>  
> +	if (err)
> +		return err;
> +
>  	err = oprofilefs_register();
>  	if (!err)
>  		return 0;

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

