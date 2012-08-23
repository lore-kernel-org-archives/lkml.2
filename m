Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab2HWGnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 02:43:33 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48903 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab2HWGn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 02:43:29 -0400
X-AuditID: 9c93016f-b7cc0ae000000e9f-28-5035d10fa38e
Date: Thu, 23 Aug 2012 15:43:57 +0900
From: Minchan Kim <minchan@kernel.org>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: m.szyprowski@samsung.com, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com, arnd@arndb.de,
        linux@arm.linux.org.uk, chunsang.jeong@linaro.org, vdumpa@nvidia.com,
        konrad.wilk@oracle.com, subashrp@gmail.com, pullip.cho@samsung.com
Subject: Re: [v2 0/4] ARM: dma-mapping: IOMMU atomic allocation
Message-ID: <20120823064357.GD5369@bbox>
References: <1345702229-9539-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345702229-9539-1-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 09:10:25AM +0300, Hiroshi Doyu wrote:
> Hi,
> 
> The commit e9da6e9 "ARM: dma-mapping: remove custom consistent dma
> region" breaks the compatibility with existing drivers. This causes
> the following kernel oops(*1). That driver has called dma_pool_alloc()
> to allocate memory from the interrupt context, and it hits
> BUG_ON(in_interrpt()) in "get_vm_area_caller()". This patch seris
> fixes this problem with making use of the pre-allocate atomic memory
> pool which DMA is using in the same way as DMA does now.
> 
> Any comment would be really appreciated.
> 
> v2:
> Don't modify attrs(DMA_ATTR_NO_KERNEL_MAPPING) for atomic allocation. (Marek)
> Skip vzalloc (KyongHo, Minchan)

Huh? I would like to correct exactly. I didn't say that kzalloc unify is okay.
As KyongHo said, there are other usecases for allocating big buffer but
I can't agree his opinion that it's system memory shortage if the allocation
fails. Because there are lots of freeable pages(cached page + anon pages
with swap , shrinkable slab and so on). But as I said early, VM can't do
anything except relying on kswapd in atomic context while there are a ton
of freeable pages in system and we can't gaurantee kswapd will do something
for us before seeing the page allocation failure in process context.
Especially, UP is more problem. So, it never indicate system needs more memory.

Atomic high order allocation is very fragile in VM POV
so caller should have fallback mechanism. Otherwise, don't do that.

-- 
Kind regards,
Minchan Kim
