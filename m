Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab2ENSmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:42:07 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:52962 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751297Ab2ENSmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:42:05 -0400
From: Pravin B Shelar <pshelar@nicira.com>
To: cl@linux.com, penberg@kernel.org, mpm@selenic.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jesse@nicira.com,
        abhide@nicira.com, Pravin B Shelar <pshelar@nicira.com>
Subject: [PATCH 2/2] mm: Fix slab->page _count corruption.
Date: Mon, 14 May 2012 11:41:40 -0700
Message-Id: <1337020900-20120-1-git-send-email-pshelar@nicira.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On arches that do not support this_cpu_cmpxchg_double slab_lock is used
to do atomic cmpxchg() on double word which contains page->_count.
page count can be changed from get_page() or put_page() without taking
slab_lock. That corrupts page counter.

Following patch fixes it by moving page->_count out of cmpxchg_double
data. So that slub does no change it while updating slub meta-data in
struct page.

Reported-by: Amey Bhide <abhide@nicira.com>
Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
---
 include/linux/mm_types.h |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index dad95bd..7f0032f 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -55,7 +55,8 @@ struct page {
 			pgoff_t index;		/* Our offset within mapping. */
 			void *freelist;		/* slub first free object */
 		};
-
+#if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
+    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 		union {
 			/* Used for cmpxchg_double in slub */
 			unsigned long counters;
@@ -90,6 +91,28 @@ struct page {
 				atomic_t _count;		/* Usage count, see below. */
 			};
 		};
+#else
+		/* Keep _count separate from slub cmpxchg_double data, As rest
+		 * of double word is protected by slab_lock but _count is not */
+		union {
+			/* Used for cmpxchg_double in slub */
+			unsigned int counters;
+
+			struct {
+
+				union {
+					atomic_t _mapcount;
+
+					struct {
+						unsigned inuse:16;
+						unsigned objects:15;
+						unsigned frozen:1;
+					};
+				};
+			};
+		};
+		atomic_t _count;
+#endif
 	};
 
 	/* Third double word block */
-- 
1.7.10

