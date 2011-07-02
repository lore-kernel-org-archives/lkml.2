Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab1GBJ7W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 05:59:22 -0400
Received: from mail.southpole.se ([193.12.106.18]:53325 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab1GBJ7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 05:59:19 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: hans-christian.egtvedt@atmel.com, lethal@linux-sh.org,
        Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 1/2] asm-generic: adapt delay.h to common implementation
Date: Sat,  2 Jul 2011 11:59:13 +0200
Message-Id: <1309600754-21217-1-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Several architectures are using a common delay.h implementation that
appears to have originated with the x86 architecture.  This common
implementation is a bit fuller than the current asm-generic version
and has some compile-time checks that should be interesting for all
architectures.

This patch takes the common delay.h version and replaces the rather
trivial asm-generic version with it.  As no architecture was actually
using asm-generic/delay.h, this change is rather innocuous; it will,
however, allow us to switch at least four architectures over to using
the asm-generic version.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 include/asm-generic/delay.h |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/delay.h b/include/asm-generic/delay.h
index 4586fec..6511b99 100644
--- a/include/asm-generic/delay.h
+++ b/include/asm-generic/delay.h
@@ -1,9 +1,23 @@
 #ifndef __ASM_GENERIC_DELAY_H
 #define __ASM_GENERIC_DELAY_H
 
+/* Undefined functions to get compile-time errors */
+extern void __bad_udelay(void);
+extern void __bad_ndelay(void);
+
 extern void __udelay(unsigned long usecs);
+extern void __ndelay(unsigned long nsecs);
+extern void __const_udelay(unsigned long xloops);
 extern void __delay(unsigned long loops);
 
-#define udelay(n) __udelay(n)
+/* 0x10c7 is 2**32 / 1000000 (rounded up) */
+#define udelay(n) (__builtin_constant_p(n) ? \
+	((n) > 20000 ? __bad_udelay() : __const_udelay((n) * 0x10c7ul)) : \
+	__udelay(n))
+
+/* 0x5 is 2**32 / 1000000000 (rounded up) */
+#define ndelay(n) (__builtin_constant_p(n) ? \
+	((n) > 20000 ? __bad_ndelay() : __const_udelay((n) * 5ul)) : \
+	__ndelay(n))
 
 #endif /* __ASM_GENERIC_DELAY_H */
-- 
1.7.4.1

