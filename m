Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab2DDOS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 10:18:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541Ab2DDOS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 10:18:56 -0400
Date: Wed, 4 Apr 2012 17:18:31 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: kvm: RCU warning in async pf
Message-ID: <20120404141831.GF11918@redhat.com>
References: <1333414472.11455.7.camel@lappy>
 <20120403105226.GF14939@redhat.com>
 <20120404123033.GD11918@redhat.com>
 <20120404140416.GF2302@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120404140416.GF2302@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 07:04:16AM -0700, Paul E. McKenney wrote:
> On Wed, Apr 04, 2012 at 03:30:33PM +0300, Gleb Natapov wrote:
> > On Tue, Apr 03, 2012 at 01:52:26PM +0300, Gleb Natapov wrote:
> > > On Mon, Apr 02, 2012 at 08:54:32PM -0400, Sasha Levin wrote:
> > > > Hi all,
> > > > 
> > > > I got the spew at the bottom of the mail in a KVM guest using the KVM tools and running trinity.
> > > > 
> > > > I'm not quite sure how default_idle managed to trigger a pagefault, so that part looks odd to me.
> > > > 
> > > This is not regular page fault. This is async page fault that tells the
> > > guest that a page, previously swapped out by hypervisor, is now swapped
> > > back in and it can happen while vcpu is idle. The code does not leave
> > > idle state properly though. We probably need to call rcu_irq_enter()
> > > there. Will look into it.
> > > 
> > 
> > The patch below solves it for me:
> > 
> > "Page ready" async PF can kick vcpu out of idle state much like IRQ.
> > We need to tell RCU about this.
> 
> This is invoked from an exception or interrupt handler, not from
> process-level code?  If so:
> 
>From an exception.

> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> > Signed-off-by: Gleb Natapov <gleb@redhat.com>
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index f0c6fd6..380079f 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -38,6 +38,7 @@
> >  #include <asm/traps.h>
> >  #include <asm/desc.h>
> >  #include <asm/tlbflush.h>
> > +#include <asm/idle.h>
> > 
> >  static int kvmapf = 1;
> > 
> > @@ -253,7 +254,10 @@ do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
> >  		kvm_async_pf_task_wait((u32)read_cr2());
> >  		break;
> >  	case KVM_PV_REASON_PAGE_READY:
> > +		rcu_irq_enter();
> > +		exit_idle();
> >  		kvm_async_pf_task_wake((u32)read_cr2());
> > +		rcu_irq_exit();
> >  		break;
> >  	}
> >  }
> > --
> > 			Gleb.
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
			Gleb.
