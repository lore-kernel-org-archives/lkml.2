Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab1EGSUt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 14:20:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54536 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857Ab1EGSUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 14:20:48 -0400
Date: Sat, 7 May 2011 20:20:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110507182035.GA10046@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

This is larger than usual:

  - the breakpoints/ptrace fix is a bit late but fixes a crash

  - the cache-events regression fix is large due to the definitions added
    (which also document the PMU features) but is otherwise low risk.

Thanks,

	Ingo

------------------>
Frederic Weisbecker (6):
      ptrace: Prepare to fix racy accesses on task breakpoints
      x86, hw_breakpoints: Fix racy access to ptrace breakpoints
      powerpc, hw_breakpoints: Fix racy access to ptrace breakpoints
      arm, hw_breakpoints: Fix racy access to ptrace breakpoints
      sh, hw_breakpoints: Fix racy access to ptrace breakpoints
      hw_breakpoints, powerpc: Fix CONFIG_HAVE_HW_BREAKPOINT off-case in ptrace_set_debugreg()

Lin Ming (1):
      perf tools: Makefile: Use gcc to determine ARCH

Peter Zijlstra (1):
      perf events, x86: Fix Intel Nehalem and Westmere last level cache event definitions


 arch/arm/kernel/ptrace.c               |    8 +++
 arch/powerpc/kernel/ptrace.c           |   12 ++++-
 arch/sh/kernel/ptrace_32.c             |    4 ++
 arch/x86/kernel/cpu/perf_event_intel.c |   87 +++++++++++++++++++-------------
 arch/x86/kernel/ptrace.c               |   36 ++++++++++----
 include/linux/ptrace.h                 |   13 ++++-
 include/linux/sched.h                  |    3 +
 kernel/exit.c                          |    2 +-
 kernel/ptrace.c                        |   17 ++++++
 tools/perf/Makefile                    |   16 ++++--
 10 files changed, 144 insertions(+), 54 deletions(-)

diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 2bf27f3..8182f45 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -767,12 +767,20 @@ long arch_ptrace(struct task_struct *child, long request,
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 		case PTRACE_GETHBPREGS:
+			if (ptrace_get_breakpoints(child) < 0)
+				return -ESRCH;
+
 			ret = ptrace_gethbpregs(child, addr,
 						(unsigned long __user *)data);
+			ptrace_put_breakpoints(child);
 			break;
 		case PTRACE_SETHBPREGS:
+			if (ptrace_get_breakpoints(child) < 0)
+				return -ESRCH;
+
 			ret = ptrace_sethbpregs(child, addr,
 						(unsigned long __user *)data);
+			ptrace_put_breakpoints(child);
 			break;
 #endif
 
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 55613e3..a6ae1cf 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -933,12 +933,16 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
 	if (data && !(data & DABR_TRANSLATION))
 		return -EIO;
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
+	if (ptrace_get_breakpoints(task) < 0)
+		return -ESRCH;
+
 	bp = thread->ptrace_bps[0];
 	if ((!data) || !(data & (DABR_DATA_WRITE | DABR_DATA_READ))) {
 		if (bp) {
 			unregister_hw_breakpoint(bp);
 			thread->ptrace_bps[0] = NULL;
 		}
+		ptrace_put_breakpoints(task);
 		return 0;
 	}
 	if (bp) {
@@ -948,9 +952,12 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
 					(DABR_DATA_WRITE | DABR_DATA_READ),
 							&attr.bp_type);
 		ret =  modify_user_hw_breakpoint(bp, &attr);
-		if (ret)
+		if (ret) {
+			ptrace_put_breakpoints(task);
 			return ret;
+		}
 		thread->ptrace_bps[0] = bp;
+		ptrace_put_breakpoints(task);
 		thread->dabr = data;
 		return 0;
 	}
@@ -965,9 +972,12 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
 							ptrace_triggered, task);
 	if (IS_ERR(bp)) {
 		thread->ptrace_bps[0] = NULL;
+		ptrace_put_breakpoints(task);
 		return PTR_ERR(bp);
 	}
 
+	ptrace_put_breakpoints(task);
+
 #endif /* CONFIG_HAVE_HW_BREAKPOINT */
 
 	/* Move contents to the DABR register */
diff --git a/arch/sh/kernel/ptrace_32.c b/arch/sh/kernel/ptrace_32.c
index 2130ca6..3d7b209 100644
--- a/arch/sh/kernel/ptrace_32.c
+++ b/arch/sh/kernel/ptrace_32.c
@@ -117,7 +117,11 @@ void user_enable_single_step(struct task_struct *child)
 
 	set_tsk_thread_flag(child, TIF_SINGLESTEP);
 
