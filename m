Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab0LRSLh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 13:11:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757141Ab0LRSLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 13:11:35 -0500
Date: Sat, 18 Dec 2010 20:11:00 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Jan Kiszka <jan.kiszka@web.de>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Tom Lyon <pugs@ieee.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v3 2/4] genirq: Inform handler about line sharing state
Message-ID: <20101218181100.GA2182@redhat.com>
References: <alpine.LFD.2.00.1012161410440.12146@localhost6.localdomain6>
 <4D0A75E3.3090900@web.de>
 <4D0B1CD9.5060601@web.de>
 <alpine.LFD.2.00.1012171116480.12146@localhost6.localdomain6>
 <4D0B3C11.4090307@siemens.com>
 <alpine.LFD.2.00.1012171137430.12146@localhost6.localdomain6>
 <4D0B400D.8010903@siemens.com>
 <alpine.LFD.2.00.1012171315260.12146@localhost6.localdomain6>
 <4D0B8A73.4050005@siemens.com>
 <alpine.LFD.2.00.1012171725300.12146@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1012171725300.12146@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 05:32:46PM +0100, Thomas Gleixner wrote:
> On Fri, 17 Dec 2010, Jan Kiszka wrote:
> > Am 17.12.2010 16:25, Thomas Gleixner wrote:
> > > Your aproach with disable_irq_nosync() is completely flawed, simply
> > > because you try to pretend that your interrupt handler is done, while
> > > it is not done at all. The threaded interrupt handler is done when
> > > user space completes. Everything else is just hacking around the
> > > problem and creates all that nasty transitional problems.
> > 
> > disable_irq_nosync is the pattern currently used in KVM, it's nothing
> > new in fact.
> 
> That does not make it less flawed :)
> 
> > The approach looks interesting but requires separate code for
> > non-PCI-2.3 devices, i.e. when we have no means to mask at device level.
> 
> Why? You can have the same code, you just can't request COND_ONESHOT
> handlers for it, so it needs unshared ONESHOT or it won't work at all,
> no matter what approach you chose. No device level mask, no sharing,
> it's that simple.
> 
> > Further drawbacks - unless I missed something on first glance:
> > 
> > - prevents any future optimizations that would work without IRQ thread
> >   ping-pong (ie. once we allow guest IRQ injection from hardirq context
> >   for selected but typical setups)
> > - two additional, though light-weight, context switches on each
> >   interrupt completion
> 
> The drawback of these two points is way less than the horror which you
> need to introduce to do the whole async handler disable, userspace
> enable dance. Robust and simple solutions really a preferred over
> complex and fragile horror which has a questionable runtime benefit.

I'd like to note that the overhead of involving the scheduler in
interrupt injection for an assigned device should be easily measurable:
just make the MSI handlers threaded and see what the result is.

In the case of emulated devices, when we had an extra thread
involved in MSI handling, the vcpu thread and the
interrupt injection thread were competing for cpu with strange
fluctuations in performance as the result
(i.e. sometimes we would get good speed as threading would introduce
a kind of interrupt coalescing, sometimes we would get huge latency).

> > - continuous polling if user space decides to leave the interrupt
> >   unhandled (e.g. because the virtual IRQ line is masked)
>  
> That should be a solvable problem.
> 
> Thanks,
> 
> 	tglx
