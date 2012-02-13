Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab2BMHbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 02:31:44 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52845 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2BMHbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 02:31:42 -0500
MIME-Version: 1.0
In-Reply-To: <20120213164000.da84dfec7723af3a9eb3e13f@canb.auug.org.au>
References: <20120213164000.da84dfec7723af3a9eb3e13f@canb.auug.org.au>
Date: Mon, 13 Feb 2012 16:31:42 +0900
X-Google-Sender-Auth: ABGaP0kXDC55s7T1yLXLy8jIq38
Message-ID: <CAH9JG2X-X-LqO7_r5yEPOMzJmOik-V5sevy_+3WTL2a984JPJg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the dma-mapping tree
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It's maybe missing modify arch/powerpc/kernel/vio.c at that time.

following patch will fix it.

Thank you,
Kyungmin Park

diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index 8b08629..b12a77a 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -487,7 +487,7 @@ static void vio_cmo_balance(struct work_struct *work)
 }
diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index 8b08629..b12a77a 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -487,7 +487,7 @@ static void vio_cmo_balance(struct work_struct *work)
 }

 static void *vio_dma_iommu_alloc_coherent(struct device *dev, size_t size,
-                                          dma_addr_t *dma_handle, gfp_t flag)
+               dma_addr_t *dma_handle, gfp_t flag, struct dma_attrs *attrs)
 {
        struct vio_dev *viodev = to_vio_dev(dev);
        void *ret;
@@ -497,7 +497,7 @@ static void *vio_dma_iommu_alloc_coherent(struct device *dev
                return NULL;
        }

-       ret = dma_iommu_ops.alloc_coherent(dev, size, dma_handle, flag);
+       ret = dma_iommu_ops.alloc(dev, size, dma_handle, flag, attrs);
        if (unlikely(ret == NULL)) {
                vio_cmo_dealloc(viodev, roundup(size, PAGE_SIZE));
                atomic_inc(&viodev->cmo.allocs_failed);
@@ -507,11 +507,11 @@ static void *vio_dma_iommu_alloc_coherent(struct device *d
 }

 static void vio_dma_iommu_free_coherent(struct device *dev, size_t size,
-                                        void *vaddr, dma_addr_t dma_handle)
+               void *vaddr, dma_addr_t dma_handle, struct dma_attrs *attrs)
 {
        struct vio_dev *viodev = to_vio_dev(dev);

-       dma_iommu_ops.free_coherent(dev, size, vaddr, dma_handle);
+       dma_iommu_ops.free(dev, size, vaddr, dma_handle, attrs);

        vio_cmo_dealloc(viodev, roundup(size, PAGE_SIZE));
 }
@@ -612,8 +612,8 @@ static u64 vio_dma_get_required_mask(struct device *dev)
 }

 struct dma_map_ops vio_dma_mapping_ops = {
-       .alloc_coherent    = vio_dma_iommu_alloc_coherent,
-       .free_coherent     = vio_dma_iommu_free_coherent,
+       .alloc             = vio_dma_iommu_alloc_coherent,
+       .free              = vio_dma_iommu_free_coherent,
        .map_sg            = vio_dma_iommu_map_sg,
        .unmap_sg          = vio_dma_iommu_unmap_sg,
        .map_page          = vio_dma_iommu_map_page,

On 2/13/12, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the dma-mapping tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> arch/powerpc/kernel/vio.c: In function 'vio_dma_iommu_alloc_coherent':
> arch/powerpc/kernel/vio.c:500:21: error: 'struct dma_map_ops' has no member
> named 'alloc_coherent'
> arch/powerpc/kernel/vio.c: In function 'vio_dma_iommu_free_coherent':
> arch/powerpc/kernel/vio.c:514:15: error: 'struct dma_map_ops' has no member
> named 'free_coherent'
> arch/powerpc/kernel/vio.c: At top level:
> arch/powerpc/kernel/vio.c:615:2: error: unknown field 'alloc_coherent'
> specified in initializer
> arch/powerpc/kernel/vio.c:615:2: error: initialization from incompatible
> pointer type [-Werror]
> arch/powerpc/kernel/vio.c:615:2: error: (near initialization for
> 'vio_dma_mapping_ops.alloc') [-Werror]
> arch/powerpc/kernel/vio.c:616:2: error: unknown field 'free_coherent'
> specified in initializer
> arch/powerpc/kernel/vio.c:616:2: error: initialization from incompatible
> pointer type [-Werror]
> arch/powerpc/kernel/vio.c:616:2: error: (near initialization for
> 'vio_dma_mapping_ops.free') [-Werror]
>
> I have dropped the dma-mapping tree for today.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
