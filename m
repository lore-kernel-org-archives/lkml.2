Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab2JJASy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 20:18:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38524 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab2JJASt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 20:18:49 -0400
Date: Wed, 10 Oct 2012 09:18:42 +0900
From: Tejun Heo <tj@kernel.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] cpufreq, powernow-k8: Fix usage of smp_processor_id()
 in preemptible code
Message-ID: <20121010001842.GA27553@localhost>
References: <20121009193844.GC7724@alberich>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009193844.GC7724@alberich>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Oct 09, 2012 at 09:38:44PM +0200, Andreas Herrmann wrote:
> 
> Commit 6889125b8b4e09c5e53e6ecab3433bed1ce198c9
> (cpufreq/powernow-k8: workqueue user shouldn't migrate the kworker to another CPU)
> causes powernow-k8 to trigger a preempt warning, e.g.:
> 
>   BUG: using smp_processor_id() in preemptible [00000000] code: cpufreq/3776
>   caller is powernowk8_target+0x20/0x49
>   Pid: 3776, comm: cpufreq Not tainted 3.6.0 #9
>   Call Trace:
>    [<ffffffff8125b447>] debug_smp_processor_id+0xc7/0xe0
>    [<ffffffff814877e7>] powernowk8_target+0x20/0x49
>    [<ffffffff81482b02>] __cpufreq_driver_target+0x82/0x8a
>    [<ffffffff81484fc6>] cpufreq_governor_performance+0x4e/0x54
>    [<ffffffff81482c50>] __cpufreq_governor+0x8c/0xc9
>    [<ffffffff81482e6f>] __cpufreq_set_policy+0x1a9/0x21e
>    [<ffffffff814839af>] store_scaling_governor+0x16f/0x19b
>    [<ffffffff81484f16>] ? cpufreq_update_policy+0x124/0x124
>    [<ffffffff8162b4a5>] ? _raw_spin_unlock_irqrestore+0x2c/0x49
>    [<ffffffff81483640>] store+0x60/0x88
>    [<ffffffff811708c0>] sysfs_write_file+0xf4/0x130
>    [<ffffffff8111243b>] vfs_write+0xb5/0x151
>    [<ffffffff811126e0>] sys_write+0x4a/0x71
>    [<ffffffff816319a9>] system_call_fastpath+0x16/0x1b
...
> -	/*
> -	 * Must run on @pol->cpu.  cpufreq core is responsible for ensuring
> -	 * that we're bound to the current CPU and pol->cpu stays online.
> -	 */

Urgh... so this wasn't true?  Well, the perils of the last minute
changes.

> -	if (smp_processor_id() == pol->cpu)
> -		return powernowk8_target_fn(&pta);
> -	else
> -		return work_on_cpu(pol->cpu, powernowk8_target_fn, &pta);
> +	this_cpu = get_cpu();
> +	if (this_cpu == pol->cpu) {
> +		ret = powernowk8_target_fn(&pta);
> +		put_cpu();
> +	} else {
> +		put_cpu();
> +		ret = work_on_cpu(pol->cpu, powernowk8_target_fn, &pta);
> +	}
> +
> +	return ret;

Looking at the code, yes, I think the above is correct.  Rafael, can
you please confirm?

Thanks.

-- 
tejun
