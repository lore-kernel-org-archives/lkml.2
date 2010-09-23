Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab0IWD4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 23:56:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50745 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab0IWD4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 23:56:09 -0400
X-Authority-Analysis: v=1.1 cv=GglhOq9PVtWDmzXFaQc2b9ix+3dKCE90LyQFAZ1FxMQ= c=1 sm=0 a=kgbpZFGZ8gUA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=CiWwQ2e9Kz_ET6uD80IA:9 a=HTp4bqcEv22ktmFivlYA:7 a=y2NADe9Sv0-bOH7Qjh2xi-fzJ1gA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20100923035607.982074918@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 22 Sep 2010 23:49:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>,
        Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
        David Miller <davem@davemloft.net>
Subject: [PATCH 02/11] jump label: Make text_poke_early() globally visible
References: <20100923034910.867858597@goodmis.org>
Content-Disposition: inline; filename=0002-jump-label-Make-text_poke_early-globally-visible.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Make text_poke_early available outside of alternative.c. The jump label
patchset wants to make use of it in order to set up the optimal no-op
sequences at run-time.

Signed-off-by: Jason Baron <jbaron@redhat.com>
LKML-Reference: <04cfddf2ba77bcabfc3e524f1849d871d6a1cf9d.1284733808.git.jbaron@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/alternative.h |    2 ++
 arch/x86/kernel/alternative.c      |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 27a35b6..634bf78 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -160,6 +160,8 @@ static inline void apply_paravirt(struct paravirt_patch_site *start,
 #define __parainstructions_end	NULL
 #endif
 
+extern void *text_poke_early(void *addr, const void *opcode, size_t len);
+
 /*
  * Clear and restore the kernel write-protection flag on the local CPU.
  * Allows the kernel to edit read-only pages.
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 1849d80..083bd01 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -195,7 +195,7 @@ static void __init_or_module add_nops(void *insns, unsigned int len)
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 extern s32 __smp_locks[], __smp_locks_end[];
-static void *text_poke_early(void *addr, const void *opcode, size_t len);
+void *text_poke_early(void *addr, const void *opcode, size_t len);
 
 /* Replace instructions with better alternatives for this CPU type.
    This runs before SMP is initialized to avoid SMP problems with
@@ -522,7 +522,7 @@ void __init alternative_instructions(void)
  * instructions. And on the local CPU you need to be protected again NMI or MCE
  * handlers seeing an inconsistent instruction while you patch.
  */
-static void *__init_or_module text_poke_early(void *addr, const void *opcode,
+void *__init_or_module text_poke_early(void *addr, const void *opcode,
 					      size_t len)
 {
 	unsigned long flags;
-- 
1.7.1


