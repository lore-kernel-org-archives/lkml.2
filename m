Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab2IBFsT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 01:48:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53814 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab2IBFsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 01:48:17 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Colin Cross <ccross@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <john.stultz@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 1/4] kernel/time: Add new helpers to convert ktime to/from jiffies
Date: Sat,  1 Sep 2012 22:45:19 -0700
Message-Id: <1346564722-14408-1-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.11.5
In-Reply-To: <20120902054335.GA12741@lizard>
References: <20120902054335.GA12741@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two new functions: jiffies_to_ktime() and ktime_to_jiffies(), we'll use
them for timerfd deferred timers handling.

We fully reuse the logic from timespec implementations, so the functions
are pretty straightforward.

The only tricky part is in headers: we have to include jiffies.h after
we defined ktime_t, this is because ktime.h needs some declarations from
jiffies.h (e.g. TICK_NSEC).

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 include/linux/jiffies.h |  3 +++
 include/linux/ktime.h   |  3 ++-
 kernel/time.c           | 23 +++++++++++++++++++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 265e2c3..4451241 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <linux/time.h>
 #include <linux/timex.h>
+#include <linux/ktime.h>
 #include <asm/param.h>			/* for HZ */
 
 /*
@@ -303,6 +304,8 @@ extern void jiffies_to_timespec(const unsigned long jiffies,
 extern unsigned long timeval_to_jiffies(const struct timeval *value);
 extern void jiffies_to_timeval(const unsigned long jiffies,
 			       struct timeval *value);
+extern unsigned long ktime_to_jiffies(ktime_t *value);
+extern void jiffies_to_ktime(const unsigned long jiffies, ktime_t *value);
 extern clock_t jiffies_to_clock_t(unsigned long x);
 extern unsigned long clock_t_to_jiffies(unsigned long x);
 extern u64 jiffies_64_to_clock_t(u64 x);
diff --git a/include/linux/ktime.h b/include/linux/ktime.h
index 603bec2..9551856 100644
--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -22,7 +22,6 @@
 #define _LINUX_KTIME_H
 
 #include <linux/time.h>
-#include <linux/jiffies.h>
 
 /*
  * ktime_t:
@@ -58,6 +57,8 @@ union ktime {
 
 typedef union ktime ktime_t;		/* Kill this */
 
+#include <linux/jiffies.h>
+
 #define KTIME_MAX			((s64)~((u64)1 << 63))
 #if (BITS_PER_LONG == 64)
 # define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
diff --git a/kernel/time.c b/kernel/time.c
index ba744cf..82c06c5 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -29,6 +29,7 @@
 
 #include <linux/export.h>
 #include <linux/timex.h>
+#include <linux/ktime.h>
 #include <linux/capability.h>
 #include <linux/clocksource.h>
 #include <linux/errno.h>
@@ -566,6 +567,28 @@ void jiffies_to_timeval(const unsigned long jiffies, struct timeval *value)
 }
 EXPORT_SYMBOL(jiffies_to_timeval);
 
+unsigned long ktime_to_jiffies(ktime_t *value)
+{
+	struct timespec ts = ktime_to_timespec(*value);
+
+	/*
+	 * nsecs_to_jiffies(ktime_to_ns(*ktime)) is unsafe as nsecs_to_jiffies
+	 * doesn't handle MAX_JIFFY_OFFSET. So we reuse the logic from the
+	 * timespec to jiffies conversion function.
+	 */
+	return timespec_to_jiffies(&ts);
+}
+EXPORT_SYMBOL(ktime_to_jiffies);
+
+void jiffies_to_ktime(const unsigned long jiffies, ktime_t *value)
+{
+	struct timespec ts;
+
+	jiffies_to_timespec(jiffies, &ts);
+	*value = timespec_to_ktime(ts);
+}
+EXPORT_SYMBOL(jiffies_to_ktime);
+
 /*
  * Convert jiffies/jiffies_64 to clock_t and back.
  */
-- 
1.7.11.5

