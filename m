Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab2DDOMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 10:12:39 -0400
Received: from [207.239.115.78] ([207.239.115.78]:49954 "EHLO
	p2112.superclick.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab2DDOMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 10:12:38 -0400
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Apr 2012 10:12:38 EDT
Date: Wed, 4 Apr 2012 07:04:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: kvm: RCU warning in async pf
Message-ID: <20120404140416.GF2302@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1333414472.11455.7.camel@lappy>
 <20120403105226.GF14939@redhat.com>
 <20120404123033.GD11918@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120404123033.GD11918@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 03:30:33PM +0300, Gleb Natapov wrote:
> On Tue, Apr 03, 2012 at 01:52:26PM +0300, Gleb Natapov wrote:
> > On Mon, Apr 02, 2012 at 08:54:32PM -0400, Sasha Levin wrote:
> > > Hi all,
> > > 
> > > I got the spew at the bottom of the mail in a KVM guest using the KVM tools and running trinity.
> > > 
> > > I'm not quite sure how default_idle managed to trigger a pagefault, so that part looks odd to me.
> > > 
> > This is not regular page fault. This is async page fault that tells the
> > guest that a page, previously swapped out by hypervisor, is now swapped
> > back in and it can happen while vcpu is idle. The code does not leave
> > idle state properly though. We probably need to call rcu_irq_enter()
> > there. Will look into it.
> > 
> 
> The patch below solves it for me:
> 
> "Page ready" async PF can kick vcpu out of idle state much like IRQ.
> We need to tell RCU about this.

This is invoked from an exception or interrupt handler, not from
process-level code?  If so:

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Gleb Natapov <gleb@redhat.com>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index f0c6fd6..380079f 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -38,6 +38,7 @@
>  #include <asm/traps.h>
>  #include <asm/desc.h>
>  #include <asm/tlbflush.h>
> +#include <asm/idle.h>
> 
>  static int kvmapf = 1;
> 
> @@ -253,7 +254,10 @@ do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
>  		kvm_async_pf_task_wait((u32)read_cr2());
>  		break;
>  	case KVM_PV_REASON_PAGE_READY:
> +		rcu_irq_enter();
> +		exit_idle();
>  		kvm_async_pf_task_wake((u32)read_cr2());
> +		rcu_irq_exit();
>  		break;
>  	}
>  }
> --
> 			Gleb.
> 
