Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab1GGNyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:54:23 -0400
Received: from bar.sig21.net ([80.81.252.164]:49511 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab1GGNyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:54:22 -0400
Date: Thu, 7 Jul 2011 15:53:59 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Daniel Mack <zonque@gmail.com>
Cc: linux-usb@vger.kernel.org, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, Clemens Ladisch <clemens@ladisch.de>,
        florian@mickler.org, pedrib@gmail.com, William Light <wrl@illest.net>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Allocating buffers for USB transfers (again)
Message-ID: <20110707135359.GA4000@sig21.net>
References: <CACTFLANCYMXH=z+NxEF0aqpMGZp21Q16_uB=J3rndM3pW74qeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACTFLANCYMXH=z+NxEF0aqpMGZp21Q16_uB=J3rndM3pW74qeA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -3.8 (---)
X-Spam-21-Report: No, score=-3.8 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.631,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 01:53:46PM +0200, Daniel Mack wrote:
> So my approach was to force the driver using memory that is DMA
> coherent, which leads to 32bit addressable memory if the device's
> DMA_MASK is set accordingly. Other drivers do the same, and the patch
> for doing this is found here: http://lkml.org/lkml/2010/5/7/61. Users
> that see the bug all report that this patch fixes their problem with
> my driver. However, it was rejected back then as other developers said
> it was fixing the wrong end, and that the driver doesn't necessarily
> need coherent memory.

I think this is a valid approach, and since it avoids
using bounce buffers it is potentially better wrt performance.
BTW, usb_alloc_coherent() doc comment says you need to set the
URB_NO_TRANSFER_DMA_MAP flag, which your patch fails to do.

> Takashi recently posted a patch to the bugzilla entry which uses a
> different approach: it introduces a function to determine suitable GFP
> flags for USB devices, and passes __DMA32 to kmalloc() eventually.
> However, using this flags directly with the SLUB allocator is illegal
> and causes a BUG() in mm/slub.c, cache_grow().

from gfp.h:
  /* Do not use these with a slab allocator */
  #define GFP_SLAB_BUG_MASK (__GFP_DMA32|__GFP_HIGHMEM|~__GFP_BITS_MASK)

I think it means you can only use __GFP_DMA32 for
get_free_pages(), not for kmalloc().

> 2. Find out exactly why these machines fail to install bounce buffers
> or set up their IOMMU correctly

I think this needs to be done.


Johannes
