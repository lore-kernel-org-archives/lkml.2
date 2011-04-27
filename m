Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110Ab1D0PYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:24:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:34674 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932465Ab1D0PYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:24:31 -0400
Date: Wed, 27 Apr 2011 15:24:02 GMT
From: tip-bot for Jan Glauber <jang@linux.vnet.ibm.com>
Message-ID: <tip-5373db886b791b2bc7811e2c115377916c409a5d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com,
        jang@linux.vnet.ibm.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jang@linux.vnet.ibm.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
        schwidefsky@de.ibm.com, tglx@linutronix.de
In-Reply-To: <6935d2c41ce111e1719176ed4bbd3dbe4de80855.1300299760.git.jbaron@redhat.com>
References: <6935d2c41ce111e1719176ed4bbd3dbe4de80855.1300299760.git.jbaron@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] jump label: Add s390 support
Git-Commit-ID: 5373db886b791b2bc7811e2c115377916c409a5d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 15:24:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5373db886b791b2bc7811e2c115377916c409a5d
Gitweb:     http://git.kernel.org/tip/5373db886b791b2bc7811e2c115377916c409a5d
Author:     Jan Glauber <jang@linux.vnet.ibm.com>
AuthorDate: Wed, 16 Mar 2011 15:58:30 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 4 Apr 2011 13:43:16 -0400

jump label: Add s390 support

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
