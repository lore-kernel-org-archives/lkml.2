Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab0F2XWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 19:22:31 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:32037 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869Ab0F2XW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 19:22:29 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jun 2010 19:22:29 EDT
From: Dmitry Torokhov <dtor@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: pv-drivers@vmware.com
Subject: [RFC/PATCH 2/2] VMware balloon: add page sharing interface
Date: Tue, 29 Jun 2010 16:15:44 -0700
Message-Id: <1277853344-19617-2-git-send-email-dtor@vmware.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1277853344-19617-1-git-send-email-dtor@vmware.com>
References: <1277853344-19617-1-git-send-email-dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Huang <whuang@vmware.com>

VMware indentifies a class of applications which manage their own
memory space and may have performance issues with existing balloon
driver. An example is Java virtual machines. JVM maps a large range
of virtual address space as heap and manages the heap itself. With
balloon driver the OS may end up having less memory to use to back
up the whole heap, which can cause undesirable disk swap and
performance degradation.

This patch introduces an interface that allows programs communicate
amount of memory they manage themselves (stored in
vmballoon_pshare_context->max_size for individual application and
vmballoon->max_pshare_size for total size). The driver then reduces
it's internal balloon target (see vmballoon_adjust_target() function)
and reports the difference to the registered applications so that
they could close the gap. The user level applications then are
expected to fill this gap by, for example, notifying hypervisor
that certain pages could be shared.

Signed-off-by: Wei Huang <whuang@vmware.com>
Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---
 Documentation/kernel-parameters.txt |    6 +
 drivers/misc/vmware_balloon.c       |  293 +++++++++++++++++++++++++++++++++--
 2 files changed, 287 insertions(+), 12 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 3aabe6e..45b104a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2813,6 +2813,12 @@ and is between 256 and 4096 characters. It is defined in the file
 	vmpoff=		[KNL,S390] Perform z/VM CP command after power off.
 			Format: <command>
 
+	vmware_balloon.enable_pshare =
+			[HW] Enable page share interface to the balloon module
+			allowing userspace clients to signal the amount of
+			pages available for sharing and amount of pages being
+			shared so that balloon target can be adjusted
+			accordingly. Default is enabled.
 	vmware_balloon.os_percentage =
 			[HW] Percentage of memory reserved for OS needs and
 			therefore is not balloonable. Default is 20%.
diff --git a/drivers/misc/vmware_balloon.c b/drivers/misc/vmware_balloon.c
index 061cc3e..c6976a3 100644
--- a/drivers/misc/vmware_balloon.c
+++ b/drivers/misc/vmware_balloon.c
@@ -39,13 +39,18 @@
 #include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/workqueue.h>
+#include <linux/wait.h>
 #include <linux/debugfs.h>
+#include <linux/cdev.h>
+#include <linux/compat.h>
+#include <linux/slab.h>
 #include <linux/seq_file.h>
+#include <linux/uaccess.h>
 #include <asm/hypervisor.h>
 
 MODULE_AUTHOR("VMware, Inc.");
 MODULE_DESCRIPTION("VMware Memory Control (Balloon) Driver");
-MODULE_VERSION("1.2.1.2-k");
+MODULE_VERSION("1.2.1.3-k");
 MODULE_ALIAS("dmi:*:svnVMware*:*");
 MODULE_ALIAS("vmware_vmmemctl");
 MODULE_LICENSE("GPL");
@@ -118,6 +123,22 @@ MODULE_LICENSE("GPL");
 #define VMW_BALLOON_CMD_UNLOCK		3
 #define VMW_BALLOON_CMD_GUEST_ID	4
 
