Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab2FWEHo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 00:07:44 -0400
Received: from nm16-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.19]:32103
	"HELO nm16-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752693Ab2FWEHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 00:07:40 -0400
X-Yahoo-Newman-Id: 498172.55476.bm@smtp103.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 8z9YIHQVM1ls_LtJKAW4eYL8USqTK1Zaa1yBmLi.Z9hseaG
 d6gNhYYC3mt2gE_MOpTVq5KbtnwE1Kwp3ZCd0Gs4ArytAo1rjeWbrzj4LtYC
 nQ_wFJ.esamOCeuutIZMpzhWcO4hwN2YonIFOIkQkyMODXEN.DSQS1IMWEUn
 G8HMp7kaBh4M8_UWSw4VhkINaUqfFc2b_O7_qRYYdF4oyut0GBX1pqUXe8pV
 yp6SiJfY5Wb991RCD9EuNO8Xq4m3CWiwwZYZk74HhmjQaqQ6dh3FCzeyE3OG
 ihyS.fp1ADgu1kDQKC1BkySvJ4k_.567.aQxHSz8Ze0oK8.5UQ5F78pTw85t
 1.2UMKxWTlmew8uI.lSq_b2qBwhsXfoUag1_CC.kd2mCs5ntvTLKyX0qFSWz
 QCy8xgnt6yYxUI2QM2w7OXB5BFs1ZtSVIsvzuDTs8EY.Rx.OerNQPlR0FF8r
 1tjcjfFLDIw6WWygqrgAzvuQrsKcF5JzdA_lEg74x1ikDkRfX
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-doc@vger.kernel.org, linux-sparse@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Turner <pjt@google.com>, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Weinberger <richard@nod.at>, Rob Landley <rob@landley.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH v4 9/13] bug.h: Add BUILD_BUG_ON_NON_CONST macro
Date: Fri, 22 Jun 2012 23:00:44 -0500
Message-Id: <1340424048-7759-10-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
References: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A very common use of __builtin_constant_p is to make sure that a certain
value is a compile time constant and generate a build-time error if it
is not.  However, __builtin_constant_p is broken in a variety of ways in
various situations (on various versions of gcc) and never returns one in
an unoptimized build. This macro provide a mechanism to perform these
build-time checks, but not break unoptimized builds (or modules being
build with -O0), of which there probably aren't many people that care
anyway.

This patch documents all of the relevant quirks I could find in the
"Gory Details" section of the doc-comments.  For almost all cases,
BUILD_BUG_ON_NON_CONST() should never fail on a primitive, non-pointer
type variable declared const.  A subsequent patch provides a separate
macro for performing tests which are known to be broken in older
compilers (pretty much, using __builtin_constant_p on arrays, pointers &
structs as well as testing those values).

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/bug.h |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index c70b833..e30f600 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -81,6 +81,54 @@ struct pt_regs;
 		__build_bug_failed();				\
 	} while (0)
 
+/**
+ * BUILD_BUG_ON_NON_CONST - break compile if expression cannot be determined
+ *                          to be a compile-time constant.
+ * @exp: value to test for compile-time constness
+ *
+ * __builtin_constant_p() is a work in progress and is broken in various ways
+ * on various versions of gcc and optimization levels. It can fail, even when
+ * gcc otherwise determines that the expression is compile-time constant when
+ * performing actual optimizations and thus, compile out the value anyway. Do
+ * not use this macro for struct members or dereferenced pointers and arrays,
+ * as these are broken in many versions of gcc -- use BUILD_BUG_ON_NON_CONST42
+ * or another gcc-version-checked macro instead.
+ *
+ * As long as you are passing a variable declared const (and not modified),
+ * this macro should never fail (except for floats).  For information on gcc's
+ * behavior in other cases, see below.
+ *
+ * Gory Details:
+ *
+ * Normal primitive variables
+ * - global non-static non-const values are never compile-time constants (but
+ *   you should already know that)
+ * - all const values (global/local, non/static) should never fail this test
+ *   (3.4+) with one exception (below)
+ * - floats (which we wont use anyway) are broken in various ways until 4.2
+ *   (-O1 broken until 4.4)
+ * - local static non-const broken until 4.2 (-O1 broken until 4.3)
+ * - local non-static non-const broken until 4.0
+ *
+ * Dereferencing pointers & arrays
+ * - all static const derefs broken until 4.4 (except arrays at -O2 or better,
+ *   which are fixed in 4.2)
+ * - global non-static const pointer derefs always fail (<=4.7)
+ * - local non-static const derefs broken until 4.3, except for array derefs
+ *   to a zero value, which works from 4.0+
+ * - local static non-const pointers always fail (<=4.7)
+ * - local static non-const arrays broken until 4.4
+ * - local non-static non-const arrays broken until 4.0 (unless zero deref,
+ *   works in 3.4+)
+
+ */
+#ifdef __OPTIMIZE__
+#define BUILD_BUG_ON_NON_CONST(exp) \
+	BUILD_BUG_ON(!__builtin_constant_p(exp))
+#else
+#define BUILD_BUG_ON_NON_CONST(exp)
+#endif
+
 #endif	/* __CHECKER__ */
 
 #ifdef CONFIG_GENERIC_BUG
-- 
1.7.3.4

