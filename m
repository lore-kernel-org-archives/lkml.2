Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab1FOO0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 10:26:21 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:33583 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754618Ab1FOO0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 10:26:19 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: oNVaKJUVM1kM2H5RfdRSGAtfHf6QxK3C0ZY1hD_ZbEq8__b
 SdzjfFRjusXzW_RjCxKpDfe1dHvvSmD5dh4Whb1pHfRfKkViAKwomtrKzy5R
 ED8Ccl.JDBFdipNM3CPeeD.ItoW0IqjybTFRp8LKF4V3ET3hcNkTpkAYAOro
 cxN1HI9lLDQvD4wr4rxZnSWHIb.RcDK7vVVw6.UhhFovZoeh.B40fO5e7GCy
 mwikTqmla_PiqhtwOJ01p3Z9OSdfANSCeg5px7Fut8aXxXvVoR3LTebvE1X6
 WlBxfgYtiq_7tRJnhDnpTksCf.d8bAY8Z8LT1BqGkmK32wCnP
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 15 Jun 2011 09:26:15 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [slubllv7 04/17] x86: Add support for cmpxchg_double
In-Reply-To: <20110615085512.GO8141@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1106150917520.768@router.home>
References: <20110601172543.437240675@linux.com> <20110601172614.173427964@linux.com> <20110615085512.GO8141@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011, Tejun Heo wrote:

> Hello, Christoph, Pekka.  Sorry about the delay.
>
> On Wed, Jun 01, 2011 at 12:25:47PM -0500, Christoph Lameter wrote:
> > Index: linux-2.6/arch/x86/include/asm/cmpxchg_64.h
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/include/asm/cmpxchg_64.h	2011-06-01 11:01:05.002406114 -0500
> > +++ linux-2.6/arch/x86/include/asm/cmpxchg_64.h	2011-06-01 11:01:48.222405834 -0500
> > +#define cmpxchg_double(ptr, o1, o2, n1, n2)				\
> > +({									\
> > +	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
> > +	VM_BUG_ON((unsigned long)(ptr) % 16);				\
> > +	cmpxchg16b((ptr), (o1), (o2), (n1), (n2));			\
> > +})
> > +
> > +#define cmpxchg_double_local(ptr, o1, o2, n1, n2)			\
> > +({									\
> > +	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
> > +	VM_BUG_ON((unsigned long)(ptr) % 16);				\
> > +	cmpxchg16b_local((ptr), (o1), (o2), (n1), (n2));		\
> > +})
>
> Do we really need cmpxchg16b*() macros separately?  Why not just
> collapse them into cmpxchg_double*()?  Also, it would be better if we
> have the same level of VM_BUG_ON() checks as in percpu cmpxchg_double
> ops.  Maybe we should put them in a separate macro?

The method here is to put all the high level checks in cmpxchg_double()
and then do the low level asm stuff in cmpxchg16b macros. I think that is
a good separation.

 > > +#define system_has_cmpxchg_double() cpu_has_cx16
>
> Where's the fallback %false definition for the above feature macro for
> archs which don't support cmpxchg_double?  Also, is system_has_*()
> conventional?  Isn't arch_has_*() more conventional for this purpose?

There is a convention for querying processor flags from core code?

The system_has_cmpxchg_double() is only used if the arch defines
CONFIG_CMPXCHG_DOUBLE

> > +#define cmpxchg8b_local(ptr, o1, o2, n1, n2)			\
> > +({								\
> > +	char __ret;						\
> > +	__typeof__(o2) __dummy;					\
> > +	__typeof__(*(ptr)) __old1 = (o1);			\
> > +	__typeof__(o2) __old2 = (o2);				\
> > +	__typeof__(*(ptr)) __new1 = (n1);			\
> > +	__typeof__(o2) __new2 = (n2);				\
> > +	asm volatile("cmpxchg8b %2; setz %1"			\
> > +		       : "=d"(__dummy), "=a"(__ret), "+m" (*ptr)\
> > +		       : "a" (__old), "d"(__old2),		\
> > +		         "b" (__new1), "c" (__new2),		\
> > +		       : "memory");				\
> > +	__ret; })
>
> Wouldn't it be better to use cmpxchg64() for cmpxchg_double()?

This way it is done in the same way on 32 bit than on 64 bit. The use of
cmpxchg64 also means that some of the parameters would have to be combined
to form 64 bit ints from the 32 bit ones before __cmpxchg64 could be used.

__cmpxchg64 has different parameter conventions.

> Another thing is that choosing different code path depending on
> has_cmpxchg_double() would be quite messy and won't bode well with
> many people.  I agree that fallback implementation would be heavier
> for SMP safe operations but some archs already do that for cmpxchg
> (forgot which one).  If we're gonna export this to generic code,
> wouldn't it be better to implement proper generic fallbacks and
> provide has_*() as hint?

A generic fallback for cmpxchg_double would mean having to disable
interrupts and then take a global spinlock. There are significant scaling
problems with such an implementation.

The fallback through the subsystem means that the subsystem can do locking
that scales better. In the case of SLUB we fall back to a bit lock in the
page struct which is a hot cache line in the hotpaths. This is the same
approach as used before the lockless patches and we expect the performance
on platforms not supporting cmpxchg_double to stay the same.

