Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab3AAWyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 17:54:49 -0500
Received: from nm18-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.23]:40483
	"EHLO nm18-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752556Ab3AAWyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 17:54:35 -0500
X-Yahoo-Newman-Id: 696172.18166.bm@smtp107.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: aXIPX10VM1kIgRcoGcRlN3v_dD922OAxRWy4g5iJFeG6aRx
 AQpmljWiXAmKe.d4Dz68WX2DohRaW8fr.FcPdBiuOJhy.HOFs7TZs4UKgKkw
 IoHkXALz3zG.YIZdgo8aB5sAGHkIbxM7XdcPTpJgCGLXA1eTtlkHvxrmEpxS
 mVNb2HPCk9f2rRHdGxvb7ZsJO.Aqn4IWWPQsIY0_To.pKTkW0knNq_Sk4_Xa
 iAAK_RqYVZDjcpdCl9m0oZn79CQTO8NbZtAJZH4b53OFJdwON5uOHkLp0g_R
 EgWKycoEm6GrrpmIdHPDQJbP4.9z9MU3ty3n5Wm5vDfsc8DmcND54zIxXYdn
 AL7luXVbf5iHt0WPJIJdLoDL8ATdz4lTZOvoGvXjQLFacir2wkB8rBmL_IXJ
 ndsuZ2TZZ8Bc0PDayfqOFFYzSZ4lJDNDXONL5rWLqG341jaLOf9T4NgND4s7
 ULH6FZKU6Z9uPVDRVz0HEIXb7FPT2_g--
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
Subject: [PATCH v8 9/9] bug.h, compiler.h: Introduce compiletime_assert & BUILD_BUG_ON_MSG
Date: Tue,  1 Jan 2013 16:54:11 -0600
Message-Id: <1357080851-30938-10-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1357080851-30938-1-git-send-email-daniel.santos@pobox.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
 <1357080851-30938-1-git-send-email-daniel.santos@pobox.com>
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
index 57c7688..3c09a00 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -17,6 +17,7 @@ struct pt_regs;
 #define BUILD_BUG_ON_ZERO(e) (0)
 #define BUILD_BUG_ON_NULL(e) ((void*)0)
 #define BUILD_BUG_ON_INVALID(e) (0)
+#define BUILD_BUG_ON_MSG(cond, msg) (0)
 #define BUILD_BUG_ON(condition) (0)
 #define BUILD_BUG() (0)
 #else /* __CHECKER__ */
@@ -40,6 +41,15 @@ struct pt_regs;
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
@@ -60,15 +70,8 @@ struct pt_regs;
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
@@ -78,12 +81,7 @@ struct pt_regs;
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
index 423bb6b..10b8f23 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -308,11 +308,35 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
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
1.7.8.6

