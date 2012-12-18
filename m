Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab2LRJmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 04:42:13 -0500
Received: from www84.your-server.de ([213.133.104.84]:50084 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2LRJmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 04:42:07 -0500
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, ak@linux.intel.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: stefani@seibold.net
Subject: [PATCH 1/6] Move out seqcount from seqlock.h
Date: Tue, 18 Dec 2012 10:40:51 +0100
Message-Id: <1355823656-13902-2-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1355823656-13902-1-git-send-email-stefani@seibold.net>
References: <1355823656-13902-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

Create a seperate seqcount.h file which handles only seqcount. This file
is save to include in VDSO, since there is no in-kernel functionality
like spinlock in use. seqlock.h still includes seqcount.h, so there is no
side effect for current users.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 include/linux/seqcount.h | 150 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/seqlock.h  | 145 +--------------------------------------------
 2 files changed, 151 insertions(+), 144 deletions(-)
 create mode 100644 include/linux/seqcount.h

diff --git a/include/linux/seqcount.h b/include/linux/seqcount.h
new file mode 100644
index 0000000..b83dff3
--- /dev/null
+++ b/include/linux/seqcount.h
@@ -0,0 +1,150 @@
+/*
+ * Version using sequence counter only.
+ * This can be used when code has its own mutex protecting the
+ * updating starting before the write_seqcountbeqin() and ending
+ * after the write_seqcount_end().
+ */
+
+#ifndef __LINUX_SEQCOUNT_H
+#define __LINUX_SEQCOUNT_H
+
+#include <asm/processor.h>
+#include <asm/barrier.h>
+
+typedef struct seqcount {
+	unsigned sequence;
+} seqcount_t;
+
+#define SEQCNT_ZERO { 0 }
+#define seqcount_init(x) do { *(x) = (seqcount_t) SEQCNT_ZERO; } while (0)
+
+/**
+ * __read_seqcount_begin - begin a seq-read critical section (without barrier)
+ * @s: pointer to seqcount_t
+ * Returns: count to be passed to read_seqcount_retry
+ *
+ * __read_seqcount_begin is like read_seqcount_begin, but has no smp_rmb()
+ * barrier. Callers should ensure that smp_rmb() or equivalent ordering is
+ * provided before actually loading any of the variables that are to be
+ * protected in this critical section.
+ *
+ * Use carefully, only in critical code, and comment how the barrier is
+ * provided.
+ */
+static inline unsigned __read_seqcount_begin(const seqcount_t *s)
+{
+	unsigned ret;
+
+repeat:
+	ret = ACCESS_ONCE(s->sequence);
+	if (unlikely(ret & 1)) {
+		cpu_relax();
+		goto repeat;
+	}
+	return ret;
+}
+
+/**
+ * read_seqcount_begin - begin a seq-read critical section
+ * @s: pointer to seqcount_t
+ * Returns: count to be passed to read_seqcount_retry
+ *
+ * read_seqcount_begin opens a read critical section of the given seqcount.
+ * Validity of the critical section is tested by checking read_seqcount_retry
+ * function.
+ */
+static inline unsigned read_seqcount_begin(const seqcount_t *s)
+{
+	unsigned ret = __read_seqcount_begin(s);
+	smp_rmb();
+	return ret;
+}
+
+/**
+ * raw_seqcount_begin - begin a seq-read critical section
+ * @s: pointer to seqcount_t
+ * Returns: count to be passed to read_seqcount_retry
+ *
+ * raw_seqcount_begin opens a read critical section of the given seqcount.
+ * Validity of the critical section is tested by checking read_seqcount_retry
+ * function.
+ *
+ * Unlike read_seqcount_begin(), this function will not wait for the count
+ * to stabilize. If a writer is active when we begin, we will fail the
+ * read_seqcount_retry() instead of stabilizing at the beginning of the
+ * critical section.
+ */
+static inline unsigned raw_seqcount_begin(const seqcount_t *s)
+{
+	unsigned ret = ACCESS_ONCE(s->sequence);
+	smp_rmb();
+	return ret & ~1;
+}
+
+/**
+ * __read_seqcount_retry - end a seq-read critical section (without barrier)
+ * @s: pointer to seqcount_t
+ * @start: count, from read_seqcount_begin
+ * Returns: 1 if retry is required, else 0
+ *
+ * __read_seqcount_retry is like read_seqcount_retry, but has no smp_rmb()
+ * barrier. Callers should ensure that smp_rmb() or equivalent ordering is
+ * provided before actually loading any of the variables that are to be
+ * protected in this critical section.
+ *
+ * Use carefully, only in critical code, and comment how the barrier is
+ * provided.
+ */
+static inline int __read_seqcount_retry(const seqcount_t *s, unsigned start)
+{
+	return unlikely(s->sequence != start);
+}
+
+/**
+ * read_seqcount_retry - end a seq-read critical section
+ * @s: pointer to seqcount_t
+ * @start: count, from read_seqcount_begin
+ * Returns: 1 if retry is required, else 0
+ *
+ * read_seqcount_retry closes a read critical section of the given seqcount.
+ * If the critical section was invalid, it must be ignored (and typically
+ * retried).
+ */
+static inline int read_seqcount_retry(const seqcount_t *s, unsigned start)
+{
+	smp_rmb();
+
+	return __read_seqcount_retry(s, start);
+}
+
+
+/*
+ * Sequence counter only version assumes that callers are using their
+ * own mutexing.
+ */
+static inline void write_seqcount_begin(seqcount_t *s)
+{
+	s->sequence++;
+	smp_wmb();
+}
+
+static inline void write_seqcount_end(seqcount_t *s)
+{
+	smp_wmb();
+	s->sequence++;
+}
+
+/**
+ * write_seqcount_barrier - invalidate in-progress read-side seq operations
+ * @s: pointer to seqcount_t
+ *
+ * After write_seqcount_barrier, no read-side seq operations will complete
+ * successfully and see data older than this.
+ */
+static inline void write_seqcount_barrier(seqcount_t *s)
+{
+	smp_wmb();
+	s->sequence += 2;
+}
+
+#endif /* __LINUX_SEQCOUNT_H */
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 600060e2..f8e8235 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -29,6 +29,7 @@
 #include <linux/spinlock.h>
 #include <linux/preempt.h>
 #include <asm/processor.h>
+#include <linux/seqcount.h>
 
 typedef struct {
 	unsigned sequence;
@@ -108,150 +109,6 @@ static __always_inline int read_seqretry(const seqlock_t *sl, unsigned start)
 	return unlikely(sl->sequence != start);
 }
 
-
-/*
- * Version using sequence counter only.
- * This can be used when code has its own mutex protecting the
- * updating starting before the write_seqcountbeqin() and ending
- * after the write_seqcount_end().
- */
-
-typedef struct seqcount {
-	unsigned sequence;
-} seqcount_t;
-
-#define SEQCNT_ZERO { 0 }
-#define seqcount_init(x)	do { *(x) = (seqcount_t) SEQCNT_ZERO; } while (0)
-
-/**
- * __read_seqcount_begin - begin a seq-read critical section (without barrier)
- * @s: pointer to seqcount_t
- * Returns: count to be passed to read_seqcount_retry
- *
- * __read_seqcount_begin is like read_seqcount_begin, but has no smp_rmb()
- * barrier. Callers should ensure that smp_rmb() or equivalent ordering is
- * provided before actually loading any of the variables that are to be
- * protected in this critical section.
- *
- * Use carefully, only in critical code, and comment how the barrier is
- * provided.
- */
-static inline unsigned __read_seqcount_begin(const seqcount_t *s)
-{
-	unsigned ret;
-
-repeat:
-	ret = ACCESS_ONCE(s->sequence);
-	if (unlikely(ret & 1)) {
-		cpu_relax();
-		goto repeat;
-	}
-	return ret;
-}
-
-/**
- * read_seqcount_begin - begin a seq-read critical section
- * @s: pointer to seqcount_t
- * Returns: count to be passed to read_seqcount_retry
- *
- * read_seqcount_begin opens a read critical section of the given seqcount.
- * Validity of the critical section is tested by checking read_seqcount_retry
- * function.
- */
-static inline unsigned read_seqcount_begin(const seqcount_t *s)
-{
-	unsigned ret = __read_seqcount_begin(s);
-	smp_rmb();
-	return ret;
-}
-
-/**
- * raw_seqcount_begin - begin a seq-read critical section
- * @s: pointer to seqcount_t
- * Returns: count to be passed to read_seqcount_retry
- *
- * raw_seqcount_begin opens a read critical section of the given seqcount.
- * Validity of the critical section is tested by checking read_seqcount_retry
- * function.
- *
- * Unlike read_seqcount_begin(), this function will not wait for the count
- * to stabilize. If a writer is active when we begin, we will fail the
- * read_seqcount_retry() instead of stabilizing at the beginning of the
- * critical section.
- */
-static inline unsigned raw_seqcount_begin(const seqcount_t *s)
-{
-	unsigned ret = ACCESS_ONCE(s->sequence);
-	smp_rmb();
-	return ret & ~1;
-}
-
-/**
- * __read_seqcount_retry - end a seq-read critical section (without barrier)
- * @s: pointer to seqcount_t
- * @start: count, from read_seqcount_begin
- * Returns: 1 if retry is required, else 0
- *
- * __read_seqcount_retry is like read_seqcount_retry, but has no smp_rmb()
- * barrier. Callers should ensure that smp_rmb() or equivalent ordering is
- * provided before actually loading any of the variables that are to be
- * protected in this critical section.
- *
- * Use carefully, only in critical code, and comment how the barrier is
- * provided.
- */
-static inline int __read_seqcount_retry(const seqcount_t *s, unsigned start)
-{
-	return unlikely(s->sequence != start);
-}
-
-/**
- * read_seqcount_retry - end a seq-read critical section
- * @s: pointer to seqcount_t
- * @start: count, from read_seqcount_begin
- * Returns: 1 if retry is required, else 0
- *
- * read_seqcount_retry closes a read critical section of the given seqcount.
- * If the critical section was invalid, it must be ignored (and typically
- * retried).
- */
-static inline int read_seqcount_retry(const seqcount_t *s, unsigned start)
-{
-	smp_rmb();
-
-	return __read_seqcount_retry(s, start);
-}
-
-
-/*
- * Sequence counter only version assumes that callers are using their
- * own mutexing.
- */
-static inline void write_seqcount_begin(seqcount_t *s)
-{
-	s->sequence++;
-	smp_wmb();
-}
-
-static inline void write_seqcount_end(seqcount_t *s)
-{
-	smp_wmb();
-	s->sequence++;
-}
-
-/**
- * write_seqcount_barrier - invalidate in-progress read-side seq operations
- * @s: pointer to seqcount_t
- *
- * After write_seqcount_barrier, no read-side seq operations will complete
- * successfully and see data older than this.
- */
-static inline void write_seqcount_barrier(seqcount_t *s)
-{
-	smp_wmb();
-	s->sequence+=2;
-}
-
 /*
  * Possible sw/hw IRQ protected versions of the interfaces.
  */
-- 
1.8.0

