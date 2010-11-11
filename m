Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab0KKIAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 03:00:19 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:2271 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757795Ab0KKIAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 03:00:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AloEANgw20x5LcZKgWdsb2JhbACiPhYBARYiIr9lhUoE
Date: Thu, 11 Nov 2010 19:00:12 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [patches] seqlock: add barrier-less special cases for seqcounts
Message-ID: <20101111080012.GB10210@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add branch annotations for seqlock read fastpath, and introduce
__read_seqcount_begin and __read_seqcount_end functions, that can avoid
the smp_rmb() if it is provided with some other barrier. Read barriers
have non trivial cost on many architectures.

These will be used by store-free path walking algorithm, where
performance is critical and seqlocks are widely used.

Also expand and kerneldocify comments for seqlock functions in general.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 include/linux/seqlock.h |   67 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 60 insertions(+), 7 deletions(-)

Index: linux-2.6/include/linux/seqlock.h
===================================================================
--- linux-2.6.orig/include/linux/seqlock.h	2010-10-21 23:29:46.000000000 +1100
+++ linux-2.6/include/linux/seqlock.h	2010-10-21 23:29:59.000000000 +1100
@@ -107,7 +107,7 @@ static __always_inline int read_seqretry
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
@@ -140,14 +151,56 @@ static inline unsigned read_seqcount_beg
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
 
 
