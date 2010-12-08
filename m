Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab0LHSoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 13:44:15 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:32057 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab0LHSoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 13:44:14 -0500
Message-ID: <4CFFD1C2.1080108@kernel.org>
Date: Wed, 08 Dec 2010 10:43:14 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Don Zickus <dzickus@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
Subject: Re: perf hw  in kexeced kernel broken in tip
References: <1291232292.32004.1969.camel@laptop>	 <20101201194644.GD2511@redhat.com> <1291232989.32004.1987.camel@laptop>	 <20101201195835.GE2511@redhat.com> <1291234036.32004.2008.camel@laptop>	 <m162vdp3l4.fsf@fess.ebiederm.org> <20101202052321.GH18100@redhat.com>	 <1291275270.4023.20.camel@twins> <20101202161502.GL18100@redhat.com>	 <1291764620.2032.1293.camel@laptop>  <20101208140103.GM21786@redhat.com>	 <1291818005.28378.38.camel@laptop> <1291820356.28378.83.camel@laptop>
In-Reply-To: <1291820356.28378.83.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2010 06:59 AM, Peter Zijlstra wrote:
> On Wed, 2010-12-08 at 15:20 +0100, Peter Zijlstra wrote:
> 
>>> I wonder if you should reverse these checks.  If the bios has the perf
>>> counter enabled, there might be a high chance that it fails the first
>>> check and never gets to the actually bios checks.
>>
>> Ah, good point. 
> 
> Something like so..
> 
> ---
> Subject: perf, x86: Detect broken BIOSes
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Wed Dec 08 15:56:23 CET 2010
> 
> Some BIOSes use PMU resources, this is a bug.
> 
> Try to detect this, warn about it, and further refuse to touch the
> PMU ourselves.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
> Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
> +++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
> @@ -375,15 +375,51 @@ static void release_pmc_hardware(void) {
>  static bool check_hw_exists(void)
>  {
>  	u64 val, val_new = 0;
> -	int ret = 0;
> +	int i, reg, ret = 0;
>  
> +	/*
> +	 * Check to see if the BIOS enabled any of the counters, if so
> +	 * complain and bail.
> +	 */
> +	for (i = 0; i < x86_pmu.num_counters; i++) {
> +		reg = x86_pmu.eventsel + i;
> +		ret = rdmsrl_safe(reg, &val);
> +		if (ret)
> +			goto msr_fail;
> +		if (val & ARCH_PERFMON_EVENTSEL_ENABLE)
> +			goto bios_fail;
> +	}
> +
> +	for (i = 0; i < x86_pmu.num_counters_fixed; i++) {
> +		reg = MSR_ARCH_PERFMON_FIXED_CTR_CTRL;
> +		ret = rdmsrl_safe(reg, &val);
> +		if (ret)
> +			goto msr_fail;
> +		if (val & (0x03 << i*4))
> +			goto bios_fail;
> +	}
> +
> +	/*
> +	 * Now write a value and read it back to see if it matches,
> +	 * this is needed to detect certain hardware emulators (qemu/kvm)
> +	 * that don't trap on the MSR access and always return 0s.
> +	 */
>  	val = 0xabcdUL;
> -	ret |= checking_wrmsrl(x86_pmu.perfctr, val);
> +	ret = checking_wrmsrl(x86_pmu.perfctr, val);
>  	ret |= rdmsrl_safe(x86_pmu.perfctr, &val_new);
>  	if (ret || val != val_new)
> -		return false;
> +		goto msr_fail;
>  
>  	return true;
> +
> +bios_fail:
> +	printk(KERN_CONT "Broken BIOS detected, software events only.\n");
> +	printk(KERN_ERR FW_BUG "invalid MSR: %x=%Lx\n", reg, val);
> +	return false;
> +
> +msr_fail:
> +	printk(KERN_CONT "Broken PMU hardware detected, software events only.\n");
> +	return false;
>  }

can you add sth force_... in command line to take over ownership of perf from BIOS or previous kernel ?

then still can use perf etc after we kexec from RHEL or SLES kernel to later kernel ( from 2.6.37)

Thanks

Yinghai

>  
>  static void reserve_ds_buffers(void);
> @@ -1378,10 +1414,8 @@ int __init init_hw_perf_events(void)
>  	pmu_check_apic();
>  
>  	/* sanity check that the hardware exists or is emulated */
> -	if (!check_hw_exists()) {
> -		pr_cont("Broken PMU hardware detected, software events only.\n");
> +	if (!check_hw_exists())
>  		return 0;
> -	}
>  
>  	pr_cont("%s PMU driver.\n", x86_pmu.name);
>  
> 

