Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab2APJdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 04:33:06 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:41752 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab2APJdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 04:33:01 -0500
Message-ID: <4F13EEC5.8050807@linux.vnet.ibm.com>
Date: Mon, 16 Jan 2012 17:32:53 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 3/3] KVM: perf: kvm events analysis tool
References: <4F13EE3D.2070602@linux.vnet.ibm.com>
In-Reply-To: <4F13EE3D.2070602@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011609-5564-0000-0000-000000F578C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 'perf kvm-events' support to analyze kvm vmexit/mmio/ioport smartly

Usage:
	perf kvm-events record
	perf kvm-events report

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 tools/perf/Documentation/perf-kvm-events.txt |   54 ++
 tools/perf/Makefile                          |    1 +
 tools/perf/builtin-kvm-events.c              |  860 ++++++++++++++++++++++++++
 tools/perf/builtin.h                         |    1 +
 tools/perf/perf.c                            |    1 +
 5 files changed, 917 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-kvm-events.txt
 create mode 100644 tools/perf/builtin-kvm-events.c

diff --git a/tools/perf/Documentation/perf-kvm-events.txt b/tools/perf/Documentation/perf-kvm-events.txt
new file mode 100644
index 0000000..73bcb82
--- /dev/null
+++ b/tools/perf/Documentation/perf-kvm-events.txt
@@ -0,0 +1,54 @@
+perf-kvm-events(1)
+============
+
+NAME
+----
+perf-kvm-events - Analyze kvm events
+
+SYNOPSIS
+--------
+[verse]
+'perf kvm-events' {record|report}
+
+DESCRIPTION
+-----------
+You can analyze some crucial events and statistics with this
+'perf kvm-events' command.
+
+  'perf kvm-events record <command>' records kvm events
+  between start and end <command>. And this command
+  produces the file "perf.data" which contains tracing
+  results of kvm events.
+
+  'perf kvm-events report' reports statistical data.
+
+COMMON OPTIONS
+--------------
+
+-i::
+--input=<file>::
+        Input file name. (default: perf.data unless stdin is a fifo)
+
+-v::
+--verbose::
+        Be more verbose (show symbol address, etc).
+
+-D::
+--dump-raw-trace::
+        Dump raw trace in ASCII.
+
+REPORT OPTIONS
+--------------
+--vcpu=<value>::
+	analyze events which occures on this vcpu
+
+--events=<value>::
+	events to be analyzed. Possible values: vmexit, mmio, ioport.
+-k::
+--key=<value>::
+        Sorting key. Possible values: sample(default, sort by samples number),
+time(sort by time%).
+
+SEE ALSO
+--------
+linkperf:perf[1]
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ac86d67..ee43451 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -382,6 +382,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-probe.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kmem.o
 BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
+BUILTIN_OBJS += $(OUTPUT)builtin-kvm-events.o
 BUILTIN_OBJS += $(OUTPUT)builtin-test.o
 BUILTIN_OBJS += $(OUTPUT)builtin-inject.o

