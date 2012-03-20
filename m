Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182Ab2CTKQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 06:16:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50632 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab2CTKQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 06:16:22 -0400
X-IronPort-AV: E=Sophos;i="4.73,617,1325433600"; 
   d="scan'208";a="4579989"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [RFC PATCH 2/6] slub: add kmalloc_align()
Date: Tue, 20 Mar 2012 18:21:20 +0800
Message-Id: <1332238884-6237-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com>
References: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-20 18:14:11,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-20 18:14:12,
	Serialize complete at 2012-03-20 18:14:12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ALIGN_OF_LAST_BIT(size) is used instead of
ARCH_KMALLOC_MINALIGN when kmalloc kmem_caches are created.

No behavior changed except debug.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/slub_def.h |    6 ++++++
 mm/slub.c                |    2 +-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index a32bcfd..67ac6b4 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -280,6 +280,12 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
 	return __kmalloc(size, flags);
 }
 
+static __always_inline
+void *kmalloc_align(size_t size, gfp_t flags, size_t align)
+{
+	return kmalloc(ALIGN(size, align), flags);
+}
+
 #ifdef CONFIG_NUMA
 void *__kmalloc_node(size_t size, gfp_t flags, int node);
 void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
diff --git a/mm/slub.c b/mm/slub.c
index 4907563..01cf99d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3238,7 +3238,7 @@ static struct kmem_cache *__init create_kmalloc_cache(const char *name,
 	 * This function is called with IRQs disabled during early-boot on
 	 * single CPU so there's no need to take slub_lock here.
 	 */
-	if (!kmem_cache_open(s, name, size, ARCH_KMALLOC_MINALIGN,
+	if (!kmem_cache_open(s, name, size, ALIGN_OF_LAST_BIT(size),
 								flags, NULL))
 		goto panic;
 
-- 
1.7.4.4

