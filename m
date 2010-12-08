Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab0LHWUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 17:20:11 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:47037 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751676Ab0LHWUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 17:20:09 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: CNeodvMVM1mvr35MdUGgf1dbxUQCs3MNb9rb6zsWfhKU9DG
 YwdpHHhfGMqjuDpNVKrClesPPs53bACbJzZdPw26fCf.qTvYNjJ0ZZKWPPQ.
 tPll46ixfjxRsuOrY1oacw2XEHqngvjWhceeYjbpynnQDCxc9sF6frd9KwEE
 w0gYzzi8hIcmr3_hoKUW8P.Q5TEaY8ov4p3xrYVPRKlBOkIdI.FP1aVp.Tok
 680xhpNOqLok_2bsOWT821rwQdrwubm3DdRxstVsG2ZJBr0b7emLUMDCYg5G
 4LGOeFj5vrxR7TZgzxJiW
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 8 Dec 2010 16:20:06 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg V1 2/4] x86: this_cpu_cmpxchg and this_cpu_xchg
 operations
In-Reply-To: <20101208175543.000201149@linux.com>
Message-ID: <alpine.DEB.2.00.1012081618530.28112@router.home>
References: <20101208175520.456864019@linux.com> <20101208175543.000201149@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argh. I included __this_cpu_cmpxchg_8 done with cmpxchg8b for 32 bit. That
has some issues....


Subject: Fixup __this_cpu_cmpxchg_8

__this_cpu_cmpxchg_8 can cause compilation failure since it is expanded
for any this_cpu_cmpxchg independent of the size or type of argument.
However. __this_cpu_cmpxchg_8 only generates code for the 8 byte
case. Use a union to get around the compilation failures.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/include/asm/percpu.h |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2010-12-08 14:48:02.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2010-12-08 16:01:24.000000000 -0600
@@ -391,15 +391,23 @@ do {									\

 #ifndef CONFIG_X86_64
 #ifdef CONFIG_X86_CMPXCHG64
-/* We can support a 8 byte cmpxchg with a special instruction on 32 bit */
+/*
+ * We can support a 8 byte cmpxchg with a special instruction on 32 bit.
+ *
+ * Note that some of the strangeness here with the __new variable is due to
+ * the need to expand and compile this function for arbitary types even
+ * though the code will not be included in the .o file if used for a smaller
+ * type.
+ */
 #define __this_cpu_cmpxchg_8(pcp, oval, nval)				\
 ({									\
-	typeof(var) __ret;						\
-	typeof(var) __old = (oval);					\
-	typeof(var) __new = (nval);					\
+	typeof(pcp) __ret;						\
+	typeof(pcp) __old = (oval);					\
+	union x { typeof(pcp) n;u64 m; } __new;				\
+	__new.n = (nval);						\
 	asm("cmpxchg8b %2, "__percpu_arg(1)				\
-	    : "=A" (__ret), "+m" (&pcp)					\
-	    : "b" (((u32)new), "c" ((u32)(new >> 32)),  "0" (__old)	\
+	    : "=A" (__ret), "+m" (pcp)					\
+	    : "b" ((u32)__new.m), "c" ((u32)(__new.m >> 32)),  "0" (__old)	\
 	    : "memory");						\
 	__ret;								\
 })

