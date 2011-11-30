Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab1K3Kmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 05:42:50 -0500
Received: from www.linutronix.de ([62.245.132.108]:37121 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756Ab1K3Kmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 05:42:49 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] x86/div64: add a shortcut if base is power of two
Date: Wed, 30 Nov 2011 11:43:34 +0100
Message-Id: <1322649814-544-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.7.3
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the target code I have a do_div(x, PAGE_SIZE). The x86-64 version of
it was doing a shift and a mask which is clever. The 32bit version of it
had a div operation in it which made me think. After digging I noticed
that x86 has an optimized version of it.
This patch adds this shift and mask optimization if base is constant so
we don't have any runtime "checking" overhead since most users use a
power of ten.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/include/asm/div64.h |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/div64.h b/arch/x86/include/asm/div64.h
index 9a2d644..ced283a 100644
--- a/arch/x86/include/asm/div64.h
+++ b/arch/x86/include/asm/div64.h
@@ -4,6 +4,7 @@
 #ifdef CONFIG_X86_32
 
 #include <linux/types.h>
+#include <linux/log2.h>
 
 /*
  * do_div() is NOT a C function. It wants to return
@@ -21,15 +22,20 @@
 ({								\
 	unsigned long __upper, __low, __high, __mod, __base;	\
 	__base = (base);					\
-	asm("":"=a" (__low), "=d" (__high) : "A" (n));		\
-	__upper = __high;					\
-	if (__high) {						\
-		__upper = __high % (__base);			\
-		__high = __high / (__base);			\
+	if (__builtin_constant_p(__base) && is_power_of_2(__base)) { \
+		__mod = n & (__base - 1);			\
+		n >>= ilog2(__base);				\
+	} else {						\
+		asm("" : "=a" (__low), "=d" (__high) : "A" (n));\
+		__upper = __high;				\
+		if (__high) {					\
+			__upper = __high % (__base);		\
+			__high = __high / (__base);		\
+		}						\
+		asm("divl %2" : "=a" (__low), "=d" (__mod)	\
+			: "rm" (__base), "0" (__low), "1" (__upper));	\
+		asm("" : "=A" (n) : "a" (__low), "d" (__high));	\
 	}							\
-	asm("divl %2":"=a" (__low), "=d" (__mod)		\
-	    : "rm" (__base), "0" (__low), "1" (__upper));	\
-	asm("":"=A" (n) : "a" (__low), "d" (__high));		\
 	__mod;							\
 })
 
-- 
1.7.7.3

