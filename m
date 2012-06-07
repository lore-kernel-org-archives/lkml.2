Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760373Ab2FGJOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 05:14:31 -0400
Received: from nm29-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.192]:34366
	"HELO nm29-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752360Ab2FGJOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 05:14:30 -0400
X-Yahoo-Newman-Id: 896663.79836.bm@omp1015.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: rJoHIykVM1k0q3iaTEmeeI_A496urMOcASbYfcX4MLPVg.h
 rNR3jYiyUB29tfFaIhHN0cu9j5TrwGgLJXdzMWHtASoW_sx5HxQVDzvKxjAg
 Q18PEsZ22l1erqfMUXIT9RxSm78xa6L8iyN8t8YApT86D2T0odcgaJ2dpprK
 Qeyv6KXIEmy2E8eHUYsfStuFSHq__s7uQ6XaQ864OSB2rdU_XBm8HbkccJXl
 g6K1y0wKhVxkaYWtowbjl1XLZbrq9A8C4uhY_V3ata2Prhpyh.QgiY2rvoZc
 4ihkYS0Hqeq1Um6HukDejTeysu7kaewlq7dOAMjYMcA1VXZj3udcA7ItJRnD
 okdGAY8I4RagVsbvWcGC_8WRpNi5fR_GcahKEmXosMKy5BAdf9jr2l_wmgjX
 0Y2IC5A--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FD070F9.3060709@att.net>
Date: Thu, 07 Jun 2012 04:14:33 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCHv3 1/6] [RFC] compiler{,-gcc4}.h: Remove duplicate macro &
 cleanup
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__linktime_error() does the same thing as __compiletime_error() and is
only used in bug.h.  Since the macro defines a function attribute that
will cause a failure at compile-time (not link-time), it makes more
sense to keep __compiletime_error(), which is also neatly mated with
__compiletime_warning().

However, gcc version check for __compiletime_error() prevented its use
one minor version after it was availble (4.4 instead of 4.3). So to fix
this and clean things up a bit, I've moved it in with other macros
defined for 4.3 and later.

Finally, I moved __compiletime_object_size() towards the top of the file
so that all macros are defined in order of the gcc version they appear
in.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/compiler-gcc4.h |   21 ++++++++++-----------
 include/linux/compiler.h      |    3 ---
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 2f40791..77be10c 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -13,6 +13,10 @@
 #define __must_check 		__attribute__((warn_unused_result))
 #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
 +#if __GNUC_MINOR__ >= 1
+#define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
+#endif /* __GNUC_MINOR__ >= 1 */
+
 #if __GNUC_MINOR__ >= 3
 /* Mark functions as cold. gcc will assume any path leading to a call
    to them will be unlikely.  This means a lot of manual unlikely()s
@@ -29,7 +33,11 @@
    the kernel context */
 #define __cold			__attribute__((__cold__))
 -#define __linktime_error(message) __attribute__((__error__(message)))
+#if !defined(__CHECKER__)
+#define __compiletime_warning(message) __attribute__((warning(message)))
+#define __compiletime_error(message) __attribute__((error(message)))
+#endif /* !defined(__CHECKER__) */
+#endif /* __GNUC_MINOR__ >= 3 */
  #if __GNUC_MINOR__ >= 5
 /*
@@ -45,14 +53,5 @@
  /* Mark a function definition as prohibited from being cloned. */
 #define __noclone	__attribute__((__noclone__))
+#endif /* __GNUC_MINOR__ >= 5 */
 -#endif
-#endif
-
-#if __GNUC_MINOR__ > 0
-#define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
-#endif
-#if __GNUC_MINOR__ >= 4 && !defined(__CHECKER__)
-#define __compiletime_warning(message) __attribute__((warning(message)))
-#define __compiletime_error(message) __attribute__((error(message)))
-#endif
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 923d093..4d9f353 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -293,9 +293,6 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
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

