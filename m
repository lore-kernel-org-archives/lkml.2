Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0GROpM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 10:45:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007Ab0GROpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 10:45:10 -0400
Message-ID: <4C431374.2020804@redhat.com>
Date: Sun, 18 Jul 2010 17:45:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: KVM <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/18] Make cpu_tsc_khz updates use local CPU
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com> <1278987938-23873-5-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278987938-23873-5-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 05:25 AM, Zachary Amsden wrote:
> This simplifies much of the init code; we can now simply always
> call tsc_khz_changed, optionally passing it a new value, or letting
> it figure out the existing value (while interrupts are disabled, and
> thus, by inference from the rule, not raceful against CPU hotplug or
> frequency updates, which will issue IPIs to the local CPU to perform
> this very same task).
>
>
> @@ -893,6 +893,15 @@ static void kvm_set_time_scale(uint32_t tsc_khz, struct pvclock_vcpu_time_info *
>
>   static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
>
> +static inline int kvm_tsc_changes_freq(void)
> +{
> +	int cpu = get_cpu();
> +	int ret = !boot_cpu_has(X86_FEATURE_CONSTANT_TSC)&&
> +		  cpufreq_quick_get(cpu) != 0;
> +	put_cpu();
> +	return ret;
> +}
> +
>   void guest_write_tsc(struct kvm_vcpu *vcpu, u64 data)
>   {
>   	struct kvm *kvm = vcpu->kvm;
> @@ -937,7 +946,7 @@ void guest_write_tsc(struct kvm_vcpu *vcpu, u64 data)
>   }
>   EXPORT_SYMBOL_GPL(guest_write_tsc);
>
> -static void kvm_write_guest_time(struct kvm_vcpu *v)
> +static int kvm_write_guest_time(struct kvm_vcpu *v)
>   {
>   	struct timespec ts;
>   	unsigned long flags;
> @@ -946,24 +955,27 @@ static void kvm_write_guest_time(struct kvm_vcpu *v)
>   	unsigned long this_tsc_khz;
>
>   	if ((!vcpu->time_page))
> -		return;
> -
> -	this_tsc_khz = get_cpu_var(cpu_tsc_khz);
> -	if (unlikely(vcpu->hv_clock_tsc_khz != this_tsc_khz)) {
> -		kvm_set_time_scale(this_tsc_khz,&vcpu->hv_clock);
> -		vcpu->hv_clock_tsc_khz = this_tsc_khz;
> -	}
> -	put_cpu_var(cpu_tsc_khz);
> +		return 0;
>
>   	/* Keep irq disabled to prevent changes to the clock */
>   	local_irq_save(flags);
>   	kvm_get_msr(v, MSR_IA32_TSC,&vcpu->hv_clock.tsc_timestamp);
>   	ktime_get_ts(&ts);
>   	monotonic_to_bootbased(&ts);
> +	this_tsc_khz = __get_cpu_var(cpu_tsc_khz);
>   	local_irq_restore(flags);
>
> -	/* With all the info we got, fill in the values */
> +	if (unlikely(this_tsc_khz == 0)) {
> +		kvm_make_request(KVM_REQ_KVMCLOCK_UPDATE, v);
> +		return 1;
> +	}
>    

Presumably, this will spin until cpufreq writes the frequency?

> @@ -4131,9 +4138,23 @@ int kvm_fast_pio_out(struct kvm_vcpu *vcpu, int size, unsigned short port)
>   }
>   EXPORT_SYMBOL_GPL(kvm_fast_pio_out);
>
> -static void bounce_off(void *info)
> +static void tsc_bad(void *info)
> +{
> +	__get_cpu_var(cpu_tsc_khz) = 0;
> +}
> +
> +static void tsc_khz_changed(void *data)
>   {
> -	/* nothing */
> +	struct cpufreq_freqs *freq = data;
> +	unsigned long khz = 0;
> +
> +	if (data)
> +		khz = freq->new;
> +	else if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
> +		khz = cpufreq_quick_get(raw_smp_processor_id());
> +	if (!khz)
> +		khz = tsc_khz;
> +	__get_cpu_var(cpu_tsc_khz) = khz;
>   }
>    

Do we really need to cache cpufreq_quick_get()?  If it's really quick, 
why not just use it everywhere instead of cacheing it?  Not a comment on 
this patch.

-- 
error compiling committee.c: too many arguments to function

