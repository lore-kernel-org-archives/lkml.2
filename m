Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab1DMIGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 04:06:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:31567 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757170Ab1DMIFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 04:05:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,203,1301900400"; 
   d="scan'208";a="732684686"
Message-Id: <20110413080517.735973727@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 13 Apr 2011 15:57:18 +0800
From: shaohua.li@intel.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, cl@linux.com, tj@kernel.org,
        eric.dumazet@gmail.com, Shaohua Li <shaohua.li@intel.com>
Subject: [patch v2 3/4] percpu_counter: fix code for 32bit systems
References: <20110413075715.090406229@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=percpu-counter-32bits.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu_counter.counter is a 's64'. Accessing it in 32-bit system is racing.
we need some locking to protect it otherwise some very wrong value could be
accessed.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 include/linux/percpu_counter.h |   48 ++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 12 deletions(-)

Index: linux/include/linux/percpu_counter.h
===================================================================
--- linux.orig/include/linux/percpu_counter.h	2011-04-13 13:21:21.000000000 +0800
+++ linux/include/linux/percpu_counter.h	2011-04-13 13:27:22.000000000 +0800
@@ -60,7 +60,16 @@ static inline s64 percpu_counter_sum(str
 
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
+#if BITS_PER_LONG == 32
+	s64 count;
+	unsigned long flags;
+	spin_lock_irqsave(&fbc->lock, flags);
+	count = fbc->count;
+	spin_unlock_irqrestore(&fbc->lock, flags);
+	return count;
+#else
 	return fbc->count;
+#endif
 }
 
 /*
@@ -70,7 +79,7 @@ static inline s64 percpu_counter_read(st
  */
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
-	s64 ret = fbc->count;
+	s64 ret = percpu_counter_read(fbc);
 
 	barrier();		/* Prevent reloads of fbc->count */
 	if (ret >= 0)
@@ -89,9 +98,20 @@ struct percpu_counter {
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
 
@@ -99,16 +119,25 @@ static inline void percpu_counter_destro
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
@@ -128,18 +157,13 @@ __percpu_counter_add(struct percpu_count
 	percpu_counter_add(fbc, amount);
 }
 
-static inline s64 percpu_counter_read(struct percpu_counter *fbc)
-{
-	return fbc->count;
-}
-
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
 	/*
 	 * percpu_counter is intended to track positive number. In UP case, the
 	 * number should never be negative.
 	 */
-	return fbc->count;
+	return percpu_counter_read(fbc);
 }
 
 static inline s64 percpu_counter_sum_positive(struct percpu_counter *fbc)

