Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576Ab1FAV0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 17:26:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47808 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab1FAV0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 17:26:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dUdn3bdGi/hngOWom7EdPEdUMi/76L92JbltFaoJgkXbWWaOAqvfZC+bMXmxIiASWb
         d2Qk9lja9h7+sUJ98nEJJfVuxnjEx5pkfjrpihT7UN7V10URcM9LKyBL34iB52/KGvqF
         lfuA1NBhp1VnI2Im1t4tt6+ymSlezTPc84/No=
Message-ID: <4DE6AE7C.6040404@samsung.com>
Date: Wed, 01 Jun 2011 14:26:20 -0700
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>,
        linux-samsung-soc@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/10] arch/arm/mach-s5pv210/cpufreq.c: add missing clk_put
References: <1306948213-20767-5-git-send-email-julia@diku.dk>
In-Reply-To: <1306948213-20767-5-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/11 10:10, Julia Lawall wrote:
> From: Julia Lawall<julia@diku.dk>
>
> The successive calls to clk_get each call clk_put in the case of failure,
> but this is not done for subsequent error handling code.  The calls to
> clk_get are moved to the end of the function, and appropriate gotos are
> added.
>
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
>
> //<smpl>
> @r exists@
> expression e1,e2;
> statement S;
> @@
>
> e1 = clk_get@p1(...);
> ... when != e1 = e2
>      when != clk_put(e1)
>      when any
> if (...) { ... when != clk_put(e1)
>                 when != if (...) { ... clk_put(e1) ... }
> * return@p3 ...;
>   } else S
> //</smpl>
>
> Signed-off-by: Julia Lawall<julia@diku.dk>
>
> ---
>   arch/arm/mach-s5pv210/cpufreq.c |   25 +++++++++++++++++--------
>   1 file changed, 17 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm/mach-s5pv210/cpufreq.c b/arch/arm/mach-s5pv210/cpufreq.c
> index 22046e2..97a29e1 100644
> --- a/arch/arm/mach-s5pv210/cpufreq.c
> +++ b/arch/arm/mach-s5pv210/cpufreq.c
> @@ -414,6 +414,7 @@ static int check_mem_type(void __iomem *dmc_reg)
>   static int __init s5pv210_cpu_init(struct cpufreq_policy *policy)
>   {
>   	unsigned long mem_type;
> +	int ret;
>
>   	cpu_clk = clk_get(NULL, "armclk");
>   	if (IS_ERR(cpu_clk))
> @@ -421,19 +422,20 @@ static int __init s5pv210_cpu_init(struct cpufreq_policy *policy)
>
>   	dmc0_clk = clk_get(NULL, "sclk_dmc0");
>   	if (IS_ERR(dmc0_clk)) {
> -		clk_put(cpu_clk);
> -		return PTR_ERR(dmc0_clk);
> +		ret = PTR_ERR(dmc0_clk);
> +		goto out_dmc0;
>   	}
>
>   	dmc1_clk = clk_get(NULL, "hclk_msys");
>   	if (IS_ERR(dmc1_clk)) {
> -		clk_put(dmc0_clk);
> -		clk_put(cpu_clk);
> -		return PTR_ERR(dmc1_clk);
> +		ret = PTR_ERR(dmc1_clk);
> +		goto out_dmc1;
>   	}
>
> -	if (policy->cpu != 0)
> -		return -EINVAL;
> +	if (policy->cpu != 0) {
> +		ret = -EINVAL;
> +		goto out_dmc1;
> +	}
>
>   	/*
>   	 * check_mem_type : This driver only support LPDDR&  LPDDR2.
> @@ -443,7 +445,8 @@ static int __init s5pv210_cpu_init(struct cpufreq_policy *policy)
>
>   	if ((mem_type != LPDDR)&&  (mem_type != LPDDR2)) {
>   		printk(KERN_ERR "CPUFreq doesn't support this memory type\n");
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto out_dmc1;
>   	}
>
>   	/* Find current refresh counter and frequency each DMC */
> @@ -460,6 +463,12 @@ static int __init s5pv210_cpu_init(struct cpufreq_policy *policy)
>   	policy->cpuinfo.transition_latency = 40000;
>
>   	return cpufreq_frequency_table_cpuinfo(policy, s5pv210_freq_table);
> +
> +out_dmc1:
> +	clk_put(dmc0_clk);
> +out_dmc0:
> +	clk_put(cpu_clk);
> +	return ret;
>   }
>
>   static struct cpufreq_driver s5pv210_driver = {
>
>

Yeah, OK to me, will apply.
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.
