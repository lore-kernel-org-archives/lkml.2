Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab2JETnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 15:43:42 -0400
Received: from nm20-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.150]:35837 "HELO
	nm20-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964787Ab2JETng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 15:43:36 -0400
X-Yahoo-Newman-Id: 119548.88533.bm@omp1030.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: FNrbDlwVM1nIs2gUh46jTqFxTwRnxrp5IOxIR0WlVp2Cm6e
 CFzeEL3pd0RwARfX5myvTIWPNr1zn14vVqGw08b9jUXSAeqMdUOdq8nqS5wN
 n7SRyVZQIHN54rrtE.DnT6dhUOq_kHx2hRgD25M25w13zfVQ0VYUczlOf_Hl
 VvmQ7sXsXxb1HsqPz60GOnAruajfBWMmjGBaCeso2KxPEKabnq5emiScXavU
 Tu4bZ.lBEmxR.43dOBHNZFSSonZX1lhkkwnzyRosJ5qLfjE41q7V1YhipntR
 _oTsR2w3fu5wxYmQ0lJH8g8XY1JVTVLq9UYgx9je2ttJP0ftxnbOakBaEKN3
 WUPbET2g.Rdbe5YeDFw9_9VOs6aiJgW1rl46Y0HWjDnvnCkGospBxT_Jbpbf
 mz9CWOlNgTk3EvDDb0Bxh7bQhkJE1kgCydof7gvGB94ZMJJFIZXkO
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH v2 06/10] bug.h: Make BUILD_BUG_ON generate compile-time error
Date: Fri,  5 Oct 2012 14:42:45 -0500
Message-Id: <1349466169-20637-6-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
References: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
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

