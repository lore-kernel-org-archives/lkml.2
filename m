Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641Ab2EaXWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 19:22:14 -0400
Received: from nm11.access.bullet.mail.sp2.yahoo.com ([98.139.44.138]:33595
	"HELO nm11.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758626Ab2EaXWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 19:22:13 -0400
X-Yahoo-Newman-Id: 819070.90184.bm@omp1018.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: HdbovM0VM1l7F4ISwOwsOAHN9PJAEtVSVe98Obogzj_ppHf
 1YqpdalNzdHAY8sqMi2UN4jHRIB6POaxLpHM2UU8wUrvGLlWIoeOoH.4Z74m
 hTVAnK1ZSaGWsZtrD8.8JN.d5UMnJwYUeHuIqNT_MNwIEyZRjA00zl7DeKH6
 NAhPmZUnmYQr9l_QTlvlvJ0cb13xz.sfPCyEXEhgS2mLMRZCznB5OCfeYVnB
 MpqHyPvMdpgrToj4QgKLXXD3ZrWjivUUab.QL.1s5SY5Be7m39jOm5eA9xkG
 5d8EO.rt648XJ4xeK564Ci9gZtUC13tJ1ycTRwJpV4OkZ5NgediMcZ2DLjhN
 fE9N2N8tDImD2Tv_GNMTKqZm.mSSKoEfEIF64.FbtBqJ4UhhqjiXY0t0fOf7
 LH2V.rA--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FC7FD23.6080800@att.net>
Date: Thu, 31 May 2012 18:22:11 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Kent Overstreet <koverstreet@google.com>, tj@kernel.org,
        Peter Zijlstra <peterz@infradead.org>, axboe@kernel.dk,
        paul.gortmaker@windriver.com, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH v2 1/3] [RFC] Generic Red-Black Trees
X-Enigmail-Version: 1.3.5
Content-Type: multipart/mixed;
 boundary="------------010808030702000103020805"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010808030702000103020805
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Well, I'm running on 3.4 patched with this generic rb tree
implementation in the fair scheduler (although these are slightly
cleaned up, so I still need to boot this version to make sure there's no
last minute snafus).  So I finally settled on a mechanism for the
type-safety, even though it's a big macro (not my first choice), it's
the mechanism that works on all versions of gcc that still matter.

This is still preliminary.  I have a user-space test program (that just
compiles the rbtree.h in userspace) and a test module that I want to
refine to do profiling & stress tests so that performance can be easily
checked on various architectures & compilers.  So here's the outstanding
list:

* insert_near not finished (low priority)
* find_near not yet tested
* augmented not yet tested



--------------010808030702000103020805
Content-Type: text/x-patch;
 name="0006-linux-bug.h-Add-BUILD_BUG_ON_NON_CONST-macros.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0006-linux-bug.h-Add-BUILD_BUG_ON_NON_CONST-macros.patch"

>From 4a82526de53ab66c5ec5c36cfd93d1efed431cf0 Mon Sep 17 00:00:00 2001
From: Daniel Santos <daniel.santos@pobox.com>
Date: Fri, 4 May 2012 00:09:10 -0500
Subject: linux/bug.h: Add BUILD_BUG_ON_NON_CONST macros

---
 include/linux/bug.h |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index 72961c3..9352ff3 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -56,6 +56,68 @@ extern int __build_bug_on_failed;
 	} while(0)
 #endif
 
+
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
+ * as these are broken in many versions of gcc -- use BUILD_BUG_ON_NON_CONST2
+ * instead.
+ *
+ * As long as you are passing a variable delcared const (and not modified),
+ * this macro should never fail.
+ */
+#ifdef __OPTIMIZE__
+#define BUILD_BUG_ON_NON_CONST(exp) \
+	BUILD_BUG_ON(!__builtin_constant_p(exp))
+#else
+#define BUILD_BUG_ON_NON_CONST(exp)
+#endif
+
+
+/**
+ * BUILD_BUG_ON_NON_CONST2 - break compile if expression cannot be determined
+ *                           to be a compile-time constant.
+ * @exp: value to test for compile-time constness
+ *
+ * Use this macro instead of BUILD_BUG_ON_NON_CONST when testing struct
+ * members or dereferenced arrays and pointers.
+ *
+ * Gory Details:
+ *
+ * Normal primitive variables
+ * - global non-static non-const values are never compile-time constants (but
+ *   you should already know that)
+ * - all const values (global/local, non/static) should never fail this test
+ *   (3.4+)
+ * - global non-static const broken until 4.2 (-O1 broken until 4.4)
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
+ */
+#if __GNUC__ > 4 || __GNUC__ == 4 &&  __GNUC_MINOR__ >= 4
+#define BUILD_BUG_ON_NON_CONST2(exp) BUILD_BUG_ON_NON_CONST(exp)
+#else
+#define BUILD_BUG_ON_NON_CONST2(exp)
+#endif
+
+
 /**
  * BUILD_BUG - break compile if used.
  *
-- 
1.7.3.4


--------------010808030702000103020805--
