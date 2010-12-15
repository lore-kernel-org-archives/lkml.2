Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab0LOOuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 09:50:11 -0500
Received: from www.tglx.de ([62.245.132.106]:38645 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab0LOOuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 09:50:09 -0500
Date: Wed, 15 Dec 2010 15:49:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kiszka <jan.kiszka@siemens.com>
cc: Jan Kiszka <jan.kiszka@web.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 2/4] genirq: Inform handler about line sharing state
In-Reply-To: <4D08CE44.6000407@siemens.com>
Message-ID: <alpine.LFD.2.00.1012151534540.12146@localhost6.localdomain6>
References: <cover.1292281184.git.jan.kiszka@web.de> <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012142147420.12146@localhost6.localdomain6> <4D07F70A.30209@web.de> <alpine.LFD.2.00.1012151357030.12146@localhost6.localdomain6>
 <4D08CE44.6000407@siemens.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010, Jan Kiszka wrote:

> Am 15.12.2010 14:04, Thomas Gleixner wrote:
> > On Wed, 15 Dec 2010, Jan Kiszka wrote:
> >> Am 14.12.2010 21:54, Thomas Gleixner wrote:
> >>> On Mon, 13 Dec 2010, Jan Kiszka wrote:
> >>>> @@ -943,6 +950,9 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
> >>>>  	/* Make sure it's not being used on another CPU: */
> >>>>  	synchronize_irq(irq);
> >>>>  
> >>>> +	if (single_handler)
> >>>> +		desc->irq_data.drv_status &= ~IRQS_SHARED;
> >>>> +
> >>>
> >>> What's the reason to clear this flag outside of the desc->lock held
> >>> region.
> >>
> >> We need to synchronize the irq first before clearing the flag.
> >>
> >> The problematic scenario behind this: An IRQ started in shared mode,
> >> this the line was unmasked after the hardirq. Now we clear IRQS_SHARED
> >> before calling into the threaded handler. And that handler may now think
> >> that the line is still masked as IRQS_SHARED is set.
> > 
> > That should read "not set" I guess.
> 
> Can't remember who wrote this, but that guy might have been too tired
> for clear sentences: Yes, of course, we could run into troubles, if
> IRQS_SHARED was _not_ set while the IRQ line is unmasked between hard
> and threaded handler.

Right.

As a side note, the current implementation requires that you lookup
irq_data.drv_status for every invocation of the handler or have a
reference to irq_data.drv_status somewhere locally, which I don't like
either.

I have an evil and nasy idea how to avoid that, need to look how ugly
it gets. Worst case we need to go back to that notification thing
which I wanted really avoid in the first place.
 
Though I like the register_mutex idea which came out of this a lot as
it allows us to reduce desc->lock held and interrupt disabled regions
quite nicely.

/me goes back to stare at the code

> > Hmm, needs more thoughts :(
> 
> Be warned, might be painful.

Bah, my brain became pain resistant when I started hacking that code.

Thanks,

	tglx
