Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383Ab1DYKpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 06:45:08 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:54333 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758362Ab1DYKpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 06:45:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AKi7QSlYPzL2PdUOw+sMb2GvqgqJIAuzSnwTgGklmmVlSstVz8lZdwZxAwxnsV7pFA
         mxkyN4fMVsdMXQUDEMptphByctXjfvrWXZY13r3DaGsHUDbcGpQ64gCLlZ+/KOo1FDhz
         oMN1v0syBi3+5Dam+yutuLMAGFx87gLGOwztk=
From: Geunsik Lim <leemgs1@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Hugh Dickins <hughd@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH 3/4] munmap: kbuild menu for munmap interface
Date: Mon, 25 Apr 2011 19:44:31 +0900
Message-Id: <1303728272-11408-4-git-send-email-leemgs1@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1303728272-11408-1-git-send-email-leemgs1@gmail.com>
References: <1303728272-11408-1-git-send-email-leemgs1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geunsik Lim <geunsik.lim@samsung.com>

Support kbuild menu to select memory unmap operation size
at build time.

Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
Acked-by: Hyunjin Choi <hj89.choi@samsung.com>
---
 init/Kconfig |   70 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/memory.c  |   21 +++++++++++-----
 2 files changed, 84 insertions(+), 7 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 56240e7..0983961 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -557,6 +557,76 @@ config LOG_BUF_SHIFT
 		     13 =>  8 KB
 		     12 =>  4 KB
 
+config PREEMPT_OK_MUNMAP_RANGE
+	int "Memory unmap unit on preemption mode (8 => 32KB)"
+	depends on !PREEMPT_NONE
+	range 8 2048
+	default 8
+	help
+	  unmap_vmas(=unmap a range of memory covered by a list of vma) is treading
+	  a delicate and uncomfortable line between hi-performance and low-latency.
+	  We've chosen to improve performance at the expense of latency.
+
+	  So although there may be no need to resched right now,
+	  if we keep on gathering more and more without flushing,
+	  we'll be very unresponsive when a resched is needed later on.
+
+	  Consider the best suitable result between high performance and low latency
+	  on preemption mode.
+	  Select optimal munmap size to return memory space that is allocated by mmap system call.
+
+	  For example, For recording mass files, if we try to unmap memory that we allocated
+	  with 100MB for recording in embedded devices, we have to wait for more than 3seconds to
+	  change mode from play mode to recording mode. This results from the unit of memory
+	  unmapped size when we are recording mass files like camcorder particularly.
+
+          This value can be changed after boot using the
+          /proc/sys/vm/munmap_unit_size tunable.
+
+	  Examples:
+                  2048 => 8,388,608bytes : for straight-line efficiency
+                  1024 => 4,194,304bytes
+                   512 => 2,097,152bytes
+                   256 => 1,048,576bytes
+                   128 =>   524,288bytes
+                    64 =>   262,144bytes
+                    32 =>   131,072bytes
+                    16 =>    65,536bytes
+                     8 =>    32,768bytes : for low-latency (*default)
+
+config PREEMPT_NO_MUNMAP_RANGE
+	int "Memory unmap unit on non-preemption mode (1024 => 4MB)"
+	depends on PREEMPT_NONE
+	range 8 2048
+	default 1024
+	help
+
+	  unmap_vmas(=unmap a range of memory covered by a list of vma) is treading
+	  a delicate and uncomfortable line between hi-performance and low-latency.
+	  We've chosen to improve performance at the expense of latency.
+
+	  So although there may be no need to resched right now,
+	  if we keep on gathering more and more without flushing,
+	  we'll be very unresponsive when a resched is needed later on.
+
+	  Consider the best suitable result between high performance and low latency
+	  on preemption mode.
+	  Select optimal munmap size to return memory space that is allocated by mmap system call.
+
+          This value can be changed after boot using the
+          /proc/sys/vm/munmap_unit_size tunable.
+
+	  Examples:
+                  2048 => 8,388,608bytes : for straight-line efficiency
+                  1024 => 4,194,304bytes (*default)
+                   512 => 2,097,152bytes
+                   256 => 1,048,576bytes
+                   128 =>   524,288bytes
+                    64 =>   262,144bytes
+                    32 =>   131,072bytes
+                    16 =>    65,536bytes
+                     8 =>    32,768bytes : for low-latency
+
 #
 # Architectures with an unreliable sched_clock() should select this:
 #
diff --git a/mm/memory.c b/mm/memory.c
index ce22a25..e4533fe 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -57,6 +57,7 @@
 #include <linux/swapops.h>
 #include <linux/elf.h>
 #include <linux/gfp.h>
+#include <linux/munmap_unit_size.h>
 
 #include <asm/io.h>
 #include <asm/pgalloc.h>
@@ -1079,6 +1080,10 @@ static unsigned long unmap_page_range(struct mmu_gather *tlb,
 			(*zap_work)--;
 			continue;
 		}
+#if 0
+printk("DEBUG:munmap step2,(%s:%d), unmap range = current(%lu) + \
+zap_work(%lu bytes) \n", current->comm, current->pid, addr, *zap_work);
+#endif
 		next = zap_pud_range(tlb, vma, pgd, addr, next,
 						zap_work, details);
 	} while (pgd++, addr = next, (addr != end && *zap_work > 0));
@@ -1088,12 +1093,10 @@ static unsigned long unmap_page_range(struct mmu_gather *tlb,
 	return addr;
 }
 
-#ifdef CONFIG_PREEMPT
-# define ZAP_BLOCK_SIZE	(8 * PAGE_SIZE)
-#else
-/* No preempt: go for improved straight-line efficiency */
-# define ZAP_BLOCK_SIZE	(1024 * PAGE_SIZE)
-#endif
+/* No preempt: go for improved straight-line efficiency
+ * on PREEMPT(preemption mode) this is not a critical latency-path.
+ */
+# define ZAP_BLOCK_SIZE        (munmap_unit_size * PAGE_SIZE)
 
 /**
  * unmap_vmas - unmap a range of memory covered by a list of vma's
@@ -1133,7 +1136,11 @@ unsigned long unmap_vmas(struct mmu_gather **tlbp,
 	spinlock_t *i_mmap_lock = details? details->i_mmap_lock: NULL;
 	int fullmm = (*tlbp)->fullmm;
 	struct mm_struct *mm = vma->vm_mm;
-
+#if 0
+printk("DEBUG:munmap step1,(%s:%d), unit=zap_work(%ld)/ZAP_BLOCK(%ld), \
+vma:[%8lu]=%lu-%lu \n", current->comm, current->pid, zap_work, ZAP_BLOCK_SIZE, \
+vma->vm_end - vma->vm_start, vma->vm_end, vma->vm_start);
+#endif
 	mmu_notifier_invalidate_range_start(mm, start_addr, end_addr);
 	for ( ; vma && vma->vm_start < end_addr; vma = vma->vm_next) {
 		unsigned long end;
-- 
1.7.3.4

