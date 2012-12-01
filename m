Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab2LALLP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 06:11:15 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43492 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2LALLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 06:11:11 -0500
Date: Sat, 1 Dec 2012 12:11:03 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20121201111103.GA18503@gmail.com>
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

   HEAD: fd6da696f38b00ffeae1185d6f0ec5d4ab3b472d Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent

This is mostly about unbreaking architectures that took the UAPI 
changes in the v3.7 cycle, plus misc fixes.

 Thanks,

	Ingo

------------------>
David Howells (5):
      x86: Export asm/{svm.h,vmx.h,perf_regs.h}
      tools: Define a Makefile function to do subdir processing
      tools: Honour the O= flag when tool build called from a higher Makefile
      tools: Pass the target in descend
      perf: Make perf build for x86 with UAPI disintegration applied

Michael Neuling (1):
      perf, powerpc: Fix hw breakpoints returning -ENOSPC

Namhyung Kim (2):
      perf header: Fix numa topology printing
      perf tools: Fix strbuf_addf() when the buffer needs to grow

Sukadev Bhattiprolu (1):
      perf powerpc: Use uapi/unistd.h to fix build error

Xiao Guangrong (2):
      perf kvm: Rename perf_kvm to perf_kvm_stat
      perf kvm: Fix building perf kvm on non x86 arches


 Makefile                                |   6 +-
 arch/x86/include/asm/Kbuild             |   3 +
 include/linux/hw_breakpoint.h           |  31 +-------
 include/uapi/linux/Kbuild               |   1 +
 include/uapi/linux/hw_breakpoint.h      |  30 ++++++++
 kernel/events/hw_breakpoint.c           |  12 ++--
 tools/Makefile                          |  24 +++----
 tools/perf/Makefile                     |  29 +++++++-
 tools/perf/arch/x86/include/perf_regs.h |   2 +-
 tools/perf/builtin-kvm.c                | 121 ++++++++++++++++++--------------
 tools/perf/builtin-test.c               |   2 +-
 tools/perf/perf.h                       |  16 +----
 tools/perf/util/evsel.c                 |   4 +-
 tools/perf/util/evsel.h                 |   3 +-
 tools/perf/util/header.c                |   2 +
 tools/perf/util/header.h                |   2 +-
 tools/perf/util/parse-events-test.c     |   2 +-
 tools/perf/util/parse-events.c          |   2 +-
 tools/perf/util/parse-events.h          |   2 +-
 tools/perf/util/pmu.h                   |   2 +-
 tools/perf/util/session.h               |   2 +-
 tools/perf/util/strbuf.c                |   8 +--
 tools/scripts/Makefile.include          |  23 +++++-
 23 files changed, 194 insertions(+), 135 deletions(-)
 create mode 100644 include/uapi/linux/hw_breakpoint.h

diff --git a/Makefile b/Makefile
index 42d0e56..71dc31e 100644
--- a/Makefile
+++ b/Makefile
@@ -1321,10 +1321,12 @@ kernelversion:
 
 # Clear a bunch of variables before executing the submake
 tools/: FORCE
-	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= -C $(src)/tools/
+	$(Q)mkdir -p $(objtree)/tools
+	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= O=$(objtree) subdir=tools -C $(src)/tools/
 
 tools/%: FORCE
-	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= -C $(src)/tools/ $*
+	$(Q)mkdir -p $(objtree)/tools
+	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= O=$(objtree) subdir=tools -C $(src)/tools/ $*
 
 # Single targets
 # ---------------------------------------------------------------------------
diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index 66e5f0e..79fd8a3 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -12,6 +12,7 @@ header-y += mce.h
 header-y += msr-index.h
 header-y += msr.h
 header-y += mtrr.h
+header-y += perf_regs.h
 header-y += posix_types_32.h
 header-y += posix_types_64.h
 header-y += posix_types_x32.h
@@ -19,8 +20,10 @@ header-y += prctl.h
 header-y += processor-flags.h
 header-y += ptrace-abi.h
 header-y += sigcontext32.h
+header-y += svm.h
 header-y += ucontext.h
 header-y += vm86.h
+header-y += vmx.h
 header-y += vsyscall.h
 
 genhdr-y += unistd_32.h
diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 6ae9c63..0464c85 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -1,35 +1,8 @@
 #ifndef _LINUX_HW_BREAKPOINT_H
 #define _LINUX_HW_BREAKPOINT_H
 
-enum {
-	HW_BREAKPOINT_LEN_1 = 1,
-	HW_BREAKPOINT_LEN_2 = 2,
-	HW_BREAKPOINT_LEN_4 = 4,
-	HW_BREAKPOINT_LEN_8 = 8,
-};
-
-enum {
-	HW_BREAKPOINT_EMPTY	= 0,
-	HW_BREAKPOINT_R		= 1,
-	HW_BREAKPOINT_W		= 2,
-	HW_BREAKPOINT_RW	= HW_BREAKPOINT_R | HW_BREAKPOINT_W,
-	HW_BREAKPOINT_X		= 4,
-	HW_BREAKPOINT_INVALID   = HW_BREAKPOINT_RW | HW_BREAKPOINT_X,
-};
-
-enum bp_type_idx {
-	TYPE_INST 	= 0,
-#ifdef CONFIG_HAVE_MIXED_BREAKPOINTS_REGS
-	TYPE_DATA	= 0,
-#else
-	TYPE_DATA	= 1,
-#endif
-	TYPE_MAX
-};
-
-#ifdef __KERNEL__
-
 #include <linux/perf_event.h>
