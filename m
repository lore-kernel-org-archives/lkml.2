Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955Ab1IBA4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 20:56:43 -0400
Received: from claw.goop.org ([74.207.240.146]:43181 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932881Ab1IBAzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 20:55:33 -0400
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
Subject: [PATCH 07/13] x86/ticketlocks: tidy up __ticket_unlock_kick()
Date: Thu,  1 Sep 2011 17:55:00 -0700
Message-Id: <b93e43da28e584058db4a52ad8280269c3b1947e.1314922370.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
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
index 622f3d6..b89699a 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -746,7 +746,7 @@ static inline void __ticket_lock_spinning(struct arch_spinlock *lock, unsigned t
 	PVOP_VCALLEE2(pv_lock_ops.lock_spinning, lock, ticket);
 }
 
-static inline void ____ticket_unlock_kick(struct arch_spinlock *lock, unsigned ticket)
+static inline void __ticket_unlock_kick(struct arch_spinlock *lock, unsigned ticket)
 {
 	PVOP_VCALL2(pv_lock_ops.unlock_kick, lock, ticket);
 }
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 2135a48..365d787 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -78,23 +78,9 @@ static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock, u
 {
 }
 
-static __always_inline void ____ticket_unlock_kick(struct arch_spinlock *lock, unsigned ticket)
-{
-}
-
 #endif	/* CONFIG_PARAVIRT_SPINLOCKS */
 
 
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
 /*
  * Ticket locks are conceptually two parts, one indicating the current head of
  * the queue, and the other indicating the current tail. The lock is acquired
-- 
1.7.6

