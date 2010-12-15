Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab0LONEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 08:04:36 -0500
Received: from www.tglx.de ([62.245.132.106]:37696 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab0LONEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 08:04:34 -0500
Date: Wed, 15 Dec 2010 14:04:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kiszka <jan.kiszka@web.de>
cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v3 2/4] genirq: Inform handler about line sharing state
In-Reply-To: <4D07F70A.30209@web.de>
Message-ID: <alpine.LFD.2.00.1012151357030.12146@localhost6.localdomain6>
References: <cover.1292281184.git.jan.kiszka@web.de> <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012142147420.12146@localhost6.localdomain6> <4D07F70A.30209@web.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010, Jan Kiszka wrote:
> Am 14.12.2010 21:54, Thomas Gleixner wrote:
> > On Mon, 13 Dec 2010, Jan Kiszka wrote:
> >> @@ -943,6 +950,9 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
> >>  	/* Make sure it's not being used on another CPU: */
> >>  	synchronize_irq(irq);
> >>  
> >> +	if (single_handler)
> >> +		desc->irq_data.drv_status &= ~IRQS_SHARED;
> >> +
> > 
> > What's the reason to clear this flag outside of the desc->lock held
> > region.
> 
> We need to synchronize the irq first before clearing the flag.
> 
> The problematic scenario behind this: An IRQ started in shared mode,
> this the line was unmasked after the hardirq. Now we clear IRQS_SHARED
> before calling into the threaded handler. And that handler may now think
> that the line is still masked as IRQS_SHARED is set.

That should read "not set" I guess. Hmm, needs more thoughts :(
 
> > I need this status for other purposes as well, where I
> > definitely need serialization.
> 
> Well, two options: wrap all bit manipulations with desc->lock
> acquisition/release or turn drv_status into an atomic. I don't know what
> your plans with drv_status are, so...

Some bits for irq migration and other stuff, which allows us to avoid
fiddling with irqdesc in the drivers.

Thanks,

	tglx
