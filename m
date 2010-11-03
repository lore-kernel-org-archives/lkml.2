Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab0KCPBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:01:44 -0400
Received: from claw.goop.org ([74.207.240.146]:42056 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486Ab0KCPBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:01:41 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 13/20] x86/pvticketlock: make sure unlock is seen by everyone before checking waiters
Date: Wed,  3 Nov 2010 10:59:54 -0400
Message-Id: <e55c733c02d264e4929681b3ba8d43ec240b626d.1288794124.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

If we don't put a real memory barrier between the unlocking increment
of the queue head and the check for lock waiters, we can end up with a
deadlock as a result of the unload write being reordered with respect
to the waiters read.  In effect, the check on the waiters count could
happen before the unlock, which leads to a deadlock:

	unlocker		locker
	check waiters (none)
				check lock head (timeout)
				add to waiters
				block
	release lock		=> deadlock

Adding a mb() barrier prevents the unlocker's waiter check from happening
before the lock release.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/spinlock.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 3deabca..b9a1aae 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -88,6 +88,13 @@ static inline void __ticket_sub_waiting(struct arch_spinlock *lock)
 
 static __always_inline bool __ticket_lock_waiters(const struct arch_spinlock *lock)
 {
+	/*
+	 * Make sure everyone sees the unlock write before we check the
+	 * waiting count.  The processor ordering doesn't guarantee this
+	 * because they're different memory locations.
+	 */
+	mb();
+
 	return ACCESS_ONCE(lock->waiting) != 0;
 }
 #endif	/* CONFIG_PARAVIRT_SPINLOCKS */
-- 
1.7.2.3

