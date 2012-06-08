Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760412Ab2FHOjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:39:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab2FHOji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:39:38 -0400
Date: Fri, 8 Jun 2012 17:39:27 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yongjie.ren@intel.com" <yongjie.ren@intel.com>
Subject: Re: [PATCH] KVM: Use IRQF_ONESHOT for assigned device MSI interrupts
Message-ID: <20120608143927.GA4949@redhat.com>
References: <20120601161521.26935.25606.stgit@bling.home>
 <4FC8F042.5050600@siemens.com>
 <1338570192.23475.25.camel@bling.home>
 <4FC8F867.7080103@siemens.com>
 <1338573558.23475.41.camel@bling.home>
 <4FC90961.8030701@siemens.com>
 <4FCB2359.9020505@redhat.com>
 <alpine.LFD.2.02.1206041235540.3086@ionos>
 <4FCC9EAC.9090007@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCC9EAC.9090007@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 01:40:28PM +0200, Jan Kiszka wrote:
> On 2012-06-04 13:21, Thomas Gleixner wrote:
> > On Sun, 3 Jun 2012, Avi Kivity wrote:
> > 
> >> On 06/01/2012 09:26 PM, Jan Kiszka wrote:
> >>>
> >>>> you suggesting we need a request_edge_threaded_only_irq() API?  Thanks,
> >>>
> >>> I'm just wondering if that restriction for threaded IRQs is really
> >>> necessary for all use cases we have. Threaded MSIs do not appear to me
> >>> like have to be handled that conservatively, but maybe I'm missing some
> >>> detail.
> >>>
> >>
> >> btw, I'm hoping we can unthread assigned MSIs.  If the delivery is
> >> unicast, we can precalculate everything and all the handler has to do is
> >> set the IRR, KVM_REQ_EVENT, and kick the vcpu.  All of these can be done
> >> from interrupt context with just RCU locking.
> > 
> > There is really no need to run MSI/MSI-X interrupts threaded for
> > KVM. I'm running the patch below for quite some time and it works like
> > a charm.
> > 
> > Thanks,
> > 
> > 	tglx
> > ----


....

> 
> This may work in practice but has two conceptual problems:
>  - we do not want to run a potential broadcast to all VCPUs to run in
>    a host IRQ handler

I'm not sure why this one is a problem: injecting an interrupt
once you know the vcpu seems really cheap.
It's true that scanning vcpus might take a bit more time
when there are lots of them but it's a single
linear scan that we do anyway.

And we also inject msi from irqfd callback with interrupts
disabled which seems equivalent.

Pls correct me if I'm wrong.

>  - crazy user space could have configured the route to end up in the
>    PIC or IOAPIC, and both are not hard-IRQ safe (this should probably
>    be caught on setup)

Yes this needs to be fixed up.

> So this shortcut requires some checks before being applied to a specific
> MSI/MSI-X vector.
> 
> 
> Taking KVM aside, my general question remains if threaded MSI handlers
> of all devices really need to apply IRQF_ONESHOT though they should have
> no use for it.
> 
> Jan
> 
> -- 
> Siemens AG, Corporate Technology, CT T DE IT 1
> Corporate Competence Center Embedded Linux
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
