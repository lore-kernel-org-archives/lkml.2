Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab2KNFu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:50:59 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:50152 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab2KNFu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:56 -0500
Message-ID: <50A3313D.1000809@gmail.com>
Date: Wed, 14 Nov 2012 00:50:53 -0500
From: Xi Wang <xi.wang@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Dahlmann <dahlmann.thomas@arcor.de>,
        Felipe Balbi <balbi@ti.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] mm: fix null dev in dma_pool_create()
References: <1352097996-25808-1-git-send-email-xi.wang@gmail.com> <50A2BE19.7000604@gmail.com> <20121113165847.4dcf968c.akpm@linux-foundation.org>
In-Reply-To: <20121113165847.4dcf968c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/12 7:58 PM, Andrew Morton wrote:
> I'm not sure that I really suggested doing this :(

You suggested WARN_ON_ONCE(!dev); I changed it to WARN_ON(!dev) and
kept the NULL check..
 
> We know there are a few scruffy drivers which are passing in dev==0.
> 
> Those drivers don't oops because nobody is testing them on NUMA
> systems.
> 
> With this patch, the kernel will now cause runtime warnings to be
> emitted from those drivers.  Even on non-NUMA systems.
> 
> This is a problem!  What will happen is that this code will get
> released by Linus and will propagate to users mainly via distros and
> eventually end-user bug reports will trickle back saying "hey, I got
> this warning".  Slowly people will fix the scruffy drivers and those
> fixes will propagate out from Linus's tree into -stable and then into
> distros and then into the end-users hands.
> 
> This is *terribly* inefficient!  It's a lot of work for a lot of people
> and it involves long delays.
> 
> So let's not do any of that!  Let us try to get those scruffy drivers
> fixed up *before* we add this warning.
> 
> As a nice side-effect of that work, we can then clean up the dmapool
> code so it doesn't need to worry about handling the dev==0 special
> case.
> 
> So.  To start this off, can you please generate a list of the offending
> drivers?  Then we can hunt down the maintainers and we'll see what can be
> done.

I like this plan.

Here's the list of drivers that invoke dma_pool_create() with NULL dev,
as well as possible fixes, from previous emails.

* arch/arm/mach-s3c64xx/dma.c

Use dmac->dev for dma_pool_create() in s3c64xx_dma_init1()?  Probably
need to add ->dma_pool to struct s3c64xx_dmac.

* drivers/usb/gadget/amd5536udc.c (2)

Use dev->gadget.dev or dev->pdev->dev for dma_pool_create()?  Also move
the init_dma_pools() call after the assignments in udc_pci_probe().

* drivers/net/wan/ixp4xx_hss.c
* drivers/net/ethernet/xscale/ixp4xx_eth.c

Use port->netdev->dev for dma_pool_create()?
