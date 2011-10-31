Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934811Ab1KAASJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 20:18:09 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43327 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934197Ab1KAASB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 20:18:01 -0400
Message-Id: <e97c6e$3uab16@wolverine02.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6516"; a="132459558"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Mon, 31 Oct 2011 18:52:00 -0500
Subject: [PATCH v5 26/36] Hexagon: Implement basic TLB management routines for Hexagon.
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly all stubs, as the TLB is managed by the hypervisor.

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/hexagon/include/asm/tlb.h      |   39 +++++++++++++++
 arch/hexagon/include/asm/tlbflush.h |   58 ++++++++++++++++++++++
 arch/hexagon/mm/vm_tlb.c            |   93 +++++++++++++++++++++++++++++++++++
 3 files changed, 190 insertions(+), 0 deletions(-)
 create mode 100644 arch/hexagon/include/asm/tlb.h
 create mode 100644 arch/hexagon/include/asm/tlbflush.h
 create mode 100644 arch/hexagon/mm/vm_tlb.c

diff --git a/arch/hexagon/include/asm/tlb.h b/arch/hexagon/include/asm/tlb.h
new file mode 100644
index 0000000..473abde
--- /dev/null
+++ b/arch/hexagon/include/asm/tlb.h
@@ -0,0 +1,39 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_TLB_H
+#define _ASM_TLB_H
+
+#include <linux/pagemap.h>
+#include <asm/tlbflush.h>
+
+/*
+ * We don't need any special per-pte or per-vma handling...
+ */
+#define tlb_start_vma(tlb, vma)				do { } while (0)
+#define tlb_end_vma(tlb, vma)				do { } while (0)
+#define __tlb_remove_tlb_entry(tlb, ptep, address)	do { } while (0)
+
+/*
+ * .. because we flush the whole mm when it fills up
+ */
+#define tlb_flush(tlb)		flush_tlb_mm((tlb)->mm)
+
+#include <asm-generic/tlb.h>
+
+#endif
diff --git a/arch/hexagon/include/asm/tlbflush.h b/arch/hexagon/include/asm/tlbflush.h
new file mode 100644
index 0000000..b89a902
--- /dev/null
+++ b/arch/hexagon/include/asm/tlbflush.h
@@ -0,0 +1,58 @@
+/*
+ * TLB flush support for Hexagon
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_TLBFLUSH_H
+#define _ASM_TLBFLUSH_H
+
+#include <linux/mm.h>
+#include <asm/processor.h>
+
+/*
+ * TLB flushing -- in "SMP", these routines get defined to be the
+ * ones from smp.c, else they are some local flavors.
+ */
+
+/*
+ * These functions are commonly macros, but in the interests of
+ * VM vs. native implementation and code size, we simply declare
+ * the function prototypes here.
+ */
+extern void tlb_flush_all(void);
+extern void flush_tlb_mm(struct mm_struct *mm);
+extern void flush_tlb_page(struct vm_area_struct *vma, unsigned long addr);
+extern void flush_tlb_range(struct vm_area_struct *vma,
+				unsigned long start, unsigned long end);
+extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
+extern void flush_tlb_one(unsigned long);
+
+/*
+ * "This is called in munmap when we have freed up some page-table pages.
+ * We don't need to do anything here..."
+ *
+ * The VM kernel doesn't walk page tables, and they are passed to the VMM
+ * by logical address. There doesn't seem to be any possibility that they
+ * could be referenced by the VM kernel based on a stale mapping, since
+ * they would only be located by consulting the mm structure, and they
+ * will have been purged from that structure by the munmap.  Seems like
+ * a noop on HVM as well.
+ */
+#define flush_tlb_pgtables(mm, start, end)
+
+#endif
diff --git a/arch/hexagon/mm/vm_tlb.c b/arch/hexagon/mm/vm_tlb.c
new file mode 100644
index 0000000..c6ff415
--- /dev/null
+++ b/arch/hexagon/mm/vm_tlb.c
@@ -0,0 +1,93 @@
+/*
+ * Hexagon Virtual Machine TLB functions
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+/*
+ * The Hexagon Virtual Machine conceals the real workings of
+ * the TLB, but there are one or two functions that need to
+ * be instantiated for it, differently from a native build.
+ */
+#include <linux/mm.h>
+#include <asm/page.h>
+#include <asm/hexagon_vm.h>
+
+/*
+ * Initial VM implementation has only one map active at a time, with
+ * TLB purgings on changes.  So either we're nuking the current map,
+ * or it's a no-op.  This operation is messy on true SMPs where other
+ * processors must be induced to flush the copies in their local TLBs,
+ * but Hexagon thread-based virtual processors share the same MMU.
+ */
+void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
+			unsigned long end)
+{
+	struct mm_struct *mm = vma->vm_mm;
+
+	if (mm->context.ptbase == current->active_mm->context.ptbase)
+		__vmclrmap((void *)start, end - start);
+}
+
+/*
+ * Flush a page from the kernel virtual map - used by highmem
+ */
+void flush_tlb_one(unsigned long vaddr)
+{
+	__vmclrmap((void *)vaddr, PAGE_SIZE);
+}
+
+/*
+ * Flush all TLBs across all CPUs, virtual or real.
+ * A single Hexagon core has 6 thread contexts but
+ * only one TLB.
+ */
+void tlb_flush_all(void)
+{
+	/*  should probably use that fixaddr end or whateve label  */
+	__vmclrmap(0, 0xffff0000);
+}
+
+/*
+ * Flush TLB entries associated with a given mm_struct mapping.
+ */
+void flush_tlb_mm(struct mm_struct *mm)
+{
+	/* Current Virtual Machine has only one map active at a time */
+	if (current->active_mm->context.ptbase == mm->context.ptbase)
+		tlb_flush_all();
+}
+
+/*
+ * Flush TLB state associated with a page of a vma.
+ */
+void flush_tlb_page(struct vm_area_struct *vma, unsigned long vaddr)
+{
+	struct mm_struct *mm = vma->vm_mm;
+
+	if (mm->context.ptbase  == current->active_mm->context.ptbase)
+		__vmclrmap((void *)vaddr, PAGE_SIZE);
+}
+
+/*
+ * Flush TLB entries associated with a kernel address range.
+ * Like flush range, but without the check on the vma->vm_mm.
+ */
+void flush_tlb_kernel_range(unsigned long start, unsigned long end)
+{
+		__vmclrmap((void *)start, end - start);
+}
-- 
1.7.1


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
