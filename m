Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab1BAB2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 20:28:40 -0500
Received: from sh.osrg.net ([192.16.179.4]:39024 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251Ab1BAB2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 20:28:39 -0500
Date: Tue, 1 Feb 2011 10:28:00 +0900
To: hancockrwd@gmail.com
Cc: ak@linux.intel.com, cebbert@redhat.com, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org
Subject: Re: b44 driver causes panic when using swiotlb
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4D4759BD.2000006@gmail.com>
References: <20110131105412.7252a09c@katamari>
	<20110131163639.GA32095@tassilo.jf.intel.com>
	<4D4759BD.2000006@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110201102707C.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 01 Feb 2011 10:28:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011 18:54:21 -0600
Robert Hancock <hancockrwd@gmail.com> wrote:

> On 01/31/2011 10:36 AM, Andi Kleen wrote:
> > On Mon, Jan 31, 2011 at 10:54:12AM -0500, Chuck Ebbert wrote:
> >> The b44 driver is triggering this panic in swiotlb_map_page():
> >>
> >>          if (!dma_capable(dev, dev_addr, size))
> >>                  panic("map_single: bounce buffer is not DMA'ble");
> >>
> >> The kernel log says the bounce buffers are at 0xdb400000, but b44 can
> >> only do DMA to the first 1GB of memory:
> >
> > b44 needs to use GFP_DMA then and do its own custom bouncing.
> > The standard pci_map_* bounce buffering is only designed for at least
> > 32bit capable devices.
> 
> That seems wrong - it's a documented API and that restriction isn't 
> documented. Either it should comply with the request or return a failure 
> if it can't accomodate it, not just blow up internally. There's no 
> reason the driver should have to deal with this on its own.
> 
> In this case the DMA mapping code  should really be falling back to 
> GFP_DMA automatically if the IOMMU aperture is outside the DMA mask of 
> the device.

swiotlb allocates the bounce buffer when a system boots up. We can't
allocate much in GFP_DMA. swiotlb uses somewhere under 4GB. So it
can't help devices that have odd dma_mask (that is, except for 4GB).

Unfortunately, Such device needs to do own custom bouncing or needs
their subsystem to does that.

Some ideas to implement something that works for such device were
discussed. Seems that the conclusion is that it's doesn't worth making
the common code complicated for such minor and insane devices.
