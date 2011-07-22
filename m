Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab1GVT6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 15:58:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:38230 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246Ab1GVT6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 15:58:42 -0400
Date: Fri, 22 Jul 2011 19:58:35 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Message-ID: <tip-599c3e7724ab4520c6f11857eb953271d365f842@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
In-Reply-To: <aa7c94ecfbee05a6b8e455271ba0bb467bf33b2f.1308878118.git.jeremy.fitzhardinge@citrix.com>
References: <aa7c94ecfbee05a6b8e455271ba0bb467bf33b2f.1308878118.git.jeremy.fitzhardinge@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] x86, ticketlock: Use xadd helper
Git-Commit-ID: 599c3e7724ab4520c6f11857eb953271d365f842
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Jul 2011 19:58:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  599c3e7724ab4520c6f11857eb953271d365f842
Gitweb:     http://git.kernel.org/tip/599c3e7724ab4520c6f11857eb953271d365f842
Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
AuthorDate: Thu, 23 Jun 2011 18:19:20 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 22 Jul 2011 11:19:05 -0700

x86, ticketlock: Use xadd helper

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Link: http://lkml.kernel.org/r/aa7c94ecfbee05a6b8e455271ba0bb467bf33b2f.1308878118.git.jeremy.fitzhardinge@citrix.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/spinlock.h |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index e07dc41..da196f1 100644
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
