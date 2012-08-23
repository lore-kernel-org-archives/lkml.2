Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab2HWDtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 23:49:11 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57292 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab2HWDtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 23:49:08 -0400
X-AuditID: 9c93016f-b7cc0ae000000e9f-b4-5035a832778c
Date: Thu, 23 Aug 2012 12:49:35 +0900
From: Minchan Kim <minchan@kernel.org>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: "pullip.cho@samsung.com" <pullip.cho@samsung.com>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "chunsang.jeong@linaro.org" <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "subashrp@gmail.com" <subashrp@gmail.com>
Subject: Re: [RFC 2/4] ARM: dma-mapping: IOMMU allocates pages from pool with
 GFP_ATOMIC
Message-ID: <20120823034935.GC5369@bbox>
References: <1345630830-9586-1-git-send-email-hdoyu@nvidia.com>
 <1345630830-9586-3-git-send-email-hdoyu@nvidia.com>
 <CAHQjnOOF7Ca-Dz8K_zcS=gxQsJvKYaWA3tqUeK1RSd-wLYZ44w@mail.gmail.com>
 <20120822.163648.3800987367886904.hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822.163648.3800987367886904.hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 03:36:48PM +0200, Hiroshi Doyu wrote:
> Hi,
> 
> KyongHo Cho <pullip.cho@samsung.com> wrote @ Wed, 22 Aug 2012 14:47:00 +0200:
> 
> > vzalloc() call in __iommu_alloc_buffer() also causes BUG() in atomic context.
> 
> Right.
> 
> I've been thinking that kzalloc() may be enough here, since
> vzalloc() was introduced to avoid allocation failure for big chunk of
> memory, but I think that it's unlikely that the number of page array
> can be so big. So I propose to drop vzalloc() here, and just simply to
> use kzalloc only as below(*1).
> 
> For example, 
> 
> 1920(H) x 1080(W) x 4(bytes) ~= 8MiB
> 
> For 8 MiB buffer,
>   8(MiB) * 1024 = 8192(KiB)
>   8192(KiB) / 4(KiB/page) = 2048 pages
>   sizeof(struct page *) = 4 bytes
>   2048(pages) * 4(bytes/page) = 8192(bytes) = 8(KiB)
>   8(KiB) / 4(KiB/page) = 2 pages
> 
> If the above estimation is right(I hope;)), the necessary pages are
> _at most_ 2 pages. If the system gets into the situation to fail to
> allocate 2 contiguous pages, that's real the problem. I guess that
> that kind of fragmentation problem would be solved with page migration
> or something, especially nowadays devices are getting larger memories.

In atomic context, VM have no choice except relying on kswapd so
high order allocation can fail easily when memory fragementation
is high.

-- 
Kind regards,
Minchan Kim
