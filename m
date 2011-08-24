Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab1HXSBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 14:01:25 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:31209 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab1HXSBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 14:01:20 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, j.glisse@redhat.com, thomas@shipmail.org,
        airlied@redhat.com, airlied@linux.ie, alexdeucher@gmail.com
Subject: [RFC PATCH] TTM DMA pool v1
Date: Wed, 24 Aug 2011 13:16:58 -0400
Message-Id: <1314206224-15304-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4E553C49.0033:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

If you guys think this set of patches make sense  - my future plans were to
move a bulk of this in the lib/dmapool.c (I spoke with Matthew Wilcox about it
and he is OK as long as I don't introduce performance regressions).

As I mentioned, in the past, the patches I introduced broke certain scenarios
so I've been running compile/runtime tests to make sure I don't repeat my past
mistakes.  Both nouveau and radeon - IGP, PCI-e, and with various IOMMUs -
Calgary, GART, SWIOTLB, Xen SWIOTLB, AMD-VI work correctly (still need to test
Intel VT-d).

My PowerPC has issues with booting a virgin 3.0 kernel (something about
"ELF image not correct") so I don't have that yet covered.

The patches are also located in a git tree:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/ttm.dma_pool.v1.5

And the full diffstat is:

 drivers/gpu/drm/nouveau/nouveau_mem.c    |    3 +-
 drivers/gpu/drm/nouveau/nouveau_sgdma.c  |    3 +-
 drivers/gpu/drm/radeon/radeon_gart.c     |    4 +-
 drivers/gpu/drm/radeon/radeon_ttm.c      |    3 +-
 drivers/gpu/drm/ttm/Makefile             |    3 +
 drivers/gpu/drm/ttm/ttm_bo.c             |    4 +-
 drivers/gpu/drm/ttm/ttm_memory.c         |    5 +
 drivers/gpu/drm/ttm/ttm_page_alloc.c     |   63 ++-
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c | 1311 ++++++++++++++++++++++++++++++
 drivers/gpu/drm/ttm/ttm_tt.c             |    5 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c      |    4 +-
 drivers/xen/swiotlb-xen.c                |    2 +-
 include/drm/ttm/ttm_bo_driver.h          |    7 +-
 include/drm/ttm/ttm_page_alloc.h         |  100 +++-
 include/linux/swiotlb.h                  |    7 +-
 lib/swiotlb.c                            |    5 +-
 16 files changed, 1499 insertions(+), 30 deletions(-)
