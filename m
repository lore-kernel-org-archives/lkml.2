Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab1IBAzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 20:55:42 -0400
Received: from claw.goop.org ([74.207.240.146]:43181 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932905Ab1IBAzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 20:55:37 -0400
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
Subject: [PATCH 13/13] x86/pvticketlock: use __ticket_t for pvop args
Date: Thu,  1 Sep 2011 17:55:06 -0700
Message-Id: <f4c29768b5bb41088d2ab12e5de40efe5765a52c.1314922370.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Use __ticket_t for the ticket argument to the pvops, to prevent
unnecessary zero-extension in the calling code.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/paravirt.h       |    6 ++++--
 arch/x86/include/asm/spinlock_types.h |    4 ----
 arch/x86/xen/spinlock.c               |    4 ++--
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index a6f2651..932a682 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -741,12 +741,14 @@ static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
 
 #if defined(CONFIG_SMP) && defined(CONFIG_PARAVIRT_SPINLOCKS)
 
-static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock, unsigned ticket)
+#include <asm/spinlock_types.h>
+
+static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock, __ticket_t ticket)
 {
 	PVOP_VCALLEE2(pv_lock_ops.lock_spinning, lock, ticket);
 }
 
-static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock, unsigned ticket)
+static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock, __ticket_t ticket)
 {
 	PVOP_VCALL2(pv_lock_ops.unlock_kick, lock, ticket);
 }
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index 7b383e2..62ea99e 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -1,10 +1,6 @@
 #ifndef _ASM_X86_SPINLOCK_TYPES_H
 #define _ASM_X86_SPINLOCK_TYPES_H
 
-#ifndef __LINUX_SPINLOCK_TYPES_H
-# error "please don't include this file directly"
-#endif
-
 #include <linux/types.h>
 
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 7b89439..91b0940 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -92,7 +92,7 @@ static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
 static DEFINE_PER_CPU(struct xen_lock_waiting, lock_waiting);
 static cpumask_t waiting_cpus;
 
-static void xen_lock_spinning(struct arch_spinlock *lock, unsigned want)
+static void xen_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
 {
 	int irq = __this_cpu_read(lock_kicker_irq);
 	struct xen_lock_waiting *w = &__get_cpu_var(lock_waiting);
@@ -171,7 +171,7 @@ out:
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_lock_spinning);
 
-static void xen_unlock_kick(struct arch_spinlock *lock, unsigned next)
+static void xen_unlock_kick(struct arch_spinlock *lock, __ticket_t next)
 {
 	int cpu;
 
-- 
1.7.6

