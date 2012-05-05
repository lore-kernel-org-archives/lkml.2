Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab2EETDD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:03:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54582 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2EETDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:03:00 -0400
Date: Sat, 5 May 2012 12:02:48 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-c39f52a9edc5e0687cbb54c08bcd78cf7fe26b62@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jejb@parisc-linux.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jejb@parisc-linux.org, tglx@linutronix.de
In-Reply-To: <20120503085035.150896946@linutronix.de>
References: <20120503085035.150896946@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] parisc: Use generic init_task
Git-Commit-ID: c39f52a9edc5e0687cbb54c08bcd78cf7fe26b62
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 12:02:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c39f52a9edc5e0687cbb54c08bcd78cf7fe26b62
Gitweb:     http://git.kernel.org/tip/c39f52a9edc5e0687cbb54c08bcd78cf7fe26b62
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:02:57 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:24 +0200

parisc: Use generic init_task

Same code, except: The alignment of init_thread_union is handled via
the linker script, so no point to have it with the data structure. The
extra asm(".data") looks like a leftover from an asm to C conversion
and is pointless.

Use the generic version.

Move the page table data to parisc/mm/init.c and get rid of
parisc/../init_task.c

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Link: http://lkml.kernel.org/r/20120503085035.150896946@linutronix.de
---
 arch/parisc/Kconfig            |    1 +
 arch/parisc/kernel/init_task.c |   70 ----------------------------------------
 arch/parisc/mm/init.c          |   12 +++++++
 3 files changed, 13 insertions(+), 70 deletions(-)

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index ddb8b24..4c6ca0d 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -18,6 +18,7 @@ config PARISC
 	select IRQ_PER_CPU
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
+	select HAVE_GENERIC_INIT_TASK
 
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
diff --git a/arch/parisc/kernel/init_task.c b/arch/parisc/kernel/init_task.c
deleted file mode 100644
index 4a91e43..0000000
--- a/arch/parisc/kernel/init_task.c
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
diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index 82f364e..3ac462d 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
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
