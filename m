Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab0LOPmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 10:42:18 -0500
Received: from www.tglx.de ([62.245.132.106]:58111 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab0LOPmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 10:42:17 -0500
Date: Wed, 15 Dec 2010 16:41:55 +0100 (CET)
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
Message-ID: <alpine.LFD.2.00.1012151633510.12146@localhost6.localdomain6>
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
> 
> > Hmm, needs more thoughts :(
> 
> Be warned, might be painful.

Talking about headache. Your solution above does not prevent that
scenario.

 CPU 0                  CPU 1
		
 synchronize_irq();
		        hard irq comes in sees shared and unmasks
 clear IRQS_SHARED
			thread handler runs and sees !SHARED

Same scenario, just moved by a few lines :)

Thanks,

	tglx
