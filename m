Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1BNMAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 07:00:37 -0500
Received: from sh.osrg.net ([192.16.179.4]:60142 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab1BNMAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 07:00:34 -0500
Date: Mon, 14 Feb 2011 20:59:43 +0900
To: cebbert@redhat.com
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, dwmw2@infradead.org,
        hancockrwd@gmail.com, Larry.Finger@lwfinger.net
Subject: Re: b44 driver causes panic when using swiotlb
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20110201225443U.fujita.tomonori@lab.ntt.co.jp>
References: <20110131105412.7252a09c@katamari>
	<20110201225443U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110214205945W.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 14 Feb 2011 20:59:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011 22:54:56 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Mon, 31 Jan 2011 10:54:12 -0500
> Chuck Ebbert <cebbert@redhat.com> wrote:
> 
> > The b44 driver is triggering this panic in swiotlb_map_page():
> > 
> >         if (!dma_capable(dev, dev_addr, size))
> >                 panic("map_single: bounce buffer is not DMA'ble");
> > 
> > The kernel log says the bounce buffers are at 0xdb400000, but b44 can
> > only do DMA to the first 1GB of memory:
> 
> Can you try this? b44 has the own bouncing mechanism so if swiotlb
> returns an error, the driver can allocate an appropriate buffer.
> 
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index c47bbe1..93ca08b 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -686,8 +686,10 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
>  	/*
>  	 * Ensure that the address returned is DMA'ble
>  	 */
> -	if (!dma_capable(dev, dev_addr, size))
> -		panic("map_single: bounce buffer is not DMA'ble");
> +	if (!dma_capable(dev, dev_addr, size)) {
> +		swiotlb_tbl_unmap_single(dev, map, size, dir);
> +		dev_addr = swiotlb_virt_to_bus(dev, io_tlb_overflow_buffer);
> +	}
>  
>  	return dev_addr;
>  }

Ping, any chance to try this?


Thanks,
