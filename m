Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab0LRPYr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 10:24:47 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:40252 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab0LRPYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 10:24:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=kSVBJl/JO/gR4wbeqXpBKtLogmbEuYbU4wmkQsofrRcKOBIkFf87bSm2t5Zf3W75H7
         47aCO4A7ebpquSjDLuFrTldfvgndXmZibt52eXY+fLIuuPQsfXm5oRhGGzPCrCINiufW
         MP2TJcsmUgmTK2fM6ixcJJR+FOMnUCKovZ68M=
From: Tejun Heo <tj@kernel.org>
To: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com, hpa@zytor.com,
        mathieu.desnoyers@efficios.com
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/6] cpuops: Use cmpxchg for xchg to avoid lock semantics
Date: Sat, 18 Dec 2010 16:24:12 +0100
Message-Id: <1292685852-12469-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292685852-12469-1-git-send-email-tj@kernel.org>
References: <1292685852-12469-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux.com>

Use cmpxchg instead of xchg to realize this_cpu_xchg.

xchg will cause LOCK overhead since LOCK is always implied but cmpxchg
will not.

Baselines:

xchg()		= 18 cycles (no segment prefix, LOCK semantics)
__this_cpu_xchg = 1 cycle

(simulated using this_cpu_read/write, two prefixes. Looks like the
cpu can use loop optimization to get rid of most of the overhead)

Cycles before:

this_cpu_xchg	 = 37 cycles (segment prefix and LOCK (implied by xchg))

After:

this_cpu_xchg	= 11 cycle (using cmpxchg without lock semantics)

Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/percpu.h |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index b85ade5..8ee4516 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -263,8 +263,9 @@ do {									\
 })
 
 /*
- * Beware: xchg on x86 has an implied lock prefix. There will be the cost of
- * full lock semantics even though they are not needed.
+ * xchg is implemented using cmpxchg without a lock prefix. xchg is
+ * expensive due to the implied lock prefix.  The processor cannot prefetch
+ * cachelines if xchg is used.
  */
 #define percpu_xchg_op(var, nval)					\
 ({									\
@@ -272,25 +273,33 @@ do {									\
 	typeof(var) pxo_new__ = (nval);					\
 	switch (sizeof(var)) {						\
 	case 1:								\
-		asm("xchgb %2, "__percpu_arg(1)				\
+		asm("\n1:mov "__percpu_arg(1)",%%al"			\
+		    "\n\tcmpxchgb %2, "__percpu_arg(1)			\
+		    "\n\tjnz 1b"					\
 			    : "=a" (pxo_ret__), "+m" (var)		\
 			    : "q" (pxo_new__)				\
 			    : "memory");				\
 		break;							\
 	case 2:								\
-		asm("xchgw %2, "__percpu_arg(1)				\
+		asm("\n1:mov "__percpu_arg(1)",%%ax"			\
+		    "\n\tcmpxchgw %2, "__percpu_arg(1)			\
+		    "\n\tjnz 1b"					\
 			    : "=a" (pxo_ret__), "+m" (var)		\
 			    : "r" (pxo_new__)				\
 			    : "memory");				\
 		break;							\
 	case 4:								\
-		asm("xchgl %2, "__percpu_arg(1)				\
+		asm("\n1:mov "__percpu_arg(1)",%%eax"			\
+		    "\n\tcmpxchgl %2, "__percpu_arg(1)			\
+		    "\n\tjnz 1b"					\
 			    : "=a" (pxo_ret__), "+m" (var)		\
 			    : "r" (pxo_new__)				\
 			    : "memory");				\
 		break;							\
 	case 8:								\
-		asm("xchgq %2, "__percpu_arg(1)				\
+		asm("\n1:mov "__percpu_arg(1)",%%rax"			\
+		    "\n\tcmpxchgq %2, "__percpu_arg(1)			\
+		    "\n\tjnz 1b"					\
 			    : "=a" (pxo_ret__), "+m" (var)		\
 			    : "r" (pxo_new__)				\
 			    : "memory");				\
-- 
1.7.1

