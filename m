Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab1F0XRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 19:17:38 -0400
Received: from mail.candelatech.com ([208.74.158.172]:43779 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393Ab1F0XRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 19:17:34 -0400
From: greearb@candelatech.com
To: linux-kernel@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/2] slub:  Add method to verify memory is not deleted.
Date: Mon, 27 Jun 2011 16:17:11 -0700
Message-Id: <1309216631-31493-3-git-send-email-greearb@candelatech.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1309216631-31493-1-git-send-email-greearb@candelatech.com>
References: <1309216631-31493-1-git-send-email-greearb@candelatech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

This is for tracking down suspect memory usage.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 ad4dd1c... 35a13d2... M	include/linux/slab.h
:100644 100644 14d0135... b3d7680... M	mm/slub.c
 include/linux/slab.h |    9 +++++++++
 mm/slub.c            |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index ad4dd1c..35a13d2 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -302,6 +302,15 @@ extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, unsigned long);
 
 #endif /* CONFIG_NUMA */
 
+/** Calling this on deleted objects will print some
+ * SLUB debugging information.
+ */
+#if defined(CONFIG_SLUB) && defined(CONFIG_SLUB_DEBUG)
+extern bool verify_mem_not_deleted(const void *x);
+#else
+#define verify_mem_not_deleted(x)
+#endif
+
 /*
  * Shortcuts
  */
diff --git a/mm/slub.c b/mm/slub.c
index 14d0135..b3d7680 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2953,6 +2953,40 @@ size_t ksize(const void *object)
 }
 EXPORT_SYMBOL(ksize);
 
+#if defined(CONFIG_SLUB_DEBUG)
+bool verify_mem_not_deleted(const void *x)
+{
+	struct page *page;
+	void *object = (void *)x;
+	struct kmem_cache *s;
+	unsigned long flags;
+	bool rv = false;
+
+	if (unlikely(ZERO_OR_NULL_PTR(x)))
+		false;
+
+	local_irq_save(flags);
+
+	page = virt_to_head_page(x);
+	if (unlikely(!PageSlab(page))) {
+		BUG_ON(!PageCompound(page));
+		goto out_unlock;
+	}
+
+	s = page->slab;
+
+	if (on_freelist(s, page, object)) {
+		object_err(s, page, object, "Object is on fee-list");
+		goto out_unlock;
+	}
+	rv = true;
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

