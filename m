Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab2GaGgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 02:36:13 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41711 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827Ab2GaGgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 02:36:11 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zhouping Liu <zliu@redhat.com>,
        CAI Qian <caiqian@redhat.com>
Subject: [PATCH 1/2] [RFC] time: Fix problem with large timespecs & ktime_get_update_offsets
Date: Tue, 31 Jul 2012 02:35:47 -0400
Message-Id: <1343716548-38742-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343716548-38742-1-git-send-email-john.stultz@linaro.org>
References: <1343716548-38742-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073106-7182-0000-0000-0000021C2447
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's currently a slight difference in ktime_get_update_offsets()
vs ktime_get() which can result in boot time crashes when booting
with insane CMOS clock values larger then ~2264.

ktime_get() does basically the following:
        return timespec_to_ktime(timespec_add(xtime, wall_to_monotonic))

Where as ktime_get_update_offsets does approximately:
        return ktime_sub(timespec_to_ktime(xtime), realtime_offset);

The problem is, at boot we set xtime = year 8200 and
wall_to_monotonic = year -8200,  ktime_get adds both values, mostly
nulling the difference out (leaving only how long the system has been
up), then converts that relatively small value to a ktime_t properly
without losing any information.

ktime_get_update_offsets however, since it converts xtime (again set
to some value greater then year 8200), to a ktime, it gets clamped at
KTIME_MAX, then we subtract realtime_offset, which is _also_ clamped
at KTIME_MAX, resulting in us always returning almost[1] zero. This
causes us to stop expiring timers.

Now, one of the reasons Thomas and I changed the logic was that using
the precalculated realtime_offset was slightly more efficient then
re-adding xtime and wall_to_monotonic's components separately. But
how valuable this unmeasured slight efficiency is vs extra
robustness for crazy time values is questionable.

So switch back to the ktime_get implementation for
ktime_get_update_offsets

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Zhouping Liu <zliu@redhat.com>
Cc: CAI Qian <caiqian@redhat.com>
Reported-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 3447cfa..96179ab 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1283,15 +1283,15 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
  */
 ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot)
 {
-	ktime_t now;
 	unsigned int seq;
 	u64 secs, nsecs;
 
 	do {
 		seq = read_seqbegin(&timekeeper.lock);
-
-		secs = timekeeper.xtime.tv_sec;
-		nsecs = timekeeper.xtime.tv_nsec;
+		secs = timekeeper.xtime.tv_sec +
+				timekeeper.wall_to_monotonic.tv_sec;
+		nsecs = timekeeper.xtime.tv_nsec +
+				timekeeper.wall_to_monotonic.tv_nsec;
 		nsecs += timekeeping_get_ns();
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
@@ -1300,9 +1300,7 @@ ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot)
 		*offs_boot = timekeeper.offs_boot;
 	} while (read_seqretry(&timekeeper.lock, seq));
 
-	now = ktime_add_ns(ktime_set(secs, 0), nsecs);
-	now = ktime_sub(now, *offs_real);
-	return now;
+	return ktime_add_ns(ktime_set(secs, 0), nsecs);
 }
 #endif
 
-- 
1.7.9.5

