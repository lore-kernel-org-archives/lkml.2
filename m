Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934955Ab2C3W7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:59:49 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41906 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934873Ab2C3VF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:26 -0400
Message-Id: <201203302105.q2UL53K2006282@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 14:05:04 -0400
Subject: [PATCH] arch/tile: make sure to build memcpy_user_64 without frame pointer
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:03.0897 (UTC) FILETIME=[C6FEC890:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a comment explaining why this is important, and add a CFLAGS_REMOVE
clause to the Makefile to make sure it happens.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/lib/Makefile         |    1 +
 arch/tile/lib/memcpy_user_64.c |    8 +++++++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/tile/lib/Makefile b/arch/tile/lib/Makefile
index 0c26086..985f598 100644
--- a/arch/tile/lib/Makefile
+++ b/arch/tile/lib/Makefile
@@ -7,6 +7,7 @@ lib-y = cacheflush.o checksum.o cpumask.o delay.o uaccess.o \
 	strchr_$(BITS).o strlen_$(BITS).o
 
 ifeq ($(CONFIG_TILEGX),y)
+CFLAGS_REMOVE_memcpy_user_64.o = -fno-omit-frame-pointer
 lib-y += memcpy_user_64.o
 else
 lib-y += atomic_32.o atomic_asm_32.o memcpy_tile64.o
diff --git a/arch/tile/lib/memcpy_user_64.c b/arch/tile/lib/memcpy_user_64.c
index 4763b3a..37440ca 100644
--- a/arch/tile/lib/memcpy_user_64.c
+++ b/arch/tile/lib/memcpy_user_64.c
@@ -14,7 +14,13 @@
  * Do memcpy(), but trap and return "n" when a load or store faults.
  *
  * Note: this idiom only works when memcpy() compiles to a leaf function.
- * If "sp" is updated during memcpy, the "jrp lr" will be incorrect.
+ * Here leaf function not only means it does not have calls, but also
+ * requires no stack operations (sp, stack frame pointer) and no
+ * use of callee-saved registers, else "jrp lr" will be incorrect since
+ * unwinding stack frame is bypassed. Since memcpy() is not complex so
+ * these conditions are satisfied here, but we need to be careful when
+ * modifying this file. This is not a clean solution but is the best
+ * one so far.
  *
  * Also note that we are capturing "n" from the containing scope here.
  */
-- 
1.6.5.2

