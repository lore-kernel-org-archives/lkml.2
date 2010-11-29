Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab0K2Syr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 13:54:47 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:27449 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751513Ab0K2Syq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 13:54:46 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: NztYYCkVM1kBiHIGa3_LWC8J0lN19P_jYeenxkXlAeUCwJ2
 CJMk-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 29 Nov 2010 12:54:42 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thisops uV2 04/10] x86: Support for
 this_cpu_add,sub,dec,inc_return
In-Reply-To: <20101129183333.GA25610@Krystal>
Message-ID: <alpine.DEB.2.00.1011291244410.4836@router.home>
References: <20101126210937.383047168@linux.com> <20101126210951.303044608@linux.com> <20101127150015.GE15365@Krystal> <alpine.DEB.2.00.1011291025410.3923@router.home> <20101129183333.GA25610@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010, Mathieu Desnoyers wrote:

> > > > +#define percpu_add_return_op(var, val)					\
> > > > +({									\
> > > > +	typedef typeof(var) pao_T__;					\
> > > > +	typeof(var) pfo_ret__ = val;					\
> > > > +	if (0) {							\
> > > > +		pao_T__ pao_tmp__;					\
> > > > +		pao_tmp__ = (val);					\
> > > > +		(void)pao_tmp__;					\
> > > > +	}								\
> > >
> > > OK, I'm dumb: why is the above needed ?
> >
> > Ensure that the compiler agrees that  *var and val are compatible. Taken
> > over from percpu_add_op().
>
> Isn't that the purpose of __builtin_types_compatible_p(t1, t2) ?

We also have a __same_type() macro in linux/compiler.h... But if I use
that the kernel build fails. I guess the check is too strict.

---
 arch/x86/include/asm/percpu.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2010-11-29 12:46:50.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2010-11-29 12:52:25.000000000 -0600
@@ -127,11 +127,7 @@ do {									\
 	typedef typeof(var) pao_T__;					\
 	const int pao_ID__ = (__builtin_constant_p(val) &&		\
 			      ((val) == 1 || (val) == -1)) ? (val) : 0;	\
-	if (0) {							\
-		pao_T__ pao_tmp__;					\
-		pao_tmp__ = (val);					\
-		(void)pao_tmp__;					\
-	}								\
+	BUILD_BUG_ON(!__same_type(var, val));				\
 	switch (sizeof(var)) {						\
 	case 1:								\
 		if (pao_ID__ == 1)					\


