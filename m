Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab2BCPGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 10:06:32 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:39668 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634Ab2BCPGb convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 3 Feb 2012 10:06:31 -0500
Message-Id: <4F2C06020200007800071066@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 03 Feb 2012 15:06:26 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: eliminate TICKET_MASK
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The definition of it being questionable already (unnecessarily
including a cast), and it being used in a single place that can be
written shorter without it, remove this #define.

Along the same lines, simplify __ticket_spin_is_locked()'s main
expression, which was the more convoluted way because of needs that
went away with the recent type changes by Jeremy.

This is pure cleanup, no functional change intended.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>

---
 arch/x86/include/asm/spinlock.h       |    4 ++--
 arch/x86/include/asm/spinlock_types.h |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

--- 3.3-rc2/arch/x86/include/asm/spinlock.h
+++ 3.3-rc2-x86-ticket-mask/arch/x86/include/asm/spinlock.h
@@ -88,14 +88,14 @@ static inline int __ticket_spin_is_locke
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
--- 3.3-rc2/arch/x86/include/asm/spinlock_types.h
+++ 3.3-rc2-x86-ticket-mask/arch/x86/include/asm/spinlock_types.h
@@ -16,7 +16,6 @@ typedef u32 __ticketpair_t;
 #endif
 
 #define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
-#define TICKET_MASK	((__ticket_t)((1 << TICKET_SHIFT) - 1))
 
 typedef struct arch_spinlock {
 	union {



