Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757Ab2CAHMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 02:12:20 -0500
Received: from ozlabs.org ([203.10.76.45]:42781 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918Ab2CAHMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 02:12:19 -0500
Date: Thu, 1 Mar 2012 18:12:16 +1100
From: Anton Blanchard <anton@samba.org>
To: benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        asharma@fb.com, vapier@gentoo.org, eric.dumazet@gmail.com
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] powerpc: atomic: Implement atomic*_inc_not_zero
Message-ID: <20120301181216.433cebab@kryten>
In-Reply-To: <20120301180953.0f61576f@kryten>
References: <20120301180953.0f61576f@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Implement atomic_inc_not_zero and atomic64_inc_not_zero. At the
moment we use atomic*_add_unless which requires us to put 0 and
1 constants into registers. We can also avoid a subtract by
saving the original value in a second temporary.

This removes 3 instructions from fget:

- c0000000001b63c0:       39 00 00 00     li      r8,0
- c0000000001b63c4:       39 40 00 01     li      r10,1
...
- c0000000001b63e8:       7c 0a 00 50     subf    r0,r10,r0

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-build/arch/powerpc/include/asm/atomic.h
===================================================================
--- linux-build.orig/arch/powerpc/include/asm/atomic.h	2012-02-11 21:42:36.101190317 +1100
+++ linux-build/arch/powerpc/include/asm/atomic.h	2012-02-11 21:58:46.102791345 +1100
@@ -212,6 +212,36 @@ static __inline__ int __atomic_add_unles
 	return t;
 }
 
+/**
+ * atomic_inc_not_zero - increment unless the number is zero
+ * @v: pointer of type atomic_t
+ *
+ * Atomically increments @v by 1, so long as @v is non-zero.
+ * Returns non-zero if @v was non-zero, and zero otherwise.
+ */
+static __inline__ int atomic_inc_not_zero(atomic_t *v)
+{
+	int t1, t2;
+
+	__asm__ __volatile__ (
+	PPC_ATOMIC_ENTRY_BARRIER
+"1:	lwarx	%0,0,%2		# atomic_inc_not_zero\n\
+	cmpwi	0,%0,0\n\
+	beq-	2f\n\
+	addic	%1,%0,1\n"
+	PPC405_ERR77(0,%2)
+"	stwcx.	%1,0,%2\n\
+	bne-	1b\n"
+	PPC_ATOMIC_EXIT_BARRIER
+	"\n\
+2:"
+	: "=&r" (t1), "=&r" (t2)
+	: "r" (&v->counter)
+	: "cc", "xer", "memory");
+
+	return t1;
+}
+#define atomic_inc_not_zero(v) atomic_inc_not_zero((v))
 
 #define atomic_sub_and_test(a, v)	(atomic_sub_return((a), (v)) == 0)
 #define atomic_dec_and_test(v)		(atomic_dec_return((v)) == 0)
@@ -467,7 +497,34 @@ static __inline__ int atomic64_add_unles
 	return t != u;
 }
 
-#define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
+/**
+ * atomic_inc64_not_zero - increment unless the number is zero
+ * @v: pointer of type atomic64_t
+ *
+ * Atomically increments @v by 1, so long as @v is non-zero.
+ * Returns non-zero if @v was non-zero, and zero otherwise.
+ */
+static __inline__ long atomic64_inc_not_zero(atomic64_t *v)
+{
+	long t1, t2;
+
+	__asm__ __volatile__ (
+	PPC_ATOMIC_ENTRY_BARRIER
+"1:	ldarx	%0,0,%2		# atomic64_inc_not_zero\n\
+	cmpdi	0,%0,0\n\
+	beq-	2f\n\
+	addic	%1,%0,1\n\
+	stdcx.	%1,0,%2\n\
+	bne-	1b\n"
+	PPC_ATOMIC_EXIT_BARRIER
+	"\n\
+2:"
+	: "=&r" (t1), "=&r" (t2)
+	: "r" (&v->counter)
+	: "cc", "xer", "memory");
+
+	return t1;
+}
 
 #endif /* __powerpc64__ */
 
