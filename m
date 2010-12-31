Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0LaTPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 14:15:52 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39300 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab0LaTPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 14:15:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lZzVzxq1qVRpWNu4ghQjtSRatoBrd5rLY59oAsNcBzaL5V2AETnbg+UivElxpb+Il3
         skFhsUZp9UQjAuWXBSmV37fe30MCZ2DPGaSbNMbIe8yk3NZZr8YiJ2hQwEaBtGG0JcA3
         nNvXoTMj6r01FHBATHKFcv2d6EYnebz/RKLlo=
Date: Fri, 31 Dec 2010 20:15:33 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        John Stultz <johnstul@us.ibm.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH V8 08/13] posix clocks: cleanup the CLOCK_DISPTACH macro
Message-ID: <503cd1fa268867573001cfc9bb5681ee3b5b32fa.1293820862.git.richard.cochran@omicron.at>
References: <cover.1293820862.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1293820862.git.richard.cochran@omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paraphrasing tglx:

This patch simplifies and clarifies the code, doing the normal thing
with function pointer structures. Stuff which is not implemented does
not magically become called via some common function. There is no
point in doing that.

We fill in the various k_clock structs with the correct pointers in
the first place and let the NULL case return a sensible error
value. The data structure does not become larger that way. It's a
little bit more init code, but that's fine if we make the code better
in general. In that case it's not even more init code, it's just
filling the data structures which we register.

My own words:

For now, each of the registered k_clocks has the previously NULL
functions assigned to the common_xyz function, since that usage was
implicitly enforced by the CLOCK_DISPTACH macro. These functions are
marked with a /* default: */ comment.

As as possible further improvement for the future, one could go
through and replace the various no_xyz function pointers in the
k_clocks with NULL pointers.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
---
 include/linux/posix-timers.h |   14 +++
 include/linux/time.h         |    2 +
 kernel/posix-timers.c        |  241 ++++++++++++++++++++++++++++++++++--------
 3 files changed, 213 insertions(+), 44 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index b05d9b8..eef7f9c 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -18,6 +18,18 @@ struct cpu_timer_list {
 	int firing;
 };
 
+/* Bit fields within a clockid:
+ *
+ * The most significant 29 bits hold either a pid or a file descriptor.
+ *
+ * Bit 2 indicates whether a cpu clock refers to a thread or a process.
+ *
+ * Bits 1 and 0 give the type: PROF=0, VIRT=1, SCHED=2, or FD=3.
+ *
+ * A clockid is invalid if bits 2, 1, and 0 all set (see also CLOCK_INVALID
+ * in include/linux/time.h)
+ */
+
 #define CPUCLOCK_PID(clock)		((pid_t) ~((clock) >> 3))
 #define CPUCLOCK_PERTHREAD(clock) \
 	(((clock) & (clockid_t) CPUCLOCK_PERTHREAD_MASK) != 0)
