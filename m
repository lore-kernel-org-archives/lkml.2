Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab0CVQII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:08:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924Ab0CVQIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:08:04 -0400
Date: Mon, 22 Mar 2010 12:07:28 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com
Message-Id: <5492858ead53ab5c67d11acc620001abe8d36bcb.1269272444.git.jbaron@redhat.com>
In-Reply-To: <cover.1269272444.git.jbaron@redhat.com>
References: <cover.1269272444.git.jbaron@redhat.com>
Subject: [PATCH 3/5] jump label: x86 support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add x86 support for jump label. I'm keeping this patch separate so its clear to
arch maintainers what was required for x86 support this new feature. hopefully,
it wouldn't be too painful for other arches.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/x86/include/asm/jump_label.h |   31 +++++++++++++++++++++
 arch/x86/kernel/Makefile          |    2 +-
 arch/x86/kernel/jump_label.c      |   53 +++++++++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/include/asm/jump_label.h
 create mode 100644 arch/x86/kernel/jump_label.c

diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
new file mode 100644
index 0000000..b8ebdc8
--- /dev/null
+++ b/arch/x86/include/asm/jump_label.h
@@ -0,0 +1,31 @@
+#ifndef _ASM_X86_JUMP_LABEL_H
+#define _ASM_X86_JUMP_LABEL_H
+
+#include <asm/nops.h>
+
+#if (__GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 5))
+# define __HAVE_ARCH_JUMP_LABEL
+#endif
+
+#ifdef __HAVE_ARCH_JUMP_LABEL
+
+# ifdef CONFIG_X86_64
+#  define JUMP_LABEL_NOP P6_NOP5
+# else
+#  define JUMP_LABEL_NOP ".byte 0xe9 \n\t .long 0\n\t"
+# endif
+
+# define JUMP_LABEL(tag, label, cond)				\
+	do {							\
+		extern const char __jlstrtab_##tag[];		\
+		asm goto("1:"					\
+			JUMP_LABEL_NOP				\
+			".pushsection __jump_table,  \"a\" \n\t"\
+			_ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
+			".popsection \n\t"			\
+			: :  "i" (__jlstrtab_##tag) :  : label);\
+	} while (0)
+
+# endif
+
+#endif
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 4c58352..7cd3bf4 100644
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
index 0000000..7fc4f84
--- /dev/null
+++ b/arch/x86/kernel/jump_label.c
@@ -0,0 +1,53 @@
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
+
+#ifdef __HAVE_ARCH_JUMP_LABEL
+
+union jump_code_union {
+	char code[RELATIVEJUMP_SIZE];
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
+		code.offset = entry->target - (entry->code + RELATIVEJUMP_SIZE);
+	} else {
+#ifdef CONFIG_X86_64
+		/* opcode for P6_NOP5 */
+		code.code[0] = 0x0f;
+		code.code[1] = 0x1f;
+		code.code[2] = 0x44;
+		code.code[3] = 0x00;
+		code.code[4] = 0x00;
+#else
+		code.jump = 0xe9;
+		code.offset = 0;
+#endif
+	}
+	get_online_cpus();
+	mutex_lock(&text_mutex);
+	text_poke_smp((void *)entry->code, &code, RELATIVEJUMP_SIZE);
+	mutex_unlock(&text_mutex);
+	put_online_cpus();
+}
+
+#endif
-- 
1.6.5.1

