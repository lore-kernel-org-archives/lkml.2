Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab0IUSS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 14:18:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab0IUSS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 14:18:27 -0400
Date: Tue, 21 Sep 2010 15:18:00 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping fixes 4/4] TSC catchup mode
Message-ID: <20100921181800.GB22536@amt.cnet>
References: <1284856695-19438-1-git-send-email-zamsden@redhat.com>
 <1284856695-19438-2-git-send-email-zamsden@redhat.com>
 <1284856695-19438-3-git-send-email-zamsden@redhat.com>
 <1284856695-19438-4-git-send-email-zamsden@redhat.com>
 <20100920153820.GA3088@amt.cnet>
 <4C980642.5000901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C980642.5000901@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 03:11:30PM -1000, Zachary Amsden wrote:
> On 09/20/2010 05:38 AM, Marcelo Tosatti wrote:
> >On Sat, Sep 18, 2010 at 02:38:15PM -1000, Zachary Amsden wrote:
> >>Negate the effects of AN TYM spell while kvm thread is preempted by tracking
> >>conversion factor to the highest TSC rate and catching the TSC up when it has
> >>fallen behind the kernel view of time.  Note that once triggered, we don't
> >>turn off catchup mode.
> >>
> >>A slightly more clever version of this is possible, which only does catchup
> >>when TSC rate drops, and which specifically targets only CPUs with broken
> >>TSC, but since these all are considered unstable_tsc(), this patch covers
> >>all necessary cases.
> >>
> >>Signed-off-by: Zachary Amsden<zamsden@redhat.com>
> >>---
> >>  arch/x86/include/asm/kvm_host.h |    6 +++
> >>  arch/x86/kvm/x86.c              |   87 +++++++++++++++++++++++++++++---------
> >>  2 files changed, 72 insertions(+), 21 deletions(-)
> >>
> >>diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >>index 8c5779d..e209078 100644
> >>--- a/arch/x86/include/asm/kvm_host.h
> >>+++ b/arch/x86/include/asm/kvm_host.h
> >>@@ -384,6 +384,9 @@ struct kvm_vcpu_arch {
> >>  	u64 last_host_tsc;
> >>  	u64 last_guest_tsc;
> >>  	u64 last_kernel_ns;
> >>+	u64 last_tsc_nsec;
> >>+	u64 last_tsc_write;
> >>+	bool tsc_catchup;
> >>
> >>  	bool nmi_pending;
> >>  	bool nmi_injected;
> >>@@ -444,6 +447,9 @@ struct kvm_arch {
> >>  	u64 last_tsc_nsec;
> >>  	u64 last_tsc_offset;
> >>  	u64 last_tsc_write;
> >>+	u32 virtual_tsc_khz;
> >>+	u32 virtual_tsc_mult;
> >>+	s8 virtual_tsc_shift;
> >>
> >>  	struct kvm_xen_hvm_config xen_hvm_config;
> >>
> >>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >>index 09f468a..9152156 100644
> >>--- a/arch/x86/kvm/x86.c
> >>+++ b/arch/x86/kvm/x86.c
> >>@@ -962,6 +962,7 @@ static inline u64 get_kernel_ns(void)
> >>  }
> >>
> >>  static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
> >>+unsigned long max_tsc_khz;
> >>
> >>  static inline int kvm_tsc_changes_freq(void)
> >>  {
> >>@@ -985,6 +986,24 @@ static inline u64 nsec_to_cycles(u64 nsec)
> >>  	return ret;
> >>  }
> >>
> >>+static void kvm_arch_set_tsc_khz(struct kvm *kvm, u32 this_tsc_khz)
> >>+{
> >>+	/* Compute a scale to convert nanoseconds in TSC cycles */
> >>+	kvm_get_time_scale(this_tsc_khz, NSEC_PER_SEC / 1000,
> >>+			&kvm->arch.virtual_tsc_shift,
> >>+			&kvm->arch.virtual_tsc_mult);
> >>+	kvm->arch.virtual_tsc_khz = this_tsc_khz;
> >>+}
> >>+
> >>+static u64 compute_guest_tsc(struct kvm_vcpu *vcpu, s64 kernel_ns)
> >>+{
> >>+	u64 tsc = pvclock_scale_delta(kernel_ns-vcpu->arch.last_tsc_nsec,
> >>+				      vcpu->kvm->arch.virtual_tsc_mult,
> >>+				      vcpu->kvm->arch.virtual_tsc_shift);
> >>+	tsc += vcpu->arch.last_tsc_write;
> >>+	return tsc;
> >>+}
> >>+
> >>  void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
> >>  {
> >>  	struct kvm *kvm = vcpu->kvm;
> >>@@ -1029,6 +1048,8 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
> >>
> >>  	/* Reset of TSC must disable overshoot protection below */
> >>  	vcpu->arch.hv_clock.tsc_timestamp = 0;
> >>+	vcpu->arch.last_tsc_write = data;
> >>+	vcpu->arch.last_tsc_nsec = ns;
> >>  }
> >>  EXPORT_SYMBOL_GPL(kvm_write_tsc);
> >>
> >>@@ -1041,22 +1062,42 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
> >>  	s64 kernel_ns, max_kernel_ns;
> >>  	u64 tsc_timestamp;
> >>
> >>-	if ((!vcpu->time_page))
> >>-		return 0;
> >>-
> >>  	/* Keep irq disabled to prevent changes to the clock */
> >>  	local_irq_save(flags);
> >>  	kvm_get_msr(v, MSR_IA32_TSC,&tsc_timestamp);
> >>  	kernel_ns = get_kernel_ns();
> >>  	this_tsc_khz = __get_cpu_var(cpu_tsc_khz);
> >>-	local_irq_restore(flags);
> >>
> >>  	if (unlikely(this_tsc_khz == 0)) {
> >>+		local_irq_restore(flags);
> >>  		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
> >>  		return 1;
> >>  	}
> >>
> >>  	/*
> >>+	 * We may have to catch up the TSC to match elapsed wall clock
> >>+	 * time for two reasons, even if kvmclock is used.
> >>+	 *   1) CPU could have been running below the maximum TSC rate
> >kvmclock handles frequency changes?
> >
> >>+	 *   2) Broken TSC compensation resets the base at each VCPU
> >>+	 *      entry to avoid unknown leaps of TSC even when running
> >>+	 *      again on the same CPU.  This may cause apparent elapsed
> >>+	 *      time to disappear, and the guest to stand still or run
> >>+	 *	very slowly.
> >I don't get this. Please explain.
> 
> This compensation in arch_vcpu_load, for unstable TSC case, causes
> time while preempted to disappear from the TSC by adjusting the TSC
> back to match the last observed TSC.
> 
>         if (unlikely(vcpu->cpu != cpu) || check_tsc_unstable()) {
>                 /* Make sure TSC doesn't go backwards */
>                 s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :
>                                 native_read_tsc() -
> vcpu->arch.last_host_tsc;
>                 if (tsc_delta < 0)
>                         mark_tsc_unstable("KVM discovered backwards TSC");
>                 if (check_tsc_unstable())
>                         kvm_x86_ops->adjust_tsc_offset(vcpu,
> -tsc_delta); <<<<<
> 
> Note that this is the correct thing to do if there are cross-CPU
> deltas, when switching CPUs, or if the TSC becomes inherently
> unpredictable while preempted (CPU bugs, kernel resets TSC).
> 
> However, all the time that elapsed while not running disappears from
> the TSC (and thus even from kvmclock, without recalibration, as it
> is based off the TSC).  Since we've got to recalibrate the kvmclock
> anyways, we might as well catch the TSC up to the proper value.

Updating kvmclock's tsc_timestamp and system_time should be enough then,
to fix this particular issue?

The problem is you're sneaking in parts of trap mode (virtual_tsc_khz),
without dealing with the issues raised in the past iteration. The
interactions between catch and trap mode are not clear, migration is not
handled, etc.

> And if kvmclock is not in use, we must catch the tsc up to the proper value.
> 
> Zach