@@ -29,6 +41,8 @@ struct cpu_timer_list {
 #define CPUCLOCK_VIRT		1
 #define CPUCLOCK_SCHED		2
 #define CPUCLOCK_MAX		3
+#define CLOCKFD			CPUCLOCK_MAX
+#define CLOCKFD_MASK		(CPUCLOCK_PERTHREAD_MASK|CPUCLOCK_CLOCK_MASK)
 
 #define MAKE_PROCESS_CPUCLOCK(pid, clock) \
 	((~(clockid_t) (pid) << 3) | (clockid_t) (clock))
diff --git a/include/linux/time.h b/include/linux/time.h
index b402134..99d4b14 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -300,6 +300,8 @@ struct itimerval {
 #define CLOCKS_MASK			(CLOCK_REALTIME | CLOCK_MONOTONIC)
 #define CLOCKS_MONO			CLOCK_MONOTONIC
 
+#define CLOCK_INVALID			-1
+
 /*
  * The various flags for setting POSIX.1b interval timers:
  */
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 502bde4..65b0599 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -138,6 +138,7 @@ static struct k_clock posix_clocks[MAX_CLOCKS];
  */
 static int common_nsleep(const clockid_t, int flags, struct timespec *t,
 			 struct timespec __user *rmtp);
+static long common_nsleep_restart(struct restart_block *restart_block);
 static void common_timer_get(struct k_itimer *, struct itimerspec *);
 static int common_timer_set(struct k_itimer *, int,
 			    struct itimerspec *, struct itimerspec *);
@@ -152,41 +153,14 @@ static inline void unlock_timer(struct k_itimer *timr, unsigned long flags)
 	spin_unlock_irqrestore(&timr->it_lock, flags);
 }
 
-/*
- * Call the k_clock hook function if non-null, or the default function.
- */
-#define CLOCK_DISPATCH(clock, call, arglist) \
- 	((clock) < 0 ? posix_cpu_##call arglist : \
- 	 (posix_clocks[clock].call != NULL \
- 	  ? (*posix_clocks[clock].call) arglist : common_##call arglist))
-
-/*
- * Default clock hook functions when the struct k_clock passed
- * to register_posix_clock leaves a function pointer null.
- *
- * The function common_CALL is the default implementation for
- * the function pointer CALL in struct k_clock.
- */
 
-static inline int common_clock_getres(const clockid_t which_clock,
-				      struct timespec *tp)
-{
-	tp->tv_sec = 0;
-	tp->tv_nsec = posix_clocks[which_clock].res;
-	return 0;
-}
-
-/*
- * Get real time for posix timers
- */
 static int common_clock_get(clockid_t which_clock, struct timespec *tp)
 {
 	ktime_get_real_ts(tp);
 	return 0;
 }
 
-static inline int common_clock_set(const clockid_t which_clock,
-				   struct timespec *tp)
+static int common_clock_set(const clockid_t which_clock, struct timespec *tp)
 {
 	return do_sys_settimeofday(tp, NULL);
 }
@@ -197,7 +171,7 @@ static int common_timer_create(struct k_itimer *new_timer)
 	return 0;
 }
 
-static inline int common_clock_adj(const clockid_t which_clock, struct timex *t)
+static int common_clock_adj(const clockid_t which_clock, struct timex *t)
 {
 	return do_adjtimex(t);
 }
@@ -214,19 +188,14 @@ static int no_nsleep(const clockid_t which_clock, int flags,
 }
 
 /*
- * Return nonzero if we know a priori this clockid_t value is bogus.
+ * Return 'true' if we know a priori this clockid_t value is bogus.
  */
-static inline int invalid_clockid(const clockid_t which_clock)
+static inline bool invalid_clockid(const clockid_t which_clock)
 {
-	if (which_clock < 0)	/* CPU clock, posix_cpu_* will check it */
-		return 0;
-	if ((unsigned) which_clock >= MAX_CLOCKS)
-		return 1;
-	if (posix_clocks[which_clock].clock_getres != NULL)
-		return 0;
-	if (posix_clocks[which_clock].res != 0)
-		return 0;
-	return 1;
+	if (which_clock >= MAX_CLOCKS)
+		return true;
+	else
+		return false;
 }
 
 /*
@@ -273,12 +242,29 @@ static __init int init_posix_timers(void)
 {
 	struct k_clock clock_realtime = {
 		.clock_getres = hrtimer_get_res,
+		/* defaults: */
+		.clock_adj	= common_clock_adj,
+		.clock_get	= common_clock_get,
+		.clock_set	= common_clock_set,
+		.nsleep		= common_nsleep,
+		.nsleep_restart	= common_nsleep_restart,
+		.timer_create	= common_timer_create,
+		.timer_del	= common_timer_del,
+		.timer_get	= common_timer_get,
+		.timer_set	= common_timer_set,
 	};
 	struct k_clock clock_monotonic = {
 		.clock_getres = hrtimer_get_res,
 		.clock_get = posix_ktime_get_ts,
 		.clock_set = do_posix_clock_nosettime,
 		.clock_adj = do_posix_clock_noadjtime,
+		/* defaults: */
+		.nsleep		= common_nsleep,
+		.nsleep_restart	= common_nsleep_restart,
+		.timer_create	= common_timer_create,
+		.timer_del	= common_timer_del,
+		.timer_get	= common_timer_get,
+		.timer_set	= common_timer_set,
 	};
 	struct k_clock clock_monotonic_raw = {
 		.clock_getres = hrtimer_get_res,
@@ -287,6 +273,11 @@ static __init int init_posix_timers(void)
 		.clock_adj = do_posix_clock_noadjtime,
 		.timer_create = no_timer_create,
 		.nsleep = no_nsleep,
+		/* defaults: */
+		.nsleep_restart	= common_nsleep_restart,
+		.timer_del	= common_timer_del,
+		.timer_get	= common_timer_get,
+		.timer_set	= common_timer_set,
 	};
 	struct k_clock clock_realtime_coarse = {
 		.clock_getres = posix_get_coarse_res,
@@ -295,6 +286,11 @@ static __init int init_posix_timers(void)
 		.clock_adj = do_posix_clock_noadjtime,
 		.timer_create = no_timer_create,
 		.nsleep = no_nsleep,
+		/* defaults: */
+		.nsleep_restart	= common_nsleep_restart,
+		.timer_del	= common_timer_del,
+		.timer_get	= common_timer_get,
+		.timer_set	= common_timer_set,
 	};
 	struct k_clock clock_monotonic_coarse = {
 		.clock_getres = posix_get_coarse_res,
@@ -303,6 +299,11 @@ static __init int init_posix_timers(void)
 		.clock_adj = do_posix_clock_noadjtime,
 		.timer_create = no_timer_create,
 		.nsleep = no_nsleep,
+		/* defaults: */
+		.nsleep_restart	= common_nsleep_restart,
+		.timer_del	= common_timer_del,
+		.timer_get	= common_timer_get,
+		.timer_set	= common_timer_set,
 	};
 
 	register_posix_clock(CLOCK_REALTIME, &clock_realtime);
@@ -526,6 +527,160 @@ static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
 	kmem_cache_free(posix_timers_cache, tmr);
 }
 
