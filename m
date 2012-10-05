Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690Ab2JEToh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 15:44:37 -0400
Received: from nm16-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.210]:37989 "HELO
	nm16-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964802Ab2JETnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 15:43:40 -0400
X-Yahoo-Newman-Id: 53645.45981.bm@omp1014.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0DECR0wVM1mP2tJV8T1VSLS4BwDuzQn6R68zGL5ovMSpg1i
 s8cbm2pkSc8dYCdww9ZYEWZUB0rlSAJT56iyPtqPtlvjhx3G.0WIoKzLaleF
 zJhby.8IerPRgCsm3s4_ZUnySV0VZsW7m.HNg3syLgdkip.kBIT1_OScfMub
 JLfoAzUXI08eSYw9ZBeBbDs0RaSNhDvIw1HwEwUd8.ERPmfiUNkHbFlZcblu
 p1zFBomWfYX_yKN2UqWUx_a70KKfzLl2P7nwN08PGImqZ81jOTxM_2GhioRC
 N2.ecksto.Jk_ioxS8wzody6mn1AwW7ZWMNK3.ER8Db7IBkRfjtzis577Kig
 NQkIh57EfAZtcRGNod93cGoxRpQaNnO3ZiFRAiRuFbXuZ26eA_o_eBIsKx5K
 r2m0qogicyREQJFRdUJCNXBm9LRKILK0tIZqn4T5DWYASEjk5sLlU
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH v2 07/10] compiler.h, bug.h: Prevent double error messages with BUILD_BUG{,_ON}
Date: Fri,  5 Oct 2012 14:42:46 -0500
Message-Id: <1349466169-20637-7-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
References: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
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
(0), resulting in exactly one compile-time error on all versions of gcc.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/bug.h      |    4 ++--
 include/linux/compiler.h |    5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

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
index fd455aa..88ba201 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -296,6 +296,11 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 #endif
 #ifndef __compiletime_error
 # define __compiletime_error(message)
+# define __compiletime_error_fallback(condition) \
+	 ((void)sizeof(char[1 - 2*!!(condition)]))
+#endif
+#ifndef __compiletime_error_fallback
+# define __compiletime_error_fallback(condition) (void)(0)
 #endif
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
-- 
1.7.3.4

