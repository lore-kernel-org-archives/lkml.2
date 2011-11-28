Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab1K1HrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 02:47:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab1K1HrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 02:47:22 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Nick Bowler <nbowler@elliptictech.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: =?UTF-8?q?=5BUPDATED=20PATCH=2001/62=5D=20highmem=3A=20mark=20k=5Bun=5Dmap=5Fatomic=28=29=20with=20two=20arguments=20as=20deprecated?=
Date: Mon, 28 Nov 2011 15:46:23 +0800
Message-Id: <1322466385-10527-1-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-2-git-send-email-amwang@redhat.com>
References: <1322371662-26166-2-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update: keep kunmap_atomic() as a macro, otherwise BUILD_BUG_ON() won't work.

For backward compatibility, we still keep the deprecated form,
and will warn the users if they still use the deprecated one, like this:

drivers/block/drbd/drbd_bitmap.c: In function ‘bm_page_io_async’:
drivers/block/drbd/drbd_bitmap.c:973:3: warning: ‘kmap_atomic_deprecated’ is deprecated (declared at /home/wangcong/linux-2.6/include/linux/highmem.h:124)
drivers/block/drbd/drbd_bitmap.c:977:3: warning: ‘kunmap_atomic_deprecated’ is deprecated (declared at /home/wangcong/linux-2.6/include/linux/highmem.h:144)

Thanks to Nick Bowler for the cpp trick!

Cc: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Nick Bowler <nbowler@elliptictech.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Cong Wang <amwang@redhat.com>

---
 include/linux/highmem.h |   52 +++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 3a93f73..11617a8 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -109,20 +109,60 @@ static inline void kmap_atomic_idx_pop(void)
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
+
+static inline void __deprecated __kunmap_atomic_deprecated(void *addr,
+							enum km_type km)
+{
+	__kunmap_atomic(addr);
+}
 
 /*
  * Prevent people trying to call kunmap_atomic() as if it were kunmap()
  * kunmap_atomic() should get the return value of kmap_atomic, not the page.
  */
-#define kunmap_atomic(addr, args...)				\
-do {								\
-	BUILD_BUG_ON(__same_type((addr), struct page *));	\
-	__kunmap_atomic(addr);					\
+#define kunmap_atomic_deprecated(addr, km)                      \
+do {                                                            \
+	BUILD_BUG_ON(__same_type((addr), struct page *));       \
+	__kunmap_atomic_deprecated(addr, km);                   \
 } while (0)
 
+#define kunmap_atomic_withcheck(addr)                           \
+do {                                                            \
+	BUILD_BUG_ON(__same_type((addr), struct page *));       \
+	__kunmap_atomic(addr);                                  \
+} while (0)
+
+#define kunmap_atomic1(...) kunmap_atomic_withcheck(__VA_ARGS__)
+#define kunmap_atomic2(...) kunmap_atomic_deprecated(__VA_ARGS__)
+#define kunmap_atomic(...) PASTE2(kunmap_atomic, NARG(__VA_ARGS__)(__VA_ARGS__))
+/**** End of C pre-processor tricks for deprecated macros ****/
+
 /* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
 #ifndef clear_user_highpage
 static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
-- 
1.7.4.4

