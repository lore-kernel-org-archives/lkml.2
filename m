Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab1EKPqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:46:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:8648 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751Ab1EKPqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:46:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,351,1301900400"; 
   d="scan'208";a="641126610"
Message-Id: <20110511081433.482521472@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 11 May 2011 16:10:13 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tj@kernel.org, eric.dumazet@gmail.com,
        cl@linux.com, npiggin@kernel.dk, Shaohua Li <shaohua.li@intel.com>
Subject: [patch v2 1/5] percpu_counter: fix code for 32bit systems for UP
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=percpu-counter-32bits.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu_counter.counter is a 's64'. Accessing it in 32-bit system is racing.
we need some locking to protect it otherwise some very wrong value could be
accessed.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 include/linux/percpu_counter.h |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

Index: linux/include/linux/percpu_counter.h
===================================================================
--- linux.orig/include/linux/percpu_counter.h	2011-05-05 10:33:12.000000000 +0800
+++ linux/include/linux/percpu_counter.h	2011-05-06 11:19:26.000000000 +0800
@@ -101,14 +101,34 @@ static inline void percpu_counter_destro
 
 static inline void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 {
+#if BITS_PER_LONG == 32
+	preempt_disable();
+	fbc->count = amount;
+	preempt_enable();
+#else
 	fbc->count = amount;
+#endif
+}
+
+static inline s64 percpu_counter_read(struct percpu_counter *fbc)
+{
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

