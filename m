Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab2JLOgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 10:36:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:41470 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab2JLOf6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 10:35:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,576,1344236400"; 
   d="scan'208";a="234099864"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with
 irq thread
Thread-Topic: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with
 irq thread
Thread-Index: AQHNqIA0xNWms64G/kSGCSQSXS8Oype1ubKA
Date: Fri, 12 Oct 2012 14:35:44 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A195A43@SHSMSX101.ccr.corp.intel.com>
References: <1350045084.13178.19.camel@cliu38-desktop-build>
 <alpine.LFD.2.02.1210121427490.2779@ionos>
 <27240C0AC20F114CBF8149A2696CBE4A19587A@SHSMSX101.ccr.corp.intel.com>
 <alpine.LFD.2.02.1210121440160.2779@ionos>
 <27240C0AC20F114CBF8149A2696CBE4A1958B9@SHSMSX101.ccr.corp.intel.com>
 <alpine.LFD.2.02.1210121533560.2779@ionos>
In-Reply-To: <alpine.LFD.2.02.1210121533560.2779@ionos>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks your beautiful explain for edge interrupt handler, still has one confusing for unmask_irq in
irq_finalize_oneshot().

Could you see below comments? Thanks.

> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Friday, October 12, 2012 9:48 PM
> To: Liu, Chuansheng
> Cc: linux-kernel@vger.kernel.org
> Subject: RE: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with irq
> thread
> 
> On Fri, 12 Oct 2012, Liu, Chuansheng wrote:
> > > -----Original Message-----
> > > From: Thomas Gleixner [mailto:tglx@linutronix.de]
> > > Sent: Friday, October 12, 2012 8:46 PM
> > > To: Liu, Chuansheng
> > > Cc: linux-kernel@vger.kernel.org
> > > Subject: RE: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support
> with irq
> > > thread
> > >
> > > On Fri, 12 Oct 2012, Liu, Chuansheng wrote:
> > > > > -----Original Message-----
> > > > > From: Thomas Gleixner [mailto:tglx@linutronix.de]
> > > > > Sent: Friday, October 12, 2012 8:32 PM
> > > > > To: Liu, Chuansheng
> > > > > Cc: linux-kernel@vger.kernel.org
> > > > > Subject: Re: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support
> > > with irq
> > > > > thread
> > > > >
> > > > > On Fri, 12 Oct 2012, Chuansheng Liu wrote:
> > > > > >
> > > > > > In our system, there is one edge interrupt, and we want it to be
> > > > > > irq thread with IRQS_ONESHOT, and found in handle_edge_irq(),
> > > > > > even with IRQS_ONESHOT, the irq is still unmasked without care of
> > > > > > flag IRQS_ONESHOT.
> > > > > >
> > > > > > It causes IRQS_ONESHOT can not work well for edge interrupt, but
> also
> > > > > > after the irq thread finished with flag IRQS_ONESHOT, the irq will be
> > > > > > possible to be unmasked again, it should be messing mask/unmask
> logic.
> > > > >
> > > > > This is just wrong. By masking edge interrupts you will run into
> > > > > situations where you will lose interrupts.
> > > > >
> > > > > Can you please explain, why you want to mask your edge interrupt?
> > >
> > > > When I request_irq with irq thread handler and flag IRQS_ONESHOT, if
> > > > do not mask the edge interrupt, the primary handler and irq thread
> > > > maybe run at the same time, and in my real case it causes spin
> > > > deadlock.
> > >
> > > Then your code is simply wrong and you need to fix it instead of hacking a
> > > workaround into the core code. Locking is not that hard.
> >
> > I got means, so I want to use flag IRQS_ONESHOT to avoid the case that two
> > handlers running at the same time. Is it right direction?
> 
> Again, this does not work for edge type interrupts. Period. And we are
> not adding something which is known to be broken.
> 
> Also there is no problem when a hard interrupt comes in while the
> thread handler is running. It's just a matter of proper code and
> proper locking.
> 
> > But IRQS_ONESHOT does not work well for edge interrupt.
> > And pasting the IRQS_ONESHOT description:
> > * IRQS_ONESHOT			- irq is not unmasked in primary handler
> 
> Right, and edge type interrupts doe not support it.
Can we do something? Thanks your sharing.
In request_thread_irq() case with FLAG IRQS_ONESHOT, for edge interrupt,
in function irq_finalize_oneshot():
	if (!desc->threads_oneshot && !irqd_irq_disabled(&desc->irq_data) &&
	    irqd_irq_masked(&desc->irq_data))
		unmask_irq(desc);

It is possible unmask_irq() is called, but the below code is just aiming for masking action
in irq handler, so I guess if I called the mask_irq() in non-core code, when irq_finalize_oneshot
is called, the unmask_irq is called, and it is not we wanted, right? Do not test this case:)
> 
> > And I need irq handler is because some heavy work is needed, it can avoid
> local
> > irq disabling time thru irq handler.
> 
> Disable the interrupt at the device level in your primary handler, but
> do not try to impose something to the core code which is fundamentaly
> wrong.
> 
> > >
> > > > You means it is not right with IRQS_ONESHOT for edge interrupt?
> > >
> > > It's wrong. Simnply because you can lose interrupts.
> > >
> > >      interrupt raised
> > >      	 handle_edge_irq()
> > > 	    mask_ack_irq()
> > > 	    handle_event()
> > > 	        wake irq thread
> > >      reti
> > >
> > >      irq thread runs
> > >      	 handle device interrupt()
> > > 				   <--- device issues edge irq
> > > 	 unmask_irq()
> > >
> > > This interrupt is not delivered. So your device stops working. Not
> > > what you want, right?
> 
> > Device should not stop:) And even in current handle_edge_irq(), it
> > is possible that losting Interrupt if primary handler need some time
> > and the irq is quick enough. I says the below code, it just avoid
> 
> The code flow is:
> 
>    Interrupt
> 	ack()
> 	handler()
>    RETI
> 
> After the ack another interrupt can come in. It's raised in the CPU,
> but it cannot be delivered because the CPU is running that very
> interrupt at this point with interupts disabled. After RETI this
> interrupt is delivered and runs the edge handler again. That's on UP.
> 
> On SMP an interrupt which is raised after the ack() again before the
> handler finishes, can invoke another delivery on a different CPU,
> which then sees the IRQ_INPROGESS flag, masks it and flags it
> PENDING. When the primary handler on the first CPU returns, it sees
> the PENDING flag, unmasks and invokes the handler another time.
> 
Got it. Thanks your clear explain.

> So nothing gets lost. Now you mask it and if you look at the flow I
> showed in my last mail, then your device will be stuck. Simply because
> the interrupt was delivered while the line was masked at the irq chip
> level which causes a drop. That's a property of edge type interrupts
> and we have proper code to deal with it. No way to change that just
> that you can avoid to fix your broken driver design.
> 
> Thanks,
> 
> 	tglx
> 

