Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab2FLXCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 19:02:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab2FLXCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 19:02:52 -0400
Date: Tue, 12 Jun 2012 20:02:18 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: peterz@infradead.org, mingo@elte.hu, avi@redhat.com,
        raghukt@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, jeremy@goop.org,
        vatsa@linux.vnet.ibm.com, hpa@zytor.com
Subject: Re: [PATCH v2 3/7] KVM: Add paravirt kvm_flush_tlb_others
Message-ID: <20120612230218.GD1973@amt.cnet>
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

Why not reintroduce the hypercall to flush TLBs? No waiting, no
entry/exit trickery.

This is half-way-there paravirt with all the downsides. Even though the
guest running information might be useful in other cases.

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


