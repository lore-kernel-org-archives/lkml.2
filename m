Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab0FOIkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 04:40:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898Ab0FOIkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 04:40:16 -0400
Message-ID: <4C173C6E.90503@redhat.com>
Date: Tue, 15 Jun 2010 11:40:14 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: mtosatti@redhat.com, glommer@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/17] Fix a possible backwards warp of kvmclock
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com> <1276587259-32319-12-git-send-email-zamsden@redhat.com>
In-Reply-To: <1276587259-32319-12-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 10:34 AM, Zachary Amsden wrote:
> Kernel time, which advances in discrete steps may progress much slower
> than TSC.  As a result, when kvmclock is adjusted to a new base, the
> apparent time to the guest, which runs at a much higher, nsec scaled
> rate based on the current TSC, may have already been observed to have
> a larger value (kernel_ns + scaled tsc) than the value to which we are
> setting it (kernel_ns + 0).
>
> We must instead compute the clock as potentially observed by the guest
> for kernel_ns to make sure it does not go backwards.
>
> @@ -455,6 +457,8 @@ struct kvm_vcpu_stat {
>   	u32 hypercalls;
>   	u32 irq_injections;
>   	u32 nmi_injections;
> +	u32 tsc_overshoot;
> +	u32 tsc_ahead;
>   };
>    

Please don't add new stats, instead add tracepoints which can also be 
observed as stats.

But does this really merit exposing?  What would one do with this 
information?

>   	struct kvm_vcpu_arch *vcpu =&v->arch;
>   	void *shared_kaddr;
>   	unsigned long this_tsc_khz;
> +	s64 kernel_ns, max_kernel_ns;
> +	u64 tsc_timestamp;
>
>   	if ((!vcpu->time_page))
>   		return 0;
>
> -	this_tsc_khz = get_cpu_var(cpu_tsc_khz);
> -	put_cpu_var(cpu_tsc_khz);
> +	/*
> +	 * The protection we require is simple: we must not be preempted from
> +	 * the CPU between our read of the TSC khz and our read of the TSC.
> +	 * Interrupt protection is not strictly required, but it does result in
> +	 * greater accuracy for the TSC / kernel_ns measurement.
> +	 */
> +	local_irq_save(flags);
> +	this_tsc_khz = __get_cpu_var(cpu_tsc_khz);
> +	kvm_get_msr(v, MSR_IA32_TSC,&tsc_timestamp);
>    

That's a slow path, since it has to go through kvm_get_msr()'s if tree.  
Could use its own accessor.

But this isn't introduced by this patch, so it can be fixed by another.

> +	ktime_get_ts(&ts);
> +	monotonic_to_bootbased(&ts);
> +	kernel_ns = timespec_to_ns(&ts);
> +	local_irq_restore(flags);
> +
>   	if (unlikely(this_tsc_khz == 0)) {
>   		kvm_request_guest_time_update(v);
>   		return 1;
>   	}
>
> +	/*
> +	 * Time as measured by the TSC may go backwards when resetting the base
> +	 * tsc_timestamp.  The reason for this is that the TSC resolution is
> +	 * higher than the resolution of the other clock scales.  Thus, many
> +	 * possible measurments of the TSC correspond to one measurement of any
> +	 * other clock, and so a spread of values is possible.  This is not a
> +	 * problem for the computation of the nanosecond clock; with TSC rates
> +	 * around 1GHZ, there can only be a few cycles which correspond to one
> +	 * nanosecond value, and any path through this code will inevitably
> +	 * take longer than that.  However, with the kernel_ns value itself,
> +	 * the precision may be much lower, down to HZ granularity.  If the
> +	 * first sampling of TSC against kernel_ns ends in the low part of the
> +	 * range, and the second in the high end of the range, we can get:
> +	 *
> +	 * (TSC - offset_low) * S + kns_old>  (TSC - offset_high) * S + kns_new
> +	 *
> +	 * As the sampling errors potentially range in the thousands of cycles,
> +	 * it is possible such a time value has already been observed by the
> +	 * guest.  To protect against this, we must compute the system time as
> +	 * observed by the guest and ensure the new system time is greater.
> + 	 */
> +	max_kernel_ns = 0;
> +	if (vcpu->hv_clock.tsc_timestamp) {
> +		max_kernel_ns = vcpu->last_guest_tsc -
> +				vcpu->hv_clock.tsc_timestamp;
> +		max_kernel_ns = pvclock_scale_delta(max_kernel_ns,
> +				    vcpu->hv_clock.tsc_to_system_mul,
> +				    vcpu->hv_clock.tsc_shift);
> +		max_kernel_ns += vcpu->last_kernel_ns;
> +	}
> +
>   	if (unlikely(vcpu->hw_tsc_khz != this_tsc_khz)) {
> -		kvm_set_time_scale(this_tsc_khz,&vcpu->hv_clock);
> +		kvm_get_time_scale(NSEC_PER_SEC / 1000, this_tsc_khz,
> +				&vcpu->hv_clock.tsc_shift,
> +				&vcpu->hv_clock.tsc_to_system_mul);
>   		vcpu->hw_tsc_khz = this_tsc_khz;
>   	}
>
> -	/* Keep irq disabled to prevent changes to the clock */
> -	local_irq_save(flags);
> -	kvm_get_msr(v, MSR_IA32_TSC,&vcpu->hv_clock.tsc_timestamp);
> -	ktime_get_ts(&ts);
> -	monotonic_to_bootbased(&ts);
> -	local_irq_restore(flags);
> +	if (max_kernel_ns>  kernel_ns) {
> +		s64 overshoot = max_kernel_ns - kernel_ns;
> +		++v->stat.tsc_ahead;
> +		if (overshoot>  NSEC_PER_SEC / HZ) {
> +			++v->stat.tsc_overshoot;
> +			if (printk_ratelimit())
> +				pr_debug("ns overshoot: %lld\n", overshoot);
> +		}
>    

A tracepoint here would allow recording both the number of overshoots 
and the value of the overshoot.  But I don't think this is of much use 
day-to-day.

-- 
error compiling committee.c: too many arguments to function

