Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab0IQPJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:09:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab0IQPJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:09:36 -0400
Date: Fri, 17 Sep 2010 11:08:56 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Message-Id: <04cfddf2ba77bcabfc3e524f1849d871d6a1cf9d.1284733808.git.jbaron@redhat.com>
In-Reply-To: <cover.1284733808.git.jbaron@redhat.com>
References: <cover.1284733808.git.jbaron@redhat.com>
Subject: [PATCH 02/10] jump label v11: make text_poke_early() globally visisble
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make text_poke_early available outside of alternative.c. The jump label
patchset wants to make use of it in order to set up the optimal no-op
sequences at run-time.

Signed-off-by: Jason Baron <jbaron@redhat.com>
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

