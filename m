Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab1DHJUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 05:20:25 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:50536 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab1DHJUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 05:20:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=iN4z4CRhlfBO233yK3PCAniC5slUjsLPcgV1lv6izPogwh7S2bosvGIt7SdqJRaav9
         XrmNYVs7AkZPzC9Frq1ne6OUt1SNvK5NaM7NGre37aIxMYJrbHGGbzIqfG3C9YmKMdkB
         Om9FSt2KnOfM3nfAEB4DulW4L6MDiMWqOYbno=
From: Aditya Shevade <aditya.shevade@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
        Richard Cochran <richard.cochran@omicron.at>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, Aditya Shevade <aditya.shevade@gmail.com>
Subject: [PATCH 9/9] kernel: time.c: Fixed if condition assignment issue
Date: Fri,  8 Apr 2011 02:20:36 -0700
Message-Id: <1302254436-6046-1-git-send-email-aditya.shevade@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed an assignment statement from if condition.
Replaced asm/uaccess.h by linux/uaccess.h
Replaced asm/unistd.h by linux/unistd.h
Removed unnecessary braces from if-else structure.
Fixed minor whitespace issues.

Signed-off-by: Aditya Shevade <aditya.shevade@gmail.com>
---
 kernel/time.c |   40 +++++++++++++++++++---------------------
 1 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/kernel/time.c b/kernel/time.c
index 8e8dc6d..9fb835f 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -38,8 +38,8 @@
 #include <linux/math64.h>
 #include <linux/ptrace.h>
 
-#include <asm/uaccess.h>
-#include <asm/unistd.h>
+#include <linux/uaccess.h>
+#include <linux/unistd.h>
 
 #include "timeconst.h"
 
@@ -64,7 +64,7 @@ SYSCALL_DEFINE1(time, time_t __user *, tloc)
 	time_t i = get_seconds();
 
 	if (tloc) {
-		if (put_user(i,tloc))
+		if (put_user(i, tloc))
 			return -EFAULT;
 	}
 	force_successful_syscall_return();
@@ -173,12 +173,10 @@ int do_sys_settimeofday(const struct timespec *tv, const struct timezone *tz)
 		}
 	}
 	if (tv)
-	{
 		/* SMP safe, again the code in arch/foo/time.c should
 		 * globally block out interrupts when it runs.
 		 */
 		return do_settimeofday(tv);
-	}
 	return 0;
 }
 
@@ -212,7 +210,7 @@ SYSCALL_DEFINE1(adjtimex, struct timex __user *, txc_p)
 	 * structure. But bear in mind that the structures
 	 * may change
 	 */
-	if(copy_from_user(&txc, txc_p, sizeof(struct timex)))
+	if (copy_from_user(&txc, txc_p, sizeof(struct timex)))
 		return -EFAULT;
 	ret = do_adjtimex(&txc);
 	return copy_to_user(txc_p, &txc, sizeof(struct timex)) ? -EFAULT : ret;
@@ -289,13 +287,12 @@ struct timespec timespec_trunc(struct timespec t, unsigned gran)
 	 * Currently current_kernel_time() never returns better than
 	 * jiffies resolution. Exploit that.
 	 */
-	if (gran <= jiffies_to_usecs(1) * 1000) {
-		/* nothing */
-	} else if (gran == 1000000000) {
+	if (gran <= jiffies_to_usecs(1) * 1000)
+		;/* nothing */
+	else if (gran == 1000000000)
 		t.tv_nsec = 0;
-	} else {
+	else
 		t.tv_nsec -= t.tv_nsec % gran;
-	}
 	return t;
 }
 EXPORT_SYMBOL(timespec_trunc);
@@ -317,13 +314,14 @@ EXPORT_SYMBOL(timespec_trunc);
  */
 unsigned long
 mktime(const unsigned int year0, const unsigned int mon0,
-       const unsigned int day, const unsigned int hour,
-       const unsigned int min, const unsigned int sec)
+	const unsigned int day, const unsigned int hour,
+	const unsigned int min, const unsigned int sec)
 {
 	unsigned int mon = mon0, year = year0;
 
 	/* 1..12 -> 11,12,1..10 */
-	if (0 >= (int) (mon -= 2)) {
+	mon -= 2;
+	if (0 >= (int) mon) {
 		mon += 12;	/* Puts Feb last since it has leap day */
 		year -= 1;
 	}
@@ -505,7 +503,7 @@ timespec_to_jiffies(const struct timespec *value)
 	unsigned long sec = value->tv_sec;
 	long nsec = value->tv_nsec + TICK_NSEC - 1;
 
-	if (sec >= MAX_SEC_IN_JIFFIES){
+	if (sec >= MAX_SEC_IN_JIFFIES) {
 		sec = MAX_SEC_IN_JIFFIES;
 		nsec = 0;
 	}
@@ -548,7 +546,7 @@ timeval_to_jiffies(const struct timeval *value)
 	unsigned long sec = value->tv_sec;
 	long usec = value->tv_usec;
 
-	if (sec >= MAX_SEC_IN_JIFFIES){
+	if (sec >= MAX_SEC_IN_JIFFIES) {
 		sec = MAX_SEC_IN_JIFFIES;
 		usec = 0;
 	}
@@ -591,7 +589,7 @@ EXPORT_SYMBOL(jiffies_to_clock_t);
 
 unsigned long clock_t_to_jiffies(unsigned long x)
 {
-#if (HZ % USER_HZ)==0
+#if (HZ % USER_HZ) == 0
 	if (x >= ~0UL / (HZ / USER_HZ))
 		return ~0UL;
 	return x * (HZ / USER_HZ);
@@ -636,10 +634,10 @@ u64 nsec_to_clock_t(u64 x)
 	return div_u64(x * USER_HZ / 512, NSEC_PER_SEC / 512);
 #else
 	/*
-         * max relative error 5.7e-8 (1.8s per year) for USER_HZ <= 1024,
-         * overflow after 64.99 years.
-         * exact for HZ=60, 72, 90, 120, 144, 180, 300, 600, 900, ...
-         */
+	 * max relative error 5.7e-8 (1.8s per year) for USER_HZ <= 1024,
+	 * overflow after 64.99 years.
+	 * exact for HZ=60, 72, 90, 120, 144, 180, 300, 600, 900, ...
+	 */
 	return div_u64(x * 9, (9ull * NSEC_PER_SEC + (USER_HZ / 2)) / USER_HZ);
 #endif
 }
-- 
1.7.4.4

