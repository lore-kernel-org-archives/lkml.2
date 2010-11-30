Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab0K3O65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 09:58:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:51708 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab0K3O6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 09:58:55 -0500
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
From: Peter Zijlstra <peterz@infradead.org>
To: tmhikaru@gmail.com
Cc: Damien Wyart <damien.wyart@free.fr>,
        Venkatesh Pallipadi <venki@google.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
In-Reply-To: <1291071677.32004.527.camel@laptop>
References: <20101109185516.GQ8332@bombadil.infradead.org>
	 <1289329348.2191.69.camel@laptop>
	 <20101110034507.GV8332@bombadil.infradead.org>
	 <1289390424.2191.98.camel@laptop> <20101114051406.GA2050@roll>
	 <20101125133106.GA12914@brouette> <1290693807.2145.36.camel@laptop>
	 <1290888920.32004.1.camel@laptop> <20101128114027.GA2745@brouette>
	 <1291030726.32004.4.camel@laptop>  <20101129194041.GA8280@roll>
	 <1291071677.32004.527.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 30 Nov 2010 15:59:05 +0100
Message-ID: <1291129145.32004.874.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 00:01 +0100, Peter Zijlstra wrote:
> 
> Ok, that's good testing.. so its still not quite the same as NO_HZ=n,
> how about this one?
> 
> (it seems to drop down to 0.00 if I wait a few minutes with top -d5)

OK, so here's a less crufty patch that gets the same result on my
machine, load drops down to 0.00 after a while.

It seems a bit slower to reach 0.00, but that could be because I
actually changed the load computation for NO_HZ=n as well, I added a
rounding factor in calc_load(), we no longer truncate the division.

If people want to compare, simply remove the third line from
calc_load(): load += 1UL << (FSHIFT - 1), to restore the old behaviour.

---
 include/linux/sched.h |    2 +-
 kernel/sched.c        |  127 ++++++++++++++++++++++++++++++++++++++++++++----
 kernel/timer.c        |    2 +-
 3 files changed, 118 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index de4d68f..a6e0c62 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -143,7 +143,7 @@ extern unsigned long nr_iowait_cpu(int cpu);
 extern unsigned long this_cpu_load(void);
 
 
-extern void calc_global_load(void);
+extern void calc_global_load(unsigned long ticks);
 
 extern unsigned long get_parent_ip(unsigned long addr);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 864040c..7868a18 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2978,6 +2978,15 @@ static long calc_load_fold_active(struct rq *this_rq)
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
@@ -3007,6 +3016,105 @@ static long calc_load_fold_idle(void)
 
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
+	 * due to NO_HZ
+	 */
+	delta = calc_load_fold_idle();
+	if (delta)
+		atomic_long_add(delta, &calc_load_tasks);
+
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
+}
 #else
 static void calc_load_account_idle(struct rq *this_rq)
 {
@@ -3016,6 +3124,10 @@ static inline long calc_load_fold_idle(void)
 {
 	return 0;
 }
+
+static void calc_global_nohz(unsigned long ticks)
+{
+}
 #endif
 
 /**
@@ -3033,24 +3145,17 @@ void get_avenrun(unsigned long *loads, unsigned long offset, int shift)
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
index d6ccb90..9f82b2a 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1297,7 +1297,7 @@ void do_timer(unsigned long ticks)
 {
 	jiffies_64 += ticks;
 	update_wall_time();
-	calc_global_load();
+	calc_global_load(ticks);
 }
 
 #ifdef __ARCH_WANT_SYS_ALARM

