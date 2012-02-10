Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237Ab2BJL0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 06:26:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759180Ab2BJLZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 06:25:55 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] unwind, api: Add unwind interface and implementation for x86_64
Date: Fri, 10 Feb 2012 12:25:18 +0100
Message-Id: <1328873119-21553-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1328873119-21553-1-git-send-email-jolsa@redhat.com>
References: <1328873119-21553-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding unwind interface with x86_64 implementation.
The interface consists of following functions:

struct unw_t;
- single backtrace handle

void unw_init(struct unw_t *u);
- initialize the handle

void unw_regs(struct unw_t *u, struct pt_regs *regs);
- returns current struct pt_regs registers data

int  unw_step(struct unw_t *u);
- makes single backtrace step

void unw_backtrace(void);
- runs the backtrace unwind and printk it out

The example usage is shown in unw_backtrace function.
---
 arch/x86/include/asm/unwind.h    |   14 +++
 arch/x86/kernel/Makefile         |    1 +
 arch/x86/kernel/unwind_init_64.S |   31 +++++++
 include/linux/unwind.h           |   23 +++++
 kernel/Makefile                  |    1 +
 kernel/unwind.c                  |  180 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 250 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/unwind.h
 create mode 100644 arch/x86/kernel/unwind_init_64.S
 create mode 100644 include/linux/unwind.h
 create mode 100644 kernel/unwind.c

diff --git a/arch/x86/include/asm/unwind.h b/arch/x86/include/asm/unwind.h
new file mode 100644
index 0000000..beab2f7
--- /dev/null
+++ b/arch/x86/include/asm/unwind.h
@@ -0,0 +1,14 @@
+#ifndef _ARCH_X86_KERNEL_UNWIND_H
+#define _ARCH_X86_KERNEL_UNWIND_H
+
+#include <asm/ptrace-abi.h>
+
+#ifdef __ASSEMBLY__
+#ifdef __i386__
+#define UNW_X86_CFA_OFF 	(FRAME_SIZE + 0x0)
+#else
+#define UNW_X86_64_CFA_OFF 	(FRAME_SIZE + 0x0)
+#endif /* __i386__ */
+#endif /* __ASSEMBLY__ */
+
+#endif  /* _ARCH_X86_KERNEL_UNWIND_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 8a7c0ec..a77fff3 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -101,6 +101,7 @@ obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
 obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
 obj-$(CONFIG_OF)			+= devicetree.o
 obj-$(CONFIG_UNWIND)			+= dwarf.o
+obj-$(CONFIG_UNWIND)			+= unwind_init_$(BITS).o
 
 ###
 # 64 bit specific files
diff --git a/arch/x86/kernel/unwind_init_64.S b/arch/x86/kernel/unwind_init_64.S
new file mode 100644
index 0000000..4c8c9ed
--- /dev/null
+++ b/arch/x86/kernel/unwind_init_64.S
@@ -0,0 +1,31 @@
+
+#include <linux/linkage.h>
+#include <asm/ptrace-abi.h>
+#include <asm/unwind.h>
+
+	.code64
+ENTRY(unw_init)
+	/* Callee saved: RBX, RBP, R12-R15  */
+	movq %r12, R12(%rdi)
+	movq %r13, R13(%rdi)
+	movq %r14, R14(%rdi)
+	movq %r15, R15(%rdi)
+	movq %rbp, RBP(%rdi)
+	movq %rbx, RBX(%rdi)
+
+	movq %r8,  R8(%rdi)
+	movq %r9,  R9(%rdi)
+	movq %rdi, RDI(%rdi)
+	movq %rsi, RSI(%rdi)
+	movq %rdx, RDX(%rdi)
+	movq %rax, RAX(%rdi)
+	movq %rcx, RCX(%rdi)
+
+	leaq 8(%rsp), %rax /* exclude this call.  */
+	movq %rax, UNW_X86_64_CFA_OFF(%rdi)
+	movq 0(%rsp), %rax
+	movq %rax, RIP(%rdi)
+
+	xorq %rax, %rax
+	retq
+END(unw_init)
diff --git a/include/linux/unwind.h b/include/linux/unwind.h
new file mode 100644
index 0000000..d99b028
--- /dev/null
+++ b/include/linux/unwind.h
@@ -0,0 +1,23 @@
+#ifndef UNWIND_H
+#define UNWIND_H
+
+#include <linux/ptrace.h>
+#include <asm/unwind.h>
+#include <linux/dwarf.h>
+
+struct unw_t {
+	struct pt_regs regs;
+	dwarf_word_t cfa;
+
+	/*
+	 * First 2 items are touched by assembly code,
+	 * do not move them.
+	 */
+};
+
+void unw_init(struct unw_t *u);
+void unw_regs(struct unw_t *u, struct pt_regs *regs);
+int  unw_step(struct unw_t *u);
+void unw_backtrace(void);
+
+#endif /* UNWIND_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index 3ddbc72..d472f4e 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -112,6 +112,7 @@ obj-$(CONFIG_UNWIND) += dwarf-read.o
 obj-$(CONFIG_UNWIND) += dwarf-cfi.o
 obj-$(CONFIG_UNWIND) += dwarf-expression.o
 obj-$(CONFIG_UNWIND) += dwarf-fde.o
+obj-$(CONFIG_UNWIND) += unwind.o
 
 $(obj)/configs.o: $(obj)/config_data.h
 
