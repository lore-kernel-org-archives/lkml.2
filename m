Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318Ab2CTKQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 06:16:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50632 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758618Ab2CTKQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 06:16:24 -0400
X-IronPort-AV: E=Sophos;i="4.73,617,1325433600"; 
   d="scan'208";a="4579992"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [RFC PATCH 3/6] slab: add kmalloc_align()
Date: Tue, 20 Mar 2012 18:21:21 +0800
Message-Id: <1332238884-6237-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com>
References: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-20 18:14:11,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-20 18:14:13,
	Serialize complete at 2012-03-20 18:14:13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ALIGN_OF_LAST_BIT(sizes[INDEX_AC].cs_size) is used instead of
ARCH_KMALLOC_MINALIGN when kmalloc kmem_caches are created.

No behavior changed except debug.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/slab_def.h |    6 ++++++
 mm/slab.c                |    8 ++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index fbd1117..fb0c8ab 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -159,6 +159,12 @@ found:
 	return __kmalloc(size, flags);
 }
 
+static __always_inline
+void *kmalloc_align(size_t size, gfp_t flags, size_t align)
+{
+	return kmalloc(ALIGN(size, align), flags);
+}
+
 #ifdef CONFIG_NUMA
 extern void *__kmalloc_node(size_t size, gfp_t flags, int node);
 extern void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
diff --git a/mm/slab.c b/mm/slab.c
index f0bd785..df8edbe 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1587,7 +1587,7 @@ void __init kmem_cache_init(void)
 
 	sizes[INDEX_AC].cs_cachep = kmem_cache_create(names[INDEX_AC].name,
 					sizes[INDEX_AC].cs_size,
-					ARCH_KMALLOC_MINALIGN,
+					ALIGN_OF_LAST_BIT(sizes[INDEX_AC].cs_size),
 					ARCH_KMALLOC_FLAGS|SLAB_PANIC,
 					NULL);
 
@@ -1595,7 +1595,7 @@ void __init kmem_cache_init(void)
 		sizes[INDEX_L3].cs_cachep =
 			kmem_cache_create(names[INDEX_L3].name,
 				sizes[INDEX_L3].cs_size,
-				ARCH_KMALLOC_MINALIGN,
+				ALIGN_OF_LAST_BIT(sizes[INDEX_L3].cs_size),
 				ARCH_KMALLOC_FLAGS|SLAB_PANIC,
 				NULL);
 	}
@@ -1613,7 +1613,7 @@ void __init kmem_cache_init(void)
 		if (!sizes->cs_cachep) {
 			sizes->cs_cachep = kmem_cache_create(names->name,
 					sizes->cs_size,
-					ARCH_KMALLOC_MINALIGN,
+					ALIGN_OF_LAST_BIT(sizes->cs_size),
 					ARCH_KMALLOC_FLAGS|SLAB_PANIC,
 					NULL);
 		}
@@ -1621,7 +1621,7 @@ void __init kmem_cache_init(void)
 		sizes->cs_dmacachep = kmem_cache_create(
 					names->name_dma,
 					sizes->cs_size,
-					ARCH_KMALLOC_MINALIGN,
+					ALIGN_OF_LAST_BIT(sizes->cs_size),
 					ARCH_KMALLOC_FLAGS|SLAB_CACHE_DMA|
 						SLAB_PANIC,
 					NULL);
-- 
1.7.4.4

