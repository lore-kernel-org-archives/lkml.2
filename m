Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab1HRTON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:14:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48468 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759Ab1HRTOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:14:11 -0400
Date: Thu, 18 Aug 2011 20:14:10 +0100
To: richard@nod.at
Subject: Subject: [PATCH 91/91] um: distribute exports to where exported
 stuff is defined
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu82c-0008Bj-3g@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ksyms.c is down to the stuff defined in various USER_OBJS

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/kernel/exec.c         |   18 ++++++++++--------
 arch/um/kernel/irq.c          |    1 +
 arch/um/kernel/ksyms.c        |   38 +-------------------------------------
 arch/um/kernel/mem.c          |    2 ++
 arch/um/kernel/physmem.c      |   21 ++++++++++++---------
 arch/um/kernel/process.c      |    2 ++
 arch/um/kernel/skas/uaccess.c |    6 ++++++
 arch/um/kernel/tlb.c          |    2 ++
 arch/um/kernel/trap.c         |    2 ++
 arch/um/kernel/um_arch.c      |    2 ++
 10 files changed, 40 insertions(+), 54 deletions(-)

diff --git a/arch/um/kernel/exec.c b/arch/um/kernel/exec.c
index 939a4a6..6cade93 100644
--- a/arch/um/kernel/exec.c
+++ b/arch/um/kernel/exec.c
@@ -3,14 +3,15 @@
  * Licensed under the GPL
  */
 
-#include "linux/stddef.h"
-#include "linux/fs.h"
-#include "linux/ptrace.h"
-#include "linux/sched.h"
-#include "linux/slab.h"
-#include "asm/current.h"
-#include "asm/processor.h"
-#include "asm/uaccess.h"
+#include <linux/stddef.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/ptrace.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <asm/current.h>
+#include <asm/processor.h>
+#include <asm/uaccess.h>
 #include "as-layout.h"
 #include "mem_user.h"
 #include "skas.h"
@@ -41,6 +42,7 @@ void start_thread(struct pt_regs *regs, unsigned long eip, unsigned long esp)
 	PT_REGS_IP(regs) = eip;
 	PT_REGS_SP(regs) = esp;
 }
+EXPORT_SYMBOL(start_thread);
 
 static long execve1(const char *file,
 		    const char __user *const __user *argv,
diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index 9e485c7..71b8c94 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -258,6 +258,7 @@ void deactivate_fd(int fd, int irqnum)
 
 	ignore_sigio_fd(fd);
 }
+EXPORT_SYMBOL(deactivate_fd);
 
 /*
  * Called just before shutdown in order to provide a clean exec
diff --git a/arch/um/kernel/ksyms.c b/arch/um/kernel/ksyms.c
index 0ae0dfc..e17bea0 100644
--- a/arch/um/kernel/ksyms.c
+++ b/arch/um/kernel/ksyms.c
@@ -3,33 +3,11 @@
  * Licensed under the GPL
  */
 
-#include "linux/module.h"
-#include "linux/syscalls.h"
-#include "asm/tlbflush.h"
-#include "asm/uaccess.h"
-#include "as-layout.h"
-#include "kern_util.h"
-#include "mem_user.h"
+#include <linux/module.h>
 #include "os.h"
 
-EXPORT_SYMBOL(uml_physmem);
 EXPORT_SYMBOL(set_signals);
 EXPORT_SYMBOL(get_signals);
-EXPORT_SYMBOL(kernel_thread);
-EXPORT_SYMBOL(sys_waitpid);
-EXPORT_SYMBOL(flush_tlb_range);
-
-EXPORT_SYMBOL(high_physmem);
-EXPORT_SYMBOL(empty_zero_page);
-EXPORT_SYMBOL(handle_page_fault);
-EXPORT_SYMBOL(find_iomem);
-
-EXPORT_SYMBOL(strnlen_user);
-EXPORT_SYMBOL(strncpy_from_user);
-EXPORT_SYMBOL(copy_to_user);
-EXPORT_SYMBOL(copy_from_user);
-EXPORT_SYMBOL(clear_user);
-EXPORT_SYMBOL(uml_strdup);
 
 EXPORT_SYMBOL(os_stat_fd);
 EXPORT_SYMBOL(os_stat_file);
@@ -57,24 +35,10 @@ EXPORT_SYMBOL(os_connect_socket);
 EXPORT_SYMBOL(os_accept_connection);
 EXPORT_SYMBOL(os_rcv_fd);
 EXPORT_SYMBOL(run_helper);
-EXPORT_SYMBOL(start_thread);
 EXPORT_SYMBOL(os_major);
 EXPORT_SYMBOL(os_minor);
 EXPORT_SYMBOL(os_makedev);
 
 EXPORT_SYMBOL(add_sigio_fd);
 EXPORT_SYMBOL(ignore_sigio_fd);
-EXPORT_SYMBOL(deactivate_fd);
 EXPORT_SYMBOL(sigio_broken);
-
-#ifdef CONFIG_SMP
-
-/* required for SMP */
-
-extern void __write_lock_failed(rwlock_t *rw);
-EXPORT_SYMBOL(__write_lock_failed);
-
-extern void __read_lock_failed(rwlock_t *rw);
-EXPORT_SYMBOL(__read_lock_failed);
-
-#endif
diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 8137ccc..ebb86b2 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/stddef.h>
+#include <linux/module.h>
 #include <linux/bootmem.h>
 #include <linux/highmem.h>
 #include <linux/mm.h>
@@ -20,6 +21,7 @@
 
 /* allocated in paging_init, zeroed in mem_init, and unchanged thereafter */
 unsigned long *empty_zero_page = NULL;
