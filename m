Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab0LXAQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 19:16:58 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:26070 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751619Ab0LXAQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 19:16:57 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: oSjHFUUVM1k7Vh1m6zS91h0r4pDjqCn.RFjJmUHOrgH_xex
 Eia77sy1befLIJmku5Z11pPPOmU48Kjdzu_0OqlHasNSF_Mn.HEnA3ThZ7GN
 x2xcbD0KoBeN_k9ZoQl1dJzEJME57X6_ZmbcJUHNhJffjJA.jgeOzF11Z.ne
 7dQylJ57xCm2P9GoOFS15SGak551o_KtPYpkGLB9oHNnZBL0HiZkLsjNz9X5
 NzEMGWqRNNZVTbJ4gxZoxUJaq7iS._csoSf9gOifhMB7tViFdG6SFruAkfW.
 Z24PqBzr70ZRfPUMV1h5Sji7t_Hyn.dDnIVlfdsjEcMEr0l8-
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 23 Dec 2010 18:16:52 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V1 1/4] Generic support for
 this_cpu_cmpxchg_double
In-Reply-To: <20101222091358.GC27861@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1012231812280.22549@router.home>
References: <20101214174847.887713690@linux.com> <20101214174900.058235985@linux.com> <4D0CC982.3030905@kernel.org> <alpine.DEB.2.00.1012211634560.3769@router.home> <4D11373D.9010205@zytor.com> <20101222091358.GC27861@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Dec 2010, Tejun Heo wrote:

> > I'm a bit confused on this one.  The standard cmpxchg() takes a scalar
> > and a pointer, and returns a scalar.  The equivalent for the "double"
> > variety would be to return a compound object, basically:
> >
> > struct double_ulong {
> > 	unsigned long v[2];
> > };
> >
> > ... which can be returned in registers on both i386 and x86-64.

Really? How would that work? I tried with uint128 but could not get the
compiler to do the right thing.

> > It's a bit clumsy from a type perspective, but I'm not sure that that is
> > a bad thing.  Doing too much type genericity has caused us problems in
> > the past.
>
> Yeah, the above might be better too.  Is there any reason to use
> cmpxchg_double on anything smaller?

Yes. You may want to use cmpxchg_double on 32 bit entities for backwards
compatibilities sake or any other smaller unit size. But those could also
be realized using this_cpu_cmpxchg_<double the size> by just aggregating
the amount.

If we can indeed pass 128 bit entities (as claimed by hpa) via registers
then the logical choice would be to do

	this_cpu_cmpxchg_16(pcp, old, new)

instead of cmpxchg_double. All parameters would have to be bit.
Then we can avoid the strange cmpxchg_double semantics and can completely
avoid introducing those.




