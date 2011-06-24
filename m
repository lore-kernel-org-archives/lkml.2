Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327Ab1FXBU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 21:20:56 -0400
Received: from claw.goop.org ([74.207.240.146]:41620 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760177Ab1FXBT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 21:19:26 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 8/8] x86/ticketlock: use xadd helper
Date: Thu, 23 Jun 2011 18:19:20 -0700
Message-Id: <aa7c94ecfbee05a6b8e455271ba0bb467bf33b2f.1308878118.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <05552e1c97739f589cb76c20b5a6565ccd506636.1308878118.git.jeremy.fitzhardinge@citrix.com>
References: <05552e1c97739f589cb76c20b5a6565ccd506636.1308878118.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/spinlock.h |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index dac6fc6..2d14e7c 100644
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
1.7.5.4

