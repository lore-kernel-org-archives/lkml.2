Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab2J1U5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 16:57:18 -0400
Received: from nm27.access.bullet.mail.mud.yahoo.com ([66.94.237.92]:23792
	"EHLO nm27.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755722Ab2J1U5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 16:57:15 -0400
X-Yahoo-Newman-Id: 304948.16106.bm@smtp105.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 8q1j.wsVM1m9YwThdbvPshnYq0RSY6Izj1dtkx6ZGQ4xzEV
 q0FUwRfVrKSo.atDtrIIlmoylYC7VZ83P7t_XtgI8xgfXqXmwxiYHnBMOiQz
 Z4B44cDKRnU5lVKLP3y1y6NsMAuWKCewCcX6cEgBZlcZOVq3QLvpGnM5JazG
 uJBTJxNrqSI1izf9lCDrdy2.2.tUO1EY66lpNcR_YUaQdslps3K7xJp44c7Y
 9gkl.WgfCDLqZ_s57RTmHR2SlguVsnzdMdGqHYs.PjmKblQ019r2dJotjIOF
 hVUFV8eG5N9IGpnImxOQfcjmqxKutFEbq2.ATG9Ihk3AG2BF5NzlffYbdC65
 Hl15Z8ALPWmmJ5oWAQmpoTNjE2RTzcY3Xh615bsBXyzVRBD44MTyf6Qf_PGD
 aeS4BNM123adI4ZJYPiEl79UVmG37poPy9G9bHK0mTt3mVIHzn8NNtfGICLl
 BqYtK3WyeFyQUxdi2aQqQT6SvIpcA
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
Subject: [PATCH v4 6/9] compiler.h, bug.h: Prevent double error messages with BUILD_BUG{,_ON}
Date: Sun, 28 Oct 2012 15:57:12 -0500
Message-Id: <1351457835-7553-6-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1351457648-7453-1-git-send-email-daniel.santos@pobox.com>
References: <1351457648-7453-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prior to the introduction of __attribute__((error("msg"))) in gcc 4.3,
creating compile-time errors required a little trickery.
BUILD_BUG{,_ON} uses this attribute when available to generate
compile-time errors, but also uses the negative-sized array trick for
older compilers, resulting in two error messages in some cases.  The
reason it's "some" cases is that as of gcc 4.4, the negative-sized array
will not create an error in some situations, like inline functions.

This patch replaces the negative-sized array code with the new
__compiletime_error_fallback() macro which expands to the same thing
unless the the error attribute is available, in which case it expands to
do{}while(0), resulting in exactly one compile-time error on all
versions of gcc.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/bug.h      |    4 ++--
 include/linux/compiler.h |    7 +++++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index 03259d7..da03dc1 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -57,13 +57,13 @@ struct pt_regs;
  * track down.
  */
 #ifndef __OPTIMIZE__
-#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+#define BUILD_BUG_ON(condition) __compiletime_error_fallback(condition)
 #else
 #define BUILD_BUG_ON(condition)						\
 	do {								\
 		extern void __build_bug_on_failed(void)			\
 			__compiletime_error("BUILD_BUG_ON failed");	\
-		((void)sizeof(char[1 - 2*!!(condition)]));		\
+		__compiletime_error_fallback(condition);		\
 		if (condition)						\
 			__build_bug_on_failed();			\
 	} while(0)
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index cbf6d9d..84926f2 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -298,6 +298,13 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 #endif
 #ifndef __compiletime_error
 # define __compiletime_error(message)
+# define __compiletime_error_fallback(condition)		\
+	do {							\
+		((void)sizeof(char[1 - 2*!!(condition)]));	\
+	} while (0)
+#endif
+#ifndef __compiletime_error_fallback
+# define __compiletime_error_fallback(condition) do { } while (0)
 #endif
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
-- 
1.7.3.4

