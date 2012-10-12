Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984Ab2JLMiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 08:38:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:64704 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932292Ab2JLMiG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 08:38:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,576,1344236400"; 
   d="scan'208";a="204801094"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with
 irq thread
Thread-Topic: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with
 irq thread
Thread-Index: AQHNqHWU29ecq+Cr/E+cQrCZvEUxo5e1mu8g
Date: Fri, 12 Oct 2012 12:38:03 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A19587A@SHSMSX101.ccr.corp.intel.com>
References: <1350045084.13178.19.camel@cliu38-desktop-build>
 <alpine.LFD.2.02.1210121427490.2779@ionos>
In-Reply-To: <alpine.LFD.2.02.1210121427490.2779@ionos>
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
> Sent: Friday, October 12, 2012 8:32 PM
> To: Liu, Chuansheng
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with irq
> thread
> 
> On Fri, 12 Oct 2012, Chuansheng Liu wrote:
> >
> > In our system, there is one edge interrupt, and we want it to be
> > irq thread with IRQS_ONESHOT, and found in handle_edge_irq(),
> > even with IRQS_ONESHOT, the irq is still unmasked without care of
> > flag IRQS_ONESHOT.
> >
> > It causes IRQS_ONESHOT can not work well for edge interrupt, but also
> > after the irq thread finished with flag IRQS_ONESHOT, the irq will be
> > possible to be unmasked again, it should be messing mask/unmask logic.
> 
> This is just wrong. By masking edge interrupts you will run into
> situations where you will lose interrupts.
> 
> Can you please explain, why you want to mask your edge interrupt?
When I request_irq with irq thread handler and flag IRQS_ONESHOT, if do not mask the edge interrupt,
the primary handler and irq thread maybe run at the same time, and in my real case it causes spin deadlock.

You means it is not right with IRQS_ONESHOT for edge interrupt?
> 
> Thanks,
> 
> 	tglx
> 
> 
> > Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> > ---
> >  kernel/irq/chip.c |    8 +++++++-
> >  1 files changed, 7 insertions(+), 1 deletions(-)
> >
> > diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> > index 57d86d0..f23f524 100644
> > --- a/kernel/irq/chip.c
> > +++ b/kernel/irq/chip.c
> > @@ -497,7 +497,13 @@ handle_edge_irq(unsigned int irq, struct irq_desc
> *desc)
> >  	kstat_incr_irqs_this_cpu(irq, desc);
> >
> >  	/* Start handling the irq */
> > -	desc->irq_data.chip->irq_ack(&desc->irq_data);
> > +	if (desc->istate & IRQS_ONESHOT) {
> > +		mask_ack_irq(desc);
> > +		handle_irq_event(desc);
> > +		cond_unmask_irq(desc);
> > +		goto out_unlock;
> > +	} else
> > +		desc->irq_data.chip->irq_ack(&desc->irq_data);
> >
> >  	do {
> >  		if (unlikely(!desc->action)) {
> > --
> > 1.7.0.4
> >
> >
> >
> >
