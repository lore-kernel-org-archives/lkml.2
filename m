Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab1CKLvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 06:51:05 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:65478 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab1CKLvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 06:51:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 3/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU) driver
Date: Fri, 11 Mar 2011 12:50:51 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-media@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>, k.debski@samsung.com,
        kgene.kim@samsung.com, kyungmin.park@samsung.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        " =?euc-kr?q?=27=B4=EB=C0=CE=B1=E2=27?=" <inki.dae@samsung.com>,
        " =?euc-kr?q?=27=B0=AD=B9=CE=B1=D4=27?=" <mk7.kang@samsung.com>,
        "'KyongHo Cho'" <pullip.cho@samsung.com>, linux-kernel@vger.kernel.org
References: <1299229274-9753-4-git-send-email-m.szyprowski@samsung.com> <201103101552.15536.arnd@arndb.de> <002101cbdfcb$5c657820$15306860$%szyprowski@samsung.com>
In-Reply-To: <002101cbdfcb$5c657820$15306860$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="euc-kr"
Content-Transfer-Encoding: 7bit
Message-Id: <201103111250.51252.arnd@arndb.de>
X-Provags-ID: V02:K0:1Zvr/5Gm2/lnYpyFAGkgAvjRWJ1z4yTMQ4+5gsAPO88
 /GG4acFlI6CybhsO7cs3Vi3GiXfVVDMcjHGXDR0ifYScj9HkEc
 WzO+EVIg+/Ci5ExQxeLIG/mY5rh0gUgcYUqgRoLF1GD6QNj6r4
 fOe4pLJdYwQDdGvGYuu7VJQmk11yoVBh6jD5s6S+u/f3Bcyy1M
 KSVK+h9485jmsNjh/sQqQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 March 2011, Marek Szyprowski wrote:
> 
> We followed the style of iommu API for other mainline ARM platforms (both OMAP and MSM
> also have custom API for their iommu modules). I've briefly checked include/linux/iommu.h
> API and I've noticed that it has been designed mainly for KVM support. There is also
> include/linux/intel-iommu.h interface, but I it is very specific to intel gfx chips.

The MSM code actually uses the generic iommu.h code, using register_iommu, so
the drivers can use the regular iommu_map.

I believe the omap code predates the iommu API, and should really be changed
to use that. At least it was added before I started reviewing the code.

The iommu API is not really meant to be KVM specific, it's just that the
in-tree users are basically limited to KVM at the moment. Another user that
is coming up soon is the vmio device driver that can be used to transparently
pass devices to user space. The idea behind the IOMMU API is that you can
map arbitrary bus addresses to physical memory addresses, but it does not
deal with allocating the bus addresses or providing buffer management such
as cache flushes.

> Is there any example how include/linux/dma-mapping.h interface can be used for iommu
> mappings?

The dma-mapping API is the normal interface that you should use for IOMMUs
that sit between DMA devices and kernel memory. The idea is that you
completely abstract the concept of an IOMMU so the device driver uses
the same code for talking to a device with an IOMMU and another device with
a linear mapping or an swiotlb bounce buffer.

This means that the user of the dma-mapping API does not get to choose the
bus addresses, but instead you use the API to get a bus address for a
chunk of memory, and then you can pass that address to a device.

See arch/powerpc/kernel/iommu.c and arch/x86/kernel/amd_iommu.c for common
examples of how this is implemented. The latter one actually implements
both the iommu_ops for iommu.h and dma_map_ops for dma-mapping.h.

	Arnd
