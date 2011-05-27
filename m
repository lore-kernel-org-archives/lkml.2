Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab1E0EMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 00:12:50 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33218 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab1E0EMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 00:12:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDF24B2.60607@jp.fujitsu.com>
Date: Fri, 27 May 2011 13:12:34 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 11/12] x86, mce: use prefix mce_chrdev_ to group functions
References: <4DDF21DE.9040705@jp.fujitsu.com>
In-Reply-To: <4DDF21DE.9040705@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many functions named mce_*, so use new prefix for
subset of functions that related to character device /dev/mcelog.

This change doesn't impact mce-inject module, because the exported
symbol mce_chrdev_ops already has the prefix so not changed.

  Before:			After:
   mce_wait			 mce_chrdev_wait
   mce_state_lock		 mce_chrdev_state_lock
   open_count   		 mce_chrdev_open_count
   open_exclu   		 mce_chrdev_open_exclu
   mce_open			 mce_chrdev_open
   mce_release  		 mce_chrdev_release
   mce_read_mutex		 mce_chrdev_read_mutex
   mce_read			 mce_chrdev_read
   mce_poll			 mce_chrdev_poll
   mce_ioctl    		 mce_chrdev_ioctl
   mce_log_device		 mce_chrdev_device

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   77 ++++++++++++++++++++------------------
 1 files changed, 41 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 4ba4040..ba2fc2d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -45,12 +45,12 @@
 
 #include "mce-internal.h"
 
-static DEFINE_MUTEX(mce_read_mutex);
+static DEFINE_MUTEX(mce_chrdev_read_mutex);
 
 #define rcu_dereference_check_mce(p) \
 	rcu_dereference_index_check((p), \
 			      rcu_read_lock_sched_held() || \
-			      lockdep_is_held(&mce_read_mutex))
+			      lockdep_is_held(&mce_chrdev_read_mutex))
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/mce.h>
@@ -90,7 +90,8 @@ static unsigned long		mce_need_notify;
 static char			mce_helper[128];
 static char			*mce_helper_argv[2] = { mce_helper, NULL };
 
-static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
+static DECLARE_WAIT_QUEUE_HEAD(mce_chrdev_wait);
+
 static DEFINE_PER_CPU(struct mce, mces_seen);
 static int			cpu_missing;
 
