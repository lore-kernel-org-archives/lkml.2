Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab2IQWF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 18:05:57 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45855 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757324Ab2IQWFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 18:05:22 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Tony Luck <tony.luck@intel.com>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Turner <pjt@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4/6][RFC] time: Introduce new GENERIC_TIME_VSYSCALL
Date: Mon, 17 Sep 2012 18:04:59 -0400
Message-Id: <1347919501-64534-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
References: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
x-cbid: 12091722-3534-0000-0000-00000CD52F22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we moved everyone over to GENERIC_TIME_VSYSCALL_OLD,
introduce the new declaration and config option for the new
update_vsyscall method.

Cc: Tony Luck <tony.luck@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Turner <pjt@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/timekeeper_internal.h |   36 ++++++++++++++++++++++++++++-------
 kernel/time/Kconfig                 |    4 ++++
 kernel/time/timekeeping.c           |   14 +-------------
 3 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
index a904d76..8896471 100644
--- a/include/linux/timekeeper_internal.h
+++ b/include/linux/timekeeper_internal.h
@@ -66,16 +66,38 @@ struct timekeeper {
 	seqlock_t		lock;
 };
 
+static inline struct timespec tk_xtime(struct timekeeper *tk)
+{
+	struct timespec ts;
+
+	ts.tv_sec = tk->xtime_sec;
+	ts.tv_nsec = (long)(tk->xtime_nsec >> tk->shift);
+	return ts;
+}
+
+
+#ifdef CONFIG_GENERIC_TIME_VSYSCALL
+
+extern void update_vsyscall(struct timekeeper *tk);
+extern void update_vsyscall_tz(void);
 
-#ifdef CONFIG_GENERIC_TIME_VSYSCALL_OLD
-extern void
-update_vsyscall_old(struct timespec *ts, struct timespec *wtm,
-			struct clocksource *c, u32 mult);
+#elif defined(CONFIG_GENERIC_TIME_VSYSCALL_OLD)
+
+extern void update_vsyscall_old(struct timespec *ts, struct timespec *wtm,
+				struct clocksource *c, u32 mult);
 extern void update_vsyscall_tz(void);
+
+static inline void update_vsyscall(struct timekeeper *tk)
+{
+	struct timespec xt;
+
+	xt = tk_xtime(tk);
+	update_vsyscall_old(&xt, &tk->wall_to_monotonic, tk->clock, tk->mult);
+}
+
 #else
-static inline void
-update_vsyscall_old(struct timespec *ts, struct timespec *wtm,
-					struct clocksource *c, u32 mult)
+
+static inline void update_vsyscall(struct timekeeper *tk);
 {
 }
 static inline void update_vsyscall_tz(void)
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 489c861..8601f0d 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -13,6 +13,10 @@ config ARCH_CLOCKSOURCE_DATA
 	bool
 
 # Timekeeping vsyscall support
+config GENERIC_TIME_VSYSCALL
+	bool
+
+# Timekeeping vsyscall support
 config GENERIC_TIME_VSYSCALL_OLD
 	bool
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index bdce688..61eaf3b 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -42,15 +42,6 @@ static inline void tk_normalize_xtime(struct timekeeper *tk)
 	}
 }
 
-static struct timespec tk_xtime(struct timekeeper *tk)
-{
-	struct timespec ts;
-
-	ts.tv_sec = tk->xtime_sec;
-	ts.tv_nsec = (long)(tk->xtime_nsec >> tk->shift);
-	return ts;
-}
-
 static void tk_set_xtime(struct timekeeper *tk, const struct timespec *ts)
 {
 	tk->xtime_sec = ts->tv_sec;
@@ -192,14 +183,11 @@ static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
 /* must hold write on timekeeper.lock */
 static void timekeeping_update(struct timekeeper *tk, bool clearntp)
 {
-	struct timespec xt;
-
 	if (clearntp) {
 		tk->ntp_error = 0;
 		ntp_clear();
 	}
-	xt = tk_xtime(tk);
-	update_vsyscall_old(&xt, &tk->wall_to_monotonic, tk->clock, tk->mult);
+	update_vsyscall(tk);
 }
 
 /**
-- 
1.7.9.5

