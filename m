Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab0LHWWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 17:22:22 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:22276 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755039Ab0LHWWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 17:22:21 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: AuDe3rcVM1lAILa6m19K91b9q93son0EkChanzUTFQvDAMI
 fHWs.r0nXSRcSLBMRdQvZ87Cf4rtqqH_G_NbY5WDA3Tp1qDRXUf0LTG3aSUy
 MD7fFt6HFvNKw2Jq8lAcCFnfmGcT26sl.eXMzi5gBpoo.fIm5GkO1WKZVpYz
 IzFGihP3y3lwPuksDjg.aWZhxMZyWWAIcRiJHEoBAvQpYt33aOTWRY3UKP2d
 vETT98r3kqUYXlgeWw1jn2nvEUr.MkV5nEZNYZfh0siHnPcic_sde
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 8 Dec 2010 16:22:18 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: cpuops cmpxchg: Provide 64 bit this_cpu_xx for 32 bit x86 using
 cmpxchg8b
In-Reply-To: <20101208175520.456864019@linux.com>
Message-ID: <alpine.DEB.2.00.1012081620340.28112@router.home>
References: <20101208175520.456864019@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another patch in the series. This may allow better 64 bit counter
management and avoids preempt on/off. Maybe not since we have an
additional branch and load.

Subject: cpuops: Provide 64 bit this_cpu_xx for 32 bit x86

The 64 bit this_cpu_cmpxchg can be used to create a set of 64 bit operations
so that 64 bit entities can also be handled by the this_cpu ops on 32 bit.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/include/asm/percpu.h |   64 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 63 insertions(+), 1 deletion(-)


Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2010-12-08 16:02:39.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2010-12-08 16:12:48.000000000 -0600
@@ -405,7 +405,7 @@ do {									\
 	typeof(pcp) __old = (oval);					\
 	union x { typeof(pcp) n;u64 m; } __new;				\
 	__new.n = (nval);						\
-	asm("cmpxchg8b %2, "__percpu_arg(1)				\
+	asm("cmpxchg8b "__percpu_arg(1)					\
 	    : "=A" (__ret), "+m" (pcp)					\
 	    : "b" ((u32)__new.m), "c" ((u32)(__new.m >> 32)),  "0" (__old)	\
 	    : "memory");						\
@@ -415,6 +415,68 @@ do {									\
 #define this_cpu_cmpxchg_8(pcp, oval, nval)	__this_cpu_cmpxchg_8(pcp, oval, nval)
 #define irqsafe_cmpxchg_8(pcp, oval, nval)	__this_cpu_cmpxchg_8(pcp, oval, nval)

+/*
+ * cmpxchg_8 can be used to create support for the 64 bit operations
+ * that are missing on 32 bit.
+ */
+
+#define this_cpu_write_8(pcp, val)					\
+({									\
+	typeof(val) __v = (val);					\
+	typeof(val) __o;						\
+	do {								\
+		__o = this_cpu_read_8(pcp);				\
+	} while (this_cpu_cmpxchg_8(pcp, __o, __v) != __o);		\
+})
+
+#define this_cpu_add_8(pcp, val)					\
+({									\
+	typeof(val) __v = (val);					\
+	typeof(val) __o;						\
+	do {								\
+		__o = this_cpu_read_8(pcp);				\
+	} while (this_cpu_cmpxchg_8(pcp, __o, __o + __v) != __o);	\
+})
+
+#define this_cpu_and_8(pcp, val)					\
+({									\
+	typeof(val) __v = (val);					\
+	typeof(val) __o;						\
+	do {								\
+		__o = this_cpu_read_8(pcp);				\
+	} while (this_cpu_cmpxchg_8(pcp, __o, __o & __v) != __o);	\
+})
+
+#define this_cpu_or_8(pcp, val)						\
+({									\
+	typeof(val) __v = (val);					\
+	typeof(val) __o;						\
+	do {								\
+		__o = this_cpu_read_8(pcp);				\
+	} while (this_cpu_cmpxchg_8(pcp, __o, __o | __v) != __o);		\
+})
+
+#define this_cpu_xor_8(pcp, val)					\
+({									\
+	typeof(val) __v = (val);					\
+	typeof(val) __o;						\
+	do {								\
+		__o = this_cpu_read_8(pcp);				\
+	} while (this_cpu_cmpxchg_8(pcp, __o, __o ^ __v) != __o);		\
+})
+
+#define this_cpu_inc_return_8(pcp, val)				\
+({									\
+	typeof(val) __v = (val);					\
+	typeof(val) __o;						\
+	typeof(val) __r;						\
+	do {								\
+		__o = this_cpu_read_8(pcp);				\
+		__r = __o  + __v;					\
+	} while (this_cpu_cmpxchg_8(pcp, __o, __r) != __o);		\
+	r;								\
+})
+
 #endif /* CONFIG_X86_CMPXCHG64 */
 #endif /* !CONFIG_X86_64 */


