Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab1K0FcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:32:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733Ab1K0Fbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:31:46 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Hellstrom <thellstrom@shipmail.org>,
        Dave Airlie <airlied@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jakob Bornecantz <jakob@vmware.com>, dri-devel@lists.freedesktop.org
Subject: [PATCH 14/62] drm: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:26:54 +0800
Message-Id: <1322371662-26166-15-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/gpu/drm/drm_cache.c         |    8 ++++----
 drivers/gpu/drm/ttm/ttm_tt.c        |   16 ++++++++--------
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c |    6 +++---
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/drm_cache.c b/drivers/gpu/drm/drm_cache.c
index 5928653..4b8653b 100644
--- a/drivers/gpu/drm/drm_cache.c
+++ b/drivers/gpu/drm/drm_cache.c
@@ -41,10 +41,10 @@ drm_clflush_page(struct page *page)
 	if (unlikely(page == NULL))
 		return;
 
-	page_virtual = kmap_atomic(page, KM_USER0);
+	page_virtual = kmap_atomic(page);
 	for (i = 0; i < PAGE_SIZE; i += boot_cpu_data.x86_clflush_size)
 		clflush(page_virtual + i);
-	kunmap_atomic(page_virtual, KM_USER0);
+	kunmap_atomic(page_virtual);
 }
 
 static void drm_cache_flush_clflush(struct page *pages[],
@@ -87,10 +87,10 @@ drm_clflush_pages(struct page *pages[], unsigned long num_pages)
 		if (unlikely(page == NULL))
 			continue;
 
-		page_virtual = kmap_atomic(page, KM_USER0);
+		page_virtual = kmap_atomic(page);
 		flush_dcache_range((unsigned long)page_virtual,
 				   (unsigned long)page_virtual + PAGE_SIZE);
-		kunmap_atomic(page_virtual, KM_USER0);
+		kunmap_atomic(page_virtual);
 	}
 #else
 	printk(KERN_ERR "Architecture has no drm_cache.c support\n");
diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index f9cc548..ec27fb9 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -496,11 +496,11 @@ static int ttm_tt_swapin(struct ttm_tt *ttm)
 			goto out_err;
 
 		preempt_disable();
-		from_virtual = kmap_atomic(from_page, KM_USER0);
-		to_virtual = kmap_atomic(to_page, KM_USER1);
+		from_virtual = kmap_atomic(from_page);
+		to_virtual = kmap_atomic(to_page);
 		memcpy(to_virtual, from_virtual, PAGE_SIZE);
-		kunmap_atomic(to_virtual, KM_USER1);
-		kunmap_atomic(from_virtual, KM_USER0);
+		kunmap_atomic(to_virtual);
+		kunmap_atomic(from_virtual);
 		preempt_enable();
 		page_cache_release(from_page);
 	}
@@ -565,11 +565,11 @@ int ttm_tt_swapout(struct ttm_tt *ttm, struct file *persistent_swap_storage)
 			goto out_err;
 		}
 		preempt_disable();
-		from_virtual = kmap_atomic(from_page, KM_USER0);
-		to_virtual = kmap_atomic(to_page, KM_USER1);
+		from_virtual = kmap_atomic(from_page);
+		to_virtual = kmap_atomic(to_page);
 		memcpy(to_virtual, from_virtual, PAGE_SIZE);
-		kunmap_atomic(to_virtual, KM_USER1);
-		kunmap_atomic(from_virtual, KM_USER0);
+		kunmap_atomic(to_virtual);
+		kunmap_atomic(from_virtual);
 		preempt_enable();
 		set_page_dirty(to_page);
 		mark_page_accessed(to_page);
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c b/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
index f4e7763..51c9ba5 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
@@ -136,10 +136,10 @@ static int vmw_gmr_build_descriptors(struct list_head *desc_pages,
 
 		if (likely(page_virtual != NULL)) {
 			desc_virtual->ppn = page_to_pfn(page);
-			kunmap_atomic(page_virtual, KM_USER0);
+			kunmap_atomic(page_virtual);
 		}
 
-		page_virtual = kmap_atomic(page, KM_USER0);
+		page_virtual = kmap_atomic(page);
 		desc_virtual = page_virtual - 1;
 		prev_pfn = ~(0UL);
 
@@ -169,7 +169,7 @@ static int vmw_gmr_build_descriptors(struct list_head *desc_pages,
 	}
 
 	if (likely(page_virtual != NULL))
-		kunmap_atomic(page_virtual, KM_USER0);
+		kunmap_atomic(page_virtual);
 
 	return 0;
 out_err:
-- 
1.7.4.4

