Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092Ab2GBUtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:49:55 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:1867 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932078Ab2GBUty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:49:54 -0400
Message-ID: <1341262188.1911.147.camel@x61.thuisdomein>
Subject: [PATCH] ARM: remove asm/locks.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 02 Jul 2012 22:49:48 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 02 Jul 2012 20:49:49.0424 (UTC) FILETIME=[38C1C700:01CD5894]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 64ac24e738823161693bf791f87adc802cf529ff ("Generic semaphore
implementation") removed the last include of this header. Apparently it
was just an oversight to keep this header. It can safely be removed now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested only with various git commands on the (history of the) tree.

 arch/arm/include/asm/locks.h |  274 ------------------------------------------
 1 files changed, 0 insertions(+), 274 deletions(-)
 delete mode 100644 arch/arm/include/asm/locks.h

diff --git a/arch/arm/include/asm/locks.h b/arch/arm/include/asm/locks.h
deleted file mode 100644
index ef4c897..0000000
--- a/arch/arm/include/asm/locks.h
+++ /dev/null
@@ -1,274 +0,0 @@
-/*
- *  arch/arm/include/asm/locks.h
- *
- *  Copyright (C) 2000 Russell King
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- *  Interrupt safe locking assembler. 
- */
-#ifndef __ASM_PROC_LOCKS_H
-#define __ASM_PROC_LOCKS_H
-
-#if __LINUX_ARM_ARCH__ >= 6
-
-#define __down_op(ptr,fail)			\
-	({					\
-	__asm__ __volatile__(			\
-	"@ down_op\n"				\
-"1:	ldrex	lr, [%0]\n"			\
-"	sub	lr, lr, %1\n"			\
-"	strex	ip, lr, [%0]\n"			\
-"	teq	ip, #0\n"			\
-"	bne	1b\n"				\
-"	teq	lr, #0\n"			\
-"	movmi	ip, %0\n"			\
-"	blmi	" #fail				\
-	:					\
-	: "r" (ptr), "I" (1)			\
-	: "ip", "lr", "cc");			\
-	smp_mb();				\
-	})
-
-#define __down_op_ret(ptr,fail)			\
-	({					\
-		unsigned int ret;		\
-	__asm__ __volatile__(			\
-	"@ down_op_ret\n"			\
-"1:	ldrex	lr, [%1]\n"			\
-"	sub	lr, lr, %2\n"			\
-"	strex	ip, lr, [%1]\n"			\
-"	teq	ip, #0\n"			\
-"	bne	1b\n"				\
-"	teq	lr, #0\n"			\
-"	movmi	ip, %1\n"			\
-"	movpl	ip, #0\n"			\
-"	blmi	" #fail "\n"			\
-"	mov	%0, ip"				\
-	: "=&r" (ret)				\
-	: "r" (ptr), "I" (1)			\
-	: "ip", "lr", "cc");			\
-	smp_mb();				\
-	ret;					\
-	})
-
-#define __up_op(ptr,wake)			\
-	({					\
-	smp_mb();				\
-	__asm__ __volatile__(			\
-	"@ up_op\n"				\
-"1:	ldrex	lr, [%0]\n"			\
-"	add	lr, lr, %1\n"			\
-"	strex	ip, lr, [%0]\n"			\
-"	teq	ip, #0\n"			\
-"	bne	1b\n"				\
-"	cmp	lr, #0\n"			\
-"	movle	ip, %0\n"			\
-"	blle	" #wake				\
-	:					\
-	: "r" (ptr), "I" (1)			\
-	: "ip", "lr", "cc");			\
-	})
-
-/*
- * The value 0x01000000 supports up to 128 processors and
- * lots of processes.  BIAS must be chosen such that sub'ing
- * BIAS once per CPU will result in the long remaining
- * negative.
- */
-#define RW_LOCK_BIAS      0x01000000
-#define RW_LOCK_BIAS_STR "0x01000000"
-
-#define __down_op_write(ptr,fail)		\
-	({					\
-	__asm__ __volatile__(			\
-	"@ down_op_write\n"			\
-"1:	ldrex	lr, [%0]\n"			\
-"	sub	lr, lr, %1\n"			\
-"	strex	ip, lr, [%0]\n"			\
-"	teq	ip, #0\n"			\
-"	bne	1b\n"				\
-"	teq	lr, #0\n"			\
-"	movne	ip, %0\n"			\
-"	blne	" #fail				\
-	:					\
-	: "r" (ptr), "I" (RW_LOCK_BIAS)		\
-	: "ip", "lr", "cc");			\
-	smp_mb();				\
-	})
-
-#define __up_op_write(ptr,wake)			\
-	({					\
-	smp_mb();				\
-	__asm__ __volatile__(			\
-	"@ up_op_write\n"			\
-"1:	ldrex	lr, [%0]\n"			\
-"	adds	lr, lr, %1\n"			\
-"	strex	ip, lr, [%0]\n"			\
-"	teq	ip, #0\n"			\
-"	bne	1b\n"				\
-"	movcs	ip, %0\n"			\
-"	blcs	" #wake				\
-	:					\
-	: "r" (ptr), "I" (RW_LOCK_BIAS)		\
-	: "ip", "lr", "cc");			\
-	})
-
-#define __down_op_read(ptr,fail)		\
-	__down_op(ptr, fail)
-
-#define __up_op_read(ptr,wake)			\
-	({					\
-	smp_mb();				\
-	__asm__ __volatile__(			\
-	"@ up_op_read\n"			\
-"1:	ldrex	lr, [%0]\n"			\
-"	add	lr, lr, %1\n"			\
-"	strex	ip, lr, [%0]\n"			\
-"	teq	ip, #0\n"			\
-"	bne	1b\n"				\
-"	teq	lr, #0\n"			\
-"	moveq	ip, %0\n"			\
-"	bleq	" #wake				\
-	:					\
-	: "r" (ptr), "I" (1)			\
-	: "ip", "lr", "cc");			\
-	})
-
-#else
-
-#define __down_op(ptr,fail)			\
-	({					\
-	__asm__ __volatile__(			\
-	"@ down_op\n"				\
-"	mrs	ip, cpsr\n"			\
-"	orr	lr, ip, #128\n"			\
-"	msr	cpsr_c, lr\n"			\
-"	ldr	lr, [%0]\n"			\
-"	subs	lr, lr, %1\n"			\
-"	str	lr, [%0]\n"			\
-"	msr	cpsr_c, ip\n"			\
-"	movmi	ip, %0\n"			\
-"	blmi	" #fail				\
-	:					\
-	: "r" (ptr), "I" (1)			\
-	: "ip", "lr", "cc");			\
-	smp_mb();				\
-	})
-
-#define __down_op_ret(ptr,fail)			\
-	({					\
-		unsigned int ret;		\
-	__asm__ __volatile__(			\
-	"@ down_op_ret\n"			\
-"	mrs	ip, cpsr\n"			\
-"	orr	lr, ip, #128\n"			\
-"	msr	cpsr_c, lr\n"			\
-"	ldr	lr, [%1]\n"			\
-"	subs	lr, lr, %2\n"			\
-"	str	lr, [%1]\n"			\
-"	msr	cpsr_c, ip\n"			\
-"	movmi	ip, %1\n"			\
-"	movpl	ip, #0\n"			\
-"	blmi	" #fail "\n"			\
-"	mov	%0, ip"				\
-	: "=&r" (ret)				\
-	: "r" (ptr), "I" (1)			\
-	: "ip", "lr", "cc");			\
-	smp_mb();				\
-	ret;					\
-	})
-
-#define __up_op(ptr,wake)			\
-	({					\
-	smp_mb();				\
-	__asm__ __volatile__(			\
-	"@ up_op\n"				\
-"	mrs	ip, cpsr\n"			\
-"	orr	lr, ip, #128\n"			\
-"	msr	cpsr_c, lr\n"			\
-"	ldr	lr, [%0]\n"			\
-"	adds	lr, lr, %1\n"			\
-"	str	lr, [%0]\n"			\
-"	msr	cpsr_c, ip\n"			\
-"	movle	ip, %0\n"			\
-"	blle	" #wake				\
-	:					\
-	: "r" (ptr), "I" (1)			\
-	: "ip", "lr", "cc");			\
-	})
-
-/*
- * The value 0x01000000 supports up to 128 processors and
- * lots of processes.  BIAS must be chosen such that sub'ing
- * BIAS once per CPU will result in the long remaining
- * negative.
- */
-#define RW_LOCK_BIAS      0x01000000
-#define RW_LOCK_BIAS_STR "0x01000000"
-
-#define __down_op_write(ptr,fail)		\
-	({					\
-	__asm__ __volatile__(			\
-	"@ down_op_write\n"			\
-"	mrs	ip, cpsr\n"			\
-"	orr	lr, ip, #128\n"			\
-"	msr	cpsr_c, lr\n"			\
-"	ldr	lr, [%0]\n"			\
-"	subs	lr, lr, %1\n"			\
-"	str	lr, [%0]\n"			\
-"	msr	cpsr_c, ip\n"			\
-"	movne	ip, %0\n"			\
-"	blne	" #fail				\
-	:					\
-	: "r" (ptr), "I" (RW_LOCK_BIAS)		\
-	: "ip", "lr", "cc");			\
-	smp_mb();				\
-	})
-
-#define __up_op_write(ptr,wake)			\
-	({					\
-	__asm__ __volatile__(			\
-	"@ up_op_write\n"			\
-"	mrs	ip, cpsr\n"			\
-"	orr	lr, ip, #128\n"			\
-"	msr	cpsr_c, lr\n"			\
-"	ldr	lr, [%0]\n"			\
-"	adds	lr, lr, %1\n"			\
-"	str	lr, [%0]\n"			\
-"	msr	cpsr_c, ip\n"			\
-"	movcs	ip, %0\n"			\
-"	blcs	" #wake				\
-	:					\
-	: "r" (ptr), "I" (RW_LOCK_BIAS)		\
-	: "ip", "lr", "cc");			\
-	smp_mb();				\
-	})
-
-#define __down_op_read(ptr,fail)		\
-	__down_op(ptr, fail)
-
-#define __up_op_read(ptr,wake)			\
-	({					\
-	smp_mb();				\
-	__asm__ __volatile__(			\
-	"@ up_op_read\n"			\
-"	mrs	ip, cpsr\n"			\
-"	orr	lr, ip, #128\n"			\
-"	msr	cpsr_c, lr\n"			\
-"	ldr	lr, [%0]\n"			\
-"	adds	lr, lr, %1\n"			\
-"	str	lr, [%0]\n"			\
-"	msr	cpsr_c, ip\n"			\
-"	moveq	ip, %0\n"			\
-"	bleq	" #wake				\
-	:					\
-	: "r" (ptr), "I" (1)			\
-	: "ip", "lr", "cc");			\
-	})
-
-#endif
-
-#endif
-- 
1.7.7.6

