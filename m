Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab0LNRT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:19:29 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:25560 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752083Ab0LNRT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:19:28 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 9Uy6SsYVM1nuhusIvCxI6x38yZnRwXSyd6kzYjaFu0jpgL0
 H8.mfQ4MFE3meHyNA02vLTn8LYUsShJ0IKPC4cfG.9NZBXLy2Wy7EZd0WASU
 dfkw_wreKeCWmed9tuRztZ2_Lypa.86Zovg.cifG8GDpHA34MaO9GMWUujqb
 viQT8GNTOXSUZu6xCARVEQFzsf5txK0HSPlyB79o8jvsZfaHkfoNIvCLX.1C
 3Xmw8eiEl9g6Iql8Jpj_R5q1G6uxG3f04CwZmv29HW8SG5Y.FNfxbEoZaOvt
 IVvuitvucokGoMqaltd3AiK23kvMEudSbLxlJyFd9ER.zpLg-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 14 Dec 2010 11:19:24 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Tejun Heo <tj@kernel.org>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg V2 5/5] cpuops: Use cmpxchg for xchg to avoid
 lock semantics
In-Reply-To: <4D07A2B7.8080405@zytor.com>
Message-ID: <alpine.DEB.2.00.1012141109470.17229@router.home>
References: <20101214162842.542421046@linux.com>  <20101214162855.392020353@linux.com> <1292345072.5934.32.camel@edumazet-laptop> <alpine.DEB.2.00.1012141055220.17229@router.home> <4D07A2B7.8080405@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 14 Dec 2010, H. Peter Anvin wrote:

> On 12/14/2010 08:55 AM, Christoph Lameter wrote:
> >
> > We do not need to reload the value as pointed out by Eric. It is already in
> > the correct register so just rerun the cmpxchg without the load.
> >
> > Signed-off-by: Christoph Lameter <cl@linux.com>
> >
>
> Is it genuinely faster to do the pre-load mov, or can we drop that too?
>  My guess would be that yes it is, but if it happens not to be it would
> be nice to reduce the code size.

Dropping the load increases the cycle count from 11 to 16.

---
 arch/x86/include/asm/percpu.h |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2010-12-14 11:07:18.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2010-12-14 11:14:37.000000000 -0600
@@ -223,32 +223,28 @@ do {									\
 	typeof(var) __new = (nval);					\
 	switch (sizeof(var)) {						\
 	case 1:								\
-		asm("\n1:mov "__percpu_arg(1)",%%al"			\
-		    "\n\tcmpxchgb %2, "__percpu_arg(1)			\
+		asm("\n1:cmpxchgb %2, "__percpu_arg(1)			\
 		    "\n\tjnz 1b"					\
 			    : "=a" (__ret), "+m" (var)			\
 			    : "q" (__new)				\
 			    : "memory");				\
 		break;							\
 	case 2:								\
-		asm("\n1:mov "__percpu_arg(1)",%%ax"			\
-		    "\n\tcmpxchgw %2, "__percpu_arg(1)			\
+		asm("\n1:cmpxchgw %2, "__percpu_arg(1)			\
 		    "\n\tjnz 1b"					\
 			    : "=a" (__ret), "+m" (var)			\
 			    : "r" (__new)				\
 			    : "memory");				\
 		break;							\
 	case 4:								\
-		asm("\n1:mov "__percpu_arg(1)",%%eax"			\
-		    "\n\tcmpxchgl %2, "__percpu_arg(1)			\
+		asm("\n1:cmpxchgl %2, "__percpu_arg(1)			\
 		    "\n\tjnz 1b"					\
 			    : "=a" (__ret), "+m" (var)			\
 			    : "r" (__new)				\
 			    : "memory");				\
 		break;							\
 	case 8:								\
-		asm("\n1:mov "__percpu_arg(1)",%%rax"			\
-		    "\n\tcmpxchgq %2, "__percpu_arg(1)			\
+		asm("\n1:cmpxchgq %2, "__percpu_arg(1)			\
 		    "\n\tjnz 1b"					\
 			    : "=a" (__ret), "+m" (var)			\
 			    : "r" (__new)				\
