Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab2HSDAc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:00:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:1635 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596Ab2HSC5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="210415455"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>, ananth@in.ibm.com
Subject: [PATCH 47/74] x86, lto: Fix kprobes for LTO
Date: Sat, 18 Aug 2012 19:56:43 -0700
Message-Id: <1345345030-22211-48-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

- Make all the external assembler template symbols __visible
- Move the templates inline assembler code into a top level
assembler statement, not inside a function. This avoids it being
optimized away or cloned.

Cc: ananth@in.ibm.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/kprobes.h |    8 ++++----
 arch/x86/kernel/kprobes-opt.c  |    5 +----
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index a967173..fa2d12e 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -48,10 +48,10 @@ typedef u8 kprobe_opcode_t;
 #define flush_insn_slot(p)	do { } while (0)
 
 /* optinsn template addresses */
-extern kprobe_opcode_t optprobe_template_entry;
-extern kprobe_opcode_t optprobe_template_val;
-extern kprobe_opcode_t optprobe_template_call;
-extern kprobe_opcode_t optprobe_template_end;
+extern __visible kprobe_opcode_t optprobe_template_entry;
+extern __visible kprobe_opcode_t optprobe_template_val;
+extern __visible kprobe_opcode_t optprobe_template_call;
+extern __visible kprobe_opcode_t optprobe_template_end;
 #define MAX_OPTIMIZED_LENGTH (MAX_INSN_SIZE + RELATIVE_ADDR_SIZE)
 #define MAX_OPTINSN_SIZE 				\
 	(((unsigned long)&optprobe_template_end -	\
diff --git a/arch/x86/kernel/kprobes-opt.c b/arch/x86/kernel/kprobes-opt.c
index c5e410e..43c34e8 100644
--- a/arch/x86/kernel/kprobes-opt.c
+++ b/arch/x86/kernel/kprobes-opt.c
@@ -88,9 +88,7 @@ static void __kprobes synthesize_set_arg1(kprobe_opcode_t *addr, unsigned long v
 	*(unsigned long *)addr = val;
 }
 
-static void __used __kprobes kprobes_optinsn_template_holder(void)
-{
-	asm volatile (
+asm (
 			".global optprobe_template_entry\n"
 			"optprobe_template_entry:\n"
 #ifdef CONFIG_X86_64
@@ -129,7 +127,6 @@ static void __used __kprobes kprobes_optinsn_template_holder(void)
 #endif
 			".global optprobe_template_end\n"
 			"optprobe_template_end:\n");
-}
 
 #define TMPL_MOVE_IDX \
 	((long)&optprobe_template_val - (long)&optprobe_template_entry)
-- 
1.7.7.6

