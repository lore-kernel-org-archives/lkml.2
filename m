Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab1GHBOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 21:14:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:36851 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab1GHBOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 21:14:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=MEs4J5JyApfVLKPtFw4fzUK+1mdD0pec4mSy8X2Lptf2gFEPbaVtKBlAubBxeTv+t
	Jg8x7Fqdt/SWIDXTqqJDw==
Date: Thu, 7 Jul 2011 18:14:12 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/49] gma500: the GEM and GTT code is device
 independant
In-Reply-To: <20110705144140.23872.86541.stgit@localhost.localdomain>
Message-ID: <alpine.LSU.2.00.1107071742250.10362@sister.anvils>
References: <20110705141038.23872.55303.stgit@localhost.localdomain> <20110705144140.23872.86541.stgit@localhost.localdomain>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Tue, 5 Jul 2011, Alan Cox wrote:
> From: Alan Cox <alan@linux.intel.com>
> 
> Rename the gem and gtt files accordingly.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>

This caught my eye, and I realize that I'm in the process of
sabotaging your work, or vice versa: sorry!

> +
> +	for (i = 0; i < pages; i++) {
> +		/* FIXME: review flags later */
> +		p = read_cache_page_gfp(mapping, i,
> +					__GFP_COLD | GFP_KERNEL);
...
> -
> -	for (i = 0; i < pages; i++) {
> -		/* FIXME: review flags later */
> -		p = read_cache_page_gfp(mapping, i,
> -					__GFP_COLD | GFP_KERNEL);

I've been eliminating drm/i915's calls to read_cache_page_gfp(),
while you've been adding them to staging/gma500.  It still works in
3.0-rc, but if my further changes go through from mmotm to 3.1-rc,
then read_cache_page_gfp() on a shmem/tmpfs file will crash on the
lack of a readpage method (we could easily make it error instead
of crash, but you'd probably prefer something that actually works).

As example, below is the patch where I updated drm/i915 to be ready
for the changeover.  They set __GFP_RECLAIMABLE on the mapping because
they've got a way to discard unpinned object pages when memory is tight;
and sometimes add in __GFP_NORETRY|__GFP_NOWARN when allocating.

I'm guessing you'd just want to use shmem_read_mapping_page() throughout,
after initializing mapping with the appropriate flags (GFP_HIGHUSER_MOVABLE
is fs/inode.c's default: maybe your pages aren't easily movable and you'd
better say GFP_HIGHUSER, or maybe you have reason to need GFP_KERNEL).

Hugh

commit 5949eac4d9b5bf936c12cb7ec3a09084c1326834
Author: Hugh Dickins <hughd@google.com>
Date:   Mon Jun 27 16:18:18 2011 -0700

    drm/i915: use shmem_read_mapping_page
    
    Soon tmpfs will stop supporting ->readpage and read_cache_page_gfp(): once
    "tmpfs: add shmem_read_mapping_page_gfp" has been applied, this patch can
    be applied to ease the transition.
    
    Make i915_gem_object_get_pages_gtt() use shmem_read_mapping_page_gfp() in
    the one place it's needed; elsewhere use shmem_read_mapping_page(), with
    the mapping's gfp_mask properly initialized.
    
    Forget about __GFP_COLD: since tmpfs initializes its pages with memset,
    asking for a cold page is counter-productive.
    
    Include linux/shmem_fs.h also in drm_gem.c: with shmem_file_setup() now
    declared there too, we shall remove the prototype from linux/mm.h later.
    
    Signed-off-by: Hugh Dickins <hughd@google.com>
    Cc: Christoph Hellwig <hch@infradead.org>
    Cc: Chris Wilson <chris@chris-wilson.co.uk>
    Cc: Keith Packard <keithp@keithp.com>
    Cc: Dave Airlie <airlied@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 74e4ff5..4012fe4 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -34,6 +34,7 @@
 #include <linux/module.h>
 #include <linux/mman.h>
 #include <linux/pagemap.h>
+#include <linux/shmem_fs.h>
 #include "drmP.h"
 
 /** @file drm_gem.c
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index c6389de..fa560ce 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -31,6 +31,7 @@
 #include "i915_drv.h"
 #include "i915_trace.h"
 #include "intel_drv.h"
+#include <linux/shmem_fs.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
 #include <linux/pci.h>
@@ -359,8 +360,7 @@ i915_gem_shmem_pread_fast(struct drm_device *dev,
 		if ((page_offset + remain) > PAGE_SIZE)
 			page_length = PAGE_SIZE - page_offset;
 
-		page = read_cache_page_gfp(mapping, offset >> PAGE_SHIFT,
-					   GFP_HIGHUSER | __GFP_RECLAIMABLE);
+		page = shmem_read_mapping_page(mapping, offset >> PAGE_SHIFT);
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 
@@ -463,8 +463,7 @@ i915_gem_shmem_pread_slow(struct drm_device *dev,
 		if ((data_page_offset + page_length) > PAGE_SIZE)
 			page_length = PAGE_SIZE - data_page_offset;
 
-		page = read_cache_page_gfp(mapping, offset >> PAGE_SHIFT,
-					   GFP_HIGHUSER | __GFP_RECLAIMABLE);
+		page = shmem_read_mapping_page(mapping, offset >> PAGE_SHIFT);
 		if (IS_ERR(page)) {
 			ret = PTR_ERR(page);
 			goto out;
@@ -797,8 +796,7 @@ i915_gem_shmem_pwrite_fast(struct drm_device *dev,
 		if ((page_offset + remain) > PAGE_SIZE)
 			page_length = PAGE_SIZE - page_offset;
 
-		page = read_cache_page_gfp(mapping, offset >> PAGE_SHIFT,
-					   GFP_HIGHUSER | __GFP_RECLAIMABLE);
+		page = shmem_read_mapping_page(mapping, offset >> PAGE_SHIFT);
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 
@@ -907,8 +905,7 @@ i915_gem_shmem_pwrite_slow(struct drm_device *dev,
 		if ((data_page_offset + page_length) > PAGE_SIZE)
 			page_length = PAGE_SIZE - data_page_offset;
 
-		page = read_cache_page_gfp(mapping, offset >> PAGE_SHIFT,
-					   GFP_HIGHUSER | __GFP_RECLAIMABLE);
+		page = shmem_read_mapping_page(mapping, offset >> PAGE_SHIFT);
 		if (IS_ERR(page)) {
 			ret = PTR_ERR(page);
 			goto out;
@@ -1558,12 +1555,10 @@ i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj,
 
 	inode = obj->base.filp->f_path.dentry->d_inode;
 	mapping = inode->i_mapping;
+	gfpmask |= mapping_gfp_mask(mapping);
+
 	for (i = 0; i < page_count; i++) {
-		page = read_cache_page_gfp(mapping, i,
-					   GFP_HIGHUSER |
-					   __GFP_COLD |
-					   __GFP_RECLAIMABLE |
-					   gfpmask);
+		page = shmem_read_mapping_page_gfp(mapping, i, gfpmask);
 		if (IS_ERR(page))
 			goto err_pages;
 
@@ -3565,6 +3560,7 @@ struct drm_i915_gem_object *i915_gem_alloc_object(struct drm_device *dev,
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct drm_i915_gem_object *obj;
+	struct address_space *mapping;
 
 	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
 	if (obj == NULL)
@@ -3575,6 +3571,9 @@ struct drm_i915_gem_object *i915_gem_alloc_object(struct drm_device *dev,
 		return NULL;
 	}
 
+	mapping = obj->base.filp->f_path.dentry->d_inode->i_mapping;
+	mapping_set_gfp_mask(mapping, GFP_HIGHUSER | __GFP_RECLAIMABLE);
+
 	i915_gem_info_add_obj(dev_priv, size);
 
 	obj->base.write_domain = I915_GEM_DOMAIN_CPU;
@@ -3950,8 +3949,7 @@ void i915_gem_detach_phys_object(struct drm_device *dev,
 
 	page_count = obj->base.size / PAGE_SIZE;
 	for (i = 0; i < page_count; i++) {
-		struct page *page = read_cache_page_gfp(mapping, i,
-							GFP_HIGHUSER | __GFP_RECLAIMABLE);
+		struct page *page = shmem_read_mapping_page(mapping, i);
 		if (!IS_ERR(page)) {
 			char *dst = kmap_atomic(page);
 			memcpy(dst, vaddr + i*PAGE_SIZE, PAGE_SIZE);
@@ -4012,8 +4010,7 @@ i915_gem_attach_phys_object(struct drm_device *dev,
 		struct page *page;
 		char *dst, *src;
 
-		page = read_cache_page_gfp(mapping, i,
-					   GFP_HIGHUSER | __GFP_RECLAIMABLE);
+		page = shmem_read_mapping_page(mapping, i);
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 

