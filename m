Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab2CFEDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 23:03:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11730 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895Ab2CFEDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 23:03:07 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=dsNQgiZsgNIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=rNbeg_Uf9ar5u9fk7eYA:9 a=Y3NhY_pb9qn9EJMJ1NIA:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331006584.25686.362.camel@gandalf.stny.rr.com>
Subject: [PATCH RT] seqlock/rt: Prevent livelocks with seqlocks in RT
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Clark Williams <clark@redhat.com>,
        John Kacur <jkacur@redhat.com>, Carsten Emde <cbe@osadl.org>
Date: Mon, 05 Mar 2012 23:03:04 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

I was running my cpu hotplug stress test along with a kernel compile and
after about 40 minutes of running it locked up. It happened in the
read_seqcount_begin() that is called by d_lookup().

ksoftirqd was caught here:

static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
{
	unsigned ret;

repeat:
	ret = ACCESS_ONCE(sl->sequence);
	if (unlikely(ret & 1)) {
		cpu_relax();
		goto repeat;
	}
	smp_rmb();

	return ret;
}

It preempted the holder of the seqlock that was held for write, and as
that holder had migrate disabled, it couldn't be scheduled. Then
ksoftirqd went into this infinite loop and the system locked up.

This patch fixes the issue by grabbing and releasing the write lock when
it detects contention. It only works with seqlocks and not seqcounts
that have their own locking. But we could add an api to include those
too if needed.

-- Steve



>From b4c0fe13e4e54f20f9e5975a39fb37efd0736333 Mon Sep 17 00:00:00 2001
From: Steven Rostedt <srostedt@redhat.com>
Date: Thu, 1 Mar 2012 09:38:12 -0500
Subject: seqlock/rt: Prevent livelocks with seqlocks in RT

With RT, seqlocks can be preempted. Worse yet, when holding a
write_seqlock, migration is disabled. If an high priority task
preempts a task holding a write_seqlock, and that high priority
task uses the associated read_seqlock(), it can go into an infinite
spin waiting for the write_seqlock() to finish. But since the holder
of that lock has migration disabled, and is of lower priority than
the task using the read_seqlock() we end up with a live lock.

To prevent this, when the read_seqcount_begin() detects that a
write lock is being held, it will grab that lock and release it.
This will cause the holder of the lock to wake up and finish.
The priority inheritance will help it as well.

Because read_seqlocks are used in the VDSO area, a raw_read_seqcount_begin()
was created to allow userspace tasks to access read_seqcount().
As the grabbing of the write_lock() is not allowed in VDSO, nor
is even referencing it.

