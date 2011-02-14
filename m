Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab1BNTFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:05:17 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:43866
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751209Ab1BNTFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:05:13 -0500
X-SpamScore: -8
X-BigFish: VPS-8(zzbb2cK98dNzz1202hzz8275bhz32i637h668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LGMFOF-02-4A1-02
X-M-MSG: 
Date: Mon, 14 Feb 2011 20:05:05 +0100
From: Robert Richter <robert.richter@amd.com>
To: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
CC: "mingo@elte.hu" <mingo@elte.hu>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Maran Pakkirisamy <maranp@linux.vnet.ibm.com>
Subject: [PATCH] oprofile, s390: Rework hwsampler implementation
Message-ID: <20110214190505.GU5874@erda.amd.com>
References: <20110121100651.821690659@linux.vnet.ibm.com>
 <20110121100842.039354578@linux.vnet.ibm.com>
 <20110214190157.GS5874@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110214190157.GS5874@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resent with subject changed)

On 14.02.11 20:01:57, Robert Richter wrote:
> I reworked some changes in a follow-on patch which I apply on top of
> your patch set.

See below for the patch.

-Robert



>From c43ad95d99aec85ba497bec3a8a8131a93098281 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Fri, 11 Feb 2011 17:31:44 +0100
Subject: [PATCH] oprofile, s390: Rework hwsampler implementation

This patch is a rework of the hwsampler oprofile implementation that
has been applied recently. Now there are less non-architectural
changes. The only changes are:

* introduction of oprofile_add_ext_hw_sample(), and
* removal of section attributes of oprofile_timer_init/_exit().

To setup hwsampler for oprofile we need to modify start()/stop()
callbacks and additional hwsampler control files in oprofilefs. We do
not reinitialize the timer or hwsampler mode by restarting calling
init/exit() anymore, instead hwsampler_running is used to switch the
mode directly in oprofile_hwsampler_start/_stop(). For locking reasons
there is also hwsampler_file that reflects the value in oprofilefs.

The overall diffstat of the oprofile s390 hwsampler implemenation
shows the low impact to non-architectural code:

 arch/Kconfig                         |    3 +
 arch/s390/Kconfig                    |    1 +
 arch/s390/oprofile/Makefile          |    2 +-
 arch/s390/oprofile/hwsampler.c       | 1256 ++++++++++++++++++++++++++++++++++
 arch/s390/oprofile/hwsampler.h       |  113 +++
 arch/s390/oprofile/hwsampler_files.c |  162 +++++
 arch/s390/oprofile/init.c            |    6 +-
 drivers/oprofile/cpu_buffer.c        |   24 +-
 drivers/oprofile/timer_int.c         |    4 +-
 include/linux/oprofile.h             |    7 +
 10 files changed, 1567 insertions(+), 11 deletions(-)

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/s390/oprofile/hwsampler_files.c |   60 +++++++++++++++++++++------------
 arch/s390/oprofile/init.c            |    1 -
 drivers/oprofile/oprof.c             |   32 ------------------
 drivers/oprofile/oprof.h             |    2 -
 drivers/oprofile/timer_int.c         |   15 ++-------
 include/linux/oprofile.h             |   21 ------------
 6 files changed, 41 insertions(+), 90 deletions(-)

diff --git a/arch/s390/oprofile/hwsampler_files.c b/arch/s390/oprofile/hwsampler_files.c
index 493f7cc..2e1da24 100644
--- a/arch/s390/oprofile/hwsampler_files.c
+++ b/arch/s390/oprofile/hwsampler_files.c
@@ -8,6 +8,7 @@
 #include <linux/errno.h>
 #include <linux/fs.h>
 
+#include "../../../drivers/oprofile/oprof.h"
 #include "hwsampler.h"
 
 #define DEFAULT_INTERVAL	4096
@@ -22,12 +23,20 @@ static unsigned long oprofile_max_interval;
 static unsigned long oprofile_sdbt_blocks = DEFAULT_SDBT_BLOCKS;
 static unsigned long oprofile_sdb_blocks = DEFAULT_SDB_BLOCKS;
 
