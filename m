Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab2CVVRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:17:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:19750 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab2CVVRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:17:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="120643374"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Andi Kleen <ak@linux.intel.com>, jeremy@goop.org
Subject: [PATCH] x86, paravirt: Remove CONFIG_PARAVIRT_DEBUG
Date: Thu, 22 Mar 2012 14:17:14 -0700
Message-Id: <1332451034-28437-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

CONFIG_PARAVIRT_DEBUG seems rather useless. It only has a single BUG_ON
on a NULL pointer and that is directly in front of code that references
that pointer anyways and would nicely oops if anything was wrong.

So remove that option.

Cc: jeremy@goop.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/Kconfig                      |    7 -------
 arch/x86/include/asm/paravirt_types.h |    8 --------
 2 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bed94e..ad52be6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -628,13 +628,6 @@ config PARAVIRT_CLOCK
 
 endif
 
-config PARAVIRT_DEBUG
-	bool "paravirt-ops debugging"
-	depends on PARAVIRT && DEBUG_KERNEL
-	---help---
-	  Enable to debug paravirt_ops internals.  Specifically, BUG if
-	  a paravirt_op is missing when it is called.
-
 config NO_BOOTMEM
 	def_bool y
 
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 8e8b9a4..fa317c2 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -526,18 +526,11 @@ int paravirt_disable_iospace(void);
 #define VEXTRA_CLOBBERS	 , "rax", "r8", "r9", "r10", "r11"
 #endif	/* CONFIG_X86_32 */
 
-#ifdef CONFIG_PARAVIRT_DEBUG
-#define PVOP_TEST_NULL(op)	BUG_ON(op == NULL)
-#else
-#define PVOP_TEST_NULL(op)	((void)op)
-#endif
-
 #define ____PVOP_CALL(rettype, op, clbr, call_clbr, extra_clbr,		\
 		      pre, post, ...)					\
 	({								\
 		rettype __ret;						\
 		PVOP_CALL_ARGS;						\
-		PVOP_TEST_NULL(op);					\
 		/* This is 32-bit specific, but is okay in 64-bit */	\
 		/* since this condition will never hold */		\
 		if (sizeof(rettype) > sizeof(unsigned long)) {		\
@@ -577,7 +570,6 @@ int paravirt_disable_iospace(void);
 #define ____PVOP_VCALL(op, clbr, call_clbr, extra_clbr, pre, post, ...)	\
 	({								\
 		PVOP_VCALL_ARGS;					\
-		PVOP_TEST_NULL(op);					\
 		asm volatile(pre					\
 			     paravirt_alt(PARAVIRT_CALL)		\
 			     post					\
-- 
1.7.7.6

