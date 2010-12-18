Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab0LRPYh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 10:24:37 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:62457 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457Ab0LRPYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 10:24:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=rtpkoMjh5hBlLrhsDiQESMIlB+AV1/8APBaKz02Z1FxVtewZa3bFWNjVbTP4xF8B2x
         LUUjr8FpatIS08pJWu+UMgre+ViFw+ifYt67IrvdsJeqcWiXt8UqGD6z3F70z4X1Jh80
         HbIrs9ySXUgOHU9ukSPR/R3Uc21FlXWaZhrUc=
From: Tejun Heo <tj@kernel.org>
To: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com, hpa@zytor.com,
        mathieu.desnoyers@efficios.com
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] x86: this_cpu_cmpxchg and this_cpu_xchg operations
Date: Sat, 18 Dec 2010 16:24:11 +0100
Message-Id: <1292685852-12469-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292685852-12469-1-git-send-email-tj@kernel.org>
References: <1292685852-12469-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux.com>

Provide support as far as the hardware capabilities of the x86 cpus
allow.

Define CONFIG_CMPXCHG_LOCAL in Kconfig.cpu to allow core code to test for
fast cpuops implementations.

V1->V2:
	- Take out the definition for this_cpu_cmpxchg_8 and move it into
	  a separate patch.

tj: - Reordered ops to better follow this_cpu_* organization.
    - Renamed macro temp variables similar to their existing
      neighbours.

Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/Kconfig.cpu          |    3 +
 arch/x86/include/asm/percpu.h |  107 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 109 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 2ac9069..15588a0 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -310,6 +310,9 @@ config X86_INTERNODE_CACHE_SHIFT
 config X86_CMPXCHG
 	def_bool X86_64 || (X86_32 && !M386)
 
+config CMPXCHG_LOCAL
+	def_bool X86_64 || (X86_32 && !M386)
+
 config X86_L1_CACHE_SHIFT
 	int
 	default "7" if MPENTIUM4 || MPSC
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index dd0cd4b..b85ade5 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -263,6 +263,83 @@ do {									\
 })
 
 /*
+ * Beware: xchg on x86 has an implied lock prefix. There will be the cost of
+ * full lock semantics even though they are not needed.
+ */
+#define percpu_xchg_op(var, nval)					\
+({									\
+	typeof(var) pxo_ret__;						\
+	typeof(var) pxo_new__ = (nval);					\
+	switch (sizeof(var)) {						\
+	case 1:								\
+		asm("xchgb %2, "__percpu_arg(1)				\
+			    : "=a" (pxo_ret__), "+m" (var)		\
+			    : "q" (pxo_new__)				\
+			    : "memory");				\
+		break;							\
+	case 2:								\
+		asm("xchgw %2, "__percpu_arg(1)				\
+			    : "=a" (pxo_ret__), "+m" (var)		\
+			    : "r" (pxo_new__)				\
+			    : "memory");				\
+		break;							\
+	case 4:								\
+		asm("xchgl %2, "__percpu_arg(1)				\
+			    : "=a" (pxo_ret__), "+m" (var)		\
+			    : "r" (pxo_new__)				\
+			    : "memory");				\
+		break;							\
+	case 8:								\
+		asm("xchgq %2, "__percpu_arg(1)				\
+			    : "=a" (pxo_ret__), "+m" (var)		\
+			    : "r" (pxo_new__)				\
+			    : "memory");				\
+		break;							\
+	default: __bad_percpu_size();					\
+	}								\
+	pxo_ret__;							\
+})
+
+/*
+ * cmpxchg has no such implied lock semantics as a result it is much
+ * more efficient for cpu local operations.
+ */
+#define percpu_cmpxchg_op(var, oval, nval)				\
+({									\
+	typeof(var) pco_ret__;						\
+	typeof(var) pco_old__ = (oval);					\
+	typeof(var) pco_new__ = (nval);					\
+	switch (sizeof(var)) {						\
+	case 1:								\
+		asm("cmpxchgb %2, "__percpu_arg(1)			\
+			    : "=a" (pco_ret__), "+m" (var)		\
+			    : "q" (pco_new__), "0" (pco_old__)		\
+			    : "memory");				\
+		break;							\
+	case 2:								\
+		asm("cmpxchgw %2, "__percpu_arg(1)			\
+			    : "=a" (pco_ret__), "+m" (var)		\
+			    : "r" (pco_new__), "0" (pco_old__)		\
+			    : "memory");				\
+		break;							\
+	case 4:								\
+		asm("cmpxchgl %2, "__percpu_arg(1)			\
+			    : "=a" (pco_ret__), "+m" (var)		\
+			    : "r" (pco_new__), "0" (pco_old__)		\
+			    : "memory");				\
+		break;							\
+	case 8:								\
+		asm("cmpxchgq %2, "__percpu_arg(1)			\
+			    : "=a" (pco_ret__), "+m" (var)		\
+			    : "r" (pco_new__), "0" (pco_old__)		\
+			    : "memory");				\
+		break;							\
+	default: __bad_percpu_size();					\
+	}								\
+	pco_ret__;							\
+})
+
+/*
  * percpu_read() makes gcc load the percpu variable every time it is
  * accessed while percpu_read_stable() allows the value to be cached.
  * percpu_read_stable() is more efficient and can be used if its value
@@ -300,6 +377,12 @@ do {									\
 #define __this_cpu_xor_1(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define __this_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define __this_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
+/*
+ * Generic fallback operations for __this_cpu_xchg_[1-4] are okay and much
+ * faster than an xchg with forced lock semantics.
+ */
+#define __this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define __this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 
 #define this_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define this_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
@@ -319,6 +402,11 @@ do {									\
 #define this_cpu_xor_1(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define this_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define this_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
+#define this_cpu_xchg_1(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define this_cpu_xchg_2(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define this_cpu_xchg_4(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 
 #define irqsafe_cpu_add_1(pcp, val)	percpu_add_op((pcp), val)
 #define irqsafe_cpu_add_2(pcp, val)	percpu_add_op((pcp), val)
@@ -332,15 +420,32 @@ do {									\
 #define irqsafe_cpu_xor_1(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define irqsafe_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define irqsafe_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
+#define irqsafe_cpu_xchg_1(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define irqsafe_cpu_xchg_2(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define irqsafe_cpu_xchg_4(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define irqsafe_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define irqsafe_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 
 #ifndef CONFIG_M386
 #define __this_cpu_add_return_1(pcp, val) percpu_add_return_op(pcp, val)
 #define __this_cpu_add_return_2(pcp, val) percpu_add_return_op(pcp, val)
 #define __this_cpu_add_return_4(pcp, val) percpu_add_return_op(pcp, val)
+#define __this_cpu_cmpxchg_1(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define __this_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define __this_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+
 #define this_cpu_add_return_1(pcp, val)	percpu_add_return_op(pcp, val)
 #define this_cpu_add_return_2(pcp, val)	percpu_add_return_op(pcp, val)
 #define this_cpu_add_return_4(pcp, val)	percpu_add_return_op(pcp, val)
-#endif
+#define this_cpu_cmpxchg_1(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define this_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define this_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+
+#define irqsafe_cpu_cmpxchg_1(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define irqsafe_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define irqsafe_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#endif /* !CONFIG_M386 */
+
 /*
  * Per cpu atomic 64 bit operations are only available under 64 bit.
  * 32 bit must fall back to generic operations.
-- 
1.7.1