+#include <uapi/linux/hw_breakpoint.h>
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 
@@ -151,6 +124,4 @@ static inline struct arch_hw_breakpoint *counter_arch_bp(struct perf_event *bp)
 }
 
 #endif /* CONFIG_HAVE_HW_BREAKPOINT */
-#endif /* __KERNEL__ */
-
 #endif /* _LINUX_HW_BREAKPOINT_H */
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index e194387..19e765f 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -415,3 +415,4 @@ header-y += wireless.h
 header-y += x25.h
 header-y += xattr.h
 header-y += xfrm.h
+header-y += hw_breakpoint.h
diff --git a/include/uapi/linux/hw_breakpoint.h b/include/uapi/linux/hw_breakpoint.h
new file mode 100644
index 0000000..b04000a
--- /dev/null
+++ b/include/uapi/linux/hw_breakpoint.h
@@ -0,0 +1,30 @@
+#ifndef _UAPI_LINUX_HW_BREAKPOINT_H
+#define _UAPI_LINUX_HW_BREAKPOINT_H
+
+enum {
+	HW_BREAKPOINT_LEN_1 = 1,
+	HW_BREAKPOINT_LEN_2 = 2,
+	HW_BREAKPOINT_LEN_4 = 4,
+	HW_BREAKPOINT_LEN_8 = 8,
+};
+
+enum {
+	HW_BREAKPOINT_EMPTY	= 0,
+	HW_BREAKPOINT_R		= 1,
+	HW_BREAKPOINT_W		= 2,
+	HW_BREAKPOINT_RW	= HW_BREAKPOINT_R | HW_BREAKPOINT_W,
+	HW_BREAKPOINT_X		= 4,
+	HW_BREAKPOINT_INVALID   = HW_BREAKPOINT_RW | HW_BREAKPOINT_X,
+};
+
+enum bp_type_idx {
+	TYPE_INST 	= 0,
+#ifdef CONFIG_HAVE_MIXED_BREAKPOINTS_REGS
+	TYPE_DATA	= 0,
+#else
+	TYPE_DATA	= 1,
+#endif
+	TYPE_MAX
+};
+
+#endif /* _UAPI_LINUX_HW_BREAKPOINT_H */
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 9a7b487..fe8a916 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -111,14 +111,16 @@ static unsigned int max_task_bp_pinned(int cpu, enum bp_type_idx type)
  * Count the number of breakpoints of the same type and same task.
  * The given event must be not on the list.
  */
