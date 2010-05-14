Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab0ENNWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 09:22:48 -0400
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:42721 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342Ab0ENNWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 09:22:46 -0400
Subject: [PATCH] Use microsecond granularity for taskstats accounting
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       tony.luck@intel.com, benh@kernel.crashing.org
Cc: martin.schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jlan@sgi.com,
       balbir@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Fri, 14 May 2010 15:22:32 +0200
Message-ID: <1273843352.2615.61.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

The taskstats interface uses microsecond granularity for the user and
system time values. The conversion from cputime to the taskstats values
uses the cputime_to_msecs primitive which effectively limits the 
granularity to milliseconds. Add the cputime_to_usecs primitive for
architectures that have better, more precise CPU time values.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 arch/ia64/include/asm/cputime.h    |    6 ++++++
 arch/powerpc/include/asm/cputime.h |   13 +++++++++++++
 arch/s390/include/asm/cputime.h    |   15 +++++++++++++++
 include/asm-generic/cputime.h      |    6 ++++++
 kernel/tsacct.c                    |   10 ++++------
 5 files changed, 44 insertions(+), 6 deletions(-)

--- a/arch/ia64/include/asm/cputime.h
+++ b/arch/ia64/include/asm/cputime.h
@@ -56,6 +56,12 @@ typedef u64 cputime64_t;
 #define jiffies64_to_cputime64(__jif)	((__jif) * (NSEC_PER_SEC / HZ))
 
 /*
+ * Convert cputime <-> microseconds
+ */
+#define cputime_to_usecs(__ct)		((__ct) / NSEC_PER_USEC)
+#define usecs_to_cputime(__usecs)	((__usecs) * NSEC_PER_USEC)
+
+/*
  * Convert cputime <-> milliseconds
  */
 #define cputime_to_msecs(__ct)		((__ct) / NSEC_PER_MSEC)
--- a/arch/powerpc/include/asm/cputime.h
+++ b/arch/powerpc/include/asm/cputime.h
@@ -151,6 +151,19 @@ static inline cputime_t msecs_to_cputime
 }
 
 /*
+ * Convert cputime <-> microseconds
+ */
+static inline unsigned long cputime_to_usecs(const cputime_t ct)
+{
+	return cputime_to_msecs(ct) * USEC_PER_MSEC;
+}
+
+static inline cputime_t usecs_to_cputime(const unsigned long us)
+{
+	return msecs_to_cputime(us / USEC_PER_MSEC);
+}
+
+/*
  * Convert cputime <-> seconds
  */
 extern u64 __cputime_sec_factor;
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@ -73,6 +73,21 @@ cputime64_to_jiffies64(cputime64_t cputi
 }
 
 /*
+ * Convert cputime to microseconds and back.
+ */
+static inline unsigned int
+cputime_to_usecs(const cputime_t cputime)
+{
+	return cputime_div(cputime, 4096);
+}
+
+static inline cputime_t
+usecs_to_cputime(const unsigned int m)
+{
+	return (cputime_t) m * 4096;
+}
+
+/*
  * Convert cputime to milliseconds and back.
  */
 static inline unsigned int
--- a/include/asm-generic/cputime.h
+++ b/include/asm-generic/cputime.h
@@ -33,6 +33,12 @@ typedef u64 cputime64_t;
 
 
 /*
+ * Convert cputime to microseconds and back.
+ */
+#define cputime_to_usecs(__ct)		jiffies_to_usecs(__ct);
+#define usecs_to_cputime(__msecs)	usecs_to_jiffies(__msecs);
+
+/*
  * Convert cputime to milliseconds and back.
  */
 #define cputime_to_msecs(__ct)		jiffies_to_msecs(__ct)
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
 


