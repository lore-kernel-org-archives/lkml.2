Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab1DLIEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 04:04:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:8881 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508Ab1DLIEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 04:04:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,194,1301900400"; 
   d="scan'208";a="908410307"
Subject: [PATCH 3/4]percpu_counter: fix code for 32bit systems
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, cl@linux.com, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 16:04:04 +0800
Message-ID: <1302595444.3981.129.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu_counter.counter is a 's64'. Accessing it in 32-bit system is racing.
we need some locking to protect it otherwise some very wrong value could be
accessed.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 include/linux/percpu_counter.h |   43 +++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

Index: linux/include/linux/percpu_counter.h
===================================================================
--- linux.orig/include/linux/percpu_counter.h	2011-04-12 15:48:44.000000000 +0800
+++ linux/include/linux/percpu_counter.h	2011-04-12 15:48:54.000000000 +0800
@@ -54,7 +54,15 @@ static inline s64 percpu_counter_sum(str
 
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
+#if BITS_PER_LONG == 32
+	s64 count;
+	spin_lock(&fbc->lock);
+	count = fbc->count;
+	spin_unlock(&fbc->lock);
+	return count;
+#else
 	return fbc->count;
+#endif
 }
 
 static inline int percpu_counter_initialized(struct percpu_counter *fbc)
@@ -68,9 +76,20 @@ struct percpu_counter {
 	s64 count;
 };
 
-static inline int percpu_counter_init(struct percpu_counter *fbc, s64 amount)
+static inline void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 {
+#if BITS_PER_LONG == 32
+	preempt_disable();
 	fbc->count = amount;
+	preempt_enable();
+#else
+	fbc->count = amount;
+#endif
+}
+
+static inline int percpu_counter_init(struct percpu_counter *fbc, s64 amount)
+{
+	percpu_counter_set(fbc, amount);
 	return 0;
 }
 
@@ -78,16 +97,25 @@ static inline void percpu_counter_destro
 {
 }
 
-static inline void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
+static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
-	fbc->count = amount;
+#if BITS_PER_LONG == 32
+	s64 count;
+	preempt_disable();
+	count = fbc->count;
+	preempt_enable();
+	return count;
+#else
+	return fbc->count;
+#endif
 }
 
 static inline int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs)
 {
-	if (fbc->count > rhs)
+	s64 count = percpu_counter_read(fbc);
+	if (count > rhs)
 		return 1;
-	else if (fbc->count < rhs)
+	else if (count < rhs)
 		return -1;
 	else
 		return 0;
@@ -107,11 +135,6 @@ __percpu_counter_add(struct percpu_count
 	percpu_counter_add(fbc, amount);
 }
 
-static inline s64 percpu_counter_read(struct percpu_counter *fbc)
-{
-	return fbc->count;
-}
-
 static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
 {
 	return percpu_counter_read(fbc);


