Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066Ab2JLMqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 08:46:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:54960 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab2JLMqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 08:46:21 -0400
Date: Fri, 12 Oct 2012 14:46:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with
 irq thread
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A19587A@SHSMSX101.ccr.corp.intel.com>
Message-ID: <alpine.LFD.2.02.1210121440160.2779@ionos>
References: <1350045084.13178.19.camel@cliu38-desktop-build> <alpine.LFD.2.02.1210121427490.2779@ionos> <27240C0AC20F114CBF8149A2696CBE4A19587A@SHSMSX101.ccr.corp.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2012, Liu, Chuansheng wrote:
> > -----Original Message-----
> > From: Thomas Gleixner [mailto:tglx@linutronix.de]
> > Sent: Friday, October 12, 2012 8:32 PM
> > To: Liu, Chuansheng
> > Cc: linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with irq
> > thread
> > 
> > On Fri, 12 Oct 2012, Chuansheng Liu wrote:
> > >
> > > In our system, there is one edge interrupt, and we want it to be
> > > irq thread with IRQS_ONESHOT, and found in handle_edge_irq(),
> > > even with IRQS_ONESHOT, the irq is still unmasked without care of
> > > flag IRQS_ONESHOT.
> > >
> > > It causes IRQS_ONESHOT can not work well for edge interrupt, but also
> > > after the irq thread finished with flag IRQS_ONESHOT, the irq will be
> > > possible to be unmasked again, it should be messing mask/unmask logic.
> > 
> > This is just wrong. By masking edge interrupts you will run into
> > situations where you will lose interrupts.
> > 
> > Can you please explain, why you want to mask your edge interrupt?

> When I request_irq with irq thread handler and flag IRQS_ONESHOT, if
> do not mask the edge interrupt, the primary handler and irq thread
> maybe run at the same time, and in my real case it causes spin
> deadlock.

Then your code is simply wrong and you need to fix it instead of hacking a
workaround into the core code. Locking is not that hard.

> You means it is not right with IRQS_ONESHOT for edge interrupt?

It's wrong. Simnply because you can lose interrupts.

     interrupt raised
     	 handle_edge_irq()
	    mask_ack_irq()
	    handle_event()
	        wake irq thread
     reti

     irq thread runs
     	 handle device interrupt()
				   <--- device issues edge irq
	 unmask_irq()

This interrupt is not delivered. So your device stops working. Not
what you want, right?

Thanks,

	tglx