Note, a live lock can still happen if the userspace task that
does the read_seqlock is of higher priority than a user doing
the write_lock, so userspace needs to be careful.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/vdso/vclock_gettime.c |    8 +++---
 include/linux/seqlock.h        |   59 +++++++++++++++++++++++++++++++++------
 2 files changed, 54 insertions(+), 13 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index d8511fb..01d0c2c 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -86,7 +86,7 @@ notrace static noinline int do_realtime(struct timespec *ts)
 {
 	unsigned long seq, ns;
 	do {
-		seq = read_seqcount_begin(&gtod->seq);
+		seq = raw_read_seqcount_begin(&gtod->seq);
 		ts->tv_sec = gtod->wall_time_sec;
 		ts->tv_nsec = gtod->wall_time_nsec;
 		ns = vgetns();
@@ -99,7 +99,7 @@ notrace static noinline int do_monotonic(struct timespec *ts)
 {
 	unsigned long seq, ns, secs;
 	do {
-		seq = read_seqcount_begin(&gtod->seq);
+		seq = raw_read_seqcount_begin(&gtod->seq);
 		secs = gtod->wall_time_sec;
 		ns = gtod->wall_time_nsec + vgetns();
 		secs += gtod->wall_to_monotonic.tv_sec;
@@ -123,7 +123,7 @@ notrace static noinline int do_realtime_coarse(struct timespec *ts)
 {
 	unsigned long seq;
 	do {
-		seq = read_seqcount_begin(&gtod->seq);
+		seq = raw_read_seqcount_begin(&gtod->seq);
 		ts->tv_sec = gtod->wall_time_coarse.tv_sec;
 		ts->tv_nsec = gtod->wall_time_coarse.tv_nsec;
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
@@ -134,7 +134,7 @@ notrace static noinline int do_monotonic_coarse(struct timespec *ts)
 {
 	unsigned long seq, ns, secs;
 	do {
-		seq = read_seqcount_begin(&gtod->seq);
+		seq = raw_read_seqcount_begin(&gtod->seq);
 		secs = gtod->wall_time_coarse.tv_sec;
 		ns = gtod->wall_time_coarse.tv_nsec;
 		secs += gtod->wall_to_monotonic.tv_sec;
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 723274d..6d93b72 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -38,10 +38,32 @@
  */
 typedef struct seqcount {
 	unsigned sequence;
+#ifdef CONFIG_PREEMPT_RT_FULL
+	int has_lock;
+#endif
 } seqcount_t;
 
-#define SEQCNT_ZERO { 0 }
-#define seqcount_init(x)	do { *(x) = (seqcount_t) SEQCNT_ZERO; } while (0)
+#ifdef CONFIG_PREEMPT_RT_FULL
+# define SEQCNT_ZERO		{ 0, 0 }
+# define SEQCNT_ZERO_LOCK	{ 0, 1 }
+# define seqcount_init(x)	do { *(x) = (seqcount_t) SEQCNT_ZERO; } while (0)
+# define seqcount_init_lock(x)	do { *(x) = (seqcount_t) SEQCNT_ZERO_LOCK; } while (0)
+#else
+# define SEQCNT_ZERO		{ 0 }
+# define SEQCNT_ZERO_LOCK	SEQCNT_ZERO
+# define seqcount_init(x)	do { *(x) = (seqcount_t) SEQCNT_ZERO; } while (0)
+# define seqcount_init_lock(x)	seqcount_init(x)
+#endif
+
+typedef struct {
+	struct seqcount seqcount;
+	raw_spinlock_t lock;
+} raw_seqlock_t;
+
+typedef struct {
+	struct seqcount seqcount;
+	spinlock_t lock;
+} seqlock_t;
 
 /**
  * __read_seqcount_begin - begin a seq-read critical section (without barrier)
@@ -63,6 +85,30 @@ static inline unsigned __read_seqcount_begin(const seqcount_t *s)
 repeat:
 	ret = s->sequence;
 	if (unlikely(ret & 1)) {
+#ifdef CONFIG_PREEMPT_RT_FULL
+		if (s->has_lock) {
+			seqlock_t *sl;
+
+			sl = container_of(s, seqlock_t, seqcount);
+			/* This process may be blocking the writer, kick it */
+			spin_lock(&sl->lock);
+			spin_unlock(&sl->lock);
+		}
+#endif
+		cpu_relax();
+		goto repeat;
+	}
+	return ret;
+}
+
+/* Needed for VDSO areas */
+static inline unsigned raw_read_seqcount_begin(const seqcount_t *s)
+{
+	unsigned ret;
+
+repeat:
+	ret = s->sequence;
+	if (unlikely(ret & 1)) {
 		cpu_relax();
 		goto repeat;
 	}
@@ -150,24 +196,19 @@ static inline void write_seqcount_barrier(seqcount_t *s)
 	s->sequence+=2;
 }
 
-typedef struct {
-	struct seqcount seqcount;
-	spinlock_t lock;
-} seqlock_t;
-
 /*
  * These macros triggered gcc-3.x compile-time problems.  We think these are
  * OK now.  Be cautious.
  */
 #define __SEQLOCK_UNLOCKED(lockname)			\
 	{						\
-		.seqcount = SEQCNT_ZERO,		\
+		.seqcount = SEQCNT_ZERO_LOCK,		\
 		.lock =	__SPIN_LOCK_UNLOCKED(lockname)	\
 	}
 
 #define seqlock_init(x)					\
 	do {						\
-		seqcount_init(&(x)->seqcount);		\
+		seqcount_init_lock(&(x)->seqcount);		\
 		spin_lock_init(&(x)->lock);		\
 	} while (0)
 
-- 
1.7.3.4



