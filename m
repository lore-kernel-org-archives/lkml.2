Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab0G0KrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 06:47:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:35390 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab0G0KrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 06:47:07 -0400
Date: Tue, 27 Jul 2010 10:46:51 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, anton@samba.org,
        hpa@zytor.com, mingo@redhat.com, johnstul@us.ibm.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org, paulus@samba.org,
        linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de
In-Reply-To: <1279068988-21864-5-git-send-email-johnstul@us.ibm.com>
References: <1279068988-21864-5-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/clocksource] powerpc: Simplify update_vsyscall
Message-ID: <tip-b0797b60d0067fe437baa97a743c7d9de98fd769@git.kernel.org>
Git-Commit-ID: b0797b60d0067fe437baa97a743c7d9de98fd769
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 27 Jul 2010 10:46:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b0797b60d0067fe437baa97a743c7d9de98fd769
Gitweb:     http://git.kernel.org/tip/b0797b60d0067fe437baa97a743c7d9de98fd769
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Tue, 13 Jul 2010 17:56:21 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 27 Jul 2010 12:40:54 +0200

powerpc: Simplify update_vsyscall

Currently powerpc's update_vsyscall calls an inline update_gtod.
However, both are straightforward, and there are no other users,
so this patch merges update_gtod into update_vsyscall.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1279068988-21864-5-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
