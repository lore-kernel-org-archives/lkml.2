Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465Ab0FIVkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 17:40:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932624Ab0FIVk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 17:40:29 -0400
Date: Wed, 9 Jun 2010 17:39:41 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
       vgoyal@redhat.com, sam@ravnborg.org
Message-Id: <55dfb1c1694df9a09de30f07594c9e5f129efcb0.1276116186.git.jbaron@redhat.com>
In-Reply-To: <cover.1276116186.git.jbaron@redhat.com>
References: <cover.1276116186.git.jbaron@redhat.com>
Subject: [PATCH 12/13] jump label v9: sparc64 add jump_label support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add jump label support for sparc64.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/sparc/Kconfig                  |    1 +
 arch/sparc/include/asm/jump_label.h |   32 +++++++++++++++++++++++++++++
 arch/sparc/kernel/Makefile          |    2 +
 arch/sparc/kernel/jump_label.c      |   38 +++++++++++++++++++++++++++++++++++
 arch/sparc/kernel/module.c          |    6 +++++
 5 files changed, 79 insertions(+), 0 deletions(-)
 create mode 100644 arch/sparc/include/asm/jump_label.h
 create mode 100644 arch/sparc/kernel/jump_label.c

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 6f1470b..5fb0652 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -29,6 +29,7 @@ config SPARC
 	select PERF_USE_VMALLOC
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
+	select HAVE_ARCH_JUMP_LABEL if !CC_OPTIMIZE_FOR_SIZE
 
 config SPARC32
 	def_bool !64BIT
diff --git a/arch/sparc/include/asm/jump_label.h b/arch/sparc/include/asm/jump_label.h
new file mode 100644
index 0000000..51781f7
--- /dev/null
+++ b/arch/sparc/include/asm/jump_label.h
@@ -0,0 +1,32 @@
+#ifndef _ASM_SPARC_JUMP_LABEL_H
+#define _ASM_SPARC_JUMP_LABEL_H
+
+#ifdef __KERNEL__
+
+#include <linux/types.h>
+#include <asm/jump_entry.h>
+
+#define JUMP_LABEL_NOP_SIZE 4
+
+#define JUMP_LABEL(tag, label)					\
+	do {							\
+		asm goto("1:\n\t"				\
+			 "nop\n\t"				\
+			 "nop\n\t"				\
+			 ".pushsection __jump_table,  \"a\"\n\t"\
+			 ".xword 1b, %l[" #label "], %c0\n\t"	\
+			 ".popsection \n\t"			\
+			 : :  "i" (tag) :  : label);\
+	} while (0)
+
+#endif /* __KERNEL__ */
+
+typedef __u32 jump_label_t;
+
+struct jump_entry {
+	jump_label_t code;
+	jump_label_t target;
+	jump_label_t name;
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
index 0000000..c1aa2d8
--- /dev/null
+++ b/arch/sparc/kernel/jump_label.c
@@ -0,0 +1,38 @@
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
+	u32 val, *insn = (u32 *) entry->code;
+
+	val = *insn;
+	if (type == JUMP_LABEL_ENABLE) {
+		s32 off = (s32)entry->target - (s32)entry->code;
+		val = 0x40000000 | ((u32) off >> 2);
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
+static const u8 jump_label_nop[JUMP_LABEL_NOP_SIZE] = { 0x01, 0x00, 0x00, 0x00 };
+
+const u8 *arch_get_jump_label_nop()
+{
+	return jump_label_nop;
+}
+
+#endif
diff --git a/arch/sparc/kernel/module.c b/arch/sparc/kernel/module.c
index f848aad..37cf439 100644
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
+	apply_jump_label_nops(me);
+
 	/* Cheetah's I-cache is fully coherent.  */
 	if (tlb_type == spitfire) {
 		unsigned long va;
-- 
1.7.1

