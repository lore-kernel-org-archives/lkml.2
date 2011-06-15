Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab1FORTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 13:19:40 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:34506 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751521Ab1FORTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 13:19:39 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 1srJRmYVM1lVDcpzDp5yck4BtIwJtlk4dn3x0z7lsdDa67U
 NY5UYX.ZnGW9M5CA9XPEEm.NJMhL.VJCV8NWve5dUyQbbTys91gadbl_rki8
 pb0ClAyu5AnrefOGjRCdz9ZY31srQGNqng0BbBkFcwzw6_OYvIu3P2taXUlu
 2O4VzBVVhxOdbVGy.iwAfeG1.3raB2y93skblRxuAi0fNGD3f6L4YPBFA3Ah
 yQndeAVnYrcn1How6pGiPf0rhAcUAqfxf9bikiGHmINhLgTksELZkt8eGUlR
 V1QA9Y67LhjueckBaMYbV3qo_sSVTe1ZV9QSe4cJoaGPG6857
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 15 Jun 2011 12:19:35 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [slubllv7 04/17] x86: Add support for cmpxchg_double
In-Reply-To: <20110615163952.GE8141@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1106151213180.4224@router.home>
References: <20110601172543.437240675@linux.com> <20110601172614.173427964@linux.com> <20110615085512.GO8141@htj.dyndns.org> <alpine.DEB.2.00.1106150917520.768@router.home> <20110615163952.GE8141@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011, Tejun Heo wrote:

> > > > +#define system_has_cmpxchg_double() cpu_has_cx16
> > >
> > > Where's the fallback %false definition for the above feature macro for
> > > archs which don't support cmpxchg_double?  Also, is system_has_*()
> > > conventional?  Isn't arch_has_*() more conventional for this purpose?
> >
> > There is a convention for querying processor flags from core code?
>
> At least generic ptrace code uses arch_has_block/single_step().
> Probably better than introducing something completely new.

Its not a property of the arch that we are after. We need to know of the
hardware that is running the kernel (the system) has that capability.

> > The system_has_cmpxchg_double() is only used if the arch defines
> > CONFIG_CMPXCHG_DOUBLE
>
> Why?  What's the benefit of that?

You dont have to define system_has_cmpxchg_double() for systems without
CONFIG_CMPXCHG_DOUBLE.

> > This way it is done in the same way on 32 bit than on 64 bit. The use of
> > cmpxchg64 also means that some of the parameters would have to be combined
> > to form 64 bit ints from the 32 bit ones before __cmpxchg64 could be used.
> >
> > __cmpxchg64 has different parameter conventions.
>
> But they all just deal with the starting addresses and the _local
> version already has proper fallback implementation.

The local version is not that problematic since it is just provided for
completeness. If you want to go through the gyrations of providing a
conversion layer with casting and conversion between 32 and 64 bit
entities then please do so. But its not going to be nice.

> > The fallback through the subsystem means that the subsystem can do locking
> > that scales better. In the case of SLUB we fall back to a bit lock in the
> > page struct which is a hot cache line in the hotpaths. This is the same
> > approach as used before the lockless patches and we expect the performance
> > on platforms not supporting cmpxchg_double to stay the same.
>
> Yes, that's nice but you're introducing new operations and they should
> meet the usual conventions and cmpxchg fallback on the arch which I
> don't recall now already uses hashed lock so it's not like this is
> completely new.  As added, the interface basically requires extreme
> ifdeffery which isn't good.

I'd be glad if you could improve on it. But the fallback to a hashed lock
would also mean additional cache footprint which would not be acceptable
for the hotpaths that this is used for now.
