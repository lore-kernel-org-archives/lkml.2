Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab0HXKuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 06:50:37 -0400
Received: from smtp-out.google.com ([74.125.121.35]:44562 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab0HXKuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 06:50:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=V4wb4HA4ywMWKfJ1nNfOZn37uFoZ1wyEYD1MSuCJs1wq121PeWCXpYHW40n/aippS
	V9pPpt5jo/mGNceueZEJg==
Date: Tue, 24 Aug 2010 03:50:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Steven Whitehouse <swhiteho@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [patch 2/5] mm: add nofail variant of kmem_cache_zalloc
In-Reply-To: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1008240346180.19596@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kmem_cache_zalloc_nofail().  This function is equivalent to
kmem_cache_zalloc(), except that it will never return NULL and instead
loop forever trying to allocate memory.

If the first allocation attempt fails, a warning will be emitted,
including a call trace.  Subsequent failures will suppress this warning.

This was added as a helper function for documentation and auditability.
No future callers should be added.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/gfs2/meta_io.c    |    2 +-
 include/linux/slab.h |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -289,7 +289,7 @@ void gfs2_attach_bufdata(struct gfs2_glock *gl, struct buffer_head *bh,
 		return;
 	}
 
-	bd = kmem_cache_zalloc(gfs2_bufdata_cachep, GFP_NOFS | __GFP_NOFAIL);
+	bd = kmem_cache_zalloc_nofail(gfs2_bufdata_cachep, GFP_NOFS);
 	bd->bd_bh = bh;
 	bd->bd_gl = gl;
 
diff --git a/include/linux/slab.h b/include/linux/slab.h
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -313,6 +313,24 @@ static inline void *kmem_cache_zalloc(struct kmem_cache *k, gfp_t flags)
 	return kmem_cache_alloc(k, flags | __GFP_ZERO);
 }
 
+/*
+ * NOTE: no new callers of this function should be implemented!
+ * All memory allocations should be failable whenever possible.
+ */
+static inline void *kmem_cache_zalloc_nofail(struct kmem_cache *k, gfp_t flags)
+{
+	void *ret;
+
+	for (;;) {
+		ret = kmem_cache_zalloc(k, flags);
+		if (ret)
+			return ret;
+		WARN_ONCE(1, "Out of memory, no fallback implemented "
+				"(flags=0x%x)\n",
+				flags);
+	}
+}
+
 /**
  * kzalloc - allocate memory. The memory is set to zero.
  * @size: how many bytes of memory are required.
