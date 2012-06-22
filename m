Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831Ab2FVDFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 23:05:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61380 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab2FVDFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 23:05:08 -0400
From: Huacai Chen <chenhuacai@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>, Zhangjin Wu <wuzhangjin@gmail.com>,
        Huacai Chen <chenhc@lemote.com>, Hongliang Tao <taohl@lemote.com>,
        Hua Yan <yanh@lemote.com>, dri-devel@lists.freedesktop.org
Subject: [PATCH V3 11/16] drm/radeon: Make radeon card usable for Loongson.
Date: Fri, 22 Jun 2012 11:01:08 +0800
Message-Id: <1340334073-17804-12-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340334073-17804-1-git-send-email-chenhc@lemote.com>
References: <1340334073-17804-1-git-send-email-chenhc@lemote.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1, Handle io prot correctly for MIPS.
2, Define SAREA_MAX as the size of one page.
3, Don't use swiotlb on Loongson machines (Loonson need swioitlb, but
   when use swiotlb, GPU reset occurs at resume from suspend).

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Hongliang Tao <taohl@lemote.com>
Signed-off-by: Hua Yan <yanh@lemote.com>
Reviewed-by: Michel Dänzer <michel@daenzer.net>
Reviewed-by: Alex Deucher <alexdeucher@gmail.com>
Reviewed-by: Lucas Stach <dev@lynxeye.de>
Reviewed-by: j.glisse <j.glisse@gmail.com>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/drm_vm.c            |    2 +-
 drivers/gpu/drm/radeon/radeon_ttm.c |    6 +++---
 drivers/gpu/drm/ttm/ttm_bo_util.c   |    2 +-
 include/drm/drm_sarea.h             |    2 ++
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
index 961ee08..3f06166 100644
--- a/drivers/gpu/drm/drm_vm.c
+++ b/drivers/gpu/drm/drm_vm.c
@@ -62,7 +62,7 @@ static pgprot_t drm_io_prot(uint32_t map_type, struct vm_area_struct *vma)
 		tmp = pgprot_writecombine(tmp);
 	else
 		tmp = pgprot_noncached(tmp);
-#elif defined(__sparc__) || defined(__arm__)
+#elif defined(__sparc__) || defined(__arm__) || defined(__mips__)
 	tmp = pgprot_noncached(tmp);
 #endif
 	return tmp;
diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index c94a225..f49bdd1 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -630,7 +630,7 @@ static int radeon_ttm_tt_populate(struct ttm_tt *ttm)
 	}
 #endif
 
-#ifdef CONFIG_SWIOTLB
+#if defined(CONFIG_SWIOTLB) && !defined(CONFIG_CPU_LOONGSON3)
 	if (swiotlb_nr_tbl()) {
 		return ttm_dma_populate(&gtt->ttm, rdev->dev);
 	}
@@ -676,7 +676,7 @@ static void radeon_ttm_tt_unpopulate(struct ttm_tt *ttm)
 	}
 #endif
 
-#ifdef CONFIG_SWIOTLB
+#if defined(CONFIG_SWIOTLB) && !defined(CONFIG_CPU_LOONGSON3)
 	if (swiotlb_nr_tbl()) {
 		ttm_dma_unpopulate(&gtt->ttm, rdev->dev);
 		return;
@@ -906,7 +906,7 @@ static int radeon_ttm_debugfs_init(struct radeon_device *rdev)
 	radeon_mem_types_list[i].show = &ttm_page_alloc_debugfs;
 	radeon_mem_types_list[i].driver_features = 0;
 	radeon_mem_types_list[i++].data = NULL;
-#ifdef CONFIG_SWIOTLB
+#if defined(CONFIG_SWIOTLB) && !defined(CONFIG_CPU_LOONGSON3)
 	if (swiotlb_nr_tbl()) {
 		sprintf(radeon_mem_types_names[i], "ttm_dma_page_pool");
 		radeon_mem_types_list[i].name = radeon_mem_types_names[i];
diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index f8187ea..0df71ea 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -472,7 +472,7 @@ pgprot_t ttm_io_prot(uint32_t caching_flags, pgprot_t tmp)
 	else
 		tmp = pgprot_noncached(tmp);
 #endif
-#if defined(__sparc__)
+#if defined(__sparc__) || defined(__mips__)
 	if (!(caching_flags & TTM_PL_FLAG_CACHED))
 		tmp = pgprot_noncached(tmp);
 #endif
diff --git a/include/drm/drm_sarea.h b/include/drm/drm_sarea.h
index ee5389d..1d1a858 100644
--- a/include/drm/drm_sarea.h
+++ b/include/drm/drm_sarea.h
@@ -37,6 +37,8 @@
 /* SAREA area needs to be at least a page */
 #if defined(__alpha__)
 #define SAREA_MAX                       0x2000U
+#elif defined(__mips__)
+#define SAREA_MAX                       0x4000U
 #elif defined(__ia64__)
 #define SAREA_MAX                       0x10000U	/* 64kB */
 #else
-- 
1.7.7.3

