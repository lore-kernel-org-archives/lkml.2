Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1DLIEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 04:04:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:15037 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab1DLIEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 04:04:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,194,1301900400"; 
   d="scan'208";a="732184819"
Subject: [PATCH 1/4]percpu_counter: make API return consistent value
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, cl@linux.com, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 16:03:57 +0800
Message-ID: <1302595437.3981.127.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the percpu_counter_*_positive() API SMP and !SMP aren't consistent. From
the API name, we should return a non-negative value for them.
Also if count < 0, returns 0 instead of 1 for *read_positive().

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 include/linux/percpu_counter.h |   52 ++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 31 deletions(-)

Index: linux/include/linux/percpu_counter.h
===================================================================
--- linux.orig/include/linux/percpu_counter.h	2011-04-12 15:48:42.000000000 +0800
+++ linux/include/linux/percpu_counter.h	2011-04-12 15:48:44.000000000 +0800
@@ -47,12 +47,6 @@ static inline void percpu_counter_add(st
 	__percpu_counter_add(fbc, amount, percpu_counter_batch);
 }
 
-static inline s64 percpu_counter_sum_positive(struct percpu_counter *fbc)
-{
-	s64 ret = __percpu_counter_sum(fbc);
-	return ret < 0 ? 0 : ret;
-}
-
 static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
 {
 	return __percpu_counter_sum(fbc);
@@ -63,21 +57,6 @@ static inline s64 percpu_counter_read(st
 	return fbc->count;
 }
 
-/*
- * It is possible for the percpu_counter_read() to return a small negative
- * number for some counter which should never be negative.
- *
- */
-static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
-{
-	s64 ret = fbc->count;
-
-	barrier();		/* Prevent reloads of fbc->count */
-	if (ret >= 0)
-		return ret;
-	return 1;
-}
-
 static inline int percpu_counter_initialized(struct percpu_counter *fbc)
 {
 	return (fbc->counters != NULL);
@@ -133,16 +112,6 @@ static inline s64 percpu_counter_read(st
 	return fbc->count;
 }
 
-static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
-{
-	return fbc->count;
-}
-
-static inline s64 percpu_counter_sum_positive(struct percpu_counter *fbc)
-{
-	return percpu_counter_read_positive(fbc);
-}
-
 static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
 {
 	return percpu_counter_read(fbc);
@@ -170,4 +139,25 @@ static inline void percpu_counter_sub(st
 	percpu_counter_add(fbc, -amount);
 }
 
+/*
+ * It is possible for the percpu_counter_read() to return a small negative
+ * number for some counter which should never be negative.
+ *
+ */
+static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
+{
+	s64 ret = percpu_counter_read(fbc);
+
+	barrier();		/* Prevent reloads of fbc->count */
+	if (ret >= 0)
+		return ret;
+	return 0;
+}
+
+static inline s64 percpu_counter_sum_positive(struct percpu_counter *fbc)
+{
+	s64 ret = percpu_counter_sum(fbc);
+	return ret < 0 ? 0 : ret;
+}
+
 #endif /* _LINUX_PERCPU_COUNTER_H */


