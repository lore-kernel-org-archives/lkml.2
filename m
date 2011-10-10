Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab1JJN7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:59:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55820 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab1JJN7o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:59:44 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.27.118]
In-Reply-To: <20111010094738.GW2138@amd.com>
References: <1316195506-9777-1-git-send-email-ohad@wizery.com>
 <1316195506-9777-2-git-send-email-ohad@wizery.com> <20110927100505.GH2138@amd.com>
 <CAK=WgbahwY+7Ux-RjW2Tw9WBSwZnYuTMZ2NQASWyOXQ3zF6qFg@mail.gmail.com>
 <20110927131222.GL2138@amd.com> <CAK=WgbYG2tpMJ2SikZhm=R9j5kQ6Hm8CGg=q1bko3idzF53Q3Q@mail.gmail.com>
 <20110927181438.GM2138@amd.com> <CAK=WgbbNs5fWHDEputZ=jzU5YN0sn0tf6AETkcsoq_Jbvc2XgQ@mail.gmail.com>
 <20111010094738.GW2138@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 10 Oct 2011 15:59:22 +0200
Message-ID: <CAK=WgbZ7Wyax1yfS1jSXw9OdwMtxxidwLO8PTsNUXX9CWzmVrw@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] iommu/core: split mapping to page sizes as
 supported by the hardware
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ -bouncing Hiroshi.DOYU@nokia.com, +not-bouncing hdoyu@nvidia.com :
hi Hiroshi :) ]

Hi Joerg,

On Mon, Oct 10, 2011 at 11:47 AM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> sorry, I was on vacation last week and had no time to look into this.

Sure thing, thanks for replying!

>> +#include <linux/bitmap.h>
>
> Is this still required?

Nope, removed, thanks.

> Hmm, I thought a little bit about that and came to the conculusion it
> might be best to just keep the page-sizes as a part of the iommu_ops
> structure. So there is no need to extend the register_iommu interface.

Sure. That was one of my initial alternatives, but I decided against
it at that time. I'll bring it back - it will help with the
bus_set_iommu rebasing.

> Also, the bus_set_iommu interface is now in the -next branch. Would be
> good if you rebase the patches to that interface.

Sure. It's a little tricky though: which branch do I base this on ?
Are you ok with me basing this on your 'next' branch ? My current
stack depends at least on three branches of yours, so that would be
helpful for me (and less merging conflicts for you I guess :).

> I think we need some care here and check pgsize for 0. A BUG_ON should
> do.

I can add it if you prefer, but I don't think it can really happen:
basically, it means that we chose a too small and unsupported page
bit, which can't happen as long as we check for IS_ALIGNED(iova |
paddr | size, iommu_min_pagesz) in the beginning of iommu_map.

>> +               unmapped_order = iommu_ops->unmap(domain, iova, order);
>
> I think we should make sure that we call iommu_ops->unmap with the same
> parameters as iommu_ops->map. Otherwise we still need some page-size
> complexity in the iommu-drivers.

Ok, let's discuss the semantics of ->unmap().

There isn't a clear documentation of that API (we should probably add
some kernel docs after we nail it down now), but judging from the
existing users (mainly kvm) and drivers, it seems that iommu_map() and
iommu_unmap() aren't symmetric: users rely on unmap() to return the
actual size that was unmapped. IOMMU drivers, in turn, should check
which page is mapped on 'iova', unmap it, and return its size.

This way iommu_unmap() becomes very simple: it just iterates through
the region, relying on iommu_ops->unmap() to return the sizes that
were actually unmapped (very similar to how amd's iommu_unmap_page
works today). This also means that iommu_ops->unmap() doesn't really
need a size/order argument and we can remove it (after all drivers
fully migrate..).

The other approach which you suggest means symmetric iommu_map() and
iommu_unmap(). It means adding a 'paddr' parameter to iommu_unmap(),
which is easy, but maybe more concerning is the limitation that it
incurs: users will now have to call iommu_unmap() exactly as they
called iommu_map() beforehand. Note sure how well this will fly with
the existing users (kvm ?) and whether we really want to enforce this
(it doesn't mean drivers need to deal with page-size complexity. they
are required to unmap a single page at a time, and iommu_unmap() will
do the work for them).

Another discussion:

I think we better change iommu_ops->map() to directly take a 'size'
(in bytes) instead of an 'order' (of pages). Most (all?) drivers just
immediately do 'size = 0x1000UL << gfp_order', so this whole size ->
order -> size back and forth seems redundant.

> When we pass the size now it makes sense to also return the
> unmapped-size instead of the order.

Sure.

Thanks for your review,
Ohad.
