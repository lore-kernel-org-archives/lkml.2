Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab1JaVCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 17:02:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:26210 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab1JaVCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 17:02:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,434,1315206000"; 
   d="scan'208";a="84531548"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCHv2] Make mce_chrdev_ops "static const"
In-Reply-To: <4eaeea2d17118d40b4@agluck-desktop.sc.intel.com>
Date: Mon, 31 Oct 2011 14:02:41 -0700
Message-Id: <4eaf0cf1139477a87b@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan would like to make struct file_operations const, but mce-inject
directly writes to the mce_chrdev_ops to install its write handler.
In an ideal world mce-inject would have its own character device, but
we have a sizable legacy of test scripts that hardwire "/dev/mcelog",
so it would be painful to switch to a separate device now. Instead,
this patch switches to a stub function in the mce code, with a
registration helper that mce-inject can call when it is loaded.

Note that this would also allow for a sane process to allow mce-inject
to be unloaded again (with an unregister function, and appropriate
module_{get,put}() calls), but that is left for potential future patches.

Reported-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>

---

v2 - fixes some checkpatch complaints about tabs/spaces/long-lines, and
     more importantly fixes the problems that Arjan wants fixed (rather
     than enabling him to apply the 2-liner to fix it).

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index c9321f3..22cc0eb 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -201,7 +201,10 @@ int mce_notify_irq(void);
 void mce_notify_process(void);
 
 DECLARE_PER_CPU(struct mce, injectm);
-extern struct file_operations mce_chrdev_ops;
+
+extern void register_mce_write_hook(ssize_t (*)(struct file *filp,
+				    const char __user *ubuf,
+				    size_t usize, loff_t *off));
 
 /*
  * Exception handler
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 0ed633c..a18c2c8 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -215,7 +215,7 @@ static int inject_init(void)
 	if (!alloc_cpumask_var(&mce_inject_cpumask, GFP_KERNEL))
 		return -ENOMEM;
 	printk(KERN_INFO "Machine check injector initialized\n");
-	mce_chrdev_ops.write = mce_write;
+	register_mce_write_hook(mce_write);
 	register_die_notifier(&mce_raise_nb);
 	return 0;
 }
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 08363b0..7010901 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1628,16 +1628,35 @@ static long mce_chrdev_ioctl(struct file *f, unsigned int cmd,
 	}
 }
 
-/* Modified in mce-inject.c, so not static or const */
-struct file_operations mce_chrdev_ops = {
+static ssize_t (*mce_write)(struct file *filp, const char __user *ubuf,
+			    size_t usize, loff_t *off);
+
+void register_mce_write_hook(ssize_t (*fn)(struct file *filp,
+			     const char __user *ubuf,
+			     size_t usize, loff_t *off))
+{
+	mce_write = fn;
+}
+EXPORT_SYMBOL_GPL(register_mce_write_hook);
+
+ssize_t mce_chrdev_write(struct file *filp, const char __user *ubuf,
+			 size_t usize, loff_t *off)
+{
+	if (mce_write)
+		return mce_write(filp, ubuf, usize, off);
+	else
+		return -ENODEV;
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
