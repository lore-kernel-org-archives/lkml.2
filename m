Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934101Ab2FHJUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 05:20:13 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49800 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934049Ab2FHJUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 05:20:08 -0400
Date: Fri, 8 Jun 2012 11:20:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20120608092002.GA12129@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: db0dc75d6403b6663c0eab4c6ccb672eb9b2ed72 perf/x86: Check user address explicitly in copy_from_user_nmi()

A bit larger than what I'd wish for - half of it is due to hw 
driver updates to Intel Ivy-Bridge which info got recently 
released, cycles:pp should work there now too, amongst other 
things. (but we are generally making exceptions for hardware 
enablement of this type.)

There are also callchain fixes in it - responding to mostly 
theoretical (but valid) concerns. The tooling side sports 
perf.data endianness/portability fixes which did not make 
it for the merge window - and various other fixes as well.

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (5):
      perf report: Use the right symbol for annotation
      perf annotate browser: Fix help window entry for navigating to hottest line
      perf stat: Initialize default events wrt exclude_{guest,host}
      perf tools: Fix make tarballs
      perf tools: Make --version show kernel version instead of pull req tag

Arun Sharma (4):
      perf/x86: Allow multiple stacks
      perf: Limit callchains to 127
      perf/x86: Check if user fp is valid
      perf/x86: Check user address explicitly in copy_from_user_nmi()

Avik Sil (1):
      perf tools: Fix pager on minimal-install embedded systems

David Ahern (1):
      perf script: Fix regression in callchain dso name

Jiri Olsa (3):
      perf symbols: Handle different endians properly during symbol load
      perf session: Handle endianity swap on sample_id_all header data
      perf evsel: Fix 32 bit values endianity swap for sample_id_all header

Masami Hiramatsu (1):
      x86/decoder: Fix bsr/bsf/jmpe decoding with operand-size prefix

Namhyung Kim (5):
      perf callchain: Make callchain cursors TLS
      perf tools: Check if callchain is corrupted
      perf tools: Update ioctl documentation for PERF_IOC_FLAG_GROUP
      perf evlist: Pass third argument to ioctl explicitly
      perf: Remove duplicate invocation on perf_event_for_each

Peter Zijlstra (4):
      perf/x86: Fix Intel shared extra MSR allocation
      perf/x86: Implement cycles:p for SNB/IVB
      perf/x86: Enable/Add IvyBridge hardware support
      perf/x86: Update SNB PEBS constraints

Srikar Dronamraju (2):
      perf symbols: Check for valid dso before creating map
      perf uprobes: Remove unnecessary check before strlist__delete


 arch/x86/include/asm/uaccess.h            |  12 +--
 arch/x86/kernel/cpu/perf_event.c          |  11 ++-
 arch/x86/kernel/cpu/perf_event.h          |   2 +
 arch/x86/kernel/cpu/perf_event_intel.c    | 145 ++++++++++++++++++++++--------
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   9 +-
 arch/x86/lib/usercopy.c                   |   4 +
 arch/x86/lib/x86-opcode-map.txt           |   8 +-
 arch/x86/tools/gen-insn-attr-x86.awk      |  14 +--
 include/linux/perf_event.h                |   4 +-
 kernel/events/core.c                      |   1 -
 tools/perf/MANIFEST                       |   2 +
 tools/perf/builtin-report.c               |   4 +-
 tools/perf/builtin-stat.c                 |   8 +-
 tools/perf/builtin-top.c                  |   2 +-
 tools/perf/design.txt                     |   7 +-
 tools/perf/ui/browsers/annotate.c         |   2 +-
 tools/perf/util/PERF-VERSION-GEN          |   2 +-
 tools/perf/util/callchain.c               |   2 +
 tools/perf/util/callchain.h               |   2 +
 tools/perf/util/evlist.c                  |  17 +++-
 tools/perf/util/evlist.h                  |   4 +
 tools/perf/util/evsel.c                   |  29 ++++--
 tools/perf/util/hist.c                    |   7 +-
 tools/perf/util/hist.h                    |   2 -
 tools/perf/util/pager.c                   |   4 +
 tools/perf/util/probe-event.c             |   8 +-
 tools/perf/util/session.c                 |  97 +++++++++++++++-----
 tools/perf/util/symbol.c                  |  38 +++++++-
 tools/perf/util/symbol.h                  |  30 +++++++
 29 files changed, 357 insertions(+), 120 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 04cd688..e1f3a17 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -33,9 +33,8 @@
 #define segment_eq(a, b)	((a).seg == (b).seg)
 
 #define user_addr_max() (current_thread_info()->addr_limit.seg)
-#define __addr_ok(addr)					\
-	((unsigned long __force)(addr) <		\
-	 (current_thread_info()->addr_limit.seg))
+#define __addr_ok(addr) 	\
+	((unsigned long __force)(addr) < user_addr_max())
 
 /*
  * Test whether a block of memory is a valid user space address.
@@ -47,14 +46,14 @@
  * This needs 33-bit (65-bit for x86_64) arithmetic. We have a carry...
  */
 
-#define __range_not_ok(addr, size)					\
+#define __range_not_ok(addr, size, limit)				\
 ({									\
 	unsigned long flag, roksum;					\
 	__chk_user_ptr(addr);						\
 	asm("add %3,%1 ; sbb %0,%0 ; cmp %1,%4 ; sbb $0,%0"		\
 	    : "=&r" (flag), "=r" (roksum)				\
 	    : "1" (addr), "g" ((long)(size)),				\
-	      "rm" (current_thread_info()->addr_limit.seg));		\
+	      "rm" (limit));						\
 	flag;								\
 })
 
@@ -77,7 +76,8 @@
  * checks that the pointer is in the user space range - after calling
  * this function, memory access functions may still return -EFAULT.
  */