@@ -1155,7 +1156,8 @@ int mce_notify_irq(void)
 	clear_thread_flag(TIF_MCE_NOTIFY);
 
 	if (test_and_clear_bit(0, &mce_need_notify)) {
-		wake_up_interruptible(&mce_wait);
+		/* wake processes polling /dev/mcelog */
+		wake_up_interruptible(&mce_chrdev_wait);
 
 		/*
 		 * There is no risk of missing notifications because
@@ -1419,40 +1421,41 @@ void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
 }
 
 /*
- * Character device to read and clear the MCE log.
+ * mce_chrdev: Character device /dev/mcelog to read and clear the MCE log.
  */
 
-static DEFINE_SPINLOCK(mce_state_lock);
-static int		open_count;		/* #times opened */
-static int		open_exclu;		/* already open exclusive? */
+static DEFINE_SPINLOCK(mce_chrdev_state_lock);
+static int mce_chrdev_open_count;	/* #times opened */
+static int mce_chrdev_open_exclu;	/* already open exclusive? */
 
-static int mce_open(struct inode *inode, struct file *file)
+static int mce_chrdev_open(struct inode *inode, struct file *file)
 {
-	spin_lock(&mce_state_lock);
+	spin_lock(&mce_chrdev_state_lock);
 
-	if (open_exclu || (open_count && (file->f_flags & O_EXCL))) {
-		spin_unlock(&mce_state_lock);
+	if (mce_chrdev_open_exclu ||
+	    (mce_chrdev_open_count && (file->f_flags & O_EXCL))) {
+		spin_unlock(&mce_chrdev_state_lock);
 
 		return -EBUSY;
 	}
 
 	if (file->f_flags & O_EXCL)
-		open_exclu = 1;
-	open_count++;
+		mce_chrdev_open_exclu = 1;
+	mce_chrdev_open_count++;
 
-	spin_unlock(&mce_state_lock);
+	spin_unlock(&mce_chrdev_state_lock);
 
 	return nonseekable_open(inode, file);
 }
 
-static int mce_release(struct inode *inode, struct file *file)
+static int mce_chrdev_release(struct inode *inode, struct file *file)
 {
-	spin_lock(&mce_state_lock);
+	spin_lock(&mce_chrdev_state_lock);
 
-	open_count--;
-	open_exclu = 0;
+	mce_chrdev_open_count--;
+	mce_chrdev_open_exclu = 0;
 
-	spin_unlock(&mce_state_lock);
+	spin_unlock(&mce_chrdev_state_lock);
 
 	return 0;
 }
@@ -1501,8 +1504,8 @@ static int __mce_read_apei(char __user **ubuf, size_t usize)
 	return 0;
 }
 
-static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
-			loff_t *off)
+static ssize_t mce_chrdev_read(struct file *filp, char __user *ubuf,
+				size_t usize, loff_t *off)
 {
 	char __user *buf = ubuf;
 	unsigned long *cpu_tsc;
@@ -1513,7 +1516,7 @@ static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
 	if (!cpu_tsc)
 		return -ENOMEM;
 
-	mutex_lock(&mce_read_mutex);
+	mutex_lock(&mce_chrdev_read_mutex);
 
 	if (!mce_apei_read_done) {
 		err = __mce_read_apei(&buf, usize);
@@ -1578,15 +1581,15 @@ timeout:
 		err = -EFAULT;
 
 out:
-	mutex_unlock(&mce_read_mutex);
+	mutex_unlock(&mce_chrdev_read_mutex);
 	kfree(cpu_tsc);
 
 	return err ? err : buf - ubuf;
 }
 
-static unsigned int mce_poll(struct file *file, poll_table *wait)
+static unsigned int mce_chrdev_poll(struct file *file, poll_table *wait)
 {
-	poll_wait(file, &mce_wait, wait);
+	poll_wait(file, &mce_chrdev_wait, wait);
 	if (rcu_access_index(mcelog.next))
 		return POLLIN | POLLRDNORM;
 	if (!mce_apei_read_done && apei_check_mce())
@@ -1594,7 +1597,8 @@ static unsigned int mce_poll(struct file *file, poll_table *wait)
 	return 0;
 }
 
-static long mce_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
+static long mce_chrdev_ioctl(struct file *f, unsigned int cmd,
+				unsigned long arg)
 {
 	int __user *p = (int __user *)arg;
 
@@ -1622,16 +1626,16 @@ static long mce_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 
 /* Modified in mce-inject.c, so not static or const */
 struct file_operations mce_chrdev_ops = {
-	.open			= mce_open,
-	.release		= mce_release,
-	.read			= mce_read,
-	.poll			= mce_poll,
-	.unlocked_ioctl		= mce_ioctl,
-	.llseek		= no_llseek,
+	.open			= mce_chrdev_open,
+	.release		= mce_chrdev_release,
+	.read			= mce_chrdev_read,
+	.poll			= mce_chrdev_poll,
+	.unlocked_ioctl		= mce_chrdev_ioctl,
+	.llseek			= no_llseek,
 };
 EXPORT_SYMBOL_GPL(mce_chrdev_ops);
 
-static struct miscdevice mce_log_device = {
+static struct miscdevice mce_chrdev_device = {
 	MISC_MCELOG_MINOR,
 	"mcelog",
 	&mce_chrdev_ops,
@@ -2103,11 +2107,12 @@ static __init int mcheck_init_device(void)
 
 	register_syscore_ops(&mce_syscore_ops);
 	register_hotcpu_notifier(&mce_cpu_notifier);
-	misc_register(&mce_log_device);
+
+	/* register character device /dev/mcelog */
+	misc_register(&mce_chrdev_device);
 
 	return err;
 }
-
 device_initcall(mcheck_init_device);
 
 /*
-- 
1.7.1