+static inline bool clock_is_posix_cpu(const clockid_t id)
+{
+	if ((id & CLOCKFD_MASK) == CLOCKFD)
+		return false;
+	else
+		return true;
+}
+
+static inline int dispatch_clock_getres(const clockid_t id, struct timespec *ts)
+{
+	if (id >= 0) {
+		return posix_clocks[id].clock_getres ?
+			posix_clocks[id].clock_getres(id, ts) : -EINVAL;
+	}
+
+	if (clock_is_posix_cpu(id))
+		return posix_cpu_clock_getres(id, ts);
+
+	return -EINVAL;
+}
+
+static inline int dispatch_clock_set(const clockid_t id, struct timespec *ts)
+{
+	if (id >= 0) {
+		return posix_clocks[id].clock_set ?
+			posix_clocks[id].clock_set(id, ts) : -EINVAL;
+	}
+
+	if (clock_is_posix_cpu(id))
+		return posix_cpu_clock_set(id, ts);
+
+	return -EINVAL;
+}
+
+static inline int dispatch_clock_get(const clockid_t id, struct timespec *ts)
+{
+	if (id >= 0) {
+		return posix_clocks[id].clock_get ?
+			posix_clocks[id].clock_get(id, ts) : -EINVAL;
+	}
+
+	if (clock_is_posix_cpu(id))
+		return posix_cpu_clock_get(id, ts);
+
+	return -EINVAL;
+}
+
+static inline int dispatch_clock_adj(const clockid_t id, struct timex *tx)
+{
+	if (id >= 0) {
+		return posix_clocks[id].clock_adj ?
+			posix_clocks[id].clock_adj(id, tx) : -EINVAL;
+	}
+
+	if (clock_is_posix_cpu(id))
+		return posix_cpu_clock_adj(id, tx);
+
+	return -EINVAL;
+}
+
+static inline int dispatch_timer_create(struct k_itimer *kit)
+{
+	clockid_t id = kit->it_clock;
+
+	if (id >= 0) {
+		return posix_clocks[id].timer_create ?
+			posix_clocks[id].timer_create(kit) : -EINVAL;
+	}
+
+	if (clock_is_posix_cpu(id))
+		return posix_cpu_timer_create(kit);
+
+	return -EINVAL;
+}
+
+static inline int dispatch_nsleep(const clockid_t id, int flags,
+				  struct timespec *ts,
+				  struct timespec __user *rts)
+{
+	if (id >= 0) {
+		return posix_clocks[id].nsleep ?
+			posix_clocks[id].nsleep(id, flags, ts, rts) : -EINVAL;
+	}
+
+	if (clock_is_posix_cpu(id))
+		return posix_cpu_nsleep(id, flags, ts, rts);
+
+	return -EINVAL;
+}
+
+static inline long dispatch_nsleep_restart(struct restart_block *block)
+{
+	clockid_t id = block->arg0;
+
+	if (id >= 0) {
+		return posix_clocks[id].nsleep_restart ?
+			posix_clocks[id].nsleep_restart(block) : -EINVAL;
+	}
+
+	if (clock_is_posix_cpu(id))
+		return posix_cpu_nsleep_restart(block);
+
+	return -EINVAL;
+}
+
+static inline int dispatch_timer_set(struct k_itimer *kit, int flags,
+				     struct itimerspec *tsp,
+				     struct itimerspec *old)
+{
+	clockid_t id = kit->it_clock;
+
+	if (id >= 0) {
+		return posix_clocks[id].timer_set ?
+			posix_clocks[id].timer_set(kit, flags, tsp, old) :
+			-EINVAL;
+	}
+
+	if (clock_is_posix_cpu(id))
+		return posix_cpu_timer_set(kit, flags, tsp, old);
+
+	return -EINVAL;
+}
+
+static inline int dispatch_timer_del(struct k_itimer *kit)
+{
+	clockid_t id = kit->it_clock;
+
+	if (id >= 0) {
+		return posix_clocks[id].timer_del ?
+			posix_clocks[id].timer_del(kit) : -EINVAL;
+	}
+
+	if (clock_is_posix_cpu(id))
+		return posix_cpu_timer_del(kit);
+
+	return -EINVAL;
+}
+
+static inline void dispatch_timer_get(struct k_itimer *kit,
+				      struct itimerspec *tsp)
+{
+	clockid_t id = kit->it_clock;
+
+	if (id >= 0 && posix_clocks[id].timer_get)
+
+		posix_clocks[id].timer_get(kit, tsp);
+
+	else if (clock_is_posix_cpu(id))
+
+		posix_cpu_timer_get(kit, tsp);
+}
+
+#define CLOCK_DISPATCH(clock, call, arglist) dispatch_##call arglist
+
 /* Create a POSIX.1b interval timer. */
 
 SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
@@ -847,7 +1002,7 @@ retry:
 	return error;
 }
 
-static inline int common_timer_del(struct k_itimer *timer)
+static int common_timer_del(struct k_itimer *timer)
 {
 	timer->it.real.interval.tv64 = 0;
 
@@ -1056,7 +1211,7 @@ SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
 /*
  * nanosleep_restart for monotonic and realtime clocks
  */
-static int common_nsleep_restart(struct restart_block *restart_block)
+static long common_nsleep_restart(struct restart_block *restart_block)
 {
 	return hrtimer_nanosleep_restart(restart_block);
 }
@@ -1068,8 +1223,6 @@ static int common_nsleep_restart(struct restart_block *restart_block)
 long
 clock_nanosleep_restart(struct restart_block *restart_block)
 {
-	clockid_t which_clock = restart_block->arg0;
-
 	return CLOCK_DISPATCH(which_clock, nsleep_restart,
 			      (restart_block));
 }
-- 
1.7.0.4

