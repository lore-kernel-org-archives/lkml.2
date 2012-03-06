Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab2CFQXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:23:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29606 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab2CFQTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:19:47 -0500
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=mcsHjY9-G0YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Sdnn_97G8oaHSRwm5WcA:9 a=AqV067L2iHb5cJJKN-wA:7 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120306161945.553560237@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 06 Mar 2012 11:16:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 03/25][RFC 3.0.23-rt39-rc1] revert-seqlock-use-seqcount
References: <20120306161636.491172179@goodmis.org>
Content-Disposition: inline; filename=0003-revert-seqlock-use-seqcount.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

revert: seqlock-use-seqcount.patch

Revert:

Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sat Jul 16 18:40:26 2011 +0200

    seqlock-use-seqcount.patch

    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/seqlock.h |  166 +++++++++++++++++++++++-----------------------
 1 files changed, 83 insertions(+), 83 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 11a9073..b990f6e 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -30,12 +30,81 @@
 #include <linux/preempt.h>
 #include <asm/processor.h>
 
+typedef struct {
+	unsigned sequence;
+	spinlock_t lock;
+} seqlock_t;
+
+/*
+ * These macros triggered gcc-3.x compile-time problems.  We think these are
+ * OK now.  Be cautious.
+ */
+#define __SEQLOCK_UNLOCKED(lockname) \
+		 { 0, __SPIN_LOCK_UNLOCKED(lockname) }
+
+#define seqlock_init(x)					\
+	do {						\
+		(x)->sequence = 0;			\
+		spin_lock_init(&(x)->lock);		\
+	} while (0)
+
+#define DEFINE_SEQLOCK(x) \
+		seqlock_t x = __SEQLOCK_UNLOCKED(x)
+
+/* Lock out other writers and update the count.
+ * Acts like a normal spin_lock/unlock.
+ * Don't need preempt_disable() because that is in the spin_lock already.
+ */
+static inline void write_seqlock(seqlock_t *sl)
+{
+	spin_lock(&sl->lock);
+	++sl->sequence;
+	smp_wmb();
+}
+
+static inline void write_sequnlock(seqlock_t *sl)
+{
+	smp_wmb();
+	sl->sequence++;
+	spin_unlock(&sl->lock);
+}
+
+/* Start of read calculation -- fetch last complete writer token */
+static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
+{
+	unsigned ret;
+
+repeat:
+	ret = ACCESS_ONCE(sl->sequence);
+	if (unlikely(ret & 1)) {
+		cpu_relax();
+		goto repeat;
+	}
+	smp_rmb();
+
+	return ret;
+}
+
+/*
+ * Test if reader processed invalid data.
+ *
+ * If sequence value changed then writer changed data while in section.
+ */
+static __always_inline int read_seqretry(const seqlock_t *sl, unsigned start)
+{
+	smp_rmb();
+
+	return unlikely(sl->sequence != start);
+}
+
+
 /*
  * Version using sequence counter only.
  * This can be used when code has its own mutex protecting the
  * updating starting before the write_seqcountbeqin() and ending
  * after the write_seqcount_end().
  */
+
 typedef struct seqcount {
 	unsigned sequence;
 } seqcount_t;
@@ -117,6 +186,7 @@ static inline int __read_seqcount_retry(const seqcount_t *s, unsigned start)
 static inline int read_seqcount_retry(const seqcount_t *s, unsigned start)
 {
 	smp_rmb();
+
 	return __read_seqcount_retry(s, start);
 }
 
@@ -150,91 +220,21 @@ static inline void write_seqcount_barrier(seqcount_t *s)
 	s->sequence+=2;
 }
 
-typedef struct {
-	struct seqcount seqcount;
-	spinlock_t lock;
-} seqlock_t;
-
 /*
- * These macros triggered gcc-3.x compile-time problems.  We think these are
- * OK now.  Be cautious.
+ * Possible sw/hw IRQ protected versions of the interfaces.
  */
-#define __SEQLOCK_UNLOCKED(lockname)			\
-	{						\
-		.seqcount = SEQCNT_ZERO,		\
-		.lock =	__SPIN_LOCK_UNLOCKED(lockname)	\
-	}
-
-#define seqlock_init(x)					\
-	do {						\
-		seqcount_init(&(x)->seqcount);		\
-		spin_lock_init(&(x)->lock);		\
-	} while (0)
-
-#define DEFINE_SEQLOCK(x) \
-		seqlock_t x = __SEQLOCK_UNLOCKED(x)
-
-#define read_seqbegin(sl)		read_seqcount_begin(&(sl)->seqcount)
-#define read_seqretry(sl, start)	read_seqcount_retry(&(sl)->seqcount, start)
-
-/*
- * Lock out other writers and update the count.
- * Acts like a normal spin_lock/unlock.
- * Don't need preempt_disable() because that is in the spin_lock already.
- */
-static inline void write_seqlock(seqlock_t *sl)
-{
-	spin_lock(&sl->lock);
-	write_seqcount_begin(&sl->seqcount);
-}
-
-static inline void write_sequnlock(seqlock_t *sl)
-{
-	write_seqcount_end(&sl->seqcount);
-	spin_unlock(&sl->lock);
-}
-
-static inline void write_seqlock_bh(seqlock_t *sl)
-{
-	spin_lock_bh(&sl->lock);
-	write_seqcount_begin(&sl->seqcount);
-}
-
-static inline void write_sequnlock_bh(seqlock_t *sl)
-{
-	write_seqcount_end(&sl->seqcount);
-	spin_unlock_bh(&sl->lock);
-}
-
-static inline void write_seqlock_irq(seqlock_t *sl)
-{
-	spin_lock_irq(&sl->lock);
-	write_seqcount_begin(&sl->seqcount);
-}
-
-static inline void write_sequnlock_irq(seqlock_t *sl)
-{
-	write_seqcount_end(&sl->seqcount);
-	spin_unlock_irq(&sl->lock);
-}
-
-static inline unsigned long __write_seqlock_irqsave(seqlock_t *sl)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&sl->lock, flags);
-	write_seqcount_begin(&sl->seqcount);
-	return flags;
-}
-
 #define write_seqlock_irqsave(lock, flags)				\
-	do { flags = __write_seqlock_irqsave(lock); } while (0)
-
-static inline void
-write_sequnlock_irqrestore(seqlock_t *sl, unsigned long flags)
-{
-	write_seqcount_end(&sl->seqcount);
-	spin_unlock_irqrestore(&sl->lock, flags);
-}
+	do { local_irq_save(flags); write_seqlock(lock); } while (0)
+#define write_seqlock_irq(lock)						\
+	do { local_irq_disable();   write_seqlock(lock); } while (0)
+#define write_seqlock_bh(lock)						\
+        do { local_bh_disable();    write_seqlock(lock); } while (0)
+
+#define write_sequnlock_irqrestore(lock, flags)				\
+	do { write_sequnlock(lock); local_irq_restore(flags); } while(0)
+#define write_sequnlock_irq(lock)					\
+	do { write_sequnlock(lock); local_irq_enable(); } while(0)
+#define write_sequnlock_bh(lock)					\
+	do { write_sequnlock(lock); local_bh_enable(); } while(0)
 
 #endif /* __LINUX_SEQLOCK_H */
-- 
1.7.8.3


