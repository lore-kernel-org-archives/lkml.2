Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab1GLRAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 13:00:40 -0400
Received: from smtpo.poczta.interia.pl ([217.74.65.206]:34916 "EHLO
	smtpo.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab1GLRAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 13:00:38 -0400
Message-ID: <4E1C7D96.1030500@interia.pl>
Date: Tue, 12 Jul 2011 18:00:06 +0100
From: =?UTF-8?b?UmFmYcWC?= Bilski <rafalbilski@interia.pl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:5.0) Gecko/20110628
	Thunderbird/5.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Axel Lin <axel.lin@gmail.com>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [PATCH] e_powersaver: Underclock checks
References: <1310114243.2940.3.camel@phoenix> <4E1B745A.5000802@interia.pl>
	<4E1B8404.1050909@interia.pl> <20110711232517.GC20367@redhat.com>
In-Reply-To: <20110711232517.GC20367@redhat.com>
X-Interia-Antivirus: OK
X-EMID: 9a346958
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some systems are using 1.2GHz@844mV processors running at 600MHz@796mV.
Try to detect such systems and don't touch anything on it. If CPU doesn't have
P-States in BIOS it will run on maximum frequency anyway.
Allow user to bypass checks by means of two new options.
Don't set frequency to maximum on module unloading to avoid bada boom.

It is also possible that these, or other,  processors have incorrect values in
mix/max registers caused by error in manufacturing process. Probably it would be
BIOS job to set them to right frequency.
For the first time CPU is reporting higher supported frequency then system is
able to support. In old times of C3 CPUs on EPIA M10000 1,4GHz processors
were reporting 1GHz as highest supported frequency because cooler was too
small. With bigger cooler and patched "Longhaul" board was (and still is somewhere)
running perfectly at 1,4GHz. I still wonder why they didn't change voltage to lower one.

Code totally untested as I have abadoned Centaur for Intel Atom two years ago.

Signed-off-by: Rafał Bilski <rafalbilski@interia.pl>
---
  drivers/cpufreq/e_powersaver.c |   42 +++++++++++++++++++++++++++++----------
  1 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index 7883ffa..46176b2 100644
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
@@ -253,9 +257,28 @@ static int eps_cpu_init(struct cpufreq_policy *policy)
          return -EINVAL;
      if (current_voltage > 0x1f || max_voltage > 0x1f)
          return -EINVAL;
-    if (max_voltage < min_voltage)
+    if (max_voltage < min_voltage || current_voltage < min_voltage)
          return -EINVAL;

+    /* Check for systems using underclocked CPU */
+    if (!freq_failsafe_off && max_multiplier != current_multiplier) {
+        printk(KERN_INFO "eps: Your processor is running at different frequency "
+            "then its maximum.\n");
+        printk(KERN_INFO "eps: Some systems use underclocked CPU's\n");
+        printk(KERN_INFO "eps: Use of \"e_powersaver\" on them may cause "
+            "irreparable damage.\n");
+        printk(KERN_INFO "eps: You can use freq_failsafe_off option to disable "
+            "this check.\n");
+        return -EINVAL;
+    }
+    if (!voltage_failsafe_off && max_voltage != current_voltage) {
+        printk(KERN_INFO "eps: Your processor is running at different voltage "
+            "then its maximum.\n");
+        printk(KERN_INFO "eps: You can use voltage_failsafe_off option to disable "
+            "this check.\n");
+        return -EINVAL;
+    }
+
      /* Calc FSB speed */
      fsb = cpu_khz / current_multiplier;
      /* Calc number of p-states supported */
@@ -312,17 +335,7 @@ static int eps_cpu_init(struct cpufreq_policy *policy)
  static int eps_cpu_exit(struct cpufreq_policy *policy)
  {
      unsigned int cpu = policy->cpu;
-    struct eps_cpu_data *centaur;
-    u32 lo, hi;
-
-    if (eps_cpu[cpu] == NULL)
-        return -ENODEV;
-    centaur = eps_cpu[cpu];

-    /* Get max frequency */
-    rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
-    /* Set max frequency */
-    eps_set_state(centaur, cpu, hi & 0xffff);
      /* Bye */
      cpufreq_frequency_table_put_attr(policy->cpu);
      kfree(eps_cpu[cpu]);
@@ -368,6 +381,13 @@ static void __exit eps_exit(void)
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
