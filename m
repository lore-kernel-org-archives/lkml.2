Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab0CWLRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 07:17:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:59531 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433Ab0CWLRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 07:17:19 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH 2/5] powernow-k8: Add core performance boost support
Date: Tue, 23 Mar 2010 12:17:16 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: akpm@linux-foundation.org, davej@redhat.com, cpufreq@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org
References: <1269283121-11894-1-git-send-email-bp@amd64.org> <1269283121-11894-3-git-send-email-bp@amd64.org>
In-Reply-To: <1269283121-11894-3-git-send-email-bp@amd64.org>
MIME-Version: 1.0
X-Length: 8737
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201003231217.16451.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 March 2010 19:38:38 Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Starting with F10h, revE, AMD processors add support for a dynamic
> core boosting feature called Core Performance Boost. When a specific
> condition is present, a subset of the cores on a system are boosted
> beyond their P0 operating frequency to speed up the performance of
> single-threaded applications.
> 
> In the normal case, the system comes out of reset with core boosting
> enabled. This patch adds a sysfs knob with which core boosting can be
> switched on or off for benchmarking purposes.
> 
> While at it, cleanup the driver init codepath and update copyrights.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  arch/x86/kernel/cpu/cpufreq/powernow-k8.c |  115 ++++++++++++++++++++++++++---
>  arch/x86/kernel/cpu/cpufreq/powernow-k8.h |    3 +-
>  2 files changed, 106 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> index d360b56..90fda2c 100644
> --- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> +++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> @@ -1,6 +1,5 @@
> -
>  /*
> - *   (c) 2003-2006 Advanced Micro Devices, Inc.
> + *   (c) 2003-2010 Advanced Micro Devices, Inc.
>   *  Your use of this code is subject to the terms and conditions of the
>   *  GNU general public license version 2. See "COPYING" or
>   *  http://www.gnu.org/licenses/gpl.html
> @@ -54,6 +53,10 @@ static DEFINE_PER_CPU(struct powernow_k8_data *, powernow_data);
>  
>  static int cpu_family = CPU_OPTERON;
>  
> +/* core performance boost */
> +static bool cpb_capable, cpb_disabled;
Whatabout using a cpufeature (arch/x86/include/asm/cpufeature.h)
instead of cpb_capable. Then people could see this feature in 
/proc/cpuinfo and other code parts could check for it easily if
needed later.
It could already be set in arch/x86/kernel/cpu/amd.c and
powernow-k8 could use cpu_has(cpu, X86_FEATURE_CPB);

Instead of cpb_disabled, I'd use cpb_enabled. Checking for
!cpb_disabled whether it's enabled, is ugly to read.

> +static struct msr __percpu *msrs;
> +
>  #ifndef CONFIG_SMP
>  static inline const struct cpumask *cpu_core_mask(int cpu)
>  {
> @@ -1393,8 +1396,69 @@ out:
>  	return khz;
>  }
>  
> +static void _cpb_toggle_msrs(bool t)
> +{
> +	int cpu;
> +
> +	rdmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
> +
> +	for_each_cpu(cpu, cpu_online_mask) {
> +		struct msr *reg = per_cpu_ptr(msrs, cpu);
> +		if (t)
> +			reg->l &= ~BIT(25);
> +		else
> +			reg->l |= BIT(25);
> +	}
> +	wrmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
> +}
> +
> +/*
> + * Switch on/off core performance boosting.
> + *
> + * 0=disable
> + * 1=enable.
> + */
> +static void cpb_toggle(bool t)
> +{
> +	if (!cpb_capable)
> +		return;
> +
> +	if (t && cpb_disabled) {
> +		cpb_disabled = false;
cpb_enabled = true
is better.
> +		_cpb_toggle_msrs(t);
> +		printk(KERN_INFO PFX "Core Boosting enabled.\n");
Always printk on every toggle?
That should not happen often and a user might want to get noticed if
an app does this behind his back -> should be fine w/ or w/o, just not 
sure whether it's intended.

...

     Thomas
