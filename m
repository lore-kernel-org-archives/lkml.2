Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab2IYXbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:31:09 -0400
Received: from nm6-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.206]:43509 "HELO
	nm6-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754444Ab2IYXbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:31:06 -0400
X-Yahoo-Newman-Id: 259467.44048.bm@omp1028.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: mLJaYVYVM1m3Hbp3tzULkqmDS0FQ4ytsY53ZQNKswUc0toq
 lMFr1cAD2nDZcd6eG3J9opazqsA97ycoTElRZzdbd_ymBAFnjAd53aI_xlfS
 MpcgBa.y3dS1kZYDX3355lHAlSJxKiouJeKCZsZHY.JQ4PIlDjiJ9YMT0BkC
 lyIyD1Y4D.g56uTFXzmtRD4aD8PiK3yxEy2xNULi5fMUjUHnE81.t2aaiGI8
 PKpIB1rLFRX_dguIZhbeDPEjxuoQ3sUUGknhCLD32Mkz400VowOCMC6OmwaZ
 TFaTRa2LdAO9RygeKZJa8K9b_GwIx3fIZtUZeYQuxicPC9P93BnKZWtQzS07
 QFRBDVnsYFLl9GH5_9yl5meGASENyKhWCrZSI_739UeMX7ODMmpNMz0m9dy4
 _F35hBxvCqvHe1PyDssbOTLx0mBn4U2oITgqad.gqfq2xgPRUf03t
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Daniel Santos <daniel.santos@pobox.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        LKML <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH v5 9/25] bug.h: Add BUILD_BUG_ON_NON_CONST macro
Date: Tue, 25 Sep 2012 18:30:59 -0500
Message-Id: <1348615859-10259-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
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

