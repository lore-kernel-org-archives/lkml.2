Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab2HVNhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 09:37:22 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4005 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427Ab2HVNhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 09:37:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 22 Aug 2012 06:36:55 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "pullip.cho@samsung.com" <pullip.cho@samsung.com>
CC: "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
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
        "subashrp@gmail.com" <subashrp@gmail.com>,
        "minchan@kernel.org" <minchan@kernel.org>
Date: Wed, 22 Aug 2012 15:36:48 +0200
Subject: Re: [RFC 2/4] ARM: dma-mapping: IOMMU allocates pages from pool
 with GFP_ATOMIC
Thread-Topic: [RFC 2/4] ARM: dma-mapping: IOMMU allocates pages from pool
 with GFP_ATOMIC
Thread-Index: Ac2Aay6W1IqltmFFRWaC/1lscM4zfg==
Message-ID: <20120822.163648.3800987367886904.hdoyu@nvidia.com>
References: <1345630830-9586-1-git-send-email-hdoyu@nvidia.com><1345630830-9586-3-git-send-email-hdoyu@nvidia.com><CAHQjnOOF7Ca-Dz8K_zcS=gxQsJvKYaWA3tqUeK1RSd-wLYZ44w@mail.gmail.com>
In-Reply-To: <CAHQjnOOF7Ca-Dz8K_zcS=gxQsJvKYaWA3tqUeK1RSd-wLYZ44w@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

KyongHo Cho <pullip.cho@samsung.com> wrote @ Wed, 22 Aug 2012 14:47:00 +0200:

> vzalloc() call in __iommu_alloc_buffer() also causes BUG() in atomic context.

Right.

I've been thinking that kzalloc() may be enough here, since
vzalloc() was introduced to avoid allocation failure for big chunk of
memory, but I think that it's unlikely that the number of page array
can be so big. So I propose to drop vzalloc() here, and just simply to
use kzalloc only as below(*1).

For example, 

1920(H) x 1080(W) x 4(bytes) ~= 8MiB

For 8 MiB buffer,
  8(MiB) * 1024 = 8192(KiB)
  8192(KiB) / 4(KiB/page) = 2048 pages
  sizeof(struct page *) = 4 bytes
  2048(pages) * 4(bytes/page) = 8192(bytes) = 8(KiB)
  8(KiB) / 4(KiB/page) = 2 pages

If the above estimation is right(I hope;)), the necessary pages are
_at most_ 2 pages. If the system gets into the situation to fail to
allocate 2 contiguous pages, that's real the problem. I guess that
that kind of fragmentation problem would be solved with page migration
or something, especially nowadays devices are getting larger memories.

*1:
>From a613c40d1b3d4fb1577cdb0807a74e8dbd08a3e6 Mon Sep 17 00:00:00 2001
From: Hiroshi Doyu <hdoyu@nvidia.com>
Date: Wed, 22 Aug 2012 16:25:54 +0300
Subject: [PATCH 1/1] ARM: dma-mapping: Use only kzalloc without vzalloc

Use only kzalloc for atomic allocation.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/mm/dma-mapping.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 4656c0f..d4f1cf2 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1083,10 +1083,7 @@ static struct page **__iommu_alloc_buffer(struct device *dev, size_t size,
 	int count = size >> PAGE_SHIFT;
 	int array_size = count * sizeof(struct page *);
 
-	if (array_size <= PAGE_SIZE)
-		pages = kzalloc(array_size, gfp);
-	else
-		pages = vzalloc(array_size);
+	pages = kzalloc(array_size, gfp);
 	if (!pages)
 		return NULL;
 
@@ -1107,10 +1104,7 @@ static struct page **__iommu_alloc_buffer(struct device *dev, size_t size,
 
 	return pages;
 error:
-	if (array_size <= PAGE_SIZE)
-		kfree(pages);
-	else
-		vfree(pages);
+	kfree(pages);
 	return NULL;
 }
 
-- 
1.7.5.4
