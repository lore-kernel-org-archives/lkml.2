Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab1KRXQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:16:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53039 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911Ab1KRXQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:16:16 -0500
Date: Fri, 18 Nov 2011 15:15:44 -0800
From: "tip-bot for Luck, Tony" <tony.luck@intel.com>
Message-ID: <tip-66f5ddf30a59f811818656cb2833c80da0340cfa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        arjan@linux.intel.com, tony.luck@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, tglx@linutronix.de, tony.luck@intel.com,
        mingo@elte.hu
In-Reply-To: <4eb2e1971326651a3b@agluck-desktop.sc.intel.com>
References: <4eb2e1971326651a3b@agluck-desktop.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mce: Make mce_chrdev_ops 'static const'
Git-Commit-ID: 66f5ddf30a59f811818656cb2833c80da0340cfa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:15:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  66f5ddf30a59f811818656cb2833c80da0340cfa
Gitweb:     http://git.kernel.org/tip/66f5ddf30a59f811818656cb2833c80da0340cfa
Author:     Luck, Tony <tony.luck@intel.com>
AuthorDate: Thu, 3 Nov 2011 11:46:47 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 8 Nov 2011 16:17:11 +0100

x86/mce: Make mce_chrdev_ops 'static const'

Arjan would like to make struct file_operations const, but
mce-inject directly writes to the mce_chrdev_ops to install its
write handler. In an ideal world mce-inject would have its own
character device, but we have a sizable legacy of test scripts
that hardwire "/dev/mcelog", so it would be painful to switch to
a separate device now. Instead, this patch switches to a stub
function in the mce code, with a registration helper that
mce-inject can call when it is loaded.

Note that this would also allow for a sane process to allow
mce-inject to be unloaded again (with an unregister function,
and appropriate module_{get,put}() calls), but that is left for
potential future patches.

Reported-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/4eb2e1971326651a3b@agluck-desktop.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/mce.h              |    5 ++++-
 arch/x86/kernel/cpu/mcheck/mce-inject.c |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c        |   25 ++++++++++++++++++++++---
 3 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index c9321f3..0e8ae57 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -201,7 +201,10 @@ int mce_notify_irq(void);
 void mce_notify_process(void);
 
 DECLARE_PER_CPU(struct mce, injectm);
-extern struct file_operations mce_chrdev_ops;
+
+extern void register_mce_write_callback(ssize_t (*)(struct file *filp,
+				    const char __user *ubuf,
+				    size_t usize, loff_t *off));
 
 /*
  * Exception handler
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 6199232..319882e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -208,7 +208,7 @@ static int inject_init(void)
 	if (!alloc_cpumask_var(&mce_inject_cpumask, GFP_KERNEL))
 		return -ENOMEM;
 	printk(KERN_INFO "Machine check injector initialized\n");
-	mce_chrdev_ops.write = mce_write;
+	register_mce_write_callback(mce_write);
 	register_nmi_handler(NMI_LOCAL, mce_raise_notify, 0,
 				"mce_notify");
 	return 0;
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 362056a..2af127d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1634,16 +1634,35 @@ static long mce_chrdev_ioctl(struct file *f, unsigned int cmd,
 	}
 }
 
-/* Modified in mce-inject.c, so not static or const */
-struct file_operations mce_chrdev_ops = {
+static ssize_t (*mce_write)(struct file *filp, const char __user *ubuf,
+			    size_t usize, loff_t *off);
+
+void register_mce_write_callback(ssize_t (*fn)(struct file *filp,
+			     const char __user *ubuf,
+			     size_t usize, loff_t *off))
+{
+	mce_write = fn;
+}
+EXPORT_SYMBOL_GPL(register_mce_write_callback);
+
+ssize_t mce_chrdev_write(struct file *filp, const char __user *ubuf,
+			 size_t usize, loff_t *off)
+{
+	if (mce_write)
+		return mce_write(filp, ubuf, usize, off);
+	else
+		return -EINVAL;
+}
+
+static const struct file_operations mce_chrdev_ops = {
 	.open			= mce_chrdev_open,
 	.release		= mce_chrdev_release,
 	.read			= mce_chrdev_read,
+	.write			= mce_chrdev_write,
 	.poll			= mce_chrdev_poll,
 	.unlocked_ioctl		= mce_chrdev_ioctl,
 	.llseek			= no_llseek,
 };
-EXPORT_SYMBOL_GPL(mce_chrdev_ops);
 
 static struct miscdevice mce_chrdev_device = {
 	MISC_MCELOG_MINOR,