+	if (ptrace_get_breakpoints(child) < 0)
+		return;
+
 	set_single_step(child, pc);
+	ptrace_put_breakpoints(child);
 }
 
 void user_disable_single_step(struct task_struct *child)
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index e61539b..447a28d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -184,26 +184,23 @@ static __initconst const u64 snb_hw_cache_event_ids
 	},
  },
  [ C(LL  ) ] = {
-	/*
-	 * TBD: Need Off-core Response Performance Monitoring support
-	 */
 	[ C(OP_READ) ] = {
-		/* OFFCORE_RESPONSE_0.ANY_DATA.LOCAL_CACHE */
+		/* OFFCORE_RESPONSE.ANY_DATA.LOCAL_CACHE */
 		[ C(RESULT_ACCESS) ] = 0x01b7,
-		/* OFFCORE_RESPONSE_1.ANY_DATA.ANY_LLC_MISS */
-		[ C(RESULT_MISS)   ] = 0x01bb,
+		/* OFFCORE_RESPONSE.ANY_DATA.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
 	[ C(OP_WRITE) ] = {
-		/* OFFCORE_RESPONSE_0.ANY_RFO.LOCAL_CACHE */
+		/* OFFCORE_RESPONSE.ANY_RFO.LOCAL_CACHE */
 		[ C(RESULT_ACCESS) ] = 0x01b7,
-		/* OFFCORE_RESPONSE_1.ANY_RFO.ANY_LLC_MISS */
-		[ C(RESULT_MISS)   ] = 0x01bb,
+		/* OFFCORE_RESPONSE.ANY_RFO.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
 	[ C(OP_PREFETCH) ] = {
-		/* OFFCORE_RESPONSE_0.PREFETCH.LOCAL_CACHE */
+		/* OFFCORE_RESPONSE.PREFETCH.LOCAL_CACHE */
 		[ C(RESULT_ACCESS) ] = 0x01b7,
-		/* OFFCORE_RESPONSE_1.PREFETCH.ANY_LLC_MISS */
-		[ C(RESULT_MISS)   ] = 0x01bb,
+		/* OFFCORE_RESPONSE.PREFETCH.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
  },
  [ C(DTLB) ] = {
@@ -285,26 +282,26 @@ static __initconst const u64 westmere_hw_cache_event_ids
  },
  [ C(LL  ) ] = {
 	[ C(OP_READ) ] = {
-		/* OFFCORE_RESPONSE_0.ANY_DATA.LOCAL_CACHE */
+		/* OFFCORE_RESPONSE.ANY_DATA.LOCAL_CACHE */
 		[ C(RESULT_ACCESS) ] = 0x01b7,
-		/* OFFCORE_RESPONSE_1.ANY_DATA.ANY_LLC_MISS */
-		[ C(RESULT_MISS)   ] = 0x01bb,
+		/* OFFCORE_RESPONSE.ANY_DATA.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
 	/*
 	 * Use RFO, not WRITEBACK, because a write miss would typically occur
 	 * on RFO.
 	 */
 	[ C(OP_WRITE) ] = {
-		/* OFFCORE_RESPONSE_1.ANY_RFO.LOCAL_CACHE */
-		[ C(RESULT_ACCESS) ] = 0x01bb,
-		/* OFFCORE_RESPONSE_0.ANY_RFO.ANY_LLC_MISS */
+		/* OFFCORE_RESPONSE.ANY_RFO.LOCAL_CACHE */
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		/* OFFCORE_RESPONSE.ANY_RFO.ANY_LLC_MISS */
 		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
 	[ C(OP_PREFETCH) ] = {
-		/* OFFCORE_RESPONSE_0.PREFETCH.LOCAL_CACHE */
+		/* OFFCORE_RESPONSE.PREFETCH.LOCAL_CACHE */
 		[ C(RESULT_ACCESS) ] = 0x01b7,
-		/* OFFCORE_RESPONSE_1.PREFETCH.ANY_LLC_MISS */
-		[ C(RESULT_MISS)   ] = 0x01bb,
+		/* OFFCORE_RESPONSE.PREFETCH.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
  },
  [ C(DTLB) ] = {
@@ -352,16 +349,36 @@ static __initconst const u64 westmere_hw_cache_event_ids
 };
 
 /*
- * OFFCORE_RESPONSE MSR bits (subset), See IA32 SDM Vol 3 30.6.1.3
+ * Nehalem/Westmere MSR_OFFCORE_RESPONSE bits;
+ * See IA32 SDM Vol 3B 30.6.1.3
  */
 
-#define DMND_DATA_RD     (1 << 0)
-#define DMND_RFO         (1 << 1)
-#define DMND_WB          (1 << 3)
-#define PF_DATA_RD       (1 << 4)
-#define PF_DATA_RFO      (1 << 5)
-#define RESP_UNCORE_HIT  (1 << 8)
-#define RESP_MISS        (0xf600) /* non uncore hit */
+#define NHM_DMND_DATA_RD	(1 << 0)
+#define NHM_DMND_RFO		(1 << 1)
+#define NHM_DMND_IFETCH		(1 << 2)
+#define NHM_DMND_WB		(1 << 3)
+#define NHM_PF_DATA_RD		(1 << 4)
+#define NHM_PF_DATA_RFO		(1 << 5)
+#define NHM_PF_IFETCH		(1 << 6)
+#define NHM_OFFCORE_OTHER	(1 << 7)
+#define NHM_UNCORE_HIT		(1 << 8)
+#define NHM_OTHER_CORE_HIT_SNP	(1 << 9)
+#define NHM_OTHER_CORE_HITM	(1 << 10)
+        			/* reserved */
+#define NHM_REMOTE_CACHE_FWD	(1 << 12)
+#define NHM_REMOTE_DRAM		(1 << 13)
+#define NHM_LOCAL_DRAM		(1 << 14)
+#define NHM_NON_DRAM		(1 << 15)
+
+#define NHM_ALL_DRAM		(NHM_REMOTE_DRAM|NHM_LOCAL_DRAM)
+
+#define NHM_DMND_READ		(NHM_DMND_DATA_RD)
+#define NHM_DMND_WRITE		(NHM_DMND_RFO|NHM_DMND_WB)
+#define NHM_DMND_PREFETCH	(NHM_PF_DATA_RD|NHM_PF_DATA_RFO)
+
+#define NHM_L3_HIT	(NHM_UNCORE_HIT|NHM_OTHER_CORE_HIT_SNP|NHM_OTHER_CORE_HITM)
+#define NHM_L3_MISS	(NHM_NON_DRAM|NHM_ALL_DRAM|NHM_REMOTE_CACHE_FWD)
+#define NHM_L3_ACCESS	(NHM_L3_HIT|NHM_L3_MISS)
 
 static __initconst const u64 nehalem_hw_cache_extra_regs
 				[PERF_COUNT_HW_CACHE_MAX]
@@ -370,16 +387,16 @@ static __initconst const u64 nehalem_hw_cache_extra_regs
 {
  [ C(LL  ) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = DMND_DATA_RD|RESP_UNCORE_HIT,
-		[ C(RESULT_MISS)   ] = DMND_DATA_RD|RESP_MISS,
+		[ C(RESULT_ACCESS) ] = NHM_DMND_READ|NHM_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = NHM_DMND_READ|NHM_L3_MISS,
 	},
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = DMND_RFO|DMND_WB|RESP_UNCORE_HIT,
-		[ C(RESULT_MISS)   ] = DMND_RFO|DMND_WB|RESP_MISS,
+		[ C(RESULT_ACCESS) ] = NHM_DMND_WRITE|NHM_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = NHM_DMND_WRITE|NHM_L3_MISS,
 	},
 	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = PF_DATA_RD|PF_DATA_RFO|RESP_UNCORE_HIT,
-		[ C(RESULT_MISS)   ] = PF_DATA_RD|PF_DATA_RFO|RESP_MISS,
+		[ C(RESULT_ACCESS) ] = NHM_DMND_PREFETCH|NHM_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = NHM_DMND_PREFETCH|NHM_L3_MISS,
 	},
  }
 };
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 45892dc..f65e5b5 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -608,6 +608,9 @@ static int ptrace_write_dr7(struct task_struct *tsk, unsigned long data)
 	unsigned len, type;
 	struct perf_event *bp;
 
+	if (ptrace_get_breakpoints(tsk) < 0)
+		return -ESRCH;
+
 	data &= ~DR_CONTROL_RESERVED;
 	old_dr7 = ptrace_get_dr7(thread->ptrace_bps);
 restore:
@@ -655,6 +658,9 @@ restore:
 		}
 		goto restore;
 	}
