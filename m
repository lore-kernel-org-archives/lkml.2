Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab1C3TPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 15:15:52 -0400
Received: from sous-sol.org ([216.99.217.87]:51432 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932169Ab1C3TPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 15:15:50 -0400
Date: Wed, 30 Mar 2011 12:15:11 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Mike Travis <travis@sgi.com>
Cc: Chris Wright <chrisw@sous-sol.org>, David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        iommu@lists.linux-foundation.org, Mike Habeck <habeck@sgi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Intel pci: Remove Host Bridge devices from identity
 mapping
Message-ID: <20110330191511.GS18712@sequoia.sous-sol.org>
References: <20110329233602.272459647@gulag1.americas.sgi.com>
 <20110329233602.439245439@gulag1.americas.sgi.com>
 <20110330175137.GQ18712@sequoia.sous-sol.org>
 <4D9376DE.1060207@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9376DE.1060207@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Travis (travis@sgi.com) wrote:
> Chris Wright wrote:
> >* Mike Travis (travis@sgi.com) wrote:
> >>    When the IOMMU is being used, each request for a DMA mapping requires
> >>    the intel_iommu code to look for some space in the DMA mapping table.
> >>    For most drivers this occurs for each transfer.
> >>
> >>    When there are many outstanding DMA mappings [as seems to be the case
> >>    with the 10GigE driver], the table grows large and the search for
> >>    space becomes increasingly time consuming.  Performance for the
> >>    10GigE driver drops to about 10% of it's capacity on a UV system
> >>    when the CPU count is large.
> >
> >That's pretty poor.  I've seen large overheads, but when that big it was
> >also related to issues in the 10G driver.  Do you have profile data
> >showing this as the hotspot?
> 
> Here's one from our internal bug report:
> 
> Here is a profile from a run with iommu=on  iommu=pt  (no forcedac)

OK, I was actually interested in the !pt case.  But this is useful
still.  The iova lookup being distinct from the identity_mapping() case.

> uv48-sys was receiving and uv-debug sending.
> ksoftirqd/640 was running at approx. 100% cpu utilization.
> I had pinned the nttcp process on uv48-sys to cpu 64.
> 
> # Samples: 1255641
> #
> # Overhead        Command  Shared Object  Symbol
> # ........  .............  .............  ......
> #
>    50.27%ESC[m  ksoftirqd/640  [kernel]       [k] _spin_lock
>    27.43%ESC[m  ksoftirqd/640  [kernel]       [k] iommu_no_mapping

> ...
>      0.48%  ksoftirqd/640  [kernel]       [k] iommu_should_identity_map
>      0.45%  ksoftirqd/640  [kernel]       [k] ixgbe_alloc_rx_buffers    [
> ixgbe]

Note, ixgbe has had rx dma mapping issues (that's why I wondered what
was causing the massive slowdown under !pt mode).

<snip>
> I tracked this time down to identity_mapping() in this loop:
> 
>       list_for_each_entry(info, &si_domain->devices, link)
>               if (info->dev == pdev)
>                       return 1;
> 
> I didn't get the exact count, but there was approx 11,000 PCI devices
> on this system.  And this function was called for every page request
> in each DMA request.

Right, so this is the list traversal (and wow, a lot of PCI devices).
Did you try a smarter data structure? (While there's room for another
bit in pci_dev, the bit is more about iommu implementation details than
anything at the pci level).

Or the domain_dev_info is cached in the archdata of device struct.
You should be able to just reference that directly.

Didn't think it through completely, but perhaps something as simple as:

	return pdev->dev.archdata.iommu == si_domain;

thanks,
-chris
