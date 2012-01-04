Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab2ADVhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 16:37:14 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:60048 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943Ab2ADVg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 16:36:56 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        j.glisse@gmail.com, bskeggs@redhat.com, thellstrom@vmware.co,
        airlied@linux.ie
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/3] drm/ttm/dma: Only call set_pages_array_wb when the page is not in WB pool.
Date: Wed,  4 Jan 2012 16:35:14 -0500
Message-Id: <1325712916-27962-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1325712916-27962-1-git-send-email-konrad.wilk@oracle.com>
References: <1325712916-27962-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4F04C673.00E2,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we are doing redundant work. Especially since the 'unbind'
and 'unpopulate' have been merged and nouveau driver ends up calling
it quite excessivly. On a GeForce 8600 GT with Gnome Shell (GNOME 3)
we end up spending about 54% CPU time in __change_page_attr_set_clr
checking the page flags.

The callgraph (annotated) looks as so before this patch:

    53.29%  gnome-shell  [kernel.kallsyms]                   [k] static_protections
            |
            --- static_protections
               |
               |--91.80%-- __change_page_attr_set_clr
               |          change_page_attr_set_clr
               |          set_pages_array_wb
               |          |
               |          |--96.55%-- ttm_dma_unpopulate
               |          |          nouveau_ttm_tt_unpopulate
               |          |          ttm_tt_destroy
               |          |          ttm_bo_cleanup_memtype_use
               |          |          ttm_bo_release
               |          |          kref_put
               |          |          ttm_bo_unref
               |          |          nouveau_gem_object_del
               |          |          drm_gem_object_free
               |          |          kref_put
               |          |          drm_gem_object_unreference_unlocked
               |          |          drm_gem_object_handle_unreference_unlocked.part.1
               |          |          drm_gem_handle_delete
               |          |          drm_gem_close_ioctl
               |          |          drm_ioctl
               |          |          do_vfs_ioctl
               |          |          sys_ioctl
               |          |          system_call_fastpath
               |          |          __GI___ioctl
               |          |
               |           --3.45%-- ttm_dma_pages_put
               |                     ttm_dma_page_pool_free
               |                     ttm_dma_unpopulate
               |                     nouveau_ttm_tt_unpopulate
               |                     ttm_tt_destroy
               |                     ttm_bo_cleanup_memtype_use
               |                     ttm_bo_release
               |                     kref_put
               |                     ttm_bo_unref
               |                     nouveau_gem_object_del
               |                     drm_gem_object_free
               |                     kref_put
               |                     drm_gem_object_unreference_unlocked
               |                     drm_gem_object_handle_unreference_unlocked.part.1
               |                     drm_gem_handle_delete
               |                     drm_gem_close_ioctl
               |                     drm_ioctl
               |                     do_vfs_ioctl
               |                     sys_ioctl
               |                     system_call_fastpath
               |                     __GI___ioctl
               |
                --8.20%-- change_page_attr_set_clr
                          set_pages_array_wb
                          |
                          |--93.76%-- ttm_dma_unpopulate
                          |          nouveau_ttm_tt_unpopulate
                          |          ttm_tt_destroy
                          |          ttm_bo_cleanup_memtype_use
                          |          ttm_bo_release
                          |          kref_put
                          |          ttm_bo_unref
                          |          nouveau_gem_object_del
                          |          drm_gem_object_free
                          |          kref_put
                          |          drm_gem_object_unreference_unlocked
                          |          drm_gem_object_handle_unreference_unlocked.part.1
                          |          drm_gem_handle_delete
                          |          drm_gem_close_ioctl
                          |          drm_ioctl
                          |          do_vfs_ioctl
                          |          sys_ioctl
                          |          system_call_fastpath
                          |          __GI___ioctl
                          |
                           --6.24%-- ttm_dma_pages_put
                                     ttm_dma_page_pool_free
                                     ttm_dma_unpopulate
                                     nouveau_ttm_tt_unpopulate
                                     ttm_tt_destroy
                                     ttm_bo_cleanup_memtype_use
                                     ttm_bo_release
                                     kref_put
                                     ttm_bo_unref
                                     nouveau_gem_object_del
                                     drm_gem_object_free
                                     kref_put
                                     drm_gem_object_unreference_unlocked
                                     drm_gem_object_handle_unreference_unlocked.part.1
                                     drm_gem_handle_delete
                                     drm_gem_close_ioctl
                                     drm_ioctl
                                     do_vfs_ioctl
                                     sys_ioctl
                                     system_call_fastpath
                                     __GI___ioctl

and after this patch all of that disappears.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
index 6678abc..6c06d0b 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
@@ -384,7 +384,9 @@ static void ttm_dma_pages_put(struct dma_pool *pool, struct list_head *d_pages,
 {
 	struct dma_page *d_page, *tmp;
 
-	if (npages && set_pages_array_wb(pages, npages))
+	/* Don't set WB on WB page pool. */
+	if (npages && !(pool->type & IS_CACHED) &&
+	    set_pages_array_wb(pages, npages))
 		pr_err(TTM_PFX "%s: Failed to set %d pages to wb!\n",
 			pool->dev_name, npages);
 
@@ -396,7 +398,8 @@ static void ttm_dma_pages_put(struct dma_pool *pool, struct list_head *d_pages,
 
 static void ttm_dma_page_put(struct dma_pool *pool, struct dma_page *d_page)
 {
-	if (set_pages_array_wb(&d_page->p, 1))
+	/* Don't set WB on WB page pool. */
+	if (!(pool->type & IS_CACHED) && set_pages_array_wb(&d_page->p, 1))
 		pr_err(TTM_PFX "%s: Failed to set %d pages to wb!\n",
 			pool->dev_name, 1);
 
-- 
1.7.7.4

