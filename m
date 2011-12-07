Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab1LGGU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 01:20:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:46986 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab1LGGUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 01:20:55 -0500
Message-ID: <1323238815.660.64.camel@pasglop>
Subject: Re: [PATCH 1/4] iommu: Add iommu_device_group callback and
 iommu_group sysfs entry
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        David Gibson <dwg@au1.ibm.com>, joerg.roedel@amd.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        chrisw@redhat.com, agraf@suse.de, scottwood@freescale.com,
        B08248@freescale.com
Date: Wed, 07 Dec 2011 17:20:15 +1100
In-Reply-To: <1322781257.10893.38.camel@i7.infradead.org>
References: <20111021195412.8438.9951.stgit@s20.home>
	 <20111021195605.8438.81609.stgit@s20.home>
	 <20111130024205.GF5435@truffala.fritz.box>
	 <1322628672.21641.39.camel@pasglop> <1322630751.19120.222.camel@bling.home>
	 <20111201000337.GA5427@truffala.fritz.box>
	 <1322722110.26545.68.camel@bling.home>
	 <1322735610.24294.9.camel@i7.infradead.org>
	 <1322750048.26545.101.camel@bling.home>
	 <1322781257.10893.38.camel@i7.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 23:14 +0000, David Woodhouse wrote:
> On Thu, 2011-12-01 at 07:34 -0700, Alex Williamson wrote:
> > > Btw, did we get a quirk for the Ricoh multi-function devices which all
> > > need to be in the same group because they do all their DMA from function
> > > zero? I think we need another similar quirk for a Marvell SATA
> > > controller which seems to do its AHCI DMA from its IDE function; see
> > > https://bugzilla.redhat.com/757166
> > 
> > No, as I mentioned, groups are currently for iommu_ops, not dma_ops,
> 
> That doesn't matter. There are multiple devices which do all their DMA
> from the same source-id, and which have to be handled together. It
> doesn't *matter* that it's a hardware bug in this case, and it's just
> because they're multiple PCI devices behind a PCIe bridge in the other
> case. The grouping code needs to handle it, whether it's for the benefit
> of iommu_ops, dma_ops, or both.
> 
> > though it makes sense that iommu drivers could use the group info or
> > create common quirk infrastructure for handling broken devices like
> > these. 
> 
> Well, I think we mostly have a consensus that dma_ops should be
> implemented *using* iommu_ops; I'd rather be trying to make things
> *consistent* between the two rather than building up the differences.
> 
> So I'd definitely go for your "use the group info" option. It is the
> *same* info, and needs the *same* quirks.

The problem at this stage is that all implementations proposed for the
group info (both Alex and David) are somewhat higher level stuff that is
itself constructed from the underlying iommu implementation.

And this is probably the right thing to do to avoid breaking too much
stuff at once.

I think the best approach for devices like that is to have a header
quirk setting a new bit flag in pci_dev along the line of
"dma_group_functions" which causes the platform iommu implementation to
"do the right thing" and in turn create the isolation groups accordingly
as well.

Later on, we might want to revisit but I think it's nasty enough to
leave it as-is. The creation of isolation groups will have to answer to
all sort of other platform specific constraints so I'd rather not try to
put too much of that logic in generic code.

Cheers,
Ben.



