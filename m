Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab2G0Sta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 14:49:30 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:59639 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab2G0Ssu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 14:48:50 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 2/5] jiffies: Rename ACTHZ to SHIFTED_HZ
Date: Fri, 27 Jul 2012 14:48:10 -0400
Message-Id: <1343414893-45779-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343414893-45779-1-git-send-email-john.stultz@linaro.org>
References: <1343414893-45779-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072718-1976-0000-0000-00000F953FE4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo noted that ACTHZ is a confusing name, and requested it
be renamed, so this patch renames ACTHZ to SHIFTED_HZ to
better describe it.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/jiffies.h |   21 +++++++++++++--------
 include/linux/timex.h   |    2 +-
 kernel/time/jiffies.c   |    2 +-
 kernel/time/ntp.c       |    2 +-
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 7d24466..8268054 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -55,21 +55,26 @@
 /* LATCH is used in the interval timer and ftape setup. */
 # define LATCH ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
 
-/* HZ is the requested value. ACTHZ is actual HZ ("<< 8" is for accuracy) */
-# define ACTHZ (SH_DIV(CLOCK_TICK_RATE, LATCH, 8))
+/*
+ * HZ is the requested value. However the CLOCK_TICK_RATE may not allow
+ * for exactly HZ. So SHIFTED_HZ is high res HZ ("<< 8" is for accuracy)
+ */
+# define SHIFTED_HZ (SH_DIV(CLOCK_TICK_RATE, LATCH, 8))
 #else
-# define ACTHZ (HZ << 8)
+# define SHIFTED_HZ (HZ << 8)
 #endif
 
-/* TICK_NSEC is the time between ticks in nsec assuming real ACTHZ */
-#define TICK_NSEC (SH_DIV (1000000UL * 1000, ACTHZ, 8))
+/* TICK_NSEC is the time between ticks in nsec assuming SHIFTED_HZ */
+#define TICK_NSEC (SH_DIV(1000000UL * 1000, SHIFTED_HZ, 8))
 
 /* TICK_USEC is the time between ticks in usec assuming fake USER_HZ */
 #define TICK_USEC ((1000000UL + USER_HZ/2) / USER_HZ)
 
-/* TICK_USEC_TO_NSEC is the time between ticks in nsec assuming real ACTHZ and	*/
-/* a value TUSEC for TICK_USEC (can be set bij adjtimex)		*/
-#define TICK_USEC_TO_NSEC(TUSEC) (SH_DIV (TUSEC * USER_HZ * 1000, ACTHZ, 8))
+/*
+ * TICK_USEC_TO_NSEC is the time between ticks in nsec assuming SHIFTED_HZ and
+ * a value TUSEC for TICK_USEC (can be set bij adjtimex)
+ */
+#define TICK_USEC_TO_NSEC(TUSEC) (SH_DIV(TUSEC * USER_HZ * 1000, SHIFTED_HZ, 8))
 
 /* some arch's have a small-data section that can be accessed register-relative
  * but that can only take up to, say, 4-byte variables. jiffies being part of
diff --git a/include/linux/timex.h b/include/linux/timex.h
index 99bc88b..7c5ceb2 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -232,7 +232,7 @@ struct timex {
  * estimated error = NTP dispersion.
  */
 extern unsigned long tick_usec;		/* USER_HZ period (usec) */
-extern unsigned long tick_nsec;		/* ACTHZ          period (nsec) */
+extern unsigned long tick_nsec;		/* SHIFTED_HZ period (nsec) */
 
 extern void ntp_init(void);
 extern void ntp_clear(void);
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index a470154..46da053 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -37,7 +37,7 @@
  * requested HZ value. It is also not recommended
  * for "tick-less" systems.
  */
-#define NSEC_PER_JIFFY	((u32)((((u64)NSEC_PER_SEC)<<8)/ACTHZ))
+#define NSEC_PER_JIFFY	((u32)((((u64)NSEC_PER_SEC)<<8)/SHIFTED_HZ))
 
 /* Since jiffies uses a simple NSEC_PER_JIFFY multiplier
  * conversion, the .shift value could be zero. However
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index b7fbadc..24174b4 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -28,7 +28,7 @@ DEFINE_SPINLOCK(ntp_lock);
 /* USER_HZ period (usecs): */
 unsigned long			tick_usec = TICK_USEC;
 
-/* ACTHZ period (nsecs): */
+/* SHIFTED_HZ period (nsecs): */
 unsigned long			tick_nsec;
 
 static u64			tick_length;
-- 
1.7.9.5

