Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab0HMGY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 02:24:27 -0400
Received: from sh.osrg.net ([192.16.179.4]:50430 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab0HMGY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 02:24:26 -0400
Date: Fri, 13 Aug 2010 15:23:53 +0900
To: linux@arm.linux.org.uk
Cc: fujita.tomonori@lab.ntt.co.jp, khc@pm.waw.pl, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: ARM: 2.6.3[45] PCI regression (IXP4xx and PXA?)
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100811072532.GA21511@n2100.arm.linux.org.uk>
References: <m3sk2m433u.fsf@intrepid.localdomain>
	<20100811110448S.fujita.tomonori@lab.ntt.co.jp>
	<20100811072532.GA21511@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100813152224H.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 13 Aug 2010 15:23:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Aug 2010 08:25:32 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Wed, Aug 11, 2010 at 11:06:00AM +0900, FUJITA Tomonori wrote:
> > On Tue, 10 Aug 2010 22:36:21 +0200
> > Krzysztof Halasa <khc@pm.waw.pl> wrote:
> > 
> > > 6fee48cd330c68332f9712bc968d934a1a84a32a broke
> > > pci_set_consistent_dma_mask() on IXP4xx and most probably PXA. Affected
> > > devices are e.g. IDE controller (CS5536-based: disk inaccessible) and
> > > e1000 ethernet ("Detected Tx Unit Hang").
> > 
> > Sorry about that.
> > 
> > > The attached patch makes it work again, though I'm not sure it's the
> > > best solution.
> > 
> > I think that we should avoid adding "#ifdef CONFIG_DMABOUNCE" to a
> > generic place.
> > 
> > Why the above patch breaks dmabounce.c? We can't set dev->coherent_dma_mask?
> 
> It doesn't break dmabounce.
> 
> What it breaks is the fact that a PCI device which can do 32-bit DMA is
> connected to a PCI bus which can only access the first 64MB of memory
> through the host bridge, but the system has more than 64MB available.
> 
> Allowing a 32-bit DMA mask means that dmabounce can't detect that memory
> above 64MB needs to be bounced to memory below the 64MB boundary.

But dmabounce doesn't look at dev->coherent_dma_mask.

The change breaks __dma_alloc_buffer()? If we set dev->coherent_dma_mask
to DMA_BIT_MASK(32) for ixp4xx's pci devices, __dma_alloc_buffer()
doesn't use GFP_DMA.
