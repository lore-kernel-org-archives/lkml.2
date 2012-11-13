Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab2KMWOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:14:53 -0500
Received: from nm16-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.19]:44968
	"EHLO nm16-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754870Ab2KMWOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:14:03 -0500
X-Yahoo-Newman-Id: 174480.28409.bm@smtp115.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: t2uOVDgVM1ldlFQUl7UIpG9DVzd7yqvi6Wm1Y5VYIr2Z.0J
 uZ47T0G_zH99uIE4ddOR_DSgqGrmbsfhUmFvbgWoGK1bTj3EYnRjwwtTlwJC
 AZpWbOTTfTwyUPMLfAlphl3sdXBmEjYLI0mKiORW5wI1NG9UEjerkBFF0ZKc
 c0117jhAtOVQmWaiNkJmeTGGUSNdx2qrscijnzI1Cbv4C2D9y6kePAC.JjaW
 ii15wuZ22300SfhwIyXScq1Xz196OzxR6sc1X8fv3k8Pa1q8GFIhIk7Ke.jE
 osWot2KscAMZrffRuxj_pmGg3g9bfZVey3NTu4hSQYa.7TW3wPOH_L7dXN4E
 rY1altHPPv9RzOWTazMbP2Saz_gIrkqZfzQOQhAPLuLXIR4fEaRajwbXhbhU
 uh25Dxq88Cb20ZNplZAuI3gjH7.k.aFSYY8wnPJ4H7FlwLSIt_zNblTZiXtB
 3FWHKDwDFjPexki4NsykH3Ob7hUKM
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
Subject: [PATCH v5 8/9] compiler.h, bug.h: Prevent double error messages with BUILD_BUG{,_ON}
Date: Tue, 13 Nov 2012 16:13:40 -0600
Message-Id: <1352844821-18952-8-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com>
References: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com>
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

Note that we are not changing the negative-sized array code for the
unoptimized version of BUILD_BUG_ON, since it has the potential to catch
problems that would be disabled in later versions of gcc were
__compiletime_error_fallback used.  The reason is that that an
unoptimized build can't always remove calls to an error-attributed
function call (like we are using) that should effectively become dead
code if it were optimized.  However, using a negative-sized array with a
similar value will not result in an false-positive (error). The only
caveat being that it will also fail to catch valid conditions, which we
should be expecting in an unoptimized build anyway.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/bug.h      |    2 +-
 include/linux/compiler.h |    5 +++++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index dd4f506..125e744 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -66,7 +66,7 @@ struct pt_regs;
 			__compiletime_error("BUILD_BUG_ON failed");	\
 		if (__cond)						\
 			__build_bug_on_failed();			\
-		((void)sizeof(char[1 - 2*!!(__cond)]));			\
+		__compiletime_error_fallback(__cond);			\
 	} while(0)
 #endif
 
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index cbf6d9d..8e5b9d5 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -298,7 +298,12 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 #endif
 #ifndef __compiletime_error
 # define __compiletime_error(message)
+# define __compiletime_error_fallback(condition) \
+	do { ((void)sizeof(char[1 - 2*!!(condition)])); } while (0)
+#else
+# define __compiletime_error_fallback(condition) do { } while (0)
 #endif
+
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),
-- 
1.7.3.4

