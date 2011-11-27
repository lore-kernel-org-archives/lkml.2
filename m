Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab1K0F2P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:28:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab1K0F2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:28:08 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: =?UTF-8?q?=5BPATCH=2001/62=5D=20highmem=3A=20mark=20k=5Bun=5Dmap=5Fatomic=28=29=20with=20two=20arguments=20as=20deprecated?=
Date: Sun, 27 Nov 2011 13:26:41 +0800
Message-Id: <1322371662-26166-2-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For backward compatibility, we still keep the deprecated form,
and will warn the users if they still use the deprecated one, like this:

drivers/block/drbd/drbd_bitmap.c: In function ‘bm_page_io_async’:
drivers/block/drbd/drbd_bitmap.c:973:3: warning: ‘kmap_atomic_deprecated’ is deprecated (declared at /home/wangcong/linux-2.6/include/linux/highmem.h:124)
drivers/block/drbd/drbd_bitmap.c:977:3: warning: ‘kunmap_atomic_deprecated’ is deprecated (declared at /home/wangcong/linux-2.6/include/linux/highmem.h:144)

Thanks to Nick Bowler for the cpp trick!

Cc: Nick Bowler <nbowler@elliptictech.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Cong Wang <amwang@redhat.com>
---
 include/linux/highmem.h |   50 ++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 3a93f73..9fb439f 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -109,19 +109,55 @@ static inline void kmap_atomic_idx_pop(void)
 #endif
 
 /*
- * Make both: kmap_atomic(page, idx) and kmap_atomic(page) work.
+ * NOTE:
+ * kmap_atomic() and kunmap_atomic() with two arguments are deprecated.
+ * We only keep them for backward compatibility, any usage of them
+ * are now warned.
  */
-#define kmap_atomic(page, args...) __kmap_atomic(page)
+
+#define PASTE(a, b) a ## b
+#define PASTE2(a, b) PASTE(a, b)
+
+#define NARG_(_2, _1, n, ...) n
+#define NARG(...) NARG_(__VA_ARGS__, 2, 1, :)
+
+static inline void *kmap_atomic(struct page *page)
+{
+	return __kmap_atomic(page);
+}
+
+static inline void __deprecated *kmap_atomic_deprecated(struct page *page,
+							enum km_type km)
+{
+	return __kmap_atomic(page);
+}
+
+#define kmap_atomic1(...) kmap_atomic(__VA_ARGS__)
+#define kmap_atomic2(...) kmap_atomic_deprecated(__VA_ARGS__)
+#define kmap_atomic(...) PASTE2(kmap_atomic, NARG(__VA_ARGS__)(__VA_ARGS__))
 
 /*
  * Prevent people trying to call kunmap_atomic() as if it were kunmap()
  * kunmap_atomic() should get the return value of kmap_atomic, not the page.
  */
-#define kunmap_atomic(addr, args...)				\
-do {								\
-	BUILD_BUG_ON(__same_type((addr), struct page *));	\
-	__kunmap_atomic(addr);					\
-} while (0)
+static inline void kunmap_atomic(void *addr)
+{
+	BUILD_BUG_ON(__same_type((addr), struct page *));
+	__kunmap_atomic(addr);
+}
+
+static inline void __deprecated kunmap_atomic_deprecated(void *addr,
+							enum km_type km)
+{
+	BUILD_BUG_ON(__same_type((addr), struct page *));
+	__kunmap_atomic(addr);
+}
+
+#define kunmap_atomic1(...) kunmap_atomic(__VA_ARGS__)
+#define kunmap_atomic2(...) kunmap_atomic_deprecated(__VA_ARGS__)
+#define kunmap_atomic(...) PASTE2(kunmap_atomic, NARG(__VA_ARGS__)(__VA_ARGS__))
+
+/**** End of C pre-processor tricks for deprecated macros ****/
 
 /* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
 #ifndef clear_user_highpage
-- 
1.7.4.4

