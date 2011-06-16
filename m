Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab1FPLUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:20:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:50352 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024Ab1FPLUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:20:33 -0400
Date: Thu, 16 Jun 2011 11:20:22 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Message-ID: <tip-93b62c3cf59d44850cbe9f04d58da08930e3fb0b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        seto.hidetoshi@jp.fujitsu.com, tony.luck@intel.com, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de, tony.luck@intel.com,
        borislav.petkov@amd.com
In-Reply-To: <4DEED7CD.3040500@jp.fujitsu.com>
References: <4DEED7CD.3040500@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:ras/core] x86, mce: Use mce_chrdev_ prefix to group functions
Git-Commit-ID: 93b62c3cf59d44850cbe9f04d58da08930e3fb0b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Jun 2011 11:20:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  93b62c3cf59d44850cbe9f04d58da08930e3fb0b
Gitweb:     http://git.kernel.org/tip/93b62c3cf59d44850cbe9f04d58da08930e3fb0b
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Wed, 8 Jun 2011 11:00:45 +0900
Committer:  Borislav Petkov <borislav.petkov@amd.com>
CommitDate: Thu, 16 Jun 2011 12:10:15 +0200

x86, mce: Use mce_chrdev_ prefix to group functions

There are many functions named mce_* so use a new prefix for the subset
of functions dealing with the character device /dev/mcelog.

This change doesn't impact the mce-inject module because the exported
symbol mce_chrdev_ops already has the prefix, therefore it is left
unchanged.

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
Acked-by: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/4DEED7CD.3040500@jp.fujitsu.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   77 ++++++++++++++++++++------------------
 1 files changed, 41 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 54360e8..9a73516 100644
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
 
@@ -1159,7 +1160,8 @@ int mce_notify_irq(void)
 	clear_thread_flag(TIF_MCE_NOTIFY);
 
 	if (test_and_clear_bit(0, &mce_need_notify)) {
-		wake_up_interruptible(&mce_wait);
+		/* wake processes polling /dev/mcelog */
+		wake_up_interruptible(&mce_chrdev_wait);
 
 		/*
 		 * There is no risk of missing notifications because
@@ -1423,40 +1425,41 @@ void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
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
@@ -1505,8 +1508,8 @@ static int __mce_read_apei(char __user **ubuf, size_t usize)
 	return 0;
 }
 
-static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
-			loff_t *off)
+static ssize_t mce_chrdev_read(struct file *filp, char __user *ubuf,
+				size_t usize, loff_t *off)
 {
 	char __user *buf = ubuf;
 	unsigned long *cpu_tsc;
@@ -1517,7 +1520,7 @@ static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
 	if (!cpu_tsc)
 		return -ENOMEM;
 
-	mutex_lock(&mce_read_mutex);
+	mutex_lock(&mce_chrdev_read_mutex);
 
 	if (!mce_apei_read_done) {
 		err = __mce_read_apei(&buf, usize);
@@ -1582,15 +1585,15 @@ timeout:
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
@@ -1598,7 +1601,8 @@ static unsigned int mce_poll(struct file *file, poll_table *wait)
 	return 0;
 }
 
-static long mce_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
+static long mce_chrdev_ioctl(struct file *f, unsigned int cmd,
+				unsigned long arg)
 {
 	int __user *p = (int __user *)arg;
 
@@ -1626,16 +1630,16 @@ static long mce_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 
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
@@ -2107,11 +2111,12 @@ static __init int mcheck_init_device(void)
 
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
