Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab2FNLAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:00:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36244 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225Ab2FNLAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:00:49 -0400
Date: Thu, 14 Jun 2012 13:00:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com,
        peterz@infradead.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/4] x86: Do microcode updates at CPU_STARTING, not
 CPU_ONLINE
Message-ID: <20120614110049.GA13629@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
	linux-kernel@vger.kernel.org, eranian@google.com,
	peterz@infradead.org, Andi Kleen <ak@linux.intel.com>
References: <1339618842-26636-1-git-send-email-andi@firstfloor.org>
 <1339618842-26636-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1339618842-26636-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 01:20:39PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Do microcode updates of resuming or newling plugged CPUs earlier
> in CPU_STARTING instead of later when ONLINE. This prevents races
> with parallel users who may need a microcode update to avoid some
> problem.
> 
> Since we cannot request the microcode from udev at this stage,
> try to grab the microcode from another CPU. This is also more efficient
> because it avoids redundant loads. In addition to that
> it avoids the need for separate paths for resume and CPU bootup.
> 
> This requires invalidating the microcodes on other CPUs on free.
> Each CPU does this in parallel, so it's not a big problem.
> 
> When there is no good microcode available the update is delayed
> until the update can be requested. In the normal cases it should
> be available.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/microcode_core.c  |   65 +++++++++++++++++++++++++------------
>  arch/x86/kernel/microcode_intel.c |   13 +++++++-
>  2 files changed, 56 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
> index fbdfc69..f947ef7 100644
> --- a/arch/x86/kernel/microcode_core.c
> +++ b/arch/x86/kernel/microcode_core.c
> @@ -358,20 +358,7 @@ static void microcode_fini_cpu(int cpu)
>  	uci->valid = 0;
>  }
>  
> -static enum ucode_state microcode_resume_cpu(int cpu)
> -{
> -	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
> -
> -	if (!uci->mc)
> -		return UCODE_NFOUND;
> -
> -	pr_debug("CPU%d updated upon resume\n", cpu);
> -	apply_microcode_on_target(cpu);
> -
> -	return UCODE_OK;
> -}
> -
> -static enum ucode_state microcode_init_cpu(int cpu)
> +static enum ucode_state microcode_init_cpu_late(int cpu)
>  {
>  	enum ucode_state ustate;
>  
> @@ -392,15 +379,44 @@ static enum ucode_state microcode_init_cpu(int cpu)
>  	return ustate;
>  }
>  
> -static enum ucode_state microcode_update_cpu(int cpu)
> +/* Grab ucode from another CPU */
> +static void clone_ucode_data(void)
> +{
> +	int cpu = smp_processor_id();
> +	int i;
> +
> +	for_each_online_cpu (i) {
> +		if (ucode_cpu_info[i].mc &&
> +			ucode_cpu_info[i].valid &&
> +			cpu_data(i).x86 == cpu_data(cpu).x86 &&
> +			cpu_data(i).x86_model == cpu_data(cpu).x86_model) {
> +			ucode_cpu_info[cpu].mc = ucode_cpu_info[i].mc;
> +			break;
> +		}
> +	}
> +}
> +
> +static enum ucode_state microcode_init_cpu_early(int cpu)
> +{
> +	clone_ucode_data();
> +	/* We can request later when the CPU is online */
> +	if (ucode_cpu_info[cpu].mc == NULL)
> +		return UCODE_ERROR;
> +	if (microcode_ops->collect_cpu_info(cpu, &ucode_cpu_info[cpu].cpu_sig))
> +		return UCODE_ERROR;
> +	if (microcode_ops->apply_microcode(smp_processor_id()))
> +		pr_warn("CPU%d microcode update failed\n", cpu);
> +	return UCODE_OK;
> +}

This is run only from the notifier and nothing is looking at its return
values. It should be returning void in such cases.

> +
> +static enum ucode_state microcode_update_cpu_late(int cpu)
>  {
>  	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
>  	enum ucode_state ustate;
>  
> -	if (uci->valid)
> -		ustate = microcode_resume_cpu(cpu);
> -	else
> -		ustate = microcode_init_cpu(cpu);
> +	/* Resume already done early */
> +	if (!uci->valid)
> +		ustate = microcode_init_cpu_late(cpu);
>  
>  	return ustate;
>  }
> @@ -418,7 +434,7 @@ static int mc_device_add(struct device *dev, struct subsys_interface *sif)
>  	if (err)
>  		return err;
>  
> -	if (microcode_init_cpu(cpu) == UCODE_ERROR)
> +	if (microcode_init_cpu_late(cpu) == UCODE_ERROR)
>  		return -EINVAL;
>  
>  	return err;
> @@ -468,9 +484,16 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
>  
>  	dev = get_cpu_device(cpu);
>  	switch (action) {
> +	case CPU_STARTING:
> +	case CPU_STARTING_FROZEN:
> +		microcode_init_cpu_early(cpu);
> +		break;
> +
>  	case CPU_ONLINE:
>  	case CPU_ONLINE_FROZEN:
> -		microcode_update_cpu(cpu);
> +		/* Retry again in case we couldn't request early */
> +		if (cpu_data(cpu).microcode < ucode_cpu_info[cpu].cpu_sig.rev)
> +			microcode_update_cpu_late(cpu);

This implies newer ucode versions are numerically higher than
what's currently present. And it is probably correct in the 99% of
the cases but it would be more correct IMHO to have "!=" there.
microcode_update_cpu_late takes care of checking the correct ucode
version anyway down the path.

-- 
Regards/Gruss,
Boris.
