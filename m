Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab2AEPwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:52:05 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40899 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529Ab2AEPwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:52:04 -0500
Date: Thu, 5 Jan 2012 10:55:59 -0500
From: Jerome Glisse <j.glisse@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, thellstrom@vmware.co, airlied@linux.ie
Subject: Re: [PATCH 1/3] drm/ttm/dma: Only call set_pages_array_wb when the
 page is not in WB pool.
Message-ID: <20120105155559.GA2799@homer.localdomain>
References: <1325712916-27962-1-git-send-email-konrad.wilk@oracle.com>
 <1325712916-27962-2-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325712916-27962-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 04:35:14PM -0500, Konrad Rzeszutek Wilk wrote:
> Otherwise we are doing redundant work. Especially since the 'unbind'
> and 'unpopulate' have been merged and nouveau driver ends up calling
> it quite excessivly. On a GeForce 8600 GT with Gnome Shell (GNOME 3)
> we end up spending about 54% CPU time in __change_page_attr_set_clr
> checking the page flags.
> 
> The callgraph (annotated) looks as so before this patch:
> 
>     53.29%  gnome-shell  [kernel.kallsyms]                   [k] static_protections
>             |
>             --- static_protections
>                |
>                |--91.80%-- __change_page_attr_set_clr
>                |          change_page_attr_set_clr
>                |          set_pages_array_wb
>                |          |
>                |          |--96.55%-- ttm_dma_unpopulate
>                |          |          nouveau_ttm_tt_unpopulate
>                |          |          ttm_tt_destroy
>                |          |          ttm_bo_cleanup_memtype_use
>                |          |          ttm_bo_release
>                |          |          kref_put
>                |          |          ttm_bo_unref
>                |          |          nouveau_gem_object_del
>                |          |          drm_gem_object_free
>                |          |          kref_put
>                |          |          drm_gem_object_unreference_unlocked
>                |          |          drm_gem_object_handle_unreference_unlocked.part.1
>                |          |          drm_gem_handle_delete
>                |          |          drm_gem_close_ioctl
>                |          |          drm_ioctl
>                |          |          do_vfs_ioctl
>                |          |          sys_ioctl
>                |          |          system_call_fastpath
>                |          |          __GI___ioctl
>                |          |
>                |           --3.45%-- ttm_dma_pages_put
>                |                     ttm_dma_page_pool_free
>                |                     ttm_dma_unpopulate
>                |                     nouveau_ttm_tt_unpopulate
>                |                     ttm_tt_destroy
>                |                     ttm_bo_cleanup_memtype_use
>                |                     ttm_bo_release
>                |                     kref_put
>                |                     ttm_bo_unref
>                |                     nouveau_gem_object_del
>                |                     drm_gem_object_free
>                |                     kref_put
>                |                     drm_gem_object_unreference_unlocked
>                |                     drm_gem_object_handle_unreference_unlocked.part.1
>                |                     drm_gem_handle_delete
>                |                     drm_gem_close_ioctl
>                |                     drm_ioctl
>                |                     do_vfs_ioctl
>                |                     sys_ioctl
>                |                     system_call_fastpath
>                |                     __GI___ioctl
>                |
>                 --8.20%-- change_page_attr_set_clr
>                           set_pages_array_wb
>                           |
>                           |--93.76%-- ttm_dma_unpopulate
>                           |          nouveau_ttm_tt_unpopulate
>                           |          ttm_tt_destroy
>                           |          ttm_bo_cleanup_memtype_use
>                           |          ttm_bo_release
>                           |          kref_put
>                           |          ttm_bo_unref
>                           |          nouveau_gem_object_del
>                           |          drm_gem_object_free
>                           |          kref_put
>                           |          drm_gem_object_unreference_unlocked
>                           |          drm_gem_object_handle_unreference_unlocked.part.1
>                           |          drm_gem_handle_delete
>                           |          drm_gem_close_ioctl
>                           |          drm_ioctl
>                           |          do_vfs_ioctl
>                           |          sys_ioctl
>                           |          system_call_fastpath
>                           |          __GI___ioctl
>                           |
>                            --6.24%-- ttm_dma_pages_put
>                                      ttm_dma_page_pool_free
>                                      ttm_dma_unpopulate
>                                      nouveau_ttm_tt_unpopulate
>                                      ttm_tt_destroy
>                                      ttm_bo_cleanup_memtype_use
>                                      ttm_bo_release
>                                      kref_put
>                                      ttm_bo_unref
>                                      nouveau_gem_object_del
>                                      drm_gem_object_free
>                                      kref_put
>                                      drm_gem_object_unreference_unlocked
>                                      drm_gem_object_handle_unreference_unlocked.part.1
>                                      drm_gem_handle_delete
>                                      drm_gem_close_ioctl
>                                      drm_ioctl
>                                      do_vfs_ioctl
>                                      sys_ioctl
>                                      system_call_fastpath
>                                      __GI___ioctl
> 
> and after this patch all of that disappears.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
> ---
>  drivers/gpu/drm/ttm/ttm_page_alloc_dma.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> index 6678abc..6c06d0b 100644
> --- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> +++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> @@ -384,7 +384,9 @@ static void ttm_dma_pages_put(struct dma_pool *pool, struct list_head *d_pages,
>  {
>  	struct dma_page *d_page, *tmp;
>  
> -	if (npages && set_pages_array_wb(pages, npages))
> +	/* Don't set WB on WB page pool. */
> +	if (npages && !(pool->type & IS_CACHED) &&
> +	    set_pages_array_wb(pages, npages))
>  		pr_err(TTM_PFX "%s: Failed to set %d pages to wb!\n",
>  			pool->dev_name, npages);
>  
> @@ -396,7 +398,8 @@ static void ttm_dma_pages_put(struct dma_pool *pool, struct list_head *d_pages,
>  
>  static void ttm_dma_page_put(struct dma_pool *pool, struct dma_page *d_page)
>  {
> -	if (set_pages_array_wb(&d_page->p, 1))
> +	/* Don't set WB on WB page pool. */
> +	if (!(pool->type & IS_CACHED) && set_pages_array_wb(&d_page->p, 1))
>  		pr_err(TTM_PFX "%s: Failed to set %d pages to wb!\n",
>  			pool->dev_name, 1);
>  
> -- 
> 1.7.7.4
> 
