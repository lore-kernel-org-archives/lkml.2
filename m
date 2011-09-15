Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935273Ab1IOW5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 18:57:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:43409 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935230Ab1IOW5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 18:57:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48919098"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/4] ptrace: Add variant of profile_pc for passing in pc
Date: Thu, 15 Sep 2011 15:56:49 -0700
Message-Id: <1316127412-1912-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a variant of profile_pc() that allows passing in the
instruction pointer.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/ptrace.h |    1 +
 arch/x86/kernel/time.c        |    9 ++++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 3566454..0fafaac 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -139,6 +139,7 @@ struct cpuinfo_x86;
 struct task_struct;
 
 extern unsigned long profile_pc(struct pt_regs *regs);
+extern unsigned long __profile_pc(unsigned long pc, struct pt_regs *regs);
 #define profile_pc profile_pc
 
 extern unsigned long
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index 5a64d05..cd98120 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -26,10 +26,8 @@
 DEFINE_VVAR(volatile unsigned long, jiffies) = INITIAL_JIFFIES;
 #endif
 
-unsigned long profile_pc(struct pt_regs *regs)
+unsigned long __profile_pc(unsigned long pc, struct pt_regs *regs)
 {
-	unsigned long pc = instruction_pointer(regs);
-
 	if (!user_mode_vm(regs) && in_lock_functions(pc)) {
 #ifdef CONFIG_FRAME_POINTER
 		return *(unsigned long *)(regs->bp + sizeof(long));
@@ -49,6 +47,11 @@ unsigned long profile_pc(struct pt_regs *regs)
 	}
 	return pc;
 }
+
+unsigned long profile_pc(struct pt_regs *regs)
+{
+	return __profile_pc(instruction_pointer(regs), regs);
+}
 EXPORT_SYMBOL(profile_pc);
 
 /*
-- 
1.7.4.4

