Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761615Ab2DLAdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:33:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756443Ab2DLAdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 20:33:08 -0400
Date: Wed, 11 Apr 2012 21:29:09 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        X86 <x86@kernel.org>, Avi Kivity <avi@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alexander Graf <agraf@suse.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Gleb Natapov <gleb@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen <xen-devel@lists.xensource.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC V5 2/6] kvm hypervisor : Add a hypercall to KVM
 hypervisor to support pv-ticketlocks
Message-ID: <20120412002909.GD32051@amt.cnet>
References: <20120323080503.14568.43092.sendpatchset@codeblue>
 <20120323080701.14568.97779.sendpatchset@codeblue>
 <20120412000629.GA32051@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412000629.GA32051@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 09:06:29PM -0300, Marcelo Tosatti wrote:
> On Fri, Mar 23, 2012 at 01:37:04PM +0530, Raghavendra K T wrote:
> > From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > 
> > KVM_HC_KICK_CPU allows the calling vcpu to kick another vcpu out of halt state.
> >     
> > The presence of these hypercalls is indicated to guest via
> > KVM_FEATURE_PV_UNHALT/KVM_CAP_PV_UNHALT.
> > 
> > Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
> > Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> > ---
> > diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> > index 734c376..9234f13 100644
> > --- a/arch/x86/include/asm/kvm_para.h
> > +++ b/arch/x86/include/asm/kvm_para.h
> > @@ -16,12 +16,14 @@
> >  #define KVM_FEATURE_CLOCKSOURCE		0
> >  #define KVM_FEATURE_NOP_IO_DELAY	1
> >  #define KVM_FEATURE_MMU_OP		2
> > +
> >  /* This indicates that the new set of kvmclock msrs
> >   * are available. The use of 0x11 and 0x12 is deprecated
> >   */
> >  #define KVM_FEATURE_CLOCKSOURCE2        3
> >  #define KVM_FEATURE_ASYNC_PF		4
> >  #define KVM_FEATURE_STEAL_TIME		5
> > +#define KVM_FEATURE_PV_UNHALT		6
> >  
> >  /* The last 8 bits are used to indicate how to interpret the flags field
> >   * in pvclock structure. If no bits are set, all flags are ignored.
> > @@ -32,6 +34,7 @@
> >  #define MSR_KVM_SYSTEM_TIME 0x12
> >  
> >  #define KVM_MSR_ENABLED 1
> > +
> >  /* Custom MSRs falls in the range 0x4b564d00-0x4b564dff */
> >  #define MSR_KVM_WALL_CLOCK_NEW  0x4b564d00
> >  #define MSR_KVM_SYSTEM_TIME_NEW 0x4b564d01
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 89b02bf..61388b9 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -408,7 +408,8 @@ static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
> >  			     (1 << KVM_FEATURE_NOP_IO_DELAY) |
> >  			     (1 << KVM_FEATURE_CLOCKSOURCE2) |
> >  			     (1 << KVM_FEATURE_ASYNC_PF) |
> > -			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT);
> > +			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
> > +			     (1 << KVM_FEATURE_PV_UNHALT);
> >  
> >  		if (sched_info_on())
> >  			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 9cbfc06..bd5ef91 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -2079,6 +2079,7 @@ int kvm_dev_ioctl_check_extension(long ext)
> >  	case KVM_CAP_XSAVE:
> >  	case KVM_CAP_ASYNC_PF:
> >  	case KVM_CAP_GET_TSC_KHZ:
> > +	case KVM_CAP_PV_UNHALT:
> >  		r = 1;
> >  		break;
> >  	case KVM_CAP_COALESCED_MMIO:
> > @@ -4913,6 +4914,30 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
> >  	return 1;
> >  }
> >  
> > +/*
> > + * kvm_pv_kick_cpu_op:  Kick a vcpu.
> > + *
> > + * @apicid - apicid of vcpu to be kicked.
> > + */
> > +static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
> > +{
> > +	struct kvm_vcpu *vcpu = NULL;
> > +	int i;
> > +
> > +	kvm_for_each_vcpu(i, vcpu, kvm) {
> > +		if (!kvm_apic_present(vcpu))
> > +			continue;
> > +
> > +		if (kvm_apic_match_dest(vcpu, 0, 0, apicid, 0))
> > +			break;
> > +	}
> > +	if (vcpu) {
> > +		vcpu->pv_unhalted = 1;
> > +		smp_mb();
> > +		kvm_vcpu_kick(vcpu);
> > +	}
> > +}
> > +
> >  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >  {
> >  	unsigned long nr, a0, a1, a2, a3, ret;
> > @@ -4946,6 +4971,10 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >  	case KVM_HC_VAPIC_POLL_IRQ:
> >  		ret = 0;
> >  		break;
> > +	case KVM_HC_KICK_CPU:
> > +		kvm_pv_kick_cpu_op(vcpu->kvm, a0);
> > +		ret = 0;
> > +		break;
> >  	default:
> >  		ret = -KVM_ENOSYS;
> >  		break;
> > @@ -6174,6 +6203,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
> >  		!vcpu->arch.apf.halted)
> >  		|| !list_empty_careful(&vcpu->async_pf.done)
> >  		|| vcpu->arch.mp_state == KVM_MP_STATE_SIPI_RECEIVED
> > +		|| vcpu->pv_unhalted
> >  		|| atomic_read(&vcpu->arch.nmi_queued) ||
> >  		(kvm_arch_interrupt_allowed(vcpu) &&
> >  		 kvm_cpu_has_interrupt(vcpu));
> > diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> > index 68e67e5..e822d96 100644
> > --- a/include/linux/kvm.h
> > +++ b/include/linux/kvm.h
> > @@ -558,6 +558,7 @@ struct kvm_ppc_pvinfo {
> >  #define KVM_CAP_PPC_PAPR 68
> >  #define KVM_CAP_S390_GMAP 71
> >  #define KVM_CAP_TSC_DEADLINE_TIMER 72
> > +#define KVM_CAP_PV_UNHALT 73
> >  
> >  #ifdef KVM_CAP_IRQ_ROUTING
> >  
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 900c763..433ae97 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -158,6 +158,7 @@ struct kvm_vcpu {
> >  #endif
> >  
> >  	struct kvm_vcpu_arch arch;
> > +	int pv_unhalted;
> >  };
> >  
> >  static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
> > diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
> > index ff476dd..38226e1 100644
> > --- a/include/linux/kvm_para.h
> > +++ b/include/linux/kvm_para.h
> > @@ -19,6 +19,7 @@
> >  #define KVM_HC_MMU_OP			2
> >  #define KVM_HC_FEATURES			3
> >  #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
> > +#define KVM_HC_KICK_CPU			5
> >  
> >  /*
> >   * hypercalls use architecture specific
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index a91f980..d3b98b1 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -226,6 +226,7 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
> >  	vcpu->kvm = kvm;
> >  	vcpu->vcpu_id = id;
> >  	vcpu->pid = NULL;
> > +	vcpu->pv_unhalted = 0;
> >  	init_waitqueue_head(&vcpu->wq);
> >  	kvm_async_pf_vcpu_init(vcpu);
> >  
> > @@ -1567,6 +1568,9 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> >  		prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
> >  
> >  		if (kvm_arch_vcpu_runnable(vcpu)) {
> > +			vcpu->pv_unhalted = 0;
> > +			/* preventing reordering should be enough here */
> > +			barrier();
> 
> Is it always OK to erase the notification, even in case an unrelated
> event such as interrupt was the source of wakeup?

Note i am only asking whether it is OK to lose a notification, not 
requesting a change to atomic test-and-clear.

It would be nice to have a comment explaining it.

> 
> It would be easier to verify that notifications are not lost with atomic
> test_and_clear(pv_unhalted).
> 
> Also x86 specific code should remain in arch/x86/kvm/
> 
