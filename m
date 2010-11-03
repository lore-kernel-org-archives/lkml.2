Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab0KCPCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:02:05 -0400
Received: from claw.goop.org ([74.207.240.146]:42040 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463Ab0KCPBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:01:37 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 15/20] x86/ticketlock: prevent compiler reordering into locked region
Date: Wed,  3 Nov 2010 10:59:56 -0400
Message-Id: <12a3251ccc2f0265678e3d1a3ad2faf6fb7f4725.1288794124.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Add a barrier() at the end of __raw_spin_unlock() to prevent instructions
from after the locked region from being reordered into it.  In theory doing
so shouldn't cause any problems, but in practice, the system locks up
under load...

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/spinlock.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index d6de5e7..158b330 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -189,6 +189,8 @@ static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
 	next = lock->tickets.head + 1;
 	__ticket_unlock_release(lock);
 	__ticket_unlock_kick(lock, next);
+
+	barrier();		/* prevent reordering into locked region */
 }
 
 static inline int arch_spin_is_locked(arch_spinlock_t *lock)
-- 
1.7.2.3

