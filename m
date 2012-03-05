Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803Ab2CEXZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 18:25:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52073 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757677Ab2CEXZQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 18:25:16 -0500
Message-ID: <1330989903.11248.261.camel@twins>
Subject: Re: Inconsistent load average on tickless kernels
From: Peter Zijlstra <peterz@infradead.org>
To: Aman Gupta <aman@tmm1.net>
Cc: =?UTF-8?Q?Les=C5=82aw_Kope=C4=87?= <leslaw.kopec@nasza-klasa.pl>,
        linux-kernel@vger.kernel.org,
        Chase Douglas <chase.douglas@canonical.com>,
        Damien Wyart <damien.wyart@free.fr>, Kyle McMartin <kyle@redhat.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Doug Smythies <dsmythies@telus.net>
Date: Tue, 06 Mar 2012 00:25:03 +0100
In-Reply-To: <CAK=uwuxvzGwes4ffy9EXVReG95U3HQaKmPPKgFnHzo_MwaO_NA@mail.gmail.com>
References: <CAK=uwuy80LaNdQ4P49i+bGUXFvxf1zB=oKqNBTdAyvFc+mOTyw@mail.gmail.com>
	 <4F465F6E.9070605@nasza-klasa.pl> <1330517195.11248.148.camel@twins>
	 <1330532667.11248.153.camel@twins> <1330534998.11248.158.camel@twins>
	 <4F551ABE.5080605@nasza-klasa.pl>
	 <CAK=uwuxvzGwes4ffy9EXVReG95U3HQaKmPPKgFnHzo_MwaO_NA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug actually spotted the problem and reported it off-list.

The below patch appears to sort the issue, but I haven't been able to
test the very long idle path simply because x86 doesn't go idle that
long.

I tried writing hpet64 support so we could idle that long, killed all
kinds of stupid kernel threads (watchdogs mostly) that keep waking up
and got a brick..

Clearly I need to try again... but I thought I'd at least share this
stuff.



---

Subject: sched: Fix nohz load accounting -- again!
From: Peter Zijlstra <peterz@infradead.org>
Date: Thu, 01 Mar 2012 15:04:46 +0100

Various people reported nohz load tracking still being wrecked, but Doug
spotted the actual problem. We fold the nohz remainder in too soon,
causing us to loose samples and under-account.

So instead of playing catch-up up-front, always do a single load-fold
with whatever state we encounter and only then fold the nohz remainder
and play catch-up.

Reported-by: Doug Smythies <dsmythies@telus.net>
Reported-by: Les�=82aw Kope=C4=87 <leslaw.kopec@nasza-klasa.pl>
Reported-by: Aman Gupta <aman@tmm1.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched/core.c |   53 +++++++++++++++++++++++++--------------------------
 1 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b83e8d0..6ffde97 100644
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


