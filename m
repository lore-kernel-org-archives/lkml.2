Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab1BJLDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 06:03:18 -0500
Received: from compulab.co.il ([67.18.134.219]:40308 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab1BJLDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 06:03:17 -0500
Message-ID: <4D53C5F3.9050100@compulab.co.il>
Date: Thu, 10 Feb 2011 13:03:15 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.13) Gecko/20101211 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-arm-kernel@lists.infradead.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PXA] A question about PXA310 cpufreq for 806Mhz
References: <1297329771.21848.6.camel@mola>
In-Reply-To: <1297329771.21848.6.camel@mola>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/10/11 11:22, Axel Lin wrote:

> hi,
>
> I have a device equipped with 806Mhz PXA310 cpu.
> After bootup, the system shows it is running with 624Mhz.
>
> # cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq
> 624000
> # cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
> 624000
>
> # cat /proc/cpuinfo
> Processor       : XScale-V3 based processor rev 2 (v5l)
> BogoMIPS        : 623.00
> Features        : swp half thumb fastmult edsp iwmmxt 
> CPU implementer : 0x69
> CPU architecture: 5TE
> CPU variant     : 0x0
> CPU part        : 0x689
> CPU revision    : 2
>
> Hardware        : Getac PS236 Handheld Platform
> Revision        : 0000
> Serial          : 0000000000000000
>
> I fix it by below patch and it looks ok on my device.
> I'm not sure if this is a proper way to fix it, I appreciate to see your comments.
>
> It is strange that I cannot find 806Mhz PXA31x CPU 
> in the datasheet Section 6.1 PXA3XX Processor Differences.

I think the reason for this is that it is not true for all PXA31x SoCs.
PXA3xx Specification Update document states, that the 806MHz
operating points were added for PXA31x processors A2 stepping.
This means that it is not true at least for A1 and A0 stepping and
Also, there is nothing stated about the B0 and B1 stepping.

> But in Section 6.7, Table 55: PXA31x Core PLL, Turbo and Run Mode Output Frequencies,
> I do see 806Mhz support on the table.

But no details regarding stepping... Marvell's mess...

> diff --git a/arch/arm/mach-pxa/cpufreq-pxa3xx.c b/arch/arm/mach-pxa/cpufreq-pxa3xx.c
> index 88fbec0..abf7d7a 100644
> --- a/arch/arm/mach-pxa/cpufreq-pxa3xx.c
> +++ b/arch/arm/mach-pxa/cpufreq-pxa3xx.c
> @@ -210,15 +210,14 @@ static int pxa3xx_cpufreq_init(struct cpufreq_policy *policy)
>  
>  	/* set default policy and cpuinfo */
>  	policy->cpuinfo.min_freq = 104000;
> -	policy->cpuinfo.max_freq = (cpu_is_pxa320()) ? 806000 : 624000;
> +	policy->cpuinfo.max_freq = (cpu_is_pxa300()) ? 624000 : 806000;
>  	policy->cpuinfo.transition_latency = 1000; /* FIXME: 1 ms, assumed */
>  	policy->max = pxa3xx_get_clk_frequency_khz(0);
>  	policy->cur = policy->min = policy->max;
>  
> -	if (cpu_is_pxa300() || cpu_is_pxa310())
> +	if (cpu_is_pxa300())
>  		ret = setup_freqs_table(policy, ARRAY_AND_SIZE(pxa300_freqs));
> -
> -	if (cpu_is_pxa320())
> +	else if (cpu_is_pxa310() || cpu_is_pxa320())
>  		ret = setup_freqs_table(policy, ARRAY_AND_SIZE(pxa320_freqs));
>  
>  	if (ret) {
>

It is obviously, not a good patch in light of what I've said above.
May be we should build the pxa3xx_freqs table dynamically according
to cpu type and stepping? And set the policy->cpuinfo on the way?


-- 
Regards,
Igor.

