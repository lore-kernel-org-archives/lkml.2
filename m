Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab2K1Qp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:45:57 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48400 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab2K1Qo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:44:29 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 22/25] Generic dynamic per cpu refcounting
Date: Wed, 28 Nov 2012 08:43:46 -0800
Message-Id: <1354121029-1376-23-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354121029-1376-1-git-send-email-koverstreet@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements a refcount with similar semantics to
atomic_get()/atomic_dec_and_test(), that starts out as just an atomic_t
but dynamically switches to per cpu refcounting when the rate of
gets/puts becomes too high.

It also implements two stage shutdown, as we need it to tear down the
percpu counts. Before dropping the initial refcount, you must call
percpu_ref_kill(); this puts the refcount in "shutting down mode" and
switches back to a single atomic refcount with the appropriate barriers
(synchronize_rcu()).

It's also legal to call percpu_ref_kill() multiple times - it only
returns true once, so callers don't have to reimplement shutdown
synchronization.

For the sake of simplicity/efficiency, the heuristic is pretty simple -
it just switches to percpu refcounting if there are more than x gets
in one second (completely arbitrarily, 4096).

It'd be more correct to count the number of cache misses or something
else more profile driven, but doing so would require accessing the
shared ref twice per get - by just counting the number of gets(), we can
stick that counter in the high bits of the refcount and increment both
with a single atomic64_add(). But I expect this'll be good enough in
practice.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 include/linux/percpu-refcount.h |  29 +++++++
 lib/Makefile                    |   2 +-
 lib/percpu-refcount.c           | 164 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 194 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/percpu-refcount.h
 create mode 100644 lib/percpu-refcount.c

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
new file mode 100644
index 0000000..1268010
--- /dev/null
+++ b/include/linux/percpu-refcount.h
@@ -0,0 +1,29 @@
+#ifndef _LINUX_PERCPU_REFCOUNT_H
+#define _LINUX_PERCPU_REFCOUNT_H
+
+#include <linux/atomic.h>
+#include <linux/percpu.h>
+
+struct percpu_ref {
+	atomic64_t		count;
+	unsigned __percpu	*pcpu_count;
+};
+
+void percpu_ref_init(struct percpu_ref *ref);
+void __percpu_ref_get(struct percpu_ref *ref, bool alloc);
+int percpu_ref_put(struct percpu_ref *ref);
+
+int percpu_ref_kill(struct percpu_ref *ref);
+int percpu_ref_dead(struct percpu_ref *ref);
+
+static inline void percpu_ref_get(struct percpu_ref *ref)
+{
+	__percpu_ref_get(ref, true);
+}
+
+static inline void percpu_ref_get_noalloc(struct percpu_ref *ref)
+{
+	__percpu_ref_get(ref, false);
+}
+
+#endif
diff --git a/lib/Makefile b/lib/Makefile
index 821a162..7cb276e 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 idr.o int_sqrt.o extable.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
-	 is_single_threaded.o plist.o decompress.o
+	 is_single_threaded.o plist.o decompress.o percpu-refcount.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
new file mode 100644
index 0000000..522b2df
--- /dev/null
+++ b/lib/percpu-refcount.c
@@ -0,0 +1,164 @@
+#define pr_fmt(fmt) "%s: " fmt "\n", __func__
+
+#include <linux/kernel.h>
+#include <linux/percpu-refcount.h>
+#include <linux/rcupdate.h>
+
+#define PCPU_COUNT_BITS		50
+#define PCPU_COUNT_MASK		((1LL << PCPU_COUNT_BITS) - 1)
+
+#define PCPU_STATUS_BITS	2
+#define PCPU_STATUS_MASK	((1 << PCPU_STATUS_BITS) - 1)
+
+#define PCPU_REF_PTR		0
+#define PCPU_REF_NONE		1
+#define PCPU_REF_DYING		2
+#define PCPU_REF_DEAD		3
+
+#define REF_STATUS(count)	((unsigned long) count & PCPU_STATUS_MASK)
+
+void percpu_ref_init(struct percpu_ref *ref)
+{
+	unsigned long now = jiffies;
+
+	atomic64_set(&ref->count, 1);
+
+	now <<= PCPU_STATUS_BITS;
+	now |= PCPU_REF_NONE;
+
+	ref->pcpu_count = (void *) now;
+}
+
+static void percpu_ref_alloc(struct percpu_ref *ref, unsigned __user *pcpu_count)
+{
+	unsigned __percpu *new;
+	unsigned long last = (unsigned long) pcpu_count;
+	unsigned long now = jiffies;
+
+	now <<= PCPU_STATUS_BITS;
+	now |= PCPU_REF_NONE;
+
+	if (now - last <= HZ << PCPU_STATUS_BITS) {
+		rcu_read_unlock();
+		new = alloc_percpu(unsigned);
+		rcu_read_lock();
+
+		if (!new)
+			goto update_time;
+
+		BUG_ON(((unsigned long) new) & PCPU_STATUS_MASK);
+
+		if (cmpxchg(&ref->pcpu_count, pcpu_count, new) != pcpu_count)
+			free_percpu(new);
+		else
+			pr_debug("created");
+	} else {
+update_time:	new = (void *) now;
+		cmpxchg(&ref->pcpu_count, pcpu_count, new);
+	}
+}
+
+void __percpu_ref_get(struct percpu_ref *ref, bool alloc)
+{
+	unsigned __percpu *pcpu_count;
+	uint64_t v;
+
+	pcpu_count = rcu_dereference(ref->pcpu_count);
+
+	if (REF_STATUS(pcpu_count) == PCPU_REF_PTR) {
+		__this_cpu_inc(*pcpu_count);
+	} else {
+		v = atomic64_add_return(1 + (1ULL << PCPU_COUNT_BITS),
+					&ref->count);
+
+		if (!(v >> PCPU_COUNT_BITS) &&
+		    REF_STATUS(pcpu_count) == PCPU_REF_NONE && alloc)
+			percpu_ref_alloc(ref, pcpu_count);
+	}
+}
+
+int percpu_ref_put(struct percpu_ref *ref)
+{
+	unsigned __percpu *pcpu_count;
+	uint64_t v;
+	int ret = 0;
+
+	rcu_read_lock();
+
+	pcpu_count = rcu_dereference(ref->pcpu_count);
+
+	switch (REF_STATUS(pcpu_count)) {
+	case PCPU_REF_PTR:
+		__this_cpu_dec(*pcpu_count);
+		break;
+	case PCPU_REF_NONE:
+	case PCPU_REF_DYING:
+		atomic64_dec(&ref->count);
+		break;
+	case PCPU_REF_DEAD:
+		v = atomic64_dec_return(&ref->count);
+		v &= PCPU_COUNT_MASK;
+
+		ret = v == 0;
+		break;
+	}
+
+	rcu_read_unlock();
+
+	return ret;
+}
+
+int percpu_ref_kill(struct percpu_ref *ref)
+{
+	unsigned __percpu *old, *new, *pcpu_count = ref->pcpu_count;
+	unsigned long status;
+
+	do {
+		status = REF_STATUS(pcpu_count);
+
+		switch (status) {
+		case PCPU_REF_PTR:
+			new = (void *) PCPU_REF_DYING;
+			break;
+		case PCPU_REF_NONE:
+			new = (void *) PCPU_REF_DEAD;
+			break;
+		case PCPU_REF_DYING:
+		case PCPU_REF_DEAD:
+			return 0;
+		}
+
+		old = pcpu_count;
+		pcpu_count = cmpxchg(&ref->pcpu_count, old, new);
+	} while (pcpu_count != old);
+
+	if (status == PCPU_REF_PTR) {
+		unsigned count = 0, cpu;
+
+		synchronize_rcu();
+
+		for_each_possible_cpu(cpu)
+			count += *per_cpu_ptr(pcpu_count, cpu);
+
+		pr_debug("global %lli pcpu %i",
+			 atomic64_read(&ref->count) & PCPU_COUNT_MASK,
+			 (int) count);
+
+		atomic64_add((int) count, &ref->count);
+		smp_wmb();
+		/* Between setting global count and setting PCPU_REF_DEAD */
+		ref->pcpu_count = (void *) PCPU_REF_DEAD;
+
+		free_percpu(pcpu_count);
+	}
+
+	return 1;
+}
+
+int percpu_ref_dead(struct percpu_ref *ref)
+{
+	unsigned status = REF_STATUS(ref->pcpu_count);
+
+	return status == PCPU_REF_DYING ||
+		status == PCPU_REF_DEAD;
+}
-- 
1.7.12

