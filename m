Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab0LRPYc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 10:24:32 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:40252 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab0LRPYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 10:24:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=UekjHzT6qQA1wDwfkceEQaqoupzJgDZYJE8nVoNtWK7QeYgYIqSRZ3AxOegHzMrhRh
         tfxDSzeCscBnu3ew5AUZMdv1Dd9pFXWh395G9kdJ9oC0ncZfhERt3MnFEVa0q876tBgF
         8QJ+BwVRIHQz4/O0v/Rs1ALexRnrPyPCA+edo=
From: Tejun Heo <tj@kernel.org>
To: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com, hpa@zytor.com,
        mathieu.desnoyers@efficios.com
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] x86: Support for this_cpu_add, sub, dec, inc_return
Date: Sat, 18 Dec 2010 16:24:08 +0100
Message-Id: <1292685852-12469-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292685852-12469-1-git-send-email-tj@kernel.org>
References: <1292685852-12469-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux.com>

Supply an implementation for x86 in order to generate more efficient code.

V2->V3:
	- Cleanup
	- Remove strange type checking from percpu_add_return_op.

tj: - Dropped unused typedef from percpu_add_return_op().
    - Renamed ret__ to paro_ret__ in percpu_add_return_op().
    - Minor indentation adjustments.

Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/percpu.h |   43 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index f899e01..38f9e96 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -177,6 +177,39 @@ do {									\
 	}								\
 } while (0)
 
+/*
+ * Add return operation
+ */
+#define percpu_add_return_op(var, val)					\
+({									\
+	typeof(var) paro_ret__ = val;					\
+	switch (sizeof(var)) {						\
+	case 1:								\
+		asm("xaddb %0, "__percpu_arg(1)				\
+			    : "+q" (paro_ret__), "+m" (var)		\
+			    : : "memory");				\
+		break;							\
+	case 2:								\
+		asm("xaddw %0, "__percpu_arg(1)				\
+			    : "+r" (paro_ret__), "+m" (var)		\
+			    : : "memory");				\
+		break;							\
+	case 4:								\
+		asm("xaddl %0, "__percpu_arg(1)				\
+			    : "+r" (paro_ret__), "+m" (var)		\
+			    : : "memory");				\
+		break;							\
+	case 8:								\
+		asm("xaddq %0, "__percpu_arg(1)				\
+			    : "+re" (paro_ret__), "+m" (var)		\
+			    : : "memory");				\
+		break;							\
+	default: __bad_percpu_size();					\
+	}								\
+	paro_ret__ += val;						\
+	paro_ret__;							\
+})
+
 #define percpu_from_op(op, var, constraint)		\
 ({							\
 	typeof(var) pfo_ret__;				\
@@ -300,6 +333,14 @@ do {									\
 #define irqsafe_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define irqsafe_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
 
+#ifndef CONFIG_M386
+#define __this_cpu_add_return_1(pcp, val) percpu_add_return_op(pcp, val)
+#define __this_cpu_add_return_2(pcp, val) percpu_add_return_op(pcp, val)
+#define __this_cpu_add_return_4(pcp, val) percpu_add_return_op(pcp, val)
+#define this_cpu_add_return_1(pcp, val)	percpu_add_return_op(pcp, val)
+#define this_cpu_add_return_2(pcp, val)	percpu_add_return_op(pcp, val)
+#define this_cpu_add_return_4(pcp, val)	percpu_add_return_op(pcp, val)
+#endif
 /*
  * Per cpu atomic 64 bit operations are only available under 64 bit.
  * 32 bit must fall back to generic operations.
@@ -324,6 +365,8 @@ do {									\
 #define irqsafe_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
 #define irqsafe_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
 
+#define __this_cpu_add_return_8(pcp, val) percpu_add_return_op(pcp, val)
+#define this_cpu_add_return_8(pcp, val)	percpu_add_return_op(pcp, val)
 #endif
 
 /* This is not atomic against other CPUs -- CPU preemption needs to be off */
-- 
1.7.1

