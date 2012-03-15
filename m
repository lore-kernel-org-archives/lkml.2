Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032358Ab2COVBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:01:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161760Ab2COVA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:00:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 36/38] Add #includes needed to permit the removal of
 asm/system.h [ver #3]
To: paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>
Date: Thu, 15 Mar 2012 21:00:50 +0000
Message-ID: <20120315210049.28759.21017.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
References: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm/system.h is a cause of circular dependency problems because it contains
commonly used primitive stuff like barrier definitions and uncommonly used
stuff like switch_to() that might require MMU definitions.

asm/system.h has been disintegrated by this point on all arches into the
following common segments:

 (1) asm/barrier.h

     Moved memory barrier definitions here.

 (2) asm/cmpxchg.h

     Moved xchg() and cmpxchg() here.  #included in asm/atomic.h.

 (3) asm/bug.h

     Moved die() and similar here.

 (4) asm/exec.h

     Moved arch_align_stack() here.

 (5) asm/elf.h

     Moved AT_VECTOR_SIZE_ARCH here.

 (6) asm/switch_to.h

     Moved switch_to() here.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/misc/sgi-gru/gru_instructions.h |    1 +
 fs/binfmt_elf.c                         |    1 +
 fs/binfmt_elf_fdpic.c                   |    1 +
 fs/exec.c                               |    1 +
 include/asm-generic/bitops/atomic.h     |    2 +-
 include/linux/llist.h                   |    3 +--
 include/linux/mtd/map.h                 |    1 +
 include/linux/spinlock.h                |    1 +
 kernel/sched/core.c                     |    1 +
 9 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/sgi-gru/gru_instructions.h b/drivers/misc/sgi-gru/gru_instructions.h
index d95587c..04d5170 100644
--- a/drivers/misc/sgi-gru/gru_instructions.h
+++ b/drivers/misc/sgi-gru/gru_instructions.h
@@ -40,6 +40,7 @@ extern void gru_wait_abort_proc(void *cb);
 			*((volatile unsigned long *)(p)) = v; /* force st.rel */	\
 		} while (0)
 #elif defined(CONFIG_X86_64)
+#include <asm/cacheflush.h>
 #define __flush_cache(p)		clflush(p)
 #define gru_ordered_store_ulong(p, v)					\
 		do {							\
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 07d096c..d104261 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -35,6 +35,7 @@
 #include <asm/uaccess.h>
 #include <asm/param.h>
 #include <asm/page.h>
+#include <asm/exec.h>
 
 static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs);
 static int load_elf_library(struct file *);
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 30745f4..c7f277a 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -39,6 +39,7 @@
 #include <asm/uaccess.h>
 #include <asm/param.h>
 #include <asm/pgalloc.h>
+#include <asm/exec.h>
 
 typedef char *elf_caddr_t;
 
diff --git a/fs/exec.c b/fs/exec.c
index 153dee1..0ce48b3 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -59,6 +59,7 @@
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/tlb.h>
+#include <asm/exec.h>
 
 #include <trace/events/task.h>
 #include "internal.h"
diff --git a/include/asm-generic/bitops/atomic.h b/include/asm-generic/bitops/atomic.h
index ecc44a8..9ae6c34 100644
--- a/include/asm-generic/bitops/atomic.h
+++ b/include/asm-generic/bitops/atomic.h
@@ -2,7 +2,7 @@
 #define _ASM_GENERIC_BITOPS_ATOMIC_H_
 
 #include <asm/types.h>
-#include <asm/system.h>
+#include <linux/irqflags.h>
 
 #ifdef CONFIG_SMP
 #include <asm/spinlock.h>
diff --git a/include/linux/llist.h b/include/linux/llist.h
index 801b44b..a5199f6 100644
--- a/include/linux/llist.h
+++ b/include/linux/llist.h
@@ -56,8 +56,7 @@
  */
 
 #include <linux/kernel.h>
-#include <asm/system.h>
-#include <asm/processor.h>
+#include <asm/cmpxchg.h>
 
 struct llist_head {
 	struct llist_node *first;
diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index d9072d9..c409e1b 100644
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -31,6 +31,7 @@
 #include <asm/unaligned.h>
 #include <asm/system.h>
 #include <asm/io.h>
+#include <asm/barrier.h>
 
 #ifdef CONFIG_MTD_MAP_BANK_WIDTH_1
 #define map_bankwidth(map) 1
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 7df6c17..fa0f93e 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -55,6 +55,7 @@
 #include <linux/kernel.h>
 #include <linux/stringify.h>
 #include <linux/bottom_half.h>
+#include <asm/barrier.h>
 
 #include <asm/system.h>
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b342f57..fff13cb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -72,6 +72,7 @@
 #include <linux/slab.h>
 #include <linux/init_task.h>
 
+#include <asm/switch_to.h>
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
 #include <asm/mutex.h>

