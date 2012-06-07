Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760448Ab2FGJPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 05:15:36 -0400
Received: from nm14-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.162]:20451
	"HELO nm14-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760430Ab2FGJPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 05:15:35 -0400
X-Yahoo-Newman-Id: 895811.68524.bm@omp1013.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 7kLhFDAVM1nzOjCyq4obEZWcJ5.VsbjfL_Il9AtrKcsa3Zj
 WCiSRSmUCFtlyjW92P8E5ZHmt88UOVfWk8b_hDoAWu2exkDy3bpZiZEgH33a
 TV1gN8jY0JNBPLbuNKOG3GZCGvp9NhgSpCiBwDPoqMqUMod7OHYz96Qmt_zA
 rrou29NI.pRG09fDHpW8cJRmGuF0ZpTPg8EbVVppXBixZnmiASnezJpF.Npj
 ltyCKwWOPV2uOvP0fSC1X5PMvY4Y0pmEiwypZET3M.ZrUxa3zpmtGivtigqd
 1Y_1.lEKwHEDi.sZHHb5x1d5nNTzZcIJvptHKl5QZaDtWt6oxad.xc0zIWTG
 qlD.RRipnKZHEay_fpTjc2cczTpAXclY3QUttta3TOCLhek3Gn5C4I5P.DX9
 Ss3VH4Q--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FD0713A.60000@att.net>
Date: Thu, 07 Jun 2012 04:15:38 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCHv3 4/6] [RFC] bug.h: make BUILD_BUG_ON generate compile-time
 error
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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

This is not only nicer, but it makes it behave consistiently with
BUILD_BUG.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/bug.h |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index 298a916..7323287 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -42,24 +42,27 @@ struct pt_regs;
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
+		if (condition) __build_bug_on_failed();			\
 	} while(0)
 #endif
 -- 1.7.3.4

