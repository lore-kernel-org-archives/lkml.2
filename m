Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab2BGTlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:41:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40851 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604Ab2BGTll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:41:41 -0500
Date: Tue, 7 Feb 2012 11:40:08 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-7931d493051ea9b09e4fddee2dc40b2eb88d62b9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        jbeulich@suse.com, jeremy@goop.org, akpm@linux-foundation.org,
        JBeulich@suse.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        jbeulich@suse.com, jeremy@goop.org, akpm@linux-foundation.org,
        JBeulich@suse.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4F2C06020200007800071066@nat28.tlf.novell.com>
References: <4F2C06020200007800071066@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86/spinlocks: Eliminate TICKET_MASK
Git-Commit-ID: 7931d493051ea9b09e4fddee2dc40b2eb88d62b9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 07 Feb 2012 11:40:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7931d493051ea9b09e4fddee2dc40b2eb88d62b9
Gitweb:     http://git.kernel.org/tip/7931d493051ea9b09e4fddee2dc40b2eb88d62b9
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Fri, 3 Feb 2012 15:06:26 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Feb 2012 10:09:54 +0100

x86/spinlocks: Eliminate TICKET_MASK

The definition of it being questionable already (unnecessarily
including a cast), and it being used in a single place that can
be written shorter without it, remove this #define.

Along the same lines, simplify __ticket_spin_is_locked()'s main
expression, which was the more convoluted way because of needs
that went away with the recent type changes by Jeremy.

This is pure cleanup, no functional change intended.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4F2C06020200007800071066@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/spinlock.h       |    4 ++--
 arch/x86/include/asm/spinlock_types.h |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index a82c2bf..76bfa2c 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -88,14 +88,14 @@ static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
 {
 	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
 
-	return !!(tmp.tail ^ tmp.head);
+	return tmp.tail != tmp.head;
 }
 
 static inline int __ticket_spin_is_contended(arch_spinlock_t *lock)
 {
 	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
 
-	return ((tmp.tail - tmp.head) & TICKET_MASK) > 1;
+	return (__ticket_t)(tmp.tail - tmp.head) > 1;
 }
 
 #ifndef CONFIG_PARAVIRT_SPINLOCKS
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index 8ebd5df..ad0ad07 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -16,7 +16,6 @@ typedef u32 __ticketpair_t;
 #endif
 
 #define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
-#define TICKET_MASK	((__ticket_t)((1 << TICKET_SHIFT) - 1))
 
 typedef struct arch_spinlock {
 	union {
