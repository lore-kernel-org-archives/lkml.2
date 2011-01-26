Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1AZMMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:12:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:39764 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab1AZMMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:12:51 -0500
Date: Wed, 26 Jan 2011 12:12:19 GMT
From: tip-bot for Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, sruffell@digium.com, tglx@linutronix.de,
        venki@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, sruffell@digium.com, tglx@linutronix.de,
        venki@google.com, mingo@elte.hu
In-Reply-To: <1292980144-28796-3-git-send-email-venki@google.com>
References: <1292980144-28796-3-git-send-email-venki@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] time: Add nsecs_to_cputime64 interface for asm-generic
Message-ID: <tip-a1dabb6bfffccb897eff3e1d102dacf2a4bedf3b@git.kernel.org>
Git-Commit-ID: a1dabb6bfffccb897eff3e1d102dacf2a4bedf3b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 12:12:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1dabb6bfffccb897eff3e1d102dacf2a4bedf3b
Gitweb:     http://git.kernel.org/tip/a1dabb6bfffccb897eff3e1d102dacf2a4bedf3b
Author:     Venkatesh Pallipadi <venki@google.com>
AuthorDate: Tue, 21 Dec 2010 17:09:01 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Jan 2011 12:33:20 +0100

time: Add nsecs_to_cputime64 interface for asm-generic

Add nsecs_to_cputime64 interface. This is used in following patches that
updates cpu irq stat based on ns granularity info in IRQ_TIME_ACCOUNTING.

Tested-by: Shaun Ruffell <sruffell@digium.com>
Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1292980144-28796-3-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-generic/cputime.h |    3 +++
 include/linux/jiffies.h       |    1 +
 kernel/time.c                 |   23 +++++++++++++++++++++--
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/cputime.h b/include/asm-generic/cputime.h
index 2bcc5c7..61e03dd 100644
--- a/include/asm-generic/cputime.h
+++ b/include/asm-generic/cputime.h
@@ -30,6 +30,9 @@ typedef u64 cputime64_t;
 #define cputime64_to_jiffies64(__ct)	(__ct)
 #define jiffies64_to_cputime64(__jif)	(__jif)
 #define cputime_to_cputime64(__ct)	((u64) __ct)
+#define cputime64_gt(__a, __b)		((__a) >  (__b))
+
+#define nsecs_to_cputime64(__ct)	nsecs_to_jiffies64(__ct)
 
 
 /*
diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 6811f4b..922aa31 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -307,6 +307,7 @@ extern clock_t jiffies_to_clock_t(long x);
 extern unsigned long clock_t_to_jiffies(unsigned long x);
 extern u64 jiffies_64_to_clock_t(u64 x);
 extern u64 nsec_to_clock_t(u64 x);
+extern u64 nsecs_to_jiffies64(u64 n);
 extern unsigned long nsecs_to_jiffies(u64 n);
 
 #define TIMESTAMP_SIZE	30
diff --git a/kernel/time.c b/kernel/time.c
index 3217435..55337a8 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -645,7 +645,7 @@ u64 nsec_to_clock_t(u64 x)
 }
 
 /**
- * nsecs_to_jiffies - Convert nsecs in u64 to jiffies
+ * nsecs_to_jiffies64 - Convert nsecs in u64 to jiffies64
  *
  * @n:	nsecs in u64
  *
@@ -657,7 +657,7 @@ u64 nsec_to_clock_t(u64 x)
  *   NSEC_PER_SEC = 10^9 = (5^9 * 2^9) = (1953125 * 512)
  *   ULLONG_MAX ns = 18446744073.709551615 secs = about 584 years
  */
-unsigned long nsecs_to_jiffies(u64 n)
+u64 nsecs_to_jiffies64(u64 n)
 {
 #if (NSEC_PER_SEC % HZ) == 0
 	/* Common case, HZ = 100, 128, 200, 250, 256, 500, 512, 1000 etc. */
@@ -674,6 +674,25 @@ unsigned long nsecs_to_jiffies(u64 n)
 #endif
 }
 
+
+/**
+ * nsecs_to_jiffies - Convert nsecs in u64 to jiffies
+ *
+ * @n:	nsecs in u64
+ *
+ * Unlike {m,u}secs_to_jiffies, type of input is not unsigned int but u64.
+ * And this doesn't return MAX_JIFFY_OFFSET since this function is designed
+ * for scheduler, not for use in device drivers to calculate timeout value.
+ *
+ * note:
+ *   NSEC_PER_SEC = 10^9 = (5^9 * 2^9) = (1953125 * 512)
+ *   ULLONG_MAX ns = 18446744073.709551615 secs = about 584 years
+ */
+unsigned long nsecs_to_jiffies(u64 n)
+{
+	return (unsigned long)nsecs_to_jiffies64(n);
+}
+
 #if (BITS_PER_LONG < 64)
 u64 get_jiffies_64(void)
 {
