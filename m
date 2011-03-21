Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab1CUXjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:39:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51891 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238Ab1CUXjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:39:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 5/6] cpufreq: Use syscore_ops for boot CPU suspend/resume (v2)
Date: Tue, 22 Mar 2011 00:38:01 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de,
        Dave Jones <davej@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Avi Kivity <avi@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        cpufreq@vger.kernel.org
References: <201103100131.58206.rjw@sisk.pl> <201103122212.40828.rjw@sisk.pl> <201103220031.22729.rjw@sisk.pl>
In-Reply-To: <201103220031.22729.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103220038.02116.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The cpufreq subsystem uses sysdev suspend and resume for
executing cpufreq_suspend() and cpufreq_resume(), respectively,
during system suspend, after interrupts have been switched off on the
boot CPU, and during system resume, while interrupts are still off on
the boot CPU.  In both cases the other CPUs are off-line at the
relevant point (either they have been switched off via CPU hotplug
during suspend, or they haven't been switched on yet during resume).
For this reason, although it may seem that cpufreq_suspend() and
cpufreq_resume() are executed for all CPUs in the system, they are
only called for the boot CPU in fact, which is quite confusing.

To remove the confusion and to prepare for elimiating sysdev
suspend and resume operations from the kernel enirely, convernt
cpufreq to using a struct syscore_ops object for the boot CPU
suspend and resume and rename the callbacks so that their names
reflect their purpose.  In addition, put some explanatory remarks
into their kerneldoc comments.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/cpufreq/cpufreq.c |   66 ++++++++++++++++++----------------------------
 1 file changed, 26 insertions(+), 40 deletions(-)

Index: linux-2.6/drivers/cpufreq/cpufreq.c
===================================================================
--- linux-2.6.orig/drivers/cpufreq/cpufreq.c
+++ linux-2.6/drivers/cpufreq/cpufreq.c
@@ -28,6 +28,7 @@
 #include <linux/cpu.h>
 #include <linux/completion.h>
 #include <linux/mutex.h>
+#include <linux/syscore_ops.h>
 
 #include <trace/events/power.h>
 
@@ -1340,35 +1341,31 @@ out:
 }
 EXPORT_SYMBOL(cpufreq_get);
 
+static struct sysdev_driver cpufreq_sysdev_driver = {
+	.add		= cpufreq_add_dev,
+	.remove		= cpufreq_remove_dev,
+};
+
 
 /**
- *	cpufreq_suspend - let the low level driver prepare for suspend
+ * cpufreq_bp_suspend - Prepare the boot CPU for system suspend.
+ *
+ * This function is only executed for the boot processor.  The other CPUs
+ * have been put offline by means of CPU hotplug.
  */
-
-static int cpufreq_suspend(struct sys_device *sysdev, pm_message_t pmsg)
+static int cpufreq_bp_suspend(void)
 {
 	int ret = 0;
 
-	int cpu = sysdev->id;
+	int cpu = smp_processor_id();
 	struct cpufreq_policy *cpu_policy;
 
 	dprintk("suspending cpu %u\n", cpu);
 
-	if (!cpu_online(cpu))
-		return 0;
-
-	/* we may be lax here as interrupts are off. Nonetheless
-	 * we need to grab the correct cpu policy, as to check
-	 * whether we really run on this CPU.
-	 */
-
+	/* If there's no policy for the boot CPU, we have nothing to do. */
 	cpu_policy = cpufreq_cpu_get(cpu);
 	if (!cpu_policy)
-		return -EINVAL;
-
-	/* only handle each CPU group once */
-	if (unlikely(cpu_policy->cpu != cpu))
-		goto out;
+		return 0;
 
 	if (cpufreq_driver->suspend) {
 		ret = cpufreq_driver->suspend(cpu_policy);
@@ -1377,13 +1374,12 @@ static int cpufreq_suspend(struct sys_de
 					"step on CPU %u\n", cpu_policy->cpu);
 	}
 
-out:
 	cpufreq_cpu_put(cpu_policy);
 	return ret;
 }
 
 /**
- *	cpufreq_resume -  restore proper CPU frequency handling after resume
+ * cpufreq_bp_resume - Restore proper frequency handling of the boot CPU.
  *
  *	1.) resume CPUfreq hardware support (cpufreq_driver->resume())
  *	2.) schedule call cpufreq_update_policy() ASAP as interrupts are
@@ -1391,31 +1387,23 @@ out:
  *	    what we believe it to be. This is a bit later than when it
  *	    should be, but nonethteless it's better than calling
  *	    cpufreq_driver->get() here which might re-enable interrupts...
+ *
+ * This function is only executed for the boot CPU.  The other CPUs have not
+ * been turned on yet.
  */
-static int cpufreq_resume(struct sys_device *sysdev)
+static void cpufreq_bp_resume(void)
 {
 	int ret = 0;
 
-	int cpu = sysdev->id;
+	int cpu = smp_processor_id();
 	struct cpufreq_policy *cpu_policy;
 
 	dprintk("resuming cpu %u\n", cpu);
 
-	if (!cpu_online(cpu))
-		return 0;
-
-	/* we may be lax here as interrupts are off. Nonetheless
-	 * we need to grab the correct cpu policy, as to check
-	 * whether we really run on this CPU.
-	 */
-
+	/* If there's no policy for the boot CPU, we have nothing to do. */
 	cpu_policy = cpufreq_cpu_get(cpu);
 	if (!cpu_policy)
-		return -EINVAL;
-
-	/* only handle each CPU group once */
-	if (unlikely(cpu_policy->cpu != cpu))
-		goto fail;
+		return;
 
 	if (cpufreq_driver->resume) {
 		ret = cpufreq_driver->resume(cpu_policy);
@@ -1430,14 +1418,11 @@ static int cpufreq_resume(struct sys_dev
 
 fail:
 	cpufreq_cpu_put(cpu_policy);
-	return ret;
 }
 
-static struct sysdev_driver cpufreq_sysdev_driver = {
-	.add		= cpufreq_add_dev,
-	.remove		= cpufreq_remove_dev,
-	.suspend	= cpufreq_suspend,
-	.resume		= cpufreq_resume,
+static struct syscore_ops cpufreq_syscore_ops = {
+	.suspend	= cpufreq_bp_suspend,
+	.resume		= cpufreq_bp_resume,
 };
 
 
@@ -2002,6 +1987,7 @@ static int __init cpufreq_core_init(void
 	cpufreq_global_kobject = kobject_create_and_add("cpufreq",
 						&cpu_sysdev_class.kset.kobj);
 	BUG_ON(!cpufreq_global_kobject);
+	register_syscore_ops(&cpufreq_syscore_ops);
 
 	return 0;
 }

