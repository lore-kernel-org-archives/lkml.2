Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab1FCPxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:53:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63777 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab1FCPxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:53:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [RFC 0/6] iommu: generic api migration and grouping
Date: Fri, 3 Jun 2011 17:53:15 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        laurent.pinchart@ideasonboard.com, Hiroshi.DOYU@nokia.com,
        davidb@codeaurora.org, Joerg.Roedel@amd.com,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <1307053663-24572-1-git-send-email-ohad@wizery.com>
In-Reply-To: <1307053663-24572-1-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106031753.16095.arnd@arndb.de>
X-Provags-ID: V02:K0:df7YqaqRHk3H/g9Pj9vKvPpYLZcGreM1KoQzZeUBKH+
 GXxAu4lM2IIXSHKk9bciYhMOK6n/x7HnzFgp4Xyj8RB6TvOySV
 jhXNWr9C1MqSYoaBhUV0CkyhoyLqK9WXzA4JpMD5pDSdbutZLA
 xhRF0vdg4SKL2r8+kO69U4CHaJVOUaVNqIqErIf1MKpNl7kGeV
 ha0wnAlWKU6w3E4OtmUNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 June 2011, Ohad Ben-Cohen wrote:
> First stab at iommu consolidation:

Hi Ohad,

Great to see your progress here!
 
> - Migrate OMAP's iommu driver to the generic iommu API. With this in hand,
>   users can now start using the generic iommu layer instead of calling
>   omap-specific iommu API.
> 
>   New code that requires functionality missing from the generic iommu api,
>   will add that functionality in the generic framework (e.g. adding framework
>   awareness to multi page sizes, supported by the underlying hardware, will
>   avoid the otherwise-inevitable code duplication when mapping a memory
>   region).
>
>   OMAP-specific api that is still exposed in the omap iommu driver can
>   now be either moved to the generic iommu framework, or just removed (if not
>   used).
> 
>   This api (and other omap-specific primitives like struct iommu) needs to
>   be omapified (i.e. renamed to include an 'omap_' prefix). At this early
>   point of this patch set this is too much churn though, so I'll do that
>   in the following iteration, after (and if), the general direction is
>   accepted.

Sounds all good.

> - Migrate OMAP's iovmm (virtual memory manager) driver to the generic
>   iommu API. With this in hand, iovmm no longer uses omap-specific api
>   for mapping/unmapping operations. Nevertheless, iovmm is still coupled
>   with omap's iommu even with this change: it assumes omap page sizes,
>   and it uses omap's iommu objects to maintain its internal state.
> 
>   Further generalizing of iovmm strongly depends on our broader plans for
>   providing a generic virtual memory manager and allocation framework
>   (which, as discussed, should be separated from a specific mapper).
> 
>   iovmm has a mainline user: omap3isp, and therefore must be maintained,
>   but new potential users will either have to generalize it, or come up
>   with a different generic framework that will replace it.

I think the future of iovmm is looking not so good. Marek Szyprowski
is working on a generic version of the dma-mapping API (dma_map_ops)
based on the iommu API. As far as I can tell, once we have that in
place, we you can migrate omap3isp from iovmm to dma-mapping and
remove iovmm.

Of course if there are things missing from the dma-mapping API
that are present in iovmm, we should know about them so that we can
extend the dma-mapping API accordingly.

> - Migrate OMAP's iommu mainline user, omap3isp, to the generic API as well
>   (so it doesn't break). As with iovmm, omap3isp still depends on
>   omap's iommu, mainly because iovmm depends on it, but also for
>   iommu context saving and restoring.
> 
>   It is definitely desirable to completely remove omap3isp's dependency
>   on the omap-specific iommu layer, and that will be possible as the
>   required functionality will be added to generic framework.

ok.

> - Create a dedicated iommu drivers folder (and put the base iommu code there)
>
> - Move OMAP's and MSM's iommu drivers to that drivers iommu folder
> 
>   Putting all iommu drivers together will ease finding similarities
>   between different platforms, with the intention of solving problems once,
>   in a generic framework which everyone can use.
> 
>   I've only moved the omap and msm implementations for now, to demonstrate
>   the idea (and support the ARM diet :), but if this is found desirable,
>   we can bring in intel-iommu.c and amd_iommu.c as well.

Yes, very good idea.

	Arnd
