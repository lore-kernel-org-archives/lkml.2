Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab3AAWyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 17:54:45 -0500
Received: from nm29-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.255]:47466
	"EHLO nm29-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752532Ab3AAWyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 17:54:31 -0500
X-Yahoo-Newman-Id: 13049.18166.bm@smtp107.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: DOdGKeoVM1lS91i.0evQhnf0o6i3voitNOyoCWybgRCCsmZ
 .ZIwzIe89pffP6sF4pQGzyM1TJBd4pY69bvD4GcDlnD0cbKi01af1LMemt4W
 .He9wPq4cEESXuDSax.cxSVFfZXKXgPk2plzZAYSAnaeChSeD5tQIIqVhds7
 2vdyJfDcRPOz2QaJ6JNnoyH9wjhGR7KAx1u0JuZ3MGZAXX7I3RANSP0CqmVt
 JQS5OClOdA3RDlshot01Ow8TPa7UECzAFi6ijeCfri37MztiMF1YFAlKY9ew
 iJIu5xiIDvG2G._udt8qP7uVed60Tk8NrL31y5__N.jjfHxaq727.bLFbrm3
 .Ez6BFLtsy7ibd74gcb_Ek.zdwhi0a7VbKaz._b4JR9kca9sazgMTcRi4ISk
 QBbdyXG202n_V.VXhotFeZf5_nKa.cSIOu6KK6iHDgUjOSEiGGJ2yHlLAWmo
 jobw_DFKGjXlczXSGX8Eqa0Ag30sM9A--
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
Subject: [PATCH v8 7/9] bug.h: Make BUILD_BUG_ON generate compile-time error
Date: Tue,  1 Jan 2013 16:54:09 -0600
Message-Id: <1357080851-30938-8-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1357080851-30938-1-git-send-email-daniel.santos@pobox.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
 <1357080851-30938-1-git-send-email-daniel.santos@pobox.com>
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
index 0d75762..08d97e9 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -2,6 +2,7 @@
 #define _LINUX_BUG_H
 
 #include <asm/bug.h>
+#include <linux/compiler.h>
 
 enum bug_trap_type {
 	BUG_TRAP_TYPE_NONE = 0,
@@ -43,25 +44,30 @@ struct pt_regs;
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
1.7.8.6

