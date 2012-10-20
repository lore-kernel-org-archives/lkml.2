Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab2JTOw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 10:52:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38656 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066Ab2JTOwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 10:52:24 -0400
Date: Sat, 20 Oct 2012 15:52:23 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Subject: [PATCH] alpha: separate thread-synchronous flags
Message-ID: <20121020145223.GS2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... and fix the race in updating unaligned control ones
    
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/alpha/include/asm/thread_info.h b/arch/alpha/include/asm/thread_info.h
index 4554ecb..1f8c729 100644
--- a/arch/alpha/include/asm/thread_info.h
+++ b/arch/alpha/include/asm/thread_info.h
@@ -7,6 +7,7 @@
 #include <asm/processor.h>
 #include <asm/types.h>
 #include <asm/hwrpb.h>
+#include <asm/sysinfo.h>
 #endif
 
 #ifndef __ASSEMBLY__
@@ -21,6 +22,7 @@ struct thread_info {
 	mm_segment_t		addr_limit;	/* thread address space */
 	unsigned		cpu;		/* current CPU */
 	int			preempt_count; /* 0 => preemptable, <0 => BUG */
+	unsigned int		status;		/* thread-synchronous flags */
 
 	int bpt_nsaved;
 	unsigned long bpt_addr[2];		/* breakpoint handling  */
@@ -63,8 +65,6 @@ register struct thread_info *__current_thread_info __asm__("$8");
  * - these are process state flags and used from assembly
  * - pending work-to-be-done flags come first and must be assigned to be
  *   within bits 0 to 7 to fit in and immediate operand.
- * - ALPHA_UAC_SHIFT below must be kept consistent with the unaligned
- *   control flags.
  *
  * TIF_SYSCALL_TRACE is known to be 0 via blbs.
  */
@@ -72,18 +72,12 @@ register struct thread_info *__current_thread_info __asm__("$8");
 #define TIF_NOTIFY_RESUME	1	/* callback before returning to user */
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
-#define TIF_POLLING_NRFLAG	8	/* poll_idle is polling NEED_RESCHED */
 #define TIF_DIE_IF_KERNEL	9	/* dik recursion lock */
-#define TIF_UAC_NOPRINT		10	/* ! Preserve sequence of following */
-#define TIF_UAC_NOFIX		11	/* ! flags as they match            */
-#define TIF_UAC_SIGBUS		12	/* ! userspace part of 'osf_sysinfo' */
 #define TIF_MEMDIE		13	/* is terminating due to OOM killer */
-#define TIF_RESTORE_SIGMASK	14	/* restore signal mask in do_signal */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
-#define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 
 /* Work to do on interrupt/exception return.  */
@@ -94,29 +88,63 @@ register struct thread_info *__current_thread_info __asm__("$8");
 #define _TIF_ALLWORK_MASK	(_TIF_WORK_MASK		\
 				 | _TIF_SYSCALL_TRACE)
 
-#define ALPHA_UAC_SHIFT		TIF_UAC_NOPRINT
-#define ALPHA_UAC_MASK		(1 << TIF_UAC_NOPRINT | 1 << TIF_UAC_NOFIX | \
-				 1 << TIF_UAC_SIGBUS)
+#define TS_UAC_NOPRINT		0x0001	/* ! Preserve the following three */
+#define TS_UAC_NOFIX		0x0002	/* ! flags as they match          */
+#define TS_UAC_SIGBUS		0x0004	/* ! userspace part of 'osf_sysinfo' */
+#define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal() */
+#define TS_POLLING		0x0010	/* idle task polling need_resched,
+					   skip sending interrupt */
 
-#define SET_UNALIGN_CTL(task,value)	({				     \
-	task_thread_info(task)->flags = ((task_thread_info(task)->flags &    \
-		~ALPHA_UAC_MASK)					     \
-		| (((value) << ALPHA_UAC_SHIFT)       & (1<<TIF_UAC_NOPRINT))\
-		| (((value) << (ALPHA_UAC_SHIFT + 1)) & (1<<TIF_UAC_SIGBUS)) \
-		| (((value) << (ALPHA_UAC_SHIFT - 1)) & (1<<TIF_UAC_NOFIX)));\
+#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
+
+#ifndef __ASSEMBLY__
+#define HAVE_SET_RESTORE_SIGMASK	1
+static inline void set_restore_sigmask(void)
+{
+	struct thread_info *ti = current_thread_info();
+	ti->status |= TS_RESTORE_SIGMASK;
+	WARN_ON(!test_bit(TIF_SIGPENDING, (unsigned long *)&ti->flags));
+}
+static inline void clear_restore_sigmask(void)
+{
+	current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
+}
+static inline bool test_restore_sigmask(void)
+{
+	return current_thread_info()->status & TS_RESTORE_SIGMASK;
+}
+static inline bool test_and_clear_restore_sigmask(void)
+{
+	struct thread_info *ti = current_thread_info();
+	if (!(ti->status & TS_RESTORE_SIGMASK))
+		return false;
+	ti->status &= ~TS_RESTORE_SIGMASK;
+	return true;
+}
+#endif
+
+#define SET_UNALIGN_CTL(task,value)	({				\
+	__u32 status = task_thread_info(task)->status & ~UAC_BITMASK;	\
+	if (value & PR_UNALIGN_NOPRINT)					\
+		status |= TS_UAC_NOPRINT;				\
+	if (value & PR_UNALIGN_SIGBUS)					\
+		status |= TS_UAC_SIGBUS;				\
+	if (value & 4)	/* alpha-specific */				\
+		status |= TS_UAC_NOFIX;					\
+	task_thread_info(task)->status = status;			\
 	0; })
 
 #define GET_UNALIGN_CTL(task,value)	({				\
