Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab0IWOBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 10:01:00 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:52278 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab0IWOA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 10:00:58 -0400
Subject: [RFC][PATCH 01/10] taskstats: Use real microsecond granularity for
 CPU times
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1285249681.1837.28.camel@holzheu-laptop>
References: <1285249681.1837.28.camel@holzheu-laptop>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Thu, 23 Sep 2010 16:00:52 +0200
Message-ID: <1285250452.1837.78.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] taskstats: Use real microsecond granularity for CPU times

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

The taskstats interface uses microsecond granularity for the user and
system time values. The conversion from cputime to the taskstats values
uses the cputime_to_msecs primitive which effectively limits the 
granularity to milliseconds. Add the cputime_to_usecs primitive for
architectures that have better, more precise CPU time values. Remove
cputime_to_msecs primitive because there is no more user left.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 arch/ia64/include/asm/cputime.h    |    6 +++---
 arch/powerpc/include/asm/cputime.h |   12 ++++++------
 arch/s390/include/asm/cputime.h    |   10 +++++-----
 include/asm-generic/cputime.h      |    6 +++---
 kernel/tsacct.c                    |   10 ++++------
 5 files changed, 21 insertions(+), 23 deletions(-)

--- a/arch/ia64/include/asm/cputime.h
+++ b/arch/ia64/include/asm/cputime.h
@@ -56,10 +56,10 @@ typedef u64 cputime64_t;
 #define jiffies64_to_cputime64(__jif)	((__jif) * (NSEC_PER_SEC / HZ))
 
 /*
- * Convert cputime <-> milliseconds
+ * Convert cputime <-> microseconds
  */
-#define cputime_to_msecs(__ct)		((__ct) / NSEC_PER_MSEC)
-#define msecs_to_cputime(__msecs)	((__msecs) * NSEC_PER_MSEC)
+#define cputime_to_usecs(__ct)		((__ct) / NSEC_PER_USEC)
+#define usecs_to_cputime(__usecs)	((__usecs) * NSEC_PER_USEC)
 
 /*
  * Convert cputime <-> seconds
--- a/arch/powerpc/include/asm/cputime.h
+++ b/arch/powerpc/include/asm/cputime.h
@@ -124,23 +124,23 @@ static inline u64 cputime64_to_jiffies64
 }
 
 /*
- * Convert cputime <-> milliseconds
+ * Convert cputime <-> microseconds
  */
 extern u64 __cputime_msec_factor;
 
-static inline unsigned long cputime_to_msecs(const cputime_t ct)
+static inline unsigned long cputime_to_usecs(const cputime_t ct)
 {
-	return mulhdu(ct, __cputime_msec_factor);
+	return mulhdu(ct, __cputime_msec_factor) * USEC_PER_MSEC;
 }
 
-static inline cputime_t msecs_to_cputime(const unsigned long ms)
+static inline cputime_t usecs_to_cputime(const unsigned long us)
 {
 	cputime_t ct;
 	unsigned long sec;
 
 	/* have to be a little careful about overflow */
-	ct = ms % 1000;
-	sec = ms / 1000;
+	ct = us % 1000000;
+	sec = us / 1000000;
 	if (ct) {
 		ct *= tb_ticks_per_sec;
 		do_div(ct, 1000);
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@ -73,18 +73,18 @@ cputime64_to_jiffies64(cputime64_t cputi
 }
 
 /*
- * Convert cputime to milliseconds and back.
+ * Convert cputime to microseconds and back.
  */
 static inline unsigned int
-cputime_to_msecs(const cputime_t cputime)
+cputime_to_usecs(const cputime_t cputime)
 {
-	return cputime_div(cputime, 4096000);
+	return cputime_div(cputime, 4096);
 }
 
 static inline cputime_t
-msecs_to_cputime(const unsigned int m)
+usecs_to_cputime(const unsigned int m)
 {
-	return (cputime_t) m * 4096000;
+	return (cputime_t) m * 4096;
 }
 
 /*
--- a/include/asm-generic/cputime.h
+++ b/include/asm-generic/cputime.h
@@ -33,10 +33,10 @@ typedef u64 cputime64_t;
 
 
 /*
- * Convert cputime to milliseconds and back.
+ * Convert cputime to microseconds and back.
  */
-#define cputime_to_msecs(__ct)		jiffies_to_msecs(__ct)
-#define msecs_to_cputime(__msecs)	msecs_to_jiffies(__msecs)
+#define cputime_to_usecs(__ct)		jiffies_to_usecs(__ct);
+#define usecs_to_cputime(__msecs)	usecs_to_jiffies(__msecs);
 
 /*
  * Convert cputime to seconds and back.
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -63,12 +63,10 @@ void bacct_add_tsk(struct taskstats *sta
 	stats->ac_ppid	 = pid_alive(tsk) ?
 				rcu_dereference(tsk->real_parent)->tgid : 0;
 	rcu_read_unlock();
-	stats->ac_utime	 = cputime_to_msecs(tsk->utime) * USEC_PER_MSEC;
-	stats->ac_stime	 = cputime_to_msecs(tsk->stime) * USEC_PER_MSEC;
-	stats->ac_utimescaled =
-		cputime_to_msecs(tsk->utimescaled) * USEC_PER_MSEC;
-	stats->ac_stimescaled =
-		cputime_to_msecs(tsk->stimescaled) * USEC_PER_MSEC;
+	stats->ac_utime = cputime_to_usecs(tsk->utime);
+	stats->ac_stime = cputime_to_usecs(tsk->stime);
+	stats->ac_utimescaled = cputime_to_usecs(tsk->utimescaled);
+	stats->ac_stimescaled = cputime_to_usecs(tsk->stimescaled);
 	stats->ac_minflt = tsk->min_flt;
 	stats->ac_majflt = tsk->maj_flt;
 


