Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760415Ab2FGJPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 05:15:24 -0400
Received: from nm28-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.190]:27464
	"HELO nm28-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760282Ab2FGJPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 05:15:21 -0400
X-Yahoo-Newman-Id: 448127.47431.bm@omp1003.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 7j_UJkMVM1luXwHPrTkErin5ChlpyQDHOOqH6fPu.teyQrp
 ROmgUTeliXhZb.WzkmrRB7pimNEqyWbqHXGRHW0PGOtI0uiBnm5xHaJUvrCw
 4PA0KUWr3YKqv_IDNjV0zOjL4IYzs4AwsSqs_HKxpRmiW7bKnIGiZcCnQq4t
 uwlPjP2y02r4OV6JRLKX.qrplNhthVMXl_ojajuUhompvmrjqlBciyAei2L5
 fWXwfSfL2WSu3dbBEY9jl1wFJZ3J_F0lmKhN4X.YVQfX2s8y9EcmuUesHla7
 sKfv2aJzrx.bkNcrOTDJS1X_SJMMPBWZ5YYy97tWiMoDxf4RKS4wQc5CXHzg
 Pm.lXTI1mhEQyQdKW._M2FWwsvn1Y7iv4sPRXgm18VwVJr7h_WBspIiEa8XX
 JJerICsmJVc.Eby22Noff_0Ygt1.NU7YDIW4qfFPpzif6h.vIVeAN2MglYIB
 NpowSNYWsXIMHBVKxmWYlkM.zFlnUIsUE8bcfEU7kw64k82_VUxvK_ikEdb4
 -
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FD0712D.20402@att.net>
Date: Thu, 07 Jun 2012 04:15:25 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCHv3 3/6] [RFC] compiler{,-gcc4}.h: Introduce __flatten function
 attribute
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
 include/linux/compiler-gcc4.h |    5 +++++
 include/linux/compiler.h      |    4 ++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 77be10c..b1c5073 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -15,6 +15,11 @@
  #if __GNUC_MINOR__ >= 1
 #define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
+
+/* flatten introduced in 4.1, but broken in 4.6.0 (gcc bug #48731)*/
+#if !(__GNUC_MINOR__ == 6 && __GNUC_PATCHLEVEL__ == 0)
+#define __flatten __attribute__((flatten))
+#endif
 #endif /* __GNUC_MINOR__ >= 1 */
  #if __GNUC_MINOR__ >= 3
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

