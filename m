Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab0KCPBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:01:12 -0400
Received: from claw.goop.org ([74.207.240.146]:35196 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457Ab0KCPBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:01:10 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 12/20] x86/pvticketlock: use callee-save for unlock_kick as well
Date: Wed,  3 Nov 2010 10:59:53 -0400
Message-Id: <1acfb53a5dd0b78e0f0e8dd86ca9ab6062464ca6.1288794124.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

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
index dbd5914..b6ff89a 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -729,7 +729,7 @@ static inline void __ticket_lock_spinning(struct arch_spinlock *lock, unsigned t
 
 static inline void ____ticket_unlock_kick(struct arch_spinlock *lock, unsigned ticket)
 {
-	PVOP_VCALL2(pv_lock_ops.unlock_kick, lock, ticket);
+	PVOP_VCALLEE2(pv_lock_ops.unlock_kick, lock, ticket);
 }
 
 #endif
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 9ad6d088..bb02831 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -317,7 +317,7 @@ struct pv_mmu_ops {
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
index 2bd51d8..bf2f409 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -159,6 +159,7 @@ static void xen_unlock_kick(struct arch_spinlock *lock, unsigned next)
 		}
 	}
 }
+PV_CALLEE_SAVE_REGS_THUNK(xen_unlock_kick);
 
 static irqreturn_t dummy_handler(int irq, void *dev_id)
 {
@@ -195,7 +196,7 @@ void xen_uninit_lock_cpu(int cpu)
 void __init xen_init_spinlocks(void)
 {
 	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(xen_lock_spinning);
-	pv_lock_ops.unlock_kick = xen_unlock_kick;
+	pv_lock_ops.unlock_kick = PV_CALLEE_SAVE(xen_unlock_kick);
 }
 
 #ifdef CONFIG_XEN_DEBUG_FS
-- 
1.7.2.3

