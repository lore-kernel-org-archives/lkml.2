Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab1BOQ6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:58:12 -0500
Received: from compulab.co.il ([67.18.134.219]:33669 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309Ab1BOQ6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:58:10 -0500
Message-ID: <4D5AB09C.9000106@compulab.co.il>
Date: Tue, 15 Feb 2011 18:58:04 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.13) Gecko/20101211 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: pxa: support 806MHz operating points for PXA31x
 processors A2 stepping
References: <1297786849.2596.13.camel@phoenix>
In-Reply-To: <1297786849.2596.13.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
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

On 02/15/11 18:20, Axel Lin wrote:

> PXA3xx Specification Update document states that the 806MHz
> operating points were added for PXA31x processors A2 stepping.
>
> This patch adds 806MHz operating points support for PXA31x A2 stepping.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>
> I cannot find any details for PXA31x stepping B1 and B2,
> thus I made this patch for PXA31x stepping A2 only.
>
> Axel
>
>  arch/arm/mach-pxa/cpufreq-pxa3xx.c |   23 +++++++++++++++++++----
>  1 files changed, 19 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/cpufreq-pxa3xx.c b/arch/arm/mach-pxa/cpufreq-pxa3xx.c
> index 88fbec0..f4f0c2e 100644
> --- a/arch/arm/mach-pxa/cpufreq-pxa3xx.c
> +++ b/arch/arm/mach-pxa/cpufreq-pxa3xx.c
> @@ -210,15 +210,30 @@ static int pxa3xx_cpufreq_init(struct cpufreq_policy *policy)
>  
>  	/* set default policy and cpuinfo */
>  	policy->cpuinfo.min_freq = 104000;
> -	policy->cpuinfo.max_freq = (cpu_is_pxa320()) ? 806000 : 624000;
> +
> +	if (cpu_is_pxa300())
> +		policy->cpuinfo.max_freq = 624000;
> +	else if (cpu_is_pxa310())
> +		policy->cpuinfo.max_freq = ((read_cpuid_id() & 0xf) == 0x2) ?
> +						806000 : 624000;
> +	else if (cpu_is_pxa320())
> +		policy->cpuinfo.max_freq = 806000;
> +
>  	policy->cpuinfo.transition_latency = 1000; /* FIXME: 1 ms, assumed */
>  	policy->max = pxa3xx_get_clk_frequency_khz(0);
>  	policy->cur = policy->min = policy->max;
>  
> -	if (cpu_is_pxa300() || cpu_is_pxa310())
> +	if (cpu_is_pxa300())
>  		ret = setup_freqs_table(policy, ARRAY_AND_SIZE(pxa300_freqs));
> -
> -	if (cpu_is_pxa320())
> +	else if (cpu_is_pxa310())
> +		/* PXA310 A2 STEPPING supports 806Mhz operating points */
> +		if ((read_cpuid_id() & 0xf) == 0x2)
> +			ret = setup_freqs_table(policy,
> +						ARRAY_AND_SIZE(pxa320_freqs));
> +		else
> +			ret = setup_freqs_table(policy,
> +						ARRAY_AND_SIZE(pxa300_freqs));
> +	else if (cpu_is_pxa320())
>  		ret = setup_freqs_table(policy, ARRAY_AND_SIZE(pxa320_freqs));
>  
>  	if (ret) {

Yeah, I've proposed something like that about half a year ago:
http://www.spinics.net/lists/arm-kernel/msg92899.html

Eric was not so happy about it back then, may be this time?
Eric, what do you think?

Also, there is one thing that is not related to this patch, but
if you have the hardware, you need to be concerned with,
is that the vcc_core voltage has to be 1.4V, otherwise your
hardware will be unstable.

-- 
Regards,
Igor.

