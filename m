Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935301Ab2JXQkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:40:25 -0400
Received: from nm25-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.184]:36767
	"EHLO nm25-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935288Ab2JXQkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:40:20 -0400
X-Yahoo-Newman-Id: 844284.79197.bm@smtp105.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: HoKQw_0VM1kxOeOrWggTlGV5lYZti3V6lK1mDuqpLXmg36i
 1nwNX7kjocGgmF6tLOeMKB6oBX0TNstX9wqZv24ethRQxMh16v8lbuXZcS10
 _eIeTuyi3SW6ANxxapBUuOtMhQT2pKUOdEpszAVqiFXU2aLA56evKPHEXYeZ
 jbRlfqXUnzict_Mc3QGNULkw_qbzWK_CoA5grbGpuXqiDSMLwypm5yTB02mC
 .D7ILe3h4v1WDBBGhxw.ghHETpZYEVGlDEFkIgMd6lraNyYff8yFR4UYt1aN
 GTyPTtYJmJlgLNjsQgdvZsvarN0B5zkeKfF8JaERJpzrnlE8DGRdth82ZgKj
 wssQM9QuRMuttRZOwG8s_awx70AOmM2IBdc8kuY_djJMlHdCp.Rd2cVF17B8
 02G.qDEuOyi4ofb1JdSrKtpAbFyEW84eX8f71O346eiH5uU6CzUtX
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
Subject: [PATCH v3 07/10] compiler.h, bug.h: Prevent double error messages with BUILD_BUG{,_ON}
Date: Wed, 24 Oct 2012 11:33:58 -0500
Message-Id: <1351096441-12388-7-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1351096132-12244-1-git-send-email-daniel.santos@pobox.com>
References: <1351096132-12244-1-git-send-email-daniel.santos@pobox.com>
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
index 3d4b564..f8eae31 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -56,13 +56,13 @@ struct pt_regs;
  * link-time error, which is harder to track down.
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

