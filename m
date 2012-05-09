Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748Ab2EII1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:27:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758731Ab2EII1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:27:00 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, luto@mit.edu, suresh.b.siddha@intel.com,
        avi@redhat.com, imammedo@redhat.com, a.p.zijlstra@chello.nl,
        johnstul@us.ibm.com, arjan@linux.intel.com, linux-doc@vger.kernel.org
Subject: [PATCH 5/5] Do not mark cpu as not present if we failed to boot it
Date: Wed,  9 May 2012 12:25:02 +0200
Message-Id: <1336559102-28103-6-git-send-email-imammedo@redhat.com>
In-Reply-To: <1336559102-28103-1-git-send-email-imammedo@redhat.com>
References: <1336559102-28103-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will allow to boot cpu later if possible.

v2:
Introduce failed_cpu_boots_limit cmd-line parameter.

At startup udev might try to online cpu even if it have failed to boot
first time. And udev will loop there on cpu that refuses to boot.
So disable cpu after failed_cpu_boots_limit is reached to prevent
udev spinning on onlining persistently faulty cpu.
Guest kernel on overcomitted hosts could use this parameter to set
limit to acceptable number of cpu online failures.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 Documentation/kernel-parameters.txt |    6 +++++
 arch/x86/kernel/smpboot.c           |   36 +++++++++++++++++++++++++++++++++-
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c1601e5..6b9bbbc 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -825,6 +825,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Format: <interval>,<probability>,<space>,<times>
 			See also Documentation/fault-injection/.
 
+	failed_cpu_boots_limit=[SMP,X86]
+			Number of tries	kernel allowed to boot not responding /
+			stuck cpu. When fail attempts are reached, kernel will
+			disable failed cpu and mark it as not present.
+			Default: 0
+
 	floppy=		[HW]
 			See Documentation/blockdev/floppy.txt.
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index af63cab..2d72a8a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -136,6 +136,28 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 atomic_t init_deasserted;
 
+static int failed_cpu_boots_limit = 0;
+static int cpu_boot_error_nr[NR_CPUS];
+
+static int parse_failed_cpu_boots(char *str)
+{
+	unsigned long val;
+	int err;
+
+	if (!str)
+		return -EINVAL;
+
+	err = kstrtoul(str, 0, &failed_cpu_boots_limit);
+	if (err)
+		return -EINVAL;
+
+	printk(KERN_NOTICE "Limit CPU failed boot attempts: %d\n",
+			failed_cpu_boots_limit);
+
+	return 0;
+}
+__setup("failed_cpu_boots_limit=", parse_failed_cpu_boots);
+
 /*
  * Report back to the Boot Processor.
  * Running on AP.
@@ -810,8 +832,18 @@ do_rest:
 		/* was set by cpu_init() */
 		cpumask_clear_cpu(cpu, cpu_initialized_mask);
 
-		set_cpu_present(cpu, false);
-		per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
+		/* was set by smp_callin() */
+		cpumask_clear_cpu(cpu, cpu_callin_mask);
+
+		/* disable CPU if it's failed to boot N times in a row */
+		if (cpu_boot_error_nr[cpu]++ > failed_cpu_boots_limit) {
+			set_cpu_present(cpu, false);
+			per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
+			pr_err("CPU%d: repeatedly fails to boot, disabling.\n",
+				cpu);
+		}
+	} else {
+		cpu_boot_error_nr[cpu] = 0;
 	}
 
 	/* mark "stuck" area as not stuck */
-- 
1.7.1