+
+	ptrace_put_breakpoints(tsk);
+
 	return ((orig_ret < 0) ? orig_ret : rc);
 }
 
@@ -668,10 +674,17 @@ static unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
 
 	if (n < HBP_NUM) {
 		struct perf_event *bp;
+
+		if (ptrace_get_breakpoints(tsk) < 0)
+			return -ESRCH;
+
 		bp = thread->ptrace_bps[n];
 		if (!bp)
-			return 0;
-		val = bp->hw.info.address;
+			val = 0;
+		else
+			val = bp->hw.info.address;
+
+		ptrace_put_breakpoints(tsk);
 	} else if (n == 6) {
 		val = thread->debugreg6;
 	 } else if (n == 7) {
@@ -686,6 +699,10 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
 	struct perf_event *bp;
 	struct thread_struct *t = &tsk->thread;
 	struct perf_event_attr attr;
+	int err = 0;
+
+	if (ptrace_get_breakpoints(tsk) < 0)
+		return -ESRCH;
 
 	if (!t->ptrace_bps[nr]) {
 		ptrace_breakpoint_init(&attr);
@@ -709,24 +726,23 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
 		 * writing for the user. And anyway this is the previous
 		 * behaviour.
 		 */
-		if (IS_ERR(bp))
-			return PTR_ERR(bp);
+		if (IS_ERR(bp)) {
+			err = PTR_ERR(bp);
+			goto put;
+		}
 
 		t->ptrace_bps[nr] = bp;
 	} else {
-		int err;
-
 		bp = t->ptrace_bps[nr];
 
 		attr = bp->attr;
 		attr.bp_addr = addr;
 		err = modify_user_hw_breakpoint(bp, &attr);
-		if (err)
-			return err;
 	}
 
-
-	return 0;
+put:
+	ptrace_put_breakpoints(tsk);
+	return err;
 }
 
 /*
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index a1147e5..9178d5c 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -189,6 +189,10 @@ static inline void ptrace_init_task(struct task_struct *child, bool ptrace)
 		child->ptrace = current->ptrace;
 		__ptrace_link(child, current->parent);
 	}
+
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+	atomic_set(&child->ptrace_bp_refcnt, 1);
+#endif
 }
 
 /**
@@ -350,6 +354,13 @@ extern int task_current_syscall(struct task_struct *target, long *callno,
 				unsigned long args[6], unsigned int maxargs,
 				unsigned long *sp, unsigned long *pc);
 
-#endif
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+extern int ptrace_get_breakpoints(struct task_struct *tsk);
+extern void ptrace_put_breakpoints(struct task_struct *tsk);
+#else
+static inline void ptrace_put_breakpoints(struct task_struct *tsk) { }
+#endif /* CONFIG_HAVE_HW_BREAKPOINT */
+
+#endif /* __KERNEL */
 
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 18d63ce..781abd1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1537,6 +1537,9 @@ struct task_struct {
 		unsigned long memsw_nr_pages; /* uncharged mem+swap usage */
 	} memcg_batch;
 #endif
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+	atomic_t ptrace_bp_refcnt;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/kernel/exit.c b/kernel/exit.c
index f5d2f63..8dd8741 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1016,7 +1016,7 @@ NORET_TYPE void do_exit(long code)
 	/*
 	 * FIXME: do that only when needed, using sched_exit tracepoint
 	 */
