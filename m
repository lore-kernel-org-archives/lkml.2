Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab2GaR7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 13:59:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59300 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab2GaR7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 13:59:50 -0400
Date: Tue, 31 Jul 2012 10:59:22 -0700
From: tip-bot for Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <tip-a7ea3bbf5d58f4df2265d312f91d5769eabc8144@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        catalin.marinas@arm.com, richardcochran@gmail.com,
        john.stultz@linaro.org, arnd@arndb.de, akpm@linux-foundation.org,
        tglx@linutronix.de, prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, richardcochran@gmail.com,
        john.stultz@linaro.org, arnd@arndb.de, akpm@linux-foundation.org,
        tglx@linutronix.de, prarit@redhat.com
In-Reply-To: <1343414893-45779-2-git-send-email-john.stultz@linaro.org>
References: <1343414893-45779-2-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] time/jiffies:
  Allow CLOCK_TICK_RATE to be undefined
Git-Commit-ID: a7ea3bbf5d58f4df2265d312f91d5769eabc8144
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 31 Jul 2012 10:59:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7ea3bbf5d58f4df2265d312f91d5769eabc8144
Gitweb:     http://git.kernel.org/tip/a7ea3bbf5d58f4df2265d312f91d5769eabc8144
Author:     Catalin Marinas <catalin.marinas@arm.com>
AuthorDate: Fri, 27 Jul 2012 14:48:09 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 31 Jul 2012 17:09:12 +0200

time/jiffies: Allow CLOCK_TICK_RATE to be undefined

CLOCK_TICK_RATE is a legacy constant that defines the timer
device's granularity. On hardware with particularly coarse
granularity, this constant is used to reduce accumulated
time error when using jiffies as a clocksource, by calculating
the hardware's actual tick length rather then just assuming
it is 1sec/HZ.

However, for the most part this is unnecessary, as most modern
systems don't use jiffies for their clocksource, and their
tick device is sufficiently fine grained to avoid major error.

Thus, this patch allows an architecture to not define
CLOCK_TICK_RATE, in which case ACTHZ defaults to (HZ << 8).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
[ Commit log & intention tweaks ]
Signed-off-by: John Stultz <john.stultz@linaro.org>
Link: http://lkml.kernel.org/r/1343414893-45779-2-git-send-email-john.stultz@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/jiffies.h |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 265e2c3..7d24466 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -39,9 +39,6 @@
 # error Invalid value of HZ.
 #endif
 
-/* LATCH is used in the interval timer and ftape setup. */
-#define LATCH  ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
-
 /* Suppose we want to divide two numbers NOM and DEN: NOM/DEN, then we can
  * improve accuracy by shifting LSH bits, hence calculating:
  *     (NOM << LSH) / DEN
@@ -54,8 +51,15 @@
 #define SH_DIV(NOM,DEN,LSH) (   (((NOM) / (DEN)) << (LSH))              \
                              + ((((NOM) % (DEN)) << (LSH)) + (DEN) / 2) / (DEN))
 
+#ifdef CLOCK_TICK_RATE
+/* LATCH is used in the interval timer and ftape setup. */
+# define LATCH ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
+
 /* HZ is the requested value. ACTHZ is actual HZ ("<< 8" is for accuracy) */
-#define ACTHZ (SH_DIV (CLOCK_TICK_RATE, LATCH, 8))
+# define ACTHZ (SH_DIV(CLOCK_TICK_RATE, LATCH, 8))
+#else
+# define ACTHZ (HZ << 8)
+#endif
 
 /* TICK_NSEC is the time between ticks in nsec assuming real ACTHZ */
 #define TICK_NSEC (SH_DIV (1000000UL * 1000, ACTHZ, 8))
