Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab1LKWtV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 17:49:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54670 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab1LKWtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 17:49:20 -0500
From: Vincent Li <vincent.mc.li@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        Vincent Li <vincent.mc.li@gmail.com>
Subject: [PATCH] Softlockup (out of cpu) killer
Date: Sun, 11 Dec 2011 14:48:55 -0800
Message-Id: <1323643735-1999-1-git-send-email-vincent.mc.li@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel, there is out of memory (OOM) killer, why not make an out of cpu (OOC) killer?
I tested following patch by running an user-space cpu hogging process and the softlockukp
detector killed the process successfully.

 Softlockup could be caused by user-space process hogging cpu, add softlockup_kill kernel
 config to allow kernel to kill the user space cpu hogging process. this feature is
 useful for high availability systems that have uptime gurantees and where a softlockup
 must be resolved ASAP

echo 1 > /proc/sys/kernel/softlockukp_kill to enable cpu hog process killer
echo 0 > /proc/sys/kernel/softlockup_kill to disable cpu hog process killer

Signed-off-by: Vincent Li <vincent.mc.li@gmail.com>
---
 Documentation/kernel-parameters.txt |    4 ++++
 include/linux/sched.h               |    1 +
 kernel/sysctl.c                     |    9 +++++++++
 kernel/watchdog.c                   |   18 ++++++++++++++++++
 lib/Kconfig.debug                   |   21 +++++++++++++++++++++
 5 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 81c287f..1609387 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2418,6 +2418,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			[KNL] Should the soft-lockup detector generate panics.
 			Format: <integer>
 
+	softlockup_panic=
+			[KNL] Should the soft-lockup detector kill cpu hog process.
+			Format: <integer>
+
 	sonypi.*=	[HW] Sony Programmable I/O Control Device driver
 			See Documentation/laptops/sonypi.txt
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1c4f3e9..4783fac 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -315,6 +315,7 @@ extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
 				  void __user *buffer,
 				  size_t *lenp, loff_t *ppos);
 extern unsigned int  softlockup_panic;
+extern unsigned int  softlockup_kill;
 void lockup_detector_init(void);
 #else
 static inline void touch_softlockup_watchdog(void)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ae27196..e79ea9c 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -770,6 +770,15 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &one,
 	},
 	{
+		.procname	= "softlockup_kill",
+		.data		= &softlockup_kill,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+	{
 		.procname       = "nmi_watchdog",
 		.data           = &watchdog_enabled,
 		.maxlen         = sizeof (int),
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 1d7bca7..5832a90 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -75,6 +75,17 @@ static int __init softlockup_panic_setup(char *str)
 }
 __setup("softlockup_panic=", softlockup_panic_setup);
 
+unsigned int __read_mostly softlockup_kill =
+			CONFIG_BOOTPARAM_SOFTLOCKUP_KILL_VALUE;
+
+static int __init softlockup_kill_setup(char *str)
+{
+	softlockup_kill = simple_strtoul(str, NULL, 0);
+
+	return 1;
+}
+__setup("softlockup_kill=", softlockup_kill_setup);
+
 static int __init nowatchdog_setup(char *str)
 {
 	watchdog_enabled = 0;
@@ -306,6 +317,13 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 		else
 			dump_stack();
 
+		if (softlockup_kill) {
+			printk(KERN_ERR "Kill softlockup process [%s:%d] on CPU#%d\n",
+				current->comm, task_pid_nr(current),
+				smp_processor_id());
+			force_sig(SIGKILL, current);
+		}
+
 		if (softlockup_panic)
 			panic("softlockup: hung tasks");
 		__this_cpu_write(soft_watchdog_warn, true);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 82928f5..e4afc98 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -224,6 +224,27 @@ config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
 	default 0 if !BOOTPARAM_SOFTLOCKUP_PANIC
 	default 1 if BOOTPARAM_SOFTLOCKUP_PANIC
 
+config BOOTPARAM_SOFTLOCKUP_KILL
+	bool "Kill (cpu hog process) On Soft Lockups"
+	depends on LOCKUP_DETECTOR
+	help
+	  Say Y here to enable the kernel to kill cpu hog process on
+	  "soft lockups", which are bugs that cause the kernel to
+	  loop in kernel mode for more than 60 seconds, without giving
+	  other tasks a chance to run.
+
+	  This feature is useful for high-availability systems that
+	  have uptime guarantees and where a lockup must be resolved ASAP.
+
+	Say N if unsure.
+
+config BOOTPARAM_SOFTLOCKUP_KILL_VALUE
+	int
+	depends on LOCKUP_DETECTOR
+	range 0 1
+	default 0 if !BOOTPARAM_SOFTLOCKUP_KILL
+	default 1 if BOOTPARAM_SOFTLOCKUP_KILL
+
 config DETECT_HUNG_TASK
 	bool "Detect Hung Tasks"
 	depends on DEBUG_KERNEL
-- 
1.7.0.4

