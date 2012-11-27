Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab2K0WDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 17:03:45 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34650 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab2K0WDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 17:03:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@vger.kernel.org
Cc: Fabio Baltieri <fabio.baltieri@linaro.org>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: ondemand: update sampling rate only on right CPUs
Date: Tue, 27 Nov 2012 23:08:27 +0100
Message-ID: <38705460.ie2PzG104T@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1353953412-20667-1-git-send-email-fabio.baltieri@linaro.org>
References: <1353953412-20667-1-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 26, 2012 07:10:12 PM Fabio Baltieri wrote:
> Fix cpufreq_gov_ondemand to skip CPU where another governor is used.
> 
> The bug present itself as NULL pointer access on the mutex_lock() call,
> an can be reproduced on an SMP machine by setting the default governor
> to anything other than ondemand, setting a single CPU's governor to
> ondemand, then changing the sample rate by writing on:
> 
> > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
> 
> Backtrace:
> 
> Nov 26 17:36:54 balto kernel: [  839.585241] BUG: unable to handle kernel NULL pointer dereference at           (null)
> Nov 26 17:36:54 balto kernel: [  839.585311] IP: [<ffffffff8174e082>] __mutex_lock_slowpath+0xb2/0x170
> [snip]
> Nov 26 17:36:54 balto kernel: [  839.587005] Call Trace:
> Nov 26 17:36:54 balto kernel: [  839.587030]  [<ffffffff8174da82>] mutex_lock+0x22/0x40
> Nov 26 17:36:54 balto kernel: [  839.587067]  [<ffffffff81610b8f>] store_sampling_rate+0xbf/0x150
> Nov 26 17:36:54 balto kernel: [  839.587110]  [<ffffffff81031e9c>] ?  __do_page_fault+0x1cc/0x4c0
> Nov 26 17:36:54 balto kernel: [  839.587153]  [<ffffffff813309bf>] kobj_attr_store+0xf/0x20
> Nov 26 17:36:54 balto kernel: [  839.587192]  [<ffffffff811bb62d>] sysfs_write_file+0xcd/0x140
> Nov 26 17:36:54 balto kernel: [  839.587234]  [<ffffffff8114c12c>] vfs_write+0xac/0x180
> Nov 26 17:36:54 balto kernel: [  839.587271]  [<ffffffff8114c472>] sys_write+0x52/0xa0
> Nov 26 17:36:54 balto kernel: [  839.587306]  [<ffffffff810321ce>] ?  do_page_fault+0xe/0x10
> Nov 26 17:36:54 balto kernel: [  839.587345]  [<ffffffff81751202>] system_call_fastpath+0x16/0x1b
> 
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
> 
> Hi Rafael,
> 
> this is based on a clean linux-pm linux-next branch (i.e. not with my other
> patch-set applied), so expect a context conflict if both are applied.

I have applied this patch to my linux-next branch.

As for the other series, I'm in the process of reviewing it, but I rather
won't include it into my first pull request for v3.8.

Thanks,
Rafael


>  drivers/cpufreq/cpufreq_ondemand.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index cca3e9f..7731f7c 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -40,6 +40,10 @@
>  static struct dbs_data od_dbs_data;
>  static DEFINE_PER_CPU(struct od_cpu_dbs_info_s, od_cpu_dbs_info);
>  
> +#ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND
> +static struct cpufreq_governor cpufreq_gov_ondemand;
> +#endif
> +
>  static struct od_dbs_tuners od_tuners = {
>  	.up_threshold = DEF_FREQUENCY_UP_THRESHOLD,
>  	.sampling_down_factor = DEF_SAMPLING_DOWN_FACTOR,
> @@ -279,6 +283,10 @@ static void update_sampling_rate(unsigned int new_rate)
>  		policy = cpufreq_cpu_get(cpu);
>  		if (!policy)
>  			continue;
> +		if (policy->governor != &cpufreq_gov_ondemand) {
> +			cpufreq_cpu_put(policy);
> +			continue;
> +		}
>  		dbs_info = &per_cpu(od_cpu_dbs_info, policy->cpu);
>  		cpufreq_cpu_put(policy);
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
