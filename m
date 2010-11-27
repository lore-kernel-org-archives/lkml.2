Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab0K0Kcj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:32:39 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34785 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752927Ab0K0K0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:20 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO1p8Ex5Lcx2/2dsb2JhbACjC3K9doVHBIph
Message-Id: <7d7ee49eddbd08e5d19a71560dda2a3dc22a4735.1290852959.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:45:02 +1100
Subject: [PATCH 32/46] kernel: optimise seqlock
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add branch annotations for seqlock read fastpath, and introduce
__read_seqcount_begin and __read_seqcount_end functions, that can avoid the
smp_rmb() if used carefully. These will be used by store-free path walking
algorithm performance is critical and seqlocks are in use.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 include/linux/seqlock.h |   67 ++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 60 insertions(+), 7 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 632205c..513c550 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -107,7 +107,7 @@ static __always_inline int read_seqretry(const seqlock_t *sl, unsigned start)
 {
 	smp_rmb();
 
-	return (sl->sequence != start);
+	return unlikely(sl->sequence != start);
 }
 
 
@@ -125,14 +125,25 @@ typedef struct seqcount {
 #define SEQCNT_ZERO { 0 }
 #define seqcount_init(x)	do { *(x) = (seqcount_t) SEQCNT_ZERO; } while (0)
 
-/* Start of read using pointer to a sequence counter only.  */
-static inline unsigned read_seqcount_begin(const seqcount_t *s)
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
 {
 	unsigned ret;
 
 repeat:
 	ret = s->sequence;
-	smp_rmb();
 	if (unlikely(ret & 1)) {
 		cpu_relax();
 		goto repeat;
@@ -140,14 +151,56 @@ repeat:
 	return ret;
 }
 
-/*
- * Test if reader processed invalid data because sequence number has changed.
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
  */
 static inline int read_seqcount_retry(const seqcount_t *s, unsigned start)
 {
 	smp_rmb();
 
-	return s->sequence != start;
+	return __read_seqcount_retry(s, start);
 }
 
 
-- 
1.7.1

