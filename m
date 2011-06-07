Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab1FGLkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 07:40:01 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:46841 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab1FGLkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 07:40:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [RFC 1/6] omap: iommu: generic iommu api migration
Date: Tue, 7 Jun 2011 13:40:14 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37-gentoo-r3; KDE/4.6.2; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hiroshi.DOYU@nokia.com, arnd@arndb.de, davidb@codeaurora.org,
        Joerg.Roedel@amd.com
References: <1307053663-24572-1-git-send-email-ohad@wizery.com> <201106071122.47804.laurent.pinchart@ideasonboard.com> <BANLkTineGVvmph=Om2FGR_+mkiMW6k7UAw@mail.gmail.com>
In-Reply-To: <BANLkTineGVvmph=Om2FGR_+mkiMW6k7UAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106071340.15199.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On Tuesday 07 June 2011 13:19:05 Ohad Ben-Cohen wrote:
> On Tue, Jun 7, 2011 at 12:22 PM, Laurent Pinchart wrote:
> >> +     BUG_ON(!IS_ALIGNED((long)omap_domain->pgtable, IOPGD_TABLE_SIZE));
> > 
> > Either __get_free_pages() guarantees that the allocated memory will be
> > aligned on an IOPGD_TABLE_SIZE boundary, in which case the BUG_ON() is
> > unnecessary, or doesn't offer such guarantee, in which case the BUG_ON()
> > will oops randomly.
> 
> Curious, does it oops randomly today ?
> (i just copied this from omap_iommu_probe, where it always existed).

No that I know of :-)

> It is a bit ugly though, and thinking on it again, 16KB is not that
> big. We can just use kmalloc here, which does ensure the alignment
> (or, better yet, kzalloc, and then ditch the memset).
> 
> > In both cases BUG_ON() should probably be avoided.
> 
> I disagree; we must check this so user data won't be harmed (hardware
> requirement), and if a memory allocation API fails to meet its
> requirements - that's really bad and user data is again at stake (much
> more will break, not only the iommu driver).

My point is that if the allocator guarantees the alignment (not as a side 
effect of the implementation, but per its API) there's no need to check it 
again. As the alignement is required, we need an allocator that guarantees it 
anyway.

> > This leaks omap_domain->pgtable.
> > 
> > The free_pages() call in omap_iommu_remove() should be removed, as
> > omap_iommu_probe() doesn't allocate the pages table anymore.
> 
> thanks !
> 
> > You can also remove the the struct iommu::iopgd field.
> 
> No, I can't; it's used when the device is attached to an address space
> domain.

Right, my bad.

> > You return 0 in the bogus pte/pgd cases. Is that intentional ?
> 
> Yes, that's probably the most (if any) reasonable value to return here
> (all other iommu implementations are doing so too).

-- 
Regards,

Laurent Pinchart
