Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab2KENfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:35:04 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:34039 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754283Ab2KENfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:35:02 -0500
Message-ID: <5097C082.8000101@vmware.com>
Date: Mon, 05 Nov 2012 14:34:58 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Thomas Hellstrom <thellstrom@vmware.com>
CC: airlied@gmail.com, airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] drm/ttm, drm/vmwgfx: Use RCU locking for object lookups
References: <1352122278-12896-1-git-send-email-thellstrom@vmware.com> <1352122278-12896-4-git-send-email-thellstrom@vmware.com>
In-Reply-To: <1352122278-12896-4-git-send-email-thellstrom@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 02:31 PM, Thomas Hellstrom wrote:
> The mostly used lookup+get put+potential_destroy path of TTM objects
> is converted to use RCU locks. This will substantially decrease the amount
> of locked bus cycles during normal operation.
> Since we use kfree_rcu to free the objects, no rcu synchronization is needed
> at module unload time.
>
> Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
> ---
>   drivers/gpu/drm/ttm/ttm_object.c         |   30 +++++++++++-------------------
>   drivers/gpu/drm/vmwgfx/vmwgfx_resource.c |    8 ++++----
>   include/drm/ttm/ttm_object.h             |    4 ++++
>   include/linux/kref.h                     |    2 +-
>   4 files changed, 20 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/gpu/drm/ttm/ttm_object.c b/drivers/gpu/drm/ttm/ttm_object.c
> index c785787..9d7f674 100644
> --- a/drivers/gpu/drm/ttm/ttm_object.c
> +++ b/drivers/gpu/drm/ttm/ttm_object.c
> @@ -80,7 +80,7 @@ struct ttm_object_file {
>    */
>   
>   struct ttm_object_device {
> -	rwlock_t object_lock;
> +	spinlock_t object_lock;
>   	struct drm_open_hash object_hash;
>   	atomic_t object_count;
>   	struct ttm_mem_global *mem_glob;
> @@ -157,12 +157,12 @@ int ttm_base_object_init(struct ttm_object_file *tfile,
>   	base->refcount_release = refcount_release;
>   	base->ref_obj_release = ref_obj_release;
>   	base->object_type = object_type;
> -	write_lock(&tdev->object_lock);
> +	spin_lock(&tdev->object_lock);
>   	kref_init(&base->refcount);
>   	ret = drm_ht_just_insert_please(&tdev->object_hash,
>   					&base->hash,
>   					(unsigned long)base, 31, 0, 0);
> -	write_unlock(&tdev->object_lock);
> +	spin_unlock(&tdev->object_lock);
>   	if (unlikely(ret != 0))
>   		goto out_err0;
>   
> @@ -186,30 +186,22 @@ static void ttm_release_base(struct kref *kref)
>   	    container_of(kref, struct ttm_base_object, refcount);
>   	struct ttm_object_device *tdev = base->tfile->tdev;
>   
> +	spin_lock(&tdev->object_lock);
>   	(void)drm_ht_remove_item(&tdev->object_hash, &base->hash);
> -	write_unlock(&tdev->object_lock);
> +	spin_unlock(&tdev->object_lock);
>   	if (base->refcount_release) {
>   		ttm_object_file_unref(&base->tfile);
>   		base->refcount_release(&base);
>   	}
> -	write_lock(&tdev->object_lock);
>   }
>   
>   void ttm_base_object_unref(struct ttm_base_object **p_base)
>   {
>   	struct ttm_base_object *base = *p_base;
> -	struct ttm_object_device *tdev = base->tfile->tdev;
>   
>   	*p_base = NULL;
>   
> -	/*
> -	 * Need to take the lock here to avoid racing with
> -	 * users trying to look up the object.
> -	 */
> -
> -	write_lock(&tdev->object_lock);
>   	kref_put(&base->refcount, ttm_release_base);
> -	write_unlock(&tdev->object_lock);
>   }
>   EXPORT_SYMBOL(ttm_base_object_unref);
>   
> @@ -221,14 +213,14 @@ struct ttm_base_object *ttm_base_object_lookup(struct ttm_object_file *tfile,
>   	struct drm_hash_item *hash;
>   	int ret;
>   
> -	read_lock(&tdev->object_lock);
> +	rcu_read_lock();
>   	ret = drm_ht_find_item(&tdev->object_hash, key, &hash);
>   
>   	if (likely(ret == 0)) {
>   		base = drm_hash_entry(hash, struct ttm_base_object, hash);
> -		kref_get(&base->refcount);
> +		ret = kref_get_unless_zero(&base->refcount);
>   	}
> -	read_unlock(&tdev->object_lock);
> +	rcu_read_unlock();
>   
>   	if (unlikely(ret != 0))
>   		return NULL;
> @@ -426,7 +418,7 @@ struct ttm_object_device *ttm_object_device_init(struct ttm_mem_global
>   		return NULL;
>   
>   	tdev->mem_glob = mem_glob;
> -	rwlock_init(&tdev->object_lock);
> +	spin_lock_init(&tdev->object_lock);
>   	atomic_set(&tdev->object_count, 0);
>   	ret = drm_ht_create(&tdev->object_hash, hash_order);
>   
> @@ -444,9 +436,9 @@ void ttm_object_device_release(struct ttm_object_device **p_tdev)
>   
>   	*p_tdev = NULL;
>   
> -	write_lock(&tdev->object_lock);
> +	spin_lock(&tdev->object_lock);
>   	drm_ht_remove(&tdev->object_hash);
> -	write_unlock(&tdev->object_lock);
> +	spin_unlock(&tdev->object_lock);
>   
>   	kfree(tdev);
>   }
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
> index da3c6b5..ae675c6 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
> @@ -351,7 +351,7 @@ static void vmw_user_context_free(struct vmw_resource *res)
>   	    container_of(res, struct vmw_user_context, res);
>   	struct vmw_private *dev_priv = res->dev_priv;
>   
> -	kfree(ctx);
> +	ttm_base_object_kfree(ctx, base);
>   	ttm_mem_global_free(vmw_mem_glob(dev_priv),
>   			    vmw_user_context_size);
>   }
> @@ -1147,7 +1147,7 @@ static void vmw_user_surface_free(struct vmw_resource *res)
>   	kfree(srf->offsets);
>   	kfree(srf->sizes);
>   	kfree(srf->snooper.image);
> -	kfree(user_srf);
> +	ttm_base_object_kfree(user_srf, base);
>   	ttm_mem_global_free(vmw_mem_glob(dev_priv), size);
>   }
>   
> @@ -1575,7 +1575,7 @@ static void vmw_user_dmabuf_destroy(struct ttm_buffer_object *bo)
>   {
>   	struct vmw_user_dma_buffer *vmw_user_bo = vmw_user_dma_buffer(bo);
>   
> -	kfree(vmw_user_bo);
> +	ttm_base_object_kfree(vmw_user_bo, base);
>   }
>   
>   static void vmw_user_dmabuf_release(struct ttm_base_object **p_base)
> @@ -1763,7 +1763,7 @@ static void vmw_user_stream_free(struct vmw_resource *res)
>   	    container_of(res, struct vmw_user_stream, stream.res);
>   	struct vmw_private *dev_priv = res->dev_priv;
>   
> -	kfree(stream);
> +	ttm_base_object_kfree(stream, base);
>   	ttm_mem_global_free(vmw_mem_glob(dev_priv),
>   			    vmw_user_stream_size);
>   }
> diff --git a/include/drm/ttm/ttm_object.h b/include/drm/ttm/ttm_object.h
> index b01c563..fc0cf06 100644
> --- a/include/drm/ttm/ttm_object.h
> +++ b/include/drm/ttm/ttm_object.h
> @@ -40,6 +40,7 @@
>   #include <linux/list.h>
>   #include <drm/drm_hashtab.h>
>   #include <linux/kref.h>
> +#include <linux/rcupdate.h>
>   #include <ttm/ttm_memory.h>
>   
>   /**
> @@ -120,6 +121,7 @@ struct ttm_object_device;
>    */
>   
>   struct ttm_base_object {
> +	struct rcu_head rhead;
>   	struct drm_hash_item hash;
>   	enum ttm_object_type object_type;
>   	bool shareable;
> @@ -268,4 +270,6 @@ extern struct ttm_object_device *ttm_object_device_init
>   
>   extern void ttm_object_device_release(struct ttm_object_device **p_tdev);
>   
> +#define ttm_base_object_kfree(__object, __base)\
> +	kfree_rcu(__object, __base.rhead)
>   #endif
> diff --git a/include/linux/kref.h b/include/linux/kref.h
> index fd16042..bae91d0 100644
> --- a/include/linux/kref.h
> +++ b/include/linux/kref.h
> @@ -117,7 +117,7 @@ static inline int kref_put_mutex(struct kref *kref,
>    * @kref: object.
>    *
>    * Return 0 if the increment succeeded. Otherwise return non-zero.
> -
> + *
>    * This function is intended to simplify locking around refcounting for
>    * objects that can be looked up from a lookup structure, and which are
>    * removed from that lookup structure in the object destructor.

Hmm, This patch looks bad. I'll respin it.
/Thomas

