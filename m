Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab0G2NB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 09:01:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54272 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab0G2NB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 09:01:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
Date: Thu, 29 Jul 2010 15:01:35 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-8-generic; KDE/4.3.2; x86_64; ; )
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "stepanm@codeaurora.org" <stepanm@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20100729090607.GN26098@amd.com> <201007291325.48129.arnd@arndb.de> <20100729121202.GR26098@amd.com>
In-Reply-To: <20100729121202.GR26098@amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007291501.35583.arnd@arndb.de>
X-Provags-ID: V02:K0:5uPOzchc3DHkChYxGwoyzSf64HwJkuwAvST46T5ZrA8
 rEhIHd905DeFkBHIMjAphFwl5CB+28BAmZc+ZP8j2GxNW0y9/0
 yGdSqw53tsF57QSh6NU3DJDLnPDPfW0iWo4yFVofHfw12Vt+zX
 5D8sCYNMgwlNq94W7pgXnHtSF4Y6OE86FMePMHIzckK0XDGL1H
 hge+42dhvCTf6ILCKBBPw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 July 2010, Roedel, Joerg wrote:
> On Thu, Jul 29, 2010 at 07:25:47AM -0400, Arnd Bergmann wrote:
> > On Thursday 29 July 2010, Roedel, Joerg wrote:
> > 
> > > > You designed it for what you need at the time. It should have been
> > > > named appropriately to avoid confusion. Later, when we actually
> > > > understand what other IOMMUs need, we can evolve the specific API for
> > > > generic purposes. Then we can rename the API to more generic.
> > > 
> > > At the time the iommu-api was written is was generic enough for what we
> > > had. So it was designed as an generic API. At this point in time nobody
> > > knew what the future requirements would we. So today it turns out that
> > > it is not generic enough anymore for latest hardware. The logical
> > > consequence is to fix this in the iommu-api.
> > 
> > Well, I think the real question is why we have two APIs that both claim
> > to work with IOMMUs in a generic way and how we could unify the two.
> 
> The DMA-API itself does not claim to be an iommu-frontend. The purpose
> of the DMA-API is to convert physical memory addresses into dma handles
> and do all the management of these handles. Backend implementations can
> use hardware iommus for this task. But depending on the hardware in the
> system the DMA-API can very well be implemented without any hardware
> support. This is an important difference to the IOMMU-API which needs
> hardware because it exposes hardware iommu features to software.

Well, you could call that a limitation in the IOMMU API ;-)

The idea behind the DMA mapping API is to allow a device driver
to work without knowing if the hardware can, cannot or must use
an IOMMU.

> > I really think we should not extend the (KVM) IOMMU API further but
> > just use the generic DMA mapping api for KVM and extend it as necessary.
> > It already has the concept of cache coherency and mapping/unmapping
> > that are in the IOMMU API and could be extended to support domains
> > as well, through the use of dma_attrs.
> 
> If we find a nice and clean way to expose lower-level iommu
> functionality through the DMA-API, thats fine. We could certainly
> discuss ideas in this direction.  I think this is going to be hard
> because the DMA-API today does not provide enough flexibility to let the
> user choose both sides of a io-virtual<->cpu-physical address mapping.
> Thats fine for most drivers because it makes sense for them to use the
> generic io-address-allocator the DMA-API provides but not for KVM which
> needs this flexibility.

One way to do this would be to add a new attribute, e.g.

enum dma_attr {
        DMA_ATTR_WRITE_BARRIER,
        DMA_ATTR_WEAK_ORDERING,
	DMA_ATTR_FIXED_MAPPING, /* this one is new */
        DMA_ATTR_MAX,
};

struct dma_attrs {
        unsigned long flags[__DMA_ATTRS_LONGS];
	dma_add_t dest;
};

Nothing except for KVM would need to use that attribute, and KVM would
obviously need a way to check if this is supported by the underlying
implementation.

	Arnd
