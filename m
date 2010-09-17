Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab0IQPJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:09:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab0IQPJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:09:54 -0400
Date: Fri, 17 Sep 2010 11:09:22 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Message-Id: <f838f49f40fbea0254036194be66dc48b598dcea.1284733808.git.jbaron@redhat.com>
In-Reply-To: <cover.1284733808.git.jbaron@redhat.com>
References: <cover.1284733808.git.jbaron@redhat.com>
Subject: [PATCH 08/10] jump label v11: x86 support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add x86 support for jump label. I'm keeping this patch separate so its clear to
arch maintainers what was required for x86 support this new feature. hopefully,
it wouldn't be too painful for other arches.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/x86/Kconfig                  |    1 +
 arch/x86/include/asm/jump_label.h |   47 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/Makefile          |    2 +-
 arch/x86/kernel/jump_label.c      |   49 +++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/module.c          |    3 ++
 5 files changed, 101 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/include/asm/jump_label.h
 create mode 100644 arch/x86/kernel/jump_label.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0c14369..a986079 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -60,6 +60,7 @@ config X86
 	select ANON_INODES
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
+	select HAVE_ARCH_JUMP_LABEL if !CC_OPTIMIZE_FOR_SIZE
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
new file mode 100644
index 0000000..b4a2cb4
--- /dev/null
+++ b/arch/x86/include/asm/jump_label.h
@@ -0,0 +1,47 @@
+#ifndef _ASM_X86_JUMP_LABEL_H
+#define _ASM_X86_JUMP_LABEL_H
+
+#ifdef __KERNEL__
+
+#include <linux/types.h>
+#include <asm/nops.h>
+
+#define JUMP_LABEL_NOP_SIZE 5
+
+# define JUMP_LABEL_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
+
+# define JUMP_LABEL(key, label)					\
+	do {							\
+		asm goto("1:"					\
+			JUMP_LABEL_INITIAL_NOP			\
+			".pushsection __jump_table,  \"a\" \n\t"\
+			_ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
+			".popsection \n\t"			\
+			: :  "i" (key) :  : label);		\
+	} while (0)
+
+#endif /* __KERNEL__ */
+
+#ifdef CONFIG_X86_64
+
+typedef u64 jump_label_t;
+
+struct jump_entry {
+	jump_label_t code;
+	jump_label_t target;
+	jump_label_t key;
+};
+
+#else
+
+typedef u32 jump_label_t;
+
+struct jump_entry {
+	jump_label_t code;
+	jump_label_t target;
+	jump_label_t key;
+};
+
+#endif
+
+#endif
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 11a9925..dfa1443 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -32,7 +32,7 @@ GCOV_PROFILE_paravirt.o		:= n
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time.o ioport.o ldt.o dumpstack.o
-obj-y			+= setup.o x86_init.o i8259.o irqinit.o
+obj-y			+= setup.o x86_init.o i8259.o irqinit.o jump_label.o
 obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
 obj-$(CONFIG_X86_32)	+= probe_roms_32.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
new file mode 100644
index 0000000..b3c0f37
--- /dev/null
+++ b/arch/x86/kernel/jump_label.c
@@ -0,0 +1,49 @@
+/*
+ * jump label x86 support
+ *
+ * Copyright (C) 2009 Jason Baron <jbaron@redhat.com>
+ *
+ */
+#include <linux/jump_label.h>
+#include <linux/memory.h>
+#include <linux/uaccess.h>
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/jhash.h>
+#include <linux/cpu.h>
+#include <asm/kprobes.h>
+#include <asm/alternative.h>
+
+#ifdef HAVE_JUMP_LABEL
+
+union jump_code_union {
+	char code[JUMP_LABEL_NOP_SIZE];
+	struct {
+		char jump;
+		int offset;
+	} __attribute__((packed));
+};
+
+void arch_jump_label_transform(struct jump_entry *entry, enum jump_label_type type)
+{
+	union jump_code_union code;
+
+	if (type == JUMP_LABEL_ENABLE) {
+		code.jump = 0xe9;
+		code.offset = entry->target -
+				(entry->code + JUMP_LABEL_NOP_SIZE);
+	} else
+		memcpy(&code, ideal_nop5, JUMP_LABEL_NOP_SIZE);
+	get_online_cpus();
+	mutex_lock(&text_mutex);
+	text_poke_smp((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
+	mutex_unlock(&text_mutex);
+	put_online_cpus();
+}
+
+void arch_jump_label_text_poke_early(jump_label_t addr)
+{
+	text_poke_early((void *)addr, ideal_nop5, JUMP_LABEL_NOP_SIZE);
+}
+
+#endif
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index e0bc186..5399f58 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -239,6 +239,9 @@ int module_finalize(const Elf_Ehdr *hdr,
 		apply_paravirt(pseg, pseg + para->sh_size);
 	}
 
+	/* make jump label nops */
+	jump_label_apply_nops(me);
+
 	return module_bug_finalize(hdr, sechdrs, me);
 }
 
-- 
1.7.1

