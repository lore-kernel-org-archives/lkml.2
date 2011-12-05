Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab1LESF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:05:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59106 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab1LESF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:05:56 -0500
Date: Mon, 5 Dec 2011 10:05:35 -0800
From: tip-bot for Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Message-ID: <tip-668b44846606185a9bed5a5357bc2cb132e00dd7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, bigeasy@linutronix.de,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        bigeasy@linutronix.de, mingo@elte.hu
In-Reply-To: <1322649814-544-1-git-send-email-bigeasy@linutronix.de>
References: <1322649814-544-1-git-send-email-bigeasy@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86/div64: Add a micro-optimization shortcut if base is power of two
Git-Commit-ID: 668b44846606185a9bed5a5357bc2cb132e00dd7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 10:05:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  668b44846606185a9bed5a5357bc2cb132e00dd7
Gitweb:     http://git.kernel.org/tip/668b44846606185a9bed5a5357bc2cb132e00dd7
Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
AuthorDate: Wed, 30 Nov 2011 11:43:34 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 18:16:11 +0100

x86/div64: Add a micro-optimization shortcut if base is power of two

In the target code I have a do_div(x, PAGE_SIZE). The x86-64
version of it was doing a shift and a mask which is clever. The
32bit version of it had a div operation in it which made me
think. After digging I noticed that x86 has an optimized version
of it. This patch adds this shift and mask optimization if base
is constant so we don't have any runtime "checking" overhead
since most users use a power of ten.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1322649814-544-1-git-send-email-bigeasy@linutronix.de
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
