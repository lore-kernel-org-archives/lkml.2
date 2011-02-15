Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab1BOOlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 09:41:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab1BOOla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 09:41:30 -0500
Message-ID: <4D5A9091.6090506@redhat.com>
Date: Tue, 15 Feb 2011 16:41:21 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 4/6] KVM-GST: KVM Steal time registration
References: <1297448364-14051-1-git-send-email-glommer@redhat.com> <1297448364-14051-5-git-send-email-glommer@redhat.com>
In-Reply-To: <1297448364-14051-5-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2011 08:19 PM, Glauber Costa wrote:
> Register steal time within KVM. Everytime we sample the steal time
> information, we update a local variable that tells what was the
> last time read. We then account the difference.
>
>
>
> +static int kvm_register_steal_time(void)
> +{
> +	int cpu = smp_processor_id();
> +	int low, high, ret;
> +	struct kvm_steal_time *st =&per_cpu(steal_time, cpu);
> +
> +	if (!hypervisor_steal_time)
> +		return 0;

You're using hypervisor_steal_time to communicate the existence of the 
feature.  Yuck.

> +
> +	memset(st, 0, sizeof(*st));
> +
> +	low = (int)__pa(st) | 1;

Named constant.

> +	high = ((u64)__pa(st)>>  32);
> +	ret = wrmsr_safe(MSR_KVM_STEAL_TIME, low, high);

No need for wrmsr_safe() since you're checking the cpuid bit.  The other 
APIs are nicer (no need to break into two words).

> +	printk(KERN_INFO "kvm-stealtime: cpu %d, msr %x:%x\n",
> +		cpu, high, low);
> +	return ret;
> +}
> +
>   #ifdef CONFIG_SMP
>   static void __init kvm_smp_prepare_boot_cpu(void)
>   {
>   #ifdef CONFIG_KVM_CLOCK
>   	WARN_ON(kvm_register_clock("primary cpu clock"));
>   #endif
> +	WARN_ON(kvm_register_steal_time());
>   	kvm_guest_cpu_init();
>   	native_smp_prepare_boot_cpu();
>   }
>
>   static void __cpuinit kvm_guest_cpu_online(void *dummy)
>   {
> +	WARN_ON(kvm_register_steal_time());
>   	kvm_guest_cpu_init();
>   }
>
>   static void kvm_guest_cpu_offline(void *dummy)
>   {
>   	kvm_pv_disable_apf(NULL);
> +	wrmsr(MSR_KVM_STEAL_TIME, 0, 0);

This will trap if running on a hypervisor without this MSR.

>   	apf_task_wake_all();
>   }
>
> @@ -534,6 +557,23 @@ static void __init kvm_apf_trap_init(void)
>   	set_intr_gate(14,&async_page_fault);
>   }
>
> +static u64 kvm_account_steal_time(int cpu)
> +{
> +	u64 steal;
> +	struct kvm_steal_time *src;
> +	int version;
> +
> +	src =&per_cpu(steal_time, cpu);
> +	do {
> +		version = src->version;
> +		rmb();
> +		steal = src->steal;
> +		rmb();
> +	} while ((src->version&  1) || (version != src->version));

Check version & 1 instead of src->version & 1, slightly cheaper.

> +
> +	return steal;
> +}
> +
>
> index f98d3ea..dcb6a67 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -164,6 +164,7 @@ static void __cpuinit kvm_setup_secondary_clock(void)
>   static void kvm_crash_shutdown(struct pt_regs *regs)
>   {
>   	native_write_msr(msr_kvm_system_time, 0, 0);
> +	wrmsr(MSR_KVM_STEAL_TIME, 0, 0);
>   	native_machine_crash_shutdown(regs);
>   }

Make conditional.  Needed for the previous wrmsr as well.

>   #endif
> @@ -171,6 +172,7 @@ static void kvm_crash_shutdown(struct pt_regs *regs)
>   static void kvm_shutdown(void)
>   {
>   	native_write_msr(msr_kvm_system_time, 0, 0);
> +	wrmsr(MSR_KVM_STEAL_TIME, 0, 0);
>   	native_machine_shutdown();
>   }
>

Ditto.  Is it me, or is the code duplicated?

-- 
error compiling committee.c: too many arguments to function

