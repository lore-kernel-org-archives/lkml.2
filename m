Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab2KTVFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 16:05:47 -0500
Received: from nm29-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.255]:35088
	"EHLO nm29-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753568Ab2KTVF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 16:05:27 -0500
X-Yahoo-Newman-Id: 480976.4524.bm@smtp108.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: KJVsFFcVM1lYtYaN4ZqBg4GTm9s3U0xbFVndiwAYs7L2ExV
 qRiTOcStKQzaH0rQI5knhiPaFNyoubuLJiaimYE2YZ8zB4B6DfTePbsJggZZ
 m2dotddOKzkbSmJyUgSRcMPyDsHXLXZ3.O8vt9TQOAO6uaU1F5RxFbP.K6jh
 or6DO3E9Pgg.gBTjnSzdqAQPKSJxgVLgV1VMCQH4cQF4pZAOIUUzuGYxWTHk
 vKwqMSt7cNdjkwH6GZxS9ot58D1s0OGcwsHnrLlPf5k_w6mcN1UN3nYUS3iA
 IpMVT_Bfzx4pzUQMyGwtpAC18Kh4f7fQtwsJTeAgjy5zLCDnq56G3nb.IK.a
 GIOwQgBUR48Rgs40g.p2gY6y.qmANqHLpzNlzcWTKw8pz7dWwLclIMZbBDHx
 oAws5a4bd9AxblAD9wgZG37LejbEfVzuUr5QUW3ZIWnCeKkXvGB3U0FKdeDg
 f_xaWyWAP188gnGlo.QO0q8jTBa194g--
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
Subject: [PATCH v6 9/9] bug.h, compiler.h: Introduce compiletime_assert & BUILD_BUG_ON_MSG
Date: Tue, 20 Nov 2012 15:05:07 -0600
Message-Id: <1353445507-7233-9-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1353444132-6809-1-git-send-email-daniel.santos@pobox.com>
References: <1353444132-6809-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce compiletime_assert to compiler.h, which moves the details of
how to break a build and emit an error message for a specific compiler
to the headers where these details should be. Following in the tradition
of the POSIX assert macro, compiletime_assert creates a build-time error
when the supplied condition is *false*.

Next, we add BUILD_BUG_ON_MSG to bug.h which simply wraps
compiletime_assert, inverting the logic, so that it fails when the
condition is *true*, consistent with the language "build bug on." This
macro allows you to specify the error message you want emitted when the
supplied condition is true.

Finally, we remove all other code from bug.h that mucks with these
details (BUILD_BUG & BUILD_BUG_ON), and have them all call
BUILD_BUG_ON_MSG.  This not only reduces source code bloat, but also
prevents the possibility of code being changed for one macro and not for
the other (which was previously the case for BUILD_BUG and
BUILD_BUG_ON).

Since __compiletime_error_fallback is now only used in compiler.h, I'm
considering it a private macro and removing the double negation that's
now extraneous.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/bug.h      |   28 +++++++++++++---------------
 include/linux/compiler.h |   26 +++++++++++++++++++++++++-
 2 files changed, 38 insertions(+), 16 deletions(-)

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
index 8e5b9d5..fcc3041 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -299,11 +299,35 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 #ifndef __compiletime_error
 # define __compiletime_error(message)
 # define __compiletime_error_fallback(condition) \
-	do { ((void)sizeof(char[1 - 2*!!(condition)])); } while (0)
+	do { ((void)sizeof(char[1 - 2 * condition])); } while (0)
 #else
 # define __compiletime_error_fallback(condition) do { } while (0)
 #endif
 
+#define __compiletime_assert(condition, msg, prefix, suffix)		\
+	do {								\
+		bool __cond = !(condition);				\
+		extern void prefix ## suffix(void) __compiletime_error(msg); \
+		if (__cond)						\
+			prefix ## suffix();				\
+		__compiletime_error_fallback(__cond);			\
+	} while (0)
+
+#define _compiletime_assert(condition, msg, prefix, suffix) \
+	__compiletime_assert(condition, msg, prefix, suffix)
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
+	_compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
+
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),
-- 
1.7.3.4

