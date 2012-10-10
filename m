Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab2JJMss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 08:48:48 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:17249
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754562Ab2JJMsq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:48:46 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh1432Izz1202h1d1ah1d2ahzz8275bh8275dhz2dh668h839h93fhd25hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
X-WSS-ID: 0MBOGX4-01-B0S-02
X-M-MSG: 
Date: Wed, 10 Oct 2012 14:48:39 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] cpufreq, powernow-k8: Fix usage of smp_processor_id() in
 preemptible code
Message-ID: <20121010124839.GA22448@alberich>
References: <20121009193844.GC7724@alberich>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20121009193844.GC7724@alberich>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

Please ignore my patch. It was insufficiently tested -- sorry for this.
(powernowk8_target_fn might sleep).

Have to take a closer look how to avoid below issue.


Regards,
Andreas


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
> 
> Fix this by using get_cpu/put_cpu in powernowk8_target().
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  drivers/cpufreq/powernow-k8.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
> index 1a40935..3d1df2a 100644
> --- a/drivers/cpufreq/powernow-k8.c
> +++ b/drivers/cpufreq/powernow-k8.c
> @@ -1220,17 +1220,20 @@ static long powernowk8_target_fn(void *arg)
>  static int powernowk8_target(struct cpufreq_policy *pol,
>  		unsigned targfreq, unsigned relation)
>  {
> +	int this_cpu, ret;
>  	struct powernowk8_target_arg pta = { .pol = pol, .targfreq = targfreq,
>  					     .relation = relation };
>  
> -	/*
> -	 * Must run on @pol->cpu.  cpufreq core is responsible for ensuring
> -	 * that we're bound to the current CPU and pol->cpu stays online.
> -	 */
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
>  }
>  
>  /* Driver entry point to verify the policy and range of frequencies */
> -- 
> 1.7.12
> 

-- 
Operating | Advanced Micro Devices GmbH
  System  | Einsteinring 24, 85609 Dornach/Aschheim, Germany
 Research | Geschäftsführer: Alberto Bozzo
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632, WEEE-Reg-Nr: DE 12919551

