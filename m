Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3ACKNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 05:13:14 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:38649 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab3ACKNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:13:11 -0500
From: kpark3469@gmail.com
To: rostedt@goodmis.org
Cc: fweisbec@gmail.com, mingo@redhat.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sahara <keun-o.park@windriver.com>
Subject: [PATCH 2/2] arm: make return_address available for ARM_UNWIND
Date: Thu,  3 Jan 2013 19:12:29 +0900
Message-Id: <1357207949-3349-2-git-send-email-kpark3469@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1357207949-3349-1-git-send-email-kpark3469@gmail.com>
References: <1357207949-3349-1-git-send-email-kpark3469@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: sahara <keun-o.park@windriver.com>

This fixes a warning saying:

    warning: #warning "TODO: return_address should use unwind tables"

And, this enables return_address using unwind information. If ARM_UNWIND is
selected, unwind_frame in unwind.c will be called in walk_stackframe.

Signed-off-by: sahara <keun-o.park@windriver.com>
---
 arch/arm/include/asm/ftrace.h    |    6 ++----
 arch/arm/kernel/return_address.c |   10 +++-------
 arch/arm/kernel/stacktrace.c     |    3 +++
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
index f89515a..3552ad9 100644
--- a/arch/arm/include/asm/ftrace.h
+++ b/arch/arm/include/asm/ftrace.h
@@ -32,13 +32,11 @@ extern void ftrace_call_old(void);
 
 #ifndef __ASSEMBLY__
 
-#if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND)
+#if defined(CONFIG_FRAME_POINTER) || defined(CONFIG_ARM_UNWIND)
 /*
  * return_address uses walk_stackframe to do it's work.  If both
  * CONFIG_FRAME_POINTER=y and CONFIG_ARM_UNWIND=y walk_stackframe uses unwind
- * information.  For this to work in the function tracer many functions would
- * have to be marked with __notrace.  So for now just depend on
- * !CONFIG_ARM_UNWIND.
+ * information.
  */
 
 void *return_address(unsigned int);
diff --git a/arch/arm/kernel/return_address.c b/arch/arm/kernel/return_address.c
index fafedd8..f202bc0 100644
--- a/arch/arm/kernel/return_address.c
+++ b/arch/arm/kernel/return_address.c
@@ -11,7 +11,7 @@
 #include <linux/export.h>
 #include <linux/ftrace.h>
 
-#if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND)
+#if defined(CONFIG_FRAME_POINTER) || defined(CONFIG_ARM_UNWIND)
 #include <linux/sched.h>
 
 #include <asm/stacktrace.h>
@@ -57,17 +57,13 @@ void *return_address(unsigned int level)
 		return NULL;
 }
 
-#else /* if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND) */
-
-#if defined(CONFIG_ARM_UNWIND)
-#warning "TODO: return_address should use unwind tables"
-#endif
+#else /* CONFIG_FRAME_POINTER || CONFIG_ARM_UNWIND */
 
 void *return_address(unsigned int level)
 {
 	return NULL;
 }
 
-#endif /* if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND) / else */
+#endif /* CONFIG_FRAME_POINTER || CONFIG_ARM_UNWIND */
 
 EXPORT_SYMBOL_GPL(return_address);
diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index 00f79e5..aab144b 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -6,6 +6,9 @@
 
 #if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND)
 /*
+ * If both CONFIG_FRAME_POINTER=y and CONFIG_ARM_UNWIND=y walk_stackframe uses
+ * unwind information. So for now just depend on !CONFIG_ARM_UNWIND.
+ *
  * Unwind the current stack frame and store the new register values in the
  * structure passed as argument. Unwinding is equivalent to a function return,
  * hence the new PC value rather than LR should be used for backtrace.
-- 
1.7.1

