Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab0JOUL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:11:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39757 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883Ab0JOUKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:10:39 -0400
X-Authority-Analysis: v=1.1 cv=exbvkCqEOBXDkHq+8n3wanotOBQtbe7qbIajSD+JluU= c=1 sm=0 a=kbRUBGKaEXUA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=enOvQawGAAAA:8 a=20KFwNOVAAAA:8 a=WPyIoOwQAAAA:8 a=meVymXHHAAAA:8 a=bWhlw3oZTvss8zEWJQIA:9 a=wvEa9j2gT5RlsGPJnp4A:7 a=3IAx4QljvZyhzZJroGqarOYyVEIA:4 a=bkT6KWdcy0IA:10 a=jEp0ucaQiEUA:10 a=1DbiqZag68YA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101015201037.941842436@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 15 Oct 2010 16:09:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
        David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 9/9] jump label: Add MIPS support.
References: <20101015200949.134732894@goodmis.org>
Content-Disposition: inline; filename=0009-jump-label-Add-MIPS-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <ddaney@caviumnetworks.com>

When in Rome...

In order not to be left behind, we add jump label support for MIPS.

Tested on 64-bit big endian (Octeon), and 32-bit little endian
(malta/qemu).

Cc: Jason Baron <jbaron@redhat.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: David Daney <ddaney@caviumnetworks.com>
LKML-Reference: <1286218615-24011-3-git-send-email-ddaney@caviumnetworks.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/mips/Kconfig                  |    1 +
 arch/mips/include/asm/jump_label.h |   48 ++++++++++++++++++++++++++++++++++
 arch/mips/kernel/Makefile          |    3 +-
 arch/mips/kernel/jump_label.c      |   50 ++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/module.c          |    5 +++
 5 files changed, 106 insertions(+), 1 deletions(-)
 create mode 100644 arch/mips/include/asm/jump_label.h
 create mode 100644 arch/mips/kernel/jump_label.c

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 5526faa..9429df3 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -12,6 +12,7 @@ config MIPS
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select HAVE_ARCH_JUMP_LABEL
 	select RTC_LIB if !MACH_LOONGSON
 	select GENERIC_ATOMIC64 if !64BIT
 
diff --git a/arch/mips/include/asm/jump_label.h b/arch/mips/include/asm/jump_label.h
new file mode 100644
index 0000000..7622ccf
--- /dev/null
+++ b/arch/mips/include/asm/jump_label.h
@@ -0,0 +1,48 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (c) 2010 Cavium Networks, Inc.
+ */
+#ifndef _ASM_MIPS_JUMP_LABEL_H
+#define _ASM_MIPS_JUMP_LABEL_H
+
+#include <linux/types.h>
+
+#ifdef __KERNEL__
+
+#define JUMP_LABEL_NOP_SIZE 4
+
+#ifdef CONFIG_64BIT
+#define WORD_INSN ".dword"
+#else
+#define WORD_INSN ".word"
+#endif
+
+#define JUMP_LABEL(key, label)						\
+	do {								\
+		asm goto("1:\tnop\n\t"					\
+			"nop\n\t"					\
+			".pushsection __jump_table,  \"a\"\n\t"		\
+			WORD_INSN " 1b, %l[" #label "], %0\n\t"		\
+			".popsection\n\t"				\
+			: :  "i" (key) :  : label);			\
+	} while (0)
+
+
+#endif /* __KERNEL__ */
+
+#ifdef CONFIG_64BIT
+typedef u64 jump_label_t;
+#else
+typedef u32 jump_label_t;
+#endif
+
+struct jump_entry {
+	jump_label_t code;
+	jump_label_t target;
+	jump_label_t key;
+};
+
+#endif /* _ASM_MIPS_JUMP_LABEL_H */
diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
index 06f8482..db4feb9 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -6,7 +6,8 @@ extra-y		:= head.o init_task.o vmlinux.lds
 
 obj-y		+= cpu-probe.o branch.o entry.o genex.o irq.o process.o \
 		   ptrace.o reset.o setup.o signal.o syscall.o \
-		   time.o topology.o traps.o unaligned.o watch.o vdso.o
+		   time.o topology.o traps.o unaligned.o watch.o vdso.o \
+		   jump_label.o
 
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_ftrace.o = -pg
diff --git a/arch/mips/kernel/jump_label.c b/arch/mips/kernel/jump_label.c
new file mode 100644
index 0000000..52d3c70
--- /dev/null
+++ b/arch/mips/kernel/jump_label.c
@@ -0,0 +1,50 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (c) 2010 Cavium Networks, Inc.
+ */
+
+#include <linux/jump_label.h>
+#include <linux/kernel.h>
+#include <linux/memory.h>
+#include <linux/mutex.h>
+#include <linux/types.h>
+#include <linux/cpu.h>
+
+#include <asm/cacheflush.h>
+#include <asm/inst.h>
+
+#define J_RANGE_MASK ((1ul << 28) - 1)
+
+void arch_jump_label_transform(struct jump_entry *e,
+			       enum jump_label_type type)
+{
+	union mips_instruction insn;
+	union mips_instruction *insn_p =
+		(union mips_instruction *)(unsigned long)e->code;
+
+	/* Jump only works within a 256MB aligned region. */
+	BUG_ON((e->target & ~J_RANGE_MASK) != (e->code & ~J_RANGE_MASK));
+
+	/* Target must have 4 byte alignment. */
+	BUG_ON((e->target & 3) != 0);
+
+	if (type == JUMP_LABEL_ENABLE) {
+		insn.j_format.opcode = j_op;
+		insn.j_format.target = (e->target & J_RANGE_MASK) >> 2;
+	} else {
+		insn.word = 0; /* nop */
+	}
+
+	get_online_cpus();
+	mutex_lock(&text_mutex);
+	*insn_p = insn;
+
+	flush_icache_range((unsigned long)insn_p,
+			   (unsigned long)insn_p + sizeof(*insn_p));
+
+	mutex_unlock(&text_mutex);
+	put_online_cpus();
+}
diff --git a/arch/mips/kernel/module.c b/arch/mips/kernel/module.c
index 6f51dda..bb9cde4 100644
--- a/arch/mips/kernel/module.c
+++ b/arch/mips/kernel/module.c
@@ -30,6 +30,8 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/jump_label.h>
+
 #include <asm/pgtable.h>	/* MODULE_START */
 
 struct mips_hi16 {
@@ -390,6 +392,9 @@ int module_finalize(const Elf_Ehdr *hdr,
 	const Elf_Shdr *s;
 	char *secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
 
+	/* Make jump label nops. */
+	jump_label_apply_nops(me);
+
 	INIT_LIST_HEAD(&me->arch.dbe_list);
 	for (s = sechdrs; s < sechdrs + hdr->e_shnum; s++) {
 		if (strcmp("__dbe_table", secstrings + s->sh_name) != 0)
-- 
1.7.1


