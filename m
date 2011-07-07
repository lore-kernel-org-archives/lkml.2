Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab1GGShJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:37:09 -0400
Received: from mail.candelatech.com ([208.74.158.172]:38844 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1GGShC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:37:02 -0400
From: greearb@candelatech.com
To: penberg@kernel.org, cl@linux.com, linux-kernel@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3 2/2] slub:  Add method to verify memory is not freed.
Date: Thu,  7 Jul 2011 11:36:37 -0700
Message-Id: <1310063797-14914-2-git-send-email-greearb@candelatech.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1310063797-14914-1-git-send-email-greearb@candelatech.com>
References: <1310063797-14914-1-git-send-email-greearb@candelatech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

This is for tracking down suspect memory usage.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v3:  Move the verify_mem_not_deleted logic from slab.h to slub_dev.h

:100644 100644 c8668d1... eec67ce... M	include/linux/slub_def.h
:100644 100644 c52fa60... b2dfc52... M	mm/slub.c
 include/linux/slub_def.h |   13 +++++++++++++
 mm/slub.c                |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index c8668d1..eec67ce 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -228,6 +228,19 @@ kmalloc_order(size_t size, gfp_t flags, unsigned int order)
 	return ret;
 }
 
+/**
+ * Calling this on allocated memory will check that the memory
+ * is expected to be in use, and print warnings if not.
+ */
+#ifdef CONFIG_SLUB_DEBUG
+extern bool verify_mem_not_deleted(const void *x);
+#else
+static inline bool verify_mem_not_deleted(const void *x)
+{
+	return true;
+}
+#endif
+
 #ifdef CONFIG_TRACING
 extern void *
 kmem_cache_alloc_trace(struct kmem_cache *s, gfp_t gfpflags, size_t size);
diff --git a/mm/slub.c b/mm/slub.c
index c52fa60..b2dfc52 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2960,6 +2960,42 @@ size_t ksize(const void *object)
 }
 EXPORT_SYMBOL(ksize);
 
+#ifdef CONFIG_SLUB_DEBUG
+bool verify_mem_not_deleted(const void *x)
+{
+	struct page *page;
+	void *object = (void *)x;
+	unsigned long flags;
+	bool rv;
+
+	if (unlikely(ZERO_OR_NULL_PTR(x)))
+		return false;
+
+	local_irq_save(flags);
+
+	page = virt_to_head_page(x);
+	if (unlikely(!PageSlab(page))) {
+		/* maybe it was from stack? */
+		rv = true;
+		goto out_unlock;
+	}
+
+	slab_lock(page);
+	if (on_freelist(page->slab, page, object)) {
+		object_err(page->slab, page, object, "Object is on free-list");
+		rv = false;
+	} else {
+		rv = true;
+	}
+	slab_unlock(page);
+
+out_unlock:
+	local_irq_restore(flags);
+	return rv;
+}
+EXPORT_SYMBOL(verify_mem_not_deleted);
+#endif
+
 void kfree(const void *x)
 {
 	struct page *page;
-- 
1.7.3.4

