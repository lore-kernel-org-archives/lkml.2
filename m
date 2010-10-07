Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677Ab0JGOFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 10:05:49 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44311 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab0JGOFs (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 7 Oct 2010 10:05:48 -0400
Date: Thu, 7 Oct 2010 10:05:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy@rcsinet11.oracle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [Xen-devel] Re: [PATCH 09/22] xen: Find an unbound irq number
 in reverse order (high to low).
Message-ID: <20101007140526.GA9437@dumpdata.com>
References: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
 <1286216015-9710-10-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.00.1010051617160.2440@kaball-desktop>
 <20101006225956.GB20211@dumpdata.com>
 <alpine.DEB.2.00.1010071130410.2440@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1010071130410.2440@kaball-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 11:38:49AM +0100, Stefano Stabellini wrote:
> On Wed, 6 Oct 2010, Konrad Rzeszutek Wilk wrote:
> > > 
> > > Unfortunately this is the wrong way to fix the issue: Xen has a range of
> > > allowed pirq for each domain and we don't know exactly what is the
> > > maximum pirq (see my patch "xen: get the maximum number of pirqs from
> > > xen" [1]).
> > 
> > > Considering that we might use the irq number returned by
> > > find_unbound_irq through xen_allocate_pirq as pirq number in some cases,
> > 
> > Ah, but we wouldn't! We would end up only using the 'find_unbound_irq' for
> > event channels. For IRQs that are for physical devices (either being
> > real devices passed in or QEMU PCI devices) we end up requesting an IRQ that
> > matches whatever the device has defined in dev->irq (or whatever the
> > vectors values for MSI/MSI-X devices that is provided) via the Xen PCI frontend
> > driver (in case of QEMU whatever its emulation provides).
> > 
> > > starting from the highest value could be unsafe.
> > > In practice it should be impossible to see this issue because it can
> > > only happen if the irq returned by xen_allocate_pirq is higher than the
> > > max pirq in xen. However AFAIK when we call xen_allocate_pirq with the
> > > intention of using the return value as pirq we always fall in the if
> > > (identity_mapped_irq(gsi) || !xen_initial_domain()) that avoid calling
> > > find_unbound_irq.
> > 
> > Right, and we end up using an the pirq/gsi number at that point. This
> > patch would not touch that logic.
> 
> What about adding a comment on top of xen_allocate_pirq like the
> following:
> 
> /* xen_allocate_irq might allocate irqs from the top down, as a
>  * consequence don't assume that the irq number returned has a low value
>  * or can be used as a pirq number unless you know otherwise.
>  *
>  * One notable exception is when xen_allocate_irq is called passing an
>  * hardware gsi as argument, in that case the irq number returned
>  * matches the gsi number passed as first argument.
>  */

Done!
