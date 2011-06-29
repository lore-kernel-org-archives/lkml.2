Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab1F2Asb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 20:48:31 -0400
Received: from mail.candelatech.com ([208.74.158.172]:49685 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab1F2AsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 20:48:23 -0400
From: greearb@candelatech.com
To: penberg@kernel.org, cl@linux.com, linux-kernel@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 2/2] slub:  Add method to verify memory is not freed.
Date: Tue, 28 Jun 2011 17:47:42 -0700
Message-Id: <1309308462-20124-3-git-send-email-greearb@candelatech.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1309308462-20124-1-git-send-email-greearb@candelatech.com>
References: <1309308462-20124-1-git-send-email-greearb@candelatech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

This is for tracking down suspect memory usage.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Fix issues brought up in review.

:100644 100644 ad4dd1c... 916ce0f... M	include/linux/slab.h
:100644 100644 3477ce5... f64caca... M	mm/slub.c
 include/linux/slab.h |   13 +++++++++++++
 mm/slub.c            |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index ad4dd1c..916ce0f 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -302,6 +302,19 @@ extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, unsigned long);
 
 #endif /* CONFIG_NUMA */
 
+/**
+ * Calling this on allocated memory will check that the memory
+ * is expected to be in use, and print warnings if not.
+ */
+#if defined(CONFIG_SLUB) && defined(CONFIG_SLUB_DEBUG)
+extern bool verify_mem_not_deleted(const void *x);
+#else
+static inline bool verify_mem_not_deleted(const void *x)
+{
+	return true;
+}
+#endif
+
 /*
  * Shortcuts
  */
diff --git a/mm/slub.c b/mm/slub.c
index 3477ce5..f64caca 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2958,6 +2958,42 @@ size_t ksize(const void *object)
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

