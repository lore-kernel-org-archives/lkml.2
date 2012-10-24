Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab2JXQmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:42:14 -0400
Received: from nm27.access.bullet.mail.sp2.yahoo.com ([98.139.44.154]:46381
	"EHLO nm27.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935194Ab2JXQj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:39:58 -0400
X-Yahoo-Newman-Id: 265290.79197.bm@smtp105.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: oycLA7oVM1nmvGXeQz1DLxc9bbV2Xqy00DT2_14TKFUBHXA
 QhQsqzTE2G1HwCu.O0gF5ZpMYtGhq7u_8yC0Pu4ARaLpqWtpkna5u2EDljrn
 0NP9MNAUOCBkp8RcHeCOzHa4Z0eKLbRtwe6sQ6Dfiwx5HfWMURbJbPoDbq7t
 rfcKoqPOoGhcN9.xUHwwNCg5RFthauOOaDla1TToaZ3bN5wUH4fWwLbNVDPf
 T4zvxKQsTl8eqEn558pyv2M4iX6a_VKerQOFxs7WcTlb2COHQwnnHH6TP6Cq
 OWojmnfEhNHE9V1dMr1ELDtDLqr.tbGyErp0wGF5ArUc3I98C9hmisb_Y7Lq
 AzHX8Km9piquDQPK9U9v6Q8VRtAKHYcA7XBCyDBxjK1rfUM0i0Cog4Df4XZA
 URzTfx1gJI_UGL752d2G40HdBq319Ayx3lx9qftCXlCwaErq9rrjq
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@alien8.de>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH v3 06/10] bug.h: Make BUILD_BUG_ON generate compile-time error
Date: Wed, 24 Oct 2012 11:33:57 -0500
Message-Id: <1351096441-12388-6-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1351096132-12244-1-git-send-email-daniel.santos@pobox.com>
References: <1351096132-12244-1-git-send-email-daniel.santos@pobox.com>
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

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/bug.h |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index a03c3ef..3d4b564 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -43,24 +43,28 @@ struct pt_regs;
  * @condition: the condition which the compiler should know is false.
  *
  * If you have some code which relies on certain constants being equal, or
- * other compile-time-evaluated condition, you should use BUILD_BUG_ON to
+ * some other compile-time-evaluated condition, you should use BUILD_BUG_ON to
  * detect if someone changes it.
  *
  * The implementation uses gcc's reluctance to create a negative array, but
  * gcc (as of 4.4) only emits that error for obvious cases (eg. not arguments
- * to inline functions).  So as a fallback we use the optimizer; if it can't
- * prove the condition is false, it will cause a link error on the undefined
- * "__build_bug_on_failed".  This error message can be harder to track down
- * though, hence the two different methods.
+ * to inline functions).  Luckily, in 4.3 they added the "error" function
+ * attribute just for this type of case.  Thus, we use a negative sized array
+ * (should always create an error pre-gcc-4.4) and then call an undefined
+ * function with the error attribute (should always creates an error 4.3+).  If
+ * for some reason, neither creates a compile-time error, we'll still have a
+ * link-time error, which is harder to track down.
  */
 #ifndef __OPTIMIZE__
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 #else
-extern int __build_bug_on_failed;
-#define BUILD_BUG_ON(condition)					\
-	do {							\
-		((void)sizeof(char[1 - 2*!!(condition)]));	\
-		if (condition) __build_bug_on_failed = 1;	\
+#define BUILD_BUG_ON(condition)						\
+	do {								\
+		extern void __build_bug_on_failed(void)			\
+			__compiletime_error("BUILD_BUG_ON failed");	\
+		((void)sizeof(char[1 - 2*!!(condition)]));		\
+		if (condition)						\
+			__build_bug_on_failed();			\
 	} while(0)
 #endif
 
-- 
1.7.3.4

