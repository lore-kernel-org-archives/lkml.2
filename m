Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086Ab0KPVJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:09:06 -0500
Received: from claw.goop.org ([74.207.240.146]:50483 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758882Ab0KPVI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:08:56 -0500
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
Subject: [PATCH 14/14] x86/ticketlocks: tidy up __ticket_unlock_kick()
Date: Tue, 16 Nov 2010 13:08:45 -0800
Message-Id: <4948250a56e0e8b30897dbc2e6194d76e4a7cfe9.1289940821.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

__ticket_unlock_kick() is now only called from known slowpaths, so there's
no need for it to do any checking of its own.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/paravirt.h |    2 +-
 arch/x86/include/asm/spinlock.h |   14 --------------
 2 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 6f275ca..7755b16 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -722,7 +722,7 @@ static inline void __ticket_lock_spinning(struct arch_spinlock *lock, unsigned t
 	PVOP_VCALLEE2(pv_lock_ops.lock_spinning, lock, ticket);
 }
 
-static inline void ____ticket_unlock_kick(struct arch_spinlock *lock, unsigned ticket)
+static inline void __ticket_unlock_kick(struct arch_spinlock *lock, unsigned ticket)
 {
 	PVOP_VCALL2(pv_lock_ops.unlock_kick, lock, ticket);
 }
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 8d1cb42..70675bc 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -90,10 +90,6 @@ static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock, u
 {
 }
 
-static __always_inline void ____ticket_unlock_kick(struct arch_spinlock *lock, unsigned ticket)
-{
-}
-
 #endif	/* CONFIG_PARAVIRT_SPINLOCKS */
 
 /*
@@ -133,16 +129,6 @@ static __always_inline struct __raw_tickets __ticket_spin_claim(struct arch_spin
 	return tickets.tickets;
 }
 
-/* 
- * If a spinlock has someone waiting on it, then kick the appropriate
- * waiting cpu.
- */
-static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock, __ticket_t next)
-{
-	if (unlikely(lock->tickets.tail != next))
-		____ticket_unlock_kick(lock, next);
-}
-
 static __always_inline void arch_spin_lock(struct arch_spinlock *lock)
 {
 	register struct __raw_tickets inc;
-- 
1.7.2.3

