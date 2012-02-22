Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab2BVU4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 15:56:11 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49576 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab2BVU4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 15:56:09 -0500
Date: Wed, 22 Feb 2012 12:56:06 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@i5.linux-foundation.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
cc: Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] i387: math_state_restore() isn't called from asm
In-Reply-To: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1202221255150.20522@i5.linux-foundation.org>
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 13 Feb 2012 13:47:25 -0800

[ Upstream commit be98c2cdb15ba26148cd2bd58a857d4f7759ed38 ]

It was marked asmlinkage for some really old and stale legacy reasons.
Fix that and the equally stale comment.

Noticed when debugging the irq_fpu_usable() bugs.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@kernel.org	# Helps back-porting
---

Ok, this is trivial, but correct, and avoids the silly clashes with the 
other patches.

 arch/x86/include/asm/i387.h |    2 +-
 arch/x86/kernel/traps.c     |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index c9e09ea05644..cba143210780 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -29,7 +29,7 @@ extern unsigned int sig_xstate_size;
 extern void fpu_init(void);
 extern void mxcsr_feature_mask_init(void);
 extern int init_fpu(struct task_struct *child);
-extern asmlinkage void math_state_restore(void);
+extern void math_state_restore(void);
 extern void __math_state_restore(void);
 extern int dump_fpu(struct pt_regs *, struct user_i387_struct *);
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a8e3eb83466c..727e6c16f294 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -590,10 +590,10 @@ void __math_state_restore(void)
  * Careful.. There are problems with IBM-designed IRQ13 behaviour.
  * Don't touch unless you *really* know how it works.
  *
- * Must be called with kernel preemption disabled (in this case,
- * local interrupts are disabled at the call-site in entry.S).
+ * Must be called with kernel preemption disabled (eg with local
+ * local interrupts as in the case of do_device_not_available).
  */
-asmlinkage void math_state_restore(void)
+void math_state_restore(void)
 {
 	struct thread_info *thread = current_thread_info();
 	struct task_struct *tsk = thread->task;
-- 
1.7.9.188.g12766.dirty

