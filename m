Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638Ab0LNQ4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:56:01 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:24342 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758656Ab0LNQ4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:56:00 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: qQklum8VM1mLP0YBQZTldMEUJiurCQrgtIvdLcALkMBIu6V
 4dNd87SIo3PXjd_mXT9.ycliDIuqCKIzB9SYogN.Tb.C47srefg3l4vY3bq4
 M5zf6ETtgu0nY_XcP2lO6owtazpVmgDWJuc_qjhSWjcpisooocazw6dXxvco
 XCPDHD3gn7.EJYrm1BRloupaPu_srq2LOiGj311RNGJ_3b8r549CgATeMMN.
 CpBbP3XEindNjQ2LKoD0gaEi6QRNRR6ZRQum5S8zwOLTT4mxyTmPbw___FnV
 AFnK9Gzqu6q40v8jvGkQlCFnK1GY6AxoCIXaISHtllUXNszc-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 14 Dec 2010 10:55:56 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg V2 5/5] cpuops: Use cmpxchg for xchg to avoid
 lock semantics
In-Reply-To: <1292345072.5934.32.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1012141055220.17229@router.home>
References: <20101214162842.542421046@linux.com>  <20101214162855.392020353@linux.com> <1292345072.5934.32.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010, Eric Dumazet wrote:

> You should use the fact that the failed cmpxchg loads in al/ax/eax/rax
> the current value, so :
>
> 	"\n\tmov "__percpu_arg(1)",%%al"
> 	"\n1:\tcmpxchgb %2, "__percpu_arg(1)
> 	"\n\tjnz 1b"
>
> (No need to reload the value again)

Subject: cpuops xchg: Exploit the fact that failed cmpxchges return old value

We do not need to reload the value as pointed out by Eric. It is already in
the correct register so just rerun the cmpxchg without the load.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/include/asm/percpu.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2010-12-14 10:51:57.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2010-12-14 10:54:46.000000000 -0600
@@ -223,32 +223,32 @@ do {									\
 	typeof(var) __new = (nval);					\
 	switch (sizeof(var)) {						\
 	case 1:								\
-		asm("\n1:mov "__percpu_arg(1)",%%al"			\
-		    "\n\tcmpxchgb %2, "__percpu_arg(1)			\
+		asm("\n\tmov "__percpu_arg(1)",%%al"			\
+		    "\n1:cmpxchgb %2, "__percpu_arg(1)		\
 		    "\n\tjnz 1b"					\
 			    : "=a" (__ret), "+m" (var)			\
 			    : "q" (__new)				\
 			    : "memory");				\
 		break;							\
 	case 2:								\
-		asm("\n1:mov "__percpu_arg(1)",%%ax"			\
-		    "\n\tcmpxchgw %2, "__percpu_arg(1)			\
+		asm("\n\tmov "__percpu_arg(1)",%%ax"			\
+		    "\n1:cmpxchgw %2, "__percpu_arg(1)		\
 		    "\n\tjnz 1b"					\
 			    : "=a" (__ret), "+m" (var)			\
 			    : "r" (__new)				\
 			    : "memory");				\
 		break;							\
 	case 4:								\
-		asm("\n1:mov "__percpu_arg(1)",%%eax"			\
-		    "\n\tcmpxchgl %2, "__percpu_arg(1)			\
+		asm("\n\tmov "__percpu_arg(1)",%%eax"			\
+		    "\n1:cmpxchgl %2, "__percpu_arg(1)		\
 		    "\n\tjnz 1b"					\
 			    : "=a" (__ret), "+m" (var)			\
 			    : "r" (__new)				\
 			    : "memory");				\
 		break;							\
 	case 8:								\
-		asm("\n1:mov "__percpu_arg(1)",%%rax"			\
-		    "\n\tcmpxchgq %2, "__percpu_arg(1)			\
+		asm("\n\tmov "__percpu_arg(1)",%%rax"			\
+		    "\n1:cmpxchgq %2, "__percpu_arg(1)		\
 		    "\n\tjnz 1b"					\
 			    : "=a" (__ret), "+m" (var)			\
 			    : "r" (__new)				\
