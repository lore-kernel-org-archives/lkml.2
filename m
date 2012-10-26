Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583Ab2JZLTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 07:19:33 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:39125 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575Ab2JZLTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 07:19:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, arvind.chauhan@arm.com
Subject: Re: [RFC] cpufreq: Make sure target freq is within limits
Date: Fri, 26 Oct 2012 13:23:28 +0200
Message-ID: <2173527.XVCDQtU61N@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.3-8-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <f0099171c1c4f3048d0f29b7deb42144f26ac5d5.1351146515.git.viresh.kumar@linaro.org>
References: <f0099171c1c4f3048d0f29b7deb42144f26ac5d5.1351146515.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 25, 2012 12:03:34 PM Viresh Kumar wrote:
> Hi Rafael,
> 
> __cpufreq_driver_target() must not pass target frequency beyond the limits of
> current policy.
> 
> Today most of cpufreq platform drivers are doing this check in their target
> routines. Why not move it to __cpufreq_driver_target().
> 
> I wanted to get your opinion on this before making changes in all driver files.
> That's why this is an RFC.

I'd prefer to apply the patch below before changing the drviers.

Thanks,
Rafael


> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index f552d5f..59264f1 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1470,12 +1470,19 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
>  			    unsigned int relation)
>  {
>  	int retval = -EINVAL;
> +	unsigned int old_target_freq = target_freq;
>  
>  	if (cpufreq_disabled())
>  		return -ENODEV;
>  
> -	pr_debug("target for CPU %u: %u kHz, relation %u\n", policy->cpu,
> -		target_freq, relation);
> +	/* Make sure that target_freq is within supported range */
> +	if (target_freq > policy->max)
> +		target_freq = policy->max;
> +	if (target_freq < policy->min)
> +		target_freq = policy->min;
> +
> +	pr_debug("target for CPU %u: %u kHz, relation %u, requested %u kHz\n",
> +			policy->cpu, target_freq, relation, old_target_freq);
>  	if (cpu_online(policy->cpu) && cpufreq_driver->target)
>  		retval = cpufreq_driver->target(policy, target_freq, relation);
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