-static unsigned long oprofile_hwsampler;
+static int hwsampler_file;
+static int hwsampler_running;	/* start_mutex must be held to change */
+
+static struct oprofile_operations timer_ops;
 
 static int oprofile_hwsampler_start(void)
 {
 	int retval;
 
+	hwsampler_running = hwsampler_file;
+
+	if (!hwsampler_running)
+		return timer_ops.start();
+
 	retval = hwsampler_allocate(oprofile_sdbt_blocks, oprofile_sdb_blocks);
 	if (retval)
 		return retval;
@@ -41,25 +50,20 @@ static int oprofile_hwsampler_start(void)
 
 static void oprofile_hwsampler_stop(void)
 {
+	if (!hwsampler_running) {
+		timer_ops.stop();
+		return;
+	}
+
 	hwsampler_stop_all();
 	hwsampler_deallocate();
 	return;
 }
 
-int oprofile_arch_set_hwsampler(struct oprofile_operations *ops)
-{
-	printk(KERN_INFO "oprofile: using hardware sampling\n");
-	ops->start = oprofile_hwsampler_start;
-	ops->stop = oprofile_hwsampler_stop;
-	ops->cpu_type = "timer";
-
-	return 0;
-}
-
 static ssize_t hwsampler_read(struct file *file, char __user *buf,
 		size_t count, loff_t *offset)
 {
-	return oprofilefs_ulong_to_user(oprofile_hwsampler, buf, count, offset);
+	return oprofilefs_ulong_to_user(hwsampler_file, buf, count, offset);
 }
 
 static ssize_t hwsampler_write(struct file *file, char const __user *buf,
@@ -75,15 +79,16 @@ static ssize_t hwsampler_write(struct file *file, char const __user *buf,
 	if (retval)
 		return retval;
 
-	if (oprofile_hwsampler == val)
-		return -EINVAL;
-
-	retval = oprofile_set_hwsampler(val);
+	if (oprofile_started)
+		/*
+		 * save to do without locking as we set
+		 * hwsampler_running in start() when start_mutex is
+		 * held
+		 */
+		return -EBUSY;
 
-	if (retval)
-		return retval;
+	hwsampler_file = val;
 
-	oprofile_hwsampler = val;
 	return count;
 }
 
@@ -98,7 +103,7 @@ static int oprofile_create_hwsampling_files(struct super_block *sb,
 	struct dentry *hw_dir;
 
 	/* reinitialize default values */
-	oprofile_hwsampler = 1;
+	hwsampler_file = 1;
 
 	hw_dir = oprofilefs_mkdir(sb, root, "hwsampling");
 	if (!hw_dir)
@@ -125,7 +130,6 @@ int oprofile_hwsampler_init(struct oprofile_operations* ops)
 	/*
 	 * create hwsampler files only if hwsampler_setup() succeeds.
 	 */
-	ops->create_files = oprofile_create_hwsampling_files;
 	oprofile_min_interval = hwsampler_query_min_interval();
 	if (oprofile_min_interval < 0) {
 		oprofile_min_interval = 0;
@@ -136,11 +140,23 @@ int oprofile_hwsampler_init(struct oprofile_operations* ops)
 		oprofile_max_interval = 0;
 		return -ENODEV;
 	}
-	oprofile_arch_set_hwsampler(ops);
+
+	if (oprofile_timer_init(ops))
+		return -ENODEV;
+
+	printk(KERN_INFO "oprofile: using hardware sampling\n");
+
+	memcpy(&timer_ops, ops, sizeof(timer_ops));
+
+	ops->start = oprofile_hwsampler_start;
+	ops->stop = oprofile_hwsampler_stop;
+	ops->create_files = oprofile_create_hwsampling_files;
+
 	return 0;
 }
 
 void oprofile_hwsampler_exit(void)
 {
+	oprofile_timer_exit();
 	hwsampler_shutdown();
 }
diff --git a/arch/s390/oprofile/init.c b/arch/s390/oprofile/init.c
index f6b3f72..059b44b 100644
--- a/arch/s390/oprofile/init.c
+++ b/arch/s390/oprofile/init.c
@@ -11,7 +11,6 @@
 #include <linux/oprofile.h>
 #include <linux/init.h>
 #include <linux/errno.h>
-#include <linux/fs.h>
 
 extern int oprofile_hwsampler_init(struct oprofile_operations* ops);
 extern void oprofile_hwsampler_exit(void);
diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index 43b01da..f9bda64 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -239,38 +239,6 @@ int oprofile_set_ulong(unsigned long *addr, unsigned long val)
 	return err;
 }
 
-#ifdef CONFIG_HAVE_HWSAMPLER
-int oprofile_set_hwsampler(unsigned long val)
-{
-	int err = 0;
-
-	mutex_lock(&start_mutex);
-
-	if (oprofile_started) {
-		err = -EBUSY;
-		goto out;
-	}
-
-	switch (val) {
-	case 1:
-		/* Switch to hardware sampling. */
-		__oprofile_timer_exit();
-		err = oprofile_arch_set_hwsampler(&oprofile_ops);
-		break;
-	case 0:
-		printk(KERN_INFO "oprofile: using timer interrupt.\n");
-		err = __oprofile_timer_init(&oprofile_ops);
-		break;
-	default:
-		err = -EINVAL;
-	}
-
-out:
-	mutex_unlock(&start_mutex);
-	return err;
-}
-#endif /* CONFIG_HAVE_HWSAMPLER */
-
 static int __init oprofile_init(void)
 {
 	int err;
diff --git a/drivers/oprofile/oprof.h b/drivers/oprofile/oprof.h
index 5a6ceb1..177b73d 100644
--- a/drivers/oprofile/oprof.h
+++ b/drivers/oprofile/oprof.h
@@ -35,9 +35,7 @@ struct dentry;
 
 void oprofile_create_files(struct super_block *sb, struct dentry *root);
 int oprofile_timer_init(struct oprofile_operations *ops);
-int __oprofile_timer_init(struct oprofile_operations *ops);
 void oprofile_timer_exit(void);
-void __oprofile_timer_exit(void);
 
 int oprofile_set_ulong(unsigned long *addr, unsigned long val);
 int oprofile_set_timeout(unsigned long time);
diff --git a/drivers/oprofile/timer_int.c b/drivers/oprofile/timer_int.c
index 0099a45..3ef4462 100644
--- a/drivers/oprofile/timer_int.c
+++ b/drivers/oprofile/timer_int.c
@@ -97,13 +97,14 @@ static struct notifier_block __refdata oprofile_cpu_notifier = {
 	.notifier_call = oprofile_cpu_notify,
 };
 
-int  __oprofile_timer_init(struct oprofile_operations *ops)
+int oprofile_timer_init(struct oprofile_operations *ops)
 {
 	int rc;
 
 	rc = register_hotcpu_notifier(&oprofile_cpu_notifier);
 	if (rc)
 		return rc;
+	ops->create_files = NULL;
 	ops->setup = NULL;
 	ops->shutdown = NULL;
 	ops->start = oprofile_hrtimer_start;
@@ -112,17 +113,7 @@ int  __oprofile_timer_init(struct oprofile_operations *ops)
 	return 0;
 }
 
-int __init oprofile_timer_init(struct oprofile_operations *ops)
-{
-	return __oprofile_timer_init(ops);
-}
-
-void __oprofile_timer_exit(void)
+void oprofile_timer_exit(void)
 {
 	unregister_hotcpu_notifier(&oprofile_cpu_notifier);
 }
-
-void __exit oprofile_timer_exit(void)
-{
-	__oprofile_timer_exit();
-}
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index b517d86..7f5cfd3 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -91,27 +91,6 @@ int oprofile_arch_init(struct oprofile_operations * ops);
  */
 void oprofile_arch_exit(void);
 
-#ifdef CONFIG_HAVE_HWSAMPLER
-/**
- * setup hardware sampler for oprofiling.
- */
-
-int oprofile_set_hwsampler(unsigned long);
-
-/**
- * hardware sampler module initialization for the s390 arch
- */
-
-int oprofile_arch_set_hwsampler(struct oprofile_operations *ops);
-
-/**
- * Add an s390 hardware sample.
- */
-void oprofile_add_ext_hw_sample(unsigned long pc, struct pt_regs * const regs,
-	unsigned long event, int is_kernel,
-	struct task_struct *task);
-#endif /* CONFIG_HAVE_HWSAMPLER */
-
 /**
  * Add a sample. This may be called from any context.
  */
-- 
1.7.3.4



-- 
Advanced Micro Devices, Inc.
Operating System Research Center

