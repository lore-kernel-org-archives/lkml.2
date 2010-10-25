Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab0JYWb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 18:31:57 -0400
Received: from smtp-out.google.com ([74.125.121.35]:47098 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab0JYWbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 18:31:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QhQOXUzbyFIInbGs+KmUgIZ++TrotGgB3vPU30zZ/oW1IKTgqkIsK3c1iEA7V9EyRS
         7w5GjuKfCvn7szl2nXdw==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 3/6] Add nsecs_to_cputime64 interface for asm-generic -v1
Date: Mon, 25 Oct 2010 15:30:14 -0700
Message-Id: <1288045817-3135-4-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288045817-3135-1-git-send-email-venki@google.com>
References: <1288045817-3135-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add nsecs_to_cputime64 interface. This is used in following patches that
updates cpu irq stat based on ns granularity info in IRQ_TIME_ACCOUNTING.

Tested-by: Shaun Ruffell <sruffell@digium.com>

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 include/asm-generic/cputime.h |    3 +++
 include/linux/jiffies.h       |    1 +
 kernel/time.c                 |   23 +++++++++++++++++++++--
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/cputime.h b/include/asm-generic/cputime.h
index ca0f239..c0f0da0 100644
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
index ba9b338..fde4691 100644
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
-- 
1.7.1

