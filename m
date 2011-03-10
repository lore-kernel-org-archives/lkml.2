Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab1CJQll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:41:41 -0500
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:33013 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab1CJQlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:41:39 -0500
Date: Thu, 10 Mar 2011 17:41:23 +0100
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Jason Baron <jbaron@redhat.com>
Cc: peterz@infradead.org, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
        rostedt@goodmis.org, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        schwidefsky@de.ibm.com
Subject: Re: [PATCH 0/2] jump label: update for .39
Message-ID: <20110310164123.GA19663@hal>
References: <cover.1299702291.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1299702291.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 03:47:24PM -0500, Jason Baron wrote:
> Hi,
> 
> Re-fresh of updates against latest -tip tree.

Hi Jason,

here are the s390 bits, tested successfully on top of your patches
so it would be nice to have this in .39 too.

The s390 support depends on the JUMP_TABLE being in the RW section
which is not the case in .38 and leads to a protection exception
there.

--Jan

Subject: [PATCH] jump_label: Add s390 support
From: Jan Glauber <jang@linux.vnet.ibm.com>

Implement the architecture backend for jump label support on s390.

For a shared kernel booted from a NSS silently disable jump labels
because the NSS is read-only. Therefore jump labels will be disabled
in a shared kernel and can't be activated.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 arch/s390/Kconfig                  |    1 
 arch/s390/include/asm/jump_label.h |   34 +++++++++++++++++++++
 arch/s390/kernel/Makefile          |    2 -
 arch/s390/kernel/jump_label.c      |   59 +++++++++++++++++++++++++++++++++++++
 arch/s390/kernel/module.c          |    1 
 5 files changed, 96 insertions(+), 1 deletion(-)

--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -87,6 +87,7 @@ config S390
 	select HAVE_KERNEL_LZO
 	select HAVE_GET_USER_PAGES_FAST
 	select HAVE_ARCH_MUTEX_CPU_RELAX
+	select HAVE_ARCH_JUMP_LABEL if !MARCH_G5
 	select ARCH_INLINE_SPIN_TRYLOCK
 	select ARCH_INLINE_SPIN_TRYLOCK_BH
 	select ARCH_INLINE_SPIN_LOCK
--- /dev/null
+++ b/arch/s390/include/asm/jump_label.h
@@ -0,0 +1,34 @@
+#ifndef _ASM_S390_JUMP_LABEL_H
+#define _ASM_S390_JUMP_LABEL_H
+
+#include <linux/types.h>
+
+#define JUMP_LABEL_NOP_SIZE 6
+
+#ifdef CONFIG_64BIT
+#define ASM_PTR ".quad"
+#else
+#define ASM_PTR ".long"
+#endif
+
+static __always_inline bool arch_static_branch(struct jump_label_key *key)
+{
+	asm goto("0:	brcl 0,0\n"
+		".pushsection __jump_table, \"aw\"\n"
+		ASM_PTR " 0b, %l[label], %0\n"
+		".popsection\n"
+		: : "X" (key) : : label);
+	return false;
+label:
+	return true;
+}
+
+typedef unsigned long jump_label_t;
+
+struct jump_entry {
+	jump_label_t code;
+	jump_label_t target;
+	jump_label_t key;
+};
+
+#endif
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -23,7 +23,7 @@ CFLAGS_sysinfo.o += -Iinclude/math-emu -
 obj-y	:=  bitmap.o traps.o time.o process.o base.o early.o setup.o \
 	    processor.o sys_s390.o ptrace.o signal.o cpcmd.o ebcdic.o \
 	    s390_ext.o debug.o irq.o ipl.o dis.o diag.o mem_detect.o \
-	    vdso.o vtime.o sysinfo.o nmi.o sclp.o
+	    vdso.o vtime.o sysinfo.o nmi.o sclp.o jump_label.o
 
 obj-y	+= $(if $(CONFIG_64BIT),entry64.o,entry.o)
 obj-y	+= $(if $(CONFIG_64BIT),reipl64.o,reipl.o)
--- /dev/null
+++ b/arch/s390/kernel/jump_label.c
@@ -0,0 +1,59 @@
+/*
+ * Jump label s390 support
+ *
+ * Copyright IBM Corp. 2011
+ * Author(s): Jan Glauber <jang@linux.vnet.ibm.com>
+ */
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/stop_machine.h>
+#include <linux/jump_label.h>
+#include <asm/ipl.h>
+
+#ifdef HAVE_JUMP_LABEL
+
+struct insn {
+	u16 opcode;
+	s32 offset;
+} __packed;
+
+struct insn_args {
+	unsigned long *target;
+	struct insn *insn;
+	ssize_t size;
+};
+
+static int __arch_jump_label_transform(void *data)
+{
+	struct insn_args *args = data;
+	int rc;
+
+	rc = probe_kernel_write(args->target, args->insn, args->size);
+	WARN_ON_ONCE(rc < 0);
+	return 0;
+}
+
+void arch_jump_label_transform(struct jump_entry *entry,
+			       enum jump_label_type type)
+{
+	struct insn_args args;
+	struct insn insn;
+
+	if (type == JUMP_LABEL_ENABLE) {
+		/* brcl 15,offset */
+		insn.opcode = 0xc0f4;
+		insn.offset = (entry->target - entry->code) >> 1;
+	} else {
+		/* brcl 0,0 */
+		insn.opcode = 0xc004;
+		insn.offset = 0;
+	}
+
+	args.target = (void *) entry->code;
+	args.insn = &insn;
+	args.size = JUMP_LABEL_NOP_SIZE;
+
+	stop_machine(__arch_jump_label_transform, &args, NULL);
+}
+
+#endif
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -407,6 +407,7 @@ int module_finalize(const Elf_Ehdr *hdr,
 {
 	vfree(me->arch.syminfo);
 	me->arch.syminfo = NULL;
+	jump_label_apply_nops(me);
 	return 0;
 }
 
