Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab2KPODa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:03:30 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:59499 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab2KPOD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:03:28 -0500
Date: Fri, 16 Nov 2012 15:03:20 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.7-rc6
Message-ID: <20121116150320.0d2727cd@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12111614-5024-0000-0000-000004633EFA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
Some more bug fixes and a config change. The signal bug is nasty, if
the clock_gettime vdso function is interrupted by a signal while in
access-register-mode we end up with an endless signal loop until the
signal stack is full. The config change is for aligned struct pages,
gives us 8% improvement with hackbench.

Heiko Carstens (5):
      s390/topology: fix core id vs physical package id mix-up
      s390/gup: add missing TASK_SIZE check to get_user_pages_fast()
      s390/gup: fix access_ok() usage in __get_user_pages_fast()
      s390/mm: have 16 byte aligned struct pages
      s390/3215: fix tty close handling

Martin Schwidefsky (1):
      s390/signal: set correct address space control

 arch/s390/Kconfig                   |    1 +
 arch/s390/include/asm/compat.h      |    2 +-
 arch/s390/include/asm/topology.h    |    3 +++
 arch/s390/include/uapi/asm/ptrace.h |    4 ++--
 arch/s390/kernel/compat_signal.c    |   14 ++++++++++++--
 arch/s390/kernel/signal.c           |   14 ++++++++++++--
 arch/s390/kernel/topology.c         |    6 ++++--
 arch/s390/mm/gup.c                  |    5 ++---
 drivers/s390/char/con3215.c         |   12 +++++-------
 9 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 5dba755..d385f39 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -96,6 +96,7 @@ config S390
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_CMPXCHG_LOCAL
 	select HAVE_CMPXCHG_DOUBLE
+	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
 	select HAVE_VIRT_CPU_ACCOUNTING
 	select VIRT_CPU_ACCOUNTING
 	select ARCH_DISCARD_MEMBLOCK
diff --git a/arch/s390/include/asm/compat.h b/arch/s390/include/asm/compat.h
index a34a9d6..18cd6b5 100644
--- a/arch/s390/include/asm/compat.h
+++ b/arch/s390/include/asm/compat.h
@@ -20,7 +20,7 @@
 #define PSW32_MASK_CC		0x00003000UL
 #define PSW32_MASK_PM		0x00000f00UL
 
-#define PSW32_MASK_USER		0x00003F00UL
+#define PSW32_MASK_USER		0x0000FF00UL
 
 #define PSW32_ADDR_AMODE	0x80000000UL
 #define PSW32_ADDR_INSN		0x7FFFFFFFUL
diff --git a/arch/s390/include/asm/topology.h b/arch/s390/include/asm/topology.h
index 9ca3053..9935cbd 100644
--- a/arch/s390/include/asm/topology.h
+++ b/arch/s390/include/asm/topology.h
@@ -8,6 +8,9 @@ struct cpu;
 
 #ifdef CONFIG_SCHED_BOOK
 
+extern unsigned char cpu_socket_id[NR_CPUS];
+#define topology_physical_package_id(cpu) (cpu_socket_id[cpu])
+
 extern unsigned char cpu_core_id[NR_CPUS];
 extern cpumask_t cpu_core_map[NR_CPUS];
 
diff --git a/arch/s390/include/uapi/asm/ptrace.h b/arch/s390/include/uapi/asm/ptrace.h
index 705588a..a5ca214 100644
--- a/arch/s390/include/uapi/asm/ptrace.h
+++ b/arch/s390/include/uapi/asm/ptrace.h
@@ -239,7 +239,7 @@ typedef struct
 #define PSW_MASK_EA		0x00000000UL
 #define PSW_MASK_BA		0x00000000UL
 
-#define PSW_MASK_USER		0x00003F00UL
+#define PSW_MASK_USER		0x0000FF00UL
 
 #define PSW_ADDR_AMODE		0x80000000UL
 #define PSW_ADDR_INSN		0x7FFFFFFFUL
@@ -269,7 +269,7 @@ typedef struct
 #define PSW_MASK_EA		0x0000000100000000UL
 #define PSW_MASK_BA		0x0000000080000000UL
 
