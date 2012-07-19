Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab2GSBUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:20:18 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:53755 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab2GSBTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:19:48 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 1/2] jiffies: Allow CLOCK_TICK_RATE to be undefined
Date: Wed, 18 Jul 2012 21:19:12 -0400
Message-Id: <1342660753-10382-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342660753-10382-1-git-send-email-john.stultz@linaro.org>
References: <1342660753-10382-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071901-2398-0000-0000-0000089CA715
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

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
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
[jstultz: commit log tweaks]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/jiffies.h |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 265e2c3..a2134be 100644
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
+#define LATCH ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
+
 /* HZ is the requested value. ACTHZ is actual HZ ("<< 8" is for accuracy) */
 #define ACTHZ (SH_DIV (CLOCK_TICK_RATE, LATCH, 8))
+#else
+#define ACTHZ (HZ << 8)
+#endif
 
 /* TICK_NSEC is the time between ticks in nsec assuming real ACTHZ */
 #define TICK_NSEC (SH_DIV (1000000UL * 1000, ACTHZ, 8))
-- 
1.7.9.5

