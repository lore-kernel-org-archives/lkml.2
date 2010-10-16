Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751177Ab0JPOT2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 10:19:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34223 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab0JPOT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 10:19:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NHBzG638Dosc7KpZ9BILoKzOChue38tM7ghGtonxKHzz1NEhHPcv8ZKE8JrRkGr5j7
         TnAki5p5VMxC6r+B7oGMErnkIa+9G8OqP3U4gVtLoL0Km4/qJ2zOc3HTjkgfeaKIYHbB
         xMllZQfmeP5h5rifVwXx6ay6ktV8jrRCZk/dw=
Subject: [PATCH] percpu_counter : add percpu_counter_add_fast()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <1287221475.2799.123.camel@edumazet-laptop>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	 <1285762729-17928-17-git-send-email-david@fromorbit.com>
	 <20100929215322.ff635d3e.akpm@linux-foundation.org>
	 <20100930061039.GX5665@dastard> <20101016075510.GH19147@amd>
	 <1287217748.2799.68.camel@edumazet-laptop>
	 <20101016020744.366bd9c6.akpm@linux-foundation.org>
	 <1287221475.2799.123.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Oct 2010 16:19:14 +0200
Message-ID: <1287238754.2799.376.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew

I based following patch against linux-2.6, I dont know if previous
Christoph patch is in a git tree. I'll respin it eventually.

Thanks

[PATCH] percpu_counter : percpu_counter_add_fast()

The current way to change a percpu_counter is to call
percpu_counter_add(), which is a bit expensive.
(More than 40 instructions, possible false sharing, ...)

When we dont need to maintain the approximate value of the
percpu_counter (aka fbc->count), and dont need a "s64" wide counter but
a regular "int" or "long" one, we can use this new function : 
percpu_counter_add_fast()

This function is pretty fast : 
- One instruction on x86 SMP, no register pressure.
- Is safe in preempt enabled contexts.
- No lock acquisition, less false sharing.

Users of this percpu_counter variant should not use
percpu_counter_read() or percpu_counter_read_positive() anymore, only
percpu_counter_sum{_positive}() variant.

Note: we could add later irqsafe variant, still one instruction on x86
SMP...

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Christoph Lameter <cl@linux-foundation.org>
CC: Nick Piggin <npiggin@kernel.dk>
CC: Dave Chinner <david@fromorbit.com>
---
 include/linux/percpu_counter.h |   36 +++++++++++++++++++++++++++----
 lib/percpu_counter.c           |   12 +++++-----
 2 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index 8a7d510..b9f4cc1 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -3,7 +3,9 @@
 /*
  * A simple "approximate counter" for use in ext2 and ext3 superblocks.
  *
- * WARNING: these things are HUGE.  4 kbytes per counter on 32-way P4.
+ * WARNING: these things are big.  sizeof(long) bytes per possible cpu per counter.
+ * For a 64 cpus 64bit machine :
+ *	64*8 (512) bytes + sizeof(struct percpu_counter)
  */
 
 #include <linux/spinlock.h>
@@ -21,7 +23,7 @@ struct percpu_counter {
 #ifdef CONFIG_HOTPLUG_CPU
 	struct list_head list;	/* All percpu_counters are on a list */
 #endif
-	s32 __percpu *counters;
+	long __percpu *counters;
 };
 
 extern int percpu_counter_batch;
@@ -38,7 +40,7 @@ int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
 
 void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
-void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
+void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, long batch);
 s64 __percpu_counter_sum(struct percpu_counter *fbc);
 int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs);
 
@@ -47,6 +49,24 @@ static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 	__percpu_counter_add(fbc, amount, percpu_counter_batch);
 }
 
+/**
+ * percpu_counter_add_fast - fast variant of percpu_counter_add
+ * @fbc: pointer to percpu_counter
+ * @amount: value to add to counter
+ *
+ * Add amount to a percpu_counter object, without approximate (fbc->count)
+ * estimation / correction.
+ * Notes :
+ * - This fast version is limited to "long" counters, not "s64".
+ * - It is preempt safe, but not IRQ safe (on UP)
+ * - Use of percpu_counter_read{_positive}() is discouraged.
+ * - fbc->count accumulates the counters from offlined cpus.
+ */
+static inline void percpu_counter_add_fast(struct percpu_counter *fbc, long amount)
+{
+	this_cpu_add(*fbc->counters, amount);
+}
+
 static inline s64 percpu_counter_sum_positive(struct percpu_counter *fbc)
 {
 	s64 ret = __percpu_counter_sum(fbc);
@@ -118,7 +138,15 @@ percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 }
 
 static inline void
-__percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
+percpu_counter_add_fast(struct percpu_counter *fbc, long amount)
+{
+	preempt_disable();
+	fbc->count += amount;
+	preempt_enable();
+}
+
+static inline void
+__percpu_counter_add(struct percpu_counter *fbc, s64 amount, long batch)
 {
 	percpu_counter_add(fbc, amount);
 }
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index ec9048e..93d50a5 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -18,7 +18,7 @@ void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 
 	spin_lock(&fbc->lock);
 	for_each_possible_cpu(cpu) {
-		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
+		long *pcount = per_cpu_ptr(fbc->counters, cpu);
 		*pcount = 0;
 	}
 	fbc->count = amount;
@@ -26,10 +26,10 @@ void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 }
 EXPORT_SYMBOL(percpu_counter_set);
 
-void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
+void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, long batch)
 {
 	s64 count;
-	s32 *pcount;
+	long *pcount;
 	int cpu = get_cpu();
 
 	pcount = per_cpu_ptr(fbc->counters, cpu);
@@ -58,7 +58,7 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
 	spin_lock(&fbc->lock);
 	ret = fbc->count;
 	for_each_online_cpu(cpu) {
-		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
+		long *pcount = per_cpu_ptr(fbc->counters, cpu);
 		ret += *pcount;
 	}
 	spin_unlock(&fbc->lock);
@@ -72,7 +72,7 @@ int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
 	spin_lock_init(&fbc->lock);
 	lockdep_set_class(&fbc->lock, key);
 	fbc->count = amount;
-	fbc->counters = alloc_percpu(s32);
+	fbc->counters = alloc_percpu(long);
 	if (!fbc->counters)
 		return -ENOMEM;
 #ifdef CONFIG_HOTPLUG_CPU
@@ -123,7 +123,7 @@ static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
 	cpu = (unsigned long)hcpu;
 	mutex_lock(&percpu_counters_lock);
 	list_for_each_entry(fbc, &percpu_counters, list) {
-		s32 *pcount;
+		long *pcount;
 		unsigned long flags;
 
 		spin_lock_irqsave(&fbc->lock, flags);


