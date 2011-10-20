Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab1JTOgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 10:36:19 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:38068 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab1JTOgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 10:36:17 -0400
Date: Thu, 20 Oct 2011 16:36:09 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Simon Kirby <sim@hostway.ca>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 3.1-rc9
Message-ID: <20111020163609.16816e78@de.ibm.com>
In-Reply-To: <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
	<20111007070842.GA27555@hostway.ca>
	<20111007174848.GA11011@hostway.ca>
	<1318010515.398.8.camel@twins>
	<20111008005035.GC22843@hostway.ca>
	<1318060551.8395.0.camel@twins>
	<20111012213555.GC24461@hostway.ca>
	<20111013232521.GA5654@hostway.ca>
	<CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Oct 2011 18:39:57 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> That stupid definition of cputime_add() has apparently existed as-is
> since it was introduced in 2005. Why do we have code like this:
> 
>     times->utime = cputime_add(times->utime, t->utime);
> 
> instead of just
> 
>     times->utime += t->utime;
> 
> which seems not just shorter, but more readable too? The reason is not
> some type safety in the cputime_add() thing, it's just a macro.
> 
> Added Martin and Ingo to the discussion - Martin because he added that
> cputime_add in the first place, and Ingo because he gets the most hits
> on kernel/sched_stats.h. Guys - you can see the history on lkml.

I tried my luck with cputime and sparse. It seems to work, I've added
sparse __nocast to the typedefs of cputime_t and cputime64_t and removed
all cputime macros for simple scalar operations on cputime.

Compiling a x86-64 tree with C=1 still gives a few warnings:

1) sparse creates a warning if a pointer to a nowarn variable is created.
   Is that intentional?
2) uptime_proc_show is borked, it uses a cputime_t to accumulate the idle
   time over the processors. This will overflow on x86-32 after 12.45 days
   of idle time. The __nocast check of sparse correctly identifies this
   as a problem:
   fs/proc/uptime.c:18:49: warning: implicit cast to/from nocast type.
3) cpufreq governor do strange things with cputime, e.g. wall time that
   is kept in a cputime64..

The patch is quite big. Comments ?

---
Subject: [PATCH] cputime: add sparse checking and cleanup

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Make cputime_t and cputime64_t nocast to enable sparse checking to
detect incorrect use of cputime. Drop the cputime macros for simple
scalar operations. The conversion macros are still needed as well as
the cputime_zero, cputime64_zero and cputime_one_jiffy defines.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/ia64/include/asm/cputime.h        |   72 ++++++++---------
 arch/powerpc/include/asm/cputime.h     |   71 ++++++----------
 arch/s390/include/asm/cputime.h        |  139 +++++++++++++++------------------
 drivers/cpufreq/cpufreq_conservative.c |   27 +++---
 drivers/cpufreq/cpufreq_ondemand.c     |   31 +++----
 drivers/cpufreq/cpufreq_stats.c        |    5 -
 drivers/macintosh/rack-meter.c         |   11 --
 fs/proc/array.c                        |    4 
 fs/proc/stat.c                         |   25 ++---
 fs/proc/uptime.c                       |    2 
 include/asm-generic/cputime.h          |   64 +++++++--------
 kernel/acct.c                          |    4 
 kernel/cpu.c                           |    3 
 kernel/exit.c                          |   22 +----
 kernel/itimer.c                        |   19 ++--
 kernel/posix-cpu-timers.c              |  125 ++++++++++++-----------------
 kernel/sched.c                         |   80 ++++++++----------
 kernel/sched_stats.h                   |    6 -
 kernel/signal.c                        |    6 -
 kernel/sys.c                           |    4 
 kernel/tsacct.c                        |    4 
 21 files changed, 318 insertions(+), 406 deletions(-)

--- a/arch/ia64/include/asm/cputime.h
+++ b/arch/ia64/include/asm/cputime.h
@@ -26,59 +26,54 @@
 #include <linux/jiffies.h>
 #include <asm/processor.h>
 
-typedef u64 cputime_t;
-typedef u64 cputime64_t;
+typedef u64 __nocast cputime_t;
+typedef u64 __nocast cputime64_t;
 
-#define cputime_zero			((cputime_t)0)
+#define cputime_zero			((__force cputime_t) 0ULL)
 #define cputime_one_jiffy		jiffies_to_cputime(1)
-#define cputime_max			((~((cputime_t)0) >> 1) - 1)
-#define cputime_add(__a, __b)		((__a) +  (__b))
-#define cputime_sub(__a, __b)		((__a) -  (__b))
-#define cputime_div(__a, __n)		((__a) /  (__n))
-#define cputime_halve(__a)		((__a) >> 1)
-#define cputime_eq(__a, __b)		((__a) == (__b))
-#define cputime_gt(__a, __b)		((__a) >  (__b))
-#define cputime_ge(__a, __b)		((__a) >= (__b))
-#define cputime_lt(__a, __b)		((__a) <  (__b))
-#define cputime_le(__a, __b)		((__a) <= (__b))
-
-#define cputime64_zero			((cputime64_t)0)
-#define cputime64_add(__a, __b)		((__a) + (__b))
-#define cputime64_sub(__a, __b)		((__a) - (__b))
-#define cputime_to_cputime64(__ct)	(__ct)
+
+#define cputime64_zero			((__force cputime64_t) 0ULL)
 
 /*
  * Convert cputime <-> jiffies (HZ)
  */
-#define cputime_to_jiffies(__ct)	((__ct) / (NSEC_PER_SEC / HZ))
-#define jiffies_to_cputime(__jif)	((__jif) * (NSEC_PER_SEC / HZ))
-#define cputime64_to_jiffies64(__ct)	((__ct) / (NSEC_PER_SEC / HZ))
-#define jiffies64_to_cputime64(__jif)	((__jif) * (NSEC_PER_SEC / HZ))
+#define cputime_to_jiffies(__ct)	\
+	((__force u64)(__ct) / (NSEC_PER_SEC / HZ))
+#define jiffies_to_cputime(__jif)	\
+	(__force cputime_t)((__jif) * (NSEC_PER_SEC / HZ))
+#define cputime64_to_jiffies64(__ct)	\
+	((__force u64)(__ct) / (NSEC_PER_SEC / HZ))
+#define jiffies64_to_cputime64(__jif)	\
+	(__force cputime64_t)((__jif) * (NSEC_PER_SEC / HZ))
 
 /*
  * Convert cputime <-> microseconds
  */
-#define cputime_to_usecs(__ct)		((__ct) / NSEC_PER_USEC)
-#define usecs_to_cputime(__usecs)	((__usecs) * NSEC_PER_USEC)
+#define cputime_to_usecs(__ct)		\
+	((__force u64)(__ct) / NSEC_PER_USEC)
+#define usecs_to_cputime(__usecs)	\
+	(__force cputime_t)((__usecs) * NSEC_PER_USEC)
 
 /*
  * Convert cputime <-> seconds
  */
-#define cputime_to_secs(__ct)		((__ct) / NSEC_PER_SEC)
-#define secs_to_cputime(__secs)		((__secs) * NSEC_PER_SEC)
+#define cputime_to_secs(__ct)		\
+	((__force u64)(__ct) / NSEC_PER_SEC)
+#define secs_to_cputime(__secs)		\
+	(__force cputime_t)((__secs) * NSEC_PER_SEC)
 
 /*
  * Convert cputime <-> timespec (nsec)
  */
 static inline cputime_t timespec_to_cputime(const struct timespec *val)
 {
-	cputime_t ret = val->tv_sec * NSEC_PER_SEC;
-	return (ret + val->tv_nsec);
+	u64 ret = val->tv_sec * NSEC_PER_SEC + val->tv_nsec;
+	return (__force cputime_t) ret;
 }
 static inline void cputime_to_timespec(const cputime_t ct, struct timespec *val)
 {
-	val->tv_sec  = ct / NSEC_PER_SEC;
-	val->tv_nsec = ct % NSEC_PER_SEC;
+	val->tv_sec  = (__force u64) ct / NSEC_PER_SEC;
+	val->tv_nsec = (__force u64) ct % NSEC_PER_SEC;
 }
 
 /*
@@ -86,25 +81,28 @@ static inline void cputime_to_timespec(c
  */
 static inline cputime_t timeval_to_cputime(struct timeval *val)
 {
-	cputime_t ret = val->tv_sec * NSEC_PER_SEC;
-	return (ret + val->tv_usec * NSEC_PER_USEC);
+	u64 ret = val->tv_sec * NSEC_PER_SEC + val->tv_usec * NSEC_PER_USEC;
+	return (__force cputime_t) ret;
 }
 static inline void cputime_to_timeval(const cputime_t ct, struct timeval *val)
 {
-	val->tv_sec = ct / NSEC_PER_SEC;
-	val->tv_usec = (ct % NSEC_PER_SEC) / NSEC_PER_USEC;
+	val->tv_sec = (__force u64) ct / NSEC_PER_SEC;
+	val->tv_usec = ((__force u64) ct % NSEC_PER_SEC) / NSEC_PER_USEC;
 }
 
 /*
  * Convert cputime <-> clock (USER_HZ)
  */
