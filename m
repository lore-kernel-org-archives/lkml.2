Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab1IVCxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 22:53:39 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39925 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab1IVCxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 22:53:37 -0400
X-AuditID: cbfee61b-b7b7fae000005864-af-4e7aa32fe325
Date: Thu, 22 Sep 2011 11:53:35 +0900
From: mhban <mhban@samsung.com>
Subject: [PATCH] ARM: futex: fix clobbering oldval
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        DavidHowells <dhowells@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Reply-to: mhban@samsung.com
Message-id: <1316660015.6872.1.camel@puffmine-laptop>
Organization: SAMSUNG
MIME-version: 1.0
X-Mailer: Evolution 2.28.3
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 22 Sep 2011 02:54:31.0121 (UTC)
 FILETIME=[F3890410:01CC78D2]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes clobbering oldval bug. oldval should be preserved for next
compare operation.

Change-Id: I2a63bc1bdb8de330eb9e1ac02d7da1f77e6e8c3c
Signed-off-by: Minho Ban <mhban@samsung.com>
---
 arch/arm/include/asm/futex.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/futex.h b/arch/arm/include/asm/futex.h
index d2d733c..b0f2e8e 100644
--- a/arch/arm/include/asm/futex.h
+++ b/arch/arm/include/asm/futex.h
@@ -30,14 +30,14 @@
 	__asm__ __volatile__(					\
 	"1:	ldrex	%1, [%2]\n"				\
 	"	" insn "\n"					\
-	"2:	strex	%1, %0, [%2]\n"				\
-	"	teq	%1, #0\n"				\
+	"2:	strex	r5, %0, [%2]\n"				\
+	"	teq	r5, #0\n"				\
 	"	bne	1b\n"					\
 	"	mov	%0, #0\n"				\
 	__futex_atomic_ex_table("%4")				\
 	: "=&r" (ret), "=&r" (oldval)				\
 	: "r" (uaddr), "r" (oparg), "Ir" (-EFAULT)		\
-	: "cc", "memory")
+	: "r5", "cc", "memory")
 
 static inline int
 futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
-- 
1.7.0.4


