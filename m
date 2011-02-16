Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685Ab1BPEU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 23:20:27 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56420 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592Ab1BPEUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 23:20:14 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Jamie Lokier <jamie@shareable.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <virtuoso@slind.org>,
        =?UTF-8?q?Arve=20Hj=C3=83=C2=B8nnev=C3=83=C2=A5g?= 
	<arve@android.com>
Subject: [PATCH 5/5] timers: Export CLOCK_BOOTTIME via the posix timers interface
Date: Tue, 15 Feb 2011 20:20:07 -0800
Message-Id: <1297830007-426-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1297830007-426-1-git-send-email-john.stultz@linaro.org>
References: <1297830007-426-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exports CLOCK_BOOTTIME through the posix timers interface

CC: Jamie Lokier <jamie@shareable.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alexander Shishkin <virtuoso@slind.org>
CC: Arve HjÃ¸nnevÃ¥g <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/posix-timers.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 44fcff1..4c01249 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -187,7 +187,7 @@ static int posix_ktime_get_ts(clockid_t which_clock, struct timespec *tp)
 }
 
 /*
- * Get monotonic time for posix timers
+ * Get monotonic-raw time for posix timers
  */
 static int posix_get_monotonic_raw(clockid_t which_clock, struct timespec *tp)
 {
@@ -214,6 +214,14 @@ static int posix_get_coarse_res(const clockid_t which_clock, struct timespec *tp
 	*tp = ktime_to_timespec(KTIME_LOW_RES);
 	return 0;
 }
+
+static int posix_get_boottime(const clockid_t which_clock, struct timespec *tp)
+{
+	get_monotonic_boottime(tp);
+	return 0;
+}
+
+
 /*
  * Initialize everything, well, just everything in Posix clocks/timers ;)
  */
@@ -253,12 +261,23 @@ static __init int init_posix_timers(void)
 		.clock_getres	= posix_get_coarse_res,
 		.clock_get	= posix_get_monotonic_coarse,
 	};
+	struct k_clock clock_boottime = {
+		.clock_getres	= hrtimer_get_res,
+		.clock_get	= posix_get_boottime,
+		.nsleep		= common_nsleep,
+		.nsleep_restart	= hrtimer_nanosleep_restart,
+		.timer_create	= common_timer_create,
+		.timer_set	= common_timer_set,
+		.timer_get	= common_timer_get,
+		.timer_del	= common_timer_del,
+	};
 
 	posix_timers_register_clock(CLOCK_REALTIME, &clock_realtime);
 	posix_timers_register_clock(CLOCK_MONOTONIC, &clock_monotonic);
 	posix_timers_register_clock(CLOCK_MONOTONIC_RAW, &clock_monotonic_raw);
 	posix_timers_register_clock(CLOCK_REALTIME_COARSE, &clock_realtime_coarse);
 	posix_timers_register_clock(CLOCK_MONOTONIC_COARSE, &clock_monotonic_coarse);
+	posix_timers_register_clock(CLOCK_BOOTTIME, &clock_boottime);
 
 	posix_timers_cache = kmem_cache_create("posix_timers_cache",
 					sizeof (struct k_itimer), 0, SLAB_PANIC,
-- 
1.7.3.2.146.gca209

