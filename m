Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab1BOWHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 17:07:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755968Ab1BOWHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 17:07:37 -0500
Date: Tue, 15 Feb 2011 17:03:11 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, dwmw2@infradead.org,
        hancockrwd@gmail.com, Larry.Finger@lwfinger.net
Subject: Re: b44 driver causes panic when using swiotlb
Message-ID: <20110215170311.512b86f7@katamari>
In-Reply-To: <20110214205945W.fujita.tomonori@lab.ntt.co.jp>
References: <20110131105412.7252a09c@katamari>
	<20110201225443U.fujita.tomonori@lab.ntt.co.jp>
	<20110214205945W.fujita.tomonori@lab.ntt.co.jp>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011 20:59:43 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> > Can you try this? b44 has the own bouncing mechanism so if swiotlb
> > returns an error, the driver can allocate an appropriate buffer.
> > 
> > diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> > index c47bbe1..93ca08b 100644
> > --- a/lib/swiotlb.c
> > +++ b/lib/swiotlb.c
> > @@ -686,8 +686,10 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
> >  	/*
> >  	 * Ensure that the address returned is DMA'ble
> >  	 */
> > -	if (!dma_capable(dev, dev_addr, size))
> > -		panic("map_single: bounce buffer is not DMA'ble");
> > +	if (!dma_capable(dev, dev_addr, size)) {
> > +		swiotlb_tbl_unmap_single(dev, map, size, dir);
> > +		dev_addr = swiotlb_virt_to_bus(dev, io_tlb_overflow_buffer);
> > +	}
> >  
> >  	return dev_addr;
> >  }
> 
> Ping, any chance to try this?

The user who reported the bug tried it and says that it works.
