Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab1FFEbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 00:31:08 -0400
Received: from smtp-out.google.com ([74.125.121.67]:25670 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab1FFEbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 00:31:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=I/ftUdNATaJinGP8/FQFMiuM1j8aWPah5PYimF/5yt9q1fThmPcfGMyJTDXR4OeNcU
         SAQUChvrx6irQ/hazVOQ==
Date: Sun, 5 Jun 2011 21:31:03 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Hellwig <hch@infradead.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 6/14] drm/i915: use shmem_read_mapping_page
In-Reply-To: <alpine.LSU.2.00.1106052116350.17116@sister.anvils>
Message-ID: <alpine.LSU.2.00.1106052129150.17116@sister.anvils>
References: <alpine.LSU.2.00.1106052116350.17116@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soon tmpfs will stop supporting ->readpage and read_cache_page_gfp():
once "tmpfs: add shmem_read_mapping_page_gfp" has been applied,
this patch can be applied to ease the transition.

Make i915_gem_object_get_pages_gtt() use shmem_read_mapping_page_gfp()
in the one place it's needed; elsewhere use shmem_read_mapping_page(),
with the mapping's gfp_mask properly initialized.

Forget about __GFP_COLD: since tmpfs initializes its pages with memset,
asking for a cold page is counter-productive.

Include linux/shmem_fs.h also in drm_gem.c: with shmem_file_setup() now
declared there too, we shall remove the prototype from linux/mm.h later.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/drm_gem.c       |    1 
 drivers/gpu/drm/i915/i915_gem.c |   31 +++++++++++++-----------------
 2 files changed, 15 insertions(+), 17 deletions(-)

--- linux.orig/drivers/gpu/drm/i915/i915_gem.c	2011-05-29 18:42:31.789854626 -0700
+++ linux/drivers/gpu/drm/i915/i915_gem.c	2011-06-05 18:37:13.589743574 -0700
@@ -31,6 +31,7 @@
 #include "i915_drv.h"
 #include "i915_trace.h"
 #include "intel_drv.h"
+#include <linux/shmem_fs.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
 #include <linux/pci.h>
@@ -359,8 +360,7 @@ i915_gem_shmem_pread_fast(struct drm_dev
 		if ((page_offset + remain) > PAGE_SIZE)
 			page_length = PAGE_SIZE - page_offset;
 
-		page = read_cache_page_gfp(mapping, offset >> PAGE_SHIFT,
-					   GFP_HIGHUSER | __GFP_RECLAIMABLE);
+		page = shmem_read_mapping_page(mapping, offset >> PAGE_SHIFT);
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 
@@ -463,8 +463,7 @@ i915_gem_shmem_pread_slow(struct drm_dev
 		if ((data_page_offset + page_length) > PAGE_SIZE)
 			page_length = PAGE_SIZE - data_page_offset;
 
-		page = read_cache_page_gfp(mapping, offset >> PAGE_SHIFT,
-					   GFP_HIGHUSER | __GFP_RECLAIMABLE);
+		page = shmem_read_mapping_page(mapping, offset >> PAGE_SHIFT);
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 
@@ -796,8 +795,7 @@ i915_gem_shmem_pwrite_fast(struct drm_de
 		if ((page_offset + remain) > PAGE_SIZE)
 			page_length = PAGE_SIZE - page_offset;
 
-		page = read_cache_page_gfp(mapping, offset >> PAGE_SHIFT,
-					   GFP_HIGHUSER | __GFP_RECLAIMABLE);
+		page = shmem_read_mapping_page(mapping, offset >> PAGE_SHIFT);
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 
@@ -906,8 +904,7 @@ i915_gem_shmem_pwrite_slow(struct drm_de
 		if ((data_page_offset + page_length) > PAGE_SIZE)
 			page_length = PAGE_SIZE - data_page_offset;
 
-		page = read_cache_page_gfp(mapping, offset >> PAGE_SHIFT,
-					   GFP_HIGHUSER | __GFP_RECLAIMABLE);
+		page = shmem_read_mapping_page(mapping, offset >> PAGE_SHIFT);
 		if (IS_ERR(page)) {
 			ret = PTR_ERR(page);
 			goto out;
@@ -1556,12 +1553,10 @@ i915_gem_object_get_pages_gtt(struct drm
 
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
 
@@ -3565,6 +3560,7 @@ struct drm_i915_gem_object *i915_gem_all
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct drm_i915_gem_object *obj;
+	struct address_space *mapping;
 
 	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
 	if (obj == NULL)
@@ -3575,6 +3571,9 @@ struct drm_i915_gem_object *i915_gem_all
 		return NULL;
 	}
 
+	mapping = obj->base.filp->f_path.dentry->d_inode->i_mapping;
+	mapping_set_gfp_mask(mapping, GFP_HIGHUSER | __GFP_RECLAIMABLE);
+
 	i915_gem_info_add_obj(dev_priv, size);
 
 	obj->base.write_domain = I915_GEM_DOMAIN_CPU;
@@ -3950,8 +3949,7 @@ void i915_gem_detach_phys_object(struct
 
 	page_count = obj->base.size / PAGE_SIZE;
 	for (i = 0; i < page_count; i++) {
-		struct page *page = read_cache_page_gfp(mapping, i,
-							GFP_HIGHUSER | __GFP_RECLAIMABLE);
+		struct page *page = shmem_read_mapping_page(mapping, i);
 		if (!IS_ERR(page)) {
 			char *dst = kmap_atomic(page);
 			memcpy(dst, vaddr + i*PAGE_SIZE, PAGE_SIZE);
@@ -4012,8 +4010,7 @@ i915_gem_attach_phys_object(struct drm_d
 		struct page *page;
 		char *dst, *src;
 
-		page = read_cache_page_gfp(mapping, i,
-					   GFP_HIGHUSER | __GFP_RECLAIMABLE);
+		page = shmem_read_mapping_page(mapping, i);
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 
--- linux.orig/drivers/gpu/drm/drm_gem.c	2011-05-18 21:06:34.000000000 -0700
+++ linux/drivers/gpu/drm/drm_gem.c	2011-06-05 18:38:18.874063036 -0700
@@ -34,6 +34,7 @@
 #include <linux/module.h>
 #include <linux/mman.h>
 #include <linux/pagemap.h>
+#include <linux/shmem_fs.h>
 #include "drmP.h"
 
 /** @file drm_gem.c
