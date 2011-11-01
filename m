Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab1KATCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 15:02:52 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31899 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab1KATCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 15:02:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, thellstrom@vmware.com, thomas@shipmail.org,
        airlied@redhat.com, jglisse@redhat.com, bskeggs@redhat.com
Cc: xen-devel@lists.xensource.com
Subject: [PATCH] TTM DMA pool v2.2 or [GIT PULL] (stable/ttm.dma_pool.v2.3) for 3.3
Date: Tue,  1 Nov 2011 14:47:21 -0400
Message-Id: <1320173252-2812-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.6.4
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4EB04231.02BA,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not sure what the right way to patches in Dave tree is for Linux 3.3, so I
am posting the patches and also providing the means of doing a git pull.

The git tree is:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/ttm.dma_pool.v2.3


Oh, and Thomas, should I add your Ack on the patches as well? I think it was an implied
Ack, but I do not want to presume. If so, I can respin this with your Ack shortly.

and it has since v2.1: https://lwn.net/Articles/463815/
 - Fixed bugs/mistakes pointed out by Jerome
 - Added Review-by: Jereme Glisse
Since v2.0: [not posted]
 - Redid the registration/override to be tightly integrated with the
   'struct ttm_backend_func' per Thomas's suggestion.
Since v1.9: [not posted]
 - Performance improvements - it was doing O(n^2) instead of O(n) on certain
   workloads.
Since v1.8: [lwn.net/Articles/458724/]
 - Removed swiotlb_enabled and used swiotlb_nr_tbl.
 - Added callback for changing cache types.
Since v1.7: [https://lkml.org/lkml/2011/8/30/460]
 - Fixed checking the DMA address in radeon/nouveau code.
Since v1: [http://lwn.net/Articles/456246/]
 - Ran it through the gauntlet of SubmitChecklist and fixed issues
 - Made radeon/nouveau driver set coherent_dma (which is required for dmapool)

[.. and this is what I said in v1 post]:

Way back in January this patchset:
http://lists.freedesktop.org/archives/dri-devel/2011-January/006905.html
was merged in, but pieces of it had to be reverted b/c they did not
work properly under PowerPC, ARM, and when swapping out pages to disk.

After a bit of discussion on the mailing list
http://marc.info/?i=4D769726.2030307@shipmail.org I started working on it, but
got waylaid by other things .. and finally I am able to post the RFC patches.

There was a lot of discussion about it and I am not sure if I captured
everybody's thoughts - if I did not - that is _not_ intentional - it has just
been quite some time..

Anyhow .. the patches explore what the "lib/dmapool.c" does - which is to have a
DMA pool that the device has associated with. I kind of married that code
along with drivers/gpu/drm/ttm/ttm_page_alloc.c to create a TTM DMA pool code.
The end result is DMA pool with extra features: can do write-combine, uncached,
writeback (and tracks them and sets back to WB when freed); tracks "cached"
pages that don't really need to be returned to a pool; and hooks up to
the shrinker code so that the pools can be shrunk.

If you guys think this set of patches make sense  - my future plans were
 1) Get this in large crowd of testing .. and if it works for a kernel release
 2) to move a bulk of this in the lib/dmapool.c (I spoke with Matthew Wilcox
    about it and he is OK as long as I don't introduce performance regressions).

In regards to testing, I've been running them non-stop for the last two months.
(and found some issues which I've fixed up) - and been quite happy with how
they work.

Michel (thanks!) took a spin of the patches on his PowerPC and they did not
cause any regressions (wheew).

The patches are also located in a git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/ttm.dma_pool.v2.3

Konrad Rzeszutek Wilk (11):
      swiotlb: Expose swiotlb_nr_tlb function to modules
      nouveau/radeon: Set coherent DMA mask
      ttm/radeon/nouveau: Check the DMA address from TTM against known value.
      ttm: Wrap ttm_[put|get]_pages and extract GFP_* and caching states from 'struct ttm_tt'
      ttm: Get rid of temporary scaffolding
      ttm/driver: Expand ttm_backend_func to include two overrides for TTM page pool.
      ttm: Do not set the ttm->be to NULL before calling the TTM page pool to free pages.
      ttm: Provide DMA aware TTM page pool code.
      ttm: Add 'no_dma' parameter to turn the TTM DMA pool off during runtime.
      nouveau/ttm/dma: Enable the TTM DMA pool if device can only do 32-bit DMA.
      radeon/ttm/dma: Enable the TTM DMA pool if the device can only do 32-bit.

 drivers/gpu/drm/nouveau/nouveau_debugfs.c |    1 +
 drivers/gpu/drm/nouveau/nouveau_mem.c     |    5 +
 drivers/gpu/drm/nouveau/nouveau_sgdma.c   |    8 +-
 drivers/gpu/drm/radeon/radeon_device.c    |    6 +
 drivers/gpu/drm/radeon/radeon_gart.c      |    4 +-
 drivers/gpu/drm/radeon/radeon_ttm.c       |   19 +-
 drivers/gpu/drm/ttm/Makefile              |    3 +
 drivers/gpu/drm/ttm/ttm_memory.c          |    5 +
 drivers/gpu/drm/ttm/ttm_page_alloc.c      |  108 ++-
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c  | 1409 +++++++++++++++++++++++++++++
 drivers/gpu/drm/ttm/ttm_tt.c              |   21 +-
 drivers/xen/swiotlb-xen.c                 |    2 +-
 include/drm/ttm/ttm_bo_driver.h           |   31 +
 include/drm/ttm/ttm_page_alloc.h          |   53 +-
 include/linux/swiotlb.h                   |    2 +-
 lib/swiotlb.c                             |    5 +-
 16 files changed, 1600 insertions(+), 82 deletions(-)
