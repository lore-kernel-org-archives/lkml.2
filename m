Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab0J2Gnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:43:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:51273 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab0J2Gnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:43:31 -0400
Date: Fri, 29 Oct 2010 06:43:02 GMT
From: tip-bot for Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        eric.dumazet@gmail.com, brgerst@gmail.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, brgerst@gmail.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1288276854.2649.607.camel@edumazet-laptop>
References: <1288276854.2649.607.camel@edumazet-laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-32: Restore irq stacks NUMA-aware allocations
Message-ID: <tip-5c1eb08936693cd78c71164c8bea0b086ae72c67@git.kernel.org>
Git-Commit-ID: 5c1eb08936693cd78c71164c8bea0b086ae72c67
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Oct 2010 06:43:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5c1eb08936693cd78c71164c8bea0b086ae72c67
Gitweb:     http://git.kernel.org/tip/5c1eb08936693cd78c71164c8bea0b086ae72c67
Author:     Eric Dumazet <eric.dumazet@gmail.com>
AuthorDate: Thu, 28 Oct 2010 16:40:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Oct 2010 08:17:07 +0200

x86-32: Restore irq stacks NUMA-aware allocations

Commit 22d4cd4c4d ("Allocate irq stacks seperate from percpu
area") removed NUMA affinity of IRQ stacks as side-effect of
the fix.

Using alloc_pages_node() instead of __get_free_pages() is safe,
even if the target node has no available LOWMEM pages :
alloc_pages_node() fallbacks to another node.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Brian Gerst <brgerst@gmail.com>
Cc: tj@kernel.org
Cc: torvalds@linux-foundation.org
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1288276854.2649.607.camel@edumazet-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/irq_32.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

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
