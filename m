Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843Ab1I2UeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:34:15 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:44931 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab1I2UeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:34:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, thellstrom@vmware.com,
        dri-devel@lists.freedesktop.org, bskeggs@redhat.com,
        j.glisse@redhat.com, thomas@shipmail.org, airlied@redhat.com,
        airlied@linux.ie, alexdeucher@gmail.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 8/9] ttm/tt: Move ttm_tt_set_page_caching implementation in TTM page pool code.
Date: Thu, 29 Sep 2011 16:33:51 -0400
Message-Id: <1317328432-25620-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317328432-25620-1-git-send-email-konrad.wilk@oracle.com>
References: <1317328432-25620-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet23.oracle.com [156.151.31.71]
X-CT-RefId: str=0001.0A090203.4E84D63E.0084,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. and provide in the function callback a method to register
with the backend a new (*set_caching).

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/ttm/ttm_page_alloc.c |   46 ++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/ttm/ttm_tt.c         |   46 +++++----------------------------
 include/drm/ttm/ttm_page_alloc.h     |   29 +++++++++++++++++++++
 3 files changed, 82 insertions(+), 39 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index f9a4d83..002f64f 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -455,6 +455,36 @@ static int ttm_set_pages_caching(struct page **pages,
 	return r;
 }
 
+#ifdef CONFIG_X86
+static int __ttm_page_set_page_caching(struct page *p,
+				       int flags,
+				       enum ttm_caching_state c_old,
+				       enum ttm_caching_state c_new,
+				       struct device *dev)
+{
+	int ret = 0;
+
+	if (PageHighMem(p))
+		return 0;
+
+	if (c_old != tt_cached) {
+		/* p isn't in the default caching state, set it to
+		 * writeback first to free its current memtype. */
+
+		ret = set_pages_wb(p, 1);
+		if (ret)
+			return ret;
+	}
+
+	if (c_new == tt_wc)
+		ret = set_memory_wc((unsigned long) page_address(p), 1);
+	else if (c_new == tt_uncached)
+		ret = set_pages_uc(p, 1);
+
+	return ret;
+}
+#endif
+
 /**
  * Free pages the pages that failed to change the caching state. If there is
  * any pages that have changed their caching state already put them to the
@@ -865,6 +895,9 @@ struct ttm_page_alloc_func ttm_page_alloc_default = {
 	.alloc_init	= __ttm_page_alloc_init,
 	.alloc_fini	= __ttm_page_alloc_fini,
 	.debugfs	= __ttm_page_alloc_debugfs,
+#ifdef CONFIG_X86
+	.set_caching	= __ttm_page_set_page_caching,
+#endif
 };
 
 int ttm_get_pages(struct list_head *pages, int flags,
@@ -902,3 +935,16 @@ int ttm_page_alloc_debugfs(struct seq_file *m, void *data)
 	return -1;
 }
 EXPORT_SYMBOL(ttm_page_alloc_debugfs);
+
+#ifdef CONFIG_X86
+int ttm_tt_set_page_caching(struct page *p,
+			    int flags,
+			    enum ttm_caching_state c_old,
+			    enum ttm_caching_state c_new,
+			    struct device *dev)
+{
+	if (ttm_page_alloc && ttm_page_alloc->set_caching)
+		return ttm_page_alloc->set_caching(p, flags, c_old, c_new, dev);
+	return -1;
+}
+#endif
diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index 1f11a33..0f5ce97 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -176,41 +176,6 @@ int ttm_tt_populate(struct ttm_tt *ttm)
 }
 EXPORT_SYMBOL(ttm_tt_populate);
 
-#ifdef CONFIG_X86
-static inline int ttm_tt_set_page_caching(struct page *p,
-					  enum ttm_caching_state c_old,
-					  enum ttm_caching_state c_new)
-{
-	int ret = 0;
-
-	if (PageHighMem(p))
-		return 0;
-
-	if (c_old != tt_cached) {
-		/* p isn't in the default caching state, set it to
-		 * writeback first to free its current memtype. */
-
-		ret = set_pages_wb(p, 1);
-		if (ret)
-			return ret;
-	}
-
-	if (c_new == tt_wc)
-		ret = set_memory_wc((unsigned long) page_address(p), 1);
-	else if (c_new == tt_uncached)
-		ret = set_pages_uc(p, 1);
-
-	return ret;
-}
-#else /* CONFIG_X86 */
-static inline int ttm_tt_set_page_caching(struct page *p,
-					  enum ttm_caching_state c_old,
-					  enum ttm_caching_state c_new)
-{
-	return 0;
-}
-#endif /* CONFIG_X86 */
-
 /*
  * Change caching policy for the linear kernel map
  * for range of pages in a ttm.
@@ -238,9 +203,9 @@ static int ttm_tt_set_caching(struct ttm_tt *ttm,
 	for (i = 0; i < ttm->num_pages; ++i) {
 		cur_page = ttm->pages[i];
 		if (likely(cur_page != NULL)) {
-			ret = ttm_tt_set_page_caching(cur_page,
+			ret = ttm_tt_set_page_caching(cur_page, ttm->page_flags,
 						      ttm->caching_state,
-						      c_state);
+						      c_state, ttm->dev);
 			if (unlikely(ret != 0))
 				goto out_err;
 		}
@@ -254,8 +219,11 @@ out_err:
 	for (j = 0; j < i; ++j) {
 		cur_page = ttm->pages[j];
 		if (likely(cur_page != NULL)) {
-			(void)ttm_tt_set_page_caching(cur_page, c_state,
-						      ttm->caching_state);
+			(void)ttm_tt_set_page_caching(cur_page,
+						      ttm->page_flags,
+						      c_state,
+						      ttm->caching_state,
+						      ttm->dev);
 		}
 	}
 
diff --git a/include/drm/ttm/ttm_page_alloc.h b/include/drm/ttm/ttm_page_alloc.h
index 1dde3bd..73ad03c 100644
--- a/include/drm/ttm/ttm_page_alloc.h
+++ b/include/drm/ttm/ttm_page_alloc.h
@@ -93,6 +93,18 @@ struct ttm_page_alloc_func {
 	 * Output the state of pools to debugfs file
 	 */
 	int (*debugfs)(struct seq_file *m, void *data);
+
+	/**
+	 *
+	 * struct ttm_page_alloc_func member set_caching
+	 *
+	 * Set the caching on the page retrieved from get_pages.
+	 */
+	int (*set_caching)(struct page *p,
+			   int flags,
+			   enum ttm_caching_state c_old,
+			   enum ttm_caching_state c_new,
+			   struct device *dev);
 };
 
 extern struct ttm_page_alloc_func *ttm_page_alloc;
@@ -163,4 +175,21 @@ void ttm_page_alloc_fini(void);
  * Output the state of pools to debugfs file
  */
 extern int ttm_page_alloc_debugfs(struct seq_file *m, void *data);
+
+#ifdef CONFIG_X86
+int ttm_tt_set_page_caching(struct page *p,
+			    int flags,
+			    enum ttm_caching_state c_old,
+			    enum ttm_caching_state c_new,
+			    struct device *dev);
+#else
+static inline int ttm_tt_set_page_caching(struct page *p,
+					  int flags,
+					  enum ttm_caching_state c_old,
+					  enum ttm_caching_state c_new,
+					  struct device *dev)
+{
+	return 0;
+}
+#endif
 #endif
-- 
1.7.4.1

