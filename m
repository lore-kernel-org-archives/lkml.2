Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586Ab0LNQ3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:29:07 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:39346 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757409Ab0LNQ25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:28:57 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 6hBqwYUVM1mtqMwBemgz2ivNsje_cDVR.JyaxpxCVY8vx7.
 D3yjya5wUdCapHls9SJJQDTdE1jSGNi03_nYbvoxVCqWNqU_RJS2f1PtM5l9
 CCaPRdtUevg.D9XoYpbSSOYNni2zwSnuzdhI4QyJ0M0b0X29vFTGGuzTNVFW
 PB7fl4G_xMPlq_XO7vzRKQ_aNHvGw0wEuq3JqbUo7XtknjkEJzFd1VC1zuTn
 rJurOJYvikb3Xk1kpJwFV4KA5_oUWBCAcPChVPAvsvtFajyyjVHHO_Uc_xVs
 g.5wrSH_Oz18m3BVOmaJsoee.a5ssGQG2Tnw1nSJy4URwqZA-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101214162855.392020353@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 14 Dec 2010 10:28:47 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops cmpxchg V2 5/5] cpuops: Use cmpxchg for xchg to avoid lock semantics
References: <20101214162842.542421046@linux.com>
Content-Disposition: inline; filename=cpuops_xchg_with_cmpxchg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

---
 arch/x86/include/asm/percpu.h |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2010-12-10 12:46:31.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2010-12-10 13:25:21.000000000 -0600
@@ -213,8 +213,9 @@ do {									\
 })
 
 /*
- * Beware: xchg on x86 has an implied lock prefix. There will be the cost of
- * full lock semantics even though they are not needed.
+ * xchg is implemented using cmpxchg without a lock prefix. xchg is
+ * expensive due to the implied lock prefix. The processor cannot prefetch
+ * cachelines if xchg is used.
  */
 #define percpu_xchg_op(var, nval)					\
 ({									\
@@ -222,25 +223,33 @@ do {									\
 	typeof(var) __new = (nval);					\
 	switch (sizeof(var)) {						\
 	case 1:								\
-		asm("xchgb %2, "__percpu_arg(1)			\
+		asm("\n1:mov "__percpu_arg(1)",%%al"			\
+		    "\n\tcmpxchgb %2, "__percpu_arg(1)			\
+		    "\n\tjnz 1b"					\
 			    : "=a" (__ret), "+m" (var)			\
 			    : "q" (__new)				\
 			    : "memory");				\
 		break;							\
 	case 2:								\
-		asm("xchgw %2, "__percpu_arg(1)			\
+		asm("\n1:mov "__percpu_arg(1)",%%ax"			\
+		    "\n\tcmpxchgw %2, "__percpu_arg(1)			\
+		    "\n\tjnz 1b"					\
 			    : "=a" (__ret), "+m" (var)			\
 			    : "r" (__new)				\
 			    : "memory");				\
 		break;							\
 	case 4:								\
-		asm("xchgl %2, "__percpu_arg(1)			\
+		asm("\n1:mov "__percpu_arg(1)",%%eax"			\
+		    "\n\tcmpxchgl %2, "__percpu_arg(1)			\
+		    "\n\tjnz 1b"					\
 			    : "=a" (__ret), "+m" (var)			\
 			    : "r" (__new)				\
 			    : "memory");				\
 		break;							\
 	case 8:								\
-		asm("xchgq %2, "__percpu_arg(1)			\
+		asm("\n1:mov "__percpu_arg(1)",%%rax"			\
+		    "\n\tcmpxchgq %2, "__percpu_arg(1)			\
+		    "\n\tjnz 1b"					\
 			    : "=a" (__ret), "+m" (var)			\
 			    : "r" (__new)				\
 			    : "memory");				\

