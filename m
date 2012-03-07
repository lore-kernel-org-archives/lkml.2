Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974Ab2CGTqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:46:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759921Ab2CGTqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:46:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/29] Disintegrate asm/system.h on all arches
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:46:31 +0000
Message-ID: <20120307194630.15987.97181.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
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

Disintegrate asm/system.h on all arches into the following common segments:

 (1) asm/barrier.h

     Memory barrier stuff - already done for MIPS and Alpha.

 (2) asm/atomic.h

     Move xchg() and cmpxchg() here as they're atomic ops.

 (3) asm/bug.h

     Move die() and similar here.

 (4) asm/arch_hooks.h

     Move common arch hooks here (such as default_idle()).

 (5) asm/elf.h

     Move AT_VECTOR_SIZE_ARCH here.

 (6) asm/switch_to.h

     Move switch_to() here.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/atm/iphase.c                    |    1 -
 drivers/misc/sgi-gru/gru_instructions.h |    1 +
 fs/binfmt_elf.c                         |    1 +
 fs/binfmt_elf_fdpic.c                   |    1 +
 fs/exec.c                               |    1 +
 include/asm-generic/bitops/atomic.h     |    1 +
 include/linux/llist.h                   |    1 +
 include/linux/spinlock.h                |    1 +
 kernel/sched/core.c                     |    1 +
 net/atm/clip.c                          |    1 -
 10 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index 9e373ba..d438601 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -56,7 +56,6 @@
 #include <linux/interrupt.h>
 #include <linux/wait.h>
 #include <linux/slab.h>
-#include <asm/system.h>  
 #include <asm/io.h>  
 #include <linux/atomic.h>
 #include <asm/uaccess.h>  
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
index 8054ef5..9ae6c34 100644
--- a/include/asm-generic/bitops/atomic.h
+++ b/include/asm-generic/bitops/atomic.h
@@ -2,6 +2,7 @@
 #define _ASM_GENERIC_BITOPS_ATOMIC_H_
 
 #include <asm/types.h>
+#include <linux/irqflags.h>
 
 #ifdef CONFIG_SMP
 #include <asm/spinlock.h>
diff --git a/include/linux/llist.h b/include/linux/llist.h
index 8bba66b..fd5f0d9 100644
--- a/include/linux/llist.h
+++ b/include/linux/llist.h
@@ -56,6 +56,7 @@
  */
 
 #include <linux/kernel.h>
+#include <asm/atomic.h>
 #include <asm/processor.h>
 
 struct llist_head {
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 3a38aa3..8a98ddf 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -55,6 +55,7 @@
 #include <linux/kernel.h>
 #include <linux/stringify.h>
 #include <linux/bottom_half.h>
+#include <asm/barrier.h>
 
 
 /*
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 33a0676..85c0cfa 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -72,6 +72,7 @@
 #include <linux/slab.h>
 #include <linux/init_task.h>
 
+#include <asm/switch_to.h>
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
 #include <asm/mutex.h>
diff --git a/net/atm/clip.c b/net/atm/clip.c
index 127fe70..e059df4 100644
--- a/net/atm/clip.c
+++ b/net/atm/clip.c
@@ -37,7 +37,6 @@
 #include <linux/param.h> /* for HZ */
 #include <linux/uaccess.h>
 #include <asm/byteorder.h> /* for htons etc. */
-#include <asm/system.h> /* save/restore_flags */
 #include <linux/atomic.h>
 
 #include "common.h"

