Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab2KMWPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:15:45 -0500
Received: from nm8.access.bullet.mail.mud.yahoo.com ([66.94.237.209]:31767
	"EHLO nm8.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754648Ab2KMWN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:13:56 -0500
X-Yahoo-Newman-Id: 107592.28409.bm@smtp115.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 8kkwv1sVM1mbzoxqZ6faXQWVegm2TdxCi4f80iKwj2X8fMj
 9jF38JKe4OOMjuLLiOM20yZVT4xHslUyagGjrQtJpP874u4kaHnXuSbB6ZWE
 z62uZx58Vab0b_UbhVtr07w9sT34Gmbn97lqTA_EGUjuqZbncBRRXLzHU.6k
 8ucZp6g7PfeCLPWz.KSfAg1RP0QnfmuthGNeoaRXoIh3Wqfdvst35R9Q65Me
 XQRynbnWeoARIBbs.J2wRgO6bOCUciI04AdspG5AsnBco49GtsKSggUMO8_S
 yj8wgrMxQvCJGLYLZH8jZWDhiETai5ngvcvowXDCR3TdgBcJ4USBYRd7ElF1
 1vuGT8DuIXL5GEunC4tVi7k8.cwVN_4mm6q8UuazpujVYJAcrePSHfcpDGcO
 szISwB8kbOU2Os7rdw8_4jVel8LFfnOsEJukn.Ls1CVu15SQNc5q8CA--
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
Subject: [PATCH v5 4/9] compiler{,-gcc4}.h, bug.h: Remove duplicate macros
Date: Tue, 13 Nov 2012 16:13:36 -0600
Message-Id: <1352844821-18952-4-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com>
References: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__linktime_error() does the same thing as __compiletime_error() and is
only used in bug.h.  Since the macro defines a function attribute that
will cause a failure at compile-time (not link-time), it makes more
sense to keep __compiletime_error(), which is also neatly mated with
__compiletime_warning().

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Borislav Petkov <bp@alien8.de>
---
 include/linux/bug.h           |    2 +-
 include/linux/compiler-gcc4.h |    2 --
 include/linux/compiler.h      |    3 ---
 3 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index aaac4bb..298a916 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -73,7 +73,7 @@ extern int __build_bug_on_failed;
 #define BUILD_BUG()						\
 	do {							\
 		extern void __build_bug_failed(void)		\
-			__linktime_error("BUILD_BUG failed");	\
+			__compiletime_error("BUILD_BUG failed");\
 		__build_bug_failed();				\
 	} while (0)
 
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 9755029..7f143ac 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -33,8 +33,6 @@
    the kernel context */
 #define __cold			__attribute__((__cold__))
 
-#define __linktime_error(message) __attribute__((__error__(message)))
-
 #ifndef __CHECKER__
 # define __compiletime_warning(message) __attribute__((warning(message)))
 # define __compiletime_error(message) __attribute__((error(message)))
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index b121554..cbf6d9d 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -299,9 +299,6 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 #ifndef __compiletime_error
 # define __compiletime_error(message)
 #endif
-#ifndef __linktime_error
-# define __linktime_error(message)
-#endif
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),
-- 
1.7.3.4

