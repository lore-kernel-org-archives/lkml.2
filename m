Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab0JEOts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 10:49:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56868 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab0JEOtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 10:49:47 -0400
Date: Tue, 5 Oct 2010 16:49:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20101005144929.GA8517@elte.hu>
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
Cyrill Gorcunov (1):
      perf, x86: Handle in flight NMIs on P4 platform

Frederik Deweerdt (1):
      perf ui hist browser: Fix segfault on 'a' for annotate

Jiri Olsa (1):
      oprofile: Add Support for Intel CPU Family 6 / Model 29

Kusanagi Kouichi (1):
      perf tools: Fix build breakage

Robert Richter (1):
      oprofile, ARM: Release resources on failure

Stephane Eranian (1):
      perf trace scripting: Fix extern struct definitions


 arch/arm/oprofile/common.c              |    7 +++++--
 arch/x86/kernel/cpu/perf_event_p4.c     |    6 +++++-
 arch/x86/oprofile/nmi_int.c             |    1 +
 tools/perf/Makefile                     |    2 +-
 tools/perf/util/trace-event-scripting.c |    4 ++--
 tools/perf/util/ui/browsers/hists.c     |    2 +-
 6 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index 0691176..72e09eb 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -102,6 +102,7 @@ static int op_create_counter(int cpu, int event)
 	if (IS_ERR(pevent)) {
 		ret = PTR_ERR(pevent);
 	} else if (pevent->state != PERF_EVENT_STATE_ACTIVE) {
+		perf_event_release_kernel(pevent);
 		pr_warning("oprofile: failed to enable event %d "
 				"on CPU %d\n", event, cpu);
 		ret = -EBUSY;
@@ -365,6 +366,7 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	ret = init_driverfs();
 	if (ret) {
 		kfree(counter_config);
+		counter_config = NULL;
 		return ret;
 	}
 
@@ -402,7 +404,6 @@ void oprofile_arch_exit(void)
 	struct perf_event *event;
 
 	if (*perf_events) {
-		exit_driverfs();
 		for_each_possible_cpu(cpu) {
 			for (id = 0; id < perf_num_counters; ++id) {
 				event = perf_events[cpu][id];
@@ -413,8 +414,10 @@ void oprofile_arch_exit(void)
 		}
 	}
 
-	if (counter_config)
+	if (counter_config) {
 		kfree(counter_config);
+		exit_driverfs();
+	}
 }
 #else
 int __init oprofile_arch_init(struct oprofile_operations *ops)
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index b560db3..2490151 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -660,8 +660,12 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		int overflow;
 
-		if (!test_bit(idx, cpuc->active_mask))
+		if (!test_bit(idx, cpuc->active_mask)) {
+			/* catch in-flight IRQs */
+			if (__test_and_clear_bit(idx, cpuc->running))
+				handled++;
 			continue;
+		}
 
 		event = cpuc->events[idx];
 		hwc = &event->hw;
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 009b819..f1575c9 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -674,6 +674,7 @@ static int __init ppro_init(char **cpu_type)
 	case 0x0f:
 	case 0x16:
 	case 0x17:
+	case 0x1d:
 		*cpu_type = "i386/core_2";
 		break;
 	case 0x1a:
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4f1fa77..1950e19 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1017,7 +1017,7 @@ builtin-revert.o wt-status.o: wt-status.h
 # we compile into subdirectories. if the target directory is not the source directory, they might not exists. So
 # we depend the various files onto their directories.
 DIRECTORY_DEPS = $(LIB_OBJS) $(BUILTIN_OBJS) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h
-$(DIRECTORY_DEPS): $(sort $(dir $(DIRECTORY_DEPS)))
+$(DIRECTORY_DEPS): | $(sort $(dir $(DIRECTORY_DEPS)))
 # In the second step, we make a rule to actually create these directories
 $(sort $(dir $(DIRECTORY_DEPS))):
 	$(QUIET_MKDIR)$(MKDIR) -p $@ 2>/dev/null
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 7ea983a..f7af2fc 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -97,7 +97,7 @@ void setup_python_scripting(void)
 	register_python_scripting(&python_scripting_unsupported_ops);
 }
 #else
-struct scripting_ops python_scripting_ops;
+extern struct scripting_ops python_scripting_ops;
 
 void setup_python_scripting(void)
 {
@@ -158,7 +158,7 @@ void setup_perl_scripting(void)
 	register_perl_scripting(&perl_scripting_unsupported_ops);
 }
 #else
-struct scripting_ops perl_scripting_ops;
+extern struct scripting_ops perl_scripting_ops;
 
 void setup_perl_scripting(void)
 {
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index dafdf67..6866aa4 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -773,7 +773,7 @@ int hists__browse(struct hists *self, const char *helpline, const char *ev_name)
 
 			switch (key) {
 			case 'a':
-				if (browser->selection->map == NULL &&
+				if (browser->selection->map == NULL ||
 				    browser->selection->map->dso->annotate_warned)
 					continue;
 				goto do_annotate;
