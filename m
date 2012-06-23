Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab2FWECV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 00:02:21 -0400
Received: from nm5.access.bullet.mail.mud.yahoo.com ([66.94.237.206]:28843
	"HELO nm5.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751471Ab2FWEBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 00:01:39 -0400
X-Yahoo-Newman-Id: 88561.55476.bm@smtp103.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 7yyaw.cVM1l0dg4pXx79MbBIXbFgbrInEduJgtK8oOhQo4l
 96pq5N6r00EawnFBvkcLC8Acpi_pKoMoT_gSpb4ILtyoL9VI3xmNFYkrnBS2
 mbX0KloGwktSl3q.msnnXRYDQLDllkjxIv5Y8dtMscqGTPC_UsOie42Cr1gw
 0fq1S3rQlD.EZYM2KzvqxKdNXugQae_j843D6KdLtZ6o9fkd9RcVVfVEvRUQ
 7wnJVs0IRre.rIwZJZYg2K7V4C3Kd6huf.kgZaeETX3B0FVZhLYcvwQSFtAt
 Nyq72uC9Izyvb1281JCTtkBvzDElaUrr3cJNNiv5_76RDSBxAIWANOeMDpqf
 hQ.zTUoJGMaP5LFLOXUyVzGjEe6UZIRTcdgvJ_FCr2pkXWAAJF6NmzhlOoIh
 JvwaCXCKOVYhcuxTgsboEXFWMd5Gg.kqVSrPffTLzZj.sidvkFggczCaVU.m
 DJ0v.abkX9GtxUpnkqdMeFqeavP10prnCQkXWNqtFIXNjYMk26KsvhqM-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-doc@vger.kernel.org, linux-sparse@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Turner <pjt@google.com>, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Weinberger <richard@nod.at>, Rob Landley <rob@landley.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH v4 8/13] bug.h: Make BUILD_BUG_ON generate compile-time error
Date: Fri, 22 Jun 2012 23:00:43 -0500
Message-Id: <1340424048-7759-9-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
References: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
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
index 298a916..c70b833 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -42,24 +42,28 @@ struct pt_regs;
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

