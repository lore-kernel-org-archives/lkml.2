Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab0J3BbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 21:31:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59851 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab0J3BbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 21:31:15 -0400
Date: Fri, 29 Oct 2010 18:28:15 -0700
Message-Id: <201010300128.o9U1SF1Z015989@voreg.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Additional x86 fixes for 2.6.37
Cc: Brian Gerst <brgerst@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Baron <jbaron@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        tj@kernel.org, torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 44234d0c465d996145e9c821fa28a981f2e8309d:

  Merge branch 'for-2637/i2c-all' of git://git.fluff.org/bjdooks/linux (2010-10-29 16:15:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Eric Dumazet (1):
      x86-32: Restore irq stacks NUMA-aware allocations

Jason Baron (1):
      x86, alternative: Call stop_machine_text_poke() on all cpus

Yinghai Lu (1):
      x86, memblock: Fix early_node_mem with big reserved region.

 arch/x86/kernel/alternative.c |    2 +-
 arch/x86/kernel/irq_32.c      |    9 +++++++--
 arch/x86/mm/numa_64.c         |    7 ++-----
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index a36bb90..5ceeca3 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -638,7 +638,7 @@ void *__kprobes text_poke_smp(void *addr, const void *opcode, size_t len)
 	atomic_set(&stop_machine_first, 1);
 	wrote_text = 0;
 	/* Use __stop_machine() because the caller already got online_cpus. */
-	__stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
+	__stop_machine(stop_machine_text_poke, (void *)&tpp, cpu_online_mask);
 	return addr;
 }
 
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 64668db..96656f2 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -17,6 +17,7 @@
 #include <linux/delay.h>
 #include <linux/uaccess.h>
 #include <linux/percpu.h>
+#include <linux/mm.h>
 
 #include <asm/apic.h>
 
@@ -125,7 +126,9 @@ void __cpuinit irq_ctx_init(int cpu)
 	if (per_cpu(hardirq_ctx, cpu))
 		return;
 
-	irqctx = (union irq_ctx *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER);
+	irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
+					       THREAD_FLAGS,
+					       THREAD_ORDER));
 	irqctx->tinfo.task		= NULL;
 	irqctx->tinfo.exec_domain	= NULL;
 	irqctx->tinfo.cpu		= cpu;
@@ -134,7 +137,9 @@ void __cpuinit irq_ctx_init(int cpu)
 
 	per_cpu(hardirq_ctx, cpu) = irqctx;
 
-	irqctx = (union irq_ctx *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER);
+	irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
+					       THREAD_FLAGS,
+					       THREAD_ORDER));
 	irqctx->tinfo.task		= NULL;
 	irqctx->tinfo.exec_domain	= NULL;
 	irqctx->tinfo.cpu		= cpu;
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 60f4985..7ffc9b7 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -178,11 +178,8 @@ static void * __init early_node_mem(int nodeid, unsigned long start,
 
 	/* extend the search scope */
 	end = max_pfn_mapped << PAGE_SHIFT;
-	if (end > (MAX_DMA32_PFN<<PAGE_SHIFT))
-		start = MAX_DMA32_PFN<<PAGE_SHIFT;
-	else
-		start = MAX_DMA_PFN<<PAGE_SHIFT;
-	mem = memblock_x86_find_in_range_node(nodeid, start, end, size, align);
+	start = MAX_DMA_PFN << PAGE_SHIFT;
+	mem = memblock_find_in_range(start, end, size, align);
 	if (mem != MEMBLOCK_ERROR)
 		return __va(mem);
 
