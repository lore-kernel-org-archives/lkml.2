Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007Ab0KPVJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:09:01 -0500
Received: from claw.goop.org ([74.207.240.146]:50417 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758842Ab0KPVIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:08:55 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        =?UTF-8?q?Am=C3=A9rico=20Wang?= <xiyou.wangcong@gmail.com>,
        Eric Dumazet <dada1@cosmosbay.com>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 10/14] x86/pvticketlock: use callee-save for lock_spinning
Date: Tue, 16 Nov 2010 13:08:41 -0800
Message-Id: <598aba88fd8411b063884264e1521e8e64b3cb15.1289940821.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Although the lock_spinning calls in the spinlock code are on the
uncommon path, their presence can cause the compiler to generate many
more register save/restores in the function pre/postamble, which is in
the fast path.  To avoid this, convert it to using the pvops callee-save
calling convention, which defers all the save/restores until the actual
function is called, keeping the fastpath clean.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/paravirt.h       |    2 +-
 arch/x86/include/asm/paravirt_types.h |    2 +-
 arch/x86/kernel/paravirt-spinlocks.c  |    2 +-
 arch/x86/xen/spinlock.c               |    3 ++-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index c864775..6f275ca 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -719,7 +719,7 @@ static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
 
 static inline void __ticket_lock_spinning(struct arch_spinlock *lock, unsigned ticket)
 {
-	PVOP_VCALL2(pv_lock_ops.lock_spinning, lock, ticket);
+	PVOP_VCALLEE2(pv_lock_ops.lock_spinning, lock, ticket);
 }
 
 static inline void ____ticket_unlock_kick(struct arch_spinlock *lock, unsigned ticket)
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 1078474..53f249a 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -315,7 +315,7 @@ struct pv_mmu_ops {
 
 struct arch_spinlock;
 struct pv_lock_ops {
-	void (*lock_spinning)(struct arch_spinlock *lock, unsigned ticket);
+	struct paravirt_callee_save lock_spinning;
 	void (*unlock_kick)(struct arch_spinlock *lock, unsigned ticket);
 };
 
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index c2e010e..4251c1d 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -9,7 +9,7 @@
 
 struct pv_lock_ops pv_lock_ops = {
 #ifdef CONFIG_SMP
-	.lock_spinning = paravirt_nop,
+	.lock_spinning = __PV_IS_CALLEE_SAVE(paravirt_nop),
 	.unlock_kick = paravirt_nop,
 #endif
 };
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 5feb897..c31c5a3 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -137,6 +137,7 @@ out:
 	w->lock = NULL;
 	spin_time_accum_blocked(start);
 }
+PV_CALLEE_SAVE_REGS_THUNK(xen_lock_spinning);
 
 static void xen_unlock_kick(struct arch_spinlock *lock, unsigned next)
 {
@@ -189,7 +190,7 @@ void xen_uninit_lock_cpu(int cpu)
 
 void __init xen_init_spinlocks(void)
 {
-	pv_lock_ops.lock_spinning = xen_lock_spinning;
+	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(xen_lock_spinning);
 	pv_lock_ops.unlock_kick = xen_unlock_kick;
 }
 
-- 
1.7.2.3