diff --git a/kernel/unwind.c b/kernel/unwind.c
new file mode 100644
index 0000000..f5191d5
--- /dev/null
+++ b/kernel/unwind.c
@@ -0,0 +1,180 @@
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/debugfs.h>
+#include <linux/unwind.h>
+#include <linux/dwarf.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/completion.h>
+
+struct table_entry {
+	int32_t start_ip_offset;
+	int32_t fde_offset;
+};
+
+static struct table_entry* 	table_data;
+static dwarf_word_t 		table_count;
+static dwarf_word_t		table_base;
+
+static struct table_entry*
+lookup(dwarf_word_t ip)
+{
+	struct table_entry *fde = NULL;
+	unsigned long lo, hi, mid;
+
+	ip -= table_base;
+
+	/* Do a binary search for right entry. */
+	for (lo = 0, hi = table_count; lo < hi;)
+	{
+		mid = (lo + hi) / 2;
+		fde = table_data + mid;
+
+		if (ip < fde->start_ip_offset)
+			hi = mid;
+		else
+			lo = mid + 1;
+	}
+
+	if (hi <= 0)
+		return NULL;
+
+	fde = table_data + hi - 1;
+	return fde;
+}
+
+#ifdef CONFIG_UNWIND_EH_FRAME
+extern char __eh_frame_hdr_start[];
+extern char __eh_frame_hdr_end[];
+extern char __eh_frame_start[];
+extern char __eh_frame_end[];
+
+struct eh_frame_hdr {
+	unsigned char version;
+	unsigned char eh_frame_ptr_enc;
+	unsigned char fde_count_enc;
+	unsigned char table_enc;
+};
+
+static int __init eh_frame_init(void)
+{
+	struct eh_frame_hdr *hdr;
+	dwarf_word_t addr, eh_frame_start;
+
+	hdr = (struct eh_frame_hdr *) __eh_frame_hdr_start;
+	addr = (dwarf_word_t) (hdr + 1);
+
+	if (dwarf_read_pointer(&addr, hdr->eh_frame_ptr_enc,
+			       &eh_frame_start)) {
+		printk("unwind failed to read eh_frame_start\n");
+		goto failed;
+	}
+
+	if (dwarf_read_pointer(&addr, hdr->fde_count_enc,
+			       &table_count)) {
+		printk("unwind failed to read fde_count\n");
+		goto failed;
+	}
+
+	if (hdr->table_enc != (DW_EH_PE_datarel | DW_EH_PE_sdata4)) {
+		printk("unwind unexpected table_enc\n");
+		goto failed;
+	}
+
+	table_data = (struct table_entry *) addr;
+	table_base = (dwarf_word_t) hdr;
+
+	printk("unwind __eh_frame_hdr_start  %p\n", __eh_frame_hdr_start);
+	printk("unwind __eh_frame_hdr_end    %p\n", __eh_frame_hdr_end);
+	printk("unwind __eh_frame_start      %p\n", __eh_frame_start);
+	printk("unwind __eh_frame_en         %p\n", __eh_frame_end);
+	printk("unwind version               %x\n", hdr->version);
+	printk("unwind eh_frame_ptr_enc      %x\n", hdr->eh_frame_ptr_enc);
+	printk("unwind fde_count_enc         %x\n", hdr->fde_count_enc);
+	printk("unwind table_enc             %x\n", hdr->table_enc);
+	printk("unwind table_data            %p\n", table_data);
+	printk("unwind table_count           %llx\n", table_count);
+	printk("unwind table_base            %llx\n", table_base);
+
+	printk("unwind eh_frame table initialized\n");
+	return 0;
+
+ failed:
+	printk("unwind table initialization failed\n");
+	return -EINVAL;
+}
+#endif /* CONFIG_UNWIND_EH_FRAME */
+
+static int __init unw_init_table(void)
+{
+#ifdef CONFIG_UNWIND_EH_FRAME
+	return eh_frame_init();
+#endif
+	return -EINVAL;
+}
+
+pure_initcall(unw_init_table);
+
+__weak void unw_init(struct unw_t *u)
+{
+}
+
+static void dwarf_regs_get(struct unw_t *u, struct dwarf_regs *regs)
+{
+	regs->cfa = u->cfa;
+	dwarf_regs_pt2dwarf(&u->regs, regs);
+}
+
+static void dwarf_regs_set(struct unw_t *u, struct dwarf_regs *regs)
+{
+	u->cfa = regs->cfa;
+	dwarf_regs_dwarf2pt(regs, &u->regs);
+}
+
+int unw_step(struct unw_t *u)
+{
+	struct table_entry *entry;
+	struct dwarf_fde fde;
+	struct dwarf_regs regs;
+	void *data;
+	int ret;
+
+	entry = lookup(u->regs.ip);
+	if (!entry)
+		return -EINVAL;
+
+	data = (void *) (table_base + entry->fde_offset);
+
+	ret = dwarf_fde_init(&fde, data);
+	if (ret)
+		return ret;
+
+	dwarf_regs_get(u, &regs);
+
+	ret = dwarf_fde_process(&fde, &regs);
+	if (!ret)
+		dwarf_regs_set(u, &regs);
+
+	return ret;
+}
+
+void unw_regs(struct unw_t *u, struct pt_regs *regs)
+{
+	memcpy(regs, &u->regs, sizeof(u->regs));
+}
+
+void unw_backtrace(void)
+{
+	struct unw_t unw;
+	struct pt_regs regs;
+
+	unw_init(&unw);
+
+	printk("unwind backtrace:\n");
+
+	do {
+		unw_regs(&unw, &regs);
+		printk("    [0x%lx] %pS\n", regs.ip, (void *) regs.ip);
+	} while (!unw_step(&unw));
+
+}
-- 
1.7.1

