Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab1GTTjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:39:36 -0400
Received: from smtpo.poczta.interia.pl ([217.74.65.205]:11719 "EHLO
	smtpo.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1GTTje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:39:34 -0400
From: Rafal Bilski <rafalbilski@interia.pl>
To: Dave Jones <davej@redhat.com>
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?b?UmFmYcWC?= Bilski <rafalbilski@interia.pl>
Subject: [PATCH] e_powersaver: Additional checks
Date: Wed, 20 Jul 2011 20:42:23 +0100
Message-Id: <1311190943-6660-1-git-send-email-rafalbilski@interia.pl>
X-Mailer: git-send-email 1.7.6
MIME-Version: 1.0
X-Interia-Antivirus: OK
X-EMID: a0771958
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafał Bilski <rafalbilski@interia.pl>

Some systems are using 1,2Ghz@844mV processors running at 600MHz@796mV.
Try to detect such systems and don't touch anything on it. If CPU doesn't have
P-States in BIOS it should run at maximum frequency.
Allow user to bypass checks by means of two new options.
Don't set frequency to maximum on module unloading to avoid bada boom.
It is also possible that some processors may have incorrect values in min/max
registers caused by error in manufacturing process. Probably it would be BIOS
job to set them to right frequency and P-States tables would have correct
values inside.
Two additional sanity checks for voltage.

Signed-off-by: Rafał Bilski <rafalbilski@interia.pl>
---
 drivers/cpufreq/e_powersaver.c |   41 +++++++++++++++++++++++++++++----------
 1 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index 7883ffa..cab543b 100644
--- a/drivers/cpufreq/e_powersaver.c
+++ b/drivers/cpufreq/e_powersaver.c
@@ -32,6 +32,10 @@ struct eps_cpu_data {
 
 static struct eps_cpu_data *eps_cpu[NR_CPUS];
 
+/* Module parameters */
+static int freq_failsafe_off;
+static int voltage_failsafe_off;
+
 
 static unsigned int eps_get(unsigned int cpu)
 {
@@ -253,9 +257,27 @@ static int eps_cpu_init(struct cpufreq_policy *policy)
 		return -EINVAL;
 	if (current_voltage > 0x1f || max_voltage > 0x1f)
 		return -EINVAL;
-	if (max_voltage < min_voltage)
+	if (max_voltage < min_voltage
+	    || current_voltage < min_voltage
+	    || current_voltage > max_voltage)
 		return -EINVAL;
 
+	/* Check for systems using underclocked CPU */
+	if (!freq_failsafe_off && max_multiplier != current_multiplier) {
+		printk(KERN_INFO "eps: Your processor is running at different "
+			"frequency then its maximum. Aborting.\n");
+		printk(KERN_INFO "eps: You can use freq_failsafe_off option "
+			"to disable this check.\n");
+		return -EINVAL;
+	}
+	if (!voltage_failsafe_off && max_voltage != current_voltage) {
+		printk(KERN_INFO "eps: Your processor is running at different "
+			"voltage then its maximum. Aborting.\n");
+		printk(KERN_INFO "eps: You can use voltage_failsafe_off "
+			"option to disable this check.\n");
+		return -EINVAL;
+	}
+
 	/* Calc FSB speed */
 	fsb = cpu_khz / current_multiplier;
 	/* Calc number of p-states supported */
@@ -312,17 +334,7 @@ static int eps_cpu_init(struct cpufreq_policy *policy)
 static int eps_cpu_exit(struct cpufreq_policy *policy)
 {
 	unsigned int cpu = policy->cpu;
-	struct eps_cpu_data *centaur;
-	u32 lo, hi;
-
-	if (eps_cpu[cpu] == NULL)
-		return -ENODEV;
-	centaur = eps_cpu[cpu];
 
-	/* Get max frequency */
-	rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
-	/* Set max frequency */
-	eps_set_state(centaur, cpu, hi & 0xffff);
 	/* Bye */
 	cpufreq_frequency_table_put_attr(policy->cpu);
 	kfree(eps_cpu[cpu]);
@@ -368,6 +380,13 @@ static void __exit eps_exit(void)
 	cpufreq_unregister_driver(&eps_driver);
 }
 
+/* Allow user to overclock his machine or to change frequency to higher after
+ * unloading module */
+module_param(freq_failsafe_off, int, 0644);
+MODULE_PARM_DESC(freq_failsafe_off, "Disable current vs max frequency check");
+module_param(voltage_failsafe_off, int, 0644);
+MODULE_PARM_DESC(voltage_failsafe_off, "Disable current vs max voltage check");
+
 MODULE_AUTHOR("Rafal Bilski <rafalbilski@interia.pl>");
 MODULE_DESCRIPTION("Enhanced PowerSaver driver for VIA C7 CPU's.");
 MODULE_LICENSE("GPL");
-- 
1.7.6


----------------------------------------------------------------
Znajdz samochod idealny dla siebie!
Szukaj >> http://linkint.pl/f29e2
