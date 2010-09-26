Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370Ab0IZX3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 19:29:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:17730 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab0IZX3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 19:29:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ZrU7Rfwe0jPGcA95XBn5p8CuKu13G3OaEt2Ck1UiXStmJvmtEuc7SsvGmd8noksPB
	ieU4u8gT2X3O+odAYtnfQ==
Date: Sun, 26 Sep 2010 16:29:23 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Chris Wilson <chris@chris-wilson.co.uk>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Christoph Hellwig <hch@infradead.org>
Subject: Re: How best to pin pages in physical memory?
In-Reply-To: <8u3s8d$jmkug0@orsmga001.jf.intel.com>
Message-ID: <alpine.LSU.2.00.1009261559540.11745@sister.anvils>
References: <8u3s8d$jmkug0@orsmga001.jf.intel.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Sep 2010, Chris Wilson wrote:

> This morning I came to the sickening conclusion that there is
> nothing in the drm/i915 driver that prevents the VM from swapping out
> pages mapped into the GTT (i.e. pages that are currently being written
> to or read from the GPU).

I'd expect that to be done by getting or raising the page_count on each
page needed, as get_user_pages() does for pages mapped into userspace.

And i915_gem_object_bind_to_gtt() calls a function
i915_get_object_get_pages() which appears to do just what's needed.
With i915_gem_object_unbind() calling i915_gem_object_put_pages().

> 
> The following patch is what I hastily threw together after grepping the
> sources for likely methods. A couple of considerations that need to be
> taken into account are:

Ingenious (or perhaps natural once you grep for shmem and lock: most
of us have forgotten mapping_set_unevictable if we ever knew it), but
potentially racy: what of pages already on their way to being evicted
when you call this?  SHM locking can tolerate that race, GEM cannot.
 
> 
> 1. Not all pages allocated through the shmfs get_pages() allocator that
> backs each GEM buffer object is mapped into the GTT. Though the actual
> quantity of such pages are small and temporary
> 
> 2. The GTT may be as large as 2GiB + a separate 2GiB that can be used
> for a per-process GTT.

There's a lot to be said for putting an amount that large on the
unevictable page list, instead of leaving it clogging up the lists
which vmscan searches for pages to evict: so your patch may be a
very good idea in the long run...

> 
> 3. Forced eviction is currently the shrinker, which may wait upon the
> GPU to finish and then unbind the pages from the GTT (and attempt to
> return the memory to the system). It might be useful to throttle the GPU
> and return the pages earlier to prevent the system from swapping?
> 
> If this looks like the continuation of the memory corruption saga caused
> by i915.ko during suspend, it is.

... but if you're trying to fix an i915 memory corruption issue, I bet
you are not all that interested in tuning mm's pageout heuristics at
the moment, and rightly so.

If i915_get_object_get_pages() isn't doing its job, I think you need to
wonder why not - maybe somewhere doing a put_page or page_cache_release,
freeing one or all pages too soon?

Hugh

> -Chris
> 
> ---
> From b3844cc3bd6fcbee7bbad640c91323f26904c1ce Mon Sep 17 00:00:00 2001
> From: Chris Wilson <chris@chris-wilson.co.uk>
> Date: Sun, 26 Sep 2010 10:11:53 +0100
> Subject: [PATCH] drm/i915: Mark pages mapped into the GTT as unevictable
> 
> If the GPU is currently reading and writing to pages, we need to prevent
> the VM from swapping those out to disk...
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> ---
>  drivers/gpu/drm/i915/i915_gem.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> index 9f547ab..5fa6227 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -1532,6 +1532,23 @@ i915_gem_mmap_gtt_ioctl(struct drm_device *dev, void *data,
>  	return 0;
>  }
>  
> +static void
> +i915_gem_object_lock_pages(struct drm_i915_gem_object *obj, bool lock)
> +{
> +	struct address_space *mapping;
> +	struct inode *inode;
> +
> +	inode = obj->base.filp->f_path.dentry->d_inode;
> +	mapping = inode->i_mapping;
> +
> +	if (lock) {
> +		mapping_set_unevictable(mapping);
> +	} else {
> +		mapping_clear_unevictable(mapping);
> +		scan_mapping_unevictable_pages(mapping);
> +	}
> +}
> +
>  void
>  i915_gem_object_put_pages(struct drm_gem_object *obj)
>  {
> @@ -2150,6 +2167,7 @@ i915_gem_object_unbind(struct drm_gem_object *obj)
>  
>  	list_del_init(&obj_priv->list);
>  
> +	i915_gem_object_lock_pages(obj_priv, false);
>  	if (i915_gem_object_is_purgeable(obj_priv))
>  		i915_gem_object_truncate(obj);
>  
> @@ -2751,6 +2769,7 @@ i915_gem_object_bind_to_gtt(struct drm_gem_object *obj,
>  
>  	obj_priv->mappable =
>  		obj_priv->gtt_offset + obj->size <= dev_priv->mm.gtt_mappable_end;
> +	i915_gem_object_lock_pages(obj_priv, true);
>  
>  	return 0;
>  }
> -- 
> 1.7.1
> 
> -- 
> Chris Wilson, Intel Open Source Technology Centre
