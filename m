Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab1DNCHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 22:07:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:59952 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756985Ab1DNCHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 22:07:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,208,1301900400"; 
   d="scan'208";a="909291252"
Message-Id: <20110414020747.201728372@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 14 Apr 2011 10:04:49 +0800
From: shaohua.li@intel.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tj@kernel.org, cl@linux.com,
        eric.dumazet@gmail.com, Shaohua Li <shaohua.li@intel.com>
Subject: [patch v3 2/3] percpu_counter: fix code for 32bit systems for UP
References: <20110414020447.979946152@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=percpu-counter-32bits.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu_counter.counter is a 's64'. Accessing it in 32-bit system is racing.
we need some locking to protect it otherwise some very wrong value could be
accessed.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 include/linux/percpu_counter.h |   37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

Index: linux/include/linux/percpu_counter.h
===================================================================
--- linux.orig/include/linux/percpu_counter.h	2011-04-14 08:50:45.000000000 +0800
+++ linux/include/linux/percpu_counter.h	2011-04-14 09:09:14.000000000 +0800
@@ -89,9 +89,20 @@ struct percpu_counter {
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
 
@@ -99,16 +110,25 @@ static inline void percpu_counter_destro
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
@@ -128,18 +148,13 @@ __percpu_counter_add(struct percpu_count
 	percpu_counter_add(fbc, amount);
 }
 
-static inline s64 percpu_counter_read(struct percpu_counter *fbc)
-{
-	return fbc->count;
-}
-
 /*
  * percpu_counter is intended to track positive number. In UP case, the number
  * should never be negative.
  */
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
-	return fbc->count;
+	return percpu_counter_read(fbc);
 }
 
 static inline s64 percpu_counter_sum_positive(struct percpu_counter *fbc)

