Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab1DTQAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 12:00:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35382 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab1DTQAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 12:00:35 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=vhdKIqpQuCYA:10 a=prTxL4AU0icA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=4qoakChLQat5bWICsiMA:9 a=VXGBcFrE9DCv4uNuMoIA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110420160031.635736395@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Apr 2011 11:58:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>, Jan Glauber <jang@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 6/6] jump label: Add s390 support
References: <20110420155838.640017971@goodmis.org>
Content-Disposition: inline; filename=0006-jump-label-Add-s390-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Glauber <jang@linux.vnet.ibm.com>

Implement the architecture backend for jump label support on s390.

For a shared kernel booted from a NSS silently disable jump labels
because the NSS is read-only. Therefore jump labels will be disabled
in a shared kernel and can't be activated.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
LKML-Reference: <6935d2c41ce111e1719176ed4bbd3dbe4de80855.1300299760.git.jbaron@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/s390/Kconfig                  |    1 +
 arch/s390/include/asm/jump_label.h |   37 ++++++++++++++++++++++
 arch/s390/kernel/Makefile          |    2 +-
 arch/s390/kernel/jump_label.c      |   59 ++++++++++++++++++++++++++++++++++++
 4 files changed, 98 insertions(+), 1 deletions(-)
 create mode 100644 arch/s390/include/asm/jump_label.h
 create mode 100644 arch/s390/kernel/jump_label.c

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 2508a6f..4a7f140 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -88,6 +88,7 @@ config S390
 	select HAVE_KERNEL_XZ
 	select HAVE_GET_USER_PAGES_FAST
 	select HAVE_ARCH_MUTEX_CPU_RELAX
+	select HAVE_ARCH_JUMP_LABEL if !MARCH_G5
 	select ARCH_INLINE_SPIN_TRYLOCK
 	select ARCH_INLINE_SPIN_TRYLOCK_BH
 	select ARCH_INLINE_SPIN_LOCK
diff --git a/arch/s390/include/asm/jump_label.h b/arch/s390/include/asm/jump_label.h
new file mode 100644
index 0000000..95a6cf2
--- /dev/null
+++ b/arch/s390/include/asm/jump_label.h
@@ -0,0 +1,37 @@
+#ifndef _ASM_S390_JUMP_LABEL_H
+#define _ASM_S390_JUMP_LABEL_H
+
+#include <linux/types.h>
+
+#define JUMP_LABEL_NOP_SIZE 6
+
+#ifdef CONFIG_64BIT
+#define ASM_PTR ".quad"
+#define ASM_ALIGN ".balign 8"
+#else
+#define ASM_PTR ".long"
+#define ASM_ALIGN ".balign 4"
+#endif
+
+static __always_inline bool arch_static_branch(struct jump_label_key *key)
+{
+	asm goto("0:	brcl 0,0\n"
+		".pushsection __jump_table, \"aw\"\n"
+		ASM_ALIGN "\n"
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
diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index 64230bc..5ff15da 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -23,7 +23,7 @@ CFLAGS_sysinfo.o += -Iinclude/math-emu -Iarch/s390/math-emu -w
 obj-y	:=  bitmap.o traps.o time.o process.o base.o early.o setup.o \
 	    processor.o sys_s390.o ptrace.o signal.o cpcmd.o ebcdic.o \
 	    s390_ext.o debug.o irq.o ipl.o dis.o diag.o mem_detect.o \
-	    vdso.o vtime.o sysinfo.o nmi.o sclp.o
+	    vdso.o vtime.o sysinfo.o nmi.o sclp.o jump_label.o
 
 obj-y	+= $(if $(CONFIG_64BIT),entry64.o,entry.o)
 obj-y	+= $(if $(CONFIG_64BIT),reipl64.o,reipl.o)
diff --git a/arch/s390/kernel/jump_label.c b/arch/s390/kernel/jump_label.c
new file mode 100644
index 0000000..44cc06b
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
-- 
1.7.2.3


