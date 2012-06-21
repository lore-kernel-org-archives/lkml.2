Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759496Ab2FUM2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 08:28:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757323Ab2FUM2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 08:28:23 -0400
Date: Thu, 21 Jun 2012 09:26:33 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Cc: peterz@infradead.org, mingo@elte.hu, avi@redhat.com,
        raghukt@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, jeremy@goop.org,
        vatsa@linux.vnet.ibm.com, hpa@zytor.com
Subject: Re: [PATCH v2 3/7] KVM: Add paravirt kvm_flush_tlb_others
Message-ID: <20120621122633.GA3842@amt.cnet>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com>
 <20120604050629.4560.85284.stgit@abhimanyu.in.ibm.com>
 <20120612230218.GD1973@amt.cnet>
 <87a9zzsudx.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9zzsudx.fsf@abhimanyu.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 11:41:54AM +0530, Nikunj A Dadhania wrote:
> Hi Marcelo,
> 
> Thanks for the review.
> 
> On Tue, 12 Jun 2012 20:02:18 -0300, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > On Mon, Jun 04, 2012 at 10:37:24AM +0530, Nikunj A. Dadhania wrote:
> > > flush_tlb_others_ipi depends on lot of statics in tlb.c.  Replicated
> > > the flush_tlb_others_ipi as kvm_flush_tlb_others to further adapt to
> > > paravirtualization.
> > > 
> > > Use the vcpu state information inside the kvm_flush_tlb_others to
> > > avoid sending ipi to pre-empted vcpus.
> > > 
> > > * Do not send ipi's to offline vcpus and set flush_on_enter flag
> > > * For online vcpus: Wait for them to clear the flag
> > > 
> > > The approach was discussed here: https://lkml.org/lkml/2012/2/20/157
> > > 
> > > Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
> > 
> > Why not reintroduce the hypercall to flush TLBs? 
> Sure, I will get a version with this.
> 
> > No waiting, no entry/exit trickery.
> > 
> Are you also suggesting to get rid of vcpu-running information?

Yes.

> We would atleast need this to raise a flushTLB hypercall on the sleeping
> vcpu.

No, you always raise a flush TLB hypercall on flush_tlb_others, like Xen does.
Instead of an MMIO exit to APIC to IPI, its a hypercall exit.

> > This is half-way-there paravirt with all the downsides. 
> Some more details on what are the downsides would help us reach to a
> better solution.

The downside i refer to is overhead to write, test and maintain separate code
for running as a guest. If you are adding awareness about hypervisor
anyway, a hypercall is the simplest way:

- It is simple to request a remote TLB flush via vcpu->requests in the
  hypervisor. Information about which vcpus are in/out guest mode 
  already available.
- Maintenance of in/out guest mode information in guest memory adds more
  overhead to entry/exit paths.
- No need to handle the interprocessor synchronization in the pseudo
  algo below (already handled by vcpu->requests mechanism).
- The guest TLB IPI flow is (target vcpu):
  - exit-due-to-external-interrupt.
  - inject-ipi.
  - enter guest mode.
  - execute IPI handler, flush TLB.
  - ACK IPI.
  - source vcpu continues.
- The hypervisor TLB flush flow is:
  - exit-due-to-external-interrupt.
  - execute IPI handler (in host, from make_all_cpus_request)
  - ACK IPI.
  - source vcpu continues.

Unless there is an advantage in using APIC IPI exit vs hypercall
exit?

> > Even though the guest running information might be useful in other
> > cases.
> > 
> Yes, that was one of the things on the mind.
> 
> > > Pseudo Algo:
> > > 
> > >    Write()
> > >    ======
> > > 
> > > 	   guest_exit()
> > > 		   flush_on_enter[i]=0;
> > > 		   running[i] = 0;
> > > 
> > > 	   guest_enter()
> > > 		   running[i] = 1;
> > > 		   smp_mb();
> > > 		   if(flush_on_enter[i]) {
> > > 			   tlb_flush()
> > > 			   flush_on_enter[i]=0;
> > > 		   }
> > > 
> > > 
> > >    Read()
> > >    ======
> > > 
> > > 	   GUEST                                                KVM-HV
> > > 
> > >    f->flushcpumask = cpumask - me;
> > > 
> > > again:
> > >    for_each_cpu(i, f->flushmask) {
> > > 
> > > 	   if (!running[i]) {
> > > 						   case 1:
> > > 
> > > 						   running[n]=1
> > > 
> > > 						   (cpuN does not see
> > > 						   flush_on_enter set,
> > > 						   guest later finds it
> > > 						   running and sends ipi,
> > > 						   we are fine here, need
> > > 						   to clear the flag on
> > > 						   guest_exit)
> > > 
> > > 		  flush_on_enter[i] = 1;
> > > 						   case2:
> > > 
> > > 						   running[n]=1
> > > 						   (cpuN - will see flush
> > > 						   on enter and an IPI as
> > > 						   well - addressed in patch-4)
> > > 
> > > 		  if (!running[i])
> > > 		     cpu_clear(f->flushmask);      All is well, vm_enter
> > > 						   will do the fixup
> > > 	   }
> > > 						   case 3:
> > > 						   running[n] = 0;
> > > 
> > > 						   (cpuN went to sleep,
> > > 						   we saw it as awake,
> > > 						   ipi sent, but wait
> > > 						   will break without
> > > 						   zero_mask and goto
> > > 						   again will take care)
> > > 
> > >    }
> > >    send_ipi(f->flushmask)
> > > 
> > >    wait_a_while_for_zero_mask();
> > > 
> > >    if (!zero_mask)
> > > 	   goto again;
> > > ---
> > >  arch/x86/include/asm/kvm_para.h |    3 +-
> > >  arch/x86/include/asm/tlbflush.h |    9 ++++++
> > >  arch/x86/kernel/kvm.c           |    1 +
> > >  arch/x86/kvm/x86.c              |   14 ++++++++-
> > >  arch/x86/mm/tlb.c               |   61 +++++++++++++++++++++++++++++++++++++++
> > >  5 files changed, 86 insertions(+), 2 deletions(-)
> > > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe kvm" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
