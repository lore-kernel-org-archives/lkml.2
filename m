Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab2JORrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:47:41 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:47653 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269Ab2JORri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:47:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Sudeep.KarkadaNagesha@arm.com,
        Robin.Randhawa@arm.com, Arvind.Chauhan@arm.com
Subject: Re: [PATCH] cpufreq:core: Fix printing of governor and driver name
Date: Mon, 15 Oct 2012 19:51:18 +0200
Message-ID: <5507518.Gae5ZRnSWO@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <51be8f865e4c80f91ac8e41e54cbd5905382ddb7.1349844049.git.viresh.kumar@linaro.org>
References: <51be8f865e4c80f91ac8e41e54cbd5905382ddb7.1349844049.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 of October 2012 10:12:11 Viresh Kumar wrote:
> Arrays for governer and driver name are of size CPUFREQ_NAME_LEN or 16.
> i.e. 15 bytes for name and 1 for trailing '\0'.
> 
> When cpufreq driver print these names (for sysfs), it includes '\n' or ' ' in
> the fmt string and still passes length as CPUFREQ_NAME_LEN. If the driver or
> governor names are using all 15 fields allocated to them, then the trailing '\n'
> or ' ' will never be printed. And so commands like:
> 
> root@linaro-developer# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver
> 
> will print something like:
> 
> cpufreq_foodrvroot@linaro-developer#
> 
> Fix this by increasing print length by one character.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Thanks for the patch, I'll queue it up for v3.8.

Rafael


> ---
>  drivers/cpufreq/cpufreq.c | 6 +++---
>  include/linux/cpufreq.h   | 2 ++
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 021973b..db6e337 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -445,7 +445,7 @@ static ssize_t show_scaling_governor(struct cpufreq_policy *policy, char *buf)
>  	else if (policy->policy == CPUFREQ_POLICY_PERFORMANCE)
>  		return sprintf(buf, "performance\n");
>  	else if (policy->governor)
> -		return scnprintf(buf, CPUFREQ_NAME_LEN, "%s\n",
> +		return scnprintf(buf, CPUFREQ_NAME_PLEN, "%s\n",
>  				policy->governor->name);
>  	return -EINVAL;
>  }
> @@ -491,7 +491,7 @@ static ssize_t store_scaling_governor(struct cpufreq_policy *policy,
>   */
>  static ssize_t show_scaling_driver(struct cpufreq_policy *policy, char *buf)
>  {
> -	return scnprintf(buf, CPUFREQ_NAME_LEN, "%s\n", cpufreq_driver->name);
> +	return scnprintf(buf, CPUFREQ_NAME_PLEN, "%s\n", cpufreq_driver->name);
>  }
>  
>  /**
> @@ -512,7 +512,7 @@ static ssize_t show_scaling_available_governors(struct cpufreq_policy *policy,
>  		if (i >= (ssize_t) ((PAGE_SIZE / sizeof(char))
>  		    - (CPUFREQ_NAME_LEN + 2)))
>  			goto out;
> -		i += scnprintf(&buf[i], CPUFREQ_NAME_LEN, "%s ", t->name);
> +		i += scnprintf(&buf[i], CPUFREQ_NAME_PLEN, "%s ", t->name);
>  	}
>  out:
>  	i += sprintf(&buf[i], "\n");
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index b60f6ba..fc4b785 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -22,6 +22,8 @@
>  #include <asm/div64.h>
>  
>  #define CPUFREQ_NAME_LEN 16
> +/* Print length for names. Extra 1 space for accomodating '\n' in prints */
> +#define CPUFREQ_NAME_PLEN (CPUFREQ_NAME_LEN + 1)
>  
>  
>  /*********************************************************************
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
