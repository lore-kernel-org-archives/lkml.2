Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1A0LyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 06:54:04 -0500
Received: from [114.251.86.0] ([114.251.86.0]:25837 "EHLO enigma.site"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754013Ab1A0LyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 06:54:03 -0500
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Jan 2011 06:54:02 EST
From: Coly Li <bosong.ly@taobao.com>
To: linux-kernel@vger.kernel.org
Cc: Coly Li <bosong.ly@taobao.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        David Daney <ddaney@caviumnetworks.com>,
        Wang Cong <xiyou.wangcong@gmail.com>,
        Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH 2/7] PowerPC: add unlikely() to BUG_ON()
Date: Thu, 27 Jan 2011 20:12:31 +0800
Message-Id: <1296130356-29896-3-git-send-email-bosong.ly@taobao.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296130356-29896-1-git-send-email-bosong.ly@taobao.com>
References: <1296130356-29896-1-git-send-email-bosong.ly@taobao.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current BUG_ON() arch/powerpc/include/asm/bug.h does not use unlikely(),
in order to get better branch predict result, source code may have to call
BUG_ON() with unlikely() explicitly. This is not a suggested method
to use BUG_ON().

This patch adds unlikely() inside BUG_ON implementation on PPC
code, callers can use BUG_ON without explicit unlikely() now.

I don't have any PPC hardware to compile and test this fix, any feedback
of this patch is welcome.

Signed-off-by: Coly Li <bosong.ly@taobao.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Daney <ddaney@caviumnetworks.com>
Cc: Wang Cong <xiyou.wangcong@gmail.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>
diff --git a/arch/powerpc/include/asm/bug.h b/arch/powerpc/include/asm/bug.h
index 065c590..10889a6 100644
--- a/arch/powerpc/include/asm/bug.h
+++ b/arch/powerpc/include/asm/bug.h
@@ -2,6 +2,7 @@
 #define _ASM_POWERPC_BUG_H
 #ifdef __KERNEL__
 
+#include <linux/compiler.h>
 #include <asm/asm-compat.h>
 
 /*
@@ -71,7 +72,7 @@
 	unreachable();						\
 } while (0)
 
-#define BUG_ON(x) do {						\
+#define __BUG_ON(x) do {					\
 	if (__builtin_constant_p(x)) {				\
 		if (x)						\
 			BUG();					\
@@ -85,6 +86,8 @@
 	}							\
 } while (0)
 
+#define BUG_ON(x) __BUG_ON(unlikely(x))
+
 #define __WARN_TAINT(taint) do {				\
 	__asm__ __volatile__(					\
 		"1:	twi 31,0,0\n"				\
