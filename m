Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab2CMEsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 00:48:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35256 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab2CMEsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 00:48:47 -0400
Date: Mon, 12 Mar 2012 21:48:16 -0700
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-4v31etnhgg9kwd6ocgx3rxl8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, peterz@infradead.org, aman@tmm1.net,
        leslaw.kopec@nasza-klasa.pl, dsmythies@telus.net, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, aman@tmm1.net,
        leslaw.kopec@nasza-klasa.pl, dsmythies@telus.net, tglx@linutronix.de,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix nohz load accounting -- again!
Git-Commit-ID: c308b56b5398779cd3da0f62ab26b0453494c3d4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 12 Mar 2012 21:48:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c308b56b5398779cd3da0f62ab26b0453494c3d4
Gitweb:     http://git.kernel.org/tip/c308b56b5398779cd3da0f62ab26b0453494c3d4
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 1 Mar 2012 15:04:46 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Mar 2012 20:43:17 +0100

sched: Fix nohz load accounting -- again!

Various people reported nohz load tracking still being wrecked, but Doug
spotted the actual problem. We fold the nohz remainder in too soon,
causing us to loose samples and under-account.

So instead of playing catch-up up-front, always do a single load-fold
with whatever state we encounter and only then fold the nohz remainder
and play catch-up.

Reported-by: Doug Smythies <dsmythies@telus.net>
Reported-by: LesÅ=82aw Kope=C4=87 <leslaw.kopec@nasza-klasa.pl>
Reported-by: Aman Gupta <aman@tmm1.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-4v31etnhgg9kwd6ocgx3rxl8@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/core.c |   53 +++++++++++++++++++++++++--------------------------
 1 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 47614a5..e3ccc13 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2266,13 +2266,10 @@ calc_load_n(unsigned long load, unsigned long exp,
  * Once we've updated the global active value, we need to apply the exponential
  * weights adjusted to the number of cycles missed.
  */
-static void calc_global_nohz(unsigned long ticks)
+static void calc_global_nohz(void)
 {
 	long delta, active, n;
 
-	if (time_before(jiffies, calc_load_update))
-		return;
-
 	/*
 	 * If we crossed a calc_load_update boundary, make sure to fold
 	 * any pending idle changes, the respective CPUs might have
@@ -2284,31 +2281,25 @@ static void calc_global_nohz(unsigned long ticks)
 		atomic_long_add(delta, &calc_load_tasks);
 
 	/*
-	 * If we were idle for multiple load cycles, apply them.
+	 * It could be the one fold was all it took, we done!
 	 */
-	if (ticks >= LOAD_FREQ) {
-		n = ticks / LOAD_FREQ;
+	if (time_before(jiffies, calc_load_update + 10))
+		return;
 
-		active = atomic_long_read(&calc_load_tasks);
-		active = active > 0 ? active * FIXED_1 : 0;
+	/*
+	 * Catch-up, fold however many we are behind still
+	 */
+	delta = jiffies - calc_load_update - 10;
+	n = 1 + (delta / LOAD_FREQ);
 
-		avenrun[0] = calc_load_n(avenrun[0], EXP_1, active, n);
-		avenrun[1] = calc_load_n(avenrun[1], EXP_5, active, n);
-		avenrun[2] = calc_load_n(avenrun[2], EXP_15, active, n);
+	active = atomic_long_read(&calc_load_tasks);
+	active = active > 0 ? active * FIXED_1 : 0;
 
-		calc_load_update += n * LOAD_FREQ;
-	}
+	avenrun[0] = calc_load_n(avenrun[0], EXP_1, active, n);
+	avenrun[1] = calc_load_n(avenrun[1], EXP_5, active, n);
+	avenrun[2] = calc_load_n(avenrun[2], EXP_15, active, n);
 
-	/*
-	 * Its possible the remainder of the above division also crosses
-	 * a LOAD_FREQ period, the regular check in calc_global_load()
-	 * which comes after this will take care of that.
-	 *
-	 * Consider us being 11 ticks before a cycle completion, and us
-	 * sleeping for 4*LOAD_FREQ + 22 ticks, then the above code will
-	 * age us 4 cycles, and the test in calc_global_load() will
-	 * pick up the final one.
-	 */
+	calc_load_update += n * LOAD_FREQ;
 }
 #else
 void calc_load_account_idle(struct rq *this_rq)
@@ -2320,7 +2311,7 @@ static inline long calc_load_fold_idle(void)
 	return 0;
 }
 
-static void calc_global_nohz(unsigned long ticks)
+static void calc_global_nohz(void)
 {
 }
 #endif
@@ -2348,8 +2339,6 @@ void calc_global_load(unsigned long ticks)
 {
 	long active;
 
-	calc_global_nohz(ticks);
-
 	if (time_before(jiffies, calc_load_update + 10))
 		return;
 
@@ -2361,6 +2350,16 @@ void calc_global_load(unsigned long ticks)
 	avenrun[2] = calc_load(avenrun[2], EXP_15, active);
 
 	calc_load_update += LOAD_FREQ;
+
+	/*
+	 * Account one period with whatever state we found before
+	 * folding in the nohz state and ageing the entire idle period.
+	 *
+	 * This avoids loosing a sample when we go idle between 
+	 * calc_load_account_active() (10 ticks ago) and now and thus
+	 * under-accounting.
+	 */
+	calc_global_nohz();
 }
 
 /*
