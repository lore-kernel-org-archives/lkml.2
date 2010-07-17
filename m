Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966305Ab0GQBDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 21:03:18 -0400
Received: from claw.goop.org ([74.207.240.146]:46941 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759579Ab0GQBDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 21:03:07 -0400
Message-Id: <dd5de0a5a928968676d3cba77c25b66543f1b9e0.1279328276.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1279328276.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1279328276.git.jeremy.fitzhardinge@citrix.com>
Subject: [PATCH RFC 12/12] x86/pvticketlock: use callee-save for unlock_kick as well
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Jan Beulich <JBeulich@novell.com>, Avi Kivity <avi@redhat.com>,
        Xen-devel <xen-devel@lists.xensource.com>
From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Fri, 16 Jul 2010 18:03:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unlock code is typically inlined throughout the kernel, so its useful
to make sure there's minimal register pressure overhead from the presence
of the unlock_tick pvop call.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/paravirt.h       |    2 +-
 arch/x86/include/asm/paravirt_types.h |    2 +-
 arch/x86/kernel/paravirt-spinlocks.c  |    2 +-
 arch/x86/xen/spinlock.c               |    3 ++-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index d02c5fe..487f965 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -738,7 +738,7 @@ static inline void __ticket_lock_spinning(struct arch_spinlock *lock, unsigned t
 
 static inline void ____ticket_unlock_kick(struct arch_spinlock *lock, unsigned ticket)
 {
-	PVOP_VCALL2(pv_lock_ops.unlock_kick, lock, ticket);
+	PVOP_VCALLEE2(pv_lock_ops.unlock_kick, lock, ticket);
 }
 
 #endif
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index b8205c4..be6f2a4 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -321,7 +321,7 @@ struct pv_mmu_ops {
 struct arch_spinlock;
 struct pv_lock_ops {
 	struct paravirt_callee_save lock_spinning;
-	void (*unlock_kick)(struct arch_spinlock *lock, unsigned ticket);
+	struct paravirt_callee_save unlock_kick;
 };
 
 /* This contains all the paravirt structures: we get a convenient
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index 4251c1d..efad219 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -10,7 +10,7 @@
 struct pv_lock_ops pv_lock_ops = {
 #ifdef CONFIG_SMP
 	.lock_spinning = __PV_IS_CALLEE_SAVE(paravirt_nop),
-	.unlock_kick = paravirt_nop,
+	.unlock_kick = __PV_IS_CALLEE_SAVE(paravirt_nop),
 #endif
 };
 EXPORT_SYMBOL(pv_lock_ops);
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 598e126..d07eff3 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -158,6 +158,7 @@ static void xen_unlock_kick(struct arch_spinlock *lock, unsigned next)
 		}
 	}
 }
+PV_CALLEE_SAVE_REGS_THUNK(xen_unlock_kick);
 
 static irqreturn_t dummy_handler(int irq, void *dev_id)
 {
@@ -194,7 +195,7 @@ void xen_uninit_lock_cpu(int cpu)
 void __init xen_init_spinlocks(void)
 {
 	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(xen_lock_spinning);
-	pv_lock_ops.unlock_kick = xen_unlock_kick;
+	pv_lock_ops.unlock_kick = PV_CALLEE_SAVE(xen_unlock_kick);
 }
 
 #ifdef CONFIG_XEN_DEBUG_FS
-- 
1.7.1.1

