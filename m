Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946Ab1IBA5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 20:57:37 -0400
Received: from claw.goop.org ([74.207.240.146]:43194 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932860Ab1IBAz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 20:55:29 -0400
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
Subject: [PATCH 09/13] x86/pvticketlocks: we only need to kick if there's waiters
Date: Thu,  1 Sep 2011 17:55:02 -0700
Message-Id: <a2b685fa9d44cf93fc1d1bf69199f5d355e02f82.1314922370.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

If we're releasing the lock into an uncontended state, there's nobody
waiting on it, so there's no need to kick anyone.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/paravirt-spinlocks.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index 21b6986..71b8557 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -47,8 +47,7 @@ void __ticket_unlock_release_slowpath(struct arch_spinlock *lock)
 		    old.head_tail, new.head_tail) != old.head_tail) {
 		/* still people waiting */
 		__ticket_unlock_release(lock);
+		__ticket_unlock_kick(lock, new.tickets.head);
 	}
-
-	__ticket_unlock_kick(lock, new.tickets.head);
 }
 EXPORT_SYMBOL(__ticket_unlock_release_slowpath);
-- 
1.7.6

