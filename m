Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab1HaDKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 23:10:30 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:30698 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1HaDK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 23:10:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: thellstrom@vmware.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, bskeggs@redhat.com,
        j.glisse@redhat.com, thomas@shipmail.org, airlied@redhat.com,
        airlied@linux.ie, alexdeucher@gmail.com
Subject: [PATCH] TTM DMA pool v1.7
Date: Tue, 30 Aug 2011 22:41:45 -0400
Message-Id: <1314758512-19285-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090203.4E5DA616.0091,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

But before I do any of that a second set of eyes taking a look at these
patches would be most welcome.

In regards to testing, I've been running them non-stop for the last two weeks
(and found some issues which I've fixed up) - and been quite happy with how
they work. I finally got my Intel VT-d box online so will test that shortly.

Michel (thanks!) took a spin off the patches on his PowerPC and they did not
cause any regressions (wheew).

The patches are also located in a git tree:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/ttm.dma_pool.v1.7

And the full diffstat is:

 drivers/gpu/drm/nouveau/nouveau_mem.c    |    8 +-
 drivers/gpu/drm/nouveau/nouveau_sgdma.c  |    3 +-
 drivers/gpu/drm/radeon/radeon_device.c   |    6 +
 drivers/gpu/drm/radeon/radeon_gart.c     |    4 +-
 drivers/gpu/drm/radeon/radeon_ttm.c      |    3 +-
 drivers/gpu/drm/ttm/Makefile             |    3 +
 drivers/gpu/drm/ttm/ttm_bo.c             |    4 +-
 drivers/gpu/drm/ttm/ttm_memory.c         |    5 +
 drivers/gpu/drm/ttm/ttm_page_alloc.c     |   63 ++-
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c | 1317 ++++++++++++++++++++++++++++++
 drivers/gpu/drm/ttm/ttm_tt.c             |    5 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c      |    4 +-
 drivers/xen/swiotlb-xen.c                |    2 +-
 include/drm/ttm/ttm_bo_driver.h          |    7 +-
 include/drm/ttm/ttm_page_alloc.h         |  100 +++-
 include/linux/swiotlb.h                  |    7 +-
 lib/swiotlb.c                            |    5 +-
 17 files changed, 1516 insertions(+), 30 deletions(-)
