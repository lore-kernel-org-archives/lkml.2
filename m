Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab1FNV2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 17:28:31 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:43460 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab1FNV23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 17:28:29 -0400
Date: Tue, 14 Jun 2011 23:28:27 +0200
From: Tobias Diedrich <ranma+xen@tdiedrich.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-users@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: 3.0.0-rc2: Xen: powernow-k8: Kernel panic - not syncing:
 Attempted to kill init!
Message-ID: <20110614212827.GH7417@yumi.tdiedrich.de>
Mail-Followup-To: Tobias Diedrich <ranma+xen@tdiedrich.de>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	xen-users@lists.xensource.com, linux-kernel@vger.kernel.org
References: <20110613202622.GC20616@yumi.tdiedrich.de>
 <20110613215123.GA19117@dumpdata.com>
 <20110613235221.GA7417@yumi.tdiedrich.de>
 <20110614001333.GC7417@yumi.tdiedrich.de>
 <20110614013457.GB414@dumpdata.com>
 <20110614134634.GD7417@yumi.tdiedrich.de>
 <20110614175940.GA22859@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110614175940.GA22859@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> On Tue, Jun 14, 2011 at 03:46:34PM +0200, Tobias Diedrich wrote:
> > [    5.740826] powernow-k8: fid 0x2 (1000 MHz), vid 0x12
> > [    5.740941] powernow-k8: fid 0xa (1800 MHz), vid 0xa
> > [    5.741057] powernow-k8: fid 0xc (2000 MHz), vid 0x8
> > [    5.741170] powernow-k8: fid 0xe (2200 MHz), vid 0x8
> > [    5.741304] cpufreq_stats_create_table: policy->cur is 800000
> > [    5.741475] last_index set to -1 in cpufreq_stats_create_table!
> > 
> > I think policy->cur used here probably set in powernowk8_cpu_init.
> 
> Yup, and there is not much that can be done there. Lets try this patch

Thanks, this works fine for suppressing the crash.

> diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> index 2368e38..7e4a664 100644
> --- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> +++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> @@ -1079,8 +1079,10 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data,
>  	}
>  
>  	res = transition_fid_vid(data, fid, vid);
> -	freqs.new = find_khz_freq_from_fid(data->currfid);
> +	if (res)
> +		return res;
>  
> +	freqs.new = find_khz_freq_from_fid(data->currfid);
>  	for_each_cpu(i, data->available_cores) {
>  		freqs.cpu = i;
>  		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
> @@ -1112,6 +1114,9 @@ static int transition_frequency_pstate(struct powernow_k8_data *data,
>  	}
>  
>  	res = transition_pstate(data, pstate);
> +	if (res)
> +		return res;
> +
>  	freqs.new = find_khz_freq_from_pstate(data->powernow_table, pstate);
>  
>  	for_each_cpu(i, data->available_cores) {
> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
> index 4f1b8de..0ecb1e2 100644
> --- a/drivers/cpufreq/cpufreq_stats.c
> +++ b/drivers/cpufreq/cpufreq_stats.c
> @@ -298,11 +298,13 @@ static int cpufreq_stat_notifier_trans(struct notifier_block *nb,
>  	old_index = stat->last_index;
>  	new_index = freq_table_get_index(stat, freq->new);
>  
> -	cpufreq_stats_update(freq->cpu);
> -	if (old_index == new_index)
> +	/* We can't do stat->time_in_state[-1]= .. */
> +	if (old_index == -1 || new_index == -1)
>  		return 0;
>  
> -	if (old_index == -1 || new_index == -1)
> +	cpufreq_stats_update(freq->cpu);
> +
> +	if (old_index == new_index)
>  		return 0;
>  
>  	spin_lock(&cpufreq_stats_lock);

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
