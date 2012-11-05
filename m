Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab2KEV0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 16:26:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55314 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2KEV0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 16:26:53 -0500
Date: Mon, 5 Nov 2012 13:26:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Xi Wang <xi.wang@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix NULL checking in dma_pool_create()
Message-Id: <20121105132651.f52549b6.akpm@linux-foundation.org>
In-Reply-To: <50982698.7050605@gmail.com>
References: <1352097996-25808-1-git-send-email-xi.wang@gmail.com>
	<20121105123738.0a0490a7.akpm@linux-foundation.org>
	<50982698.7050605@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Nov 2012 15:50:32 -0500
Xi Wang <xi.wang@gmail.com> wrote:

> On 11/5/12 3:37 PM, Andrew Morton wrote:
> > 
> > Well, the dma_pool_create() kerneldoc does not describe dev==NULL to be
> > acceptable usage and given the lack of oops reports, we can assume that
> > no code is calling this function with dev==NULL.
> > 
> > So I think we can just remove the code which handles dev==NULL?
> 
> Actually, a quick grep gives the following...
> 
> arch/arm/mach-s3c64xx/dma.c:731:	dma_pool = dma_pool_create("DMA-LLI", NULL, sizeof(struct pl080s_lli), 16, 0);
> drivers/usb/gadget/amd5536udc.c:3136:	dev->data_requests = dma_pool_create("data_requests", NULL,
> drivers/usb/gadget/amd5536udc.c:3148:	dev->stp_requests = dma_pool_create("setup requests", NULL,
> drivers/net/wan/ixp4xx_hss.c:973:		if (!(dma_pool = dma_pool_create(DRV_NAME, NULL,
> drivers/net/ethernet/xscale/ixp4xx_eth.c:1106:		if (!(dma_pool = dma_pool_create(DRV_NAME, NULL,
> 

OK, so it seems that those drivers have never been tested on a
CONFIG_NUMA kernel.  whee.

So we have a large amount of code here which ostensibly supports
dev==NULL but which has not been well tested.  Take a look at
dma_alloc_coherent(), dma_free_coherent() - are they safe?  Unobvious.

dmam_pool_destroy() will clearly cause an oops:

devres_destroy()
->devres_remove()
  ->spin_lock_irqsave(&dev->devres_lock, flags);


So what to do?

I'm thinking we should disallow dev==NULL.  We have a lot of code in
mm/dmapool.c which _attempts_ to support this case, but is largely
untested and obviously isn't working.  I don't think it's a good idea
to try to fix up and then support this case on behalf of a handful of
scruffy drivers.  It would be better to fix the drivers, then simplify
the core code.  drivers/usb/gadget/amd5536udc.c can probably use
dev->gadget.dev and drivers/net/wan/ixp4xx_hss.c can probably use
port->netdev->dev, etc.

So how about we add a WARN_ON_ONCE(dev == NULL), notify the driver maintainers
and later we can remove all that mm/dmapool.c code which is trying to
handle dev==NULL?

