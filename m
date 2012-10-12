Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934037Ab2JLNDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 09:03:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:47089 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933185Ab2JLNDn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 09:03:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,576,1344236400"; 
   d="scan'208";a="155500402"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with
 irq thread
Thread-Topic: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with
 irq thread
Thread-Index: AQHNqHeaj1yQox4Me0+UyZJ6nHY31pe1n4TQ
Date: Fri, 12 Oct 2012 13:03:39 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1958B9@SHSMSX101.ccr.corp.intel.com>
References: <1350045084.13178.19.camel@cliu38-desktop-build>
 <alpine.LFD.2.02.1210121427490.2779@ionos>
 <27240C0AC20F114CBF8149A2696CBE4A19587A@SHSMSX101.ccr.corp.intel.com>
 <alpine.LFD.2.02.1210121440160.2779@ionos>
In-Reply-To: <alpine.LFD.2.02.1210121440160.2779@ionos>
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



> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Friday, October 12, 2012 8:46 PM
> To: Liu, Chuansheng
> Cc: linux-kernel@vger.kernel.org
> Subject: RE: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with irq
> thread
> 
> On Fri, 12 Oct 2012, Liu, Chuansheng wrote:
> > > -----Original Message-----
> > > From: Thomas Gleixner [mailto:tglx@linutronix.de]
> > > Sent: Friday, October 12, 2012 8:32 PM
> > > To: Liu, Chuansheng
> > > Cc: linux-kernel@vger.kernel.org
> > > Subject: Re: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support
> with irq
> > > thread
> > >
> > > On Fri, 12 Oct 2012, Chuansheng Liu wrote:
> > > >
> > > > In our system, there is one edge interrupt, and we want it to be
> > > > irq thread with IRQS_ONESHOT, and found in handle_edge_irq(),
> > > > even with IRQS_ONESHOT, the irq is still unmasked without care of
> > > > flag IRQS_ONESHOT.
> > > >
> > > > It causes IRQS_ONESHOT can not work well for edge interrupt, but also
> > > > after the irq thread finished with flag IRQS_ONESHOT, the irq will be
> > > > possible to be unmasked again, it should be messing mask/unmask logic.
> > >
> > > This is just wrong. By masking edge interrupts you will run into
> > > situations where you will lose interrupts.
> > >
> > > Can you please explain, why you want to mask your edge interrupt?
> 
> > When I request_irq with irq thread handler and flag IRQS_ONESHOT, if
> > do not mask the edge interrupt, the primary handler and irq thread
> > maybe run at the same time, and in my real case it causes spin
> > deadlock.
> 
> Then your code is simply wrong and you need to fix it instead of hacking a
> workaround into the core code. Locking is not that hard.
I got means, so I want to use flag IRQS_ONESHOT to avoid the case that two
handlers running at the same time. Is it right direction?
But IRQS_ONESHOT does not work well for edge interrupt.
And pasting the IRQS_ONESHOT description:
* IRQS_ONESHOT			- irq is not unmasked in primary handler

And I need irq handler is because some heavy work is needed, it can avoid local
irq disabling time thru irq handler.

> 
> > You means it is not right with IRQS_ONESHOT for edge interrupt?
> 
> It's wrong. Simnply because you can lose interrupts.
> 
>      interrupt raised
>      	 handle_edge_irq()
> 	    mask_ack_irq()
> 	    handle_event()
> 	        wake irq thread
>      reti
> 
>      irq thread runs
>      	 handle device interrupt()
> 				   <--- device issues edge irq
> 	 unmask_irq()
> 
> This interrupt is not delivered. So your device stops working. Not
> what you want, right?
Device should not stop:) And even in current handle_edge_irq(), it is possible that losting
Interrupt if primary handler need some time and the irq is quick enough. I says the below
code, it just avoid one time lost.

                        desc->istate |= IRQS_PENDING;
                        mask_ack_irq(desc);


> 
> Thanks,
> 
> 	tglx
