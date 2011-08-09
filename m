Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab1HISvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 14:51:23 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:63196 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab1HISvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 14:51:22 -0400
Date: Tue, 9 Aug 2011 14:51:00 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 2/3] xen/pv-on-hvm kexec: rebind virqs to
 existing eventchannel ports
Message-ID: <20110809185100.GA19520@dumpdata.com>
References: <20110804162053.723541930@aepfle.de>
 <20110804162054.510901329@aepfle.de>
 <1312881460.26263.46.camel@zakaz.uk.xensource.com>
 <20110809152806.GA12710@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809152806.GA12710@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090208.4E4181A3.0093,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 05:28:06PM +0200, Olaf Hering wrote:
> On Tue, Aug 09, Ian Campbell wrote:
> 
> > On Thu, 2011-08-04 at 17:20 +0100, Olaf Hering wrote:
> > > During a kexec boot some virqs such as timer and debugirq were already
> > > registered by the old kernel.  The hypervisor will return -EEXISTS from
> > > the new EVTCHNOP_bind_virq request and the BUG in bind_virq_to_irq()
> > > triggers.  Catch the -EEXISTS error and loop through all possible ports to find
> > > what port belongs to the virq/cpu combo.
> > 
> > Would it be better to proactively just query the status of all event
> > channels early on, like you do in find_virq, and setup the irq info
> > structures as appropriate? Rather than waiting for an -EEXISTS I mean.

We only create those structures when the IRQ handler is setup. And since
this is a new kernel, the irq_get_handler_data(irq) won't be present.
> 
> Now that I read that again more carefully: 
> No idea if thats possible, I will leave that answer to Jeremy/Konrad.

But we could an optimization. The find_virq does a search every time
from 0->NR_EVENTS. Perhaps we can also check the xen_irq_list_head
to skip over the event channels we have already created?

Something like this:

   bool skip = false;
   list_for_each_entry(info, &xen_irq_list_head, list)
   if (info->evtchn == port && info->cpu == cpu) {
        skip=true;
        break;
    }
    if (skip)
        continue

    .. snip..
    and here is the EVTCHNOP_status hypercall.
