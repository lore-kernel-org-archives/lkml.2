Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab1HVXPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 19:15:39 -0400
Received: from claw.goop.org ([74.207.240.146]:48625 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197Ab1HVXP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 19:15:26 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 08/15] x86/ticketlock: use xadd helper
Date: Mon, 22 Aug 2011 16:15:04 -0700
Message-Id: <82e514016e787feec5568851cafd3234a7b9d307.1314054734.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1314054734.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314054734.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/spinlock.h |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 4857dee..05fd59e 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -71,14 +71,7 @@ static __always_inline struct __raw_tickets __ticket_spin_claim(struct arch_spin
 {
 	register struct __raw_tickets tickets = { .tail = 1 };
 
-	if (sizeof(lock->tickets.head) == sizeof(u8))
-		asm volatile (LOCK_PREFIX "xaddw %w0, %1\n"
-			      : "+r" (tickets), "+m" (lock->tickets)
-			      : : "memory", "cc");
-	else
-		asm volatile (LOCK_PREFIX "xaddl %0, %1\n"
-			     : "+r" (tickets), "+m" (lock->tickets)
-			     : : "memory", "cc");
+	xadd(&lock->tickets, tickets);
 
 	return tickets;
 }
-- 
1.7.6

