Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab2G0Rzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 13:55:52 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:52657 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab2G0Rzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 13:55:51 -0400
Date: Fri, 27 Jul 2012 13:55:46 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/2] xen/swiotlb: If iommu=soft was not passed in on > 4GB, don't turn it on.
Message-ID: <20120727175546.GH17427@andromeda.dapyr.net>
References: <1343335407-5465-1-git-send-email-konrad.wilk@oracle.com> <1343335407-5465-2-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1207271204500.26163@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1207271204500.26163@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 12:06:27PM +0100, Stefano Stabellini wrote:
> On Thu, 26 Jul 2012, Konrad Rzeszutek Wilk wrote:
> > If we boot a 64-bit guest with more than 4GB memory, the SWIOTLB
> > gets turned on:
> > PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> > software IO TLB [mem 0xfb43d000-0xff43cfff] (64MB) mapped at [ffff8800fb43d000-ffff8800ff43cfff]
> > 
> > which is OK if we had PCI devices, but not if we did not. In a PV
> > guest the SWIOTLB ends up asking the hypervisor for precious lowmem
> > memory - and 64MB of it per guest. On a 32GB machine, this limits the
> > amount of guests that are 4GB to start due to lowmem exhaustion.
> > 
> > What we do is detect whether the user supplied e820_hole=1
> > parameter, which is used to construct an E820 that is similar to
> > the machine  - so that the PCI regions do not overlap with RAM regions.
> > We check for that by looking at the E820 and seeing if it diverges
> > from the standard - and if so (and if iommu=soft was not turned on),
> > we disable the check pci_swiotlb_detect_4gb code.
> 
> What kind of paramter is it?
> Is it a Linux cmdline paramter? Or maybe a Xen toolstack parameter?

Its a guest config option.

> 
> Surely there must be a better way to let Linux know if this paramter has
> been turned on than looking for ACPI entries in the E820.

I am all open for suggestions. The best way I can think of is to have
some early_init variant of XenBus-detect-this-backend-parameter. Can
one unhook an "old" XenBus and reset with the full-fledged XenBus
init later on?
