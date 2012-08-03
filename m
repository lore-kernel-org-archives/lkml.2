Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab2HCHHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 03:07:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57839 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab2HCHHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 03:07:30 -0400
From: Huacai Chen <chenhuacai@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>, Zhangjin Wu <wuzhangjin@gmail.com>,
        Huacai Chen <chenhc@lemote.com>, Hongliang Tao <taohl@lemote.com>,
        Hua Yan <yanh@lemote.com>, dri-devel@lists.freedesktop.org
Subject: [PATCH V4 11/16] drm/radeon: Make radeon card usable for Loongson.
Date: Fri,  3 Aug 2012 15:06:06 +0800
Message-Id: <1343977571-2292-12-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1343977571-2292-1-git-send-email-chenhc@lemote.com>
References: <1343977571-2292-1-git-send-email-chenhc@lemote.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1, Handle io prot correctly for MIPS.
2, Define SAREA_MAX as the size of one page.
3, Include swiotlb.h if SWIOTLB configured.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Hongliang Tao <taohl@lemote.com>
Signed-off-by: Hua Yan <yanh@lemote.com>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/drm_vm.c            |    2 +-
 drivers/gpu/drm/radeon/radeon_ttm.c |    4 ++++
 drivers/gpu/drm/ttm/ttm_bo_util.c   |    2 +-
 include/drm/drm_sarea.h             |    2 ++
 4 files changed, 8 insertions(+), 2 deletions(-)

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
index 5b71c71..fc3ac22 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -41,6 +41,10 @@
 #include "radeon_reg.h"
 #include "radeon.h"
 
+#ifdef CONFIG_SWIOTLB
+#include <linux/swiotlb.h>
+#endif
+
 #define DRM_FILE_PAGE_OFFSET (0x100000000ULL >> PAGE_SHIFT)
 
 static int radeon_ttm_debugfs_init(struct radeon_device *rdev);
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

