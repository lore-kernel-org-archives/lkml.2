Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab2KMWOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:14:05 -0500
Received: from nm24-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.182]:32934
	"EHLO nm24-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754780Ab2KMWOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:14:00 -0500
X-Yahoo-Newman-Id: 676555.28409.bm@smtp115.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: t0nVrKcVM1lsRu2X7IPoZMQDekKhtqBVkBAJSJvYCkA_AYY
 n7kMZQYyTZJQrReb4a4ZL19uwbk6yFc7AkltEcyu9IxR49.XTDFZJKAqJvNg
 dOV8FHsFox3akDX5pyyStxN3Y2kzZ7TFyg7FfzmwE2WhEj3QUfyG3EeXXv2S
 pGjwpOFvx3VUPCrVl2zrA6uyK2XFRWhVFnqjw_Tm8GHYoGj0ySee2cPuLkpn
 c.qm4iaTzwyyzNpL0GaPyjietryd522co14Yg6xB.zimgfHzLQgKpxwUEuq8
 LPrR.abfkPzUJKerWZcq7mZwqA5BBDPg8lLZE1O_1ZS.94RhtFQhmihivOnP
 bq8ZVgoHxqBx9hDaW4JW6HZ8gDwZv5lcxKya8MGgAvRBH2_CcHnJ8_zYrpVO
 hH4WBT0rwFh4COzoSKE1BFYZnhrtmxb6B_zldvKDJBGVESTeOUDFZBmBwgpP
 tQRLXpqyVGgmGujV51no95U2kzWEa
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v5 7/9] bug.h: Make BUILD_BUG_ON generate compile-time error
Date: Tue, 13 Nov 2012 16:13:39 -0600
Message-Id: <1352844821-18952-7-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com>
References: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com>
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
index ccd44ce..dd4f506 100644
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
-		((void)sizeof(char[1 - 2*!!(__cond)]));		\
-		if (__cond) __build_bug_on_failed = 1;		\
+#define BUILD_BUG_ON(condition)						\
+	do {								\
+		bool __cond = !!(condition);				\
+		extern void __build_bug_on_failed(void)			\
+			__compiletime_error("BUILD_BUG_ON failed");	\
+		if (__cond)						\
+			__build_bug_on_failed();			\
+		((void)sizeof(char[1 - 2*!!(__cond)]));			\
 	} while(0)
 #endif
 
-- 
1.7.3.4

