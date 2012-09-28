Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab2I1B4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 21:56:37 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:51096 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756584Ab2I1B4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 21:56:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:in-reply-to:references; q=dns; s=sasl; b=
	ujYZXbXjbBxYat43VJm0G1KmUUcr+96LEmiL1PEUmovMrxw+BdorL4gB7v9saCmb
	Ky+0YvVjYZvxQA5lBtgMtoaSWbYd5YNEGtjYbKJSouZeJZ5oVj8ycYMAXXFqMtf/
	synaLFLesuPBeBjIE+G2UIV1G29N0QaumJVpTZPTRaQ=
From: Daniel Santos <daniel.santos@pobox.com>
To: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-sparse@vger.kernel.org, Akinobu Mita <akinobu.mita@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Don Zickus <dzickus@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH v6 7/25] compiler{,-gcc4}.h: Introduce __flatten function
 attribute
Date: Thu, 27 Sep 2012 20:54:23 -0500
Message-Id: <1348797281-25021-8-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348797281-25021-1-git-send-email-daniel.santos@pobox.com>
References: <1348797281-25021-1-git-send-email-daniel.santos@pobox.com>
X-Pobox-Relay-ID: A9468C96-090F-11E2-B3C1-18772E706CDE-06139138!b-pb-sasl-quonix.pobox.com
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
index ad610f2..5a0897e 100644
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
index fd455aa..268aeb6 100644
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

