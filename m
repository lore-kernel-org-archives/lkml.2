Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761756Ab2COLpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 07:45:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:39744 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761539Ab2COLoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 07:44:25 -0400
Message-Id: <20120314170918.535070199@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 15 Mar 2012 11:44:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: [patch 3/5] seqlock: Provide seq_spin_* functions
References: <20120314170736.617746873@linutronix.de>
Content-Disposition: inline; filename=seqlock-provide-seq-spin-lock.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases it's desirable to lock the seqlock w/o changing the
seqcount. Provide functions for this, so we can avoid open coded
constructs.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/seqlock.h |   66 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

Index: tip/include/linux/seqlock.h
===================================================================
--- tip.orig/include/linux/seqlock.h
+++ tip/include/linux/seqlock.h
@@ -176,6 +176,21 @@ typedef struct {
 
 /*
  * Read side functions for starting and finalizing a read side section.
+ * w/o barriers
+ */
+static inline unsigned __read_seqbegin(const seqlock_t *sl)
+{
+	return __read_seqcount_begin(&sl->seqcount);
+}
+
+static inline unsigned __read_seqretry(const seqlock_t *sl, unsigned start)
+{
+	return __read_seqcount_retry(&sl->seqcount, start);
+}
+
+/*
+ * Read side functions for starting and finalizing a read side section.
+ * with barriers
  */
 static inline unsigned read_seqbegin(const seqlock_t *sl)
 {
@@ -247,4 +262,55 @@ write_sequnlock_irqrestore(seqlock_t *sl
 	spin_unlock_irqrestore(&sl->lock, flags);
 }
 
+/*
+ * Instead of open coding a spinlock and a seqcount, the following
+ * functions allow to serialize on the seqlock w/o touching seqcount.
+ */
+static inline void seq_spin_lock(seqlock_t *sl)
+{
+	spin_lock(&sl->lock);
+}
+
+static inline int seq_spin_trylock(seqlock_t *sl)
+{
+	return spin_trylock(&sl->lock);
+}
+
+static inline void seq_spin_unlock(seqlock_t *sl)
+{
+	spin_unlock(&sl->lock);
+}
+
+static inline void assert_seq_spin_locked(seqlock_t *sl)
+{
+	lockdep_assert_held(&sl->lock);
+}
+
+static inline void seq_spin_lock_nested(seqlock_t *sl, int subclass)
+{
+	spin_lock_nested(&sl->lock, subclass);
+}
+
+/*
+ * For writers which need to take/release the lock w/o updating seqcount for
+ * whatever reasons the following functions allow to update the count
+ * after the lock has been acquired or before it is released.
+ */
+static inline void write_seqlock_begin(seqlock_t *sl)
+{
+	lockdep_assert_held(&sl->lock);
+	write_seqcount_begin(&sl->seqcount);
+}
+
+static inline void write_seqlock_end(seqlock_t *sl)
+{
+	lockdep_assert_held(&sl->lock);
+	write_seqcount_end(&sl->seqcount);
+}
+
+static inline void write_seqlock_barrier(seqlock_t *sl)
+{
+	write_seqcount_barrier(&sl->seqcount);
+}
+
 #endif /* __LINUX_SEQLOCK_H */


