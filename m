Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab2KMWOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:14:34 -0500
Received: from nm29-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.192]:21587
	"EHLO nm29-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754913Ab2KMWOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:14:04 -0500
X-Yahoo-Newman-Id: 694330.28409.bm@smtp115.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: _8FtTKkVM1l1iBMV2NtfhOh30VbwvxZNPVE0C6f7BpSPK29
 cpxdkAohaIjxqaVd_FC1wyzvoMtt7wm6U_KNUalbIw07IeKbyu4hWEpWWj4f
 v1BknHdfKTx.0lFXKjMYbjz4iQVb6blgaNOY9T2Q0XMZvw00GznMVYWaLmbd
 188BSJ7FIzUgEXedJe4pXB9P4GA43RgeyIVpCyfARHC_mr7UE_N9mQ0BiJ0T
 GKywnJ2BmsoQuRNwDYepCU6SQ__vV9JCHaTwKHPb76pMDJnQVIF4.GeOmTWO
 _bFkWpWOHyjVvk3FSUPzuw9ouRspejvzRB6KPIvbxFLL3SPu6SjSls_96Yps
 kkzeXGbzZGwiiAmf90..T1sdJu5ptfluPWBs6yGBPHHU0DTmWgLkm0Gx3_WE
 CMpfoLXyPrq3mFqqp4NHWDiysJ3ZO701mdyuBh2haCUdYkxSMvbHJvrp7u25
 ji.7_lSEvwqCKBEYYBMEPbfZL_gSx
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
Subject: [PATCH v5 9/9] bug.h, compiler.h: Introduce compiletime_assert & BUILD_BUG_ON_MSG
Date: Tue, 13 Nov 2012 16:13:41 -0600
Message-Id: <1352844821-18952-9-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com>
References: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce compiletime_assert to compiler.h, which moves the details of
how to break a build and emit an error message for a specific compiler
to the headers where these details should be. Following the tradition of
the POSIX assert macro, compiletime_assert creates a build-time error
when the supplied condition is *false*.

Next, we add BUILD_BUG_ON_MSG to bug.h which simply wraps
compiletime_assert, inverting the logic, so that it fails when the
condition is *true*, consistient with the language "build bug on." This
macro allows you to specify the error message you want emitted when the
supplied condition is true.

Finally, we remove all other code from bug.h that mucks with these
details (BUILD_BUG & BUILD_BUG_ON), and have them all call
BUILD_BUG_ON_MSG.  This not only reduces source code bloat, but also
prevents the possibility of code being changed for one macro and not for
the other (which was previously the case for BUILD_BUG and
BUILD_BUG_ON).

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/bug.h      |   28 +++++++++++++---------------
 include/linux/compiler.h |   24 ++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index 125e744..31a1310 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -16,6 +16,7 @@ struct pt_regs;
 #define BUILD_BUG_ON_NOT_POWER_OF_2(n) (0)
 #define BUILD_BUG_ON_ZERO(e) (0)
 #define BUILD_BUG_ON_NULL(e) ((void*)0)
+#define BUILD_BUG_ON_MSG(cond, msg) (0)
 #define BUILD_BUG_ON(condition) (0)
 #define BUILD_BUG() (0)
 #else /* __CHECKER__ */
@@ -39,6 +40,15 @@ struct pt_regs;
 #define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
 
 /**
+ * BUILD_BUG_ON_MSG - break compile if a condition is true & emit supplied
+ * 		      error message.
+ * @condition: the condition which the compiler should know is false.
+ *
+ * See BUILD_BUG_ON for description.
+ */
+#define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
+
+/**
  * BUILD_BUG_ON - break compile if a condition is true.
  * @condition: the condition which the compiler should know is false.
  *
@@ -59,15 +69,8 @@ struct pt_regs;
 #ifndef __OPTIMIZE__
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 #else
-#define BUILD_BUG_ON(condition)						\
-	do {								\
-		bool __cond = !!(condition);				\
-		extern void __build_bug_on_failed(void)			\
-			__compiletime_error("BUILD_BUG_ON failed");	\
-		if (__cond)						\
-			__build_bug_on_failed();			\
-		__compiletime_error_fallback(__cond);			\
-	} while(0)
+#define BUILD_BUG_ON(condition) \
+	BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
 #endif
 
 /**
@@ -77,12 +80,7 @@ struct pt_regs;
  * build time, you should use BUILD_BUG to detect if it is
  * unexpectedly used.
  */
-#define BUILD_BUG()						\
-	do {							\
-		extern void __build_bug_failed(void)		\
-			__compiletime_error("BUILD_BUG failed");\
-		__build_bug_failed();				\
-	} while (0)
+#define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
 
 #endif	/* __CHECKER__ */
 
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 8e5b9d5..57878f3 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -304,6 +304,30 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 # define __compiletime_error_fallback(condition) do { } while (0)
 #endif
 
+#define __compiletime_assert(condition, msg, __func)			\
+	do {								\
+		bool __cond = !(condition);				\
+		extern void __func(void) __compiletime_error(msg);	\
+		if (__cond)						\
+			__func();					\
+		__compiletime_error_fallback(__cond);			\
+	} while (0)
+
+#define _compiletime_assert(condition, msg, __func) \
+	__compiletime_assert(condition, msg, __func)
+
+/**
+ * compiletime_assert - break build and emit msg if condition is false
+ * @condition: a compile-time constant condition to check
+ * @msg:       a message to emit if condition is false
+ *
+ * In tradition of POSIX assert, this macro will break the build if the
+ * supplied condition is *false*, emitting the supplied error message if the
+ * compiler has support to do so.
+ */
+#define compiletime_assert(condition, msg) \
+	_compiletime_assert(condition, msg, __compiletime_assert_ ## __LINE__)
+
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),
-- 
1.7.3.4

