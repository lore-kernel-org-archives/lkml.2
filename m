Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab2EIF4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:56:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39197 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756864Ab2EIFxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:55 -0400
Message-Id: <20120509055047.976113883@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:42 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Zijlstra <peterz@infradead.org>,
        Doug Smythies <dsmythies@telus.net>,
        =?ISO-8859-15?q?Les=C3=85=82aw=20Kope=C4=87?= 
	<leslaw.kopec@nasza-klasa.pl>,
        Aman Gupta <aman@tmm1.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Subject: [ 133/167] [PATCH] sched: Fix nohz load accounting -- again!
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit c308b56b5398779cd3da0f62ab26b0453494c3d4 upstream.

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
[bwh: Backported to 3.2: change filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/sched.c |   53 +++++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -3538,13 +3538,10 @@
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
@@ -3556,31 +3553,25 @@
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
 static void calc_load_account_idle(struct rq *this_rq)
@@ -3592,7 +3583,7 @@
 	return 0;
 }
 
-static void calc_global_nohz(unsigned long ticks)
+static void calc_global_nohz(void)
 {
 }
 #endif
@@ -3620,8 +3611,6 @@
 {
 	long active;
 
-	calc_global_nohz(ticks);
-
 	if (time_before(jiffies, calc_load_update + 10))
 		return;
 
@@ -3633,6 +3622,16 @@
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


