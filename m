Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab0K2AhY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 19:37:24 -0500
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:39765 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754496Ab0K2AhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 19:37:20 -0500
From: Dave Chinner <david@fromorbit.com>
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: =?UTF-8?q?=5BPATCH=201/3=5D=20lib=3A=20percpu=20counter=20add=20unless=20less=20than=20functionality?=
Date: Mon, 29 Nov 2010 11:36:39 +1100
Message-Id: <1290991002-18680-2-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1290991002-18680-1-git-send-email-david@fromorbit.com>
References: <1290991002-18680-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To use the generic percpu counter infrastructure for counters that
require conditional addition based on a threshold value we need
special handling of the counter. Further, the caller needs to know
the status of the conditional addition to determine what action to
take depending on whether the addition occurred or not.  Examples of
this sort of usage are resource counters that cannot go below zero
(e.g. filesystem free blocks).

To allow XFS to replace it's complex roll-your-own per-cpu
superblock counters, a single generic conditional function is
required: percpu_counter_add_unless_lt(). This will add the amount
to the counter unless the result would be less than the given
threshold. A caller supplied threshold is required because XFS does
not necessarily use the same threshold for every counter.

percpu_counter_add_unless_lt() attempts to minimise counter lock
traversals by only taking the counter lock when the threshold is
within the error range of the current counter value. Hence when the
threshold is not within the counter error range, the counter will
still have the same scalability characteristics as the normal
percpu_counter_add() function.

Adding this functionality to the generic percpu counters allows us
to remove the much more complex and less efficient XFS percpu
counter code (~700 lines of code) and replace it with generic
percpu counters.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/linux/percpu_counter.h |   20 ++++++++++
 lib/percpu_counter.c           |   78 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+), 0 deletions(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index 46f6ba5..465b658f 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -41,6 +41,8 @@ void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
 s64 __percpu_counter_sum(struct percpu_counter *fbc);
 int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs);
+int percpu_counter_add_unless_lt(struct percpu_counter *fbc, s64 amount,
+							s64 threshold);
 
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
@@ -153,6 +155,24 @@ static inline int percpu_counter_initialized(struct percpu_counter *fbc)
 	return 1;
 }
 
+static inline int percpu_counter_add_unless_lt(struct percpu_counter *fbc, s64 amount,
+							s64 threshold)
+{
+	s64 count;
+	int ret = ‐1;
+
+	preempt_disable();
+	count = fbc->count + amount;
+	if (count < threshold)
+		goto out;
+	fbc->count = count;
+	ret = count == threshold ? 0 : 1;
+out:
+	preempt_enable();
+	return ret;
+}
+
+
 #endif	/* CONFIG_SMP */
 
 static inline void percpu_counter_inc(struct percpu_counter *fbc)
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index 604678d..ba625b7 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -213,6 +213,84 @@ int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs)
 }
 EXPORT_SYMBOL(percpu_counter_compare);
 
+/**
+ * percpu_counter_add_unless_lt - add to a counter avoiding underruns
+ * @fbc:	counter
+ * @amount:	amount to add
+ * @threshold:	underrun threshold
+ *
+ * Add @amount to @fdc if and only if result of addition is greater than or
+ * equal to @threshold  Return 1 if greater and added, 0 if equal and added
+ * and -1 if and underrun would have occured.
+ *
+ * This is useful for operations that must accurately and atomically only add a
+ * delta to a counter if the result is greater than a given (e.g. for freespace
+ * accounting with ENOSPC checking in filesystems).
+ */
+int percpu_counter_add_unless_lt(struct percpu_counter *fbc, s64 amount,
+						s64 threshold)
+{
+	s64	count;
+	s64	error = 2 * percpu_counter_batch * num_online_cpus();
+	int	cpu;
+	int	ret = -1;
+
+	preempt_disable();
+
+	/* Check to see if rough count will be sufficient for comparison */
+	count = percpu_counter_read(fbc);
+	if (count + amount < threshold - error)
+		goto out;
+
+	/*
+	 * If the counter is over the threshold and the change is less than the
+	 * batch size, we might be able to avoid locking.
+	 */
+	if (count > threshold + error && abs(amount) < percpu_counter_batch) {
+		__percpu_counter_add(fbc, amount, percpu_counter_batch);
+		ret = 1;
+		goto out;
+	}
+
+	/*
+	 * If the result is is over the error threshold, we can just add it
+	 * into the global counter ignoring what is in the per-cpu counters
+	 * as they will not change the result of the calculation.
+	 */
+	spin_lock(&fbc->lock);
+	if (fbc->count + amount > threshold + error) {
+		fbc->count += amount;
+		ret = 1;
+		goto out_unlock;
+	}
+
+	/*
+	 * Result is withing the error margin. Run an open-coded sum of the
+	 * per-cpu counters to get the exact value at this point in time,
+	 * and if the result woul dbe above the threshold, add the amount to
+	 * the global counter.
+	 */
+	count = fbc->count;
+	for_each_online_cpu(cpu) {
+		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
+		count += *pcount;
+	}
+	WARN_ON(count < threshold);
+
+	if (count + amount >= threshold) {
+		ret = 0;
+		if (count + amount > threshold)
+			ret = 1;
+		fbc->count += amount;
+	}
+out_unlock:
+	spin_unlock(&fbc->lock);
+out:
+	preempt_enable();
+	return ret;
+}
+EXPORT_SYMBOL(percpu_counter_add_unless_lt);
+
 static int __init percpu_counter_startup(void)
 {
 	compute_batch_value();
-- 
1.7.2.3