-#define cputime_to_clock_t(__ct)	((__ct) / (NSEC_PER_SEC / USER_HZ))
-#define clock_t_to_cputime(__x)		((__x) * (NSEC_PER_SEC / USER_HZ))
+#define cputime_to_clock_t(__ct)	\
+	((__force u64)(__ct) / (NSEC_PER_SEC / USER_HZ))
+#define clock_t_to_cputime(__x)		\
+	(__force cputime_t)((__x) * (NSEC_PER_SEC / USER_HZ))
 
 /*
  * Convert cputime64 to clock.
  */
-#define cputime64_to_clock_t(__ct)      cputime_to_clock_t((cputime_t)__ct)
+#define cputime64_to_clock_t(__ct)      \
+	cputime_to_clock_t((__force cputime_t)__ct)
 
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING */
 #endif /* __IA64_CPUTIME_H */
--- a/arch/powerpc/include/asm/cputime.h
+++ b/arch/powerpc/include/asm/cputime.h
@@ -29,25 +29,11 @@ static inline void setup_cputime_one_jif
 #include <asm/time.h>
 #include <asm/param.h>
 
-typedef u64 cputime_t;
-typedef u64 cputime64_t;
+typedef u64 __nocast cputime_t;
+typedef u64 __nocast cputime64_t;
 
-#define cputime_zero			((cputime_t)0)
-#define cputime_max			((~((cputime_t)0) >> 1) - 1)
-#define cputime_add(__a, __b)		((__a) +  (__b))
-#define cputime_sub(__a, __b)		((__a) -  (__b))
-#define cputime_div(__a, __n)		((__a) /  (__n))
-#define cputime_halve(__a)		((__a) >> 1)
-#define cputime_eq(__a, __b)		((__a) == (__b))
-#define cputime_gt(__a, __b)		((__a) >  (__b))
-#define cputime_ge(__a, __b)		((__a) >= (__b))
-#define cputime_lt(__a, __b)		((__a) <  (__b))
-#define cputime_le(__a, __b)		((__a) <= (__b))
-
-#define cputime64_zero			((cputime64_t)0)
-#define cputime64_add(__a, __b)		((__a) + (__b))
-#define cputime64_sub(__a, __b)		((__a) - (__b))
-#define cputime_to_cputime64(__ct)	(__ct)
+#define cputime_zero			((__force cputime_t) 0ULL)
+#define cputime64_zero			((__force cputime64_t) 0ULL)
 
 #ifdef __KERNEL__
 
@@ -65,7 +51,7 @@ DECLARE_PER_CPU(unsigned long, cputime_s
 
 static inline unsigned long cputime_to_jiffies(const cputime_t ct)
 {
-	return mulhdu(ct, __cputime_jiffies_factor);
+	return mulhdu((__force u64) ct, __cputime_jiffies_factor);
 }
 
 /* Estimate the scaled cputime by scaling the real cputime based on
@@ -74,14 +60,15 @@ static inline cputime_t cputime_to_scale
 {
 	if (cpu_has_feature(CPU_FTR_SPURR) &&
 	    __get_cpu_var(cputime_last_delta))
-		return ct * __get_cpu_var(cputime_scaled_last_delta) /
-			    __get_cpu_var(cputime_last_delta);
+		return (__force u64) ct *
+			__get_cpu_var(cputime_scaled_last_delta) /
+			__get_cpu_var(cputime_last_delta);
 	return ct;
 }
 
 static inline cputime_t jiffies_to_cputime(const unsigned long jif)
 {
-	cputime_t ct;
+	u64 ct;
 	unsigned long sec;
 
 	/* have to be a little careful about overflow */
@@ -93,7 +80,7 @@ static inline cputime_t jiffies_to_cputi
 	}
 	if (sec)
 		ct += (cputime_t) sec * tb_ticks_per_sec;
-	return ct;
+	return (__force cputime_t) ct;
 }
 
 static inline void setup_cputime_one_jiffy(void)
@@ -103,7 +90,7 @@ static inline void setup_cputime_one_jif
 
 static inline cputime64_t jiffies64_to_cputime64(const u64 jif)
 {
-	cputime_t ct;
+	u64 ct;
 	u64 sec;
 
 	/* have to be a little careful about overflow */
@@ -114,13 +101,13 @@ static inline cputime64_t jiffies64_to_c
 		do_div(ct, HZ);
 	}
 	if (sec)
-		ct += (cputime_t) sec * tb_ticks_per_sec;
-	return ct;
+		ct += (u64) sec * tb_ticks_per_sec;
+	return (__force cputime64_t) ct;
 }
 
 static inline u64 cputime64_to_jiffies64(const cputime_t ct)
 {
-	return mulhdu(ct, __cputime_jiffies_factor);
+	return mulhdu((__force u64) ct, __cputime_jiffies_factor);
 }
 
 /*
@@ -130,12 +117,12 @@ extern u64 __cputime_msec_factor;
 
 static inline unsigned long cputime_to_usecs(const cputime_t ct)
 {
-	return mulhdu(ct, __cputime_msec_factor) * USEC_PER_MSEC;
+	return mulhdu((__force u64) ct, __cputime_msec_factor) * USEC_PER_MSEC;
 }
 
 static inline cputime_t usecs_to_cputime(const unsigned long us)
 {
-	cputime_t ct;
+	u64 ct;
 	unsigned long sec;
 
 	/* have to be a little careful about overflow */
@@ -147,7 +134,7 @@ static inline cputime_t usecs_to_cputime
 	}
 	if (sec)
 		ct += (cputime_t) sec * tb_ticks_per_sec;
-	return ct;
+	return (__force cputime_t) ct;
 }
 
 /*
@@ -157,12 +144,12 @@ extern u64 __cputime_sec_factor;
 
 static inline unsigned long cputime_to_secs(const cputime_t ct)
 {
-	return mulhdu(ct, __cputime_sec_factor);
+	return mulhdu((__force u64) ct, __cputime_sec_factor);
 }
 
 static inline cputime_t secs_to_cputime(const unsigned long sec)
 {
-	return (cputime_t) sec * tb_ticks_per_sec;
+	return (__force cputime_t)((u64) sec * tb_ticks_per_sec);
 }
 
 /*
@@ -170,7 +157,7 @@ static inline cputime_t secs_to_cputime(
  */
 static inline void cputime_to_timespec(const cputime_t ct, struct timespec *p)
 {
-	u64 x = ct;
+	u64 x = (__force u64) ct;
 	unsigned int frac;
 
 	frac = do_div(x, tb_ticks_per_sec);
@@ -182,11 +169,11 @@ static inline void cputime_to_timespec(c
 
 static inline cputime_t timespec_to_cputime(const struct timespec *p)
 {
-	cputime_t ct;
+	u64 ct;
 
 	ct = (u64) p->tv_nsec * tb_ticks_per_sec;
 	do_div(ct, 1000000000);
-	return ct + (u64) p->tv_sec * tb_ticks_per_sec;
+	return (__force cputime_t)(ct + (u64) p->tv_sec * tb_ticks_per_sec);
 }
 
 /*
@@ -194,7 +181,7 @@ static inline cputime_t timespec_to_cput
  */
 static inline void cputime_to_timeval(const cputime_t ct, struct timeval *p)
 {
-	u64 x = ct;
+	u64 x = (__force u64) ct;
 	unsigned int frac;
 
 	frac = do_div(x, tb_ticks_per_sec);
@@ -206,11 +193,11 @@ static inline void cputime_to_timeval(co
 
 static inline cputime_t timeval_to_cputime(const struct timeval *p)
 {
-	cputime_t ct;
+	u64 ct;
 
 	ct = (u64) p->tv_usec * tb_ticks_per_sec;
 	do_div(ct, 1000000);
-	return ct + (u64) p->tv_sec * tb_ticks_per_sec;
+	return (__force cputime_t)(ct + (u64) p->tv_sec * tb_ticks_per_sec);
 }
 
 /*
@@ -220,12 +207,12 @@ extern u64 __cputime_clockt_factor;
 
 static inline unsigned long cputime_to_clock_t(const cputime_t ct)
 {
-	return mulhdu(ct, __cputime_clockt_factor);
+	return mulhdu((__force u64) ct, __cputime_clockt_factor);
 }
 
 static inline cputime_t clock_t_to_cputime(const unsigned long clk)
 {
-	cputime_t ct;
+	u64 ct;
 	unsigned long sec;
 
 	/* have to be a little careful about overflow */
@@ -236,8 +223,8 @@ static inline cputime_t clock_t_to_cputi
 		do_div(ct, USER_HZ);
 	}
 	if (sec)
-		ct += (cputime_t) sec * tb_ticks_per_sec;
-	return ct;
+		ct += (u64) sec * tb_ticks_per_sec;
+	return (__force cputime_t) ct;
 }
 
 #define cputime64_to_clock_t(ct)	cputime_to_clock_t((cputime_t)(ct))
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@ -16,114 +16,101 @@
 
 /* We want to use full resolution of the CPU timer: 2**-12 micro-seconds. */
 
-typedef unsigned long long cputime_t;
-typedef unsigned long long cputime64_t;
+typedef unsigned long long __nocast cputime_t;
+typedef unsigned long long __nocast cputime64_t;
 
-#ifndef __s390x__
-
-static inline unsigned int
-__div(unsigned long long n, unsigned int base)
+static inline unsigned long __div(unsigned long long n, unsigned long base)
 {
+#ifndef __s390x__
 	register_pair rp;
 
 	rp.pair = n >> 1;
 	asm ("dr %0,%1" : "+d" (rp) : "d" (base >> 1));
 	return rp.subreg.odd;
+#else /* __s390x__ */
+	return n / base;
+#endif /* __s390x__ */
 }
 
-#else /* __s390x__ */
+#define cputime_zero			((__force cputime_t) 0ULL)
+#define cputime_one_jiffy		jiffies_to_cputime(1)
+
+#define cputime64_zero			((__force cputime64_t) 0ULL)
 
-static inline unsigned int
-__div(unsigned long long n, unsigned int base)
+/*
+ * Convert cputime to jiffies and back.
+ */
+static inline unsigned long cputime_to_jiffies(const cputime_t cputime)
 {
-	return n / base;
+	return __div((__force unsigned long long) cputime, 4096000000ULL / HZ);
 }
 
-#endif /* __s390x__ */
+static inline cputime_t jiffies_to_cputime(const unsigned int jif)
+{
+	return (__force cputime_t)(jif * (4096000000ULL / HZ));
+}
 
-#define cputime_zero			(0ULL)
-#define cputime_one_jiffy		jiffies_to_cputime(1)
-#define cputime_max			((~0UL >> 1) - 1)
-#define cputime_add(__a, __b)		((__a) +  (__b))
-#define cputime_sub(__a, __b)		((__a) -  (__b))
-#define cputime_div(__a, __n) ({		\
-	unsigned long long __div = (__a);	\
-	do_div(__div,__n);			\
-	__div;					\
-})
-#define cputime_halve(__a)		((__a) >> 1)
-#define cputime_eq(__a, __b)		((__a) == (__b))
-#define cputime_gt(__a, __b)		((__a) >  (__b))
-#define cputime_ge(__a, __b)		((__a) >= (__b))
-#define cputime_lt(__a, __b)		((__a) <  (__b))
-#define cputime_le(__a, __b)		((__a) <= (__b))
-#define cputime_to_jiffies(__ct)	(__div((__ct), 4096000000ULL / HZ))
-#define cputime_to_scaled(__ct)		(__ct)
-#define jiffies_to_cputime(__hz)	((cputime_t)(__hz) * (4096000000ULL / HZ))
-
-#define cputime64_zero			(0ULL)
-#define cputime64_add(__a, __b)		((__a) + (__b))
-#define cputime_to_cputime64(__ct)	(__ct)
+static inline u64 cputime64_to_jiffies64(cputime64_t cputime)
+{
+	unsigned long long jif = (__force unsigned long long) cputime;
+	do_div(jif, 4096000000ULL / HZ);
+	return jif;
+}
 
