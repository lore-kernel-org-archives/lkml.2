Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760906Ab0FRAAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 20:00:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:64858 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756995Ab0FRAAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 20:00:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,434,1272870000"; 
   d="scan'208";a="631399005"
Subject: [PATCH v3 1/2] tmpfs: Add accurate compare function to
 percpu_counter library
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       Hugh Dickins <hughd@google.com>, yanmin.zhang@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Jun 2010 16:56:32 -0700
Message-ID: <1276818992.9661.81.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add percpu_counter_compare that allows for a quick but accurate
comparison of percpu_counter with a given value.  

A rough count is provided by the count field in percpu_counter structure, 
without accounting for the other values stored in individual cpu counters.
The actual count is a sum of count and the cpu counters.  However, count field is
never different from the actual value by a factor of batch*num_online_cpu.
We do not need to get actual count for comparison if count
is different from the given value by this factor and allows for
quick comparison without summing up all the per cpu counters.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
 include/linux/percpu_counter.h |   11 +++++++++++
 lib/percpu_counter.c           |   27 +++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index c88d67b..8a7d510 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -40,6 +40,7 @@ void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
 s64 __percpu_counter_sum(struct percpu_counter *fbc);
+int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs);
 
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
@@ -98,6 +99,16 @@ static inline void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 	fbc->count = amount;
 }
 
+static inline int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs)
+{
+	if (fbc->count > rhs)
+		return 1;
+	else if (fbc->count < rhs)
+		return -1;
+	else
+		return 0;
+}
+
 static inline void
 percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index aeaa6d7..ec9048e 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -137,6 +137,33 @@ static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
+/*
+ * Compare counter against given value.
+ * Return 1 if greater, 0 if equal and -1 if less
+ */
+int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs)
+{
+	s64	count;
+
+	count = percpu_counter_read(fbc);
+	/* Check to see if rough count will be sufficient for comparison */
+	if (abs(count - rhs) > (percpu_counter_batch*num_online_cpus())) {
+		if (count > rhs)
+			return 1;
+		else
+			return -1;
+	}
+	/* Need to use precise count */
+	count = percpu_counter_sum(fbc);
+	if (count > rhs)
+		return 1;
+	else if (count < rhs)
+		return -1;
+	else
+		return 0;
+}
+EXPORT_SYMBOL(percpu_counter_compare);
+
 static int __init percpu_counter_startup(void)
 {
 	compute_batch_value();


