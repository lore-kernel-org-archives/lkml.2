Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab2DPM7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 08:59:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806Ab2DPM7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 08:59:09 -0400
Date: Mon, 16 Apr 2012 15:58:48 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: kvm: RCU warning in async pf
Message-ID: <20120416125848.GT11918@redhat.com>
References: <1333414472.11455.7.camel@lappy>
 <20120403105226.GF14939@redhat.com>
 <20120404123033.GD11918@redhat.com>
 <1334396693.2528.45.camel@twins>
 <20120416102855.GP11918@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120416102855.GP11918@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 01:28:55PM +0300, Gleb Natapov wrote:
> On Sat, Apr 14, 2012 at 11:44:53AM +0200, Peter Zijlstra wrote:
> > On Wed, 2012-04-04 at 15:30 +0300, Gleb Natapov wrote:
> > >  
> > > @@ -253,7 +254,10 @@ do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
> > >  		kvm_async_pf_task_wait((u32)read_cr2());
> > >  		break;
> > >  	case KVM_PV_REASON_PAGE_READY:
> > > +		rcu_irq_enter();
> > > +		exit_idle();
> > >  		kvm_async_pf_task_wake((u32)read_cr2());
> > > +		rcu_irq_exit();
> > >  		break;
> > >  	}
> > >  }
> > 
> > Wouldn't irq_enter() / irq_exit() be more appropriate? You're basically
> > taking an interrupt/exception from idle, irq_enter() will fix up
> > everything that needs fixing up, including time sources (which the
> > scheduler expects to be up-to-date).
> > 
> You are right. Will send a patch.
> 

KVM: Call irq_enter() instead of rcu_irq_enter() during async PF.

As Peter noted there are more things that should be done when leaving
idle state. irq_(enter|exit)() does them and also call rcu functions.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b8ba6e4..83a48f6 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -254,10 +254,10 @@ do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
 		kvm_async_pf_task_wait((u32)read_cr2());
 		break;
 	case KVM_PV_REASON_PAGE_READY:
-		rcu_irq_enter();
+		irq_enter();
 		exit_idle();
 		kvm_async_pf_task_wake((u32)read_cr2());
-		rcu_irq_exit();
+		irq_exit();
 		break;
 	}
 }
--
			Gleb.
