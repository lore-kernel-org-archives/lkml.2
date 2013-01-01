Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab3AAVKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 16:10:48 -0500
Received: from nm17.access.bullet.mail.mud.yahoo.com ([66.94.237.218]:35922
	"EHLO nm17.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752458Ab3AAVKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 16:10:20 -0500
X-Yahoo-Newman-Id: 3645.17119.bm@smtp109.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: dj9N4gkVM1kmbWNC1ygcfqI6acxA9rzAHDa0HzJBWYLceke
 dVA88YnaUVXdMcTbP4a1iOtmPykG3.75t_ZX2HMwBmfzCtmNh2GsexO9TBKY
 XAJ9lMAqrbeoMp7FUwpRjz2pqyWS.QOHAmSX44.QR05XrLsPjzf044PSbDRG
 HUGqw2JK7vSuuRz0cdKcBJFWt6LKwEOJRZW_Jhd2tSjmEKsLb3Qk_YgC4Cuz
 UzOQ5zzJvI3hBTUFRdjXjS_4kvXawgUwnZH7XEQpEm3wby8xWj1R4vUTovVv
 sQmVzeu3Qq2Rw3lghSIKbqYx4sPIg0iUYVUdGA6UeG3OLowSCowsOgDP_rkG
 ZW28necRitx050b_0hkbVHfCo4jpaj4XmQ5S1bmMWdjFi4KBBSadEoxrkTnB
 Z9uOdTwzyspgKWhs02qwAswMZk2r8bKz423IuX0IBpvorZEndm93CPa6ejLe
 Mg2TtAF.ql9LaUnuFHe3S19iUUGgs
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
Subject: [PATCH v7 8/9] compiler.h, bug.h: Prevent double error messages with BUILD_BUG{,_ON}
Date: Tue,  1 Jan 2013 15:09:56 -0600
Message-Id: <1357074597-21722-8-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1357074597-21722-1-git-send-email-daniel.santos@pobox.com>
References: <1357074491-21669-1-git-send-email-daniel.santos@pobox.com>
 <1357074597-21722-1-git-send-email-daniel.santos@pobox.com>
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
index 08d97e9..57c7688 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -67,7 +67,7 @@ struct pt_regs;
 			__compiletime_error("BUILD_BUG_ON failed");	\
 		if (__cond)						\
 			__build_bug_on_failed();			\
-		((void)sizeof(char[1 - 2 * __cond]));			\
+		__compiletime_error_fallback(__cond);			\
 	} while(0)
 #endif
 
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 4c638be..423bb6b 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -307,7 +307,12 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
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
1.7.8.6

