Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab2GaSAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 14:00:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59327 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab2GaSA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 14:00:28 -0400
Date: Tue, 31 Jul 2012 11:00:16 -0700
From: tip-bot for John Stultz <john.stultz@linaro.org>
Message-ID: <tip-02ab20ae38337b99b5c29c81090f594b8fd61283@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, prarit@redhat.com
In-Reply-To: <1343414893-45779-3-git-send-email-john.stultz@linaro.org>
References: <1343414893-45779-3-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] time/jiffies: Rename ACTHZ to SHIFTED_HZ
Git-Commit-ID: 02ab20ae38337b99b5c29c81090f594b8fd61283
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 31 Jul 2012 11:00:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  02ab20ae38337b99b5c29c81090f594b8fd61283
Gitweb:     http://git.kernel.org/tip/02ab20ae38337b99b5c29c81090f594b8fd61283
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Fri, 27 Jul 2012 14:48:10 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 31 Jul 2012 17:09:12 +0200

time/jiffies: Rename ACTHZ to SHIFTED_HZ

Ingo noted that ACTHZ is a confusing name, and requested it
be renamed, so this patch renames ACTHZ to SHIFTED_HZ to
better describe it.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1343414893-45779-3-git-send-email-john.stultz@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
