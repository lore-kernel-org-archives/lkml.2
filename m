Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965130Ab2CBIch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 03:32:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:65380 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756599Ab2CBIcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 03:32:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="113760949"
Subject: [RFC patch] cmpxchg_double: remove local variables to get better
 performance
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jeremy@goop.org, jbeulich@suse.com
Cc: Andi Kleen <ak@linux.intel.com>,
        "asit.k.mallick@intel.com" <asit.k.mallick@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Mar 2012 16:31:03 +0800
Message-ID: <1330677063.21053.1532.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some local variables in cmpxchg_double macro, seems these are
used to for force casting on input variables to transfer them into '*p1'
type. May there are some reason I don't know. But I just saw 2 problems
here:

1, user may mis-use the macro, like give a 'long' type o1, but just use
a 'int*' or 'char*' p1.  
If we remove the force cast here, gcc will check the mis-using in
compiling. and user can get the error report in compiling for such
issues.

2, local variable increased the data section, and bring extra memory bus
accesses, that hurt performance in this critical macro.
I did a little experiment on my nhm i7 desktop, to run the macro with a
fixed times, here is the data:
			 using local vars         no local variable
with lock prefix,         267700578ns             232079696ns
without lock prefix,      34715666ns              34687566ns

So, we may need rethink about the local variable usage here. 

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index b3b7332..8bf9127 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -210,17 +210,15 @@ extern void __add_wrong_size(void)
 #define __cmpxchg_double(pfx, p1, p2, o1, o2, n1, n2)			\
 ({									\
 	bool __ret;							\
-	__typeof__(*(p1)) __old1 = (o1), __new1 = (n1);			\
-	__typeof__(*(p2)) __old2 = (o2), __new2 = (n2);			\
 	BUILD_BUG_ON(sizeof(*(p1)) != sizeof(long));			\
 	BUILD_BUG_ON(sizeof(*(p2)) != sizeof(long));			\
 	VM_BUG_ON((unsigned long)(p1) % (2 * sizeof(long)));		\
 	VM_BUG_ON((unsigned long)((p1) + 1) != (unsigned long)(p2));	\
 	asm volatile(pfx "cmpxchg%c4b %2; sete %0"			\
-		     : "=a" (__ret), "+d" (__old2),			\
+		     : "=a" (__ret), "+d" (o2),				\
 		       "+m" (*(p1)), "+m" (*(p2))			\
-		     : "i" (2 * sizeof(long)), "a" (__old1),		\
-		       "b" (__new1), "c" (__new2));			\
+		     : "i" (2 * sizeof(long)), "a" (o1),		\
+		       "b" (n1), "c" (n2));				\
 	__ret;								\
 })
 


