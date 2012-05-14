Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab2ENWaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 18:30:04 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:36545 "HELO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932528Ab2ENWaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 18:30:02 -0400
From: Pravin B Shelar <pshelar@nicira.com>
To: cl@linux.com, penberg@kernel.org, mpm@selenic.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jesse@nicira.com,
        abhide@nicira.com, Pravin B Shelar <pshelar@nicira.com>
Subject: [PATCH v2] mm: Fix slab->page _count corruption.
Date: Mon, 14 May 2012 15:29:57 -0700
Message-Id: <1337034597-1826-1-git-send-email-pshelar@nicira.com>
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
 include/linux/mm_types.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index dad95bd..5f558dc 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -57,8 +57,16 @@ struct page {
 		};
 
 		union {
+#if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
+    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 			/* Used for cmpxchg_double in slub */
 			unsigned long counters;
+#else
+			/* Keep _count separate from slub cmpxchg_double data,
+			 * As rest of double word is protected by slab_lock
+			 * but _count is not. */
+			unsigned counters;
+#endif
 
 			struct {
 
-- 
1.7.10