-static inline u64
-cputime64_to_jiffies64(cputime64_t cputime)
+static inline cputime64_t jiffies64_to_cputime64(const u64 jif)
 {
-	do_div(cputime, 4096000000ULL / HZ);
-	return cputime;
+	return (__force cputime64_t)(jif * (4096000000ULL / HZ));
 }
 
 /*
  * Convert cputime to microseconds and back.
  */
-static inline unsigned int
-cputime_to_usecs(const cputime_t cputime)
+static inline unsigned int cputime_to_usecs(const cputime_t cputime)
 {
-	return cputime_div(cputime, 4096);
+	return (__force unsigned long long) cputime >> 12;
 }
 
-static inline cputime_t
-usecs_to_cputime(const unsigned int m)
+static inline cputime_t usecs_to_cputime(const unsigned int m)
 {
-	return (cputime_t) m * 4096;
+	return (__force cputime_t)(m * 4096ULL);
 }
 
 /*
  * Convert cputime to milliseconds and back.
  */
-static inline unsigned int
-cputime_to_secs(const cputime_t cputime)
+static inline unsigned int cputime_to_secs(const cputime_t cputime)
 {
-	return __div(cputime, 2048000000) >> 1;
+	return __div((__force unsigned long long) cputime, 2048000000) >> 1;
 }
 
-static inline cputime_t
-secs_to_cputime(const unsigned int s)
+static inline cputime_t secs_to_cputime(const unsigned int s)
 {
-	return (cputime_t) s * 4096000000ULL;
+	return (__force cputime_t)(s * 4096000000ULL);
 }
 
 /*
  * Convert cputime to timespec and back.
  */
-static inline cputime_t
-timespec_to_cputime(const struct timespec *value)
+static inline cputime_t timespec_to_cputime(const struct timespec *value)
 {
-	return value->tv_nsec * 4096 / 1000 + (u64) value->tv_sec * 4096000000ULL;
+	unsigned long long ret = value->tv_sec * 4096000000ULL;
+	return (__force cputime_t)(ret + value->tv_nsec * 4096 / 1000);
 }
 
-static inline void
-cputime_to_timespec(const cputime_t cputime, struct timespec *value)
+static inline void cputime_to_timespec(const cputime_t cputime,
+				       struct timespec *value)
 {
+	unsigned long long __cputime = (__force unsigned long long) cputime;
 #ifndef __s390x__
 	register_pair rp;
 
-	rp.pair = cputime >> 1;
+	rp.pair = __cputime >> 1;
 	asm ("dr %0,%1" : "+d" (rp) : "d" (2048000000UL));
 	value->tv_nsec = rp.subreg.even * 1000 / 4096;
 	value->tv_sec = rp.subreg.odd;
 #else
-	value->tv_nsec = (cputime % 4096000000ULL) * 1000 / 4096;
-	value->tv_sec = cputime / 4096000000ULL;
+	value->tv_nsec = (__cputime % 4096000000ULL) * 1000 / 4096;
+	value->tv_sec = __cputime / 4096000000ULL;
 #endif
 }
 
@@ -132,50 +119,52 @@ cputime_to_timespec(const cputime_t cput
  * Since cputime and timeval have the same resolution (microseconds)
  * this is easy.
  */
-static inline cputime_t
-timeval_to_cputime(const struct timeval *value)
+static inline cputime_t timeval_to_cputime(const struct timeval *value)
 {
-	return value->tv_usec * 4096 + (u64) value->tv_sec * 4096000000ULL;
+	unsigned long long ret = value->tv_sec * 4096000000ULL;
+	return (__force cputime_t)(ret + value->tv_usec * 4096ULL);
 }
 
-static inline void
-cputime_to_timeval(const cputime_t cputime, struct timeval *value)
+static inline void cputime_to_timeval(const cputime_t cputime,
+				      struct timeval *value)
 {
+	unsigned long long __cputime = (__force unsigned long long) cputime;
 #ifndef __s390x__
 	register_pair rp;
 
-	rp.pair = cputime >> 1;
+	rp.pair = __cputime >> 1;
 	asm ("dr %0,%1" : "+d" (rp) : "d" (2048000000UL));
 	value->tv_usec = rp.subreg.even / 4096;
 	value->tv_sec = rp.subreg.odd;
 #else
-	value->tv_usec = (cputime % 4096000000ULL) / 4096;
-	value->tv_sec = cputime / 4096000000ULL;
+	value->tv_usec = (__cputime % 4096000000ULL) / 4096;
+	value->tv_sec = __cputime / 4096000000ULL;
 #endif
 }
 
 /*
  * Convert cputime to clock and back.
  */
-static inline clock_t
-cputime_to_clock_t(cputime_t cputime)
+static inline clock_t cputime_to_clock_t(cputime_t cputime)
 {
-	return cputime_div(cputime, 4096000000ULL / USER_HZ);
+	unsigned long long clock = (__force unsigned long long) cputime;
+	do_div(clock, 4096000000ULL / USER_HZ);
+	return clock;
 }
 
-static inline cputime_t
-clock_t_to_cputime(unsigned long x)
+static inline cputime_t clock_t_to_cputime(unsigned long x)
 {
-	return (cputime_t) x * (4096000000ULL / USER_HZ);
+	return (__force cputime_t)(x * (4096000000ULL / USER_HZ));
 }
 
 /*
  * Convert cputime64 to clock.
  */
-static inline clock_t
-cputime64_to_clock_t(cputime64_t cputime)
+static inline clock_t cputime64_to_clock_t(cputime64_t cputime)
 {
-       return cputime_div(cputime, 4096000000ULL / USER_HZ);
+	unsigned long long clock = (__force unsigned long long) cputime;
+	do_div(clock, 4096000000ULL / USER_HZ);
+	return clock;
 }
 
 struct s390_idle_data {
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -103,15 +103,14 @@ static inline cputime64_t get_cpu_idle_t
 	cputime64_t busy_time;
 
 	cur_wall_time = jiffies64_to_cputime64(get_jiffies_64());
-	busy_time = cputime64_add(kstat_cpu(cpu).cpustat.user,
-			kstat_cpu(cpu).cpustat.system);
+	busy_time  = kstat_cpu(cpu).cpustat.user;
+	busy_time += kstat_cpu(cpu).cpustat.system;
+	busy_time += kstat_cpu(cpu).cpustat.irq;
+	busy_time += kstat_cpu(cpu).cpustat.softirq;
+	busy_time += kstat_cpu(cpu).cpustat.steal;
+	busy_time += kstat_cpu(cpu).cpustat.nice;
 
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.irq);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.softirq);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.steal);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.nice);
-
-	idle_time = cputime64_sub(cur_wall_time, busy_time);
+	idle_time = cur_wall_time - busy_time;
 	if (wall)
 		*wall = (cputime64_t)jiffies_to_usecs(cur_wall_time);
 
