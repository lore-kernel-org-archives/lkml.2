Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab2IQWFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 18:05:23 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52905 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123Ab2IQWFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 18:05:20 -0400
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
Subject: [PATCH 5/6][RFC] time: Only do nanosecond rounding on GENERIC_TIME_VSYSCALL_OLD systems
Date: Mon, 17 Sep 2012 18:05:00 -0400
Message-Id: <1347919501-64534-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
References: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
x-cbid: 12091722-1976-0000-0000-0000117577B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only do rounding to the next nanosecond so we don't see minor
1ns inconsistencies in the vsyscall implementations. Since we're
changing the vsyscall implementations to avoid this, conditionalize
the rounding only to the GENERIC_TIME_VSYSCALL_OLD architectures.

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
 kernel/time/timekeeping.c |   45 +++++++++++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 61eaf3b..b976692 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1059,6 +1059,33 @@ static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
 	return offset;
 }
 
+#ifdef CONFIG_GENERIC_TIME_VSYSCALL_OLD
+static inline void old_vsyscall_fixup(struct timekeeper *tk)
+{
+	s64 remainder;
+
+	/*
+	* Store only full nanoseconds into xtime_nsec after rounding
+	* it up and add the remainder to the error difference.
+	* XXX - This is necessary to avoid small 1ns inconsistnecies caused
+	* by truncating the remainder in vsyscalls. However, it causes
+	* additional work to be done in timekeeping_adjust(). Once
+	* the vsyscall implementations are converted to use xtime_nsec
+	* (shifted nanoseconds), and CONFIG_GENERIC_TIME_VSYSCALL_OLD
+	* users are removed, this can be killed.
+	*/
+	remainder = tk->xtime_nsec & ((1ULL << tk->shift) - 1);
+	tk->xtime_nsec -= remainder;
+	tk->xtime_nsec += 1ULL << tk->shift;
+	tk->ntp_error += remainder << tk->ntp_error_shift;
+
+}
+#else
+#define old_vsyscall_fixup(tk)
+#endif
+
+
+
 /**
  * update_wall_time - Uses the current clocksource to increment the wall time
  *
@@ -1070,7 +1097,6 @@ static void update_wall_time(void)
 	cycle_t offset;
 	int shift = 0, maxshift;
 	unsigned long flags;
-	s64 remainder;
 
 	write_seqlock_irqsave(&tk->lock, flags);
 
@@ -1112,20 +1138,11 @@ static void update_wall_time(void)
 	/* correct the clock when NTP error is too big */
 	timekeeping_adjust(tk, offset);
 
-
 	/*
-	* Store only full nanoseconds into xtime_nsec after rounding
-	* it up and add the remainder to the error difference.
-	* XXX - This is necessary to avoid small 1ns inconsistnecies caused
-	* by truncating the remainder in vsyscalls. However, it causes
-	* additional work to be done in timekeeping_adjust(). Once
-	* the vsyscall implementations are converted to use xtime_nsec
-	* (shifted nanoseconds), this can be killed.
-	*/
-	remainder = tk->xtime_nsec & ((1ULL << tk->shift) - 1);
-	tk->xtime_nsec -= remainder;
-	tk->xtime_nsec += 1ULL << tk->shift;
-	tk->ntp_error += remainder << tk->ntp_error_shift;
+	 * XXX This can be killed once everyone converts
+	 * to the new update_vsyscall.
+	 */
+	old_vsyscall_fixup(tk);
 
 	/*
 	 * Finally, make sure that after the rounding
-- 
1.7.9.5