-	put_user((task_thread_info(task)->flags & (1 << TIF_UAC_NOPRINT))\
-		  >> ALPHA_UAC_SHIFT					\
-		 | (task_thread_info(task)->flags & (1 << TIF_UAC_SIGBUS))\
-		 >> (ALPHA_UAC_SHIFT + 1)				\
-		 | (task_thread_info(task)->flags & (1 << TIF_UAC_NOFIX))\
-		 >> (ALPHA_UAC_SHIFT - 1),				\
-		 (int __user *)(value));				\
+	__u32 status = task_thread_info(task)->status & ~UAC_BITMASK;	\
+	__u32 res = 0;							\
+	if (status & TS_UAC_NOPRINT)					\
+		res |= PR_UNALIGN_NOPRINT;				\
+	if (status & TS_UAC_SIGBUS)					\
+		res |= PR_UNALIGN_SIGBUS;				\
+	if (status & TS_UAC_NOFIX)					\
+		res |= 4;						\
+	put_user(res, (int __user *)(value));				\
 	})
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
 #endif /* __KERNEL__ */
 #endif /* _ALPHA_THREAD_INFO_H */
diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 9eb0905..5530911 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -793,8 +793,7 @@ SYSCALL_DEFINE5(osf_getsysinfo, unsigned long, op, void __user *, buffer,
  	case GSI_UACPROC:
 		if (nbytes < sizeof(unsigned int))
 			return -EINVAL;
-		w = (current_thread_info()->flags >> ALPHA_UAC_SHIFT) &
-			UAC_BITMASK;
+		w = current_thread_info()->status & UAC_BITMASK;
 		if (put_user(w, (unsigned int __user *)buffer))
 			return -EFAULT;
  		return 1;
@@ -904,24 +903,20 @@ SYSCALL_DEFINE5(osf_setsysinfo, unsigned long, op, void __user *, buffer,
 		break;
 
  	case SSI_NVPAIRS: {
-		unsigned long v, w, i;
-		unsigned int old, new;
+		unsigned __user *p = buffer;
+		unsigned i;
 		
- 		for (i = 0; i < nbytes; ++i) {
+ 		for (i = 0, p = buffer; i < nbytes; ++i, p += 2) {
+			unsigned v, w, status;
 
- 			if (get_user(v, 2*i + (unsigned int __user *)buffer))
- 				return -EFAULT;
- 			if (get_user(w, 2*i + 1 + (unsigned int __user *)buffer))
+ 			if (get_user(v, p) || get_user(w, p + 1))
  				return -EFAULT;
  			switch (v) {
  			case SSIN_UACPROC:
-			again:
-				old = current_thread_info()->flags;
-				new = old & ~(UAC_BITMASK << ALPHA_UAC_SHIFT);
-				new = new | (w & UAC_BITMASK) << ALPHA_UAC_SHIFT;
-				if (cmpxchg(&current_thread_info()->flags,
-					    old, new) != old)
-					goto again;
+				w &= UAC_BITMASK;
+				status = current_thread_info()->status;
+				status = (status & ~UAC_BITMASK) | w;
+				current_thread_info()->status = status;
  				break;
  
  			default:
diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index 3d28a53..ad86c09 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -49,7 +49,7 @@ EXPORT_SYMBOL(pm_power_off);
 void
 cpu_idle(void)
 {
-	set_thread_flag(TIF_POLLING_NRFLAG);
+	current_thread_info()->status |= TS_POLLING;
 
 	while (1) {
 		/* FIXME -- EV6 and LCA45 know how to power down
diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index 80d987c..272666d 100644
--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -780,17 +780,17 @@ do_entUnaUser(void __user * va, unsigned long opcode,
 	/* Check the UAC bits to decide what the user wants us to do
 	   with the unaliged access.  */
 
-	if (!test_thread_flag (TIF_UAC_NOPRINT)) {
+	if (!(current_thread_info()->status & TS_UAC_NOPRINT)) {
 		if (__ratelimit(&ratelimit)) {
 			printk("%s(%d): unaligned trap at %016lx: %p %lx %ld\n",
 			       current->comm, task_pid_nr(current),
 			       regs->pc - 4, va, opcode, reg);
 		}
 	}
-	if (test_thread_flag (TIF_UAC_SIGBUS))
+	if ((current_thread_info()->status & TS_UAC_SIGBUS))
 		goto give_sigbus;
 	/* Not sure why you'd want to use this, but... */
-	if (test_thread_flag (TIF_UAC_NOFIX))
+	if ((current_thread_info()->status & TS_UAC_NOFIX))
 		return;
 
 	/* Don't bother reading ds in the access check since we already
