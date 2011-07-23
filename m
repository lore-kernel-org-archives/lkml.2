Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab1GWWc4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 18:32:56 -0400
Received: from smtpo.poczta.interia.pl ([217.74.65.205]:32867 "EHLO
	smtpo.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab1GWWcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 18:32:50 -0400
From: =?UTF-8?b?UmFmYcWC?= Bilski <rafalbilski@interia.pl>
To: Dave Jones <davej@redhat.com>
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?b?UmFmYcWC?= Bilski <rafalbilski@interia.pl>
Subject: [PATCH] e_powersaver: Allow user to lower maximum voltage
Date: Sat, 23 Jul 2011 23:35:28 +0100
Message-Id: <1311460528-1094-1-git-send-email-rafalbilski@interia.pl>
X-Mailer: git-send-email 1.7.6
MIME-Version: 1.0
X-Interia-Antivirus: OK
X-EMID: a0771958
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new module option "set_max_voltage".
One of the lessons learned from Adaptive Powersaver is that voltage values
returned by processor are for worst case scenario. But required voltage
is changing with CPU temperature. And even processors produced in the same
batch can have different minimum voltage necessary for stable work at
specified frequency.
On Elonex Webbook, once system starts, temperature never drops below
48 deg. C. Loading module after systems start allows user to lower CPU
voltage and still have stable system.
Sadly C7 doesn't allow code to set frequency or voltage from outside limits.
If you ask it to set voltage lower then minimum it will ignore you. Thats
why it isn't possible to change minimum voltage for minimum frequency too.
Changing maximum voltage on Elonex Webbook leads to very good results. Looks
like VIA C7 1.6GHz 1084mV can safetly run at 892mV. This means 83% of
orginal value. If same percentage applies to power generated it means 12.5W
in the place of 15W. Not much, but it is better then nothing.
Only C7-M makes it possible.
If voltage is too low by 16mV or more you will experience kernel panic.
If voltage is too low by 32mV or more you will experience system freeze.

Signed-off-by: Rafał Bilski <rafalbilski@interia.pl>
---
 drivers/cpufreq/e_powersaver.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index 8efe31f..eecab5f 100644
--- a/drivers/cpufreq/e_powersaver.c
+++ b/drivers/cpufreq/e_powersaver.c
@@ -43,6 +43,7 @@ static struct eps_cpu_data *eps_cpu[NR_CPUS];
 /* Module parameters */
 static int freq_failsafe_off;
 static int voltage_failsafe_off;
+static int set_max_voltage;
 
 #if defined CONFIG_ACPI_PROCESSOR || defined CONFIG_ACPI_PROCESSOR_MODULE
 static int ignore_acpi_limit;
@@ -345,6 +346,21 @@ static int eps_cpu_init(struct cpufreq_policy *policy)
 	}
 #endif
 
+	/* Allow user to set lower maximum voltage then that reported
+	 * by processor */
+	if (brand == EPS_BRAND_C7M && set_max_voltage) {
+		u32 v;
+
+		/* Change mV to something hardware can use */
+		v = (set_max_voltage - 700) / 16;
+		/* Check if voltage is within limits */
+		if (v >= min_voltage && v <= max_voltage) {
+			printk(KERN_INFO "eps: Setting %dmV as maximum.\n",
+				v * 16 + 700);
+			max_voltage = v;
+		}
+	}
+
 	/* Calc number of p-states supported */
 	if (brand == EPS_BRAND_C7M)
 		states = max_multiplier - min_multiplier + 1;
@@ -459,6 +475,8 @@ MODULE_PARM_DESC(voltage_failsafe_off, "Disable current vs max voltage check");
 module_param(ignore_acpi_limit, int, 0644);
 MODULE_PARM_DESC(ignore_acpi_limit, "Don't check ACPI's processor speed limit");
 #endif
+module_param(set_max_voltage, int, 0644);
+MODULE_PARM_DESC(set_max_voltage, "Set maximum CPU voltage (mV) C7-M only");
 
 MODULE_AUTHOR("Rafal Bilski <rafalbilski@interia.pl>");
 MODULE_DESCRIPTION("Enhanced PowerSaver driver for VIA C7 CPU's.");
-- 
1.7.6


----------------------------------------------------------------
Znajdz samochod idealny dla siebie!
Szukaj >> http://linkint.pl/f29e2
