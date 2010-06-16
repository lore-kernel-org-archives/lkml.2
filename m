Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab0FPAjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 20:39:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab0FPAjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 20:39:46 -0400
Date: Tue, 15 Jun 2010 21:39:13 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: avi@redhat.com, glommer@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/17] Fix a possible backwards warp of kvmclock
Message-ID: <20100616003913.GA16533@amt.cnet>
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
 <1276587259-32319-12-git-send-email-zamsden@redhat.com>
 <20100615234725.GC3395@amt.cnet>
 <4C1818FD.80603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1818FD.80603@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 02:21:17PM -1000, Zachary Amsden wrote:
> On 06/15/2010 01:47 PM, Marcelo Tosatti wrote:
> >On Mon, Jun 14, 2010 at 09:34:13PM -1000, Zachary Amsden wrote:
> >>Kernel time, which advances in discrete steps may progress much slower
> >>than TSC.  As a result, when kvmclock is adjusted to a new base, the
> >>apparent time to the guest, which runs at a much higher, nsec scaled
> >>rate based on the current TSC, may have already been observed to have
> >>a larger value (kernel_ns + scaled tsc) than the value to which we are
> >>setting it (kernel_ns + 0).
> >>
> >>We must instead compute the clock as potentially observed by the guest
> >>for kernel_ns to make sure it does not go backwards.
> >>
> >>Signed-off-by: Zachary Amsden<zamsden@redhat.com>
> >>---
> >>  arch/x86/include/asm/kvm_host.h |    4 ++
> >>  arch/x86/kvm/x86.c              |   79 +++++++++++++++++++++++++++++++++------
> >>  2 files changed, 71 insertions(+), 12 deletions(-)
> >>
> >>+	/*
> >>+	 * The protection we require is simple: we must not be preempted from
> >>+	 * the CPU between our read of the TSC khz and our read of the TSC.
> >>+	 * Interrupt protection is not strictly required, but it does result in
> >>+	 * greater accuracy for the TSC / kernel_ns measurement.
> >>+	 */
> >>+	local_irq_save(flags);
> >>+	this_tsc_khz = __get_cpu_var(cpu_tsc_khz);
> >>+	kvm_get_msr(v, MSR_IA32_TSC,&tsc_timestamp);
> >>+	ktime_get_ts(&ts);
> >>+	monotonic_to_bootbased(&ts);
> >>+	kernel_ns = timespec_to_ns(&ts);
> >>+	local_irq_restore(flags);
> >>+
> >>  	if (unlikely(this_tsc_khz == 0)) {
> >>  		kvm_request_guest_time_update(v);
> >>  		return 1;
> >>  	}
> >>
> >>+	/*
> >>+	 * Time as measured by the TSC may go backwards when resetting the base
> >>+	 * tsc_timestamp.  The reason for this is that the TSC resolution is
> >>+	 * higher than the resolution of the other clock scales.  Thus, many
> >>+	 * possible measurments of the TSC correspond to one measurement of any
> >>+	 * other clock, and so a spread of values is possible.  This is not a
> >>+	 * problem for the computation of the nanosecond clock; with TSC rates
> >>+	 * around 1GHZ, there can only be a few cycles which correspond to one
> >>+	 * nanosecond value, and any path through this code will inevitably
> >>+	 * take longer than that.  However, with the kernel_ns value itself,
> >>+	 * the precision may be much lower, down to HZ granularity.  If the
> >>+	 * first sampling of TSC against kernel_ns ends in the low part of the
> >>+	 * range, and the second in the high end of the range, we can get:
> >>+	 *
> >>+	 * (TSC - offset_low) * S + kns_old>  (TSC - offset_high) * S + kns_new
> >>+	 *
> >>+	 * As the sampling errors potentially range in the thousands of cycles,
> >>+	 * it is possible such a time value has already been observed by the
> >>+	 * guest.  To protect against this, we must compute the system time as
> >>+	 * observed by the guest and ensure the new system time is greater.
> >>+ 	 */
> >>+	max_kernel_ns = 0;
> >>+	if (vcpu->hv_clock.tsc_timestamp) {
> >>+		max_kernel_ns = vcpu->last_guest_tsc -
> >>+				vcpu->hv_clock.tsc_timestamp;
> >>+		max_kernel_ns = pvclock_scale_delta(max_kernel_ns,
> >>+				    vcpu->hv_clock.tsc_to_system_mul,
> >>+				    vcpu->hv_clock.tsc_shift);
> >>+		max_kernel_ns += vcpu->last_kernel_ns;
> >>+	}
> >>+
> >>  	if (unlikely(vcpu->hw_tsc_khz != this_tsc_khz)) {
> >>-		kvm_set_time_scale(this_tsc_khz,&vcpu->hv_clock);
> >>+		kvm_get_time_scale(NSEC_PER_SEC / 1000, this_tsc_khz,
> >>+				&vcpu->hv_clock.tsc_shift,
> >>+				&vcpu->hv_clock.tsc_to_system_mul);
> >>  		vcpu->hw_tsc_khz = this_tsc_khz;
> >>  	}
> >>
> >>-	/* Keep irq disabled to prevent changes to the clock */
> >>-	local_irq_save(flags);
> >>-	kvm_get_msr(v, MSR_IA32_TSC,&vcpu->hv_clock.tsc_timestamp);
> >>-	ktime_get_ts(&ts);
> >>-	monotonic_to_bootbased(&ts);
> >>-	local_irq_restore(flags);
> >>+	if (max_kernel_ns>  kernel_ns) {
> >>+		s64 overshoot = max_kernel_ns - kernel_ns;
> >>+		++v->stat.tsc_ahead;
> >>+		if (overshoot>  NSEC_PER_SEC / HZ) {
> >>+			++v->stat.tsc_overshoot;
> >>+			if (printk_ratelimit())
> >>+				pr_debug("ns overshoot: %lld\n", overshoot);
> >>+		}
> >>+		kernel_ns = max_kernel_ns;
> >>+	}
> >>
> >>  	/* With all the info we got, fill in the values */
> >>-
> >>-	vcpu->hv_clock.system_time = ts.tv_nsec +
> >>-				     (NSEC_PER_SEC * (u64)ts.tv_sec) + v->kvm->arch.kvmclock_offset;
> >>+	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
> >>+	vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
> >>+	vcpu->last_kernel_ns = kernel_ns;
> >>
> >>  	vcpu->hv_clock.flags = 0;
> >>
> >>@@ -4836,6 +4889,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >>  	if (hw_breakpoint_active())
> >>  		hw_breakpoint_restore();
> >>
> >>+	kvm_get_msr(vcpu, MSR_IA32_TSC,&vcpu->arch.last_guest_tsc);
> >>+
> >>  	atomic_set(&vcpu->guest_mode, 0);
> >>  	smp_wmb();
> >>  	local_irq_enable();
> >Is this still needed with the guest side global counter fix?
> 
> It's debatable.  Instrumentation showed this happen 100% of the time
> when measuring TSC in the compensation sequence.  When measuring TSC
> in the hot-path exit from hardware virt, before interrupts are
> enabled, the compensation rate drops to 0%.
> 
> That's with an HPET clocksource for kernel time.  Kernels with less
> accurate and more granular clocksources would have worse problems,
> of course.
> 
> If we're ever going to turn on the "kvmclock is reliable" bit,
> though, I think at least paying attention to the potential need for
> compensation is required - it technically is a backwards warp of
> time, and even if we spend so long getting out of and back into
> hardware virtualization that the guest can't notice it today, that
> might not be true on a faster processor.
> 
> Zach

What is worrying is that if this keeps happening the guest clock will
advance faster then it should. The solution you had before with "if
(kernel_ns <= last_ns) compensate()" was simpler and more resistant in
that respect, if i'm not missing anything.

