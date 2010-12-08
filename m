Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0LHUkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:40:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:34207 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756582Ab0LHUkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:40:53 -0500
Date: Wed, 8 Dec 2010 20:40:19 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, orion@cora.nwra.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, kyle@mcmartin.ca,
        damien.wyart@free.fr, chase.douglas@canonical.com, tglx@linutronix.de,
        mingo@elte.hu, tmhikaru@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, orion@cora.nwra.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, kyle@mcmartin.ca,
        damien.wyart@free.fr, chase.douglas@canonical.com, tglx@linutronix.de,
        tmhikaru@gmail.com, mingo@elte.hu
In-Reply-To: <1291129145.32004.874.camel@laptop>
References: <1291129145.32004.874.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Cure more NO_HZ load average woes
Message-ID: <tip-0f004f5a696a9434b7214d0d3cbd0525ee77d428@git.kernel.org>
Git-Commit-ID: 0f004f5a696a9434b7214d0d3cbd0525ee77d428
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Dec 2010 20:40:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f004f5a696a9434b7214d0d3cbd0525ee77d428
Gitweb:     http://git.kernel.org/tip/0f004f5a696a9434b7214d0d3cbd0525ee77d428
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 30 Nov 2010 19:48:45 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Dec 2010 20:15:04 +0100

sched: Cure more NO_HZ load average woes

There's a long-running regression that proved difficult to fix and
which is hitting certain people and is rather annoying in its effects.

Damien reported that after 74f5187ac8 (sched: Cure load average vs
NO_HZ woes) his load average is unnaturally high, he also noted that
even with that patch reverted the load avgerage numbers are not
correct.

The problem is that the previous patch only solved half the NO_HZ
problem, it addressed the part of going into NO_HZ mode, not of
comming out of NO_HZ mode. This patch implements that missing half.

When comming out of NO_HZ mode there are two important things to take
care of:

 - Folding the pending idle delta into the global active count.
 - Correctly aging the averages for the idle-duration.

So with this patch the NO_HZ interaction should be complete and
behaviour between CONFIG_NO_HZ=[yn] should be equivalent.

Furthermore, this patch slightly changes the load average computation
by adding a rounding term to the fixed point multiplication.

Reported-by: Damien Wyart <damien.wyart@free.fr>
Reported-by: Tim McGrath <tmhikaru@gmail.com>
Tested-by: Damien Wyart <damien.wyart@free.fr>
Tested-by: Orion Poplawski <orion@cora.nwra.com>
Tested-by: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stable@kernel.org
Cc: Chase Douglas <chase.douglas@canonical.com>
LKML-Reference: <1291129145.32004.874.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    2 +-
 kernel/sched.c        |  150 +++++++++++++++++++++++++++++++++++++++++++++----
 kernel/timer.c        |    2 +-
 3 files changed, 141 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2c79e92..2238745 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -143,7 +143,7 @@ extern unsigned long nr_iowait_cpu(int cpu);
 extern unsigned long this_cpu_load(void);
 
 
-extern void calc_global_load(void);
+extern void calc_global_load(unsigned long ticks);
 
 extern unsigned long get_parent_ip(unsigned long addr);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index dc91a4d..6b7c26a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3119,6 +3119,15 @@ static long calc_load_fold_active(struct rq *this_rq)
 	return delta;
 }
 
