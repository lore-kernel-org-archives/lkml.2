Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab2G3O6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:58:45 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:30377 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab2G3O6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:58:44 -0400
X-IronPort-AV: E=Sophos;i="4.77,679,1336348800"; 
   d="scan'208";a="13764645"
Date: Mon, 30 Jul 2012 15:58:02 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/2] xen/swiotlb: If iommu=soft was not passed
 in on > 4GB, don't turn it on.
In-Reply-To: <20120727175546.GH17427@andromeda.dapyr.net>
Message-ID: <alpine.DEB.2.02.1207301551250.4645@kaball.uk.xensource.com>
References: <1343335407-5465-1-git-send-email-konrad.wilk@oracle.com> <1343335407-5465-2-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1207271204500.26163@kaball.uk.xensource.com> <20120727175546.GH17427@andromeda.dapyr.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2012, Konrad Rzeszutek Wilk wrote:
> On Fri, Jul 27, 2012 at 12:06:27PM +0100, Stefano Stabellini wrote:
> > On Thu, 26 Jul 2012, Konrad Rzeszutek Wilk wrote:
> > > If we boot a 64-bit guest with more than 4GB memory, the SWIOTLB
> > > gets turned on:
> > > PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> > > software IO TLB [mem 0xfb43d000-0xff43cfff] (64MB) mapped at [ffff8800fb43d000-ffff8800ff43cfff]
> > > 
> > > which is OK if we had PCI devices, but not if we did not. In a PV
> > > guest the SWIOTLB ends up asking the hypervisor for precious lowmem
> > > memory - and 64MB of it per guest. On a 32GB machine, this limits the
> > > amount of guests that are 4GB to start due to lowmem exhaustion.
> > > 
> > > What we do is detect whether the user supplied e820_hole=1
> > > parameter, which is used to construct an E820 that is similar to
> > > the machine  - so that the PCI regions do not overlap with RAM regions.
> > > We check for that by looking at the E820 and seeing if it diverges
> > > from the standard - and if so (and if iommu=soft was not turned on),
> > > we disable the check pci_swiotlb_detect_4gb code.
> > 
> > What kind of paramter is it?
> > Is it a Linux cmdline paramter? Or maybe a Xen toolstack parameter?
> 
> Its a guest config option.

Is this option turned on by default if the VM config file contains one
or more PCI devices statically assigned to the VM?

If this option is not specified, is it going to be impossible to
dynamically passthrough a PCI devices after the VM is booted?


> > Surely there must be a better way to let Linux know if this paramter has
> > been turned on than looking for ACPI entries in the E820.
> 
> I am all open for suggestions. The best way I can think of is to have
> some early_init variant of XenBus-detect-this-backend-parameter. Can
> one unhook an "old" XenBus and reset with the full-fledged XenBus
> init later on?

Assuming that the xen swiotlb is only useful for PCI passthrough devices
in PV guests, we could write few wrappers for the current xen_swiotlb
functions like this:

xen_swiotlb_alloc_coherent_new(..)
{
    if (xen_initial_domain() || (xen_pv_domain() && a_pci_device_is_assigned()))
        xen_swiotlb_alloc_coherent();
    else
        return __get_free_pages();
}

do you think it would work?
This way it would be far more flexible.
