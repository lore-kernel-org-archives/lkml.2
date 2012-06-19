Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab2FSGMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 02:12:41 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:35164 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab2FSGMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 02:12:40 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: peterz@infradead.org, mingo@elte.hu, avi@redhat.com,
        raghukt@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, jeremy@goop.org,
        vatsa@linux.vnet.ibm.com, hpa@zytor.com
Subject: Re: [PATCH v2 3/7] KVM: Add paravirt kvm_flush_tlb_others
In-Reply-To: <20120612230218.GD1973@amt.cnet>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com> <20120604050629.4560.85284.stgit@abhimanyu.in.ibm.com> <20120612230218.GD1973@amt.cnet>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Tue, 19 Jun 2012 11:41:54 +0530
Message-ID: <87a9zzsudx.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12061820-0260-0000-0000-0000015CF76B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcelo,

Thanks for the review.

On Tue, 12 Jun 2012 20:02:18 -0300, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> On Mon, Jun 04, 2012 at 10:37:24AM +0530, Nikunj A. Dadhania wrote:
> > flush_tlb_others_ipi depends on lot of statics in tlb.c.  Replicated
> > the flush_tlb_others_ipi as kvm_flush_tlb_others to further adapt to
> > paravirtualization.
> > 
> > Use the vcpu state information inside the kvm_flush_tlb_others to
> > avoid sending ipi to pre-empted vcpus.
> > 
> > * Do not send ipi's to offline vcpus and set flush_on_enter flag
> > * For online vcpus: Wait for them to clear the flag
> > 
> > The approach was discussed here: https://lkml.org/lkml/2012/2/20/157
> > 
> > Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
> 
> Why not reintroduce the hypercall to flush TLBs? 
Sure, I will get a version with this.

> No waiting, no entry/exit trickery.
> 
Are you also suggesting to get rid of vcpu-running information?
We would atleast need this to raise a flushTLB hypercall on the sleeping
vcpu.

> This is half-way-there paravirt with all the downsides. 
Some more details on what are the downsides would help us reach to a
better solution.

> Even though the guest running information might be useful in other
> cases.
> 
Yes, that was one of the things on the mind.

> > Pseudo Algo:
> > 
> >    Write()
> >    ======
> > 
> > 	   guest_exit()
> > 		   flush_on_enter[i]=0;
> > 		   running[i] = 0;
> > 
> > 	   guest_enter()
> > 		   running[i] = 1;
> > 		   smp_mb();
> > 		   if(flush_on_enter[i]) {
> > 			   tlb_flush()
> > 			   flush_on_enter[i]=0;
> > 		   }
> > 
> > 
> >    Read()
> >    ======
> > 
> > 	   GUEST                                                KVM-HV
> > 
> >    f->flushcpumask = cpumask - me;
> > 
> > again:
> >    for_each_cpu(i, f->flushmask) {
> > 
> > 	   if (!running[i]) {
> > 						   case 1:
> > 
> > 						   running[n]=1
> > 
> > 						   (cpuN does not see
> > 						   flush_on_enter set,
> > 						   guest later finds it
> > 						   running and sends ipi,
> > 						   we are fine here, need
> > 						   to clear the flag on
> > 						   guest_exit)
> > 
> > 		  flush_on_enter[i] = 1;
> > 						   case2:
> > 
> > 						   running[n]=1
> > 						   (cpuN - will see flush
> > 						   on enter and an IPI as
> > 						   well - addressed in patch-4)
> > 
> > 		  if (!running[i])
> > 		     cpu_clear(f->flushmask);      All is well, vm_enter
> > 						   will do the fixup
> > 	   }
> > 						   case 3:
> > 						   running[n] = 0;
> > 
> > 						   (cpuN went to sleep,
> > 						   we saw it as awake,
> > 						   ipi sent, but wait
> > 						   will break without
> > 						   zero_mask and goto
> > 						   again will take care)
> > 
> >    }
> >    send_ipi(f->flushmask)
> > 
> >    wait_a_while_for_zero_mask();
> > 
> >    if (!zero_mask)
> > 	   goto again;
> > ---
> >  arch/x86/include/asm/kvm_para.h |    3 +-
> >  arch/x86/include/asm/tlbflush.h |    9 ++++++
> >  arch/x86/kernel/kvm.c           |    1 +
> >  arch/x86/kvm/x86.c              |   14 ++++++++-
> >  arch/x86/mm/tlb.c               |   61 +++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 86 insertions(+), 2 deletions(-)
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

