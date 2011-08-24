Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab1HXM1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 08:27:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:47923 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab1HXM1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 08:27:23 -0400
Subject: [ia64] Question on __ARCH_WANT_UNLOCKED_CTXSW
From: Peter Zijlstra <peterz@infradead.org>
To: Ken Chen <kenchen@google.com>, "Luck,Tony" <tony.luck@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>, David Miller <davem@davemloft.net>
Date: Wed, 24 Aug 2011 14:27:13 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314188833.6925.3.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ken, Tony,

happen to remember what the perceived benefit of using
__ARCH_WANT_UNLOCKED_CTXSW was about?

---
commit f8efa27662532ad5adb2790bfc3f4c78e019cfad
Author: Chen, Kenneth W <kenneth.w.chen@intel.com>
Date:   Thu Jan 26 18:24:59 2006 -0800

    [IA64] remove staled comments in asm/system.h
    
    With the recent optimization made to wrap_mmu_context function,
    we don't hold tasklist_lock anymore when wrapping context id.
    The comments in asm/system.h must fall through the crack earlier.
    Remove staled comments.
    
    I believe it is still beneficial to unlock the runqueue lock
    across context switch. So leave __ARCH_WANT_UNLOCKED_CTXSW on.
    
    Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>
    Signed-off-by: Tony Luck <tony.luck@intel.com>

diff --git a/include/asm-ia64/system.h b/include/asm-ia64/system.h
index 80c5a23..0625387 100644
--- a/include/asm-ia64/system.h
+++ b/include/asm-ia64/system.h
@@ -249,32 +249,7 @@ extern void ia64_load_extra (struct task_struct *task);
 # define switch_to(prev,next,last)	__switch_to(prev, next, last)
 #endif
 
-/*
- * On IA-64, we don't want to hold the runqueue's lock during the low-level context-switch,
- * because that could cause a deadlock.  Here is an example by Erich Focht:
- *
- * Example:
- * CPU#0:
- * schedule()
- *    -> spin_lock_irq(&rq->lock)
- *    -> context_switch()
- *       -> wrap_mmu_context()
- *          -> read_lock(&tasklist_lock)
- *
- * CPU#1:
- * sys_wait4() or release_task() or forget_original_parent()
- *    -> write_lock(&tasklist_lock)
- *    -> do_notify_parent()
- *       -> wake_up_parent()
- *          -> try_to_wake_up()
- *             -> spin_lock_irq(&parent_rq->lock)
- *
- * If the parent's rq happens to be on CPU#0, we'll wait for the rq->lock
- * of that CPU which will not be released, because there we wait for the
- * tasklist_lock to become available.
- */
 #define __ARCH_WANT_UNLOCKED_CTXSW
-
 #define ARCH_HAS_PREFETCH_SWITCH_STACK
 #define ia64_platform_is(x) (strcmp(x, platform_name) == 0)
 

