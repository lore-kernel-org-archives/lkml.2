Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab0GCCRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 22:17:54 -0400
Received: from king.tilera.com ([72.1.168.226]:11396 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501Ab0GCCRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 22:17:52 -0400
Message-Id: <201007030217.o632HoK9004030@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 2 Jul 2010 11:45:18 -0400
Subject: [PATCH] arch/tile: updates to hardwall code from community feedback.
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: arnd@arndb.de
X-OriginalArrivalTime: 03 Jul 2010 02:17:51.0177 (UTC) FILETIME=[F007B390:01CB1A55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change reflects some feedback from Arnd Bergmann, and also
fixes a compat issue by removing the requirement that the cpumask
pointer passed to the ioctl point to memory whose size is a
multiple of sizeof(long), since that is awkward when userspace
has a different sizeof(long).

The compat_ptr() declaration was fixed and used to pass the
compat_ioctl argument to the normal ioctl.  So far we limit compat
code to 2GB, so the difference between zero-extend and sign-extend
(the latter being correct, eventually) had been overlooked.

Remove the file_to_hardwall() abstractions since they're not
really needed.

In addition, use <linux/list_types.h> to simplify hardwall code.
Instead of using a bogus hardwall_list type, we can now use
the proper list_head type directly.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/compat.h    |    2 +-
 arch/tile/include/asm/hardwall.h  |    3 +-
 arch/tile/include/asm/processor.h |    9 +---
 arch/tile/kernel/hardwall.c       |   89 +++++++++++++++----------------------
 4 files changed, 40 insertions(+), 63 deletions(-)

I'm cc'ing this to linux-arch since it includes the changes
for <asm/processor.h> and arch/tile/kernel/hardwall.c to use
<linux/list_types.h>, to illustrate the cleanup benefits of splitting
<linux/list.h>.

diff --git a/arch/tile/include/asm/compat.h b/arch/tile/include/asm/compat.h
index 6ee9d07..5a34da6 100644
--- a/arch/tile/include/asm/compat.h
+++ b/arch/tile/include/asm/compat.h
@@ -181,7 +181,7 @@ struct compat_shmid64_ds {
 
 static inline void __user *compat_ptr(compat_uptr_t uptr)
 {
-	return (void __user *)(unsigned long)uptr;
+	return (void __user *)(long)(s32)uptr;
 }
 
 static inline compat_uptr_t ptr_to_compat(void __user *uptr)
diff --git a/arch/tile/include/asm/hardwall.h b/arch/tile/include/asm/hardwall.h
index 631a24f..0bed3ec 100644
--- a/arch/tile/include/asm/hardwall.h
+++ b/arch/tile/include/asm/hardwall.h
@@ -26,8 +26,7 @@
  * The resulting ioctl value is passed to the kernel in conjunction
  * with a pointer to a little-endian bitmask of cpus, which must be
  * physically in a rectangular configuration on the chip.
- * The "size" is the number of bytes of cpu mask data and must be a
- * multiple of sizeof(long).
+ * The "size" is the number of bytes of cpu mask data.
  */
 #define _HARDWALL_CREATE 1
 #define HARDWALL_CREATE(size) \
diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
index 95b54bc..a67076b 100644
--- a/arch/tile/include/asm/processor.h
+++ b/arch/tile/include/asm/processor.h
@@ -21,6 +21,7 @@
  * NOTE: we don't include <linux/ptrace.h> or <linux/percpu.h> as one
  * normally would, due to #include dependencies.
  */
+#include <linux/list_types.h>
 #include <asm/ptrace.h>
 #include <asm/percpu.h>
 
@@ -29,7 +30,6 @@
 
 struct task_struct;
 struct thread_struct;
-struct list_head;
 
 typedef struct {
 	unsigned long seg;
@@ -76,11 +76,6 @@ struct async_tlb {
 
 #ifdef CONFIG_HARDWALL
 struct hardwall_info;
-
-/* Can't use a normal list_head here due to header-file inclusion issues. */
-struct hardwall_list {
-	struct list_head *next, *prev;
-};
 #endif
 
 struct thread_struct {
@@ -112,7 +107,7 @@ struct thread_struct {
 	/* Is this task tied to an activated hardwall? */
 	struct hardwall_info *hardwall;
 	/* Chains this task into the list at hardwall->list. */
-	struct hardwall_list hardwall_list;
+	struct list_head hardwall_list;
 #endif
 #if CHIP_HAS_TILE_DMA()
 	/* Async DMA TLB fault information */
diff --git a/arch/tile/kernel/hardwall.c b/arch/tile/kernel/hardwall.c
index 27f2856..d399540 100644
--- a/arch/tile/kernel/hardwall.c
+++ b/arch/tile/kernel/hardwall.c
@@ -22,6 +22,7 @@
 #include <linux/uaccess.h>
 #include <linux/smp.h>
 #include <linux/cdev.h>
+#include <linux/compat.h>
 #include <asm/hardwall.h>
 #include <asm/traps.h>
 #include <asm/siginfo.h>
@@ -46,27 +47,11 @@ struct hardwall_info {
 	int teardown_in_progress;          /* are we tearing this one down? */
 };
 
-/* Work around list_head vs hardwall_list. */
-#define hardwall_for_each_entry(pos, head, member)			\
-	for (pos = list_entry((struct hardwall_list *)((head)->next),	\
-			      typeof(*pos), member);			\
-	     (struct list_head *)&pos->member != (head);		\
-	     pos = list_entry((struct hardwall_list *)(pos->member.next),\
-			      typeof(*pos), member))
 #define for_each_hardwall_task(pos, head) \
-	hardwall_for_each_entry(pos, head, thread.hardwall_list)
-
-#define hardwall_for_each_entry_safe(pos, n, head, member)		\
-	for (pos = list_entry((struct hardwall_list *)((head)->next),	\
-			      typeof(*pos), member),			\
-	     n = list_entry((struct hardwall_list *)(pos->member.next), \
-			      typeof(*pos), member);			\
-	     (struct list_head *)&pos->member != (head);		\
-	     pos = n,							\
-	     n = list_entry((struct hardwall_list *)(pos->member.next), \
-			      typeof(*n), member))
+	list_for_each_entry(pos, head, thread.hardwall_list)
+
 #define for_each_hardwall_task_safe(pos, n, head) \
-	hardwall_for_each_entry_safe(pos, n, head, thread.hardwall_list)
+	list_for_each_entry_safe(pos, n, head, thread.hardwall_list)
 
 
 /* Currently allocated hardwall rectangles */
@@ -99,11 +84,6 @@ early_param("noudn", noudn);
  * Low-level primitives
  */
 
-/* Map a HARDWALL_FILE file to the matching hardwall info structure */
-#define _file_to_hardwall(file) ((file)->private_data)
-#define file_to_hardwall(file) \
-	((struct hardwall_info *)_file_to_hardwall(file))
-
 /* Set a CPU bit if the CPU is online. */
 #define cpu_online_set(cpu, dst) do { \
 	if (cpu_online(cpu))          \
@@ -355,30 +335,37 @@ void restrict_network_mpls(void)
 
 /* Create a hardwall for the given rectangle */
 static struct hardwall_info *hardwall_create(
-	size_t size, const unsigned long __user *bits)
+	size_t size, const unsigned char __user *bits)
 {
 	struct hardwall_info *iter, *rect;
 	struct cpumask mask;
 	unsigned long flags;
-	int rc, cpu, maxcpus = smp_height * smp_width;
+	int rc;
 
-	/* If "size" is not a multiple of long, it's invalid. */
-	if (size % sizeof(long))
+	/* Reject crazy sizes out of hand, a la sys_mbind(). */
+	if (size > PAGE_SIZE)
 		return ERR_PTR(-EINVAL);
 
-	/* Validate that all the bits we are given fit in our coordinates. */
-	cpumask_clear(&mask);
-	for (cpu = 0; size > 0; ++bits, size -= sizeof(long)) {
-		int i;
-		unsigned long m;
-		if (get_user(m, bits) != 0)
-			return ERR_PTR(-EFAULT);
-		for (i = 0; i < BITS_PER_LONG; ++i, ++cpu)
-			if (m & (1UL << i)) {
-				if (cpu >= maxcpus)
-					return ERR_PTR(-EINVAL);
-				cpumask_set_cpu(cpu, &mask);
-			}
+	/* Copy whatever fits into a cpumask. */
+	if (copy_from_user(&mask, bits, min(sizeof(struct cpumask), size)))
+		return ERR_PTR(-EFAULT);
+
+	/*
+	 * If the size was short, clear the rest of the mask;
+	 * otherwise validate that the rest of the user mask was zero
+	 * (we don't try hard to be efficient when validating huge masks).
+	 */
+	if (size < sizeof(struct cpumask)) {
+		memset((char *)&mask + size, 0, sizeof(struct cpumask) - size);
+	} else if (size > sizeof(struct cpumask)) {
+		size_t i;
+		for (i = sizeof(struct cpumask); i < size; ++i) {
+			char c;
+			if (get_user(c, &bits[i]))
+				return ERR_PTR(-EFAULT);
+			if (c)
+				return ERR_PTR(-EINVAL);
+		}
 	}
 
 	/* Allocate a new rectangle optimistically. */
@@ -451,7 +438,7 @@ static int hardwall_activate(struct hardwall_info *rect)
 	/* Success!  This process gets to use the user networks on this cpu. */
 	ts->hardwall = rect;
 	spin_lock_irqsave(&hardwall_lock, flags);
-	list_add((struct list_head *)&ts->hardwall_list, &rect->task_head);
+	list_add(&ts->hardwall_list, &rect->task_head);
 	spin_unlock_irqrestore(&hardwall_lock, flags);
 	grant_network_mpls();
 	printk(KERN_DEBUG "Pid %d (%s) activated for hardwall: cpu %d\n",
@@ -479,7 +466,7 @@ static void _hardwall_deactivate(struct task_struct *task)
 
 	BUG_ON(ts->hardwall == NULL);
 	ts->hardwall = NULL;
-	list_del((struct list_head *)&ts->hardwall_list);
+	list_del(&ts->hardwall_list);
 	if (task == current)
 		restrict_network_mpls();
 }
@@ -710,7 +697,7 @@ int proc_tile_hardwall_show(struct seq_file *sf, void *v)
 
 static long hardwall_ioctl(struct file *file, unsigned int a, unsigned long b)
 {
-	struct hardwall_info *rect = file_to_hardwall(file);
+	struct hardwall_info *rect = file->private_data;
 
 	if (_IOC_TYPE(a) != HARDWALL_IOCTL_BASE)
 		return -EINVAL;
@@ -722,10 +709,10 @@ static long hardwall_ioctl(struct file *file, unsigned int a, unsigned long b)
 		if (rect != NULL)
 			return -EALREADY;
 		rect = hardwall_create(_IOC_SIZE(a),
-					(const unsigned long __user *)b);
+					(const unsigned char __user *)b);
 		if (IS_ERR(rect))
 			return PTR_ERR(rect);
-		_file_to_hardwall(file) = rect;
+		file->private_data = rect;
 		return 0;
 
 	case _HARDWALL_ACTIVATE:
@@ -746,14 +733,14 @@ static long hardwall_compat_ioctl(struct file *file,
 				  unsigned int a, unsigned long b)
 {
 	/* Sign-extend the argument so it can be used as a pointer. */
-	return hardwall_ioctl(file, a, (int)(long)b);
+	return hardwall_ioctl(file, a, (unsigned long)compat_ptr(b));
 }
 #endif
 
 /* The user process closed the file; revoke access to user networks. */
 static int hardwall_flush(struct file *file, fl_owner_t owner)
 {
-	struct hardwall_info *rect = file_to_hardwall(file);
+	struct hardwall_info *rect = file->private_data;
 	struct task_struct *task, *tmp;
 	unsigned long flags;
 
@@ -780,7 +767,7 @@ static int hardwall_flush(struct file *file, fl_owner_t owner)
 /* This hardwall is gone, so destroy it. */
 static int hardwall_release(struct inode *inode, struct file *file)
 {
-	hardwall_destroy(file_to_hardwall(file));
+	hardwall_destroy(file->private_data);
 	return 0;
 }
 
@@ -808,10 +795,6 @@ static int __init dev_hardwall_init(void)
 	if (rc < 0)
 		return rc;
 
-	/* Verify that hardwall_list can stand in for list_head. */
-	BUILD_BUG_ON(sizeof(struct list_head) !=
-		     sizeof(current->thread.hardwall_list));
-
 	return 0;
 }
 late_initcall(dev_hardwall_init);
-- 
1.6.5.2

