Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab0FECxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 22:53:30 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:46514 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab0FECx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 22:53:29 -0400
From: John Stultz <johnstul@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Paul Mackerras <paulus@samba.org>,
       Anton Blanchard <anton@samba.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC][PATCH 2/6] powerpc: Cleanup xtime usage
Date: Fri,  4 Jun 2010 19:53:22 -0700
Message-Id: <1275706406-8111-3-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1275706406-8111-2-git-send-email-johnstul@us.ibm.com>
References: <1275706406-8111-1-git-send-email-johnstul@us.ibm.com>
 <1275706406-8111-2-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes powerpc's direct xtime usage, allowing for further
generic timeekeping cleanups

Compiled but otherwise untested.

Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: John Stultz <johnstul@us.ibm.com>
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
-- 
1.6.0.4

