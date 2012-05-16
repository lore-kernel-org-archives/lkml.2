Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759081Ab2EPGWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:22:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757467Ab2EPGWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:22:06 -0400
Date: Wed, 16 May 2012 09:22:04 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 5/8] kvm_para: guest side for eoi avoidance
Message-ID: <20120516062204.GC1823@redhat.com>
References: <cover.1337091955.git.mst@redhat.com>
 <958125d740a3d3a28003228307c993d9759b5ddb.1337091955.git.mst@redhat.com>
 <20120516015124.GA8846@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120516015124.GA8846@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 10:51:24PM -0300, Marcelo Tosatti wrote:
> On Tue, May 15, 2012 at 05:36:12PM +0300, Michael S. Tsirkin wrote:
> > The idea is simple: there's a bit, per APIC, in guest memory,
> > that tells the guest that it does not need EOI.
> > Guest tests it using a single est and clear operation - this is
> > necessary so that host can detect interrupt nesting - and if set, it can
> > skip the EOI MSR.
> > 
> > I run a simple microbenchmark to show exit reduction
> > (note: for testing, need to apply patch 7 from the series + a qemu patch
> >  I posted separately, on host):
> > 
> > Before:
> > 
> > Performance counter stats for 'sleep 1s':
> > 
> >             47,357 kvm:kvm_entry                                                [99.98%]
> >                  0 kvm:kvm_hypercall                                            [99.98%]
> >                  0 kvm:kvm_hv_hypercall                                         [99.98%]
> >              5,001 kvm:kvm_pio                                                  [99.98%]
> >                  0 kvm:kvm_cpuid                                                [99.98%]
> >             22,124 kvm:kvm_apic                                                 [99.98%]
> >             49,849 kvm:kvm_exit                                                 [99.98%]
> >             21,115 kvm:kvm_inj_virq                                             [99.98%]
> >                  0 kvm:kvm_inj_exception                                        [99.98%]
> >                  0 kvm:kvm_page_fault                                           [99.98%]
> >             22,937 kvm:kvm_msr                                                  [99.98%]
> >                  0 kvm:kvm_cr                                                   [99.98%]
> >                  0 kvm:kvm_pic_set_irq                                          [99.98%]
> >                  0 kvm:kvm_apic_ipi                                             [99.98%]
> >             22,207 kvm:kvm_apic_accept_irq                                      [99.98%]
> >             22,421 kvm:kvm_eoi                                                  [99.98%]
> >                  0 kvm:kvm_pv_eoi                                               [99.99%]
> >                  0 kvm:kvm_nested_vmrun                                         [99.99%]
> >                  0 kvm:kvm_nested_intercepts                                    [99.99%]
> >                  0 kvm:kvm_nested_vmexit                                        [99.99%]
> >                  0 kvm:kvm_nested_vmexit_inject                                    [99.99%]
> >                  0 kvm:kvm_nested_intr_vmexit                                    [99.99%]
> >                  0 kvm:kvm_invlpga                                              [99.99%]
> >                  0 kvm:kvm_skinit                                               [99.99%]
> >                 57 kvm:kvm_emulate_insn                                         [99.99%]
> >                  0 kvm:vcpu_match_mmio                                          [99.99%]
> >                  0 kvm:kvm_userspace_exit                                       [99.99%]
> >                  2 kvm:kvm_set_irq                                              [99.99%]
> >                  2 kvm:kvm_ioapic_set_irq                                       [99.99%]
> >             23,609 kvm:kvm_msi_set_irq                                          [99.99%]
> >                  1 kvm:kvm_ack_irq                                              [99.99%]
> >                131 kvm:kvm_mmio                                                 [99.99%]
> >                226 kvm:kvm_fpu                                                  [100.00%]
> >                  0 kvm:kvm_age_page                                             [100.00%]
> >                  0 kvm:kvm_try_async_get_page                                    [100.00%]
> >                  0 kvm:kvm_async_pf_doublefault                                    [100.00%]
> >                  0 kvm:kvm_async_pf_not_present                                    [100.00%]
> >                  0 kvm:kvm_async_pf_ready                                       [100.00%]
> >                  0 kvm:kvm_async_pf_completed
> > 
> >        1.002100578 seconds time elapsed
> > 
> > After:
> > 
> >  Performance counter stats for 'sleep 1s':
> > 
> >             28,354 kvm:kvm_entry                                                [99.98%]
> >                  0 kvm:kvm_hypercall                                            [99.98%]
> >                  0 kvm:kvm_hv_hypercall                                         [99.98%]
> >              1,347 kvm:kvm_pio                                                  [99.98%]
> >                  0 kvm:kvm_cpuid                                                [99.98%]
> >              1,931 kvm:kvm_apic                                                 [99.98%]
> >             29,595 kvm:kvm_exit                                                 [99.98%]
> >             24,884 kvm:kvm_inj_virq                                             [99.98%]
> >                  0 kvm:kvm_inj_exception                                        [99.98%]
> >                  0 kvm:kvm_page_fault                                           [99.98%]
> >              1,986 kvm:kvm_msr                                                  [99.98%]
> >                  0 kvm:kvm_cr                                                   [99.98%]
> >                  0 kvm:kvm_pic_set_irq                                          [99.98%]
> >                  0 kvm:kvm_apic_ipi                                             [99.99%]
> >             25,953 kvm:kvm_apic_accept_irq                                      [99.99%]
> >             26,132 kvm:kvm_eoi                                                  [99.99%]
> >             26,593 kvm:kvm_pv_eoi                                               [99.99%]
> >                  0 kvm:kvm_nested_vmrun                                         [99.99%]
> >                  0 kvm:kvm_nested_intercepts                                    [99.99%]
> >                  0 kvm:kvm_nested_vmexit                                        [99.99%]
> >                  0 kvm:kvm_nested_vmexit_inject                                    [99.99%]
> >                  0 kvm:kvm_nested_intr_vmexit                                    [99.99%]
> >                  0 kvm:kvm_invlpga                                              [99.99%]
> >                  0 kvm:kvm_skinit                                               [99.99%]
> >                284 kvm:kvm_emulate_insn                                         [99.99%]
> >                 68 kvm:vcpu_match_mmio                                          [99.99%]
> >                 68 kvm:kvm_userspace_exit                                       [99.99%]
> >                  2 kvm:kvm_set_irq                                              [99.99%]
> >                  2 kvm:kvm_ioapic_set_irq                                       [99.99%]
> >             28,288 kvm:kvm_msi_set_irq                                          [99.99%]
> >                  1 kvm:kvm_ack_irq                                              [99.99%]
> >                131 kvm:kvm_mmio                                                 [100.00%]
> >                588 kvm:kvm_fpu                                                  [100.00%]
> >                  0 kvm:kvm_age_page                                             [100.00%]
> >                  0 kvm:kvm_try_async_get_page                                    [100.00%]
> >                  0 kvm:kvm_async_pf_doublefault                                    [100.00%]
> >                  0 kvm:kvm_async_pf_not_present                                    [100.00%]
> >                  0 kvm:kvm_async_pf_ready                                       [100.00%]
> >                  0 kvm:kvm_async_pf_completed
> > 
> >        1.002039622 seconds time elapsed
> > 
> > We see that # of exits is almost halved.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  arch/x86/include/asm/bitops.h |    6 +++-
> >  arch/x86/kernel/kvm.c         |   50 ++++++++++++++++++++++++++++++++++++++--
> >  2 files changed, 51 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
> > index b97596e..c9c70ea 100644
> > --- a/arch/x86/include/asm/bitops.h
> > +++ b/arch/x86/include/asm/bitops.h
> > @@ -26,11 +26,13 @@
> >  #if __GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 1)
> >  /* Technically wrong, but this avoids compilation errors on some gcc
> >     versions. */
> > -#define BITOP_ADDR(x) "=m" (*(volatile long *) (x))
> > +#define BITOP_ADDR_CONSTRAINT "=m"
> >  #else
> > -#define BITOP_ADDR(x) "+m" (*(volatile long *) (x))
> > +#define BITOP_ADDR_CONSTRAINT "+m"
> >  #endif
> >  
> > +#define BITOP_ADDR(x) BITOP_ADDR_CONSTRAINT (*(volatile long *) (x))
> > +
> >  #define ADDR				BITOP_ADDR(addr)
> >  
> >  /*
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index e554e5a..31f85cb 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -39,6 +39,8 @@
> >  #include <asm/desc.h>
> >  #include <asm/tlbflush.h>
> >  #include <asm/idle.h>
> > +#include <asm/apic.h>
> > +#include <asm/apicdef.h>
> >  
> >  static int kvmapf = 1;
> >  
> > @@ -283,6 +285,23 @@ static void kvm_register_steal_time(void)
> >  		cpu, __pa(st));
> >  }
> >  
> > +/* size alignment is implied but just to make it explicit. */
> > +static DEFINE_PER_CPU(unsigned long, kvm_apic_eoi) __aligned(2) = 0;
> 
> DECLARE_PER_CPU_ALIGNED, can be heavily accessed.

Are you sure this will help? Without this, will all values
share a cache line?
I was unable to trigger any perf difference and it does
increase the cache footprint.

> > +static void kvm_guest_apic_eoi_write(u32 reg, u32 val)
> > +{
> > +	/**
> > +	 * This relies on __test_and_clear_bit to modify the memory
> > +	 * in a way that is atomic with respect to the local CPU.
> > +	 * The hypervisor only accesses this memory from the local CPU so
> > +	 * there's no need for lock or memory barriers.
> > +	 * An optimization barrier is implied in apic write.
> > +	 */
> > +	if (__test_and_clear_bit(0, &__get_cpu_var(kvm_apic_eoi)))
> > +		return;
> 
> Name and #define for the bit, please.

Where would be a good place for this define?
