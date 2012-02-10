Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab2BJFsC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:48:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932577Ab2BJFr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:47:58 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        David Airlie <airlied@linux.ie>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 56/60] gma500: remove the second argument of k[un]map_atomic()
Date: Fri, 10 Feb 2012 13:40:17 +0800
Message-Id: <1328852421-19678-57-git-send-email-amwang@redhat.com>
In-Reply-To: <1328852421-19678-1-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/gpu/drm/gma500/mmu.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/gma500/mmu.c b/drivers/gpu/drm/gma500/mmu.c
index c904d73..e80ee82 100644
--- a/drivers/gpu/drm/gma500/mmu.c
+++ b/drivers/gpu/drm/gma500/mmu.c
@@ -125,14 +125,14 @@ static void psb_page_clflush(struct psb_mmu_driver *driver, struct page* page)
 	int i;
 	uint8_t *clf;
 
-	clf = kmap_atomic(page, KM_USER0);
+	clf = kmap_atomic(page);
 	mb();
 	for (i = 0; i < clflush_count; ++i) {
 		psb_clflush(clf);
 		clf += clflush_add;
 	}
 	mb();
-	kunmap_atomic(clf, KM_USER0);
+	kunmap_atomic(clf);
 }
 
 static void psb_pages_clflush(struct psb_mmu_driver *driver,
@@ -325,7 +325,7 @@ static struct psb_mmu_pt *psb_mmu_alloc_pt(struct psb_mmu_pd *pd)
 
 	spin_lock(lock);
 
-	v = kmap_atomic(pt->p, KM_USER0);
+	v = kmap_atomic(pt->p);
 	clf = (uint8_t *) v;
 	ptes = (uint32_t *) v;
 	for (i = 0; i < (PAGE_SIZE / sizeof(uint32_t)); ++i)
@@ -341,7 +341,7 @@ static struct psb_mmu_pt *psb_mmu_alloc_pt(struct psb_mmu_pd *pd)
 		mb();
 	}
 
-	kunmap_atomic(v, KM_USER0);
+	kunmap_atomic(v);
 	spin_unlock(lock);
 
 	pt->count = 0;
@@ -376,18 +376,18 @@ struct psb_mmu_pt *psb_mmu_pt_alloc_map_lock(struct psb_mmu_pd *pd,
 			continue;
 		}
 
-		v = kmap_atomic(pd->p, KM_USER0);
+		v = kmap_atomic(pd->p);
 		pd->tables[index] = pt;
 		v[index] = (page_to_pfn(pt->p) << 12) | pd->pd_mask;
 		pt->index = index;
-		kunmap_atomic((void *) v, KM_USER0);
+		kunmap_atomic((void *) v);
 
 		if (pd->hw_context != -1) {
 			psb_mmu_clflush(pd->driver, (void *) &v[index]);
 			atomic_set(&pd->driver->needs_tlbflush, 1);
 		}
 	}
-	pt->v = kmap_atomic(pt->p, KM_USER0);
+	pt->v = kmap_atomic(pt->p);
 	return pt;
 }
 
@@ -404,7 +404,7 @@ static struct psb_mmu_pt *psb_mmu_pt_map_lock(struct psb_mmu_pd *pd,
 		spin_unlock(lock);
 		return NULL;
 	}
-	pt->v = kmap_atomic(pt->p, KM_USER0);
+	pt->v = kmap_atomic(pt->p);
 	return pt;
 }
 
@@ -413,9 +413,9 @@ static void psb_mmu_pt_unmap_unlock(struct psb_mmu_pt *pt)
 	struct psb_mmu_pd *pd = pt->pd;
 	uint32_t *v;
 
-	kunmap_atomic(pt->v, KM_USER0);
+	kunmap_atomic(pt->v);
 	if (pt->count == 0) {
-		v = kmap_atomic(pd->p, KM_USER0);
+		v = kmap_atomic(pd->p);
 		v[pt->index] = pd->invalid_pde;
 		pd->tables[pt->index] = NULL;
 
@@ -424,7 +424,7 @@ static void psb_mmu_pt_unmap_unlock(struct psb_mmu_pt *pt)
 					(void *) &v[pt->index]);
 			atomic_set(&pd->driver->needs_tlbflush, 1);
 		}
-		kunmap_atomic(pt->v, KM_USER0);
+		kunmap_atomic(pt->v);
 		spin_unlock(&pd->driver->lock);
 		psb_mmu_free_pt(pt);
 		return;
@@ -457,7 +457,7 @@ void psb_mmu_mirror_gtt(struct psb_mmu_pd *pd,
 	down_read(&driver->sem);
 	spin_lock(&driver->lock);
 
-	v = kmap_atomic(pd->p, KM_USER0);
+	v = kmap_atomic(pd->p);
 	v += start;
 
 	while (gtt_pages--) {
@@ -467,7 +467,7 @@ void psb_mmu_mirror_gtt(struct psb_mmu_pd *pd,
 
 	/*ttm_tt_cache_flush(&pd->p, num_pages);*/
 	psb_pages_clflush(pd->driver, &pd->p, num_pages);
-	kunmap_atomic(v, KM_USER0);
+	kunmap_atomic(v);
 	spin_unlock(&driver->lock);
 
 	if (pd->hw_context != -1)
@@ -830,9 +830,9 @@ int psb_mmu_virtual_to_pfn(struct psb_mmu_pd *pd, uint32_t virtual,
 		uint32_t *v;
 
 		spin_lock(lock);
-		v = kmap_atomic(pd->p, KM_USER0);
+		v = kmap_atomic(pd->p);
 		tmp = v[psb_mmu_pd_index(virtual)];
-		kunmap_atomic(v, KM_USER0);
+		kunmap_atomic(v);
 		spin_unlock(lock);
 
 		if (tmp != pd->invalid_pde || !(tmp & PSB_PTE_VALID) ||
-- 
1.7.7.6

