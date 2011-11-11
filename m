Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab1KKM6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 07:58:46 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:51933 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab1KKM6n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 07:58:43 -0500
X-SpamScore: -18
X-BigFish: VPS-18(zzc89bh1432N98dKzz1202hzz15d4Rz32i668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LUHYPR-01-1IL-02
X-M-MSG: 
Date: Fri, 11 Nov 2011 13:58:37 +0100
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
Subject: Re: [PATCH v4 2/7] iommu/core: split mapping to page sizes as
 supported by the hardware
Message-ID: <20111111125837.GF13213@amd.com>
References: <1318850846-16066-1-git-send-email-ohad@wizery.com>
 <1318850846-16066-3-git-send-email-ohad@wizery.com>
 <CANqQZNH1YRSgYRVxceicQ3szD=t7zeJjhJKEQ30PeKsxtj5V+A@mail.gmail.com>
 <1320938930.22195.17.camel@i7.infradead.org>
 <20111110170918.GE13213@amd.com>
 <1320953319.535.11.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1320953319.535.11.camel@i7.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 07:28:39PM +0000, David Woodhouse wrote:

> ... which implies that a mapping, once made, might *never* actually get
> torn down until we loop and start reusing address space? That has
> interesting security implications.

Yes, it is a trade-off between security and performance. But if the user
wants more security the unmap_flush parameter can be used.

> Is it true even for devices which have been assigned to a VM and then
> unassigned?

No, this is only used in the DMA-API path. The device-assignment code
uses the IOMMU-API directly. There the IOTLB is always flushed on unmap.

> > There is something similar on the AMD IOMMU side. There it is called
> > unmap_flush.
> 
> OK, so that definitely wants consolidating into a generic option.

Agreed.

> > Some time ago I proposed the iommu_commit() interface which changes
> > these requirements. With this interface the requirement is that after a
> > couple of map/unmap operations the IOMMU-API user has to call
> > iommu_commit() to make these changes visible to the hardware (so mostly
> > sync the IOTLBs). As discussed at that time this would make sense for
> > the Intel and AMD IOMMU drivers.
> 
> I would *really* want to keep those off the fast path (thinking mostly
> about DMA API here, since that's the performance issue). But as long as
> we can achieve that, that's fine.

For AMD IOMMU there is a feature called not-present cache. It says that
the IOMMU caches non-present entries as well and needs an IOTLB flush
when something is mapped (meant for software implementations of the
IOMMU).
So it can't be really taken out of the fast-path. But the IOMMU driver
can optimize the function so that it only flushes the IOTLB when there
was an unmap-call before. It is also an improvement over the current
situation where every iommu_unmap call results in a flush implicitly.
This pretty much a no-go for using IOMMU-API in DMA mapping at the
moment.

> But also, it's not *so* much of an issue to divide the space up even
> when it's limited. The idea was not to have it *strictly* per-CPU, but
> just for a CPU to try allocating from "its own" subrange first, and then
> fall back to allocating a new subrange, and *then* fall back to
> allocating from subranges "belonging" to other CPUs. It's not that the
> allocation from a subrange would be lockless — it's that the lock would
> almost never leave the l1 cache of the CPU that *normally* uses that
> subrange.

Yeah, I get the idea. I fear that the memory consumption will get pretty
high with that approach. It basically means one round-robin allocator
per cpu and device. What does that mean on a 4096 CPU machine :)
How much lock contention will be lowered also depends on the work-load.
If dma-handles are frequently freed from another cpu than they were
allocated from the same problem re-appears.
But in the end we have to try it out and see what works best :)


Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