diff --git a/tools/perf/builtin-kvm-events.c b/tools/perf/builtin-kvm-events.c
new file mode 100644
index 0000000..55dc680
--- /dev/null
+++ b/tools/perf/builtin-kvm-events.c
@@ -0,0 +1,860 @@
+#include "builtin.h"
+#include "perf.h"
+#include "util/util.h"
+#include "util/cache.h"
+#include "util/symbol.h"
+#include "util/thread.h"
+#include "util/header.h"
+#include "util/parse-options.h"
+#include "util/trace-event.h"
+#include "util/debug.h"
+#include "util/session.h"
+#include "util/tool.h"
+
+#include <linux/hash.h>
+
+/*
+ * Todo: improve the print format of kvm_exit to let it is easier
+ * parsed by perf, then we can get the exit reason from print
+ * format directly.
+ */
+#define EXIT_REASON_EXCEPTION_NMI       0
+#define EXIT_REASON_EXTERNAL_INTERRUPT  1
+#define EXIT_REASON_TRIPLE_FAULT        2
+
+#define EXIT_REASON_PENDING_INTERRUPT   7
+#define EXIT_REASON_NMI_WINDOW		8
+#define EXIT_REASON_TASK_SWITCH         9
+#define EXIT_REASON_CPUID               10
+#define EXIT_REASON_HLT                 12
+#define EXIT_REASON_INVD                13
+#define EXIT_REASON_INVLPG              14
+#define EXIT_REASON_RDPMC               15
+#define EXIT_REASON_RDTSC               16
+#define EXIT_REASON_VMCALL              18
+#define EXIT_REASON_VMCLEAR             19
+#define EXIT_REASON_VMLAUNCH            20
+#define EXIT_REASON_VMPTRLD             21
+#define EXIT_REASON_VMPTRST             22
+#define EXIT_REASON_VMREAD              23
+#define EXIT_REASON_VMRESUME            24
+#define EXIT_REASON_VMWRITE             25
+#define EXIT_REASON_VMOFF               26
+#define EXIT_REASON_VMON                27
+#define EXIT_REASON_CR_ACCESS           28
+#define EXIT_REASON_DR_ACCESS           29
+#define EXIT_REASON_IO_INSTRUCTION      30
+#define EXIT_REASON_MSR_READ            31
+#define EXIT_REASON_MSR_WRITE           32
+#define EXIT_REASON_INVALID_STATE	33
+#define EXIT_REASON_MWAIT_INSTRUCTION   36
+#define EXIT_REASON_MONITOR_INSTRUCTION 39
+#define EXIT_REASON_PAUSE_INSTRUCTION   40
+#define EXIT_REASON_MCE_DURING_VMENTRY	 41
+#define EXIT_REASON_TPR_BELOW_THRESHOLD 43
+#define EXIT_REASON_APIC_ACCESS         44
+#define EXIT_REASON_EPT_VIOLATION       48
+#define EXIT_REASON_EPT_MISCONFIG       49
+#define EXIT_REASON_WBINVD		54
+#define EXIT_REASON_XSETBV		55
+
+#define SVM_EXIT_READ_CR0	0x000
+#define SVM_EXIT_READ_CR3	0x003
+#define SVM_EXIT_READ_CR4	0x004
+#define SVM_EXIT_READ_CR8	0x008
+#define SVM_EXIT_WRITE_CR0	0x010
+#define SVM_EXIT_WRITE_CR3	0x013
+#define SVM_EXIT_WRITE_CR4	0x014
+#define SVM_EXIT_WRITE_CR8	0x018
+#define SVM_EXIT_READ_DR0	0x020
+#define SVM_EXIT_READ_DR1	0x021
+#define SVM_EXIT_READ_DR2	0x022
+#define SVM_EXIT_READ_DR3	0x023
+#define SVM_EXIT_READ_DR4	0x024
+#define SVM_EXIT_READ_DR5	0x025
+#define SVM_EXIT_READ_DR6	0x026
+#define SVM_EXIT_READ_DR7	0x027
+#define SVM_EXIT_WRITE_DR0	0x030
+#define SVM_EXIT_WRITE_DR1	0x031
+#define SVM_EXIT_WRITE_DR2	0x032
+#define SVM_EXIT_WRITE_DR3	0x033
+#define SVM_EXIT_WRITE_DR4	0x034
+#define SVM_EXIT_WRITE_DR5	0x035
+#define SVM_EXIT_WRITE_DR6	0x036
+#define SVM_EXIT_WRITE_DR7	0x037
+#define SVM_EXIT_EXCP_BASE	0x040
+#define SVM_EXIT_INTR		0x060
+#define SVM_EXIT_NMI		0x061
+#define SVM_EXIT_SMI		0x062
+#define SVM_EXIT_INIT		0x063
+#define SVM_EXIT_VINTR		0x064
+#define SVM_EXIT_CR0_SEL_WRITE	0x065
+#define SVM_EXIT_IDTR_READ	0x066
+#define SVM_EXIT_GDTR_READ	0x067
+#define SVM_EXIT_LDTR_READ	0x068
+#define SVM_EXIT_TR_READ	0x069
+#define SVM_EXIT_IDTR_WRITE	0x06a
+#define SVM_EXIT_GDTR_WRITE	0x06b
+#define SVM_EXIT_LDTR_WRITE	0x06c
+#define SVM_EXIT_TR_WRITE	0x06d
+#define SVM_EXIT_RDTSC	0x06e
+#define SVM_EXIT_RDPMC	0x06f
+#define SVM_EXIT_PUSHF	0x070
+#define SVM_EXIT_POPF	0x071
+#define SVM_EXIT_CPUID	0x072
+#define SVM_EXIT_RSM	0x073
+#define SVM_EXIT_IRET	0x074
+#define SVM_EXIT_SWINT	0x075
+#define SVM_EXIT_INVD	0x076
+#define SVM_EXIT_PAUSE	0x077
+#define SVM_EXIT_HLT	0x078
+#define SVM_EXIT_INVLPG	0x079
+#define SVM_EXIT_INVLPGA	0x07a
+#define SVM_EXIT_IOIO	0x07b
+#define SVM_EXIT_MSR	0x07c
+#define SVM_EXIT_TASK_SWITCH	0x07d
+#define SVM_EXIT_FERR_FREEZE	0x07e
+#define SVM_EXIT_SHUTDOWN	0x07f
+#define SVM_EXIT_VMRUN	0x080
+#define SVM_EXIT_VMMCALL	0x081
+#define SVM_EXIT_VMLOAD	0x082
+#define SVM_EXIT_VMSAVE	0x083
+#define SVM_EXIT_STGI	0x084
+#define SVM_EXIT_CLGI	0x085
+#define SVM_EXIT_SKINIT	0x086
+#define SVM_EXIT_RDTSCP	0x087
+#define SVM_EXIT_ICEBP	0x088
+#define SVM_EXIT_WBINVD	0x089
+#define SVM_EXIT_MONITOR	0x08a
+#define SVM_EXIT_MWAIT	0x08b
+#define SVM_EXIT_MWAIT_COND	0x08c
+#define SVM_EXIT_XSETBV	0x08d
+#define SVM_EXIT_NPF	0x400
+
+#define DE_VECTOR 0
+#define DB_VECTOR 1
+#define BP_VECTOR 3
+#define OF_VECTOR 4
+#define BR_VECTOR 5
+#define UD_VECTOR 6
+#define NM_VECTOR 7
+#define DF_VECTOR 8
+#define TS_VECTOR 10
+#define NP_VECTOR 11
+#define SS_VECTOR 12
+#define GP_VECTOR 13
+#define PF_VECTOR 14
+#define MF_VECTOR 16
+#define MC_VECTOR 18
+
+
+#define VMX_EXIT_REASONS \
+	{ EXIT_REASON_EXCEPTION_NMI,		"EXCEPTION_NMI" }, \
+	{ EXIT_REASON_EXTERNAL_INTERRUPT,	"EXTERNAL_INTERRUPT" }, \
+	{ EXIT_REASON_TRIPLE_FAULT,		"TRIPLE_FAULT" }, \
+	{ EXIT_REASON_PENDING_INTERRUPT,	"PENDING_INTERRUPT" }, \
+	{ EXIT_REASON_NMI_WINDOW,		"NMI_WINDOW" }, \
+	{ EXIT_REASON_TASK_SWITCH,		"TASK_SWITCH" }, \
+	{ EXIT_REASON_CPUID,			"CPUID" }, \
+	{ EXIT_REASON_HLT,			"HLT" }, \
+	{ EXIT_REASON_INVLPG,			"INVLPG" }, \
+	{ EXIT_REASON_RDPMC,			"RDPMC" }, \
+	{ EXIT_REASON_RDTSC,			"RDTSC" }, \
+	{ EXIT_REASON_VMCALL,			"VMCALL" }, \
+	{ EXIT_REASON_VMCLEAR,			"VMCLEAR" }, \
+	{ EXIT_REASON_VMLAUNCH,			"VMLAUNCH" }, \
+	{ EXIT_REASON_VMPTRLD,			"VMPTRLD" }, \
+	{ EXIT_REASON_VMPTRST,			"VMPTRST" }, \
+	{ EXIT_REASON_VMREAD,			"VMREAD" }, \
+	{ EXIT_REASON_VMRESUME,			"VMRESUME" }, \
+	{ EXIT_REASON_VMWRITE,			"VMWRITE" }, \
+	{ EXIT_REASON_VMOFF,			"VMOFF" }, \
+	{ EXIT_REASON_VMON,			"VMON" }, \
+	{ EXIT_REASON_CR_ACCESS,		"CR_ACCESS" }, \
+	{ EXIT_REASON_DR_ACCESS,		"DR_ACCESS" }, \
+	{ EXIT_REASON_IO_INSTRUCTION,		"IO_INSTRUCTION" }, \
+	{ EXIT_REASON_MSR_READ,			"MSR_READ" }, \
+	{ EXIT_REASON_MSR_WRITE,		"MSR_WRITE" }, \
+	{ EXIT_REASON_MWAIT_INSTRUCTION,	"MWAIT_INSTRUCTION" }, \
+	{ EXIT_REASON_MONITOR_INSTRUCTION,	"MONITOR_INSTRUCTION" }, \
+	{ EXIT_REASON_PAUSE_INSTRUCTION,	"PAUSE_INSTRUCTION" }, \
+	{ EXIT_REASON_MCE_DURING_VMENTRY,	"MCE_DURING_VMENTRY" }, \
+	{ EXIT_REASON_TPR_BELOW_THRESHOLD,	"TPR_BELOW_THRESHOLD" },\
+	{ EXIT_REASON_APIC_ACCESS,		"APIC_ACCESS" }, \
+	{ EXIT_REASON_EPT_VIOLATION,		"EPT_VIOLATION" }, \
+	{ EXIT_REASON_EPT_MISCONFIG,		"EPT_MISCONFIG" }, \
+	{ EXIT_REASON_WBINVD,			"WBINVD" }
+
+#define SVM_EXIT_REASONS \
+	{ SVM_EXIT_READ_CR0,			"read_cr0" }, \
+	{ SVM_EXIT_READ_CR3,			"read_cr3" }, \
+	{ SVM_EXIT_READ_CR4,			"read_cr4" }, \
+	{ SVM_EXIT_READ_CR8,			"read_cr8" }, \
+	{ SVM_EXIT_WRITE_CR0,			"write_cr0" }, \
+	{ SVM_EXIT_WRITE_CR3,			"write_cr3" }, \
+	{ SVM_EXIT_WRITE_CR4,			"write_cr4" }, \
+	{ SVM_EXIT_WRITE_CR8,			"write_cr8" }, \
+	{ SVM_EXIT_READ_DR0,			"read_dr0" }, \
+	{ SVM_EXIT_READ_DR1,			"read_dr1" }, \
+	{ SVM_EXIT_READ_DR2,			"read_dr2" }, \
+	{ SVM_EXIT_READ_DR3,			"read_dr3" }, \
+	{ SVM_EXIT_WRITE_DR0,			"write_dr0" }, \
+	{ SVM_EXIT_WRITE_DR1,			"write_dr1" }, \
+	{ SVM_EXIT_WRITE_DR2,			"write_dr2" }, \
+	{ SVM_EXIT_WRITE_DR3,			"write_dr3" }, \
+	{ SVM_EXIT_WRITE_DR5,			"write_dr5" }, \
+	{ SVM_EXIT_WRITE_DR7,			"write_dr7" }, \
+	{ SVM_EXIT_EXCP_BASE + DB_VECTOR,	"DB excp" }, \
+	{ SVM_EXIT_EXCP_BASE + BP_VECTOR,	"BP excp" }, \
+	{ SVM_EXIT_EXCP_BASE + UD_VECTOR,	"UD excp" }, \
+	{ SVM_EXIT_EXCP_BASE + PF_VECTOR,	"PF excp" }, \
+	{ SVM_EXIT_EXCP_BASE + NM_VECTOR,	"NM excp" }, \
+	{ SVM_EXIT_EXCP_BASE + MC_VECTOR,	"MC excp" }, \
+	{ SVM_EXIT_INTR,			"interrupt" }, \
+	{ SVM_EXIT_NMI,				"nmi" }, \
+	{ SVM_EXIT_SMI,				"smi" }, \
+	{ SVM_EXIT_INIT,			"init" }, \
+	{ SVM_EXIT_VINTR,			"vintr" }, \
+	{ SVM_EXIT_CPUID,			"cpuid" }, \
+	{ SVM_EXIT_INVD,			"invd" }, \
+	{ SVM_EXIT_HLT,				"hlt" }, \
+	{ SVM_EXIT_INVLPG,			"invlpg" }, \
+	{ SVM_EXIT_INVLPGA,			"invlpga" }, \
+	{ SVM_EXIT_IOIO,			"io" }, \
+	{ SVM_EXIT_MSR,				"msr" }, \
+	{ SVM_EXIT_TASK_SWITCH,			"task_switch" }, \
+	{ SVM_EXIT_SHUTDOWN,			"shutdown" }, \
+	{ SVM_EXIT_VMRUN,			"vmrun" }, \
+	{ SVM_EXIT_VMMCALL,			"hypercall" }, \
+	{ SVM_EXIT_VMLOAD,			"vmload" }, \
+	{ SVM_EXIT_VMSAVE,			"vmsave" }, \
+	{ SVM_EXIT_STGI,			"stgi" }, \
+	{ SVM_EXIT_CLGI,			"clgi" }, \
+	{ SVM_EXIT_SKINIT,			"skinit" }, \
+	{ SVM_EXIT_WBINVD,			"wbinvd" }, \
+	{ SVM_EXIT_MONITOR,			"monitor" }, \
+	{ SVM_EXIT_MWAIT,			"mwait" }, \
+	{ SVM_EXIT_XSETBV,			"xsetbv" }, \
+	{ SVM_EXIT_NPF,				"npf" }
+
+struct exit_reasons_table {
+	unsigned long exit_code;
+	const char *reason;
+};
+
+struct exit_reasons_table vmx_exit_reasons[] = {
+	VMX_EXIT_REASONS
+};
+
+struct exit_reasons_table svm_exit_reasons[] = {
+	SVM_EXIT_REASONS
+};
+
+static const char *get_exit_reason(long isa, u64 exit_code)
+{
+	int table_size = ARRAY_SIZE(svm_exit_reasons);
+	struct exit_reasons_table *table = svm_exit_reasons;
+
+
+	if (isa == 1) {
+		table = vmx_exit_reasons;
+		table_size = ARRAY_SIZE(vmx_exit_reasons);
+	}
+
+	while (table_size--) {
+		if (table->exit_code == exit_code)
+			return table->reason;
+		table++;
+	}
+
+	die("unkonw kvm exit code:%ld on %s\n", exit_code, isa == 1 ?
+						"VMX" : "SVM");
+}
+
+struct event_key {
+	u64 key;
+	int info;
+};
+
+struct kvm_events_ops {
+	bool (*is_begain_event)(struct event *event, void *data);
+	bool (*is_end_event)(struct event *event);
+	struct event_key (*get_key)(struct event *event, void *data);
+	void (*decode_key)(struct event_key *key, char decode[20]);
+	const char *name;
+};
+
+static bool exit_event_begain(struct event *event, void *data __unused)
+{
+	return !strcmp(event->name, "kvm_exit");
+}
+
+static bool exit_event_end(struct event *event)
+{
+	return !strcmp(event->name, "kvm_entry");
+}
+
+static struct event_key exit_event_get_key(struct event *event, void *data)
+{
+	struct event_key key;
+
+	key.key = raw_field_value(event, "exit_reason", data);
+	key.info = raw_field_value(event, "isa", data);
+	return key;
+}
+
+static void exit_event_decode_key(struct event_key *key, char decode[20])
+{
+	const char *exit_reason = get_exit_reason(key->info, key->key);
+
+	memset(decode, 0, 20);
+	strncpy(decode, exit_reason, 20);
+}
+
+static struct kvm_events_ops exit_events = {
+	.is_begain_event = exit_event_begain,
+	.is_end_event = exit_event_end,
+	.get_key = exit_event_get_key,
+	.decode_key = exit_event_decode_key,
+	.name = "VM-EXIT"
+};
+
+#define KVM_TRACE_MMIO_READ_UNSATISFIED 0
+#define KVM_TRACE_MMIO_READ 1
+#define KVM_TRACE_MMIO_WRITE 2
+static bool mmio_event_begain(struct event *event, void *data)
+{
+	if (!strcmp(event->name, "kvm_mmio")) {
+		long type = raw_field_value(event, "type", data);
+
+		if (type != KVM_TRACE_MMIO_READ_UNSATISFIED)
+			return true;
+	};
+
+	return false;
+}
+
+static bool mmio_event_end(struct event *event)
+{
+	return !strcmp(event->name, "kvm_mmio_done");
+}
+
+static struct event_key mmio_event_get_key(struct event *event, void *data)
+{
+	struct event_key key;
+
+	key.key = raw_field_value(event, "gpa", data);
+	key.info = raw_field_value(event, "type", data);
+
+	return key;
+}
+
+static void mmio_event_decode_key(struct event_key *key, char decode[20])
+{
+	memset(decode, 0, 20);
+	sprintf(decode, "%#lx:%s", key->key,
+		key->info == KVM_TRACE_MMIO_READ ? "R" : "W");
+}
+
+static struct kvm_events_ops mmio_events = {
+	.is_begain_event = mmio_event_begain,
+	.is_end_event = mmio_event_end,
+	.get_key = mmio_event_get_key,
+	.decode_key = mmio_event_decode_key,
+	.name = "MMIO Access"
+};
+
+static bool ioport_event_begain(struct event *event, void *data __unused)
+{
+	return !strcmp(event->name, "kvm_pio");
+}
+
+static struct event_key ioport_event_get_key(struct event *event, void *data)
+{
+	struct event_key key;
+
+	key.key = raw_field_value(event, "port", data);
+	key.info = raw_field_value(event, "rw", data);
+
+	return key;
+}
+
+static void ioport_event_decode_key(struct event_key *key, char decode[20])
+{
+	memset(decode, 0, 20);
+	sprintf(decode, "%#lx:%s", key->key, key->info ? "POUT" : "PIN");
+}
+
+static struct kvm_events_ops ioport_events = {
+	.is_begain_event = ioport_event_begain,
+	.is_end_event = mmio_event_end,
+	.get_key = ioport_event_get_key,
+	.decode_key = ioport_event_decode_key,
+	.name = "IO Port Access"
+};
+
+static const char *report_event = "vmexit";
+struct kvm_events_ops *events_ops;
+
+static void register_kvm_events_ops(void)
+{
+	if (!strcmp(report_event, "vmexit"))
+		events_ops = &exit_events;
+	else if (!strcmp(report_event, "mmio"))
+		events_ops = &mmio_events;
+	else if (!strcmp(report_event, "ioport"))
+		events_ops = &ioport_events;
+	else
+		die("Unknown report event:%s\n", report_event);
+}
+
+#define KVM_MAX_VCPUS 254
+
+struct kvm_event {
+	struct list_head hash_entry;
+	struct rb_node rb;
+
+	u64 count;
+	u64 time;
+	struct {
+		u64 count;
+		u64 time;
+	} vcpu[KVM_MAX_VCPUS];
+
+	struct event_key key;
+};
+
+struct {
+	u64 start_time;
+	struct kvm_event *last_event;
+} vcpu_event_record[KVM_MAX_VCPUS] ;
+
+#define EVENTS_BITS			12
+#define EVENTS_CACHE_SIZE	(1UL << EVENTS_BITS)
+
+static u64 total_time;
+static u64 total_count;
+static struct list_head kvm_events_cache[EVENTS_CACHE_SIZE];
+
+static void init_kvm_event_record(void)
+{
+	int i;
+
+	for (i = 0; i < KVM_MAX_VCPUS; i++)
+		vcpu_event_record[i].last_event = NULL;
+
+	for (i = 0; i < (int)EVENTS_CACHE_SIZE; i++)
+		INIT_LIST_HEAD(&kvm_events_cache[i]);
+}
+
+static int kvm_events_hash_fn(u64 key)
+{
+	return hash_long((unsigned long)key, EVENTS_BITS);
+}
+
+static void kvm_event_init(struct kvm_event *event, struct event_key *key)
+{
+	event->key = *key;
+}
+
+static struct kvm_event *find_create_kvm_event(struct event_key *key)
+{
+	struct kvm_event *event;
+	struct list_head *head;
+
+	head = &kvm_events_cache[kvm_events_hash_fn(key->key)];
+	list_for_each_entry(event, head, hash_entry)
+		if (event->key.key == key->key && event->key.info == key->info)
+			return event;
+
+	event = zalloc(sizeof(*event));
+	if (!event)
+		die("Not enough memory\n");
+
+	kvm_event_init(event, key);
+	list_add(&event->hash_entry, head);
+	return event;
+}
+
+static void handle_begain_event(struct event_key *key, int vcpu_id,
+				u64 timestamp)
+{
+	struct kvm_event *event = find_create_kvm_event(key);
+
+	vcpu_event_record[vcpu_id].last_event = event;
+	vcpu_event_record[vcpu_id].start_time = timestamp;
+}
+
+static void update_kvm_event(struct kvm_event *event, int vcpu_id,
+			     u64 time_diff)
+{
+	event->count++;
+	event->time += time_diff;
+	event->vcpu[vcpu_id].count++;
+	event->vcpu[vcpu_id].time += time_diff;
+}
+
+static void handle_end_event(int vcpu_id, u64 timestamp)
+{
+	u64 time_begain, time_diff;
+	struct kvm_event *event;
+
+	event = vcpu_event_record[vcpu_id].last_event;
+	if (!event)
+		return;
+
+	time_begain = vcpu_event_record[vcpu_id].start_time;
+
+	vcpu_event_record[vcpu_id].last_event = NULL;
+	vcpu_event_record[vcpu_id].start_time = 0;
+
+	BUG_ON(!time_begain || timestamp < time_begain);
+
+	time_diff = timestamp - time_begain;
+	update_kvm_event(event, vcpu_id, time_diff);
+}
+
+static int get_vcpu_id(struct event *event, void *data)
+{
+	return raw_field_value(event, "vcpu_id", data);
+}
+
+static void handle_kvm_event(struct event *event, void *data, u64 timestamp)
+{
+	int vcpu_id;
+
+	if (events_ops->is_begain_event(event, data)) {
+		struct event_key key = events_ops->get_key(event, data);
+
+		vcpu_id = get_vcpu_id(event, data);
+		return handle_begain_event(&key, vcpu_id, timestamp);
+	}
+
+	if (events_ops->is_end_event(event)) {
+		vcpu_id = get_vcpu_id(event, data);
+		return handle_end_event(vcpu_id, timestamp);
+	}
+}
+
+typedef int (*key_cmp_fun)(struct kvm_event*, struct kvm_event*, int);
+struct kvm_event_key {
+	const char *name;
+	key_cmp_fun key;
+};
+
+static int trace_vcpu = -1;
+#define COMPARE_EVENT_KEY(member)					\
+static u64 get_event_ ##member(struct kvm_event *event, int vcpu)	\
+{									\
+	if (vcpu == -1)							\
+		return event->member;					\
+									\
+	return event->vcpu[vcpu].member;				\
+}									\
+									\
+static int compare_kvm_event_ ## member(struct kvm_event *one,		\
+					struct kvm_event *two, int vcpu)\
+{									\
+	return get_event_ ##member(one, vcpu) > get_event_ ##member(two, vcpu);\
+}
+
+COMPARE_EVENT_KEY(count);
+COMPARE_EVENT_KEY(time);
+
+#define DEF_SORT_NAME_KEY(name, compare_key)	\
+	{ #name, compare_kvm_event_ ## compare_key }
+
+static struct kvm_event_key keys[] = {
+	DEF_SORT_NAME_KEY(sample, count),
+	DEF_SORT_NAME_KEY(time, time),
+	{ NULL, NULL }
+};
+
+static const char *sort_key = "sample";
+static key_cmp_fun compare;
+
+static void select_key(void)
+{
+	int i;
+
+	for (i = 0; keys[i].name; i++) {
+		if (!strcmp(keys[i].name, sort_key)) {
+			compare = keys[i].key;
+			return;
+		}
+	}
+
+	die("Unknown compare key:%s\n", sort_key);
+}
+
+static struct rb_root result;
+static void insert_to_result(struct kvm_event *event, key_cmp_fun bigger,
+			     int vcpu)
+{
+	struct rb_node **rb = &result.rb_node;
+	struct rb_node *parent = NULL;
+	struct kvm_event *p;
+
+	while (*rb) {
+		p = container_of(*rb, struct kvm_event, rb);
+		parent = *rb;
+
+		if (bigger(event, p, vcpu))
+			rb = &(*rb)->rb_left;
+		else
+			rb = &(*rb)->rb_right;
+	}
+
+	rb_link_node(&event->rb, parent, rb);
+	rb_insert_color(&event->rb, &result);
+}
+
+static void update_total_count(struct kvm_event *event, int vcpu)
+{
+	total_count += get_event_count(event, vcpu);
+	total_time += get_event_time(event, vcpu);
+}
+
+static bool event_is_valid(struct kvm_event *event, int vcpu)
+{
+	return get_event_count(event, vcpu);
+}
+
+static void sort_result(int vcpu)
+{
+	unsigned int i;
+	struct kvm_event *event;
+
+	for (i = 0; i < EVENTS_CACHE_SIZE; i++)
+		list_for_each_entry(event, &kvm_events_cache[i], hash_entry)
+			if (event_is_valid(event, vcpu)) {
+				update_total_count(event, vcpu);
+				insert_to_result(event, compare, vcpu);
+			}
+}
+
+/* returns left most element of result, and erase it */
+static struct kvm_event *pop_from_result(void)
+{
+	struct rb_node *node = result.rb_node;
+
+	if (!node)
+		return NULL;
+
+	while (node->rb_left)
+		node = node->rb_left;
+
+	rb_erase(node, &result);
+	return container_of(node, struct kvm_event, rb);
+}
+
+static void print_vcpu_info(int vcpu)
+{
+	pr_info("Analyze events for ");
+
+	if (vcpu == -1)
+		pr_info("all VCPUs:\n\n");
+	else
+		pr_info("VCPU %d:\n\n", vcpu);
+}
+
+static void print_result(int vcpu)
+{
+	char decode[20];
+	struct kvm_event *event;
+
+	pr_info("\n\n");
+	print_vcpu_info(vcpu);
+	pr_info("%20s ", events_ops->name);
+	pr_info("%10s ", "Samples");
+	pr_info("%13s ", "Samples%");
+
+	pr_info("%13s ", "Time%");
+	pr_info("%15s ", "Avg time");
+	pr_info("\n\n");
+
+	while ((event = pop_from_result())) {
+		u64 ecount, etime;
+
+		ecount = get_event_count(event, vcpu);
+		etime = get_event_time(event, vcpu);
+
+		events_ops->decode_key(&event->key, decode);
+		pr_info("%20s ", decode);
+		pr_info("%10lu ", ecount);
+		pr_info("%12.2f%% ", (double)ecount / total_count * 100);
+		pr_info("%12.2f%%", (double)etime / total_time * 100);
+		pr_info("%13.2fus ", (double)etime / ecount/1e3);
+		pr_info("\n");
+	}
+
+	pr_info("\nTotal Samples:%ld, Total events handled time:%.2fus.\n\n",
+		total_count, total_time / 1e3);
+}
+
+static void process_raw_event(void *data, int __unused cpu, u64 timestamp,
+			      struct thread *thread __unused)
+{
+	struct event *event;
+	int type;
+
+	type = trace_parse_common_type(data);
+	event = trace_find_event(type);
+
+	return handle_kvm_event(event, data, timestamp);
+}
+
+static int process_sample_event(struct perf_tool *tool __used,
+				union perf_event *event,
+				struct perf_sample *sample,
+				struct perf_evsel *evsel __used,
+				struct machine *machine)
+{
+	struct thread *thread = machine__findnew_thread(machine, sample->tid);
+
+	if (thread == NULL) {
+		pr_debug("problem processing %d event, skipping it.\n",
+			event->header.type);
+		return -1;
+	}
+
+	process_raw_event(sample->raw_data, sample->cpu, sample->time, thread);
+
+	return 0;
+}
+
+static struct perf_tool eops = {
+	.sample			= process_sample_event,
+	.comm			= perf_event__process_comm,
+	.ordered_samples	= true,
+};
+
+static char const *input_name = "perf.data";
+
+static int read_events(void)
+{
+	struct perf_session *session;
+
+	session = perf_session__new(input_name, O_RDONLY, 0, false, &eops);
+	if (!session)
+		die("Initializing perf session failed\n");
+
+	if (!perf_session__has_traces(session, "kvm record"))
+		return -1;
+
+	return perf_session__process_events(session, &eops);
+}
+
+static void verify_vcpu(int vcpu)
+{
+	if (vcpu != -1 && (vcpu > KVM_MAX_VCPUS || vcpu < 0))
+		die("Unknow vcpu:%d.\n", vcpu);
+
+}
+
+static int kvm_events_report(int vcpu)
+{
+	verify_vcpu(vcpu);
+	select_key();
+	register_kvm_events_ops();
+	init_kvm_event_record();
+	setup_pager();
+	read_events();
+	sort_result(vcpu);
+	print_result(vcpu);
+	return 0;
+}
+
+static const char * const record_args[] = {
+	"record",
+	"-a",
+	"-R",
+	"-f",
+	"-m", "1024",
+	"-c", "1",
+	"-e", "kvm:kvm_entry",
+	"-e", "kvm:kvm_exit",
+	"-e", "kvm:kvm_mmio",
+	"-e", "kvm:kvm_mmio_done",
+	"-e", "kvm:kvm_pio"
+};
+
+static int kvm_events_record(int argc, const char **argv)
+{
+	unsigned int rec_argc, i, j;
+	const char **rec_argv;
+
+	rec_argc = ARRAY_SIZE(record_args) + argc - 1;
+	rec_argv = calloc(rec_argc + 1, sizeof(char *));
+
+	if (rec_argv == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(record_args); i++)
+		rec_argv[i] = strdup(record_args[i]);
+
+	for (j = 1; j < (unsigned int)argc; j++, i++)
+		rec_argv[i] = argv[j];
+
+	BUG_ON(i != rec_argc);
+
+	return cmd_record(i, rec_argv, NULL);
+}
+
+static const char * const kvm_events_report_usage[] = {
+	"perf kvm events report [<options>]",
+	NULL
+};
+
+static const struct option kvm_events_report_options[] = {
+	OPT_STRING(0, "event", &report_event, "reprot event",
+		    "event for reporting: vmexit, mmio, ioport"),
+	OPT_INTEGER(0, "vcpu", &trace_vcpu,
+		    "vcpu id to report"),
+	OPT_STRING('k', "key", &sort_key, "sort-key",
+		    "key for sorting: sample(sort by samples number)"
+		    " time (sort by time%)"),
+	OPT_END()
+};
+
+static const char * const kvm_events_usage[] = {
+	"perf kvm events [<options>] {record|report}",
+	NULL
+};
+
+static const struct option kvm_events_options[] = {
+	OPT_STRING('i', "input", &input_name, "file", "input file name"),
+	OPT_INCR('v', "verbose", &verbose,
+		 "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		 "dump raw trace in ASCII"),
+	OPT_END()
+};
+
+int cmd_kvm_events(int argc, const char **argv, const char *prefix __used)
+{
+	argc = parse_options(argc, argv, kvm_events_options, kvm_events_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+	if (!argc)
+		usage_with_options(kvm_events_usage, kvm_events_options);
+
+	symbol__init();
+
+	if (!strncmp(argv[0], "rec", 3))
+		return kvm_events_record(argc, argv);
+
+	if (!strncmp(argv[0], "report", 6)) {
+		if (argc) {
+			argc = parse_options(argc, argv,
+					     kvm_events_report_options,
+					     kvm_events_report_usage, 0);
+			if (argc)
+				usage_with_options(kvm_events_report_usage,
+						   kvm_events_report_options);
+		}
+		return kvm_events_report(trace_vcpu);
+	}
+
+	usage_with_options(kvm_events_usage, kvm_events_options);
+	return 0;
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index b382bd5..fb19e3d 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -33,6 +33,7 @@ extern int cmd_probe(int argc, const char **argv, const char *prefix);
 extern int cmd_kmem(int argc, const char **argv, const char *prefix);
 extern int cmd_lock(int argc, const char **argv, const char *prefix);
 extern int cmd_kvm(int argc, const char **argv, const char *prefix);
+extern int cmd_kvm_events(int argc, const char **argv, const char *prefix);
 extern int cmd_test(int argc, const char **argv, const char *prefix);
 extern int cmd_inject(int argc, const char **argv, const char *prefix);

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 2b2e225..ab85ea5 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -317,6 +317,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "kmem",	cmd_kmem,	0 },
 		{ "lock",	cmd_lock,	0 },
 		{ "kvm",	cmd_kvm,	0 },
+		{ "kvm-events", cmd_kvm_events, 0},
 		{ "test",	cmd_test,	0 },
 		{ "inject",	cmd_inject,	0 },
 	};
-- 
1.7.7.5

