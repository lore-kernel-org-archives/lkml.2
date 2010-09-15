Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab0IOBTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 21:19:04 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:55023 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab0IOBTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 21:19:01 -0400
Date: Wed, 15 Sep 2010 10:48:55 +0930
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] Cross Memory Attach
Message-ID: <20100915104855.41de3ebf@lilo>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The basic idea behind cross memory attach is to allow MPI programs doing
intra-node communication to do a single copy of the message rather than
a double copy of the message via shared memory.

The following patch attempts to achieve this by allowing a
destination process, given an address and size from a source process, to
copy memory directly from the source process into its own address space
via a system call. There is also a symmetrical ability to copy from 
the current process's address space into a destination process's
address space.

Use of vmsplice instead was considered, but has problems. Since you
need the reader and writer working co-operatively if the pipe is not
drained then you block. Which requires some wrapping to do non blocking
on the send side or polling on the receive. In all to all communication
it requires ordering otherwise you can deadlock. And in the example of
many MPI tasks writing to one MPI task vmsplice serialises the
copying.

I've added the use of this capability to OpenMPI and run some MPI
benchmarks on a 64-way (with SMT off) Power6 machine which see
improvements in the following areas:

HPCC results:
=============

MB/s			Num Processes	
Naturally Ordered	4	8	16	32
Base			1235	935	622	419
CMA			4741	3769	1977	703

			
MB/s			Num Processes	
Randomly Ordered	4	8	16	32
Base			1227	947	638	412
CMA			4666	3682	1978	710
				
MB/s			Num Processes	
Max Ping Pong		4	8	16	32
Base			2028	1938	1928	1882
CMA			7424	7510	7598	7708


NPB:
====
BT - 12% improvement
FT - 15% improvement
IS - 30% improvement
SP - 34% improvement

IMB:
===
		
Ping Pong - ~30% improvement
Ping Ping - ~120% improvement
SendRecv - ~100% improvement
Exchange - ~150% improvement
Gather(v) - ~20% improvement
Scatter(v) - ~20% improvement
AlltoAll(v) - 30-50% improvement

Patch is as below. Any comments?

Regards,

Chris
-- 
cyeoh@au.ibm.com


Signed-off-by: Chris Yeoh <cyeoh@au1.ibm.com>
--- 
 arch/powerpc/include/asm/systbl.h  |    2 
 arch/powerpc/include/asm/unistd.h  |    5 -
 arch/x86/include/asm/unistd_32.h   |    4 
 arch/x86/kernel/syscall_table_32.S |    2 
 include/linux/syscalls.h           |    6 +
 mm/memory.c                        |  184 +++++++++++++++++++++++++++++++++++++
 6 files changed, 200 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index a5ee345..d82a6be 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -326,3 +326,5 @@ SYSCALL_SPU(perf_event_open)
 COMPAT_SYS_SPU(preadv)
 COMPAT_SYS_SPU(pwritev)
 COMPAT_SYS(rt_tgsigqueueinfo)
+SYSCALL(copy_from_process)
+SYSCALL(copy_to_process)
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index f0a1026..40d46fc 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -345,10 +345,11 @@
 #define __NR_preadv		320
 #define __NR_pwritev		321
 #define __NR_rt_tgsigqueueinfo	322
-
+#define __NR_copy_from_process  323
+#define __NR_copy_to_process    324
 #ifdef __KERNEL__
 
-#define __NR_syscalls		323
+#define __NR_syscalls		325
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index beb9b5f..9c90a65 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -343,10 +343,12 @@
 #define __NR_rt_tgsigqueueinfo	335
 #define __NR_perf_event_open	336
 #define __NR_recvmmsg		337
+#define __NR_copy_from_process	338
+#define __NR_copy_to_process	339
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 338
+#define NR_syscalls 340
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index 8b37293..984b766 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -337,3 +337,5 @@ ENTRY(sys_call_table)
 	.long sys_rt_tgsigqueueinfo	/* 335 */
 	.long sys_perf_event_open
 	.long sys_recvmmsg
+	.long sys_copy_from_process
+	.long sys_copy_to_process
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 13ebb54..64b64c3 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -825,5 +825,11 @@ asmlinkage long sys_mmap_pgoff(unsigned long addr, unsigned long len,
 			unsigned long prot, unsigned long flags,
 			unsigned long fd, unsigned long pgoff);
 asmlinkage long sys_old_mmap(struct mmap_arg_struct __user *arg);
+asmlinkage long sys_copy_from_process(pid_t pid, unsigned long addr,
+				      unsigned long len,
+				      char __user *buf, int flags);
+asmlinkage long sys_copy_to_process(pid_t pid, unsigned long addr,
+				    unsigned long len,
+				    char __user *buf, int flags);
 
 #endif
diff --git a/mm/memory.c b/mm/memory.c
index 119b7cc..64a6d7b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -57,6 +57,7 @@
 #include <linux/swapops.h>
 #include <linux/elf.h>
 #include <linux/gfp.h>
+#include <linux/syscalls.h>
 
 #include <asm/io.h>
 #include <asm/pgalloc.h>
@@ -3487,6 +3488,189 @@ void print_vma_addr(char *prefix, unsigned long ip)
 	up_read(&current->mm->mmap_sem);
 }
 