+static unsigned long
+calc_load(unsigned long load, unsigned long exp, unsigned long active)
+{
+	load *= exp;
+	load += active * (FIXED_1 - exp);
+	load += 1UL << (FSHIFT - 1);
+	return load >> FSHIFT;
+}
+
 #ifdef CONFIG_NO_HZ
 /*
  * For NO_HZ we delay the active fold to the next LOAD_FREQ update.
@@ -3148,6 +3157,128 @@ static long calc_load_fold_idle(void)
 
 	return delta;
 }
+
+/**
+ * fixed_power_int - compute: x^n, in O(log n) time
+ *
+ * @x:         base of the power
+ * @frac_bits: fractional bits of @x
+ * @n:         power to raise @x to.
+ *
+ * By exploiting the relation between the definition of the natural power
+ * function: x^n := x*x*...*x (x multiplied by itself for n times), and
+ * the binary encoding of numbers used by computers: n := \Sum n_i * 2^i,
+ * (where: n_i \elem {0, 1}, the binary vector representing n),
+ * we find: x^n := x^(\Sum n_i * 2^i) := \Prod x^(n_i * 2^i), which is
+ * of course trivially computable in O(log_2 n), the length of our binary
+ * vector.
+ */
+static unsigned long
+fixed_power_int(unsigned long x, unsigned int frac_bits, unsigned int n)
+{
+	unsigned long result = 1UL << frac_bits;
+
+	if (n) for (;;) {
+		if (n & 1) {
+			result *= x;
+			result += 1UL << (frac_bits - 1);
+			result >>= frac_bits;
+		}
+		n >>= 1;
+		if (!n)
+			break;
+		x *= x;
+		x += 1UL << (frac_bits - 1);
+		x >>= frac_bits;
+	}
+
+	return result;
+}
+
+/*
+ * a1 = a0 * e + a * (1 - e)
+ *
+ * a2 = a1 * e + a * (1 - e)
+ *    = (a0 * e + a * (1 - e)) * e + a * (1 - e)
+ *    = a0 * e^2 + a * (1 - e) * (1 + e)
+ *
+ * a3 = a2 * e + a * (1 - e)
+ *    = (a0 * e^2 + a * (1 - e) * (1 + e)) * e + a * (1 - e)
+ *    = a0 * e^3 + a * (1 - e) * (1 + e + e^2)
+ *
+ *  ...
+ *
+ * an = a0 * e^n + a * (1 - e) * (1 + e + ... + e^n-1) [1]
+ *    = a0 * e^n + a * (1 - e) * (1 - e^n)/(1 - e)
+ *    = a0 * e^n + a * (1 - e^n)
+ *
+ * [1] application of the geometric series:
+ *
+ *              n         1 - x^(n+1)
+ *     S_n := \Sum x^i = -------------
+ *             i=0          1 - x
+ */
+static unsigned long
+calc_load_n(unsigned long load, unsigned long exp,
+	    unsigned long active, unsigned int n)
+{
+
+	return calc_load(load, fixed_power_int(exp, FSHIFT, n), active);
+}
+
+/*
+ * NO_HZ can leave us missing all per-cpu ticks calling
+ * calc_load_account_active(), but since an idle CPU folds its delta into
+ * calc_load_tasks_idle per calc_load_account_idle(), all we need to do is fold
+ * in the pending idle delta if our idle period crossed a load cycle boundary.
+ *
+ * Once we've updated the global active value, we need to apply the exponential
+ * weights adjusted to the number of cycles missed.
+ */
+static void calc_global_nohz(unsigned long ticks)
+{
+	long delta, active, n;
+
+	if (time_before(jiffies, calc_load_update))
+		return;
+
+	/*
+	 * If we crossed a calc_load_update boundary, make sure to fold
+	 * any pending idle changes, the respective CPUs might have
+	 * missed the tick driven calc_load_account_active() update
+	 * due to NO_HZ.
+	 */
+	delta = calc_load_fold_idle();
+	if (delta)
+		atomic_long_add(delta, &calc_load_tasks);
+
+	/*
+	 * If we were idle for multiple load cycles, apply them.
+	 */
+	if (ticks >= LOAD_FREQ) {
+		n = ticks / LOAD_FREQ;
+
+		active = atomic_long_read(&calc_load_tasks);
+		active = active > 0 ? active * FIXED_1 : 0;
+
+		avenrun[0] = calc_load_n(avenrun[0], EXP_1, active, n);
+		avenrun[1] = calc_load_n(avenrun[1], EXP_5, active, n);
+		avenrun[2] = calc_load_n(avenrun[2], EXP_15, active, n);
+
+		calc_load_update += n * LOAD_FREQ;
+	}
+
+	/*
+	 * Its possible the remainder of the above division also crosses
+	 * a LOAD_FREQ period, the regular check in calc_global_load()
+	 * which comes after this will take care of that.
+	 *
+	 * Consider us being 11 ticks before a cycle completion, and us
+	 * sleeping for 4*LOAD_FREQ + 22 ticks, then the above code will
+	 * age us 4 cycles, and the test in calc_global_load() will
+	 * pick up the final one.
+	 */
+}
 #else
 static void calc_load_account_idle(struct rq *this_rq)
 {
@@ -3157,6 +3288,10 @@ static inline long calc_load_fold_idle(void)
 {
 	return 0;
 }
+
+static void calc_global_nohz(unsigned long ticks)
+{
+}
 #endif
 
 /**
@@ -3174,24 +3309,17 @@ void get_avenrun(unsigned long *loads, unsigned long offset, int shift)
 	loads[2] = (avenrun[2] + offset) << shift;
 }
 
-static unsigned long
-calc_load(unsigned long load, unsigned long exp, unsigned long active)
-{
-	load *= exp;
-	load += active * (FIXED_1 - exp);
-	return load >> FSHIFT;
-}
-
 /*
  * calc_load - update the avenrun load estimates 10 ticks after the
  * CPUs have updated calc_load_tasks.
  */
-void calc_global_load(void)
+void calc_global_load(unsigned long ticks)
 {
-	unsigned long upd = calc_load_update + 10;
 	long active;
 
-	if (time_before(jiffies, upd))
+	calc_global_nohz(ticks);
+
+	if (time_before(jiffies, calc_load_update + 10))
 		return;
 
 	active = atomic_long_read(&calc_load_tasks);
diff --git a/kernel/timer.c b/kernel/timer.c
index 68a9ae7..7bd715f 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1319,7 +1319,7 @@ void do_timer(unsigned long ticks)
 {
 	jiffies_64 += ticks;
 	update_wall_time();
-	calc_global_load();
+	calc_global_load(ticks);
 }
 
 #ifdef __ARCH_WANT_SYS_ALARM
