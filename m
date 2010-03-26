Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab0CZWEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 18:04:15 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:39875 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268Ab0CZWEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 18:04:12 -0400
Date: Fri, 26 Mar 2010 23:04:09 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: peterz@infradead.org, mingo@elte.hu, tglx@linutronix.de, oleg@redhat.com,
       "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 7/7] arch/sparc/kernel: Use set_cpus_allowed_ptr
Message-ID: <Pine.LNX.4.64.1003262303500.6480@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use set_cpus_allowed_ptr rather than set_cpus_allowed.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1,E2;
@@

- set_cpus_allowed(E1, cpumask_of_cpu(E2))
+ set_cpus_allowed_ptr(E1, cpumask_of(E2))

@@
expression E;
identifier I;
@@

- set_cpus_allowed(E, I)
+ set_cpus_allowed_ptr(E, &I)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/sparc/kernel/sysfs.c        |    4 ++--
 arch/sparc/kernel/us2e_cpufreq.c |    8 ++++----
 arch/sparc/kernel/us3_cpufreq.c  |    8 ++++----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff -u -p a/arch/sparc/kernel/sysfs.c b/arch/sparc/kernel/sysfs.c
--- a/arch/sparc/kernel/sysfs.c
+++ b/arch/sparc/kernel/sysfs.c
@@ -107,12 +107,12 @@ static unsigned long run_on_cpu(unsigned
 	unsigned long ret;
 
 	/* should return -EINVAL to userspace */
-	if (set_cpus_allowed(current, cpumask_of_cpu(cpu)))
+	if (set_cpus_allowed_ptr(current, cpumask_of(cpu)))
 		return 0;
 
 	ret = func(arg);
 
-	set_cpus_allowed(current, old_affinity);
+	set_cpus_allowed_ptr(current, &old_affinity);
 
 	return ret;
 }
diff -u -p a/arch/sparc/kernel/us2e_cpufreq.c b/arch/sparc/kernel/us2e_cpufreq.c
--- a/arch/sparc/kernel/us2e_cpufreq.c
+++ b/arch/sparc/kernel/us2e_cpufreq.c
@@ -238,12 +238,12 @@ static unsigned int us2e_freq_get(unsign
 		return 0;
 
 	cpus_allowed = current->cpus_allowed;
-	set_cpus_allowed(current, cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
 	clock_tick = sparc64_get_clock_tick(cpu) / 1000;
 	estar = read_hbreg(HBIRD_ESTAR_MODE_ADDR);
 
-	set_cpus_allowed(current, cpus_allowed);
+	set_cpus_allowed_ptr(current, &cpus_allowed);
 
 	return clock_tick / estar_to_divisor(estar);
 }
@@ -259,7 +259,7 @@ static void us2e_set_cpu_divider_index(u
 		return;
 
 	cpus_allowed = current->cpus_allowed;
-	set_cpus_allowed(current, cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
 	new_freq = clock_tick = sparc64_get_clock_tick(cpu) / 1000;
 	new_bits = index_to_estar_mode(index);
@@ -281,7 +281,7 @@ static void us2e_set_cpu_divider_index(u
 
 	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 
-	set_cpus_allowed(current, cpus_allowed);
+	set_cpus_allowed_ptr(current, &cpus_allowed);
 }
 
 static int us2e_freq_target(struct cpufreq_policy *policy,
diff -u -p a/arch/sparc/kernel/us3_cpufreq.c b/arch/sparc/kernel/us3_cpufreq.c
--- a/arch/sparc/kernel/us3_cpufreq.c
+++ b/arch/sparc/kernel/us3_cpufreq.c
@@ -86,12 +86,12 @@ static unsigned int us3_freq_get(unsigne
 		return 0;
 
 	cpus_allowed = current->cpus_allowed;
-	set_cpus_allowed(current, cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
 	reg = read_safari_cfg();
 	ret = get_current_freq(cpu, reg);
 
-	set_cpus_allowed(current, cpus_allowed);
+	set_cpus_allowed_ptr(current, &cpus_allowed);
 
 	return ret;
 }
@@ -106,7 +106,7 @@ static void us3_set_cpu_divider_index(un
 		return;
 
 	cpus_allowed = current->cpus_allowed;
-	set_cpus_allowed(current, cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
 	new_freq = sparc64_get_clock_tick(cpu) / 1000;
 	switch (index) {
@@ -140,7 +140,7 @@ static void us3_set_cpu_divider_index(un
 
 	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 
-	set_cpus_allowed(current, cpus_allowed);
+	set_cpus_allowed_ptr(current, &cpus_allowed);
 }
 
 static int us3_freq_target(struct cpufreq_policy *policy,
