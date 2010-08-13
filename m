Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab0HMVO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 17:14:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:49812 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab0HMVOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 17:14:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,365,1278313200"; 
   d="scan'208";a="827886406"
Subject: Re: [PATCH/RFC 2/5] [PATCH] sched: pass sched_domain_level to
 sched_power_savings_store
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <20100812172622.349333778@de.ibm.com>
References: <20100812172544.655648128@de.ibm.com>
	 <20100812172622.349333778@de.ibm.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 13 Aug 2010 14:13:40 -0700
Message-Id: <1281734020.2704.30.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-12 at 10:25 -0700, Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Pass the corresponding sched domain level to sched_power_savings_store instead
> of a yes/no flag which indicates if the level is SMT or MC.
> This is needed to easily extend the function so it can be used for a third
> level.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

> ---
> 
>  kernel/sched.c |   17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff -urpN linux-2.6/kernel/sched.c linux-2.6-patched/kernel/sched.c
> --- linux-2.6/kernel/sched.c	2010-08-11 13:47:22.000000000 +0200
> +++ linux-2.6-patched/kernel/sched.c	2010-08-11 13:47:22.000000000 +0200
> @@ -7380,7 +7380,8 @@ static void arch_reinit_sched_domains(vo
>  	put_online_cpus();
>  }
>  
> -static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
> +static ssize_t sched_power_savings_store(const char *buf, size_t count,
> +					 enum sched_domain_level sd_level)
>  {
>  	unsigned int level = 0;
>  
> @@ -7397,10 +7398,16 @@ static ssize_t sched_power_savings_store
>  	if (level >= MAX_POWERSAVINGS_BALANCE_LEVELS)
>  		return -EINVAL;
>  
> -	if (smt)
> +	switch (sd_level) {
> +	case SD_LV_SIBLING:
>  		sched_smt_power_savings = level;
> -	else
> +		break;
> +	case SD_LV_MC:
>  		sched_mc_power_savings = level;
> +		break;
> +	default:
> +		break;
> +	}
>  
>  	arch_reinit_sched_domains();
>  
> @@ -7418,7 +7425,7 @@ static ssize_t sched_mc_power_savings_st
>  					    struct sysdev_class_attribute *attr,
>  					    const char *buf, size_t count)
>  {
> -	return sched_power_savings_store(buf, count, 0);
> +	return sched_power_savings_store(buf, count, SD_LV_MC);
>  }
>  static SYSDEV_CLASS_ATTR(sched_mc_power_savings, 0644,
>  			 sched_mc_power_savings_show,
> @@ -7436,7 +7443,7 @@ static ssize_t sched_smt_power_savings_s
>  					     struct sysdev_class_attribute *attr,
>  					     const char *buf, size_t count)
>  {
> -	return sched_power_savings_store(buf, count, 1);
> +	return sched_power_savings_store(buf, count, SD_LV_SIBLING);
>  }
>  static SYSDEV_CLASS_ATTR(sched_smt_power_savings, 0644,
>  		   sched_smt_power_savings_show,
> 

