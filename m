Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090Ab1LPEHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 23:07:43 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:13129
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751826Ab1LPEHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 23:07:42 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2fh668h839h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4EEAC3EA.3070202@am.sony.com>
Date: Thu, 15 Dec 2011 20:07:06 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: "tglx@linutronix.de" <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <peterz@infradead.org>, <rostedt@goodmis.org>
CC: <stable-rt@vger.kernel.org>
Subject: adding cc to stable-rt: [PATCH] PREEMPT_RT_FULL: ARM context switch
 needs IRQs enabled
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ARMv6 and later have VIPT caches and the TLBs are tagged with an ASID
(application specific ID). The number of ASIDs is limited to 256 and
the allocation algorithm requires IPIs when all the ASIDs have been
used.  The IPIs require interrupts enabled during context switch for
deadlock avoidance.

The RT patch mm-protect-activate-switch-mm.patch disables irqs around
activate_mm() and switch_mm(), which are the portion of the ARMv6
context switch that require interrupts enabled.

The solution for the ARMv6 processors could be to _not_ disable irqs.
A more conservative solution is to provide the same environment that
the scheduler provides, that is preempt_disable().  This is more
resilient for possible future changes to the ARM context switch code
that is not aware of the RT patches.

This patch will conflict slightly with Catalin's patch set to remove
__ARCH_WANT_INTERRUPTS_ON_CTXSW, when that is accepted:

   http://lkml.indiana.edu/hypermail/linux/kernel/1111.3/01893.html

When Catalin's patch set is accepted, this RT patch will need to reverse
the change in patch 6 to arch/arm/include/asm/system.h:

   -#ifndef CONFIG_CPU_HAS_ASID
   -#define __ARCH_WANT_INTERRUPTS_ON_CTXSW
   -#endif

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>

---
 fs/exec.c        |    8 	8 +	0 -	0 !
 mm/mmu_context.c |    8 	8 +	0 -	0 !
 2 files changed, 16 insertions(+)

Index: b/fs/exec.c
===================================================================
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -837,12 +837,20 @@ static int exec_mmap(struct mm_struct *m
 		}
 	}
 	task_lock(tsk);
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	preempt_disable();
+#else
 	local_irq_disable_rt();
+#endif
 	active_mm = tsk->active_mm;
 	tsk->mm = mm;
 	tsk->active_mm = mm;
 	activate_mm(active_mm, mm);
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	preempt_enable();
+#else
 	local_irq_enable_rt();
+#endif
 	task_unlock(tsk);
 	arch_pick_mmap_layout(mm);
 	if (old_mm) {
Index: b/mm/mmu_context.c
===================================================================
--- a/mm/mmu_context.c
+++ b/mm/mmu_context.c
@@ -26,7 +26,11 @@ void use_mm(struct mm_struct *mm)
 	struct task_struct *tsk = current;
 
 	task_lock(tsk);
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	preempt_disable();
+#else
 	local_irq_disable_rt();
+#endif
 	active_mm = tsk->active_mm;
 	if (active_mm != mm) {
 		atomic_inc(&mm->mm_count);
@@ -34,7 +38,11 @@ void use_mm(struct mm_struct *mm)
 	}
 	tsk->mm = mm;
 	switch_mm(active_mm, mm, tsk);
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	preempt_enable();
+#else
 	local_irq_enable_rt();
+#endif
 	task_unlock(tsk);
 
 	if (active_mm != mm)

