Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab2IYXh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:37:28 -0400
Received: from nm32-vm3.bullet.mail.ne1.yahoo.com ([98.138.229.51]:27862 "HELO
	nm32-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752598Ab2IYXh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:37:27 -0400
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Sep 2012 19:37:27 EDT
X-Yahoo-Newman-Id: 789393.23681.bm@omp1030.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 7Jnnp24VM1m4qoQ9AffnLteZR5DR5YcnV195sT1vcTnfxmq
 KvltnAZCQqhv6oJrINu2eyYJuvDa0gqbmdlFCoXpRmoJxQVWN4nkDvM4g7Xd
 MKD3Vgbqo9JeHL1S9FMeUjsu6qOwK1W5PBRCIXDprByZPK1MErZzwLJG.X9W
 l_pgxTw_CAfRaSTVAN3RNNBhZJ.hi.i1nFIj0BEvEsoR0.GXcY5FJr5VWDB7
 gWIECC6b_G2ekLiLgfWsY2BWZoxMEMcd5O4blEUxEshXa_eiVecVMcgmL5g.
 pGm5a4VRLFTPt9ZXzgYTntRaFKw75Hj0zA461204LVLH34YJCCFSVGgk.Ppg
 Lcw5aUuPKo0zPcXB62S9i9S8xFfRAeFhFcLluBpGeT1Q70KGNTDph4eQJiak
 CI2Zi_sOLjMDnOova6AMnD7BE6bkLhQEsIKOxNkyUHEpUjT6Jt1.A7A--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Daniel Santos <daniel.santos@pobox.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        LKML <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH v5 8/25] bug.h: Make BUILD_BUG_ON generate compile-time error
Date: Tue, 25 Sep 2012 18:30:52 -0500
Message-Id: <1348615852-10226-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
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

