Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab0ESNLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 09:11:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41074 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab0ESNLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 09:11:14 -0400
Message-ID: <4BF3E367.5080906@ti.com>
Date: Wed, 19 May 2010 08:11:03 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Mike Chan <mike@android.com>
CC: "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
       "menage@google.com" <menage@google.com>,
       "balbir@in.ibm.com" <balbir@in.ibm.com>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 4/4] omap: cpu: Power tracking support for cgroup cpuacct
References: <1274232620-23003-1-git-send-email-mike@android.com> <1274232620-23003-5-git-send-email-mike@android.com>
In-Reply-To: <1274232620-23003-5-git-send-email-mike@android.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Chan had written, on 05/18/2010 08:30 PM, the following:
> Specify new power field in struct omap_opp, which is
> power exported in milliWatt.
> 
> power_usage function gives power consumed in milliWatt seconds
> 
> Signed-off-by: Mike Chan <mike@android.com>
> ---
>  arch/arm/plat-omap/cpu-omap.c             |   23 ++++++++++++++++++++++-
>  arch/arm/plat-omap/include/plat/omap-pm.h |    1 +
>  2 files changed, 23 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/cpu-omap.c b/arch/arm/plat-omap/cpu-omap.c
> index d27234d..1381539 100644
> --- a/arch/arm/plat-omap/cpu-omap.c
> +++ b/arch/arm/plat-omap/cpu-omap.c
> @@ -22,6 +22,7 @@
>  #include <linux/clk.h>
>  #include <linux/io.h>
>  #include <linux/cpuacct.h>
> +#include <linux/math64.h>
>  
>  #include <mach/hardware.h>
>  #include <plat/clock.h>
> @@ -218,10 +219,30 @@ static void omap_cpuacct_freq_show(void *cpuacct_data, struct cgroup_map_cb *cb)
>  	}
>  }
>  
> +
> +/* Returns power (in milliWatt seconds) for cgroup */
> +static u64 omap_cpuacct_power_usage(void *cpuacct_data)
> +{
> +	int i;
> +	u64 *cpuacct_freq = cpuacct_data;
> +	u64 totalpower = 0;
> +
> +	/* mpu_opps table starts at 1 */
> +	for (i = 0; freq_table[i].frequency != CPUFREQ_TABLE_END; i++)
> +		totalpower += cpuacct_freq[i] * mpu_opps[i + 1].power;
> +
> +	/* milliwatt seconds */
> +	totalpower = div64_u64(totalpower, NSEC_PER_SEC);
> +
> +	return totalpower;
> +}
> +
> +
>  static struct cpuacct_cpufreq_calls omap_cpuacct_cpufreq = {
>  	.init = omap_cpuacct_freq_init,
>  	.charge = omap_cpuacct_freq_charge,
> -	.show = omap_cpuacct_freq_show,
> +	.cpufreq_show = omap_cpuacct_freq_show,
> +	.power_usage = omap_cpuacct_power_usage,
>  };
>  
>  static int __init omap_cpuacct_init(void)
> diff --git a/arch/arm/plat-omap/include/plat/omap-pm.h b/arch/arm/plat-omap/include/plat/omap-pm.h
> index 3ee41d7..8f2db6f 100644
> --- a/arch/arm/plat-omap/include/plat/omap-pm.h
> +++ b/arch/arm/plat-omap/include/plat/omap-pm.h
> @@ -31,6 +31,7 @@ struct omap_opp {
>  	unsigned long rate;
>  	u8 opp_id;
>  	u16 min_vdd;
> +	unsigned long power; /* power consumed running at OPP in milliWatts */

this conflicts with the OPP layer implementation. this structure will 
disappear for good.

>  };
>  
>  extern struct omap_opp *mpu_opps;


-- 
Regards,
Nishanth Menon
