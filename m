Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509Ab2GCIMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 04:12:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755768Ab2GCIMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 04:12:34 -0400
Date: Tue, 3 Jul 2012 05:11:35 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: peterz@infradead.org, mingo@elte.hu, avi@redhat.com,
        raghukt@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, jeremy@goop.org,
        vatsa@linux.vnet.ibm.com, hpa@zytor.com
Subject: Re: [PATCH v2 3/7] KVM: Add paravirt kvm_flush_tlb_others
Message-ID: <20120703081135.GB12579@amt.cnet>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com>
 <20120604050629.4560.85284.stgit@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120604050629.4560.85284.stgit@abhimanyu.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 10:37:24AM +0530, Nikunj A. Dadhania wrote:
> flush_tlb_others_ipi depends on lot of statics in tlb.c.  Replicated
> the flush_tlb_others_ipi as kvm_flush_tlb_others to further adapt to
> paravirtualization.
> 
> Use the vcpu state information inside the kvm_flush_tlb_others to
> avoid sending ipi to pre-empted vcpus.
> 
> * Do not send ipi's to offline vcpus and set flush_on_enter flag
> * For online vcpus: Wait for them to clear the flag
> 
> The approach was discussed here: https://lkml.org/lkml/2012/2/20/157
> 
> Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
> 
> --
> Pseudo Algo:
> 
>    Write()
>    ======
> 
> 	   guest_exit()
> 		   flush_on_enter[i]=0;
> 		   running[i] = 0;
> 
> 	   guest_enter()
> 		   running[i] = 1;
> 		   smp_mb();
> 		   if(flush_on_enter[i]) {
> 			   tlb_flush()
> 			   flush_on_enter[i]=0;
> 		   }
> 
> 
>    Read()
>    ======
> 
> 	   GUEST                                                KVM-HV
> 
>    f->flushcpumask = cpumask - me;
> 
> again:
>    for_each_cpu(i, f->flushmask) {
> 
> 	   if (!running[i]) {
> 						   case 1:
> 
> 						   running[n]=1
> 
> 						   (cpuN does not see
> 						   flush_on_enter set,
> 						   guest later finds it
> 						   running and sends ipi,
> 						   we are fine here, need
> 						   to clear the flag on
> 						   guest_exit)
> 
> 		  flush_on_enter[i] = 1;
> 						   case2:
> 
> 						   running[n]=1
> 						   (cpuN - will see flush
> 						   on enter and an IPI as
> 						   well - addressed in patch-4)
> 
> 		  if (!running[i])
> 		     cpu_clear(f->flushmask);      All is well, vm_enter
> 						   will do the fixup
> 	   }
> 						   case 3:
> 						   running[n] = 0;
> 
> 						   (cpuN went to sleep,
> 						   we saw it as awake,
> 						   ipi sent, but wait
> 						   will break without
> 						   zero_mask and goto
> 						   again will take care)
> 
>    }
>    send_ipi(f->flushmask)
> 
>    wait_a_while_for_zero_mask();
> 
>    if (!zero_mask)
> 	   goto again;
> ---
>  arch/x86/include/asm/kvm_para.h |    3 +-
>  arch/x86/include/asm/tlbflush.h |    9 ++++++
>  arch/x86/kernel/kvm.c           |    1 +
>  arch/x86/kvm/x86.c              |   14 ++++++++-
>  arch/x86/mm/tlb.c               |   61 +++++++++++++++++++++++++++++++++++++++
>  5 files changed, 86 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index f57b5cc..684a285 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -55,7 +55,8 @@ struct kvm_steal_time {
>  
>  struct kvm_vcpu_state {
>  	__u32 state;
> -	__u32 pad[15];
> +	__u32 flush_on_enter;
> +	__u32 pad[14];
>  };
>  
>  #define KVM_VCPU_STATE_ALIGN_BITS 5
> diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
> index c0e108e..29470bd 100644
> --- a/arch/x86/include/asm/tlbflush.h
> +++ b/arch/x86/include/asm/tlbflush.h
> @@ -119,6 +119,12 @@ static inline void native_flush_tlb_others(const struct cpumask *cpumask,
>  {
>  }
>  
> +static inline void kvm_flush_tlb_others(const struct cpumask *cpumask,
> +					struct mm_struct *mm,
> +					unsigned long va)
> +{
> +}
> +
>  static inline void reset_lazy_tlbstate(void)
>  {
>  }
> @@ -145,6 +151,9 @@ static inline void flush_tlb_range(struct vm_area_struct *vma,
>  void native_flush_tlb_others(const struct cpumask *cpumask,
>  			     struct mm_struct *mm, unsigned long va);
>  
> +void kvm_flush_tlb_others(const struct cpumask *cpumask,
> +			  struct mm_struct *mm, unsigned long va);
> +
>  #define TLBSTATE_OK	1
>  #define TLBSTATE_LAZY	2
>  
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index bb686a6..66db54e 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -465,6 +465,7 @@ void __init kvm_guest_init(void)
>  	}
>  
>  	has_vcpu_state = 1;
> +	pv_mmu_ops.flush_tlb_others = kvm_flush_tlb_others;
>  
>  #ifdef CONFIG_SMP
>  	smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 264f172..4714a7b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c

Please split guest/host (arch/x86/kernel/kvm.c etc VS arch/x86/kvm/) 
patches.

Please document guest/host interface (Documentation/virtual/kvm/paravirt-tlb-flush.txt, add a pointer to it from msr.txt).


