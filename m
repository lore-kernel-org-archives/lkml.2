Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab0DJGQO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 02:16:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44716
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896Ab0DJGQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 02:16:07 -0400
Date: Fri, 09 Apr 2010 23:16:07 -0700 (PDT)
Message-Id: <20100409.231607.267279645.davem@davemloft.net>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com
Subject: Re: [PATCH 0/9] jump label v6
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1270839564.git.jbaron@redhat.com>
References: <cover.1270839564.git.jbaron@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I took a stab at implementing this on sparc64 but there are just
too many x86-specific references in kernel/jump_label.c to even
build this on non-x86 currently.

Please abstract out all of that ideal nop business so that whatever
values you need can be specified in the asm/jump_label.h header.
Probably what you want is the nop sequence size.  Fine, call it
JUMP_LABEL_NOP_SIZE and define it in asm/jump_label.h

Also, kernel/jump_label.c is built unconditionally, and thus
linux/jump_label.h is included unconditionally, but that
unconditionally includes asm/jump_label.h which will break the
build on every platform that hasn't implemented the header file
yet.

Once you sort this out the patch below will probably work, once the
nop size defines have been added (sparc will use 2 nops so the
sequence is 8 bytes).

Finally, please abstract out the jump label and string address
type.  Even on 64-bit sparc all of the kernel addresses are 32-bits
so we can use "u32" for all of the addresses jump label wants to
record.  This will decrease the jump label section size.  There is
at least one other 64-bit platform that can benefit from this,
which I think is s390x if I'm not mistaken.

Thanks.

--------------------
sparc64: Add jump_label support.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/include/asm/jump_label.h |   24 ++++++++++++++++++++++++
 arch/sparc/kernel/Makefile          |    2 ++
 arch/sparc/kernel/jump_label.c      |   29 +++++++++++++++++++++++++++++
 arch/sparc/kernel/module.c          |    6 ++++++
 4 files changed, 61 insertions(+), 0 deletions(-)
 create mode 100644 arch/sparc/include/asm/jump_label.h
 create mode 100644 arch/sparc/kernel/jump_label.c

diff --git a/arch/sparc/include/asm/jump_label.h b/arch/sparc/include/asm/jump_label.h
new file mode 100644
index 0000000..efcd950
--- /dev/null
+++ b/arch/sparc/include/asm/jump_label.h
@@ -0,0 +1,24 @@
+#ifndef _ASM_SPARC_JUMP_LABEL_H
+#define _ASM_SPARC_JUMP_LABEL_H
+
+#if (__GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 5))
+# define __HAVE_ARCH_JUMP_LABEL
+#endif
+
+#ifdef __HAVE_ARCH_JUMP_LABEL
+
+# define JUMP_LABEL(tag, label, cond)				\
+	do {							\
+		extern const char __jlstrtab_##tag[];		\
+		asm goto("1:\n\t"				\
+			 "nop\n\t"				\
+			 "nop\n\t"				\
+			 ".pushsection __jump_table,  \"a\"\n\t"\
+			 ".xword 1b, %l[" #label "], %c0\n\t"	\
+			 ".popsection \n\t"			\
+			 : :  "i" (__jlstrtab_##tag) :  : label);\
+	} while (0)
+
+# endif
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
index 0000000..c636ccf
--- /dev/null
+++ b/arch/sparc/kernel/jump_label.c
@@ -0,0 +1,29 @@
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/mutex.h>
+#include <linux/cpu.h>
+
+#include <linux/jump_label.h>
+#include <linux/memory.h>
+
+#ifdef __HAVE_ARCH_JUMP_LABEL
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
+#endif
diff --git a/arch/sparc/kernel/module.c b/arch/sparc/kernel/module.c
index 0ee642f..469f380 100644
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
1.6.6.1

