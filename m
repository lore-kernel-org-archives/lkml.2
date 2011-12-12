Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab1LLUKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 15:10:38 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:44007 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab1LLUKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 15:10:32 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, j.glisse@gmail.com,
        dri-devel@lists.freedesktop.org
Cc: bskeggs@redhat.com, thellstrom@vmware.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/3] drm/ttm/dma: Only call set_pages_array_wb when the page is not in WB pool.
Date: Mon, 12 Dec 2011 15:09:27 -0500
Message-Id: <1323720569-15435-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323720569-15435-1-git-send-email-konrad.wilk@oracle.com>
References: <1323720569-15435-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090207.4EE65FB3.0146,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we are doing redundant work. Especially since the 'unbind'
and 'unpopulate' have been merged and nouveau driver ends up calling
it quite excessivly. On a GeForce 8600 GT with Gnome Shell (GNOME 3)
we end up spending about 54% CPU time in __change_page_attr_set_clr
checking the page flags when I move the mouse cursor all over the screen.

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
1.7.7.3

