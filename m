Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab0FPIFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 04:05:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630Ab0FPIFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 04:05:51 -0400
Message-ID: <4C18872E.4030105@redhat.com>
Date: Wed, 16 Jun 2010 16:11:26 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: avi@redhat.com, mtosatti@redhat.com, glommer@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/17] Fix a possible backwards warp of kvmclock
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com> <1276587259-32319-12-git-send-email-zamsden@redhat.com>
In-Reply-To: <1276587259-32319-12-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Kernel time, which advances in discrete steps may progress much slower
> than TSC.  As a result, when kvmclock is adjusted to a new base, the
> apparent time to the guest, which runs at a much higher, nsec scaled
> rate based on the current TSC, may have already been observed to have
> a larger value (kernel_ns + scaled tsc) than the value to which we are
> setting it (kernel_ns + 0).
>   
This is one issue of kvmclock which tries to supply a clocksource whose
precision may even higher than host.
> We must instead compute the clock as potentially observed by the guest
> for kernel_ns to make sure it does not go backwards.
>
> Signed-off-by: Zachary Amsden <zamsden@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    4 ++
>  arch/x86/kvm/x86.c              |   79 +++++++++++++++++++++++++++++++++------
>  2 files changed, 71 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1afecd7..7ec2472 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -338,6 +338,8 @@ struct kvm_vcpu_arch {
>  	struct page *time_page;
>  	u64 last_host_tsc;
>  	u64 last_host_ns;
> +	u64 last_guest_tsc;
> +	u64 last_kernel_ns;
>  
>  	bool nmi_pending;
>  	bool nmi_injected;
> @@ -455,6 +457,8 @@ struct kvm_vcpu_stat {
>  	u32 hypercalls;
>  	u32 irq_injections;
>  	u32 nmi_injections;
> +	u32 tsc_overshoot;
> +	u32 tsc_ahead;
>  };
>  
>  struct kvm_x86_ops {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 52d7d34..703ea43 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -138,6 +138,8 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>  	{ "insn_emulation_fail", VCPU_STAT(insn_emulation_fail) },
>  	{ "irq_injections", VCPU_STAT(irq_injections) },
>  	{ "nmi_injections", VCPU_STAT(nmi_injections) },
> +	{ "tsc_overshoot", VCPU_STAT(tsc_overshoot) },
> +	{ "tsc_ahead", VCPU_STAT(tsc_ahead) },
>  	{ "mmu_shadow_zapped", VM_STAT(mmu_shadow_zapped) },
>  	{ "mmu_pte_write", VM_STAT(mmu_pte_write) },
>  	{ "mmu_pte_updated", VM_STAT(mmu_pte_updated) },
> @@ -927,33 +929,84 @@ static int kvm_recompute_guest_time(struct kvm_vcpu *v)
>  	struct kvm_vcpu_arch *vcpu = &v->arch;
>  	void *shared_kaddr;
>  	unsigned long this_tsc_khz;
> +	s64 kernel_ns, max_kernel_ns;
> +	u64 tsc_timestamp;
>  
>  	if ((!vcpu->time_page))
>  		return 0;
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
> +	kvm_get_msr(v, MSR_IA32_TSC, &tsc_timestamp);
> +	ktime_get_ts(&ts);
> +	monotonic_to_bootbased(&ts);
> +	kernel_ns = timespec_to_ns(&ts);
> +	local_irq_restore(flags);
> +
>  	if (unlikely(this_tsc_khz == 0)) {
>  		kvm_request_guest_time_update(v);
>  		return 1;
>  	}
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
> +	 * (TSC - offset_low) * S + kns_old > (TSC - offset_high) * S + kns_new
> +	 *
> +	 * As the sampling errors potentially range in the thousands of cycles,
> +	 * it is possible such a time value has already been observed by the
> +	 * guest.  To protect against this, we must compute the system time as
> +	 * observed by the guest and ensure the new system time is greater.
> + 	 */
> +	max_kernel_ns = 0;
> +	if (vcpu->hv_clock.tsc_timestamp) {
> +		max_kernel_ns = vcpu->last_guest_tsc -
>   
Since you do the comparison with kernel_ns, so what you need here is
tsc_timestamp which looks more like the 'last' tsc seen by guest.
> +				vcpu->hv_clock.tsc_timestamp;
> +		max_kernel_ns = pvclock_scale_delta(max_kernel_ns,
> +				    vcpu->hv_clock.tsc_to_system_mul,
> +				    vcpu->hv_clock.tsc_shift);
> +		max_kernel_ns += vcpu->last_kernel_ns;
> +	}
> +
>  	if (unlikely(vcpu->hw_tsc_khz != this_tsc_khz)) {
> -		kvm_set_time_scale(this_tsc_khz, &vcpu->hv_clock);
> +		kvm_get_time_scale(NSEC_PER_SEC / 1000, this_tsc_khz,
> +				   &vcpu->hv_clock.tsc_shift,
> +				   &vcpu->hv_clock.tsc_to_system_mul);
>  		vcpu->hw_tsc_khz = this_tsc_khz;
>  	}
>  
> -	/* Keep irq disabled to prevent changes to the clock */
> -	local_irq_save(flags);
> -	kvm_get_msr(v, MSR_IA32_TSC, &vcpu->hv_clock.tsc_timestamp);
> -	ktime_get_ts(&ts);
> -	monotonic_to_bootbased(&ts);
> -	local_irq_restore(flags);
> +	if (max_kernel_ns > kernel_ns) {
>   
Both max_kernel_ns and kernel_ns are not adjusted by kvmclock_offset, so
this comparing is not safe after migration.
> +		s64 overshoot = max_kernel_ns - kernel_ns;
> +		++v->stat.tsc_ahead;
> +		if (overshoot > NSEC_PER_SEC / HZ) {
> +			++v->stat.tsc_overshoot;
> +			if (printk_ratelimit())
> +				pr_debug("ns overshoot: %lld\n", overshoot);
> +		}
> +		kernel_ns = max_kernel_ns;
> +	}
>   
A tsc_behind or something like this would make the problem more clear,
and tsc_ahead should be zero when host using tsc as its clocksource.
>  
>  	/* With all the info we got, fill in the values */
> -
> -	vcpu->hv_clock.system_time = ts.tv_nsec +
> -				     (NSEC_PER_SEC * (u64)ts.tv_sec) + v->kvm->arch.kvmclock_offset;
> +	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
> +	vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
> +	vcpu->last_kernel_ns = kernel_ns;
>  
>  	vcpu->hv_clock.flags = 0;
>  
> @@ -4836,6 +4889,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	if (hw_breakpoint_active())
>  		hw_breakpoint_restore();
>  
> +	kvm_get_msr(vcpu, MSR_IA32_TSC, &vcpu->arch.last_guest_tsc);
>   
This could be dropped since it does not take the time of guest execution
into account.
> +
>  	atomic_set(&vcpu->guest_mode, 0);
>  	smp_wmb();
>  	local_irq_enable();
>   

