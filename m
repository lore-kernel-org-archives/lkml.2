Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab0HSOz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 10:55:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37080 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab0HSOzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 10:55:24 -0400
Date: Thu, 19 Aug 2010 16:55:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] perf fixes
Message-ID: <20100819145500.GA20577@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
KUMANO Syuhei (1):
      kprobes/x86: Fix the return address of multiple kretprobes

Kusanagi Kouichi (1):
      perf tools: Fix build error on read only source.

Zhang, Yanmin (1):
      perf, x86: Fix Intel-nhm PMU programming errata workaround


 arch/x86/kernel/cpu/perf_event_intel.c |   81 +++++++++++++++++++++++++-------
 arch/x86/kernel/kprobes.c              |   25 +++++++++-
 tools/perf/Makefile                    |   14 ++++--
 tools/perf/feature-tests.mak           |    2 +-
 4 files changed, 96 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 214ac86..d8d86d0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -491,33 +491,78 @@ static void intel_pmu_enable_all(int added)
  *   Intel Errata AAP53  (model 30)
  *   Intel Errata BD53   (model 44)
  *
- * These chips need to be 'reset' when adding counters by programming
- * the magic three (non counting) events 0x4300D2, 0x4300B1 and 0x4300B5
- * either in sequence on the same PMC or on different PMCs.
+ * The official story:
+ *   These chips need to be 'reset' when adding counters by programming the
+ *   magic three (non-counting) events 0x4300B5, 0x4300D2, and 0x4300B1 either
+ *   in sequence on the same PMC or on different PMCs.
+ *
+ * In practise it appears some of these events do in fact count, and
+ * we need to programm all 4 events.
  */
-static void intel_pmu_nhm_enable_all(int added)
+static void intel_pmu_nhm_workaround(void)
 {
-	if (added) {
-		struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-		int i;
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	static const unsigned long nhm_magic[4] = {
+		0x4300B5,
+		0x4300D2,
+		0x4300B1,
+		0x4300B1
+	};
+	struct perf_event *event;
+	int i;
+
+	/*
+	 * The Errata requires below steps:
+	 * 1) Clear MSR_IA32_PEBS_ENABLE and MSR_CORE_PERF_GLOBAL_CTRL;
+	 * 2) Configure 4 PERFEVTSELx with the magic events and clear
+	 *    the corresponding PMCx;
+	 * 3) set bit0~bit3 of MSR_CORE_PERF_GLOBAL_CTRL;
+	 * 4) Clear MSR_CORE_PERF_GLOBAL_CTRL;
+	 * 5) Clear 4 pairs of ERFEVTSELx and PMCx;
+	 */
+
+	/*
+	 * The real steps we choose are a little different from above.
+	 * A) To reduce MSR operations, we don't run step 1) as they
+	 *    are already cleared before this function is called;
+	 * B) Call x86_perf_event_update to save PMCx before configuring
+	 *    PERFEVTSELx with magic number;
+	 * C) With step 5), we do clear only when the PERFEVTSELx is
+	 *    not used currently.
+	 * D) Call x86_perf_event_set_period to restore PMCx;
+	 */
 
-		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 0, 0x4300D2);
-		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 1, 0x4300B1);
-		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 2, 0x4300B5);
+	/* We always operate 4 pairs of PERF Counters */
+	for (i = 0; i < 4; i++) {
+		event = cpuc->events[i];
+		if (event)
+			x86_perf_event_update(event);
+	}
 
-		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x3);
-		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x0);
+	for (i = 0; i < 4; i++) {
+		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, nhm_magic[i]);
+		wrmsrl(MSR_ARCH_PERFMON_PERFCTR0 + i, 0x0);
+	}
 
-		for (i = 0; i < 3; i++) {
-			struct perf_event *event = cpuc->events[i];
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0xf);
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x0);
 
-			if (!event)
-				continue;
+	for (i = 0; i < 4; i++) {
+		event = cpuc->events[i];
 
+		if (event) {
+			x86_perf_event_set_period(event);
 			__x86_pmu_enable_event(&event->hw,
-					       ARCH_PERFMON_EVENTSEL_ENABLE);
-		}
+					ARCH_PERFMON_EVENTSEL_ENABLE);
+		} else
+			wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, 0x0);
 	}
