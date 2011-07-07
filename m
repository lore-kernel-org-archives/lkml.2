Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab1GGVoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 17:44:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:54576 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab1GGVoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 17:44:10 -0400
Date: Thu, 7 Jul 2011 21:43:51 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-e08fbb78f03fe2c4f88824faf6f51ce6af185e11@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110702033852.733414762@goodmis.org>
References: <20110702033852.733414762@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing, x86/irq: Do not trace arch_local_{*,irq_*}() functions
Git-Commit-ID: e08fbb78f03fe2c4f88824faf6f51ce6af185e11
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Jul 2011 21:43:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e08fbb78f03fe2c4f88824faf6f51ce6af185e11
Gitweb:     http://git.kernel.org/tip/e08fbb78f03fe2c4f88824faf6f51ce6af185e11
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Fri, 1 Jul 2011 23:04:36 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 7 Jul 2011 19:22:32 +0200

tracing, x86/irq: Do not trace arch_local_{*,irq_*}() functions

I triggered a triple fault with gcc 4.5.1 because it did not
honor the inline annotation to arch_local_save_flags() function
and that function was added to the pool of functions traced by
the function tracer.

When preempt_schedule() called arch_local_save_flags() (called
by irqs_disabled()), it was traced, but the first thing the
function tracer does is disable preemption. When it enables
preemption, the NEED_RESCHED flag will not have been cleared and
the preemption check will trigger the call to preempt_schedule()
again.

Although the dynamic function tracer crashed immediately, the
static version of the function tracer (CONFIG_DYNAMIC_FTRACE is
not set) actually was able to show where the problem was.

 swapper-1       3.N.. 103885us : arch_local_save_flags <-preempt_schedule
 swapper-1       3.N.. 103886us : arch_local_save_flags <-preempt_schedule
 swapper-1       3.N.. 103886us : arch_local_save_flags <-preempt_schedule
 swapper-1       3.N.. 103887us : arch_local_save_flags <-preempt_schedule
 swapper-1       3.N.. 103887us : arch_local_save_flags <-preempt_schedule
 swapper-1       3.N.. 103888us : arch_local_save_flags <-preempt_schedule
 swapper-1       3.N.. 103888us : arch_local_save_flags <-preempt_schedule

It went on for a while before it triple faulted with a corrupted
stack.

The arch_local_save_flags and arch_local_irq_* functions should
not be traced. Even though they are marked as inline, gcc may
still make them a function and enable tracing of them.

The simple solution is to just mark them as notrace. I had to
add the <linux/types.h> for this file to include the notrace
tag.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20110702033852.733414762@goodmis.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/irqflags.h |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/irqflags.h b/arch/x86/include/asm/irqflags.h
index 5745ce8..bba3cf8 100644
--- a/arch/x86/include/asm/irqflags.h
+++ b/arch/x86/include/asm/irqflags.h
@@ -60,23 +60,24 @@ static inline void native_halt(void)
 #include <asm/paravirt.h>
 #else
 #ifndef __ASSEMBLY__
+#include <linux/types.h>
 
-static inline unsigned long arch_local_save_flags(void)
+static inline notrace unsigned long arch_local_save_flags(void)
 {
 	return native_save_fl();
 }
 
-static inline void arch_local_irq_restore(unsigned long flags)
+static inline notrace void arch_local_irq_restore(unsigned long flags)
 {
 	native_restore_fl(flags);
 }
 
-static inline void arch_local_irq_disable(void)
+static inline notrace void arch_local_irq_disable(void)
 {
 	native_irq_disable();
 }
 
-static inline void arch_local_irq_enable(void)
+static inline notrace void arch_local_irq_enable(void)
 {
 	native_irq_enable();
 }
@@ -102,7 +103,7 @@ static inline void halt(void)
 /*
  * For spinlocks, etc:
  */
-static inline unsigned long arch_local_irq_save(void)
+static inline notrace unsigned long arch_local_irq_save(void)
 {
 	unsigned long flags = arch_local_save_flags();
 	arch_local_irq_disable();
