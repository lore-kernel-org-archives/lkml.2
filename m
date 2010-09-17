Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab0IQPKB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:10:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab0IQPJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:09:58 -0400
Date: Fri, 17 Sep 2010 11:09:25 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Message-Id: <3b5b071fcdb2afb7f67cacecfa78b14c740278a7.1284733808.git.jbaron@redhat.com>
In-Reply-To: <cover.1284733808.git.jbaron@redhat.com>
References: <cover.1284733808.git.jbaron@redhat.com>
Subject: [PATCH 09/10] jump label 11: add sparc64 support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add sparc64 support

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/sparc/Kconfig                  |    1 +
 arch/sparc/include/asm/jump_label.h |   32 ++++++++++++++++++++++++
 arch/sparc/kernel/Makefile          |    2 +
 arch/sparc/kernel/jump_label.c      |   46 +++++++++++++++++++++++++++++++++++
 arch/sparc/kernel/module.c          |    6 ++++
 5 files changed, 87 insertions(+), 0 deletions(-)
 create mode 100644 arch/sparc/include/asm/jump_label.h
 create mode 100644 arch/sparc/kernel/jump_label.c

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 491e9d6..a81b04e 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -30,6 +30,7 @@ config SPARC
 	select PERF_USE_VMALLOC
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
+	select HAVE_ARCH_JUMP_LABEL if !CC_OPTIMIZE_FOR_SIZE
 
 config SPARC32
 	def_bool !64BIT
diff --git a/arch/sparc/include/asm/jump_label.h b/arch/sparc/include/asm/jump_label.h
new file mode 100644
index 0000000..62e66d7
--- /dev/null
+++ b/arch/sparc/include/asm/jump_label.h
@@ -0,0 +1,32 @@
+#ifndef _ASM_SPARC_JUMP_LABEL_H
+#define _ASM_SPARC_JUMP_LABEL_H
+
+#ifdef __KERNEL__
+
+#include <linux/types.h>
+#include <asm/system.h>
+
+#define JUMP_LABEL_NOP_SIZE 4
+
+#define JUMP_LABEL(key, label)					\
+	do {							\
+		asm goto("1:\n\t"				\
+			 "nop\n\t"				\
+			 "nop\n\t"				\
+			 ".pushsection __jump_table,  \"a\"\n\t"\
+			 ".word 1b, %l[" #label "], %c0\n\t"	\
+			 ".popsection \n\t"			\
+			 : :  "i" (key) :  : label);\
+	} while (0)
+
+#endif /* __KERNEL__ */
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
diff --git a/arch/sparc/kernel/Makefile b/arch/sparc/kernel/Makefile
index 0c2dc1f..599398f 100644
--- a/arch/sparc/kernel/Makefile
+++ b/arch/sparc/kernel/Makefile
@@ -119,3 +119,5 @@ obj-$(CONFIG_COMPAT)    += $(audit--y)
 
 pc--$(CONFIG_PERF_EVENTS) := perf_event.o
 obj-$(CONFIG_SPARC64)	+= $(pc--y)
+
+obj-$(CONFIG_SPARC64)	+= jump_label.o
diff --git a/arch/sparc/kernel/jump_label.c b/arch/sparc/kernel/jump_label.c
new file mode 100644
index 0000000..00b3fcb
--- /dev/null
+++ b/arch/sparc/kernel/jump_label.c
@@ -0,0 +1,46 @@
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/mutex.h>
+#include <linux/cpu.h>
+
+#include <linux/jump_label.h>
+#include <linux/memory.h>
+
+#ifdef HAVE_JUMP_LABEL
+
+void arch_jump_label_transform(struct jump_entry *entry, enum jump_label_type type)
+{
+	u32 val;
+	u32 *insn = (u32 *) (unsigned long) entry->code;
+
+	if (type == JUMP_LABEL_ENABLE) {
+		s32 off = (s32)entry->target - (s32)entry->code;
+
+#ifdef CONFIG_SPARC64
+		/* ba,pt %xcc, . + (off << 2) */
+		val = 0x10680000 | ((u32) off >> 2);
+#else
+		/* ba . + (off << 2) */
+		val = 0x10800000 | ((u32) off >> 2);
+#endif
+	} else {
+		val = 0x01000000;
+	}
+
+	get_online_cpus();
+	mutex_lock(&text_mutex);
+	*insn = val;
+	flushi(insn);
+	mutex_unlock(&text_mutex);
+	put_online_cpus();
+}
+
+void arch_jump_label_text_poke_early(jump_label_t addr)
+{
+	u32 *insn_p = (u32 *) (unsigned long) addr;
+
+	*insn_p = 0x01000000;
+	flushi(insn_p);
+}
+
+#endif
diff --git a/arch/sparc/kernel/module.c b/arch/sparc/kernel/module.c
index f848aad..ee3c7dd 100644
--- a/arch/sparc/kernel/module.c
+++ b/arch/sparc/kernel/module.c
@@ -18,6 +18,9 @@
 #include <asm/spitfire.h>
 
 #ifdef CONFIG_SPARC64
+
+#include <linux/jump_label.h>
+
 static void *module_map(unsigned long size)
 {
 	struct vm_struct *area;
@@ -227,6 +230,9 @@ int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
 		    struct module *me)
 {
+	/* make jump label nops */
+	jump_label_apply_nops(me);
+
 	/* Cheetah's I-cache is fully coherent.  */
 	if (tlb_type == spitfire) {
 		unsigned long va;
-- 
1.7.1

