Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab1KKNSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 08:18:12 -0500
Received: from mail-va3.bigfish.com ([216.32.180.10]:35700 "EHLO
	VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750863Ab1KKNSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 08:18:10 -0500
X-SpamScore: -12
X-BigFish: VPS-12(z1039oz1432N98dKzz1202hzz15d4Rz2dh668h839h944h64h)
X-Spam-TCS-SCL: 3:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LUHZLO-01-2OJ-02
X-M-MSG: 
Date: Fri, 11 Nov 2011 14:17:28 +0100
From: Joerg Roedel <Joerg.Roedel@amd.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: Kai Huang <mail.kai.huang@gmail.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        <iommu@lists.linux-foundation.org>, <linux-omap@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        KyongHo Cho <pullip.cho@samsung.com>, <kvm@vger.kernel.org>
Subject: Changing IOMMU-API for generic DMA-mapping supported by the hardware
Message-ID: <20111111131728.GG13213@amd.com>
References: <1318850846-16066-1-git-send-email-ohad@wizery.com>
 <1318850846-16066-3-git-send-email-ohad@wizery.com>
 <CANqQZNH1YRSgYRVxceicQ3szD=t7zeJjhJKEQ30PeKsxtj5V+A@mail.gmail.com>
 <1320938930.22195.17.camel@i7.infradead.org>
 <20111110170918.GE13213@amd.com>
 <1320953319.535.11.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1320953319.535.11.camel@i7.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, seperate thread for this one.

On Thu, Nov 10, 2011 at 07:28:39PM +0000, David Woodhouse wrote:
> > The plan is to have a single DMA-API implementation for all IOMMU
> > drivers (X86 and ARM) which just uses the IOMMU-API. But to make this
> > performing reasonalbly well a few changes to the IOMMU-API are required.
> > I already have some ideas which we can discuss if you want.
> 
> Yeah, that sounds useful.

As I said some changes to the IOMMU-API are required in my opinion.
These changes should also allow it to move over old-style IOMMUs like
Calgary or GART later.

The basic idea is that IOMMU drivers should be required to put every
device they are responsible for into a default domain. The DMA mapping
code can query this default domain for each device.

Also the default domain has capabilities that can be queried. Those
capabilities include the size and offset of the address space they can
re-map. For GART and Calgary this will be the aperture, for VT-d and AMD
IOMMU the whole 64bit address space. Another capability is whether
addresses outside of that area are 1-1 mapped or no accessible to the
device.

The generic DMA-mapping code will use that information to initialize its
allocator and uses iommu_map/iommu_unmap to create and destroy mappings
as requested by the DMA-API (but the DMA-mapping code does not need to
create a domain of its own).

The good thing about these default domains is that IOMMU drivers can
implement their own optimizations on it. The AMD IOMMU driver for
example already makes a distinction between dma-mapping domains and
other protection-domains. The optimization for dma-mapping domains is
that the leaf-pages of the page-table are keept in an array so that it
is very easy to find the PTE for an address. Those optimizations are
still possible with the default-domain concept.

In short, the benefits of the default-domain concept are:

	1) It allows existing optimizations for the DMA-mapping code
	   paths to persist
	2) It also fits old-style IOMMUs like GART, Calgary and others

An open problem is how to report reserved ranges of an address-space.
These ranges might exist from a BIOS requirement for 1-1 mapping of
certain address ranges (in AMD jargon: Unity mapped ranges, something
similar exists on VT-d afaik) or hardware requirements like the reserved
address range used for MSI interrupts.

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