+int copy_to_from_process_allowed(struct task_struct *task)
+{
+	/* Allow copy_to_from_process to access another process using
+	   the same critera  as a process would be allowed to ptrace
+	   that same process */
+	const struct cred *cred = current_cred(), *tcred;
+
+	rcu_read_lock();
+	tcred = __task_cred(task);
+	if ((cred->uid != tcred->euid ||
+	     cred->uid != tcred->suid ||
+	     cred->uid != tcred->uid  ||
+	     cred->gid != tcred->egid ||
+	     cred->gid != tcred->sgid ||
+	     cred->gid != tcred->gid) &&
+	    !capable(CAP_SYS_PTRACE)) {
+		rcu_read_unlock();
+		return 0;
+	}
+	rcu_read_unlock();
+	return 1;
+}
+
+
+
+static int copy_to_from_process_pages(struct task_struct *task,
+				      struct page **process_pages,
+				      unsigned long pa,
+				      unsigned long *bytes_copied,
+				      unsigned long start_offset,
+				      unsigned long len,
+				      char *user_buf,
+				      int copy_to,
+				      int nr_pages_remain)
+{
+	int pages_pinned;
+	void *target_kaddr;
+	int i;
+	int ret;
+	unsigned long bytes_to_copy;
+	int max_pages_per_loop = (PAGE_SIZE * 2) / sizeof(struct pages *);
+	int nr_pages_to_copy = min(nr_pages_remain, max_pages_per_loop);
+	int rc = -EFAULT;
+	
+	/* Get the pages we're interested in */
+	pages_pinned = get_user_pages(task, task->mm, pa,
+				      nr_pages_to_copy,
+				      copy_to, 0, process_pages, NULL);
+
+	if (pages_pinned != nr_pages_to_copy)
+		goto end;
+
+	/* Do the copy for each page */
+	for (i = 0; i < nr_pages_to_copy; i++) {
+		target_kaddr = kmap(process_pages[i]) + start_offset;
+		bytes_to_copy = min(PAGE_SIZE - start_offset,
+				    len - *bytes_copied);
+		if (start_offset)
+			start_offset = 0;
+
+		if (copy_to) {
+			ret = copy_from_user(target_kaddr,
+					     user_buf + *bytes_copied,
+					     bytes_to_copy);
+			if (ret) {
+				kunmap(process_pages[i]);
+				goto end;
+			}
+		} else {
+			ret = copy_to_user(user_buf + *bytes_copied,
+					   target_kaddr, bytes_to_copy);
+			if (ret) {
+				kunmap(process_pages[i]);
+				goto end;
+			}
+		}
+		kunmap(process_pages[i]);
+		*bytes_copied += bytes_to_copy;
+	}
+
+	rc = nr_pages_to_copy;
+
+end:
+	for (i = 0; i < pages_pinned; i++) {
+		if (copy_to)
+			set_page_dirty_lock(process_pages[i]);
+		put_page(process_pages[i]);
+	}
+
+	return rc;
+}
+
+static int copy_to_from_process(pid_t pid, unsigned long addr,
+				unsigned long len,
+				char *user_buf, int flags, int copy_to)
+{
+	unsigned long pa = addr & PAGE_MASK;
+	unsigned long start_offset = addr - pa;
+	int nr_pages;
+	struct task_struct *task;
+	struct page **process_pages;
+	unsigned long bytes_copied = 0;
+	int rc;
+	int nr_pages_copied = 0;
+
+	/* Work out address and page range required */
+	if (len == 0)
+		return 0;
+	nr_pages = (addr + len - 1) / PAGE_SIZE - addr / PAGE_SIZE + 1;
+
+	/* Get process information */
+	rcu_read_lock();
+	task = find_task_by_vpid(pid); /* pid namespace?!? */
+	if (task)
+		get_task_struct(task);
+	rcu_read_unlock();
+	if (!task)
+		return -ESRCH;
+
+	task_lock(task);
+	if (!copy_to_from_process_allowed(task)) {
+		task_unlock(task);
+		rc = -EPERM;
+		goto end;
+	}
+	task_unlock(task);
+
+
+	/* For reliability don't try to kmalloc more than 2 pages worth */
+	process_pages = kmalloc(min(PAGE_SIZE * 2,
+				    sizeof(struct pages *) * nr_pages),
+				GFP_KERNEL);
+
+	if (!process_pages) {
+		rc = -ENOMEM;
+		goto end;
+	}
+
+	down_read(&task->mm->mmap_sem);
+	while (nr_pages_copied < nr_pages) {
+		rc = copy_to_from_process_pages(task, process_pages,
+						pa,
+						&bytes_copied,
+						start_offset,
+						len,
+						user_buf,
+						copy_to,
+						nr_pages - nr_pages_copied);
+		start_offset = 0;
+
+		if (rc == -EFAULT)
+			goto free_mem;
+		else {
+			nr_pages_copied += rc;
+			pa += rc * PAGE_SIZE;
+		}
+	}
+
+	rc = bytes_copied;
+
+free_mem:
+	up_read(&task->mm->mmap_sem);
+	kfree(process_pages);
+
+end:
+	put_task_struct(task);
+	return rc;
+}
+
+SYSCALL_DEFINE5(copy_from_process, pid_t, pid, unsigned long, addr,
+		unsigned long, len, char __user *, buf, int, flags)
+{
+	return copy_to_from_process(pid, addr, len, buf, flags, 0);
+}
+
+
+SYSCALL_DEFINE5(copy_to_process, pid_t, pid, unsigned long, addr,
+		unsigned long, len, char __user *, buf, int, flags)
+{
+	return copy_to_from_process(pid, addr, len, buf, flags, 1);
+}
+
+
 #ifdef CONFIG_PROVE_LOCKING
 void might_fault(void)
 {


-- 
cyeoh@au.ibm.com