-#define PSW_MASK_USER		0x00003F8180000000UL
+#define PSW_MASK_USER		0x0000FF8180000000UL
 
 #define PSW_ADDR_AMODE		0x0000000000000000UL
 #define PSW_ADDR_INSN		0xFFFFFFFFFFFFFFFFUL
diff --git a/arch/s390/kernel/compat_signal.c b/arch/s390/kernel/compat_signal.c
index a1e8a86..593fcc9 100644
--- a/arch/s390/kernel/compat_signal.c
+++ b/arch/s390/kernel/compat_signal.c
@@ -309,6 +309,10 @@ static int restore_sigregs32(struct pt_regs *regs,_sigregs32 __user *sregs)
 	regs->psw.mask = (regs->psw.mask & ~PSW_MASK_USER) |
 		(__u64)(regs32.psw.mask & PSW32_MASK_USER) << 32 |
 		(__u64)(regs32.psw.addr & PSW32_ADDR_AMODE);
+	/* Check for invalid user address space control. */
+	if ((regs->psw.mask & PSW_MASK_ASC) >= (psw_kernel_bits & PSW_MASK_ASC))
+		regs->psw.mask = (psw_user_bits & PSW_MASK_ASC) |
+			(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr = (__u64)(regs32.psw.addr & PSW32_ADDR_INSN);
 	for (i = 0; i < NUM_GPRS; i++)
 		regs->gprs[i] = (__u64) regs32.gprs[i];
@@ -481,7 +485,10 @@ static int setup_frame32(int sig, struct k_sigaction *ka,
 
 	/* Set up registers for signal handler */
 	regs->gprs[15] = (__force __u64) frame;
-	regs->psw.mask |= PSW_MASK_BA;		/* force amode 31 */
+	/* Force 31 bit amode and default user address space control. */
+	regs->psw.mask = PSW_MASK_BA |
+		(psw_user_bits & PSW_MASK_ASC) |
+		(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr = (__force __u64) ka->sa.sa_handler;
 
 	regs->gprs[2] = map_signal(sig);
@@ -549,7 +556,10 @@ static int setup_rt_frame32(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	/* Set up registers for signal handler */
 	regs->gprs[15] = (__force __u64) frame;
-	regs->psw.mask |= PSW_MASK_BA;		/* force amode 31 */
+	/* Force 31 bit amode and default user address space control. */
+	regs->psw.mask = PSW_MASK_BA |
+		(psw_user_bits & PSW_MASK_ASC) |
+		(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr = (__u64) ka->sa.sa_handler;
 
 	regs->gprs[2] = map_signal(sig);
diff --git a/arch/s390/kernel/signal.c b/arch/s390/kernel/signal.c
index c13a2a3..d1259d8 100644
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -136,6 +136,10 @@ static int restore_sigregs(struct pt_regs *regs, _sigregs __user *sregs)
 	/* Use regs->psw.mask instead of psw_user_bits to preserve PER bit. */
 	regs->psw.mask = (regs->psw.mask & ~PSW_MASK_USER) |
 		(user_sregs.regs.psw.mask & PSW_MASK_USER);
+	/* Check for invalid user address space control. */
+	if ((regs->psw.mask & PSW_MASK_ASC) >= (psw_kernel_bits & PSW_MASK_ASC))
+		regs->psw.mask = (psw_user_bits & PSW_MASK_ASC) |
+			(regs->psw.mask & ~PSW_MASK_ASC);
 	/* Check for invalid amode */
 	if (regs->psw.mask & PSW_MASK_EA)
 		regs->psw.mask |= PSW_MASK_BA;
@@ -273,7 +277,10 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 
 	/* Set up registers for signal handler */
 	regs->gprs[15] = (unsigned long) frame;
-	regs->psw.mask |= PSW_MASK_EA | PSW_MASK_BA;	/* 64 bit amode */
+	/* Force default amode and default user address space control. */
+	regs->psw.mask = PSW_MASK_EA | PSW_MASK_BA |
+		(psw_user_bits & PSW_MASK_ASC) |
+		(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr = (unsigned long) ka->sa.sa_handler | PSW_ADDR_AMODE;
 
 	regs->gprs[2] = map_signal(sig);
@@ -346,7 +353,10 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	/* Set up registers for signal handler */
 	regs->gprs[15] = (unsigned long) frame;
-	regs->psw.mask |= PSW_MASK_EA | PSW_MASK_BA;	/* 64 bit amode */
+	/* Force default amode and default user address space control. */
+	regs->psw.mask = PSW_MASK_EA | PSW_MASK_BA |
+		(psw_user_bits & PSW_MASK_ASC) |
+		(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr = (unsigned long) ka->sa.sa_handler | PSW_ADDR_AMODE;
 
 	regs->gprs[2] = map_signal(sig);
diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index 54d93f4..dd55f7c 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -40,6 +40,7 @@ static DEFINE_SPINLOCK(topology_lock);
 static struct mask_info core_info;
 cpumask_t cpu_core_map[NR_CPUS];
 unsigned char cpu_core_id[NR_CPUS];
+unsigned char cpu_socket_id[NR_CPUS];
 
 static struct mask_info book_info;
 cpumask_t cpu_book_map[NR_CPUS];
@@ -83,11 +84,12 @@ static struct mask_info *add_cpus_to_mask(struct topology_cpu *tl_cpu,
 			cpumask_set_cpu(lcpu, &book->mask);
 			cpu_book_id[lcpu] = book->id;
 			cpumask_set_cpu(lcpu, &core->mask);
+			cpu_core_id[lcpu] = rcpu;
 			if (one_core_per_cpu) {
-				cpu_core_id[lcpu] = rcpu;
+				cpu_socket_id[lcpu] = rcpu;
 				core = core->next;
 			} else {
-				cpu_core_id[lcpu] = core->id;
+				cpu_socket_id[lcpu] = core->id;
 			}
 			smp_cpu_set_polarization(lcpu, tl_cpu->pp);
 		}
diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
index 8b82853..1f5315d1 100644
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -180,8 +180,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	addr = start;
 	len = (unsigned long) nr_pages << PAGE_SHIFT;
 	end = start + len;
-	if (unlikely(!access_ok(write ? VERIFY_WRITE : VERIFY_READ,
-					(void __user *)start, len)))
+	if ((end < start) || (end > TASK_SIZE))
 		return 0;
 
 	local_irq_save(flags);
@@ -229,7 +228,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	addr = start;
 	len = (unsigned long) nr_pages << PAGE_SHIFT;
 	end = start + len;
-	if (end < start)
+	if ((end < start) || (end > TASK_SIZE))
 		goto slow_irqon;
 
 	/*
diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 9ffb6d5..4ed343e 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -44,7 +44,6 @@
 #define RAW3215_NR_CCWS	    3
 #define RAW3215_TIMEOUT	    HZ/10     /* time for delayed output */
 
-#define RAW3215_FIXED	    1	      /* 3215 console device is not be freed */
 #define RAW3215_WORKING	    4	      /* set if a request is being worked on */
 #define RAW3215_THROTTLED   8	      /* set if reading is disabled */
 #define RAW3215_STOPPED	    16	      /* set if writing is disabled */
@@ -339,8 +338,10 @@ static void raw3215_wakeup(unsigned long data)
 	struct tty_struct *tty;
 
 	tty = tty_port_tty_get(&raw->port);
-	tty_wakeup(tty);
-	tty_kref_put(tty);
+	if (tty) {
+		tty_wakeup(tty);
+		tty_kref_put(tty);
+	}
 }
 
 /*
@@ -629,8 +630,7 @@ static void raw3215_shutdown(struct raw3215_info *raw)
 	DECLARE_WAITQUEUE(wait, current);
 	unsigned long flags;
 
-	if (!(raw->port.flags & ASYNC_INITIALIZED) ||
-			(raw->flags & RAW3215_FIXED))
+	if (!(raw->port.flags & ASYNC_INITIALIZED))
 		return;
 	/* Wait for outstanding requests, then free irq */
 	spin_lock_irqsave(get_ccwdev_lock(raw->cdev), flags);
@@ -926,8 +926,6 @@ static int __init con3215_init(void)
 	dev_set_drvdata(&cdev->dev, raw);
 	cdev->handler = raw3215_irq;
 
-	raw->flags |= RAW3215_FIXED;
-
 	/* Request the console irq */
 	if (raw3215_startup(raw) != 0) {
 		raw3215_free_info(raw);

