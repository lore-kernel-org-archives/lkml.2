Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab0FVGAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 02:00:36 -0400
Received: from sh.osrg.net ([192.16.179.4]:57799 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687Ab0FVGAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 02:00:34 -0400
Date: Tue, 22 Jun 2010 14:59:50 +0900
To: mattst88@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, rth@twiddle.net,
       ink@jurassic.park.msu.ru, mcree@orcon.net.nz, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org,
       airlied@gmail.com, alexdeucher@gmail.com, jglisse@redhat.com
Subject: Re: Problems with alpha/pci + radeon/ttm
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <AANLkTinG-5iKW5cigIQHPHRZuAMtG_xY-74XLL6vE5kb@mail.gmail.com>
References: <AANLkTinG-5iKW5cigIQHPHRZuAMtG_xY-74XLL6vE5kb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100622145805R.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 22 Jun 2010 14:59:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010 17:19:43 -0400
Matt Turner <mattst88@gmail.com> wrote:

> Michael Cree and I have been debugging FDO bug 26403 [1]. I tried
> booting with `radeon.test=1` and found this, which I think is related:
> 
> > [drm] Tested GTT->VRAM and VRAM->GTT copy for GTT offset 0x202000
> > [drm] Tested GTT->VRAM and VRAM->GTT copy for GTT offset 0x302000
> [snip]
> > [drm] Tested GTT->VRAM and VRAM->GTT copy for GTT offset 0xfd02000
> > [drm] Tested GTT->VRAM and VRAM->GTT copy for GTT offset 0xfe02000
> > pci_map_single failed: could not allocate dma page tables
> > [drm:radeon_ttm_backend_bind] *ERROR* failed to bind 128 pages at 0x0FF02000
> > [TTM] Couldn't bind backend.
> > radeon 0000:00:07.0: object_init failed for (1048576, 0x00000002)
> > [drm:radeon_test_moves] *ERROR* Failed to create GTT object 253
> > Error while testing BO move.
> 
> From what I can see, the call chain is
> radeon_test_moves
>  (radeon_ttm_backend_bind called through callback function)
>  - radeon_ttm.c:radeon_ttm_backend_bind calls radeon_gart_bind
>   - radeon_gart.c:radeon_gart_bind calls pci_map_page
>    - pci_map_page is alpha_pci_map_page, which calls...
>     - alpha_pci_map_page calls pci_iommu.c:pci_map_single_1
>      - pci_map_single_1 calls iommu_arena_alloc
>       - iommu_arena_alloc calls iommu_arena_find_pages
>        - iommu_arena_find_pages returns non-0
>       - iommu_arena_alloc returns non-0
>      - pci_map_single_1 returns 0 after printing
>        "could not allocate dma page tables" error
>     - alpha_pci_map_page returns 0 from pci_map_single_1
>   - radeon_gart_bind returns non-0, error path prints
>     "*ERROR* failed to bind 128 pages at 0x0FF02000"

This happens in the latest git, right?

Is this a regression (what kernel version worked)?


Seems that the IOMMU can't find 128 pages. It's likely due to:

- out of the IOMMU space (possibly someone doesn't free the IOMMU
  space).

or

- the mapping parameters (such as align) aren't appropriate so the
  IOMMU can't find space.


> Is this the cause of the bug we're seeing in the report [1]?
>
> Anyone know what's going wrong here?


I've attached a patch to print the debug info about the mapping
parameters.


diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index d1dbd9a..17cf0d8 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -187,6 +187,10 @@ iommu_arena_alloc(struct device *dev, struct pci_iommu_arena *arena, long n,
 	/* Search for N empty ptes */
 	ptes = arena->ptes;
 	mask = max(align, arena->align_entry) - 1;
+
+	printk("%s: %p, %p, %d, %ld, %lx, %u\n", __func__, dev, arena, arena->size,
+	       n, mask, align);
+
 	p = iommu_arena_find_pages(dev, arena, n, mask);
 	if (p < 0) {
 		spin_unlock_irqrestore(&arena->lock, flags);

