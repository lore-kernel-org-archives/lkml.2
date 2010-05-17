Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab0EQOR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 10:17:29 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:54953 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab0EQOR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 10:17:26 -0400
Subject: RE: [PATCH] Use microsecond granularity for taskstats accounting
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
       "schwidefsky@de.ibm.com" <martin.schwidefsky@de.ibm.com>,
       "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
       "jlan@sgi.com" <jlan@sgi.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
In-Reply-To: <987664A83D2D224EAE907B061CE93D53C6120ABB@orsmsx505.amr.corp.intel.com>
References: <1273843352.2615.61.camel@holzheu-laptop>
	 <987664A83D2D224EAE907B061CE93D53C6120ABB@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Mon, 17 May 2010 16:17:15 +0200
Message-ID: <1274105835.11913.28.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tony,

On Fri, 2010-05-14 at 14:28 -0700, Luck, Tony wrote:
> You delete the only users of cputime_to_msecs() ... should
> you also delete the definition from asm-generic/cputime.h?
> Same for the msecs_to_cputime() that had no users.
> 
> Is it worth adding the usecs_to_cputime() functions/macros.
> Symmetry is nice (and matches what used to be there, but
> unused code isn't very worthwhile.

Fine, I removed the msecs functions, but I have the feeling that we
should keep the usecs_to_cputime().

Another thing: The power PC implementation of cputime_to_usecs() could
probably be done better. With my patch it still uses only millisecond
granularity. To fix this we probably would have to add a new variable
"__cputime_usec_factor". Not sure, if we should do that.

Here the updated patch:

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
 




