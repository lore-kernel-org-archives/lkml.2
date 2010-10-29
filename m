Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761756Ab0J2Toc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 15:44:32 -0400
Received: from canuck.infradead.org ([134.117.69.58]:43132 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761744Ab0J2Toa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 15:44:30 -0400
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Damien Wyart <damien.wyart@free.fr>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, tmhikaru@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1288101958.15336.284.camel@twins>
References: <AANLkTin+HE09Oui89uCmG-rrHE14zXfJuRvZgsPCB1De@mail.gmail.com>
	 <1287788622-25860-1-git-send-email-venki@google.com>
	 <1288001573.15336.52.camel@twins>  <1288097074.15336.211.camel@twins>
	 <1288101958.15336.284.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 29 Oct 2010 21:42:23 +0200
Message-ID: <1288381343.1988.12.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 16:05 +0200, Peter Zijlstra wrote:
> 
>  a1 = a0 * e + a * (1 - e)
> 
>  a2 = a1 * e + a * (1 - e)
>     = (a0 * e + a * (1 - e)) * e + a * (1 - e)
>     = a0 * e^2 + a * (1 - e) * (1 + e)
> 
>  a3 = a2 * e + a * (1 - e)
>     = (a0 * e^2 + a * (1 - e) * (1 + e)) * e + a * (1 - e)
>     = a0 * e^3 + a * (1 - e) * (1 + e + e^2)
> 
>  an = a0 * e^n + a * (1 - e) * (1 + e + ... + e^n-1)
>     = a0 * e^n + a * (1 - e) * (1 - e^n)/(1 - e)
>     = a0 * e^n + a * (1 - e^n)

not tested other than compile, but how does that look...?

---
 include/linux/sched.h |    2 +-
 kernel/sched.c        |   74 +++++++++++++++++++++++++++++++++++++++++++++---
 kernel/timer.c        |    2 +-
 3 files changed, 71 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b3d07df..f878db3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -143,7 +143,7 @@ extern unsigned long nr_iowait_cpu(int cpu);
 extern unsigned long this_cpu_load(void);
 
 
-extern void calc_global_load(void);
+extern void calc_global_load(int ticks);
 
 extern unsigned long get_parent_ip(unsigned long addr);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 41f1869..125417e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3168,10 +3168,64 @@ calc_load(unsigned long load, unsigned long exp, unsigned long active)
 }
 
 /*
+ * fixed_power_int - compute: x^n in O(log n) time
+ * @x:		base of the power
+ * frac_bits:	fractional bits of @x
+ * @n:		power to raise @x to.
+ */
+static unsigned long 
+fixed_power_int(unsigned long x, unsigned int frac_bits, unsigned int n)
+{
+	unsigned long result = 1UL << frac_bits;
+
+	while (n) {
+		if (n & 1) {
+			result *= x;
+			result += 1UL << (frac_bits - 1);
+			result >>= frac_bits;
+		}
+		n >>= 1;
+		x *= x;
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
+ * an = a0 * e^n + a * (1 - e) * (1 + e + ... + e^n-1)
+ *    = a0 * e^n + a * (1 - e) * (1 - e^n)/(1 - e)
+ *    = a0 * e^n + a * (1 - e^n)
+ */
+static unsigned long
+calc_load_n(unsigned long load, unsigned long exp, 
+	    unsigned long active, unsigned int n)
+{
+	unsigned long en = fixed_power_int(exp, FSHIFT, n);
+
+	load *= en;
+	load += active * (FIXED_1 - en);
+	load += 1UL << (FSHIFT - 1);
+	load >>= FSHIFT;
+
+	return load;
+}
+
+/*
  * calc_load - update the avenrun load estimates 10 ticks after the
  * CPUs have updated calc_load_tasks.
  */
-void calc_global_load(void)
+void calc_global_load(int ticks)
 {
 	unsigned long upd = calc_load_update + 10;
 	long active;
@@ -3182,11 +3236,21 @@ void calc_global_load(void)
 	active = atomic_long_read(&calc_load_tasks);
 	active = active > 0 ? active * FIXED_1 : 0;
 
-	avenrun[0] = calc_load(avenrun[0], EXP_1, active);
-	avenrun[1] = calc_load(avenrun[1], EXP_5, active);
-	avenrun[2] = calc_load(avenrun[2], EXP_15, active);
+	if (ticks > LOAD_FREQ) {
+		int n = (jiffies - upd) / LOAD_FREQ;
+
+		avenrun[0] = calc_load_n(avenrun[0], EXP_1, active, n);
+		avenrun[1] = calc_load_n(avenrun[1], EXP_5, active, n);
+		avenrun[2] = calc_load_n(avenrun[2], EXP_15, active, n);
 
-	calc_load_update += LOAD_FREQ;
+		calc_load_update += n * LOAD_FREQ;
+	} else {
+		avenrun[0] = calc_load(avenrun[0], EXP_1, active);
+		avenrun[1] = calc_load(avenrun[1], EXP_5, active);
+		avenrun[2] = calc_load(avenrun[2], EXP_15, active);
+
+		calc_load_update += LOAD_FREQ;
+	}
 }
 
 /*
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

