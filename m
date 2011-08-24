Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab1HXSBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 14:01:36 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:31308 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab1HXSBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 14:01:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, j.glisse@redhat.com, thomas@shipmail.org,
        airlied@redhat.com, airlied@linux.ie, alexdeucher@gmail.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 6/6] ttm: Add 'no_dma' parameter to turn the TTM DMA pool off during runtime.
Date: Wed, 24 Aug 2011 13:17:04 -0400
Message-Id: <1314206224-15304-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314206224-15304-1-git-send-email-konrad.wilk@oracle.com>
References: <1314206224-15304-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090208.4E553C4C.008D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TTM DMA only gets turned on when the SWIOTLB is enabled - but
we might also want to turn it off when SWIOTLB is on to
use the non-DMA TTM pool code.

In the future this parameter can be removed.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c |    4 ++++
 include/drm/ttm/ttm_page_alloc.h         |    4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
index 2cc4b54..9e09eb9 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
@@ -51,6 +51,10 @@
 #include <asm/agp.h>
 #endif
 
+int __read_mostly dma_ttm_disable;
+MODULE_PARM_DESC(no_dma, "Disable TTM DMA pool");
+module_param_named(no_dma, dma_ttm_disable, bool, S_IRUGO);
+
 #define NUM_PAGES_TO_ALLOC		(PAGE_SIZE/sizeof(struct page *))
 #define SMALL_ALLOCATION		16
 #define FREE_ALL_PAGES			(~0U)
diff --git a/include/drm/ttm/ttm_page_alloc.h b/include/drm/ttm/ttm_page_alloc.h
index 192c5f8..e75af77 100644
--- a/include/drm/ttm/ttm_page_alloc.h
+++ b/include/drm/ttm/ttm_page_alloc.h
@@ -103,10 +103,10 @@ extern struct ttm_page_alloc_func ttm_page_alloc_default;
 #ifdef CONFIG_SWIOTLB
 /* Defined in ttm_page_alloc_dma.c */
 extern struct ttm_page_alloc_func ttm_page_alloc_dma;
-
+extern int dma_ttm_disable;
 static inline bool ttm_page_alloc_need_dma(void)
 {
-	if (swiotlb_enabled()) {
+	if (!dma_ttm_disable && swiotlb_enabled()) {
 		ttm_page_alloc = &ttm_page_alloc_dma;
 		return true;
 	}
-- 
1.7.4.1

