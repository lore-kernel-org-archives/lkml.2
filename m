Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab0FECxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 22:53:32 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41367 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085Ab0FECx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 22:53:29 -0400
From: John Stultz <johnstul@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Anton Blanchard <anton@samba.org>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC][PATCH 1/6] powerpc: Simplify update_vsyscall
Date: Fri,  4 Jun 2010 19:53:21 -0700
Message-Id: <1275706406-8111-2-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1275706406-8111-1-git-send-email-johnstul@us.ibm.com>
References: <1275706406-8111-1-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently powerpc's update_vsyscall calls an inline update_gtod.
However, both are straightforward, and there are no other users,
so this patch merges update_gtod into update_vsyscall.

Compiles, but otherwise untested.

Cc: Anton Blanchard <anton@samba.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/powerpc/kernel/time.c |   55 ++++++++++++++++++++------------------------
 1 files changed, 25 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 0441bbd..6fcd648 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -423,30 +423,6 @@ void udelay(unsigned long usecs)
 }
 EXPORT_SYMBOL(udelay);
 
-static inline void update_gtod(u64 new_tb_stamp, u64 new_stamp_xsec,
-			       u64 new_tb_to_xs)
-{
-	/*
-	 * tb_update_count is used to allow the userspace gettimeofday code
-	 * to assure itself that it sees a consistent view of the tb_to_xs and
-	 * stamp_xsec variables.  It reads the tb_update_count, then reads
-	 * tb_to_xs and stamp_xsec and then reads tb_update_count again.  If
-	 * the two values of tb_update_count match and are even then the
-	 * tb_to_xs and stamp_xsec values are consistent.  If not, then it
-	 * loops back and reads them again until this criteria is met.
-	 * We expect the caller to have done the first increment of
-	 * vdso_data->tb_update_count already.
-	 */
-	vdso_data->tb_orig_stamp = new_tb_stamp;
-	vdso_data->stamp_xsec = new_stamp_xsec;
-	vdso_data->tb_to_xs = new_tb_to_xs;
-	vdso_data->wtom_clock_sec = wall_to_monotonic.tv_sec;
-	vdso_data->wtom_clock_nsec = wall_to_monotonic.tv_nsec;
-	vdso_data->stamp_xtime = xtime;
-	smp_wmb();
-	++(vdso_data->tb_update_count);
-}
-
 #ifdef CONFIG_SMP
 unsigned long profile_pc(struct pt_regs *regs)
 {
@@ -876,7 +852,7 @@ static cycle_t timebase_read(struct clocksource *cs)
 void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
 		     u32 mult)
 {
-	u64 t2x, stamp_xsec;
+	u64 new_tb_to_xs, new_stamp_xsec;
 
 	if (clock != &clocksource_timebase)
 		return;
@@ -887,11 +863,30 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
 
 	/* XXX this assumes clock->shift == 22 */
 	/* 4611686018 ~= 2^(20+64-22) / 1e9 */
-	t2x = (u64) mult * 4611686018ULL;
-	stamp_xsec = (u64) xtime.tv_nsec * XSEC_PER_SEC;
-	do_div(stamp_xsec, 1000000000);
-	stamp_xsec += (u64) xtime.tv_sec * XSEC_PER_SEC;
-	update_gtod(clock->cycle_last, stamp_xsec, t2x);
+	new_tb_to_xs = (u64) mult * 4611686018ULL;
+	new_stamp_xsec = (u64) xtime.tv_nsec * XSEC_PER_SEC;
+	do_div(new_stamp_xsec, 1000000000);
+	new_stamp_xsec += (u64) xtime.tv_sec * XSEC_PER_SEC;
+
+	/*
+	 * tb_update_count is used to allow the userspace gettimeofday code
+	 * to assure itself that it sees a consistent view of the tb_to_xs and
+	 * stamp_xsec variables.  It reads the tb_update_count, then reads
+	 * tb_to_xs and stamp_xsec and then reads tb_update_count again.  If
+	 * the two values of tb_update_count match and are even then the
+	 * tb_to_xs and stamp_xsec values are consistent.  If not, then it
+	 * loops back and reads them again until this criteria is met.
+	 * We expect the caller to have done the first increment of
+	 * vdso_data->tb_update_count already.
+	 */
+	vdso_data->tb_orig_stamp = clock->cycle_last;
+	vdso_data->stamp_xsec = new_stamp_xsec;
+	vdso_data->tb_to_xs = new_tb_to_xs;
+	vdso_data->wtom_clock_sec = wall_to_monotonic.tv_sec;
+	vdso_data->wtom_clock_nsec = wall_to_monotonic.tv_nsec;
+	vdso_data->stamp_xtime = xtime;
+	smp_wmb();
+	++(vdso_data->tb_update_count);
 }
 
 void update_vsyscall_tz(void)
-- 
1.6.0.4

