Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564Ab0FUVTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 17:19:46 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58669 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab0FUVTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 17:19:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=CqBM7zxxtH2MH8qKKzgYtxe1CbCc8pB4K0qh9A26O2tLU1x4YBA2QgjS5mFrpTLQoB
         ya+39DPSu0izRZnpIg7a3xAvd89MjUqUiIVQ0gXFrzbUEOu1hQvGj+STEAiPU90dlHRy
         xZYlAxUhD087xAbrD/ySyCmhsxaSzp2K8hn6g=
MIME-Version: 1.0
Date: Mon, 21 Jun 2010 17:19:43 -0400
Message-ID: <AANLkTinG-5iKW5cigIQHPHRZuAMtG_xY-74XLL6vE5kb@mail.gmail.com>
Subject: Problems with alpha/pci + radeon/ttm
From: Matt Turner <mattst88@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-alpha@vger.kernel.org
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Michael Cree <mcree@orcon.net.nz>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
       Dave Airlie <airlied@gmail.com>, Alex Deucher <alexdeucher@gmail.com>,
       Jerome Glisse <jglisse@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Cree and I have been debugging FDO bug 26403 [1]. I tried
booting with `radeon.test=1` and found this, which I think is related:

> [drm] Tested GTT->VRAM and VRAM->GTT copy for GTT offset 0x202000
> [drm] Tested GTT->VRAM and VRAM->GTT copy for GTT offset 0x302000
[snip]
> [drm] Tested GTT->VRAM and VRAM->GTT copy for GTT offset 0xfd02000
> [drm] Tested GTT->VRAM and VRAM->GTT copy for GTT offset 0xfe02000
> pci_map_single failed: could not allocate dma page tables
> [drm:radeon_ttm_backend_bind] *ERROR* failed to bind 128 pages at 0x0FF02000
> [TTM] Couldn't bind backend.
> radeon 0000:00:07.0: object_init failed for (1048576, 0x00000002)
> [drm:radeon_test_moves] *ERROR* Failed to create GTT object 253
> Error while testing BO move.

>From what I can see, the call chain is
radeon_test_moves
 (radeon_ttm_backend_bind called through callback function)
 - radeon_ttm.c:radeon_ttm_backend_bind calls radeon_gart_bind
  - radeon_gart.c:radeon_gart_bind calls pci_map_page
   - pci_map_page is alpha_pci_map_page, which calls...
    - alpha_pci_map_page calls pci_iommu.c:pci_map_single_1
     - pci_map_single_1 calls iommu_arena_alloc
      - iommu_arena_alloc calls iommu_arena_find_pages
       - iommu_arena_find_pages returns non-0
      - iommu_arena_alloc returns non-0
     - pci_map_single_1 returns 0 after printing
       "could not allocate dma page tables" error
    - alpha_pci_map_page returns 0 from pci_map_single_1
  - radeon_gart_bind returns non-0, error path prints
    "*ERROR* failed to bind 128 pages at 0x0FF02000"

Is this the cause of the bug we're seeing in the report [1]?

Anyone know what's going wrong here?

Thanks!
Matt Turner

[1] https://bugs.freedesktop.org/show_bug.cgi?id=26403
