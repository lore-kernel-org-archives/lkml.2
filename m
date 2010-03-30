Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab0C3WoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 18:44:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653Ab0C3WoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 18:44:09 -0400
Date: Tue, 30 Mar 2010 15:42:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <bp@amd64.org>
Cc: davej@redhat.com, trenn@suse.de, linux@dominikbrodowski.net,
       <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>,
       cpufreq@vger.kernel.org, <x86@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [-v2 PATCH 2/6] powernow-k8: Add core performance boost support
Message-Id: <20100330154229.dc8ebd24.akpm@linux-foundation.org>
In-Reply-To: <1269610800-23847-3-git-send-email-bp@amd64.org>
References: <1269610800-23847-1-git-send-email-bp@amd64.org>
	<1269610800-23847-3-git-send-email-bp@amd64.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Mar 2010 14:39:56 +0100
Borislav Petkov <bp@amd64.org> wrote:

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
> ...
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

What prevents cpu_online_mask from changing while this is happening?

> @@ -1422,15 +1490,34 @@ static int __cpuinit powernowk8_init(void)
>  			supported_cpus++;
>  	}
>  
> -	if (supported_cpus == num_online_cpus()) {
> -		printk(KERN_INFO PFX "Found %d %s "
> -			"processors (%d cpu cores) (" VERSION ")\n",
> -			num_online_nodes(),
> -			boot_cpu_data.x86_model_id, supported_cpus);
> -		return cpufreq_register_driver(&cpufreq_amd64_driver);
> +	if (supported_cpus != num_online_cpus())
> +		return -ENODEV;
> +
> +	printk(KERN_INFO PFX "Found %d %s (%d cpu cores) (" VERSION ")\n",
> +		num_online_nodes(), boot_cpu_data.x86_model_id, supported_cpus);
> +
> +	if (boot_cpu_has(X86_FEATURE_CPB)) {
> +
> +		cpb_capable = true;
> +
> +		msrs = msrs_alloc();
> +		if (!msrs) {
> +			printk(KERN_ERR "%s: Error allocating msrs!\n", __func__);
> +			return -ENOMEM;
> +		}
> +
> +		rdmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
> +
> +		for_each_cpu(cpu, cpu_online_mask) {
> +			struct msr *reg = per_cpu_ptr(msrs, cpu);
> +			cpb_enabled |= !(!!(reg->l & BIT(25)));
> +		}

Ditto.

I assume these changes get applied to new CPUs as they come online?

> ...
