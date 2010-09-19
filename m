Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab0ISOeE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 10:34:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab0ISOeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 10:34:02 -0400
From: Avi Kivity <avi@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-users@vger.kernel.org
Subject: [PATCH trace-cmd] plugin_kvm: disassemble instructions for kvm_emulate_insn
Date: Sun, 19 Sep 2010 16:33:57 +0200
Message-Id: <1284906837-2431-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Override kvm_emulate_insn formatting to use a disassembler to format
the emulated instruction.  If a disassembler (udis86) is not available,
fall back to showing the instruction bytes in hex.

Signed-off-by: Avi Kivity <avi@redhat.com>
---

Note 1: on top of 'master' with 'trace-cmd-kvm' cherry-picked on top.

Note 2: I get output of the form

... kvm_emulate_insn:     0:fffff800010527b5: mov $0x0, 0xfffe00b0CAN'T FIND FIELD "guest_rip"

which leads me to believe there is a bug in trace_seq_printf when the input
to %s is "".

 Makefile     |   11 +++++-
 plugin_kvm.c |  111 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 121 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 5282f94..fe34d1c 100644
--- a/Makefile
+++ b/Makefile
@@ -74,6 +74,14 @@ ifeq ($(shell sh -c "python-config --includes > /dev/null 2>&1 && echo y"), y)
 	PYTHON_PY_INSTALL := event-viewer.install tracecmd.install tracecmdgui.install
 endif
 
+# $(call test-build, snippet, ret) -> ret if snippet compiles
+#                                  -> empty otherwise
+test-build = $(if $(shell $(CC) -o /dev/null -c -x c - > /dev/null 2>&1 \
+	                  <<<'$1' && echo y), $2)
+
+# have udis86 disassembler library?
+udis86-flags := $(call test-build,\#include <udis86.h>,-DHAVE_UDIS86 -ludis86)
+
 ifeq ("$(origin O)", "command line")
   BUILD_OUTPUT := $(O)
 endif
@@ -188,6 +196,7 @@ CFLAGS ?= -g -Wall
 
 # Append required CFLAGS
 override CFLAGS += $(CONFIG_FLAGS) $(INCLUDES) $(PLUGIN_DIR_SQ)
+override CFLAGS += $(udis86-flags)
 
 ifeq ($(VERBOSE),1)
   Q =
@@ -228,7 +237,7 @@ do_compile_plugin_obj =				\
 
 do_plugin_build =				\
 	($(print_plugin_build)			\
-	$(CC) -shared -nostartfiles -o $@ $<)
+	$(CC) $(CFLAGS) -shared -nostartfiles -o $@ $<)
 
 do_build_static_lib =				\
 	($(print_static_lib_build)		\
diff --git a/plugin_kvm.c b/plugin_kvm.c
index 7217e85..00cac5a 100644
--- a/plugin_kvm.c
+++ b/plugin_kvm.c
@@ -21,9 +21,68 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <stdint.h>
 
 #include "parse-events.h"
 
+#ifdef HAVE_UDIS86
+
+#include <udis86.h>
+
+static ud_t ud;
+
+static void init_disassembler(void)
+{
+	ud_init(&ud);
+	ud_set_syntax(&ud, UD_SYN_ATT);
+}
+
+static const char *disassemble(unsigned char *insn, int len, uint64_t rip,
+			       int cr0_pe, int eflags_vm,
+			       int cs_d, int cs_l)
+{
+	int mode;
+
+	if (!cr0_pe)
+		mode = 16;
+	else if (eflags_vm)
+		mode = 16;
+	else if (cs_l)
+		mode = 64;
+	else if (cs_d)
+		mode = 32;
+	else
+		mode = 16;
+
+	ud_set_pc(&ud, rip);
+	ud_set_mode(&ud, mode);
+	ud_set_input_buffer(&ud, insn, len);
+	ud_disassemble(&ud);
+	return ud_insn_asm(&ud);
+}
+
+#else
+
+static void init_disassembler(void)
+{
+}
+
+static const char *disassemble(unsigned char *insn, int len, uint64_t rip,
+			       int cr0_pe, int eflags_vm,
+			       int cs_d, int cs_l)
+{
+	static char out[15*3+1];
+	int i;
+
+	for (i = 0; i < len; ++i)
+		sprintf(out + i * 3, "%02x ", insn[i]);
+	out[len*3-1] = '\0';
+	return out;
+}
+
+#endif
+
+
 #define VMX_EXIT_REASONS			\
 	_ER(EXCEPTION_NMI,	0)		\
 	_ER(EXTERNAL_INTERRUPT,	1)		\
@@ -99,6 +158,53 @@ static int kvm_exit_handler(struct trace_seq *s, struct record *record,
 	return 0;
 }
 
+#define KVM_EMUL_INSN_F_CR0_PE (1 << 0)
+#define KVM_EMUL_INSN_F_EFL_VM (1 << 1)
+#define KVM_EMUL_INSN_F_CS_D   (1 << 2)
+#define KVM_EMUL_INSN_F_CS_L   (1 << 3)
+
+static int kvm_emulate_insn_handler(struct trace_seq *s, struct record *record,
+				    struct event_format *event, void *context)
+{
+	unsigned long long rip, csbase, len, flags, failed;
+	int llen;
+	uint8_t *insn;
+	const char *disasm;
+
+	if (pevent_get_field_val(s, event, "rip", record, &rip, 1) < 0)
+		return -1;
+
+	if (pevent_get_field_val(s, event, "csbase", record, &csbase, 1) < 0)
+		return -1;
+
+	if (pevent_get_field_val(s, event, "len", record, &len, 1) < 0)
+		return -1;
+
+	if (pevent_get_field_val(s, event, "flags", record, &flags, 1) < 0)
+		return -1;
+
+	if (pevent_get_field_val(s, event, "failed", record, &failed, 1) < 0)
+		return -1;
+
+	insn = pevent_get_field_raw(s, event, "insn", record, &llen, 1);
+	if (!insn)
+		return -1;
+
+	disasm = disassemble(insn, len, rip,
+			     flags & KVM_EMUL_INSN_F_CR0_PE,
+			     flags & KVM_EMUL_INSN_F_EFL_VM,
+			     flags & KVM_EMUL_INSN_F_CS_D,
+			     flags & KVM_EMUL_INSN_F_CS_L);
+
+	trace_seq_printf(s, "%llx:%llx: %s%s", csbase, rip, disasm,
+			 failed ? " FAIL" : "");
+
+	pevent_print_num_field(s, " rip %0xlx", event, "guest_rip", record, 1);
+
+	return 0;
+}
+
+
 static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct record *record,
 					    struct event_format *event, void *context)
 {
@@ -199,9 +305,14 @@ static int kvm_mmu_get_page_handler(struct trace_seq *s, struct record *record,
 
 int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 {
+	init_disassembler();
+
 	pevent_register_event_handler(pevent, -1, "kvm", "kvm_exit",
 				      kvm_exit_handler, NULL);
 
+	pevent_register_event_handler(pevent, -1, "kvm", "kvm_emulate_insn",
+				      kvm_emulate_insn_handler, NULL);
+
 	pevent_register_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit",
 				      kvm_nested_vmexit_handler, NULL);
 
-- 
1.7.2.3