-#define access_ok(type, addr, size) (likely(__range_not_ok(addr, size) == 0))
+#define access_ok(type, addr, size) \
+	(likely(__range_not_ok(addr, size, user_addr_max()) == 0))
 
 /*
  * The exception table consists of pairs of addresses relative to the
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index e049d6d..c4706cf 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1496,6 +1496,7 @@ static struct cpu_hw_events *allocate_fake_cpuc(void)
 		if (!cpuc->shared_regs)
 			goto error;
 	}
+	cpuc->is_fake = 1;
 	return cpuc;
 error:
 	free_fake_cpuc(cpuc);
@@ -1756,6 +1757,12 @@ perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
 	dump_trace(NULL, regs, NULL, 0, &backtrace_ops, entry);
 }
 
+static inline int
+valid_user_frame(const void __user *fp, unsigned long size)
+{
+	return (__range_not_ok(fp, size, TASK_SIZE) == 0);
+}
+
 #ifdef CONFIG_COMPAT
 
 #include <asm/compat.h>
@@ -1780,7 +1787,7 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 		if (bytes != sizeof(frame))
 			break;
 
-		if (fp < compat_ptr(regs->sp))
+		if (!valid_user_frame(fp, sizeof(frame)))
 			break;
 
 		perf_callchain_store(entry, frame.return_address);
@@ -1826,7 +1833,7 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 		if (bytes != sizeof(frame))
 			break;
 
-		if ((unsigned long)fp < regs->sp)
+		if (!valid_user_frame(fp, sizeof(frame)))
 			break;
 
 		perf_callchain_store(entry, frame.return_address);
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 6638aaf..7241e2f 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -117,6 +117,7 @@ struct cpu_hw_events {
 	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
 
 	unsigned int		group_flag;
+	int			is_fake;
 
 	/*
 	 * Intel DebugStore bits
@@ -364,6 +365,7 @@ struct x86_pmu {
 	int		pebs_record_size;
 	void		(*drain_pebs)(struct pt_regs *regs);
 	struct event_constraint *pebs_constraints;
+	void		(*pebs_aliases)(struct perf_event *event);
 
 	/*
 	 * Intel LBR
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 166546e..187c294 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1119,27 +1119,33 @@ intel_bts_constraints(struct perf_event *event)
 	return NULL;
 }
 
-static bool intel_try_alt_er(struct perf_event *event, int orig_idx)
+static int intel_alt_er(int idx)
 {
 	if (!(x86_pmu.er_flags & ERF_HAS_RSP_1))
-		return false;
+		return idx;
 
-	if (event->hw.extra_reg.idx == EXTRA_REG_RSP_0) {
-		event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
-		event->hw.config |= 0x01bb;
-		event->hw.extra_reg.idx = EXTRA_REG_RSP_1;
-		event->hw.extra_reg.reg = MSR_OFFCORE_RSP_1;
-	} else if (event->hw.extra_reg.idx == EXTRA_REG_RSP_1) {
+	if (idx == EXTRA_REG_RSP_0)
+		return EXTRA_REG_RSP_1;
+
+	if (idx == EXTRA_REG_RSP_1)
+		return EXTRA_REG_RSP_0;
+
+	return idx;
+}
+
+static void intel_fixup_er(struct perf_event *event, int idx)
+{
+	event->hw.extra_reg.idx = idx;
+
+	if (idx == EXTRA_REG_RSP_0) {
 		event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
 		event->hw.config |= 0x01b7;
-		event->hw.extra_reg.idx = EXTRA_REG_RSP_0;
 		event->hw.extra_reg.reg = MSR_OFFCORE_RSP_0;
+	} else if (idx == EXTRA_REG_RSP_1) {
+		event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
+		event->hw.config |= 0x01bb;
+		event->hw.extra_reg.reg = MSR_OFFCORE_RSP_1;
 	}
-
-	if (event->hw.extra_reg.idx == orig_idx)
-		return false;
-
-	return true;
 }
 
 /*
@@ -1157,14 +1163,18 @@ __intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
 	struct event_constraint *c = &emptyconstraint;
 	struct er_account *era;
 	unsigned long flags;
-	int orig_idx = reg->idx;
+	int idx = reg->idx;
 
-	/* already allocated shared msr */
-	if (reg->alloc)
+	/*
+	 * reg->alloc can be set due to existing state, so for fake cpuc we
+	 * need to ignore this, otherwise we might fail to allocate proper fake
+	 * state for this extra reg constraint. Also see the comment below.
+	 */
+	if (reg->alloc && !cpuc->is_fake)
 		return NULL; /* call x86_get_event_constraint() */
 
 again:
-	era = &cpuc->shared_regs->regs[reg->idx];
+	era = &cpuc->shared_regs->regs[idx];
 	/*
 	 * we use spin_lock_irqsave() to avoid lockdep issues when
 	 * passing a fake cpuc
@@ -1173,6 +1183,29 @@ again:
 
 	if (!atomic_read(&era->ref) || era->config == reg->config) {
 
+		/*
+		 * If its a fake cpuc -- as per validate_{group,event}() we
+		 * shouldn't touch event state and we can avoid doing so
+		 * since both will only call get_event_constraints() once
+		 * on each event, this avoids the need for reg->alloc.
+		 *
+		 * Not doing the ER fixup will only result in era->reg being
+		 * wrong, but since we won't actually try and program hardware
+		 * this isn't a problem either.
+		 */
+		if (!cpuc->is_fake) {
+			if (idx != reg->idx)
+				intel_fixup_er(event, idx);
+
+			/*
+			 * x86_schedule_events() can call get_event_constraints()
+			 * multiple times on events in the case of incremental
+			 * scheduling(). reg->alloc ensures we only do the ER
+			 * allocation once.
+			 */
+			reg->alloc = 1;
+		}
+
 		/* lock in msr value */
 		era->config = reg->config;
 		era->reg = reg->reg;
@@ -1180,17 +1213,17 @@ again:
 		/* one more user */
 		atomic_inc(&era->ref);
 
-		/* no need to reallocate during incremental event scheduling */
-		reg->alloc = 1;
-
 		/*
 		 * need to call x86_get_event_constraint()
 		 * to check if associated event has constraints
 		 */
 		c = NULL;
-	} else if (intel_try_alt_er(event, orig_idx)) {
-		raw_spin_unlock_irqrestore(&era->lock, flags);
-		goto again;
+	} else {
+		idx = intel_alt_er(idx);
+		if (idx != reg->idx) {
+			raw_spin_unlock_irqrestore(&era->lock, flags);
+			goto again;
+		}
 	}
 	raw_spin_unlock_irqrestore(&era->lock, flags);
 
