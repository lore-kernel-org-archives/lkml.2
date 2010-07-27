Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab0G0Kr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 06:47:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:35404 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab0G0Kr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 06:47:26 -0400
Date: Tue, 27 Jul 2010 10:47:10 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, johnstul@us.ibm.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, anton@samba.org,
        linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de
In-Reply-To: <1279068988-21864-6-git-send-email-johnstul@us.ibm.com>
References: <1279068988-21864-6-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/clocksource] powerpc: Cleanup xtime usage
Message-ID: <tip-06d518e3dfb25334282c7e38b4d7a4eada215f6d@git.kernel.org>
Git-Commit-ID: 06d518e3dfb25334282c7e38b4d7a4eada215f6d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 27 Jul 2010 10:47:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  06d518e3dfb25334282c7e38b4d7a4eada215f6d
Gitweb:     http://git.kernel.org/tip/06d518e3dfb25334282c7e38b4d7a4eada215f6d
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Tue, 13 Jul 2010 17:56:22 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 27 Jul 2010 12:40:54 +0200

powerpc: Cleanup xtime usage

This removes powerpc's direct xtime usage, allowing for further
generic timeekeping cleanups

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
LKML-Reference: <1279068988-21864-6-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/powerpc/kernel/time.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 6fcd648..0711d60 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -864,9 +864,9 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
 	/* XXX this assumes clock->shift == 22 */
 	/* 4611686018 ~= 2^(20+64-22) / 1e9 */
 	new_tb_to_xs = (u64) mult * 4611686018ULL;
-	new_stamp_xsec = (u64) xtime.tv_nsec * XSEC_PER_SEC;
+	new_stamp_xsec = (u64) wall_time->tv_nsec * XSEC_PER_SEC;
 	do_div(new_stamp_xsec, 1000000000);
-	new_stamp_xsec += (u64) xtime.tv_sec * XSEC_PER_SEC;
+	new_stamp_xsec += (u64) wall_time->tv_sec * XSEC_PER_SEC;
 
 	/*
 	 * tb_update_count is used to allow the userspace gettimeofday code
@@ -884,7 +884,7 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
 	vdso_data->tb_to_xs = new_tb_to_xs;
 	vdso_data->wtom_clock_sec = wall_to_monotonic.tv_sec;
 	vdso_data->wtom_clock_nsec = wall_to_monotonic.tv_nsec;
-	vdso_data->stamp_xtime = xtime;
+	vdso_data->stamp_xtime = *wall_time;
 	smp_wmb();
 	++(vdso_data->tb_update_count);
 }
@@ -1093,7 +1093,7 @@ void __init time_init(void)
 	vdso_data->tb_orig_stamp = tb_last_jiffy;
 	vdso_data->tb_update_count = 0;
 	vdso_data->tb_ticks_per_sec = tb_ticks_per_sec;
-	vdso_data->stamp_xsec = (u64) xtime.tv_sec * XSEC_PER_SEC;
+	vdso_data->stamp_xsec = (u64) get_seconds() * XSEC_PER_SEC;
 	vdso_data->tb_to_xs = tb_to_xs;
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
