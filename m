Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab1JMAwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:52:05 -0400
Received: from claw.goop.org ([74.207.240.146]:47383 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab1JMAvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:51:51 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH RFC V5 07/11] x86/pvticketlock: use callee-save for lock_spinning
Date: Wed, 12 Oct 2011 17:51:39 -0700
Message-Id: <3c2d4b131254f8e6565f4e8c7a0427d06f244b01.1318466916.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <cover.1318466916.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1318466916.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1318466916.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1318466916.git.jeremy.fitzhardinge@citrix.com>
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
index 76cae7a..50281c7 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -752,7 +752,7 @@ static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
 
 static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock, __ticket_t ticket)
 {
-	PVOP_VCALL2(pv_lock_ops.lock_spinning, lock, ticket);
+	PVOP_VCALLEE2(pv_lock_ops.lock_spinning, lock, ticket);
 }
 
 static __always_inline void ____ticket_unlock_kick(struct arch_spinlock *lock, __ticket_t ticket)
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 005e24d..5e0c138 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -330,7 +330,7 @@ struct arch_spinlock;
 #include <asm/spinlock_types.h>
 
 struct pv_lock_ops {
-	void (*lock_spinning)(struct arch_spinlock *lock, __ticket_t ticket);
+	struct paravirt_callee_save lock_spinning;
 	void (*unlock_kick)(struct arch_spinlock *lock, __ticket_t ticket);
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
index 1e21c99..431d231 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -145,6 +145,7 @@ out:
 
 	spin_time_accum_blocked(start);
 }
+PV_CALLEE_SAVE_REGS_THUNK(xen_lock_spinning);
 
 static void xen_unlock_kick(struct arch_spinlock *lock, __ticket_t next)
 {
@@ -204,7 +205,7 @@ void __init xen_init_spinlocks(void)
 		return;
 	}
 
-	pv_lock_ops.lock_spinning = xen_lock_spinning;
+	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(xen_lock_spinning);
 	pv_lock_ops.unlock_kick = xen_unlock_kick;
 }
 
-- 
1.7.6.4