@@ -1204,11 +1237,14 @@ __intel_shared_reg_put_constraints(struct cpu_hw_events *cpuc,
 	struct er_account *era;
 
 	/*
-	 * only put constraint if extra reg was actually
-	 * allocated. Also takes care of event which do
-	 * not use an extra shared reg
+	 * Only put constraint if extra reg was actually allocated. Also takes
+	 * care of event which do not use an extra shared reg.
+	 *
+	 * Also, if this is a fake cpuc we shouldn't touch any event state
+	 * (reg->alloc) and we don't care about leaving inconsistent cpuc state
+	 * either since it'll be thrown out.
 	 */
-	if (!reg->alloc)
+	if (!reg->alloc || cpuc->is_fake)
 		return;
 
 	era = &cpuc->shared_regs->regs[reg->idx];
@@ -1300,15 +1336,9 @@ static void intel_put_event_constraints(struct cpu_hw_events *cpuc,
 	intel_put_shared_regs_event_constraints(cpuc, event);
 }
 
-static int intel_pmu_hw_config(struct perf_event *event)
+static void intel_pebs_aliases_core2(struct perf_event *event)
 {
-	int ret = x86_pmu_hw_config(event);
-
-	if (ret)
-		return ret;
-
-	if (event->attr.precise_ip &&
-	    (event->hw.config & X86_RAW_EVENT_MASK) == 0x003c) {
+	if ((event->hw.config & X86_RAW_EVENT_MASK) == 0x003c) {
 		/*
 		 * Use an alternative encoding for CPU_CLK_UNHALTED.THREAD_P
 		 * (0x003c) so that we can use it with PEBS.
@@ -1329,10 +1359,48 @@ static int intel_pmu_hw_config(struct perf_event *event)
 		 */
 		u64 alt_config = X86_CONFIG(.event=0xc0, .inv=1, .cmask=16);
 
+		alt_config |= (event->hw.config & ~X86_RAW_EVENT_MASK);
+		event->hw.config = alt_config;
+	}
+}
+
+static void intel_pebs_aliases_snb(struct perf_event *event)
+{
+	if ((event->hw.config & X86_RAW_EVENT_MASK) == 0x003c) {
+		/*
+		 * Use an alternative encoding for CPU_CLK_UNHALTED.THREAD_P
+		 * (0x003c) so that we can use it with PEBS.
+		 *
+		 * The regular CPU_CLK_UNHALTED.THREAD_P event (0x003c) isn't
+		 * PEBS capable. However we can use UOPS_RETIRED.ALL
+		 * (0x01c2), which is a PEBS capable event, to get the same
+		 * count.
+		 *
+		 * UOPS_RETIRED.ALL counts the number of cycles that retires
+		 * CNTMASK micro-ops. By setting CNTMASK to a value (16)
+		 * larger than the maximum number of micro-ops that can be
+		 * retired per cycle (4) and then inverting the condition, we
+		 * count all cycles that retire 16 or less micro-ops, which
+		 * is every cycle.
+		 *
+		 * Thereby we gain a PEBS capable cycle counter.
+		 */
+		u64 alt_config = X86_CONFIG(.event=0xc2, .umask=0x01, .inv=1, .cmask=16);
 
 		alt_config |= (event->hw.config & ~X86_RAW_EVENT_MASK);
 		event->hw.config = alt_config;
 	}
+}
+
+static int intel_pmu_hw_config(struct perf_event *event)
+{
+	int ret = x86_pmu_hw_config(event);
+
+	if (ret)
+		return ret;
+
+	if (event->attr.precise_ip && x86_pmu.pebs_aliases)
+		x86_pmu.pebs_aliases(event);
 
 	if (intel_pmu_needs_lbr_smpl(event)) {
 		ret = intel_pmu_setup_lbr_filter(event);
@@ -1607,6 +1675,7 @@ static __initconst const struct x86_pmu intel_pmu = {
 	.max_period		= (1ULL << 31) - 1,
 	.get_event_constraints	= intel_get_event_constraints,
 	.put_event_constraints	= intel_put_event_constraints,
+	.pebs_aliases		= intel_pebs_aliases_core2,
 
 	.format_attrs		= intel_arch3_formats_attr,
 
@@ -1840,8 +1909,9 @@ __init int intel_pmu_init(void)
 		break;
 
 	case 42: /* SandyBridge */
-		x86_add_quirk(intel_sandybridge_quirk);
 	case 45: /* SandyBridge, "Romely-EP" */
+		x86_add_quirk(intel_sandybridge_quirk);
+	case 58: /* IvyBridge */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
@@ -1849,6 +1919,7 @@ __init int intel_pmu_init(void)
 
 		x86_pmu.event_constraints = intel_snb_event_constraints;
 		x86_pmu.pebs_constraints = intel_snb_pebs_event_constraints;
+		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
 		x86_pmu.extra_regs = intel_snb_extra_regs;
 		/* all extra regs are per-cpu when HT is on */
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 5a3edc2..35e2192 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -400,14 +400,7 @@ struct event_constraint intel_snb_pebs_event_constraints[] = {
 	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xcd, 0x8),    /* MEM_TRANS_RETIRED.* */
-	INTEL_UEVENT_CONSTRAINT(0x11d0, 0xf), /* MEM_UOP_RETIRED.STLB_MISS_LOADS */
-	INTEL_UEVENT_CONSTRAINT(0x12d0, 0xf), /* MEM_UOP_RETIRED.STLB_MISS_STORES */
-	INTEL_UEVENT_CONSTRAINT(0x21d0, 0xf), /* MEM_UOP_RETIRED.LOCK_LOADS */
-	INTEL_UEVENT_CONSTRAINT(0x22d0, 0xf), /* MEM_UOP_RETIRED.LOCK_STORES */
-	INTEL_UEVENT_CONSTRAINT(0x41d0, 0xf), /* MEM_UOP_RETIRED.SPLIT_LOADS */
-	INTEL_UEVENT_CONSTRAINT(0x42d0, 0xf), /* MEM_UOP_RETIRED.SPLIT_STORES */
-	INTEL_UEVENT_CONSTRAINT(0x81d0, 0xf), /* MEM_UOP_RETIRED.ANY_LOADS */
-	INTEL_UEVENT_CONSTRAINT(0x82d0, 0xf), /* MEM_UOP_RETIRED.ANY_STORES */
+	INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
 	INTEL_UEVENT_CONSTRAINT(0x02d4, 0xf), /* MEM_LOAD_UOPS_MISC_RETIRED.LLC_MISS */
diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
index f61ee67..677b1ed 100644
--- a/arch/x86/lib/usercopy.c
+++ b/arch/x86/lib/usercopy.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 
 #include <asm/word-at-a-time.h>
+#include <linux/sched.h>
 
 /*
  * best effort, GUP based copy_from_user() that is NMI-safe
@@ -21,6 +22,9 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 	void *map;
 	int ret;
 
+	if (__range_not_ok(from, n, TASK_SIZE) == 0)
+		return len;
+
 	do {
 		ret = __get_user_pages_fast(addr, 1, 0, &page);
 		if (!ret)
diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 8191379..5d7e51f 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -28,7 +28,7 @@
 #  - (66): the last prefix is 0x66
 #  - (F3): the last prefix is 0xF3
 #  - (F2): the last prefix is 0xF2
-#
+#  - (!F3) : the last prefix is not 0xF3 (including non-last prefix case)
 
 Table: one byte opcode
 Referrer:
@@ -515,12 +515,12 @@ b4: LFS Gv,Mp
 b5: LGS Gv,Mp
 b6: MOVZX Gv,Eb
 b7: MOVZX Gv,Ew
-b8: JMPE | POPCNT Gv,Ev (F3)
+b8: JMPE (!F3) | POPCNT Gv,Ev (F3)
 b9: Grp10 (1A)
 ba: Grp8 Ev,Ib (1A)
 bb: BTC Ev,Gv
-bc: BSF Gv,Ev | TZCNT Gv,Ev (F3)
-bd: BSR Gv,Ev | LZCNT Gv,Ev (F3)
+bc: BSF Gv,Ev (!F3) | TZCNT Gv,Ev (F3)
+bd: BSR Gv,Ev (!F3) | LZCNT Gv,Ev (F3)
 be: MOVSX Gv,Eb
 bf: MOVSX Gv,Ew
 # 0x0f 0xc0-0xcf
diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
index 5f6a5b6..ddcf39b 100644
--- a/arch/x86/tools/gen-insn-attr-x86.awk
+++ b/arch/x86/tools/gen-insn-attr-x86.awk
@@ -66,9 +66,10 @@ BEGIN {
 	rex_expr = "^REX(\\.[XRWB]+)*"
 	fpu_expr = "^ESC" # TODO
 
-	lprefix1_expr = "\\(66\\)"
+	lprefix1_expr = "\\((66|!F3)\\)"
 	lprefix2_expr = "\\(F3\\)"
-	lprefix3_expr = "\\(F2\\)"
+	lprefix3_expr = "\\((F2|!F3)\\)"
+	lprefix_expr = "\\((66|F2|F3)\\)"
 	max_lprefix = 4
 
 	# All opcodes starting with lower-case 'v' or with (v1) superscript
@@ -333,13 +334,16 @@ function convert_operands(count,opnd,       i,j,imm,mod)
 		if (match(ext, lprefix1_expr)) {
 			lptable1[idx] = add_flags(lptable1[idx],flags)
 			variant = "INAT_VARIANT"
-		} else if (match(ext, lprefix2_expr)) {
+		}
+		if (match(ext, lprefix2_expr)) {
 			lptable2[idx] = add_flags(lptable2[idx],flags)
 			variant = "INAT_VARIANT"
-		} else if (match(ext, lprefix3_expr)) {
+		}
+		if (match(ext, lprefix3_expr)) {
 			lptable3[idx] = add_flags(lptable3[idx],flags)
 			variant = "INAT_VARIANT"
-		} else {
+		}
+		if (!match(ext, lprefix_expr)){
 			table[idx] = add_flags(table[idx],flags)
 		}
 	}
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f325786..45db49f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -555,6 +555,8 @@ enum perf_event_type {
 	PERF_RECORD_MAX,			/* non-ABI */
 };
 
+#define PERF_MAX_STACK_DEPTH		127
+
 enum perf_callchain_context {
 	PERF_CONTEXT_HV			= (__u64)-32,
 	PERF_CONTEXT_KERNEL		= (__u64)-128,
@@ -609,8 +611,6 @@ struct perf_guest_info_callbacks {
 #include <linux/sysfs.h>
 #include <asm/local.h>
 
-#define PERF_MAX_STACK_DEPTH		255
-
 struct perf_callchain_entry {
 	__u64				nr;
 	__u64				ip[PERF_MAX_STACK_DEPTH];
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5b06cbb..f85c015 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3181,7 +3181,6 @@ static void perf_event_for_each(struct perf_event *event,
 	event = event->group_leader;
 
 	perf_event_for_each_child(event, func);
-	func(event);
 	list_for_each_entry(sibling, &event->sibling_list, group_entry)
 		perf_event_for_each_child(sibling, func);
 	mutex_unlock(&ctx->mutex);
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 5476bc0..b4b572e 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -1,4 +1,6 @@
 tools/perf
+tools/scripts
+tools/lib/traceevent
 include/linux/const.h
 include/linux/perf_event.h
 include/linux/rbtree.h
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8c767c6..25249f7 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -152,7 +152,7 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 
 	if (symbol_conf.use_callchain) {
 		err = callchain_append(he->callchain,
-				       &evsel->hists.callchain_cursor,
+				       &callchain_cursor,
 				       sample->period);
 		if (err)
 			return err;
@@ -162,7 +162,7 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	 * so we don't allocated the extra space needed because the stdio
 	 * code will not use it.
 	 */
-	if (al->sym != NULL && use_browser > 0) {
+	if (he->ms.sym != NULL && use_browser > 0) {
 		struct annotation *notes = symbol__annotation(he->ms.sym);
 
 		assert(evsel != NULL);
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 62ae30d..2625899 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1129,7 +1129,7 @@ static int add_default_attributes(void)
 		return 0;
 
 	if (!evsel_list->nr_entries) {
-		if (perf_evlist__add_attrs_array(evsel_list, default_attrs) < 0)
+		if (perf_evlist__add_default_attrs(evsel_list, default_attrs) < 0)
 			return -1;
 	}
 
@@ -1139,21 +1139,21 @@ static int add_default_attributes(void)
 		return 0;
 
 	/* Append detailed run extra attributes: */
-	if (perf_evlist__add_attrs_array(evsel_list, detailed_attrs) < 0)
+	if (perf_evlist__add_default_attrs(evsel_list, detailed_attrs) < 0)
 		return -1;
 
 	if (detailed_run < 2)
 		return 0;
 
 	/* Append very detailed run extra attributes: */
-	if (perf_evlist__add_attrs_array(evsel_list, very_detailed_attrs) < 0)
+	if (perf_evlist__add_default_attrs(evsel_list, very_detailed_attrs) < 0)
 		return -1;
 
 	if (detailed_run < 3)
 		return 0;
 
 	/* Append very, very detailed run extra attributes: */
-	return perf_evlist__add_attrs_array(evsel_list, very_very_detailed_attrs);
+	return perf_evlist__add_default_attrs(evsel_list, very_very_detailed_attrs);
 }
 
 int cmd_stat(int argc, const char **argv, const char *prefix __used)
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 871b540..6bb0277 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -787,7 +787,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 		}
 
 		if (symbol_conf.use_callchain) {
-			err = callchain_append(he->callchain, &evsel->hists.callchain_cursor,
+			err = callchain_append(he->callchain, &callchain_cursor,
 					       sample->period);
 			if (err)
 				return;
diff --git a/tools/perf/design.txt b/tools/perf/design.txt
index bd0bb1b..67e5d0c 100644
--- a/tools/perf/design.txt
+++ b/tools/perf/design.txt
@@ -409,14 +409,15 @@ Counters can be enabled and disabled in two ways: via ioctl and via
 prctl.  When a counter is disabled, it doesn't count or generate
 events but does continue to exist and maintain its count value.
 
-An individual counter or counter group can be enabled with
+An individual counter can be enabled with
 
-	ioctl(fd, PERF_EVENT_IOC_ENABLE);
+	ioctl(fd, PERF_EVENT_IOC_ENABLE, 0);
 
 or disabled with
 
-	ioctl(fd, PERF_EVENT_IOC_DISABLE);
+	ioctl(fd, PERF_EVENT_IOC_DISABLE, 0);
 
+For a counter group, pass PERF_IOC_FLAG_GROUP as the third argument.
 Enabling or disabling the leader of a group enables or disables the
 whole group; that is, while the group leader is disabled, none of the
 counters in the group will count.  Enabling or disabling a member of a
diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 4deea6a..34b1c46 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -668,7 +668,7 @@ static int annotate_browser__run(struct annotate_browser *browser, int evidx,
 		"q/ESC/CTRL+C  Exit\n\n"
 		"->            Go to target\n"
 		"<-            Exit\n"
-		"h             Cycle thru hottest instructions\n"
+		"H             Cycle thru hottest instructions\n"
 		"j             Toggle showing jump to target arrows\n"
 		"J             Toggle showing number of jump sources on targets\n"
 		"n             Search next string\n"
diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index ad73300..95264f3 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -12,7 +12,7 @@ LF='
 # First check if there is a .git to get the version from git describe
 # otherwise try to get the version from the kernel makefile
 if test -d ../../.git -o -f ../../.git &&
-	VN=$(git describe --abbrev=4 HEAD 2>/dev/null) &&
+	VN=$(git describe --match 'v[0-9].[0-9]*' --abbrev=4 HEAD 2>/dev/null) &&
 	case "$VN" in
 	*$LF*) (exit 1) ;;
 	v[0-9]*)
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 9f7106a..3a6bff4 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -18,6 +18,8 @@
 #include "util.h"
 #include "callchain.h"
 
+__thread struct callchain_cursor callchain_cursor;
+
 bool ip_callchain__valid(struct ip_callchain *chain,
 			 const union perf_event *event)
 {
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 7f9c0f1..3bdb407 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -76,6 +76,8 @@ struct callchain_cursor {
 	struct callchain_cursor_node	*curr;
 };
 
+extern __thread struct callchain_cursor callchain_cursor;
+
 static inline void callchain_init(struct callchain_root *root)
 {
 	INIT_LIST_HEAD(&root->node.siblings);
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 4ac5f5a..7400fb3 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -159,6 +159,17 @@ out_delete_partial_list:
 	return -1;
 }
 
+int __perf_evlist__add_default_attrs(struct perf_evlist *evlist,
+				     struct perf_event_attr *attrs, size_t nr_attrs)
+{
+	size_t i;
+
+	for (i = 0; i < nr_attrs; i++)
+		event_attr_init(attrs + i);
+
+	return perf_evlist__add_attrs(evlist, attrs, nr_attrs);
+}
+
 static int trace_event__id(const char *evname)
 {
 	char *filename, *colon;
@@ -263,7 +274,8 @@ void perf_evlist__disable(struct perf_evlist *evlist)
 	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
 			for (thread = 0; thread < evlist->threads->nr; thread++)
-				ioctl(FD(pos, cpu, thread), PERF_EVENT_IOC_DISABLE);
+				ioctl(FD(pos, cpu, thread),
+				      PERF_EVENT_IOC_DISABLE, 0);
 		}
 	}
 }
@@ -276,7 +288,8 @@ void perf_evlist__enable(struct perf_evlist *evlist)
 	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
 			for (thread = 0; thread < evlist->threads->nr; thread++)
-				ioctl(FD(pos, cpu, thread), PERF_EVENT_IOC_ENABLE);
+				ioctl(FD(pos, cpu, thread),
+				      PERF_EVENT_IOC_ENABLE, 0);
 		}
 	}
 }
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 58abb63..989bee9 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -54,6 +54,8 @@ void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry);
 int perf_evlist__add_default(struct perf_evlist *evlist);
 int perf_evlist__add_attrs(struct perf_evlist *evlist,
 			   struct perf_event_attr *attrs, size_t nr_attrs);
+int __perf_evlist__add_default_attrs(struct perf_evlist *evlist,
+				     struct perf_event_attr *attrs, size_t nr_attrs);
 int perf_evlist__add_tracepoints(struct perf_evlist *evlist,
 				 const char *tracepoints[], size_t nr_tracepoints);
 int perf_evlist__set_tracepoints_handlers(struct perf_evlist *evlist,
@@ -62,6 +64,8 @@ int perf_evlist__set_tracepoints_handlers(struct perf_evlist *evlist,
 
 #define perf_evlist__add_attrs_array(evlist, array) \
 	perf_evlist__add_attrs(evlist, array, ARRAY_SIZE(array))
+#define perf_evlist__add_default_attrs(evlist, array) \
+	__perf_evlist__add_default_attrs(evlist, array, ARRAY_SIZE(array))
 
 #define perf_evlist__add_tracepoints_array(evlist, array) \
 	perf_evlist__add_tracepoints(evlist, array, ARRAY_SIZE(array))
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 91d1913..9f6cebd 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -494,16 +494,24 @@ int perf_evsel__open_per_thread(struct perf_evsel *evsel,
 }
 
 static int perf_event__parse_id_sample(const union perf_event *event, u64 type,
-				       struct perf_sample *sample)
+				       struct perf_sample *sample,
+				       bool swapped)
 {
 	const u64 *array = event->sample.array;
+	union u64_swap u;
 
 	array += ((event->header.size -
 		   sizeof(event->header)) / sizeof(u64)) - 1;
 
 	if (type & PERF_SAMPLE_CPU) {
-		u32 *p = (u32 *)array;
-		sample->cpu = *p;
+		u.val64 = *array;
+		if (swapped) {
+			/* undo swap of u64, then swap on individual u32s */
+			u.val64 = bswap_64(u.val64);
+			u.val32[0] = bswap_32(u.val32[0]);
+		}
+
+		sample->cpu = u.val32[0];
 		array--;
 	}
 
@@ -523,9 +531,16 @@ static int perf_event__parse_id_sample(const union perf_event *event, u64 type,
 	}
 
 	if (type & PERF_SAMPLE_TID) {
-		u32 *p = (u32 *)array;
-		sample->pid = p[0];
-		sample->tid = p[1];
+		u.val64 = *array;
+		if (swapped) {
+			/* undo swap of u64, then swap on individual u32s */
+			u.val64 = bswap_64(u.val64);
+			u.val32[0] = bswap_32(u.val32[0]);
+			u.val32[1] = bswap_32(u.val32[1]);
+		}
+
+		sample->pid = u.val32[0];
+		sample->tid = u.val32[1];
 	}
 
 	return 0;
@@ -562,7 +577,7 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	if (event->header.type != PERF_RECORD_SAMPLE) {
 		if (!sample_id_all)
 			return 0;
-		return perf_event__parse_id_sample(event, type, data);
+		return perf_event__parse_id_sample(event, type, data, swapped);
 	}
 
 	array = event->sample.array;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 1293b5e..514e2a4 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -378,7 +378,7 @@ void hist_entry__free(struct hist_entry *he)
  * collapse the histogram
  */
 
-static bool hists__collapse_insert_entry(struct hists *hists,
+static bool hists__collapse_insert_entry(struct hists *hists __used,
 					 struct rb_root *root,
 					 struct hist_entry *he)
 {
@@ -397,8 +397,9 @@ static bool hists__collapse_insert_entry(struct hists *hists,
 			iter->period += he->period;
 			iter->nr_events += he->nr_events;
 			if (symbol_conf.use_callchain) {
-				callchain_cursor_reset(&hists->callchain_cursor);
-				callchain_merge(&hists->callchain_cursor, iter->callchain,
+				callchain_cursor_reset(&callchain_cursor);
+				callchain_merge(&callchain_cursor,
+						iter->callchain,
 						he->callchain);
 			}
 			hist_entry__free(he);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index cfc64e2..34bb556 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -67,8 +67,6 @@ struct hists {
 	struct events_stats	stats;
 	u64			event_stream;
 	u16			col_len[HISTC_NR_COLS];
-	/* Best would be to reuse the session callchain cursor */
-	struct callchain_cursor	callchain_cursor;
 };
 
 struct hist_entry *__hists__add_entry(struct hists *self,
diff --git a/tools/perf/util/pager.c b/tools/perf/util/pager.c
index 1915de2..3322b84 100644
--- a/tools/perf/util/pager.c
+++ b/tools/perf/util/pager.c
@@ -57,6 +57,10 @@ void setup_pager(void)
 	}
 	if (!pager)
 		pager = getenv("PAGER");
+	if (!pager) {
+		if (!access("/usr/bin/pager", X_OK))
+			pager = "/usr/bin/pager";
+	}
 	if (!pager)
 		pager = "less";
 	else if (!*pager || !strcmp(pager, "cat"))
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 59dccc9..0dda25d 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2164,16 +2164,12 @@ int del_perf_probe_events(struct strlist *dellist)
 
 error:
 	if (kfd >= 0) {
-		if (namelist)
-			strlist__delete(namelist);
-
+		strlist__delete(namelist);
 		close(kfd);
 	}
 
 	if (ufd >= 0) {
-		if (unamelist)
-			strlist__delete(unamelist);
-
+		strlist__delete(unamelist);
 		close(ufd);
 	}
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 93d355d..2600916 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -288,7 +288,8 @@ struct branch_info *machine__resolve_bstack(struct machine *self,
 	return bi;
 }
 
-int machine__resolve_callchain(struct machine *self, struct perf_evsel *evsel,
+int machine__resolve_callchain(struct machine *self,
+			       struct perf_evsel *evsel __used,
 			       struct thread *thread,
 			       struct ip_callchain *chain,
 			       struct symbol **parent)
@@ -297,7 +298,12 @@ int machine__resolve_callchain(struct machine *self, struct perf_evsel *evsel,
 	unsigned int i;
 	int err;
 
-	callchain_cursor_reset(&evsel->hists.callchain_cursor);
+	callchain_cursor_reset(&callchain_cursor);
+
+	if (chain->nr > PERF_MAX_STACK_DEPTH) {
+		pr_warning("corrupted callchain. skipping...\n");
+		return 0;
+	}
 
 	for (i = 0; i < chain->nr; i++) {
 		u64 ip;
@@ -317,7 +323,14 @@ int machine__resolve_callchain(struct machine *self, struct perf_evsel *evsel,
 			case PERF_CONTEXT_USER:
 				cpumode = PERF_RECORD_MISC_USER;	break;
 			default:
-				break;
+				pr_debug("invalid callchain context: "
+					 "%"PRId64"\n", (s64) ip);
+				/*
+				 * It seems the callchain is corrupted.
+				 * Discard all.
+				 */
+				callchain_cursor_reset(&callchain_cursor);
+				return 0;
 			}
 			continue;
 		}
@@ -333,7 +346,7 @@ int machine__resolve_callchain(struct machine *self, struct perf_evsel *evsel,
 				break;
 		}
 
-		err = callchain_cursor_append(&evsel->hists.callchain_cursor,
+		err = callchain_cursor_append(&callchain_cursor,
 					      ip, al.map, al.sym);
 		if (err)
 			return err;
@@ -441,37 +454,65 @@ void mem_bswap_64(void *src, int byte_size)
 	}
 }
 
-static void perf_event__all64_swap(union perf_event *event)
+static void swap_sample_id_all(union perf_event *event, void *data)
+{
+	void *end = (void *) event + event->header.size;
+	int size = end - data;
+
+	BUG_ON(size % sizeof(u64));
+	mem_bswap_64(data, size);
+}
+
+static void perf_event__all64_swap(union perf_event *event,
+				   bool sample_id_all __used)
 {
 	struct perf_event_header *hdr = &event->header;
 	mem_bswap_64(hdr + 1, event->header.size - sizeof(*hdr));
 }
 
-static void perf_event__comm_swap(union perf_event *event)
+static void perf_event__comm_swap(union perf_event *event, bool sample_id_all)
 {
 	event->comm.pid = bswap_32(event->comm.pid);
 	event->comm.tid = bswap_32(event->comm.tid);
+
+	if (sample_id_all) {
+		void *data = &event->comm.comm;
+
+		data += ALIGN(strlen(data) + 1, sizeof(u64));
+		swap_sample_id_all(event, data);
+	}
 }
 
-static void perf_event__mmap_swap(union perf_event *event)
+static void perf_event__mmap_swap(union perf_event *event,
+				  bool sample_id_all)
 {
 	event->mmap.pid	  = bswap_32(event->mmap.pid);
 	event->mmap.tid	  = bswap_32(event->mmap.tid);
 	event->mmap.start = bswap_64(event->mmap.start);
 	event->mmap.len	  = bswap_64(event->mmap.len);
 	event->mmap.pgoff = bswap_64(event->mmap.pgoff);
+
+	if (sample_id_all) {
+		void *data = &event->mmap.filename;
+
+		data += ALIGN(strlen(data) + 1, sizeof(u64));
+		swap_sample_id_all(event, data);
+	}
 }
 
-static void perf_event__task_swap(union perf_event *event)
+static void perf_event__task_swap(union perf_event *event, bool sample_id_all)
 {
 	event->fork.pid	 = bswap_32(event->fork.pid);
 	event->fork.tid	 = bswap_32(event->fork.tid);
 	event->fork.ppid = bswap_32(event->fork.ppid);
 	event->fork.ptid = bswap_32(event->fork.ptid);
 	event->fork.time = bswap_64(event->fork.time);
+
+	if (sample_id_all)
+		swap_sample_id_all(event, &event->fork + 1);
 }
 
-static void perf_event__read_swap(union perf_event *event)
+static void perf_event__read_swap(union perf_event *event, bool sample_id_all)
 {
 	event->read.pid		 = bswap_32(event->read.pid);
 	event->read.tid		 = bswap_32(event->read.tid);
@@ -479,6 +520,9 @@ static void perf_event__read_swap(union perf_event *event)
 	event->read.time_enabled = bswap_64(event->read.time_enabled);
 	event->read.time_running = bswap_64(event->read.time_running);
 	event->read.id		 = bswap_64(event->read.id);
+
+	if (sample_id_all)
+		swap_sample_id_all(event, &event->read + 1);
 }
 
 static u8 revbyte(u8 b)
@@ -530,7 +574,8 @@ void perf_event__attr_swap(struct perf_event_attr *attr)
 	swap_bitfield((u8 *) (&attr->read_format + 1), sizeof(u64));
 }
 
-static void perf_event__hdr_attr_swap(union perf_event *event)
+static void perf_event__hdr_attr_swap(union perf_event *event,
+				      bool sample_id_all __used)
 {
 	size_t size;
 
@@ -541,18 +586,21 @@ static void perf_event__hdr_attr_swap(union perf_event *event)
 	mem_bswap_64(event->attr.id, size);
 }
 
-static void perf_event__event_type_swap(union perf_event *event)
+static void perf_event__event_type_swap(union perf_event *event,
+					bool sample_id_all __used)
 {
 	event->event_type.event_type.event_id =
 		bswap_64(event->event_type.event_type.event_id);
 }
 
-static void perf_event__tracing_data_swap(union perf_event *event)
+static void perf_event__tracing_data_swap(union perf_event *event,
+					  bool sample_id_all __used)
 {
 	event->tracing_data.size = bswap_32(event->tracing_data.size);
 }
 
-typedef void (*perf_event__swap_op)(union perf_event *event);
+typedef void (*perf_event__swap_op)(union perf_event *event,
+				    bool sample_id_all);
 
 static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_MMAP]		  = perf_event__mmap_swap,
@@ -986,6 +1034,15 @@ static int perf_session__process_user_event(struct perf_session *session, union
 	}
 }
 
+static void event_swap(union perf_event *event, bool sample_id_all)
+{
+	perf_event__swap_op swap;
+
+	swap = perf_event__swap_ops[event->header.type];
+	if (swap)
+		swap(event, sample_id_all);
+}
+
 static int perf_session__process_event(struct perf_session *session,
 				       union perf_event *event,
 				       struct perf_tool *tool,
@@ -994,9 +1051,8 @@ static int perf_session__process_event(struct perf_session *session,
 	struct perf_sample sample;
 	int ret;
 
-	if (session->header.needs_swap &&
-	    perf_event__swap_ops[event->header.type])
-		perf_event__swap_ops[event->header.type](event);
+	if (session->header.needs_swap)
+		event_swap(event, session->sample_id_all);
 
 	if (event->header.type >= PERF_RECORD_HEADER_MAX)
 		return -EINVAL;
@@ -1428,7 +1484,6 @@ void perf_event__print_ip(union perf_event *event, struct perf_sample *sample,
 			  int print_sym, int print_dso, int print_symoffset)
 {
 	struct addr_location al;
-	struct callchain_cursor *cursor = &evsel->hists.callchain_cursor;
 	struct callchain_cursor_node *node;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample,
@@ -1446,10 +1501,10 @@ void perf_event__print_ip(union perf_event *event, struct perf_sample *sample,
 				error("Failed to resolve callchain. Skipping\n");
 			return;
 		}
-		callchain_cursor_commit(cursor);
+		callchain_cursor_commit(&callchain_cursor);
 
 		while (1) {
-			node = callchain_cursor_current(cursor);
+			node = callchain_cursor_current(&callchain_cursor);
 			if (!node)
 				break;
 
@@ -1460,12 +1515,12 @@ void perf_event__print_ip(union perf_event *event, struct perf_sample *sample,
 			}
 			if (print_dso) {
 				printf(" (");
-				map__fprintf_dsoname(al.map, stdout);
+				map__fprintf_dsoname(node->map, stdout);
 				printf(")");
 			}
 			printf("\n");
 
-			callchain_cursor_advance(cursor);
+			callchain_cursor_advance(&callchain_cursor);
 		}
 
 	} else {
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e2ba885..3e2e5ea 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -323,6 +323,7 @@ struct dso *dso__new(const char *name)
 		dso->sorted_by_name = 0;
 		dso->has_build_id = 0;
 		dso->kernel = DSO_TYPE_USER;
+		dso->needs_swap = DSO_SWAP__UNSET;
 		INIT_LIST_HEAD(&dso->node);
 	}
 
@@ -1156,6 +1157,33 @@ static size_t elf_addr_to_index(Elf *elf, GElf_Addr addr)
 	return -1;
 }
 
+static int dso__swap_init(struct dso *dso, unsigned char eidata)
+{
+	static unsigned int const endian = 1;
+
+	dso->needs_swap = DSO_SWAP__NO;
+
+	switch (eidata) {
+	case ELFDATA2LSB:
+		/* We are big endian, DSO is little endian. */
+		if (*(unsigned char const *)&endian != 1)
+			dso->needs_swap = DSO_SWAP__YES;
+		break;
+
+	case ELFDATA2MSB:
+		/* We are little endian, DSO is big endian. */
+		if (*(unsigned char const *)&endian != 0)
+			dso->needs_swap = DSO_SWAP__YES;
+		break;
+
+	default:
+		pr_err("unrecognized DSO data encoding %d\n", eidata);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int dso__load_sym(struct dso *dso, struct map *map, const char *name,
 			 int fd, symbol_filter_t filter, int kmodule,
 			 int want_symtab)
@@ -1187,6 +1215,9 @@ static int dso__load_sym(struct dso *dso, struct map *map, const char *name,
 		goto out_elf_end;
 	}
 
+	if (dso__swap_init(dso, ehdr.e_ident[EI_DATA]))
+		goto out_elf_end;
+
 	/* Always reject images with a mismatched build-id: */
 	if (dso->has_build_id) {
 		u8 build_id[BUILD_ID_SIZE];
@@ -1272,7 +1303,7 @@ static int dso__load_sym(struct dso *dso, struct map *map, const char *name,
 		if (opdsec && sym.st_shndx == opdidx) {
 			u32 offset = sym.st_value - opdshdr.sh_addr;
 			u64 *opd = opddata->d_buf + offset;
-			sym.st_value = *opd;
+			sym.st_value = DSO__SWAP(dso, u64, *opd);
 			sym.st_shndx = elf_addr_to_index(elf, sym.st_value);
 		}
 
@@ -2786,8 +2817,11 @@ int machine__load_vmlinux_path(struct machine *machine, enum map_type type,
 
 struct map *dso__new_map(const char *name)
 {
+	struct map *map = NULL;
 	struct dso *dso = dso__new(name);
-	struct map *map = map__new2(0, dso, MAP__FUNCTION);
+
+	if (dso)
+		map = map__new2(0, dso, MAP__FUNCTION);
 
 	return map;
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 5649d63..af0752b 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -9,6 +9,7 @@
 #include <linux/list.h>
 #include <linux/rbtree.h>
 #include <stdio.h>
+#include <byteswap.h>
 
 #ifdef HAVE_CPLUS_DEMANGLE
 extern char *cplus_demangle(const char *, int);
@@ -160,11 +161,18 @@ enum dso_kernel_type {
 	DSO_TYPE_GUEST_KERNEL
 };
 
+enum dso_swap_type {
+	DSO_SWAP__UNSET,
+	DSO_SWAP__NO,
+	DSO_SWAP__YES,
+};
+
 struct dso {
 	struct list_head node;
 	struct rb_root	 symbols[MAP__NR_TYPES];
 	struct rb_root	 symbol_names[MAP__NR_TYPES];
 	enum dso_kernel_type	kernel;
+	enum dso_swap_type	needs_swap;
 	u8		 adjust_symbols:1;
 	u8		 has_build_id:1;
 	u8		 hit:1;
@@ -182,6 +190,28 @@ struct dso {
 	char		 name[0];
 };
 
+#define DSO__SWAP(dso, type, val)			\
+({							\
+	type ____r = val;				\
+	BUG_ON(dso->needs_swap == DSO_SWAP__UNSET);	\
+	if (dso->needs_swap == DSO_SWAP__YES) {		\
+		switch (sizeof(____r)) {		\
+		case 2:					\
+			____r = bswap_16(val);		\
+			break;				\
+		case 4:					\
+			____r = bswap_32(val);		\
+			break;				\
+		case 8:					\
+			____r = bswap_64(val);		\
+			break;				\
+		default:				\
+			BUG_ON(1);			\
+		}					\
+	}						\
+	____r;						\
+})
+
 struct dso *dso__new(const char *name);
 void dso__delete(struct dso *dso);
 
