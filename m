Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933512Ab0J1OlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 10:41:01 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56739 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab0J1Ok6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 10:40:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=R+6VQK7MQgG+l4s8vbwAodAvvTc1jEMSzZK79o5XVotXWjVykZbKYl1fPNxvo7TxPw
         uV9Xyg6e2m9AX3unbrySGTR2RN76WVHHcWHmjwoTFzp8eEbgrzU73pvidbcYPqEtU2GU
         8Ca8krlxlmr/cP2kcwSOHX+DvfaBRLLUGWL6k=
Subject: [PATCH] x86-32: NUMA irq stacks allocations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Brian Gerst <brgerst@gmail.com>, tj@kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
In-Reply-To: <1288173442.15336.1490.camel@twins>
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>
	 <1288158182-1753-1-git-send-email-brgerst@gmail.com>
	 <1288159670.2652.181.camel@edumazet-laptop>
	 <1288173442.15336.1490.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Oct 2010 16:40:54 +0200
Message-ID: <1288276854.2649.607.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 22d4cd4c4d (Allocate irq stacks seperate from percpu area)
removed NUMA affinity of IRQ stacks.

Using alloc_pages_node() instead of __get_free_pages() is safe, even if
the target node has no available LOWMEM pages : alloc_pages_node()
fallbacks to another node.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: tj@kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
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


