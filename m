Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab2D3UTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:19:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:35769 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858Ab2D3UQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:16:02 -0400
Message-Id: <20120430194846.659416196@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 30 Apr 2012 20:16:00 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, "James E.J. Bottomley" <jejb@parisc-linux.org>
Subject: [patch 18/29] parisc: Use generic init_task
References: <20120430194725.763322463@linutronix.de>
Content-Disposition: inline; filename=parisc-use-generic-init-task.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same code, except: The alignment of init_thread_union is handled via
the linker script, so no point to have it with the data structure. The
extra asm(".data") looks like a leftover from an asm to C conversion
and is pointless.

Use the generic version.

Move the page table data to parisc/mm/init.c and get rid of
parisc/../init_task.c

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
---
 arch/parisc/Kconfig            |    1 
 arch/parisc/kernel/init_task.c |   70 -----------------------------------------
 arch/parisc/mm/init.c          |   12 +++++++
 3 files changed, 13 insertions(+), 70 deletions(-)

Index: tip/arch/parisc/Kconfig
===================================================================
--- tip.orig/arch/parisc/Kconfig
+++ tip/arch/parisc/Kconfig
@@ -18,6 +18,7 @@ config PARISC
 	select IRQ_PER_CPU
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
+	select HAVE_GENERIC_INIT_TASK
 
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
Index: tip/arch/parisc/kernel/init_task.c
===================================================================
--- tip.orig/arch/parisc/kernel/init_task.c
+++ /dev/null
@@ -1,70 +0,0 @@
-/* 
- *    Static declaration of "init" task data structure.
- *
- *    Copyright (C) 2000 Paul Bame <bame at parisc-linux.org>
- *    Copyright (C) 2000-2001 John Marvin <jsm at parisc-linux.org>
- *    Copyright (C) 2001 Helge Deller <deller @ parisc-linux.org>
- *    Copyright (C) 2002 Matthew Wilcox <willy with parisc-linux.org>
- *
- *
- *    This program is free software; you can redistribute it and/or modify
- *    it under the terms of the GNU General Public License as published by
- *    the Free Software Foundation; either version 2 of the License, or
- *    (at your option) any later version.
- *
- *    This program is distributed in the hope that it will be useful,
- *    but WITHOUT ANY WARRANTY; without even the implied warranty of
- *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *    GNU General Public License for more details.
- *
- *    You should have received a copy of the GNU General Public License
- *    along with this program; if not, write to the Free Software
- *    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#include <linux/mm.h>
-#include <linux/fs.h>
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/init_task.h>
-#include <linux/mqueue.h>
-
-#include <asm/uaccess.h>
-#include <asm/pgtable.h>
-#include <asm/pgalloc.h>
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-/*
- * Initial task structure.
- *
- * We need to make sure that this is 16384-byte aligned due to the
- * way process stacks are handled. This is done by having a special
- * "init_task" linker map entry..
- */
-union thread_union init_thread_union __init_task_data
-	__attribute__((aligned(128))) =
-		{ INIT_THREAD_INFO(init_task) };
-
-#if PT_NLEVELS == 3
-/* NOTE: This layout exactly conforms to the hybrid L2/L3 page table layout
- * with the first pmd adjacent to the pgd and below it. gcc doesn't actually
- * guarantee that global objects will be laid out in memory in the same order 
- * as the order of declaration, so put these in different sections and use
- * the linker script to order them. */
-pmd_t pmd0[PTRS_PER_PMD] __attribute__ ((__section__ (".data..vm0.pmd"), aligned(PAGE_SIZE)));
-#endif
-
-pgd_t swapper_pg_dir[PTRS_PER_PGD] __attribute__ ((__section__ (".data..vm0.pgd"), aligned(PAGE_SIZE)));
-pte_t pg0[PT_INITIAL * PTRS_PER_PTE] __attribute__ ((__section__ (".data..vm0.pte"), aligned(PAGE_SIZE)));
-
-/*
- * Initial task structure.
- *
- * All other task structs will be allocated on slabs in fork.c
- */
-EXPORT_SYMBOL(init_task);
-
-__asm__(".data");
-struct task_struct init_task = INIT_TASK(init_task);
Index: tip/arch/parisc/mm/init.c
===================================================================
--- tip.orig/arch/parisc/mm/init.c
+++ tip/arch/parisc/mm/init.c
@@ -33,6 +33,18 @@
 
 extern int  data_start;
 
+#if PT_NLEVELS == 3
+/* NOTE: This layout exactly conforms to the hybrid L2/L3 page table layout
+ * with the first pmd adjacent to the pgd and below it. gcc doesn't actually
+ * guarantee that global objects will be laid out in memory in the same order
+ * as the order of declaration, so put these in different sections and use
+ * the linker script to order them. */
+pmd_t pmd0[PTRS_PER_PMD] __attribute__ ((__section__ (".data..vm0.pmd"), aligned(PAGE_SIZE)));
+#endif
+
+pgd_t swapper_pg_dir[PTRS_PER_PGD] __attribute__ ((__section__ (".data..vm0.pgd"), aligned(PAGE_SIZE)));
+pte_t pg0[PT_INITIAL * PTRS_PER_PTE] __attribute__ ((__section__ (".data..vm0.pte"), aligned(PAGE_SIZE)));
+
 #ifdef CONFIG_DISCONTIGMEM
 struct node_map_data node_data[MAX_NUMNODES] __read_mostly;
 unsigned char pfnnid_map[PFNNID_MAP_MAX] __read_mostly;


