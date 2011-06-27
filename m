Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab1F0Nmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 09:42:35 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47948 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab1F0NmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 09:42:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TQxmsSba/NXRhQ5kyY48LCCwIDpkoa3EXwh1XswV4M/9VmkKGS6AIRy+nR/oIxlQwN
         DBclGMEDeENBOe3I6/9hoAKxdQdhe+WsVt8QAPEbba4rncy8WZWlt2rpMC/tx4MuXrOC
         7FNj8n+U+sU5gb0JviddUaeKFmscsnSsxP8dY=
From: Geunsik Lim <leemgs1@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Hugh Dickins <hughd@google.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: [PATCH V2 1/4] munmap: mem unmap operation size handling
Date: Mon, 27 Jun 2011 22:41:53 +0900
Message-Id: <1309182116-26698-2-git-send-email-leemgs1@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1309182116-26698-1-git-send-email-leemgs1@gmail.com>
References: <1309182116-26698-1-git-send-email-leemgs1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geunsik Lim <geunsik.lim@samsung.com>

The specification of H/W(CPU, memory, I/O bandwidth, etc) is different
according to their SOC. We can earn a suitable performance(or latency)
after adjust memory unmap size by selecting an optimal value to consider
specified system environment in real world.

In other words, We can get real-fast or real-time using the Linux kernel
tunable parameter choosingly for flexible memory unmap operation unit.

Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
Acked-by: Hyunjin Choi <hj89.choi@samsung.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Steven Rostedt <rostedt@redhat.com>
CC: Hugh Dickins <hughd@google.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>
---
 include/linux/munmap_unit_size.h |   24 ++++++++++++++++
 mm/Makefile                      |    4 ++-
 mm/memory.c                      |   21 +++++++++++-----
 mm/munmap_unit_size.c            |   57 ++++++++++++++++++++++++++++++++++++++
 
 4 files changed, 84 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/munmap_unit_size.h
 create mode 100644 mm/munmap_unit_size.c

diff --git a/include/linux/munmap_unit_size.h b/include/linux/munmap_unit_size.h
new file mode 100644
index 0000000..c4f1fd4
--- /dev/null
+++ b/include/linux/munmap_unit_size.h
@@ -0,0 +1,24 @@
+/*
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ *
+ *	Due to this file being licensed under the GPL there is controversy over
+ *	whether this permits you to write a module that #includes this file
+ *	without placing your module under the GPL.  Please consult a lawyer for
+ *	advice before doing this.
+ *
+ */
+
+#ifdef CONFIG_MMU
+extern unsigned long munmap_unit_size;
+extern unsigned long sysctl_munmap_unit_size;
+#else
+#define sysctl_munmap_unit_size	0UL
+#endif
+
+#ifdef CONFIG_MMU
+extern int munmap_unit_size_handler(struct ctl_table *table, int write,
+				 void __user *buffer, size_t *lenp, loff_t *ppos);
+#endif


diff --git a/mm/Makefile b/mm/Makefile
index 42a8326..4b55b6c 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -5,7 +5,9 @@
 mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= fremap.o highmem.o madvise.o memory.o mincore.o \
 			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
-			   vmalloc.o pagewalk.o pgtable-generic.o
+			   vmalloc.o pagewalk.o pgtable-generic.o  \
+			   munmap_unit_size.o
+
 
 obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
 			   maccess.o page_alloc.o page-writeback.o \
diff --git a/mm/memory.c b/mm/memory.c
index ce22a25..8573cb6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -57,6 +57,7 @@
 #include <linux/swapops.h>
 #include <linux/elf.h>
 #include <linux/gfp.h>
+#include <linux/munmap_unit_size.h>
 
 #include <asm/io.h>
 #include <asm/pgalloc.h>
@@ -1088,12 +1089,10 @@ static unsigned long unmap_page_range(struct mmu_gather *tlb,
 	return addr;
 }
 
-#ifdef CONFIG_PREEMPT
-# define ZAP_BLOCK_SIZE	(8 * PAGE_SIZE)
-#else
-/* No preempt: go for improved straight-line efficiency */
-# define ZAP_BLOCK_SIZE	(1024 * PAGE_SIZE)
-#endif
+/* No preempt: go for improved straight-line efficiency
+ * on PREEMPT(preemptive mode) this is not a critical latency-path.
+ */
+# define ZAP_BLOCK_SIZE        (munmap_unit_size * PAGE_SIZE)
 
 /**
  * unmap_vmas - unmap a range of memory covered by a list of vma's
diff --git a/mm/munmap_unit_size.c b/mm/munmap_unit_size.c
new file mode 100644
index 0000000..1a2a2c6
--- /dev/null
+++ b/mm/munmap_unit_size.c
@@ -0,0 +1,57 @@
+/*
+ * Memory Unmap Operation Unit Interface
+ * (C) Geunsik Lim, April 2011
+ */
+
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/munmap_unit_size.h>
+#include <linux/sysctl.h>
+
+/* amount of vm to unmap from userspace access by both non-preemptive mode
+ * and preemptive mode
+ */
+unsigned long munmap_unit_size;
+
+/*
+ * Memory unmap operation unit of vm to release allocated memory size from
+ * userspace using  mmap system call
+ */
+#if !defined(CONFIG_PREEMPT_VOLUNTARY) && !defined(CONFIG_PREEMPT)
+unsigned long sysctl_munmap_unit_size = CONFIG_PREEMPT_NO_MUNMAP_RANGE;
+#else
+unsigned long sysctl_munmap_unit_size = CONFIG_PREEMPT_OK_MUNMAP_RANGE;
+#endif
+
+/*
+ * Update munmap_unit_size that changed with /proc/sys/vm/munmap_unit_size
+ * tunable value.
+ */
+static void update_munmap_unit_size(void)
+{
+	munmap_unit_size = sysctl_munmap_unit_size;
+}
+
+/*
+ * sysctl handler which just sets sysctl_munmap_unit_size = the new value
+ * and then calls update_munmap_unit_size()
+ */
+int munmap_unit_size_handler(struct ctl_table *table, int write,
+			  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret;
+
+	ret = proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
+
+	update_munmap_unit_size();
+
+	return ret;
+}
+
+static int __init init_munmap_unit_size(void)
+{
+	update_munmap_unit_size();
+
+	return 0;
+}
+pure_initcall(init_munmap_unit_size);
-- 
1.7.3.4