-static int task_bp_pinned(struct perf_event *bp, enum bp_type_idx type)
+static int task_bp_pinned(int cpu, struct perf_event *bp, enum bp_type_idx type)
 {
 	struct task_struct *tsk = bp->hw.bp_target;
 	struct perf_event *iter;
 	int count = 0;
 
 	list_for_each_entry(iter, &bp_task_head, hw.bp_list) {
-		if (iter->hw.bp_target == tsk && find_slot_idx(iter) == type)
+		if (iter->hw.bp_target == tsk &&
+		    find_slot_idx(iter) == type &&
+		    cpu == iter->cpu)
 			count += hw_breakpoint_weight(iter);
 	}
 
@@ -141,7 +143,7 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 		if (!tsk)
 			slots->pinned += max_task_bp_pinned(cpu, type);
 		else
-			slots->pinned += task_bp_pinned(bp, type);
+			slots->pinned += task_bp_pinned(cpu, bp, type);
 		slots->flexible = per_cpu(nr_bp_flexible[type], cpu);
 
 		return;
@@ -154,7 +156,7 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 		if (!tsk)
 			nr += max_task_bp_pinned(cpu, type);
 		else
-			nr += task_bp_pinned(bp, type);
+			nr += task_bp_pinned(cpu, bp, type);
 
 		if (nr > slots->pinned)
 			slots->pinned = nr;
@@ -188,7 +190,7 @@ static void toggle_bp_task_slot(struct perf_event *bp, int cpu, bool enable,
 	int old_idx = 0;
 	int idx = 0;
 
-	old_count = task_bp_pinned(bp, type);
+	old_count = task_bp_pinned(cpu, bp, type);
 	old_idx = old_count - 1;
 	idx = old_idx + weight;
 
diff --git a/tools/Makefile b/tools/Makefile
index 3ae4394..1f9a529 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -31,44 +31,44 @@ help:
 	@echo '  clean: a summary clean target to clean _all_ folders'
 
 cpupower: FORCE
-	$(QUIET_SUBDIR0)power/$@/ $(QUIET_SUBDIR1)
+	$(call descend,power/$@)
 
 firewire lguest perf usb virtio vm: FORCE
-	$(QUIET_SUBDIR0)$@/ $(QUIET_SUBDIR1)
+	$(call descend,$@)
 
 selftests: FORCE
-	$(QUIET_SUBDIR0)testing/$@/ $(QUIET_SUBDIR1)
+	$(call descend,testing/$@)
 
 turbostat x86_energy_perf_policy: FORCE
-	$(QUIET_SUBDIR0)power/x86/$@/ $(QUIET_SUBDIR1)
+	$(call descend,power/x86/$@)
 
 cpupower_install:
-	$(QUIET_SUBDIR0)power/$(@:_install=)/ $(QUIET_SUBDIR1) install
+	$(call descend,power/$(@:_install=),install)
 
 firewire_install lguest_install perf_install usb_install virtio_install vm_install:
-	$(QUIET_SUBDIR0)$(@:_install=)/ $(QUIET_SUBDIR1) install
+	$(call descend,$(@:_install=),install)
 
 selftests_install:
-	$(QUIET_SUBDIR0)testing/$(@:_clean=)/ $(QUIET_SUBDIR1) install
+	$(call descend,testing/$(@:_clean=),install)
 
 turbostat_install x86_energy_perf_policy_install:
-	$(QUIET_SUBDIR0)power/x86/$(@:_install=)/ $(QUIET_SUBDIR1) install
+	$(call descend,power/x86/$(@:_install=),install)
 
 install: cpupower_install firewire_install lguest_install perf_install \
 		selftests_install turbostat_install usb_install virtio_install \
 		vm_install x86_energy_perf_policy_install
 
 cpupower_clean:
-	$(QUIET_SUBDIR0)power/cpupower/ $(QUIET_SUBDIR1) clean
+	$(call descend,power/cpupower,clean)
 
 firewire_clean lguest_clean perf_clean usb_clean virtio_clean vm_clean:
-	$(QUIET_SUBDIR0)$(@:_clean=)/ $(QUIET_SUBDIR1) clean
+	$(call descend,$(@:_clean=),clean)
 
 selftests_clean:
-	$(QUIET_SUBDIR0)testing/$(@:_clean=)/ $(QUIET_SUBDIR1) clean
+	$(call descend,testing/$(@:_clean=),clean)
 
 turbostat_clean x86_energy_perf_policy_clean:
-	$(QUIET_SUBDIR0)power/x86/$(@:_clean=)/ $(QUIET_SUBDIR1) clean
+	$(call descend,power/x86/$(@:_clean=),clean)
 
 clean: cpupower_clean firewire_clean lguest_clean perf_clean selftests_clean \
 		turbostat_clean usb_clean virtio_clean vm_clean \
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 00deed4d..0a619af 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -169,7 +169,34 @@ endif
 
 ### --- END CONFIGURATION SECTION ---
 
-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
+ifeq ($(srctree),)
+srctree := $(patsubst %/,%,$(dir $(shell pwd)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+#$(info Determined 'srctree' to be $(srctree))
+endif
+
+ifneq ($(objtree),)
+#$(info Determined 'objtree' to be $(objtree))
+endif
+
+ifneq ($(OUTPUT),)
+#$(info Determined 'OUTPUT' to be $(OUTPUT))
+endif
+
+BASIC_CFLAGS = \
+	-Iutil/include \
+	-Iarch/$(ARCH)/include \
+	$(if $(objtree),-I$(objtree)/arch/$(ARCH)/include/generated/uapi) \
+	-I$(srctree)/arch/$(ARCH)/include/uapi \
+	-I$(srctree)/arch/$(ARCH)/include \
+	$(if $(objtree),-I$(objtree)/include/generated/uapi) \
+	-I$(srctree)/include/uapi \
+	-I$(srctree)/include \
+	-I$(OUTPUT)util \
+	-Iutil \
+	-I. \
+	-I$(TRACE_EVENT_DIR) \
+	-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 BASIC_LDFLAGS =
 
 # Guard against environment variables
diff --git a/tools/perf/arch/x86/include/perf_regs.h b/tools/perf/arch/x86/include/perf_regs.h
index 46fc9f1..7fcdcdb 100644
--- a/tools/perf/arch/x86/include/perf_regs.h
+++ b/tools/perf/arch/x86/include/perf_regs.h
@@ -3,7 +3,7 @@
 
 #include <stdlib.h>
 #include "../../util/types.h"
-#include "../../../../../arch/x86/include/asm/perf_regs.h"
+#include <asm/perf_regs.h>
 
 #ifndef ARCH_X86_64
 #define PERF_REGS_MASK ((1ULL << PERF_REG_X86_32_MAX) - 1)
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 260abc5..283b439 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -22,9 +22,10 @@
 #include <pthread.h>
 #include <math.h>
 
-#include "../../arch/x86/include/asm/svm.h"
-#include "../../arch/x86/include/asm/vmx.h"
-#include "../../arch/x86/include/asm/kvm.h"
+#if defined(__i386__) || defined(__x86_64__)
+#include <asm/svm.h>
+#include <asm/vmx.h>
+#include <asm/kvm.h>
 
 struct event_key {
 	#define INVALID_KEY     (~0ULL)
@@ -58,7 +59,7 @@ struct kvm_event_key {
 };
 
 
-struct perf_kvm;
+struct perf_kvm_stat;
 
 struct kvm_events_ops {
 	bool (*is_begin_event)(struct perf_evsel *evsel,
@@ -66,7 +67,7 @@ struct kvm_events_ops {
 			       struct event_key *key);
 	bool (*is_end_event)(struct perf_evsel *evsel,
 			     struct perf_sample *sample, struct event_key *key);
-	void (*decode_key)(struct perf_kvm *kvm, struct event_key *key,
+	void (*decode_key)(struct perf_kvm_stat *kvm, struct event_key *key,
 			   char decode[20]);
 	const char *name;
 };
@@ -79,7 +80,7 @@ struct exit_reasons_table {
 #define EVENTS_BITS		12
 #define EVENTS_CACHE_SIZE	(1UL << EVENTS_BITS)
 
-struct perf_kvm {
+struct perf_kvm_stat {
 	struct perf_tool    tool;
 	struct perf_session *session;
 
@@ -146,7 +147,7 @@ static struct exit_reasons_table svm_exit_reasons[] = {
 	SVM_EXIT_REASONS
 };
 
-static const char *get_exit_reason(struct perf_kvm *kvm, u64 exit_code)
+static const char *get_exit_reason(struct perf_kvm_stat *kvm, u64 exit_code)
 {
 	int i = kvm->exit_reasons_size;
 	struct exit_reasons_table *tbl = kvm->exit_reasons;
@@ -162,7 +163,7 @@ static const char *get_exit_reason(struct perf_kvm *kvm, u64 exit_code)
 	return "UNKNOWN";
 }
 
-static void exit_event_decode_key(struct perf_kvm *kvm,
+static void exit_event_decode_key(struct perf_kvm_stat *kvm,
 				  struct event_key *key,
 				  char decode[20])
 {
@@ -228,7 +229,7 @@ static bool mmio_event_end(struct perf_evsel *evsel, struct perf_sample *sample,
 	return false;
 }
 
-static void mmio_event_decode_key(struct perf_kvm *kvm __maybe_unused,
+static void mmio_event_decode_key(struct perf_kvm_stat *kvm __maybe_unused,
 				  struct event_key *key,
 				  char decode[20])
 {
@@ -271,7 +272,7 @@ static bool ioport_event_end(struct perf_evsel *evsel,
 	return kvm_entry_event(evsel);
 }
 
-static void ioport_event_decode_key(struct perf_kvm *kvm __maybe_unused,
+static void ioport_event_decode_key(struct perf_kvm_stat *kvm __maybe_unused,
 				    struct event_key *key,
 				    char decode[20])
 {
@@ -286,7 +287,7 @@ static struct kvm_events_ops ioport_events = {
 	.name = "IO Port Access"
 };
 
-static bool register_kvm_events_ops(struct perf_kvm *kvm)
+static bool register_kvm_events_ops(struct perf_kvm_stat *kvm)
 {
 	bool ret = true;
 
@@ -311,7 +312,7 @@ struct vcpu_event_record {
 };
 
 
-static void init_kvm_event_record(struct perf_kvm *kvm)
+static void init_kvm_event_record(struct perf_kvm_stat *kvm)
 {
 	int i;
 
@@ -360,7 +361,7 @@ static struct kvm_event *kvm_alloc_init_event(struct event_key *key)
 	return event;
 }
 
-static struct kvm_event *find_create_kvm_event(struct perf_kvm *kvm,
+static struct kvm_event *find_create_kvm_event(struct perf_kvm_stat *kvm,
 					       struct event_key *key)
 {
 	struct kvm_event *event;
@@ -381,7 +382,7 @@ static struct kvm_event *find_create_kvm_event(struct perf_kvm *kvm,
 	return event;
 }
 
-static bool handle_begin_event(struct perf_kvm *kvm,
+static bool handle_begin_event(struct perf_kvm_stat *kvm,
 			       struct vcpu_event_record *vcpu_record,
 			       struct event_key *key, u64 timestamp)
 {
@@ -425,7 +426,7 @@ static bool update_kvm_event(struct kvm_event *event, int vcpu_id,
 	return true;
 }
 
-static bool handle_end_event(struct perf_kvm *kvm,
+static bool handle_end_event(struct perf_kvm_stat *kvm,
 			     struct vcpu_event_record *vcpu_record,
 			     struct event_key *key,
 			     u64 timestamp)
@@ -486,7 +487,7 @@ struct vcpu_event_record *per_vcpu_record(struct thread *thread,
 	return thread->priv;
 }
 
-static bool handle_kvm_event(struct perf_kvm *kvm,
+static bool handle_kvm_event(struct perf_kvm_stat *kvm,
 			     struct thread *thread,
 			     struct perf_evsel *evsel,
 			     struct perf_sample *sample)
@@ -541,7 +542,7 @@ static struct kvm_event_key keys[] = {
 	{ NULL, NULL }
 };
 
-static bool select_key(struct perf_kvm *kvm)
+static bool select_key(struct perf_kvm_stat *kvm)
 {
 	int i;
 
@@ -577,7 +578,8 @@ static void insert_to_result(struct rb_root *result, struct kvm_event *event,
 	rb_insert_color(&event->rb, result);
 }
 
-static void update_total_count(struct perf_kvm *kvm, struct kvm_event *event)
+static void
+update_total_count(struct perf_kvm_stat *kvm, struct kvm_event *event)
 {
 	int vcpu = kvm->trace_vcpu;
 
@@ -590,7 +592,7 @@ static bool event_is_valid(struct kvm_event *event, int vcpu)
 	return !!get_event_count(event, vcpu);
 }
 
-static void sort_result(struct perf_kvm *kvm)
+static void sort_result(struct perf_kvm_stat *kvm)
 {
 	unsigned int i;
 	int vcpu = kvm->trace_vcpu;
@@ -627,7 +629,7 @@ static void print_vcpu_info(int vcpu)
 		pr_info("VCPU %d:\n\n", vcpu);
 }
 
-static void print_result(struct perf_kvm *kvm)
+static void print_result(struct perf_kvm_stat *kvm)
 {
 	char decode[20];
 	struct kvm_event *event;
@@ -670,7 +672,8 @@ static int process_sample_event(struct perf_tool *tool,
 				struct machine *machine)
 {
 	struct thread *thread = machine__findnew_thread(machine, sample->tid);
-	struct perf_kvm *kvm = container_of(tool, struct perf_kvm, tool);
+	struct perf_kvm_stat *kvm = container_of(tool, struct perf_kvm_stat,
+						 tool);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
@@ -701,7 +704,7 @@ static int get_cpu_isa(struct perf_session *session)
 	return isa;
 }
 
-static int read_events(struct perf_kvm *kvm)
+static int read_events(struct perf_kvm_stat *kvm)
 {
 	int ret;
 
@@ -750,7 +753,7 @@ static bool verify_vcpu(int vcpu)
 	return true;
 }
 
-static int kvm_events_report_vcpu(struct perf_kvm *kvm)
+static int kvm_events_report_vcpu(struct perf_kvm_stat *kvm)
 {
 	int ret = -EINVAL;
 	int vcpu = kvm->trace_vcpu;
@@ -798,7 +801,8 @@ static const char * const record_args[] = {
 		_p;			\
 	})
 
-static int kvm_events_record(struct perf_kvm *kvm, int argc, const char **argv)
+static int
+kvm_events_record(struct perf_kvm_stat *kvm, int argc, const char **argv)
 {
 	unsigned int rec_argc, i, j;
 	const char **rec_argv;
@@ -821,7 +825,8 @@ static int kvm_events_record(struct perf_kvm *kvm, int argc, const char **argv)
 	return cmd_record(i, rec_argv, NULL);
 }
 
-static int kvm_events_report(struct perf_kvm *kvm, int argc, const char **argv)
+static int
+kvm_events_report(struct perf_kvm_stat *kvm, int argc, const char **argv)
 {
 	const struct option kvm_events_report_options[] = {
 		OPT_STRING(0, "event", &kvm->report_event, "report event",
@@ -864,24 +869,37 @@ static void print_kvm_stat_usage(void)
 	printf("\nOtherwise, it is the alias of 'perf stat':\n");
 }
 
-static int kvm_cmd_stat(struct perf_kvm *kvm, int argc, const char **argv)
+static int kvm_cmd_stat(const char *file_name, int argc, const char **argv)
 {
+	struct perf_kvm_stat kvm = {
+		.file_name = file_name,
+
+		.trace_vcpu	= -1,
+		.report_event	= "vmexit",
+		.sort_key	= "sample",
+
+		.exit_reasons = svm_exit_reasons,
+		.exit_reasons_size = ARRAY_SIZE(svm_exit_reasons),
+		.exit_reasons_isa = "SVM",
+	};
+
 	if (argc == 1) {
 		print_kvm_stat_usage();
 		goto perf_stat;
 	}
 
 	if (!strncmp(argv[1], "rec", 3))
-		return kvm_events_record(kvm, argc - 1, argv + 1);
+		return kvm_events_record(&kvm, argc - 1, argv + 1);
 
 	if (!strncmp(argv[1], "rep", 3))
-		return kvm_events_report(kvm, argc - 1 , argv + 1);
+		return kvm_events_report(&kvm, argc - 1 , argv + 1);
 
 perf_stat:
 	return cmd_stat(argc, argv, NULL);
 }
+#endif
 
-static int __cmd_record(struct perf_kvm *kvm, int argc, const char **argv)
+static int __cmd_record(const char *file_name, int argc, const char **argv)
 {
 	int rec_argc, i = 0, j;
 	const char **rec_argv;
@@ -890,7 +908,7 @@ static int __cmd_record(struct perf_kvm *kvm, int argc, const char **argv)
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 	rec_argv[i++] = strdup("record");
 	rec_argv[i++] = strdup("-o");
-	rec_argv[i++] = strdup(kvm->file_name);
+	rec_argv[i++] = strdup(file_name);
 	for (j = 1; j < argc; j++, i++)
 		rec_argv[i] = argv[j];
 
@@ -899,7 +917,7 @@ static int __cmd_record(struct perf_kvm *kvm, int argc, const char **argv)
 	return cmd_record(i, rec_argv, NULL);
 }
 
-static int __cmd_report(struct perf_kvm *kvm, int argc, const char **argv)
+static int __cmd_report(const char *file_name, int argc, const char **argv)
 {
 	int rec_argc, i = 0, j;
 	const char **rec_argv;
@@ -908,7 +926,7 @@ static int __cmd_report(struct perf_kvm *kvm, int argc, const char **argv)
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 	rec_argv[i++] = strdup("report");
 	rec_argv[i++] = strdup("-i");
-	rec_argv[i++] = strdup(kvm->file_name);
+	rec_argv[i++] = strdup(file_name);
 	for (j = 1; j < argc; j++, i++)
 		rec_argv[i] = argv[j];
 
@@ -917,7 +935,8 @@ static int __cmd_report(struct perf_kvm *kvm, int argc, const char **argv)
 	return cmd_report(i, rec_argv, NULL);
 }
 
-static int __cmd_buildid_list(struct perf_kvm *kvm, int argc, const char **argv)
+static int
+__cmd_buildid_list(const char *file_name, int argc, const char **argv)
 {
 	int rec_argc, i = 0, j;
 	const char **rec_argv;
@@ -926,7 +945,7 @@ static int __cmd_buildid_list(struct perf_kvm *kvm, int argc, const char **argv)
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 	rec_argv[i++] = strdup("buildid-list");
 	rec_argv[i++] = strdup("-i");
-	rec_argv[i++] = strdup(kvm->file_name);
+	rec_argv[i++] = strdup(file_name);
 	for (j = 1; j < argc; j++, i++)
 		rec_argv[i] = argv[j];
 
@@ -937,20 +956,12 @@ static int __cmd_buildid_list(struct perf_kvm *kvm, int argc, const char **argv)
 
 int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 {
-	struct perf_kvm kvm = {
-		.trace_vcpu	= -1,
-		.report_event	= "vmexit",
-		.sort_key	= "sample",
-
-		.exit_reasons = svm_exit_reasons,
-		.exit_reasons_size = ARRAY_SIZE(svm_exit_reasons),
-		.exit_reasons_isa = "SVM",
-	};
+	const char *file_name;
 
 	const struct option kvm_options[] = {
-		OPT_STRING('i', "input", &kvm.file_name, "file",
+		OPT_STRING('i', "input", &file_name, "file",
 			   "Input file name"),
-		OPT_STRING('o', "output", &kvm.file_name, "file",
+		OPT_STRING('o', "output", &file_name, "file",
 			   "Output file name"),
 		OPT_BOOLEAN(0, "guest", &perf_guest,
 			    "Collect guest os data"),
@@ -985,32 +996,34 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!perf_host)
 		perf_guest = 1;
 
-	if (!kvm.file_name) {
+	if (!file_name) {
 		if (perf_host && !perf_guest)
-			kvm.file_name = strdup("perf.data.host");
+			file_name = strdup("perf.data.host");
 		else if (!perf_host && perf_guest)
-			kvm.file_name = strdup("perf.data.guest");
+			file_name = strdup("perf.data.guest");
 		else
-			kvm.file_name = strdup("perf.data.kvm");
+			file_name = strdup("perf.data.kvm");
 
-		if (!kvm.file_name) {
+		if (!file_name) {
 			pr_err("Failed to allocate memory for filename\n");
 			return -ENOMEM;
 		}
 	}
 
 	if (!strncmp(argv[0], "rec", 3))
-		return __cmd_record(&kvm, argc, argv);
+		return __cmd_record(file_name, argc, argv);
 	else if (!strncmp(argv[0], "rep", 3))
-		return __cmd_report(&kvm, argc, argv);
+		return __cmd_report(file_name, argc, argv);
 	else if (!strncmp(argv[0], "diff", 4))
 		return cmd_diff(argc, argv, NULL);
 	else if (!strncmp(argv[0], "top", 3))
 		return cmd_top(argc, argv, NULL);
 	else if (!strncmp(argv[0], "buildid-list", 12))
-		return __cmd_buildid_list(&kvm, argc, argv);
+		return __cmd_buildid_list(file_name, argc, argv);
+#if defined(__i386__) || defined(__x86_64__)
 	else if (!strncmp(argv[0], "stat", 4))
-		return kvm_cmd_stat(&kvm, argc, argv);
+		return kvm_cmd_stat(file_name, argc, argv);
+#endif
 	else
 		usage_with_options(kvm_usage, kvm_options);
 
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 484f26c..5acd6e8 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -15,7 +15,7 @@
 #include "util/thread_map.h"
 #include "util/pmu.h"
 #include "event-parse.h"
-#include "../../include/linux/hw_breakpoint.h"
+#include <linux/hw_breakpoint.h>
 
 #include <sys/mman.h>
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index c50985e..238f923 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -5,8 +5,9 @@ struct winsize;
 
 void get_term_dimensions(struct winsize *ws);
 
+#include <asm/unistd.h>
+
 #if defined(__i386__)
-#include "../../arch/x86/include/asm/unistd.h"
 #define rmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
 #define CPUINFO_PROC	"model name"
@@ -16,7 +17,6 @@ void get_term_dimensions(struct winsize *ws);
 #endif
 
 #if defined(__x86_64__)
-#include "../../arch/x86/include/asm/unistd.h"
 #define rmb()		asm volatile("lfence" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
 #define CPUINFO_PROC	"model name"
@@ -26,20 +26,17 @@ void get_term_dimensions(struct winsize *ws);
 #endif
 
 #ifdef __powerpc__
-#include "../../arch/powerpc/include/asm/unistd.h"
 #define rmb()		asm volatile ("sync" ::: "memory")
 #define cpu_relax()	asm volatile ("" ::: "memory");
 #define CPUINFO_PROC	"cpu"
 #endif
 
 #ifdef __s390__
-#include "../../arch/s390/include/asm/unistd.h"
 #define rmb()		asm volatile("bcr 15,0" ::: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory");
 #endif
 
 #ifdef __sh__
-#include "../../arch/sh/include/asm/unistd.h"
 #if defined(__SH4A__) || defined(__SH5__)
 # define rmb()		asm volatile("synco" ::: "memory")
 #else
@@ -50,35 +47,30 @@ void get_term_dimensions(struct winsize *ws);
 #endif
 
 #ifdef __hppa__
-#include "../../arch/parisc/include/asm/unistd.h"
 #define rmb()		asm volatile("" ::: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory");
 #define CPUINFO_PROC	"cpu"
 #endif
 
 #ifdef __sparc__
-#include "../../arch/sparc/include/uapi/asm/unistd.h"
 #define rmb()		asm volatile("":::"memory")
 #define cpu_relax()	asm volatile("":::"memory")
 #define CPUINFO_PROC	"cpu"
 #endif
 
 #ifdef __alpha__
-#include "../../arch/alpha/include/asm/unistd.h"
 #define rmb()		asm volatile("mb" ::: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory")
 #define CPUINFO_PROC	"cpu model"
 #endif
 
 #ifdef __ia64__
-#include "../../arch/ia64/include/asm/unistd.h"
 #define rmb()		asm volatile ("mf" ::: "memory")
 #define cpu_relax()	asm volatile ("hint @pause" ::: "memory")
 #define CPUINFO_PROC	"model name"
 #endif
 
 #ifdef __arm__
-#include "../../arch/arm/include/asm/unistd.h"
 /*
  * Use the __kuser_memory_barrier helper in the CPU helper page. See
  * arch/arm/kernel/entry-armv.S in the kernel source for details.
@@ -89,13 +81,11 @@ void get_term_dimensions(struct winsize *ws);
 #endif
 
 #ifdef __aarch64__
-#include "../../arch/arm64/include/asm/unistd.h"
 #define rmb()		asm volatile("dmb ld" ::: "memory")
 #define cpu_relax()	asm volatile("yield" ::: "memory")
 #endif
 
 #ifdef __mips__
-#include "../../arch/mips/include/asm/unistd.h"
 #define rmb()		asm volatile(					\
 				".set	mips2\n\t"			\
 				"sync\n\t"				\
@@ -112,7 +102,7 @@ void get_term_dimensions(struct winsize *ws);
 #include <sys/types.h>
 #include <sys/syscall.h>
 
-#include "../../include/uapi/linux/perf_event.h"
+#include <linux/perf_event.h>
 #include "util/types.h"
 #include <stdbool.h>
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 618d411..d144d46 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -18,8 +18,8 @@
 #include "cpumap.h"
 #include "thread_map.h"
 #include "target.h"
-#include "../../../include/linux/hw_breakpoint.h"
-#include "../../../include/uapi/linux/perf_event.h"
+#include <linux/hw_breakpoint.h>
+#include <linux/perf_event.h>
 #include "perf_regs.h"
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 6f94d6d..d99b476 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -3,7 +3,8 @@
 
 #include <linux/list.h>
 #include <stdbool.h>
-#include "../../../include/uapi/linux/perf_event.h"
+#include <stddef.h>
+#include <linux/perf_event.h>
 #include "types.h"
 #include "xyarray.h"
 #include "cgroup.h"
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 7daad23..566b84c 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1378,6 +1378,8 @@ static void print_numa_topology(struct perf_header *ph, int fd __maybe_unused,
 
 		str = tmp + 1;
 		fprintf(fp, "# node%u cpu list : %s\n", c, str);
+
+		str += strlen(str) + 1;
 	}
 	return;
 error:
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 879d215..9bc0078 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_HEADER_H
 #define __PERF_HEADER_H
 
-#include "../../../include/uapi/linux/perf_event.h"
+#include <linux/perf_event.h>
 #include <sys/types.h>
 #include <stdbool.h>
 #include "types.h"
diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index 516ecd9..6ef213b 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -3,7 +3,7 @@
 #include "evsel.h"
 #include "evlist.h"
 #include "sysfs.h"
-#include "../../../include/linux/hw_breakpoint.h"
+#include <linux/hw_breakpoint.h>
 
 #define TEST_ASSERT_VAL(text, cond) \
 do { \
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 75c7b0f..6b6d03e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1,4 +1,4 @@
-#include "../../../include/linux/hw_breakpoint.h"
+#include <linux/hw_breakpoint.h>
 #include "util.h"
 #include "../perf.h"
 #include "evlist.h"
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 839230c..2820c40 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -7,7 +7,7 @@
 #include <linux/list.h>
 #include <stdbool.h>
 #include "types.h"
-#include "../../../include/uapi/linux/perf_event.h"
+#include <linux/perf_event.h>
 #include "types.h"
 
 struct list_head;
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 39f3aba..fdeb8ac 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -2,7 +2,7 @@
 #define __PMU_H
 
 #include <linux/bitops.h>
-#include "../../../include/uapi/linux/perf_event.h"
+#include <linux/perf_event.h>
 
 enum {
 	PERF_PMU_FORMAT_VALUE_CONFIG,
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index dd64261..0eae00a 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -7,7 +7,7 @@
 #include "symbol.h"
 #include "thread.h"
 #include <linux/rbtree.h>
-#include "../../../include/uapi/linux/perf_event.h"
+#include <linux/perf_event.h>
 
 struct sample_queue;
 struct ip_callchain;
diff --git a/tools/perf/util/strbuf.c b/tools/perf/util/strbuf.c
index 2eeb51b..cfa9068 100644
--- a/tools/perf/util/strbuf.c
+++ b/tools/perf/util/strbuf.c
@@ -90,17 +90,17 @@ void strbuf_addf(struct strbuf *sb, const char *fmt, ...)
 	if (!strbuf_avail(sb))
 		strbuf_grow(sb, 64);
 	va_start(ap, fmt);
-	len = vscnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
+	len = vsnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
 	va_end(ap);
 	if (len < 0)
-		die("your vscnprintf is broken");
+		die("your vsnprintf is broken");
 	if (len > strbuf_avail(sb)) {
 		strbuf_grow(sb, len);
 		va_start(ap, fmt);
-		len = vscnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
+		len = vsnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
 		va_end(ap);
 		if (len > strbuf_avail(sb)) {
-			die("this should not happen, your snprintf is broken");
+			die("this should not happen, your vsnprintf is broken");
 		}
 	}
 	strbuf_setlen(sb, sb->len + len);
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 96ce80a..2964b96 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -1,8 +1,11 @@
-ifeq ("$(origin O)", "command line")
+ifeq ($(origin O), command line)
 	dummy := $(if $(shell test -d $(O) || echo $(O)),$(error O=$(O) does not exist),)
 	ABSOLUTE_O := $(shell cd $(O) ; pwd)
-	OUTPUT := $(ABSOLUTE_O)/
+	OUTPUT := $(ABSOLUTE_O)/$(if $(subdir),$(subdir)/)
 	COMMAND_O := O=$(ABSOLUTE_O)
+ifeq ($(objtree),)
+	objtree := $(O)
+endif
 endif
 
 ifneq ($(OUTPUT),)
@@ -41,7 +44,16 @@ else
 NO_SUBDIR = :
 endif
 
-QUIET_SUBDIR0  = +$(MAKE) -C # space to separate -C and subdir
+#
+# Define a callable command for descending to a new directory
+#
+# Call by doing: $(call descend,directory[,target])
+#
+descend = \
+	+mkdir -p $(OUTPUT)$(1) && \
+	$(MAKE) $(COMMAND_O) subdir=$(if $(subdir),$(subdir)/$(1),$(1)) $(PRINT_DIR) -C $(1) $(2)
+
+QUIET_SUBDIR0  = +$(MAKE) $(COMMAND_O) -C # space to separate -C and subdir
 QUIET_SUBDIR1  =
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)
@@ -56,5 +68,10 @@ ifndef V
 			 $(MAKE) $(PRINT_DIR) -C $$subdir
 	QUIET_FLEX     = @echo '   ' FLEX $@;
 	QUIET_BISON    = @echo '   ' BISON $@;
+
+	descend = \
+		@echo '   ' DESCEND $(1); \
+		mkdir -p $(OUTPUT)$(1) && \
+		$(MAKE) $(COMMAND_O) subdir=$(if $(subdir),$(subdir)/$(1),$(1)) $(PRINT_DIR) -C $(1) $(2)
 endif
 endif
