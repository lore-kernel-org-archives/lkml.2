Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030234Ab2COLob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 07:44:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:39740 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760656Ab2COLoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 07:44:24 -0400
Message-Id: <20120314170918.467626549@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 15 Mar 2012 11:44:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: [patch 2/5] seqlock: Use seqcount for seqlock
References: <20120314170736.617746873@linutronix.de>
Content-Disposition: inline; filename=seqlock-use-seqcount.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No point in having different implementations for the same thing.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/seqlock.h |  176 +++++++++++++++++++++++++-----------------------
 1 file changed, 93 insertions(+), 83 deletions(-)

Index: tip/include/linux/seqlock.h
===================================================================
--- tip.orig/include/linux/seqlock.h
+++ tip/include/linux/seqlock.h
@@ -30,81 +30,12 @@
 #include <linux/preempt.h>
 #include <asm/processor.h>
 
-typedef struct {
-	unsigned sequence;
-	spinlock_t lock;
-} seqlock_t;
-
-/*
- * These macros triggered gcc-3.x compile-time problems.  We think these are
- * OK now.  Be cautious.
- */
-#define __SEQLOCK_UNLOCKED(lockname) \
-		 { 0, __SPIN_LOCK_UNLOCKED(lockname) }
-
-#define seqlock_init(x)					\
-	do {						\
-		(x)->sequence = 0;			\
-		spin_lock_init(&(x)->lock);		\
-	} while (0)
-
-#define DEFINE_SEQLOCK(x) \
-		seqlock_t x = __SEQLOCK_UNLOCKED(x)
-
-/* Lock out other writers and update the count.
- * Acts like a normal spin_lock/unlock.
- * Don't need preempt_disable() because that is in the spin_lock already.
- */
-static inline void write_seqlock(seqlock_t *sl)
-{
-	spin_lock(&sl->lock);
-	++sl->sequence;
-	smp_wmb();
-}
-
-static inline void write_sequnlock(seqlock_t *sl)
-{
-	smp_wmb();
-	sl->sequence++;
-	spin_unlock(&sl->lock);
-}
-
-/* Start of read calculation -- fetch last complete writer token */
-static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
-{
-	unsigned ret;
-
-repeat:
-	ret = ACCESS_ONCE(sl->sequence);
-	if (unlikely(ret & 1)) {
-		cpu_relax();
-		goto repeat;
-	}
-	smp_rmb();
-
-	return ret;
-}
-
-/*
- * Test if reader processed invalid data.
- *
- * If sequence value changed then writer changed data while in section.
- */
-static __always_inline int read_seqretry(const seqlock_t *sl, unsigned start)
-{
-	smp_rmb();
-
-	return unlikely(sl->sequence != start);
-}
-
-
 /*
  * Version using sequence counter only.
  * This can be used when code has its own mutex protecting the
  * updating starting before the write_seqcountbeqin() and ending
  * after the write_seqcount_end().
  */
-
 typedef struct seqcount {
 	unsigned sequence;
 } seqcount_t;
@@ -186,7 +117,6 @@ static inline int __read_seqcount_retry(
 static inline int read_seqcount_retry(const seqcount_t *s, unsigned start)
 {
 	smp_rmb();
-
 	return __read_seqcount_retry(s, start);
 }
 
@@ -220,21 +150,101 @@ static inline void write_seqcount_barrie
 	s->sequence+=2;
 }
 
+typedef struct {
+	struct seqcount seqcount;
+	spinlock_t lock;
+} seqlock_t;
+
 /*
- * Possible sw/hw IRQ protected versions of the interfaces.
+ * These macros triggered gcc-3.x compile-time problems.  We think these are
+ * OK now.  Be cautious.
  */
+#define __SEQLOCK_UNLOCKED(lockname)			\
+	{						\
+		.seqcount = SEQCNT_ZERO,		\
+		.lock =	__SPIN_LOCK_UNLOCKED(lockname)	\
+	}
+
+#define seqlock_init(x)					\
+	do {						\
+		seqcount_init(&(x)->seqcount);		\
+		spin_lock_init(&(x)->lock);		\
+	} while (0)
+
+#define DEFINE_SEQLOCK(x) \
+		seqlock_t x = __SEQLOCK_UNLOCKED(x)
+
+/*
+ * Read side functions for starting and finalizing a read side section.
+ */
+static inline unsigned read_seqbegin(const seqlock_t *sl)
+{
+	return read_seqcount_begin(&sl->seqcount);
+}
+
+static inline unsigned read_seqretry(const seqlock_t *sl, unsigned start)
+{
+	return read_seqcount_retry(&sl->seqcount, start);
+}
+
+/*
+ * Lock out other writers and update the count.
+ * Acts like a normal spin_lock/unlock.
+ * Don't need preempt_disable() because that is in the spin_lock already.
+ */
+static inline void write_seqlock(seqlock_t *sl)
+{
+	spin_lock(&sl->lock);
+	write_seqcount_begin(&sl->seqcount);
+}
+
+static inline void write_sequnlock(seqlock_t *sl)
+{
+	write_seqcount_end(&sl->seqcount);
+	spin_unlock(&sl->lock);
+}
+
+static inline void write_seqlock_bh(seqlock_t *sl)
+{
+	spin_lock_bh(&sl->lock);
+	write_seqcount_begin(&sl->seqcount);
+}
+
+static inline void write_sequnlock_bh(seqlock_t *sl)
+{
+	write_seqcount_end(&sl->seqcount);
+	spin_unlock_bh(&sl->lock);
+}
+
+static inline void write_seqlock_irq(seqlock_t *sl)
+{
+	spin_lock_irq(&sl->lock);
+	write_seqcount_begin(&sl->seqcount);
+}
+
+static inline void write_sequnlock_irq(seqlock_t *sl)
+{
+	write_seqcount_end(&sl->seqcount);
+	spin_unlock_irq(&sl->lock);
+}
+
+static inline unsigned long __write_seqlock_irqsave(seqlock_t *sl)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sl->lock, flags);
+	write_seqcount_begin(&sl->seqcount);
+	return flags;
+}
+
 #define write_seqlock_irqsave(lock, flags)				\
-	do { local_irq_save(flags); write_seqlock(lock); } while (0)
-#define write_seqlock_irq(lock)						\
-	do { local_irq_disable();   write_seqlock(lock); } while (0)
-#define write_seqlock_bh(lock)						\
-        do { local_bh_disable();    write_seqlock(lock); } while (0)
-
-#define write_sequnlock_irqrestore(lock, flags)				\
-	do { write_sequnlock(lock); local_irq_restore(flags); } while(0)
-#define write_sequnlock_irq(lock)					\
-	do { write_sequnlock(lock); local_irq_enable(); } while(0)
-#define write_sequnlock_bh(lock)					\
-	do { write_sequnlock(lock); local_bh_enable(); } while(0)
+	do { flags = __write_seqlock_irqsave(lock); } while (0)
+
+static inline void
+write_sequnlock_irqrestore(seqlock_t *sl, unsigned long flags)
+{
+	write_seqcount_end(&sl->seqcount);
+	spin_unlock_irqrestore(&sl->lock, flags);
+}
 
 #endif /* __LINUX_SEQLOCK_H */