-	flush_ptrace_hw_breakpoint(tsk);
+	ptrace_put_breakpoints(tsk);
 
 	exit_notify(tsk, group_dead);
 #ifdef CONFIG_NUMA
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 0fc1eed..dc7ab65 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -22,6 +22,7 @@
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
 #include <linux/regset.h>
+#include <linux/hw_breakpoint.h>
 
 
 /*
@@ -879,3 +880,19 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 	return ret;
 }
 #endif	/* CONFIG_COMPAT */
+
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+int ptrace_get_breakpoints(struct task_struct *tsk)
+{
+	if (atomic_inc_not_zero(&tsk->ptrace_bp_refcnt))
+		return 0;
+
+	return -1;
+}
+
+void ptrace_put_breakpoints(struct task_struct *tsk)
+{
+	if (atomic_dec_and_test(&tsk->ptrace_bp_refcnt))
+		flush_ptrace_hw_breakpoint(tsk);
+}
+#endif /* CONFIG_HAVE_HW_BREAKPOINT */
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 207dee5..0c54256 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -35,15 +35,21 @@ ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
 				  -e s/sh[234].*/sh/ )
 
+CC = $(CROSS_COMPILE)gcc
+AR = $(CROSS_COMPILE)ar
+
 # Additional ARCH settings for x86
 ifeq ($(ARCH),i386)
         ARCH := x86
 endif
 ifeq ($(ARCH),x86_64)
-	RAW_ARCH := x86_64
-        ARCH := x86
-	ARCH_CFLAGS := -DARCH_X86_64
-	ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S
+	ARCH := x86
+	IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -xc - | tail -n 1)
+	ifeq (${IS_X86_64}, 1)
+		RAW_ARCH := x86_64
+		ARCH_CFLAGS := -DARCH_X86_64
+		ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S
+	endif
 endif
 
 #
@@ -119,8 +125,6 @@ lib = lib
 
 export prefix bindir sharedir sysconfdir
 
-CC = $(CROSS_COMPILE)gcc
-AR = $(CROSS_COMPILE)ar
 RM = rm -f
 MKDIR = mkdir
 FIND = find
