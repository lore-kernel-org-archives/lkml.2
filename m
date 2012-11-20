Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab2KTVIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 16:08:18 -0500
Received: from nm12.access.bullet.mail.mud.yahoo.com ([66.94.237.213]:21807
	"EHLO nm12.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753496Ab2KTVIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 16:08:13 -0500
X-Yahoo-Newman-Id: 32795.4524.bm@smtp108.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 11hDZkYVM1lDHOA_mLWgx015OQBbPYYFLyrf5N8GnDe9W.6
 hAZLybva43YYmMIUkBT99dZqpSHwpz_uax.hHmcc.SqXTTr_yrqK1iBdhp7n
 1yTxGgbT20j2CFaAPOcdUm0cwmyC81xQUKqFgXvX2N8tu7dGo90SrSyMoj3o
 JLAwnVZq93VpcACnWMrffaGA0H17lHhTepKjwrHYYdcF40v6WexbseRvSfxd
 AvjlOTb_NeJOC7NgkCqh5uvojUwbsa.iDLWHMcaneKoiKuUt9xhEGXR1gTfL
 zRBqr2t3t_XvX8BBB7A3yz7oU4FkM6_gkuHSDIkbXkkg2rBCmfiiBZTtr.G3
 m7ho9lBBT81e9hRAoByJJDr4xYzrjMOv_h6RY3mTUGY.4XkOUGvINmCGB8tq
 gdwklIG_PIBfGGr7RoJDh6r6RF79v53Bv3L1jb0ZwVp08h3qADYYj_w--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
        Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH v6 7/9] bug.h: Make BUILD_BUG_ON generate compile-time error
Date: Tue, 20 Nov 2012 15:05:05 -0600
Message-Id: <1353445507-7233-7-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1353444132-6809-1-git-send-email-daniel.santos@pobox.com>
References: <1353444132-6809-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Negative sized arrays wont create a compile-time error in some cases
starting with gcc 4.4 (e.g., inlined functions), but gcc 4.3 introduced
the error function attribute that will.  This patch modifies
BUILD_BUG_ON to behave like BUILD_BUG already does, using the error
function attribute so that you don't have to build the entire kernel to
discover that you have a problem, and then enjoy trying to track it down
from a link-time error.

Also, we are only including asm/bug.h and then expecting that
linux/compiler.h will eventually be included to define __linktime_error
(used in BUILD_BUG_ON). This patch includes it directly for clarity and
to avoid the possibility of changes in <arch>/*/include/asm/bug.h being
changed or not including linux/compiler.h for some reason.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Acked-by: Borislav Petkov <bp@alien8.de>
---
 include/linux/bug.h |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index 98bdbb3d..eb6d715 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -2,6 +2,7 @@
 #define _LINUX_BUG_H
 
 #include <asm/bug.h>
+#include <linux/compiler.h>
 
 enum bug_trap_type {
 	BUG_TRAP_TYPE_NONE = 0,
@@ -42,25 +43,30 @@ struct pt_regs;
  * @condition: the condition which the compiler should know is false.
  *
  * If you have some code which relies on certain constants being equal, or
- * other compile-time-evaluated condition, you should use BUILD_BUG_ON to
+ * some other compile-time-evaluated condition, you should use BUILD_BUG_ON to
  * detect if someone changes it.
  *
- * The implementation uses gcc's reluctance to create a negative array, but
- * gcc (as of 4.4) only emits that error for obvious cases (eg. not arguments
- * to inline functions).  So as a fallback we use the optimizer; if it can't
- * prove the condition is false, it will cause a link error on the undefined
- * "__build_bug_on_failed".  This error message can be harder to track down
- * though, hence the two different methods.
+ * The implementation uses gcc's reluctance to create a negative array, but gcc
+ * (as of 4.4) only emits that error for obvious cases (e.g. not arguments to
+ * inline functions).  Luckily, in 4.3 they added the "error" function
+ * attribute just for this type of case.  Thus, we use a negative sized array
+ * (should always create an error on gcc versions older than 4.4) and then call
+ * an undefined function with the error attribute (should always create an
+ * error on gcc 4.3 and later).  If for some reason, neither creates a
+ * compile-time error, we'll still have a link-time error, which is harder to
+ * track down.
  */
 #ifndef __OPTIMIZE__
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 #else
-extern int __build_bug_on_failed;
-#define BUILD_BUG_ON(condition)					\
-	do {							\
-		bool __cond = !!(condition);			\
-		((void)sizeof(char[1 - 2 * __cond]));		\
-		if (__cond) __build_bug_on_failed = 1;		\
+#define BUILD_BUG_ON(condition)						\
+	do {								\
+		bool __cond = !!(condition);				\
+		extern void __build_bug_on_failed(void)			\
+			__compiletime_error("BUILD_BUG_ON failed");	\
+		if (__cond)						\
+			__build_bug_on_failed();			\
+		((void)sizeof(char[1 - 2 * __cond]));			\
 	} while(0)
 #endif
 
-- 
1.7.3.4