@@ -351,20 +350,20 @@ static void dbs_check_cpu(struct cpu_dbs
 
 		cur_idle_time = get_cpu_idle_time(j, &cur_wall_time);
 
-		wall_time = (unsigned int) cputime64_sub(cur_wall_time,
-				j_dbs_info->prev_cpu_wall);
+		wall_time = (unsigned int)
+			cur_wall_time - j_dbs_info->prev_cpu_wall;
 		j_dbs_info->prev_cpu_wall = cur_wall_time;
 
-		idle_time = (unsigned int) cputime64_sub(cur_idle_time,
-				j_dbs_info->prev_cpu_idle);
+		idle_time = (unsigned int)
+			cur_idle_time - j_dbs_info->prev_cpu_idle;
 		j_dbs_info->prev_cpu_idle = cur_idle_time;
 
 		if (dbs_tuners_ins.ignore_nice) {
 			cputime64_t cur_nice;
 			unsigned long cur_nice_jiffies;
 
-			cur_nice = cputime64_sub(kstat_cpu(j).cpustat.nice,
-					 j_dbs_info->prev_cpu_nice);
+			cur_nice = kstat_cpu(j).cpustat.nice -
+					j_dbs_info->prev_cpu_nice;
 			/*
 			 * Assumption: nice time between sampling periods will
 			 * be less than 2^32 jiffies for 32 bit sys
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -127,15 +127,14 @@ static inline cputime64_t get_cpu_idle_t
 	cputime64_t busy_time;
 
 	cur_wall_time = jiffies64_to_cputime64(get_jiffies_64());
-	busy_time = cputime64_add(kstat_cpu(cpu).cpustat.user,
-			kstat_cpu(cpu).cpustat.system);
+	busy_time  = kstat_cpu(cpu).cpustat.user;
+	busy_time += kstat_cpu(cpu).cpustat.system;
+	busy_time += kstat_cpu(cpu).cpustat.irq;
+	busy_time += kstat_cpu(cpu).cpustat.softirq;
+	busy_time += kstat_cpu(cpu).cpustat.steal;
+	busy_time += kstat_cpu(cpu).cpustat.nice;
 
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.irq);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.softirq);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.steal);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.nice);
-
-	idle_time = cputime64_sub(cur_wall_time, busy_time);
+	idle_time = cur_wall_time - busy_time;
 	if (wall)
 		*wall = (cputime64_t)jiffies_to_usecs(cur_wall_time);
 
@@ -440,24 +439,24 @@ static void dbs_check_cpu(struct cpu_dbs
 		cur_idle_time = get_cpu_idle_time(j, &cur_wall_time);
 		cur_iowait_time = get_cpu_iowait_time(j, &cur_wall_time);
 
-		wall_time = (unsigned int) cputime64_sub(cur_wall_time,
-				j_dbs_info->prev_cpu_wall);
+		wall_time = (unsigned int)
+			cur_wall_time - j_dbs_info->prev_cpu_wall;
 		j_dbs_info->prev_cpu_wall = cur_wall_time;
 
-		idle_time = (unsigned int) cputime64_sub(cur_idle_time,
-				j_dbs_info->prev_cpu_idle);
+		idle_time = (unsigned int)
+			cur_idle_time - j_dbs_info->prev_cpu_idle;
 		j_dbs_info->prev_cpu_idle = cur_idle_time;
 
-		iowait_time = (unsigned int) cputime64_sub(cur_iowait_time,
-				j_dbs_info->prev_cpu_iowait);
+		iowait_time = (unsigned int)
+			cur_iowait_time - j_dbs_info->prev_cpu_iowait;
 		j_dbs_info->prev_cpu_iowait = cur_iowait_time;
 
 		if (dbs_tuners_ins.ignore_nice) {
 			cputime64_t cur_nice;
 			unsigned long cur_nice_jiffies;
 
-			cur_nice = cputime64_sub(kstat_cpu(j).cpustat.nice,
-					 j_dbs_info->prev_cpu_nice);
+			cur_nice = kstat_cpu(j).cpustat.nice -
+					j_dbs_info->prev_cpu_nice;
 			/*
 			 * Assumption: nice time between sampling periods will
 			 * be less than 2^32 jiffies for 32 bit sys
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -60,9 +60,8 @@ static int cpufreq_stats_update(unsigned
 	spin_lock(&cpufreq_stats_lock);
 	stat = per_cpu(cpufreq_stats_table, cpu);
 	if (stat->time_in_state)
-		stat->time_in_state[stat->last_index] =
-			cputime64_add(stat->time_in_state[stat->last_index],
-				      cputime_sub(cur_time, stat->last_time));
+		stat->time_in_state[stat->last_index] +=
+			cur_time - stat->last_time;
 	stat->last_time = cur_time;
 	spin_unlock(&cpufreq_stats_lock);
 	return 0;
--- a/drivers/macintosh/rack-meter.c
+++ b/drivers/macintosh/rack-meter.c
@@ -83,11 +83,10 @@ static inline cputime64_t get_cpu_idle_t
 {
 	cputime64_t retval;
 
-	retval = cputime64_add(kstat_cpu(cpu).cpustat.idle,
-			kstat_cpu(cpu).cpustat.iowait);
+	retval = kstat_cpu(cpu).cpustat.idle + kstat_cpu(cpu).cpustat.iowait;
 
 	if (rackmeter_ignore_nice)
-		retval = cputime64_add(retval, kstat_cpu(cpu).cpustat.nice);
+		retval = retval + kstat_cpu(cpu).cpustat.nice;
 
 	return retval;
 }
@@ -220,13 +219,11 @@ static void rackmeter_do_timer(struct wo
 	int i, offset, load, cumm, pause;
 
 	cur_jiffies = jiffies64_to_cputime64(get_jiffies_64());
-	total_ticks = (unsigned int)cputime64_sub(cur_jiffies,
-						  rcpu->prev_wall);
+	total_ticks = (unsigned int) (cur_jiffies - rcpu->prev_wall);
 	rcpu->prev_wall = cur_jiffies;
 
 	total_idle_ticks = get_cpu_idle_time(cpu);
-	idle_ticks = (unsigned int) cputime64_sub(total_idle_ticks,
-				rcpu->prev_idle);
+	idle_ticks = (unsigned int) (total_idle_ticks - rcpu->prev_idle);
 	rcpu->prev_idle = total_idle_ticks;
 
 	/* We do a very dumb calculation to update the LEDs for now,
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -423,14 +423,14 @@ static int do_task_stat(struct seq_file
 			do {
 				min_flt += t->min_flt;
 				maj_flt += t->maj_flt;
-				gtime = cputime_add(gtime, t->gtime);
+				gtime += t->gtime;
 				t = next_thread(t);
 			} while (t != task);
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
 			thread_group_times(task, &utime, &stime);
-			gtime = cputime_add(gtime, sig->gtime);
+			gtime += sig->gtime;
 		}
 
 		sid = task_session_nr_ns(task, ns);
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -39,18 +39,16 @@ static int show_stat(struct seq_file *p,
 	jif = boottime.tv_sec;
 
 	for_each_possible_cpu(i) {
-		user = cputime64_add(user, kstat_cpu(i).cpustat.user);
-		nice = cputime64_add(nice, kstat_cpu(i).cpustat.nice);
-		system = cputime64_add(system, kstat_cpu(i).cpustat.system);
-		idle = cputime64_add(idle, kstat_cpu(i).cpustat.idle);
-		idle = cputime64_add(idle, arch_idle_time(i));
-		iowait = cputime64_add(iowait, kstat_cpu(i).cpustat.iowait);
-		irq = cputime64_add(irq, kstat_cpu(i).cpustat.irq);
-		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
-		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
-		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
-		guest_nice = cputime64_add(guest_nice,
-			kstat_cpu(i).cpustat.guest_nice);
+		user += kstat_cpu(i).cpustat.user;
+		nice += kstat_cpu(i).cpustat.nice;
+		system += kstat_cpu(i).cpustat.system;
+		idle += kstat_cpu(i).cpustat.idle + arch_idle_time(i);
+		iowait += kstat_cpu(i).cpustat.iowait;
+		irq += kstat_cpu(i).cpustat.irq;
+		softirq += kstat_cpu(i).cpustat.softirq;
+		steal += kstat_cpu(i).cpustat.steal;
+		guest += kstat_cpu(i).cpustat.guest;
+		guest_nice += kstat_cpu(i).cpustat.guest_nice;
 		sum += kstat_cpu_irqs_sum(i);
 		sum += arch_irq_stat_cpu(i);
 
@@ -81,8 +79,7 @@ static int show_stat(struct seq_file *p,
 		user = kstat_cpu(i).cpustat.user;
 		nice = kstat_cpu(i).cpustat.nice;
 		system = kstat_cpu(i).cpustat.system;
-		idle = kstat_cpu(i).cpustat.idle;
-		idle = cputime64_add(idle, arch_idle_time(i));
+		idle = kstat_cpu(i).cpustat.idle + arch_idle_time(i);
 		iowait = kstat_cpu(i).cpustat.iowait;
 		irq = kstat_cpu(i).cpustat.irq;
 		softirq = kstat_cpu(i).cpustat.softirq;
--- a/fs/proc/uptime.c
+++ b/fs/proc/uptime.c
@@ -15,7 +15,7 @@ static int uptime_proc_show(struct seq_f
 	cputime_t idletime = cputime_zero;
 
 	for_each_possible_cpu(i)
-		idletime = cputime64_add(idletime, kstat_cpu(i).cpustat.idle);
+		idletime += kstat_cpu(i).cpustat.idle;
 
 	do_posix_clock_monotonic_gettime(&uptime);
 	monotonic_to_bootbased(&uptime);
--- a/include/asm-generic/cputime.h
+++ b/include/asm-generic/cputime.h
@@ -4,70 +4,66 @@
 #include <linux/time.h>
 #include <linux/jiffies.h>
 
-typedef unsigned long cputime_t;
+typedef unsigned long __nocast cputime_t;
 
-#define cputime_zero			(0UL)
+#define cputime_zero			((__force cputime_t) 0UL)
 #define cputime_one_jiffy		jiffies_to_cputime(1)
-#define cputime_max			((~0UL >> 1) - 1)
-#define cputime_add(__a, __b)		((__a) +  (__b))
-#define cputime_sub(__a, __b)		((__a) -  (__b))
-#define cputime_div(__a, __n)		((__a) /  (__n))
-#define cputime_halve(__a)		((__a) >> 1)
-#define cputime_eq(__a, __b)		((__a) == (__b))
-#define cputime_gt(__a, __b)		((__a) >  (__b))
-#define cputime_ge(__a, __b)		((__a) >= (__b))
-#define cputime_lt(__a, __b)		((__a) <  (__b))
-#define cputime_le(__a, __b)		((__a) <= (__b))
-#define cputime_to_jiffies(__ct)	(__ct)
+#define cputime_to_jiffies(__ct)	(__force unsigned long)(__ct)
 #define cputime_to_scaled(__ct)		(__ct)
-#define jiffies_to_cputime(__hz)	(__hz)
+#define jiffies_to_cputime(__hz)	(__force cputime_t)(__hz)
 
-typedef u64 cputime64_t;
+typedef u64 __nocast cputime64_t;
 
-#define cputime64_zero (0ULL)
-#define cputime64_add(__a, __b)		((__a) + (__b))
-#define cputime64_sub(__a, __b)		((__a) - (__b))
-#define cputime64_to_jiffies64(__ct)	(__ct)
-#define jiffies64_to_cputime64(__jif)	(__jif)
-#define cputime_to_cputime64(__ct)	((u64) __ct)
-#define cputime64_gt(__a, __b)		((__a) >  (__b))
+#define cputime64_zero			((__force cputime64_t) 0ULL)
+#define cputime64_to_jiffies64(__ct)	(__force u64)(__ct)
+#define jiffies64_to_cputime64(__jif)	(__force cputime64_t)(__jif)
 
-#define nsecs_to_cputime64(__ct)	nsecs_to_jiffies64(__ct)
+#define nsecs_to_cputime64(__ct)	\
+	jiffies64_to_cputime64(nsecs_to_jiffies64(__ct))
 
 
 /*
  * Convert cputime to microseconds and back.
  */
-#define cputime_to_usecs(__ct)		jiffies_to_usecs(__ct);
-#define usecs_to_cputime(__msecs)	usecs_to_jiffies(__msecs);
+#define cputime_to_usecs(__ct)		\
+	jiffies_to_usecs(cputime_to_jiffies(__ct));
+#define usecs_to_cputime(__msecs)	\
+	jiffies_to_cputime(usecs_to_jiffies(__msecs));
 
 /*
  * Convert cputime to seconds and back.
  */
-#define cputime_to_secs(jif)		((jif) / HZ)
-#define secs_to_cputime(sec)		((sec) * HZ)
+#define cputime_to_secs(jif)		(cputime_to_jiffies(jif) / HZ)
+#define secs_to_cputime(sec)		jiffies_to_cputime((sec) * HZ)
 
 /*
  * Convert cputime to timespec and back.
  */
-#define timespec_to_cputime(__val)	timespec_to_jiffies(__val)
-#define cputime_to_timespec(__ct,__val)	jiffies_to_timespec(__ct,__val)
+#define timespec_to_cputime(__val)	\
+	jiffies_to_cputime(timespec_to_jiffies(__val))
+#define cputime_to_timespec(__ct,__val)	\
+	jiffies_to_timespec(cputime_to_jiffies(__ct),__val)
 
 /*
  * Convert cputime to timeval and back.
  */
-#define timeval_to_cputime(__val)	timeval_to_jiffies(__val)
-#define cputime_to_timeval(__ct,__val)	jiffies_to_timeval(__ct,__val)
+#define timeval_to_cputime(__val)	\
+	jiffies_to_cputime(timeval_to_jiffies(__val))
+#define cputime_to_timeval(__ct,__val)	\
+	jiffies_to_timeval(cputime_to_jiffies(__ct),__val)
 
 /*
  * Convert cputime to clock and back.
  */
-#define cputime_to_clock_t(__ct)	jiffies_to_clock_t(__ct)
-#define clock_t_to_cputime(__x)		clock_t_to_jiffies(__x)
+#define cputime_to_clock_t(__ct)	\
+	jiffies_to_clock_t(cputime_to_jiffies(__ct))
+#define clock_t_to_cputime(__x)		\
+	jiffies_to_cputime(clock_t_to_jiffies(__x))
 
 /*
  * Convert cputime64 to clock.
  */
-#define cputime64_to_clock_t(__ct)	jiffies_64_to_clock_t(__ct)
+#define cputime64_to_clock_t(__ct)	\
+	jiffies_64_to_clock_t(cputime64_to_jiffies64(__ct))
 
 #endif
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -613,8 +613,8 @@ void acct_collect(long exitcode, int gro
 		pacct->ac_flag |= ACORE;
 	if (current->flags & PF_SIGNALED)
 		pacct->ac_flag |= AXSIG;
-	pacct->ac_utime = cputime_add(pacct->ac_utime, current->utime);
-	pacct->ac_stime = cputime_add(pacct->ac_stime, current->stime);
+	pacct->ac_utime += current->utime;
+	pacct->ac_stime += current->stime;
 	pacct->ac_minflt += current->min_flt;
 	pacct->ac_majflt += current->maj_flt;
 	spin_unlock_irq(&current->sighand->siglock);
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -177,8 +177,7 @@ static inline void check_for_tasks(int c
 	write_lock_irq(&tasklist_lock);
 	for_each_process(p) {
 		if (task_cpu(p) == cpu && p->state == TASK_RUNNING &&
-		    (!cputime_eq(p->utime, cputime_zero) ||
-		     !cputime_eq(p->stime, cputime_zero)))
+		    (p->utime != cputime_zero || p->stime != cputime_zero))
 			printk(KERN_WARNING "Task %s (pid = %d) is on cpu %d "
 				"(state = %ld, flags = %x)\n",
 				p->comm, task_pid_nr(p), cpu,
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -121,9 +121,9 @@ static void __exit_signal(struct task_st
 		 * We won't ever get here for the group leader, since it
 		 * will have been the last reference on the signal_struct.
 		 */
-		sig->utime = cputime_add(sig->utime, tsk->utime);
-		sig->stime = cputime_add(sig->stime, tsk->stime);
-		sig->gtime = cputime_add(sig->gtime, tsk->gtime);
+		sig->utime += tsk->utime;
+		sig->stime += tsk->stime;
+		sig->gtime += tsk->gtime;
 		sig->min_flt += tsk->min_flt;
 		sig->maj_flt += tsk->maj_flt;
 		sig->nvcsw += tsk->nvcsw;
@@ -1257,19 +1257,9 @@ static int wait_task_zombie(struct wait_
 		spin_lock_irq(&p->real_parent->sighand->siglock);
 		psig = p->real_parent->signal;
 		sig = p->signal;
-		psig->cutime =
-			cputime_add(psig->cutime,
-			cputime_add(tgutime,
-				    sig->cutime));
-		psig->cstime =
-			cputime_add(psig->cstime,
-			cputime_add(tgstime,
-				    sig->cstime));
-		psig->cgtime =
-			cputime_add(psig->cgtime,
-			cputime_add(p->gtime,
-			cputime_add(sig->gtime,
-				    sig->cgtime)));
+		psig->cutime += tgutime + sig->cutime;
+		psig->cstime += tgstime + sig->cstime;
+		psig->cgtime += p->gtime + sig->gtime + sig->cgtime;
 		psig->cmin_flt +=
 			p->min_flt + sig->min_flt + sig->cmin_flt;
 		psig->cmaj_flt +=
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -52,22 +52,22 @@ static void get_cpu_itimer(struct task_s
 
 	cval = it->expires;
 	cinterval = it->incr;
-	if (!cputime_eq(cval, cputime_zero)) {
+	if (cval != cputime_zero) {
 		struct task_cputime cputime;
 		cputime_t t;
 
 		thread_group_cputimer(tsk, &cputime);
 		if (clock_id == CPUCLOCK_PROF)
-			t = cputime_add(cputime.utime, cputime.stime);
+			t = cputime.utime + cputime.stime;
 		else
 			/* CPUCLOCK_VIRT */
 			t = cputime.utime;
 
-		if (cputime_le(cval, t))
+		if (cval < t)
 			/* about to fire */
 			cval = cputime_one_jiffy;
 		else
-			cval = cputime_sub(cval, t);
+			cval = cval - t;
 	}
 
 	spin_unlock_irq(&tsk->sighand->siglock);
@@ -123,7 +123,7 @@ enum hrtimer_restart it_real_fn(struct h
 	struct signal_struct *sig =
 		container_of(timer, struct signal_struct, real_timer);
 
-	trace_itimer_expire(ITIMER_REAL, sig->leader_pid, 0);
+	trace_itimer_expire(ITIMER_REAL, sig->leader_pid, cputime_zero);
 	kill_pid_info(SIGALRM, SEND_SIG_PRIV, sig->leader_pid);
 
 	return HRTIMER_NORESTART;
@@ -161,10 +161,9 @@ static void set_cpu_itimer(struct task_s
 
 	cval = it->expires;
 	cinterval = it->incr;
-	if (!cputime_eq(cval, cputime_zero) ||
-	    !cputime_eq(nval, cputime_zero)) {
-		if (cputime_gt(nval, cputime_zero))
-			nval = cputime_add(nval, cputime_one_jiffy);
+	if (cval != cputime_zero || nval != cputime_zero) {
+		if (nval > cputime_zero)
+			nval += cputime_one_jiffy;
 		set_process_cpu_timer(tsk, clock_id, &nval, &cval);
 	}
 	it->expires = nval;
@@ -224,7 +223,7 @@ again:
 		} else
 			tsk->signal->it_real_incr.tv64 = 0;
 
-		trace_itimer_state(ITIMER_REAL, value, 0);
+		trace_itimer_state(ITIMER_REAL, value, cputime_zero);
 		spin_unlock_irq(&tsk->sighand->siglock);
 		break;
 	case ITIMER_VIRTUAL:
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -78,7 +78,7 @@ static inline int cpu_time_before(const
 	if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED) {
 		return now.sched < then.sched;
 	}  else {
-		return cputime_lt(now.cpu, then.cpu);
+		return now.cpu < then.cpu;
 	}
 }
 static inline void cpu_time_add(const clockid_t which_clock,
@@ -88,7 +88,7 @@ static inline void cpu_time_add(const cl
 	if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED) {
 		acc->sched += val.sched;
 	}  else {
-		acc->cpu = cputime_add(acc->cpu, val.cpu);
+		acc->cpu += val.cpu;
 	}
 }
 static inline union cpu_time_count cpu_time_sub(const clockid_t which_clock,
@@ -98,25 +98,12 @@ static inline union cpu_time_count cpu_t
 	if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED) {
 		a.sched -= b.sched;
 	}  else {
-		a.cpu = cputime_sub(a.cpu, b.cpu);
+		a.cpu -= b.cpu;
 	}
 	return a;
 }
 
 /*
- * Divide and limit the result to res >= 1
- *
- * This is necessary to prevent signal delivery starvation, when the result of
- * the division would be rounded down to 0.
- */
-static inline cputime_t cputime_div_non_zero(cputime_t time, unsigned long div)
-{
-	cputime_t res = cputime_div(time, div);
-
-	return max_t(cputime_t, res, 1);
-}
-
-/*
  * Update expiry time from increment, and increase overrun count,
  * given the current clock sample.
  */
@@ -148,28 +135,26 @@ static void bump_cpu_timer(struct k_itim
 	} else {
 		cputime_t delta, incr;
 
-		if (cputime_lt(now.cpu, timer->it.cpu.expires.cpu))
+		if (now.cpu < timer->it.cpu.expires.cpu)
 			return;
 		incr = timer->it.cpu.incr.cpu;
-		delta = cputime_sub(cputime_add(now.cpu, incr),
-				    timer->it.cpu.expires.cpu);
+		delta = now.cpu + incr - timer->it.cpu.expires.cpu;
 		/* Don't use (incr*2 < delta), incr*2 might overflow. */
-		for (i = 0; cputime_lt(incr, cputime_sub(delta, incr)); i++)
-			     incr = cputime_add(incr, incr);
-		for (; i >= 0; incr = cputime_halve(incr), i--) {
-			if (cputime_lt(delta, incr))
+		for (i = 0; incr < delta - incr; i++)
+			     incr += incr;
+		for (; i >= 0; incr = incr >> 1, i--) {
+			if (delta < incr)
 				continue;
-			timer->it.cpu.expires.cpu =
-				cputime_add(timer->it.cpu.expires.cpu, incr);
+			timer->it.cpu.expires.cpu += incr;
 			timer->it_overrun += 1 << i;
-			delta = cputime_sub(delta, incr);
+			delta -= incr;
 		}
 	}
 }
 
 static inline cputime_t prof_ticks(struct task_struct *p)
 {
-	return cputime_add(p->utime, p->stime);
+	return p->utime + p->stime;
 }
 static inline cputime_t virt_ticks(struct task_struct *p)
 {
@@ -248,8 +233,8 @@ void thread_group_cputime(struct task_st
 
 	t = tsk;
 	do {
-		times->utime = cputime_add(times->utime, t->utime);
-		times->stime = cputime_add(times->stime, t->stime);
+		times->utime += t->utime;
+		times->stime += t->stime;
 		times->sum_exec_runtime += task_sched_runtime(t);
 	} while_each_thread(tsk, t);
 out:
@@ -258,10 +243,10 @@ out:
 
 static void update_gt_cputime(struct task_cputime *a, struct task_cputime *b)
 {
-	if (cputime_gt(b->utime, a->utime))
+	if (b->utime > a->utime)
 		a->utime = b->utime;
 
-	if (cputime_gt(b->stime, a->stime))
+	if (b->stime > a->stime)
 		a->stime = b->stime;
 
 	if (b->sum_exec_runtime > a->sum_exec_runtime)
@@ -306,7 +291,7 @@ static int cpu_clock_sample_group(const
 		return -EINVAL;
 	case CPUCLOCK_PROF:
 		thread_group_cputime(p, &cputime);
-		cpu->cpu = cputime_add(cputime.utime, cputime.stime);
+		cpu->cpu = cputime.utime + cputime.stime;
 		break;
 	case CPUCLOCK_VIRT:
 		thread_group_cputime(p, &cputime);
@@ -470,26 +455,24 @@ static void cleanup_timers(struct list_h
 			   unsigned long long sum_exec_runtime)
 {
 	struct cpu_timer_list *timer, *next;
-	cputime_t ptime = cputime_add(utime, stime);
+	cputime_t ptime = utime + stime;
 
 	list_for_each_entry_safe(timer, next, head, entry) {
 		list_del_init(&timer->entry);
-		if (cputime_lt(timer->expires.cpu, ptime)) {
+		if (timer->expires.cpu < ptime) {
 			timer->expires.cpu = cputime_zero;
 		} else {
-			timer->expires.cpu = cputime_sub(timer->expires.cpu,
-							 ptime);
+			timer->expires.cpu = timer->expires.cpu - ptime;
 		}
 	}
 
 	++head;
 	list_for_each_entry_safe(timer, next, head, entry) {
 		list_del_init(&timer->entry);
-		if (cputime_lt(timer->expires.cpu, utime)) {
+		if (timer->expires.cpu < utime) {
 			timer->expires.cpu = cputime_zero;
 		} else {
-			timer->expires.cpu = cputime_sub(timer->expires.cpu,
-							 utime);
+			timer->expires.cpu = timer->expires.cpu - utime;
 		}
 	}
 
@@ -520,8 +503,7 @@ void posix_cpu_timers_exit_group(struct
 	struct signal_struct *const sig = tsk->signal;
 
 	cleanup_timers(tsk->signal->cpu_timers,
-		       cputime_add(tsk->utime, sig->utime),
-		       cputime_add(tsk->stime, sig->stime),
+		       tsk->utime + sig->utime, tsk->stime + sig->stime,
 		       tsk->se.sum_exec_runtime + sig->sum_sched_runtime);
 }
 
@@ -540,8 +522,7 @@ static void clear_dead_task(struct k_iti
 
 static inline int expires_gt(cputime_t expires, cputime_t new_exp)
 {
-	return cputime_eq(expires, cputime_zero) ||
-	       cputime_gt(expires, new_exp);
+	return expires == cputime_zero || expires > new_exp;
 }
 
 /*
@@ -651,7 +632,7 @@ static int cpu_timer_sample_group(const
 	default:
 		return -EINVAL;
 	case CPUCLOCK_PROF:
-		cpu->cpu = cputime_add(cputime.utime, cputime.stime);
+		cpu->cpu = cputime.utime + cputime.stime;
 		break;
 	case CPUCLOCK_VIRT:
 		cpu->cpu = cputime.utime;
@@ -923,7 +904,7 @@ static void check_thread_timers(struct t
 		struct cpu_timer_list *t = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || cputime_lt(prof_ticks(tsk), t->expires.cpu)) {
+		if (!--maxfire || prof_ticks(tsk) < t->expires.cpu) {
 			tsk->cputime_expires.prof_exp = t->expires.cpu;
 			break;
 		}
@@ -938,7 +919,7 @@ static void check_thread_timers(struct t
 		struct cpu_timer_list *t = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || cputime_lt(virt_ticks(tsk), t->expires.cpu)) {
+		if (!--maxfire || virt_ticks(tsk) < t->expires.cpu) {
 			tsk->cputime_expires.virt_exp = t->expires.cpu;
 			break;
 		}
@@ -1009,16 +990,15 @@ static u32 onecputick;
 static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
 			     cputime_t *expires, cputime_t cur_time, int signo)
 {
-	if (cputime_eq(it->expires, cputime_zero))
+	if (it->expires == cputime_zero)
 		return;
 
-	if (cputime_ge(cur_time, it->expires)) {
-		if (!cputime_eq(it->incr, cputime_zero)) {
-			it->expires = cputime_add(it->expires, it->incr);
+	if (cur_time >= it->expires) {
+		if (it->incr != cputime_zero) {
+			it->expires += it->incr;
 			it->error += it->incr_error;
 			if (it->error >= onecputick) {
-				it->expires = cputime_sub(it->expires,
-							  cputime_one_jiffy);
+				it->expires -= cputime_one_jiffy;
 				it->error -= onecputick;
 			}
 		} else {
@@ -1031,9 +1011,8 @@ static void check_cpu_itimer(struct task
 		__group_send_sig_info(signo, SEND_SIG_PRIV, tsk);
 	}
 
-	if (!cputime_eq(it->expires, cputime_zero) &&
-	    (cputime_eq(*expires, cputime_zero) ||
-	     cputime_lt(it->expires, *expires))) {
+	if (it->expires != cputime_zero &&
+	    (*expires == cputime_zero || it->expires < *expires)) {
 		*expires = it->expires;
 	}
 }
@@ -1048,8 +1027,8 @@ static void check_cpu_itimer(struct task
  */
 static inline int task_cputime_zero(const struct task_cputime *cputime)
 {
-	if (cputime_eq(cputime->utime, cputime_zero) &&
-	    cputime_eq(cputime->stime, cputime_zero) &&
+	if (cputime->utime == cputime_zero &&
+	    cputime->stime == cputime_zero &&
 	    cputime->sum_exec_runtime == 0)
 		return 1;
 	return 0;
@@ -1076,7 +1055,7 @@ static void check_process_timers(struct
 	 */
 	thread_group_cputimer(tsk, &cputime);
 	utime = cputime.utime;
-	ptime = cputime_add(utime, cputime.stime);
+	ptime = utime + cputime.stime;
 	sum_sched_runtime = cputime.sum_exec_runtime;
 	maxfire = 20;
 	prof_expires = cputime_zero;
@@ -1084,7 +1063,7 @@ static void check_process_timers(struct
 		struct cpu_timer_list *tl = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || cputime_lt(ptime, tl->expires.cpu)) {
+		if (!--maxfire || ptime < tl->expires.cpu) {
 			prof_expires = tl->expires.cpu;
 			break;
 		}
@@ -1099,7 +1078,7 @@ static void check_process_timers(struct
 		struct cpu_timer_list *tl = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || cputime_lt(utime, tl->expires.cpu)) {
+		if (!--maxfire || utime < tl->expires.cpu) {
 			virt_expires = tl->expires.cpu;
 			break;
 		}
@@ -1154,8 +1133,7 @@ static void check_process_timers(struct
 			}
 		}
 		x = secs_to_cputime(soft);
-		if (cputime_eq(prof_expires, cputime_zero) ||
-		    cputime_lt(x, prof_expires)) {
+		if (prof_expires == cputime_zero || x < prof_expires) {
 			prof_expires = x;
 		}
 	}
@@ -1249,12 +1227,11 @@ out:
 static inline int task_cputime_expired(const struct task_cputime *sample,
 					const struct task_cputime *expires)
 {
-	if (!cputime_eq(expires->utime, cputime_zero) &&
-	    cputime_ge(sample->utime, expires->utime))
+	if (expires->utime != cputime_zero &&
+	    sample->utime >= expires->utime)
 		return 1;
-	if (!cputime_eq(expires->stime, cputime_zero) &&
-	    cputime_ge(cputime_add(sample->utime, sample->stime),
-		       expires->stime))
+	if (expires->stime != cputime_zero &&
+	    sample->utime + sample->stime >= expires->stime)
 		return 1;
 	if (expires->sum_exec_runtime != 0 &&
 	    sample->sum_exec_runtime >= expires->sum_exec_runtime)
@@ -1389,18 +1366,18 @@ void set_process_cpu_timer(struct task_s
 		 * it to be relative, *newval argument is relative and we update
 		 * it to be absolute.
 		 */
-		if (!cputime_eq(*oldval, cputime_zero)) {
-			if (cputime_le(*oldval, now.cpu)) {
+		if (*oldval != cputime_zero) {
+			if (*oldval <= now.cpu) {
 				/* Just about to fire. */
 				*oldval = cputime_one_jiffy;
 			} else {
-				*oldval = cputime_sub(*oldval, now.cpu);
+				*oldval -= now.cpu;
 			}
 		}
 
-		if (cputime_eq(*newval, cputime_zero))
+		if (*newval == cputime_zero)
 			return;
-		*newval = cputime_add(*newval, now.cpu);
+		*newval += now.cpu;
 	}
 
 	/*
@@ -1409,11 +1386,11 @@ void set_process_cpu_timer(struct task_s
 	 */
 	switch (clock_idx) {
 	case CPUCLOCK_PROF:
-		if (expires_gt(tsk->signal->cputime_expires.prof_exp, *newval))
+		if (tsk->signal->cputime_expires.prof_exp > *newval)
 			tsk->signal->cputime_expires.prof_exp = *newval;
 		break;
 	case CPUCLOCK_VIRT:
-		if (expires_gt(tsk->signal->cputime_expires.virt_exp, *newval))
+		if (tsk->signal->cputime_expires.virt_exp >  *newval)
 			tsk->signal->cputime_expires.virt_exp = *newval;
 		break;
 	}
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2011,7 +2011,7 @@ static int irqtime_account_hi_update(voi
 
 	local_irq_save(flags);
 	latest_ns = this_cpu_read(cpu_hardirq_time);
-	if (cputime64_gt(nsecs_to_cputime64(latest_ns), cpustat->irq))
+	if (nsecs_to_cputime64(latest_ns) > cpustat->irq)
 		ret = 1;
 	local_irq_restore(flags);
 	return ret;
@@ -2026,7 +2026,7 @@ static int irqtime_account_si_update(voi
 
 	local_irq_save(flags);
 	latest_ns = this_cpu_read(cpu_softirq_time);
-	if (cputime64_gt(nsecs_to_cputime64(latest_ns), cpustat->softirq))
+	if (nsecs_to_cputime64(latest_ns) > cpustat->softirq)
 		ret = 1;
 	local_irq_restore(flags);
 	return ret;
@@ -3734,19 +3734,17 @@ void account_user_time(struct task_struc
 		       cputime_t cputime_scaled)
 {
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
-	cputime64_t tmp;
 
 	/* Add user time to process. */
-	p->utime = cputime_add(p->utime, cputime);
-	p->utimescaled = cputime_add(p->utimescaled, cputime_scaled);
+	p->utime += cputime;
+	p->utimescaled += cputime_scaled;
 	account_group_user_time(p, cputime);
 
 	/* Add user time to cpustat. */
-	tmp = cputime_to_cputime64(cputime);
 	if (TASK_NICE(p) > 0)
-		cpustat->nice = cputime64_add(cpustat->nice, tmp);
+		cpustat->nice += (__force cputime64_t) cputime;
 	else
-		cpustat->user = cputime64_add(cpustat->user, tmp);
+		cpustat->user += (__force cputime64_t) cputime;
 
 	cpuacct_update_stats(p, CPUACCT_STAT_USER, cputime);
 	/* Account for user time used */
@@ -3762,24 +3760,21 @@ void account_user_time(struct task_struc
 static void account_guest_time(struct task_struct *p, cputime_t cputime,
 			       cputime_t cputime_scaled)
 {
-	cputime64_t tmp;
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
 
-	tmp = cputime_to_cputime64(cputime);
-
 	/* Add guest time to process. */
-	p->utime = cputime_add(p->utime, cputime);
-	p->utimescaled = cputime_add(p->utimescaled, cputime_scaled);
+	p->utime += cputime;
+	p->utimescaled += cputime_scaled;
 	account_group_user_time(p, cputime);
-	p->gtime = cputime_add(p->gtime, cputime);
+	p->gtime += cputime;
 
 	/* Add guest time to cpustat. */
 	if (TASK_NICE(p) > 0) {
-		cpustat->nice = cputime64_add(cpustat->nice, tmp);
-		cpustat->guest_nice = cputime64_add(cpustat->guest_nice, tmp);
+		cpustat->nice += (__force cputime64_t) cputime;
+		cpustat->guest_nice += (__force cputime64_t) cputime;
 	} else {
-		cpustat->user = cputime64_add(cpustat->user, tmp);
-		cpustat->guest = cputime64_add(cpustat->guest, tmp);
+		cpustat->user += (__force cputime64_t) cputime;
+		cpustat->guest += (__force cputime64_t) cputime;
 	}
 }
 
@@ -3794,15 +3789,13 @@ static inline
 void __account_system_time(struct task_struct *p, cputime_t cputime,
 			cputime_t cputime_scaled, cputime64_t *target_cputime64)
 {
-	cputime64_t tmp = cputime_to_cputime64(cputime);
-
 	/* Add system time to process. */
-	p->stime = cputime_add(p->stime, cputime);
-	p->stimescaled = cputime_add(p->stimescaled, cputime_scaled);
+	p->stime += cputime;
+	p->stimescaled += cputime_scaled;
 	account_group_system_time(p, cputime);
 
 	/* Add system time to cpustat. */
-	*target_cputime64 = cputime64_add(*target_cputime64, tmp);
+	*target_cputime64 += (__force cputime64_t) cputime;
 	cpuacct_update_stats(p, CPUACCT_STAT_SYSTEM, cputime);
 
 	/* Account for system time used */
@@ -3844,9 +3837,8 @@ void account_system_time(struct task_str
 void account_steal_time(cputime_t cputime)
 {
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
-	cputime64_t cputime64 = cputime_to_cputime64(cputime);
 
-	cpustat->steal = cputime64_add(cpustat->steal, cputime64);
+	cpustat->steal += (__force cputime64_t) cputime;
 }
 
 /*
@@ -3856,13 +3848,12 @@ void account_steal_time(cputime_t cputim
 void account_idle_time(cputime_t cputime)
 {
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
-	cputime64_t cputime64 = cputime_to_cputime64(cputime);
 	struct rq *rq = this_rq();
 
 	if (atomic_read(&rq->nr_iowait) > 0)
-		cpustat->iowait = cputime64_add(cpustat->iowait, cputime64);
+		cpustat->iowait += (__force cputime64_t) cputime;
 	else
-		cpustat->idle = cputime64_add(cpustat->idle, cputime64);
+		cpustat->idle += (__force cputime64_t) cputime;
 }
 
 static __always_inline bool steal_account_process_tick(void)
@@ -3912,16 +3903,15 @@ static void irqtime_account_process_tick
 						struct rq *rq)
 {
 	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
-	cputime64_t tmp = cputime_to_cputime64(cputime_one_jiffy);
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
 
 	if (steal_account_process_tick())
 		return;
 
 	if (irqtime_account_hi_update()) {
-		cpustat->irq = cputime64_add(cpustat->irq, tmp);
+		cpustat->irq += (__force cputime64_t) cputime_one_jiffy;
 	} else if (irqtime_account_si_update()) {
-		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
+		cpustat->softirq += (__force cputime64_t) cputime_one_jiffy;
 	} else if (this_cpu_ksoftirqd() == p) {
 		/*
 		 * ksoftirqd time do not get accounted in cpu_softirq_time.
@@ -4037,7 +4027,7 @@ void thread_group_times(struct task_stru
 
 void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
-	cputime_t rtime, utime = p->utime, total = cputime_add(utime, p->stime);
+	cputime_t rtime, utime = p->utime, total = utime + p->stime;
 
 	/*
 	 * Use CFS's precise accounting:
@@ -4045,11 +4035,11 @@ void task_times(struct task_struct *p, c
 	rtime = nsecs_to_cputime(p->se.sum_exec_runtime);
 
 	if (total) {
-		u64 temp = rtime;
+		u64 temp = (__force u64) rtime;
 
-		temp *= utime;
-		do_div(temp, total);
-		utime = (cputime_t)temp;
+		temp *= (__force u64) utime;
+		do_div(temp, (__force u32) total);
+		utime = (__force cputime_t) temp;
 	} else
 		utime = rtime;
 
@@ -4057,7 +4047,7 @@ void task_times(struct task_struct *p, c
 	 * Compare with previous values, to keep monotonicity:
 	 */
 	p->prev_utime = max(p->prev_utime, utime);
-	p->prev_stime = max(p->prev_stime, cputime_sub(rtime, p->prev_utime));
+	p->prev_stime = max(p->prev_stime, rtime - p->prev_utime);
 
 	*ut = p->prev_utime;
 	*st = p->prev_stime;
@@ -4074,21 +4064,20 @@ void thread_group_times(struct task_stru
 
 	thread_group_cputime(p, &cputime);
 
-	total = cputime_add(cputime.utime, cputime.stime);
+	total = cputime.utime + cputime.stime;
 	rtime = nsecs_to_cputime(cputime.sum_exec_runtime);
 
 	if (total) {
-		u64 temp = rtime;
+		u64 temp = (__force u64) rtime;
 
-		temp *= cputime.utime;
-		do_div(temp, total);
-		utime = (cputime_t)temp;
+		temp *= (__force u64) cputime.utime;
+		do_div(temp, (__force u32) total);
+		utime = (__force cputime_t) temp;
 	} else
 		utime = rtime;
 
 	sig->prev_utime = max(sig->prev_utime, utime);
-	sig->prev_stime = max(sig->prev_stime,
-			      cputime_sub(rtime, sig->prev_utime));
+	sig->prev_stime = max(sig->prev_stime, rtime - sig->prev_utime);
 
 	*ut = sig->prev_utime;
 	*st = sig->prev_stime;
@@ -9330,7 +9319,8 @@ static void cpuacct_update_stats(struct
 	ca = task_ca(tsk);
 
 	do {
-		__percpu_counter_add(&ca->cpustat[idx], val, batch);
+		__percpu_counter_add(&ca->cpustat[idx],
+				     (__force s64) val, batch);
 		ca = ca->parent;
 	} while (ca);
 	rcu_read_unlock();
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -283,8 +283,7 @@ static inline void account_group_user_ti
 		return;
 
 	spin_lock(&cputimer->lock);
-	cputimer->cputime.utime =
-		cputime_add(cputimer->cputime.utime, cputime);
+	cputimer->cputime.utime += cputime;
 	spin_unlock(&cputimer->lock);
 }
 
@@ -307,8 +306,7 @@ static inline void account_group_system_
 		return;
 
 	spin_lock(&cputimer->lock);
-	cputimer->cputime.stime =
-		cputime_add(cputimer->cputime.stime, cputime);
+	cputimer->cputime.stime += cputime;
 	spin_unlock(&cputimer->lock);
 }
 
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1621,10 +1621,8 @@ bool do_notify_parent(struct task_struct
 	info.si_uid = __task_cred(tsk)->uid;
 	rcu_read_unlock();
 
-	info.si_utime = cputime_to_clock_t(cputime_add(tsk->utime,
-				tsk->signal->utime));
-	info.si_stime = cputime_to_clock_t(cputime_add(tsk->stime,
-				tsk->signal->stime));
+	info.si_utime = cputime_to_clock_t(tsk->utime + tsk->signal->utime);
+	info.si_stime = cputime_to_clock_t(tsk->stime + tsk->signal->stime);
 
 	info.si_status = tsk->exit_code & 0x7f;
 	if (tsk->exit_code & 0x80)
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1632,8 +1632,8 @@ static void k_getrusage(struct task_stru
 
 		case RUSAGE_SELF:
 			thread_group_times(p, &tgutime, &tgstime);
-			utime = cputime_add(utime, tgutime);
-			stime = cputime_add(stime, tgstime);
+			utime += tgutime;
+			stime += tgstime;
 			r->ru_nvcsw += p->signal->nvcsw;
 			r->ru_nivcsw += p->signal->nivcsw;
 			r->ru_minflt += p->signal->min_flt;
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -127,7 +127,7 @@ void acct_update_integrals(struct task_s
 
 		local_irq_save(flags);
 		time = tsk->stime + tsk->utime;
-		dtime = cputime_sub(time, tsk->acct_timexpd);
+		dtime = time - tsk->acct_timexpd;
 		jiffies_to_timeval(cputime_to_jiffies(dtime), &value);
 		delta = value.tv_sec;
 		delta = delta * USEC_PER_SEC + value.tv_usec;
@@ -148,7 +148,7 @@ void acct_update_integrals(struct task_s
  */
 void acct_clear_integrals(struct task_struct *tsk)
 {
-	tsk->acct_timexpd = 0;
+	tsk->acct_timexpd = cputime_zero;
 	tsk->acct_rss_mem1 = 0;
 	tsk->acct_vm_mem1 = 0;
 }


-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