+}
+
+static void intel_pmu_nhm_enable_all(int added)
+{
+	if (added)
+		intel_pmu_nhm_workaround();
 	intel_pmu_enable_all(added);
 }
 
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 1bfb6cf..770ebfb 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -709,6 +709,7 @@ static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
 	struct hlist_node *node, *tmp;
 	unsigned long flags, orig_ret_address = 0;
 	unsigned long trampoline_address = (unsigned long)&kretprobe_trampoline;
+	kprobe_opcode_t *correct_ret_addr = NULL;
 
 	INIT_HLIST_HEAD(&empty_rp);
 	kretprobe_hash_lock(current, &head, &flags);
@@ -740,14 +741,34 @@ static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
 			/* another task is sharing our hash bucket */
 			continue;
 
+		orig_ret_address = (unsigned long)ri->ret_addr;
+
+		if (orig_ret_address != trampoline_address)
+			/*
+			 * This is the real return address. Any other
+			 * instances associated with this task are for
+			 * other calls deeper on the call stack
+			 */
+			break;
+	}
+
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
+
+	correct_ret_addr = ri->ret_addr;
+	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+		if (ri->task != current)
+			/* another task is sharing our hash bucket */
+			continue;
+
+		orig_ret_address = (unsigned long)ri->ret_addr;
 		if (ri->rp && ri->rp->handler) {
 			__get_cpu_var(current_kprobe) = &ri->rp->kp;
 			get_kprobe_ctlblk()->kprobe_status = KPROBE_HIT_ACTIVE;
+			ri->ret_addr = correct_ret_addr;
 			ri->rp->handler(ri, regs);
 			__get_cpu_var(current_kprobe) = NULL;
 		}
 
-		orig_ret_address = (unsigned long)ri->ret_addr;
 		recycle_rp_inst(ri, &empty_rp);
 
 		if (orig_ret_address != trampoline_address)
@@ -759,8 +780,6 @@ static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
 			break;
 	}
 
-	kretprobe_assert(ri, orig_ret_address, trampoline_address);
-
 	kretprobe_hash_unlock(current, &flags);
 
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index dcb9700..4f1fa77 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -5,6 +5,12 @@ endif
 # The default target of this Makefile is...
 all::
 
+ifneq ($(OUTPUT),)
+# check that the output directory actually exists
+OUTDIR := $(shell cd $(OUTPUT) && /bin/pwd)
+$(if $(OUTDIR),, $(error output directory "$(OUTPUT)" does not exist))
+endif
+
 # Define V=1 to have a more verbose compile.
 # Define V=2 to have an even more verbose compile.
 #
@@ -931,15 +937,15 @@ $(OUTPUT)common-cmds.h: $(wildcard Documentation/perf-*.txt)
 	$(QUIET_GEN). util/generate-cmdlist.sh > $@+ && mv $@+ $@
 
 $(patsubst %.sh,%,$(SCRIPT_SH)) : % : %.sh
-	$(QUIET_GEN)$(RM) $@ $@+ && \
+	$(QUIET_GEN)$(RM) $(OUTPUT)$@ $(OUTPUT)$@+ && \
 	sed -e '1s|#!.*/sh|#!$(SHELL_PATH_SQ)|' \
 	    -e 's|@SHELL_PATH@|$(SHELL_PATH_SQ)|' \
 	    -e 's|@@PERL@@|$(PERL_PATH_SQ)|g' \
 	    -e 's/@@PERF_VERSION@@/$(PERF_VERSION)/g' \
 	    -e 's/@@NO_CURL@@/$(NO_CURL)/g' \
-	    $@.sh >$@+ && \
-	chmod +x $@+ && \
-	mv $@+ $(OUTPUT)$@
+	    $@.sh > $(OUTPUT)$@+ && \
+	chmod +x $(OUTPUT)$@+ && \
+	mv $(OUTPUT)$@+ $(OUTPUT)$@
 
 configure: configure.ac
 	$(QUIET_GEN)$(RM) $@ $<+ && \
diff --git a/tools/perf/feature-tests.mak b/tools/perf/feature-tests.mak
index ddb68e6..7a7b608 100644
--- a/tools/perf/feature-tests.mak
+++ b/tools/perf/feature-tests.mak
@@ -113,7 +113,7 @@ endef
 # try-cc
 # Usage: option = $(call try-cc, source-to-build, cc-options)
 try-cc = $(shell sh -c						  \
-	'TMP="$(TMPOUT).$$$$";			 		  \
+	'TMP="$(OUTPUT)$(TMPOUT).$$$$";				  \
 	 echo "$(1)" |						  \
 	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
 	 rm -f "$$TMP"')
