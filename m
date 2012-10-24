Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935225Ab2JXQjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:39:48 -0400
Received: from nm11.access.bullet.mail.sp2.yahoo.com ([98.139.44.138]:48579
	"EHLO nm11.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934468Ab2JXQjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:39:45 -0400
X-Yahoo-Newman-Id: 524141.79197.bm@smtp105.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: I4hNqs0VM1mgcwo1.yH8Z0TZr1J3u.kHdLqn_IS0YwiY4RF
 bEkDf4gwU3gN7PrnuVBO0cFst28.cerqyPF8lndDqAGq67biqq3hh8rx57o5
 bc5rpjX86EgMOG2FhM7lmX17.s9Kxo2cK6onrdZHiVhAuRBkBKtCtP93ZI1B
 6P2TWFfUKYAA4ugPGP7W._Ag_KlKqmV9ubJprpdE_sq.b75kmAaj9ywDQ4rw
 OkCQm0m.NM2IYVGwjRUzJrXJHP6rxq2Jk3OP9GyW0AxZt3gzWZ4sUVFZICM8
 shT5FbkRRjWwXl.LZf_UDC6d16S2O.5mFYb_e86aGgtomkEfoTJZdoskgifG
 iqjl_64O71xFjnvWOYIKsRgwt6XcWbjbqc8_rlJDmlbwV.Q.fbeYUBE9V5tV
 4DoH2NhuuMnEiZKqn3o0xM9Cp.nNISB0FsI5QsO1bDcaHy4rmhUeDFQ--
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
Subject: [PATCH v3 05/10] compiler{,-gcc4}.h, bug.h: Remove duplicate macros
Date: Wed, 24 Oct 2012 11:33:56 -0500
Message-Id: <1351096441-12388-5-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1351096132-12244-1-git-send-email-daniel.santos@pobox.com>
References: <1351096132-12244-1-git-send-email-daniel.santos@pobox.com>
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
---
 include/linux/bug.h           |    2 +-
 include/linux/compiler-gcc4.h |    2 --
 include/linux/compiler.h      |    3 ---
 3 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index 4bd74d8..a03c3ef 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -74,7 +74,7 @@ extern int __build_bug_on_failed;
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