+EXPORT_SYMBOL(empty_zero_page);
 /* allocated in paging_init and unchanged thereafter */
 static unsigned long *empty_bad_page = NULL;
 
diff --git a/arch/um/kernel/physmem.c b/arch/um/kernel/physmem.c
index a1a9090..f116db1 100644
--- a/arch/um/kernel/physmem.c
+++ b/arch/um/kernel/physmem.c
@@ -3,20 +3,22 @@
  * Licensed under the GPL
  */
 
-#include "linux/bootmem.h"
-#include "linux/mm.h"
-#include "linux/pfn.h"
-#include "asm/page.h"
-#include "as-layout.h"
-#include "init.h"
-#include "kern.h"
-#include "mem_user.h"
-#include "os.h"
+#include <linux/module.h>
+#include <linux/bootmem.h>
+#include <linux/mm.h>
+#include <linux/pfn.h>
+#include <asm/page.h>
+#include <as-layout.h>
+#include <init.h>
+#include <kern.h>
+#include <mem_user.h>
+#include <os.h>
 
 static int physmem_fd = -1;
 
 /* Changed during early boot */
 unsigned long high_physmem;
+EXPORT_SYMBOL(high_physmem);
 
 extern unsigned long long physmem_size;
 
@@ -184,6 +186,7 @@ unsigned long find_iomem(char *driver, unsigned long *len_out)
 
 	return 0;
 }
+EXPORT_SYMBOL(find_iomem);
 
 static int setup_iomem(void)
 {
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 6f042e7..4ffd426 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -78,6 +78,7 @@ int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
 		      &current->thread.regs, 0, NULL, NULL);
 	return pid;
 }
+EXPORT_SYMBOL(kernel_thread);
 
 static inline void set_current(struct task_struct *task)
 {
@@ -286,6 +287,7 @@ char *uml_strdup(const char *string)
 {
 	return kstrdup(string, GFP_KERNEL);
 }
+EXPORT_SYMBOL(uml_strdup);
 
 int copy_to_user_proc(void __user *to, void *from, int size)
 {
diff --git a/arch/um/kernel/skas/uaccess.c b/arch/um/kernel/skas/uaccess.c
index 6966342..9fefd92 100644
--- a/arch/um/kernel/skas/uaccess.c
+++ b/arch/um/kernel/skas/uaccess.c
@@ -6,6 +6,7 @@
 #include <linux/err.h>
 #include <linux/highmem.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/sched.h>
 #include <asm/current.h>
 #include <asm/page.h>
@@ -149,6 +150,7 @@ int copy_from_user(void *to, const void __user *from, int n)
 	       buffer_op((unsigned long) from, n, 0, copy_chunk_from_user, &to):
 	       n;
 }
+EXPORT_SYMBOL(copy_from_user);
 
 static int copy_chunk_to_user(unsigned long to, int len, void *arg)
 {
@@ -170,6 +172,7 @@ int copy_to_user(void __user *to, const void *from, int n)
 	       buffer_op((unsigned long) to, n, 1, copy_chunk_to_user, &from) :
 	       n;
 }
+EXPORT_SYMBOL(copy_to_user);
 
 static int strncpy_chunk_from_user(unsigned long from, int len, void *arg)
 {
@@ -204,6 +207,7 @@ int strncpy_from_user(char *dst, const char __user *src, int count)
 		return -EFAULT;
 	return strnlen(dst, count);
 }
+EXPORT_SYMBOL(strncpy_from_user);
 
 static int clear_chunk(unsigned long addr, int len, void *unused)
 {
@@ -226,6 +230,7 @@ int clear_user(void __user *mem, int len)
 	return access_ok(VERIFY_WRITE, mem, len) ?
 	       buffer_op((unsigned long) mem, len, 1, clear_chunk, NULL) : len;
 }
+EXPORT_SYMBOL(clear_user);
 
 static int strnlen_chunk(unsigned long str, int len, void *arg)
 {
@@ -251,3 +256,4 @@ int strnlen_user(const void __user *str, int len)
 		return count + 1;
 	return -EFAULT;
 }
+EXPORT_SYMBOL(strnlen_user);
diff --git a/arch/um/kernel/tlb.c b/arch/um/kernel/tlb.c
index 11cadb2..7f3d4d8 100644
--- a/arch/um/kernel/tlb.c
+++ b/arch/um/kernel/tlb.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/sched.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
@@ -498,6 +499,7 @@ void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
 		flush_tlb_kernel_range_common(start, end);
 	else fix_range(vma->vm_mm, start, end, 0);
 }
+EXPORT_SYMBOL(flush_tlb_range);
 
 void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 			unsigned long end)
diff --git a/arch/um/kernel/trap.c b/arch/um/kernel/trap.c
index f2a2036..dafc947 100644
--- a/arch/um/kernel/trap.c
+++ b/arch/um/kernel/trap.c
@@ -6,6 +6,7 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/hardirq.h>
+#include <linux/module.h>
 #include <asm/current.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
@@ -111,6 +112,7 @@ out_of_memory:
 	pagefault_out_of_memory();
 	return 0;
 }
+EXPORT_SYMBOL(handle_page_fault);
 
 static void show_segv_info(struct uml_pt_regs *regs)
 {
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index 8d84250..ba00eae 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -102,6 +102,8 @@ const struct seq_operations cpuinfo_op = {
 
 /* Set in linux_main */
 unsigned long uml_physmem;
+EXPORT_SYMBOL(uml_physmem);
+
 unsigned long uml_reserved; /* Also modified in mem_init */
 unsigned long start_vm;
 unsigned long end_vm;
-- 
1.7.2.5

