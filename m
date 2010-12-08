Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab0LHQpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 11:45:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:38084 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab0LHQpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 11:45:03 -0500
Message-ID: <4CFFB5F0.6030006@kernel.org>
Date: Wed, 08 Dec 2010 17:44:32 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops UPDATED 2/9] x86: Support for this_cpu_add, sub, dec, inc_return
References: <20101206173958.685460926@linux.com> <20101206174014.214410808@linux.com>
In-Reply-To: <20101206174014.214410808@linux.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Dec 2010 16:44:35 +0000 (UTC)
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

Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
I got a bit fascistic with this one too.  Here's the updated version.

Thank you.

 arch/x86/include/asm/percpu.h |   43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

Index: percpu/arch/x86/include/asm/percpu.h
===================================================================
--- percpu.orig/arch/x86/include/asm/percpu.h
+++ percpu/arch/x86/include/asm/percpu.h
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
