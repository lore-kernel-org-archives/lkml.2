Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab2FUGqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 02:46:23 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13711 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab2FUGqV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 02:46:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 20 Jun 2012 23:46:21 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "arnd@arndb.de" <arnd@arndb.de>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Date: Thu, 21 Jun 2012 08:46:11 +0200
Subject: Re: [PATCH 1/5] iommu/tegra: smmu: Add DMA window parser,
 of_get_dma_window()
Thread-Topic: [PATCH 1/5] iommu/tegra: smmu: Add DMA window parser,
 of_get_dma_window()
Thread-Index: Ac1PeY+PJI3SD18jSU6rPuULQgwIrw==
Message-ID: <20120621.094611.2108645748323641310.hdoyu@nvidia.com>
References: <20120521124707.GC2604@amd.com><1340176620-13012-1-git-send-email-hdoyu@nvidia.com><4FE20457.8090307@wwwdotorg.org>
In-Reply-To: <4FE20457.8090307@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Warren <swarren@wwwdotorg.org> wrote @ Wed, 20 Jun 2012 19:11:51 +0200:

> On 06/20/2012 01:16 AM, Hiroshi DOYU wrote:
> > From: Hiroshi Doyu <hdoyu@nvidia.com>
> > 
> > This code was based on:
> >     "arch/microblaze/kernel/prom_parse.c"
> >     "arch/powerpc/kernel/prom_parse.c"
> > 
> > Can be promoted as a global function for general use to replace
> > "of_parse_dma_window()" in the above. This supports different formats
> > flexibly. "prefix" can be configured if any. "busno" and "index" are
> > optionally specified. Set NULL and 0 if not used.
> > 
> > Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> > ---
> > Based on the discussion:
> > http://marc.info/?l=linux-tegra&m=133732046606458&w=2
> 
> Hmmm. This function really should be in some common location and
> available for all drivers to use. Can't we add it to that common
> location from the start? What prevented the earlier patch that did this
> from getting merged into 3.5?

It's because there was no feedback against the original patches(the
common location ones, *1,*2) from DT side.

*1: http://article.gmane.org/gmane.linux.ports.tegra/4468
*2: https://lkml.org/lkml/2012/4/30/153

> One thing that might help here would be /not/ to add the common code to
> drivers/of/of_dma.c as was done in the earlier revisions of this patch -
> I believe that Grant has been trying to push subsystem-specific OF
> functionality into files in those individual subsystems, so that
> drivers/of can be kept for core support. Perhaps this patch should
> create drivers/iommu/of_iommu.c or similar?

"drivers/iommu/of_iommu.c" seems quite reasonable for this function.

> But I wonder: Is this function likely to be useful outside of
> drivers/iommu/ - you mentioned that similar code already exists in the
> two arch-specific prom_parse.c files; where are the existing users of
> those functions. If not in drivers/iommu/, then probably drivers/iommu/
> isn't a good place to put the new common function...

There are the following 3 users of of_parse_dma_window() as below. All
of them are IOMMU related, but they are architecture specific ones,
not for the standard IOMMU API. I guess that the current trend is to
convert Arch specific IOMMU API to the standard one basically.

  arch/powerpc/kernel/vio.c 	of_parse_dma_window(dev->dev.of_node, dma_window,
  arch/powerpc/platforms/cell/iommu.c 	of_parse_dma_window(np, dma_window, &index, base, size);
  arch/powerpc/platforms/pseries/iommu.c 	of_parse_dma_window(dn, dma_window, &tbl->it_index, &offset, &size);

I think that the common "dma-window" DT parser is necessary for the
standard IOMMU because "dma-window" info is dealt as
DOMAIN_ATTR_GEOMETRY in the following Joerg's patch too.

  [PATCH 0/5] IOMMU: Make IOMMU-API ready for GART-like hardware
    https://lkml.org/lkml/2012/1/19/170

If it's ok to have of_get_dma_window() in "drivers/iommu/of_iommu.c",
I'll post that version.

Any comment?
