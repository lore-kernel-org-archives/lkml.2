Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab0LWLAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 06:00:38 -0500
Received: from isilmar-3.linta.de ([188.40.101.200]:56091 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752612Ab0LWLAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 06:00:36 -0500
Date: Thu, 23 Dec 2010 11:57:30 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Youquan Song <youquan.song@intel.com>
Cc: davej@redhat.com, cpufreq@vger.kernel.org, venki@google.com,
        arjan@linux.intel.com, lenb@kernel.org, suresh.b.siddha@intel.com,
        kent.liu@intel.com, chaohong.guo@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH 6/6] cpufreq: Evaluate P1 before enter turbo mode
Message-ID: <20101223105730.GB18363@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Youquan Song <youquan.song@intel.com>, davej@redhat.com,
	cpufreq@vger.kernel.org, venki@google.com, arjan@linux.intel.com,
	lenb@kernel.org, suresh.b.siddha@intel.com, kent.liu@intel.com,
	chaohong.guo@intel.com, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	Youquan Song <youquan.song@linux.intel.com>
References: <1293085424-18212-1-git-send-email-youquan.song@intel.com>
 <1293085424-18212-2-git-send-email-youquan.song@intel.com>
 <1293085424-18212-3-git-send-email-youquan.song@intel.com>
 <1293085424-18212-4-git-send-email-youquan.song@intel.com>
 <1293085424-18212-5-git-send-email-youquan.song@intel.com>
 <1293085424-18212-6-git-send-email-youquan.song@intel.com>
 <1293085424-18212-7-git-send-email-youquan.song@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293085424-18212-7-git-send-email-youquan.song@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Thu, Dec 23, 2010 at 02:23:44PM +0800, Youquan Song wrote:
> diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
> index 0543221..d7dc010 100644
> --- a/drivers/cpufreq/freq_table.c
> +++ b/drivers/cpufreq/freq_table.c
> @@ -26,6 +26,7 @@ int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
>  {
>  	unsigned int min_freq = ~0;
>  	unsigned int max_freq = 0;
> +	unsigned int sec_max_freq = 0;
>  	unsigned int i;
>  
>  	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
> @@ -41,10 +42,18 @@ int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
>  			min_freq = freq;
>  		if (freq > max_freq)
>  			max_freq = freq;
> +		/* Find the second largest frequency */
> +		if ((freq < max_freq) && (freq > sec_max_freq))
> +			sec_max_freq = freq;
>  	}
>  
>  	policy->min = policy->cpuinfo.min_freq = min_freq;
>  	policy->max = policy->cpuinfo.max_freq = max_freq;
> +	/* Check CPU turbo mode enabled */
> +	if (max_freq - sec_max_freq == 1000)
> +		policy->sec_max = sec_max_freq;
> +	else
> +		policy->sec_max = max_freq;
>  
>  	if (policy->min == ~0)
>  		return -EINVAL;
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index c3e9de8..0087e56 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -92,6 +92,7 @@ struct cpufreq_policy {
>  
>  	unsigned int		min;    /* in kHz */
>  	unsigned int		max;    /* in kHz */
> +	unsigned int		sec_max; /* in kHz*/
>  	unsigned int		cur;    /* in kHz, only needed if cpufreq
>  					 * governors are used */
>          unsigned int		policy; /* see above */

NACK. First of all, why is it only a "turbo mode" if it's 1000 kHz
difference? Second, I don't like to put such an additional level into the
generic cpufreq code -- it just looks to be too chipset/CPU-specific. Third,
it isn't open to different turbo modes, e.g. if future CPUs offer a
"super-turbo", a "turbo" and a "semi-turbo" mode. Finally, if (certain) 
governors really really need to become aware of the individual
frequency steps -- something we avoided in the past -- we could extend
struct cpufreq_policy to optionally(!) contain a reference to the struct
cpufreq_frequency_table array. And add a "power_usage" parameter to that
struct, which could then be evaluated by the governor.

Best,
	Dominik