+/* ioctl command to communicate with user level pshare agent */
+#define VMW_BALLOON_API_VERSION		15
+#define VMW_BALLOON_IOC_GET_VERSION	_IOR('B', 0x01, unsigned int)
+
+/*
+ * Even with user level psharing ability, at the minimum we still use normal
+ * in-kernel balloon up to 6% of total memory. This is because in-kernel
+ * balloon typically responds faster than user level psharing. Having certain
+ * amount of in-kernel balloon helps dealing with work load spikes on host
+ * machines.
+ */
+#define VMW_MIN_SYSBALLOON_PERCENTAGE   6
+
+/* Minor device number */
+#define VMW_BALLOON_DEVICE_MINIOR	0
+
 /* error codes */
 #define VMW_BALLOON_SUCCESS		0
 #define VMW_BALLOON_FAILURE		-1
@@ -178,6 +199,15 @@ struct vmballoon_stats {
 #define STATS_INC(stat)
 #endif
 
+/* Pshare information from user level agent */
+struct vmballoon_pshare_info {
+	u64 max_size;		/* In pages */
+};
+
+struct vmballoon_pshare_target {
+	u64 target_size;	/* In pages */
+};
+
 struct vmballoon {
 
 	/* list of reserved physical pages */
@@ -191,6 +221,14 @@ struct vmballoon {
 	unsigned int size;
 	unsigned int target;
 
+	/* user level pshare */
+	unsigned int max_pshare_size;
+	unsigned int pshare_target;
+
+	unsigned int dev_major;
+	spinlock_t pshare_lock;
+	wait_queue_head_t wait_target_queue;
+
 	/* reset flag */
 	bool reset_required;
 
@@ -214,9 +252,19 @@ struct vmballoon {
 	struct delayed_work dwork;
 };
 
+struct vmballoon_pshare_context {
+	struct vmballoon *balloon;
+	unsigned int max_size;		/* All sizes are in pages */
+};
+
+
 static struct vmballoon balloon;
 static struct workqueue_struct *vmballoon_wq;
 
+static bool vmballoon_enable_pshare = true;
+module_param_named(enable_pshare, vmballoon_enable_pshare, bool, 0444);
+MODULE_PARM_DESC(enable_pshare, "Enable page share interface (default=true)");
+
 /*
  * We reserve, by default, 20% of the total RAM for OS needs, limiting
  * balloon size to 80% of the total RAM.
@@ -652,6 +700,48 @@ static void vmballoon_deflate(struct vmballoon *b)
 }
 
 /*
+ * Adjust balloon target with the knowledge of user level psharing
+ */
+static unsigned int vmballoon_adjust_target(struct vmballoon *b, unsigned int target)
+{
+	unsigned int max_target, min_target, new_target;
+
+	max_target = b->sysinfo.totalram *
+			(100 - vmballoon_os_percentage) / 100;
+
+	if (vmballoon_enable_pshare) {
+		min_target = b->sysinfo.totalram * VMW_MIN_SYSBALLOON_PERCENTAGE / 100;
+
+		if (max_target > b->max_pshare_size + min_target) {
+			/*
+			 * Normally, when we have a single pshare user
+			 * registered, we split work between in-kernel
+			 * balloon and userspace.
+			 */
+			max_target -= b->max_pshare_size;
+
+		} else {
+			/*
+			 * If registered share size is larger than
+			 * memory size make sure that we still
+			 * do some in-kernel ballooning to quickly
+			 * react to memory pressure in host.
+			 */
+			max_target = min_target;
+		}
+
+		new_target = min(target, max_target);
+		b->pshare_target = target - new_target;
+		if (b->pshare_target)
+			wake_up_interruptible(&b->wait_target_queue);
+	} else {
+		new_target = min(target, max_target);
+	}
+
+	return new_target;
+}
+
+/*
  * Balloon work function: reset protocol, if needed, get the new size and
  * adjust balloon as needed. Repeat in 1 sec.
  */
@@ -659,7 +749,7 @@ static void vmballoon_work(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct vmballoon *b = container_of(dwork, struct vmballoon, dwork);
-	unsigned int max_target, target;
+	unsigned int target;
 
 	STATS_INC(b->stats.timer);
 
@@ -671,13 +761,10 @@ static void vmballoon_work(struct work_struct *work)
 
 	if (vmballoon_send_get_target(b, &target)) {
 		/* update target, adjust size */
-		max_target = b->sysinfo.totalram *
-				(100 - vmballoon_os_percentage) / 100;
-		b->target = min(target, max_target);
-
-		if (b->size < target)
+		b->target = vmballoon_adjust_target(b, target);
+		if (b->size < b->target)
 			vmballoon_inflate(b);
-		else if (b->size > target)
+		else if (b->size > b->target)
 			vmballoon_deflate(b);
 	}
 
@@ -697,8 +784,11 @@ static int vmballoon_debug_show(struct seq_file *f, void *offset)
 	/* format size info */
 	seq_printf(f,
 		   "target:             %8d pages\n"
-		   "current:            %8d pages\n",
-		   b->target, b->size);
+		   "current:            %8d pages\n"
+		   "pshareTarget:       %8d pages\n"
+		   "pshareMax:          %8d pages\n",
+		   b->target, b->size,
+		   b->pshare_target, b->max_pshare_size);
 
 	/* format rate info */
 	seq_printf(f,
@@ -781,6 +871,179 @@ static inline void vmballoon_debugfs_exit(struct vmballoon *b)
 
 #endif	/* CONFIG_DEBUG_FS */
 
+/*
+ * User level pshare
+ */
+
+static int vmballoon_pshare_open(struct inode *inode, struct file *filep)
+{
+	struct vmballoon_pshare_context *context;
+	struct vmballoon *b = &balloon;
+
+	context = kzalloc(sizeof *context, GFP_KERNEL);
+	if (!context) {
+		pr_err("Cannot allocate memory for new agent context\n");
+		return -ENOMEM;
+	}
+	context->balloon = b;
+	filep->private_data = context;
+
+	pr_debug("pshare open called on file %p, context %p\n",
+			filep, context);
+
+	return 0;
+}
+
+static int vmballoon_pshare_release(struct inode *inode, struct file *filep)
+{
+	struct vmballoon_pshare_context *context = filep->private_data;
+	struct vmballoon *b = context->balloon;
+
+	spin_lock(&b->pshare_lock);
+	b->max_pshare_size -= context->max_size;
+	spin_unlock(&b->pshare_lock);
+
+	kfree(context);
+
+	pr_debug("Freeing context %p on file %p\n", context, filep);
+
+	return 0;
+}
+
+static long vmballoon_pshare_ioctl(struct file *filep,
+				   unsigned int cmd, void __user *p)
+{
+	if (cmd == VMW_BALLOON_IOC_GET_VERSION)
+		return put_user(VMW_BALLOON_API_VERSION, (int __user *)p);
+
+	return -EINVAL;
+}
+
+static long vmballoon_pshare_ioctl_native(struct file *file,
+					  unsigned int cmd, unsigned long arg)
+{
+	return vmballoon_pshare_ioctl(file, cmd, (void __user *)arg);
+}
+
+#ifdef CONFIG_COMPAT
+static long vmballoon_pshare_ioctl_compat(struct file *file,
+					  unsigned int cmd, unsigned long arg)
+{
+	return vmballoon_pshare_ioctl(file, cmd, compat_ptr(arg));
+}
+#endif
+
+static ssize_t vmballoon_pshare_read(struct file *filp, char __user *buf,
+				 size_t count, loff_t *pos)
+{
+	struct vmballoon_pshare_context *context = filp->private_data;
+	struct vmballoon *b = context->balloon;
+	struct vmballoon_pshare_target target;
+
+	if (count != sizeof(struct vmballoon_pshare_target)) {
+		pr_err("Driver supports only unsigned int read\n");
+		return -EINVAL;
+	}
+
+	if (b->pshare_target == 0 && !(filp->f_flags & O_NONBLOCK)) {
+		if (wait_event_interruptible(b->wait_target_queue,
+					     b->pshare_target != 0))
+			return -ERESTARTSYS;
+	}
+
+	spin_lock(&b->pshare_lock);
+
+	if (context->max_size == 0)
+		target.target_size = 0;
+	else
+		target.target_size = (unsigned long)b->pshare_target
+					* context->max_size
+					/ b->max_pshare_size;
+
+	spin_unlock(&b->pshare_lock);
+
+	if (copy_to_user(buf, &target, count))
+		return -EFAULT;
+
+	return count;
+}
+
+static ssize_t vmballoon_pshare_write(struct file *filp, const char __user *buf,
+				  size_t count, loff_t *pos)
+{
+	struct vmballoon_pshare_context *context = filp->private_data;
+	struct vmballoon *b = context->balloon;
+	struct vmballoon_pshare_info info;
+
+	if (count != sizeof(struct vmballoon_pshare_info)) {
+		pr_err("Incorrect write protocol\n");
+		return -EINVAL;
+	}
+
+	if (copy_from_user(&info, buf, count))
+		return -EFAULT;
+
+	spin_lock(&b->pshare_lock);
+
+	b->max_pshare_size -= context->max_size;
+	b->max_pshare_size += info.max_size;
+	context->max_size = info.max_size;
+
+	spin_unlock(&b->pshare_lock);
+
+	return count;
+}
+
+static const struct file_operations vmballoon_pshare_fops = {
+	.owner		= THIS_MODULE,
+	.open		= vmballoon_pshare_open,
+	.read		= vmballoon_pshare_read,
+	.write		= vmballoon_pshare_write,
+	.unlocked_ioctl	= vmballoon_pshare_ioctl_native,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= vmballoon_pshare_ioctl_compat,
+#endif
+	.release	= vmballoon_pshare_release,
+};
+
+static int __init vmballoon_pshare_init(struct vmballoon *b)
+{
+	int err;
+
+	if (!vmballoon_enable_pshare) {
+		pr_debug("Pshare interface disabled\n");
+		return 0;
+	}
+
+	if (vmballoon_os_percentage < 0 || vmballoon_os_percentage > 100)
+		vmballoon_os_percentage = 20;
+
+	spin_lock_init(&b->pshare_lock);
+	init_waitqueue_head(&b->wait_target_queue);
+
+	b->max_pshare_size = 0;
+	b->pshare_target = 0;
+
+	err = __register_chrdev(0, VMW_BALLOON_DEVICE_MINIOR, 1, "vmmemctl",
+				&vmballoon_pshare_fops);
+	if (err < 0) {
+		pr_err("Unable to allocate vmmemctl device\n");
+		return err;
+	}
+	b->dev_major = err;
+
+	pr_info("Pshare API version %d initialized\n", VMW_BALLOON_API_VERSION);
+
+	return 0;
+}
+
+static void vmballoon_pshare_exit(struct vmballoon *b)
+{
+	if (vmballoon_enable_pshare)
+		__unregister_chrdev(b->dev_major, VMW_BALLOON_DEVICE_MINIOR, 1,
+				    "vmmemctl");
+}
+
 static int __init vmballoon_init(void)
 {
 	int error;
@@ -822,14 +1085,20 @@ static int __init vmballoon_init(void)
 		goto fail;
 	}
 
-	error = vmballoon_debugfs_init(&balloon);
+	error = vmballoon_pshare_init(&balloon);
 	if (error)
 		goto fail;
 
+	error = vmballoon_debugfs_init(&balloon);
+	if (error)
+		goto fail_debugfs;
+
 	queue_delayed_work(vmballoon_wq, &balloon.dwork, 0);
 
 	return 0;
 
+fail_debugfs:
+	vmballoon_pshare_exit(&balloon);
 fail:
 	destroy_workqueue(vmballoon_wq);
 	return error;
@@ -842,7 +1111,7 @@ static void __exit vmballoon_exit(void)
 	destroy_workqueue(vmballoon_wq);
 
 	vmballoon_debugfs_exit(&balloon);
-
+	vmballoon_pshare_exit(&balloon);
 	/*
 	 * Deallocate all reserved memory, and reset connection with monitor.
 	 * Reset connection before deallocating memory to avoid potential for
-- 
1.7.0

