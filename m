Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab2IYXaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:30:55 -0400
Received: from nm6.bullet.mail.sp2.yahoo.com ([98.139.91.76]:42838 "HELO
	nm6.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754699Ab2IYXax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:30:53 -0400
X-Yahoo-Newman-Id: 30714.90796.bm@omp1030.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ZsdWBc8VM1l7NZ9gUWc_UbBEZccTuLw_cLnaTGOQl9iqKF1
 8avmnLKMZfF3xBNfYTUE5XBCqAHBYLizpCXN5qcfD0PId5MCiVP6l0CZpML0
 Yoim1bT0kUt0JNo2_r9WQYh_j0i2FVXOhUkWuW30ET0w1eV0ZJ8IdMQBjFAT
 ObiLRmmMnwd5eOMcBJAcPdfmcI4e0biNvBOkbD_.mij6wtGYpUVFbKv7k24a
 ZtorrO30pv0cRl9S4N7HEB533yAf...0Cr3jD39_6F5gsdTrHFq.Nkc77iNB
 DEjcKYs1l0rD41fJWXH.VBIkR5yae8nLa.hXtBpPFABZdnAxd4pCAQ07GUoP
 cFG.Bb0i._M0TRjuuQnePeftu24AMbgc9OgWX9Kch8oTPPBJlkRqvuqcaXpn
 bYcie1.kEr10fG9OIaPIYIQ8DnTd9bzUIBvEQgnW1VbHoYQ41qoDxB0s6lDg
 xBQWj954OjBnSFNWjgJo6_hRQ2guhIViwBBeNz6_.EYOK7JexznXWeN29sch
 MZ2..lGYi6n531Igx9OjpWYpe2isRu_Ko_dc-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        David Daney <david.daney@cavium.com>,
        David Rientjes <rientjes@google.com>, linux-sparse@vger.kernel.org,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        LKML <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH v5 7/25] compiler{,-gcc4}.h: Introduce __flatten function attribute
Date: Tue, 25 Sep 2012 18:30:46 -0500
Message-Id: <1348615846-10193-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For gcc 4.1 & later, expands to __attribute__((flatten)) which forces
the compiler to inline everything it can into the function.  This is
useful in combination with noinline when you want to control the depth
of inlining, or create a single function where inline expansions will
occur. (see
http://gcc.gnu.org/onlinedocs/gcc/Function-Attributes.html#index-g_t_0040code_007bflatten_007d-function-attribute-2512)

Normally, it's best to leave this type of thing up to the compiler.
However, the generic rbtree code uses inline functions just to be able
to inject compile-time constant data that specifies how the caller wants
the function to behave (via struct rb_relationship).  This data can be
thought of as the template parameters of a C++ templatized function.
Since some of these functions, once expanded, become quite large, gcc
sometimes decides not to perform some important inlining, in one case,
even generating a few bytes more code by not doing so. (Note: I have not
eliminated the possibility that this was an optimization bug, but the
flatten attribute fixes it in either case.)

Combining __flatten and noinline insures that important optimizations
occur in these cases and that the inline expansion occurs in exactly one
place, thus not leading to unnecissary bloat. However, it also can
eliminate some opportunities for optimization should gcc otherwise
decide the function its self is a good candidate for inlining.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/compiler-gcc4.h |    7 ++++++-
 include/linux/compiler.h      |    4 ++++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 5755e23..38fb81d 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -15,7 +15,12 @@
 
 #if GCC_VERSION >= 40102
 # define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
-#endif
+
+/* flatten introduced in 4.1, but broken in 4.6.0 (gcc bug #48731)*/
+# if GCC_VERSION != 40600
+#  define __flatten __attribute__((flatten))
+# endif
+#endif /* GCC_VERSION >= 40102 */
 
 #if GCC_VERSION >= 40300
 /* Mark functions as cold. gcc will assume any path leading to a call
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 4d9f353..b26d606 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -244,6 +244,10 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 #define __always_inline inline
 #endif
 
+#ifndef __flatten
+#define __flatten
+#endif
+
 #endif /* __KERNEL__ */
 
 /*
-- 
1.7.3.4

