Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab1AUSKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:10:55 -0500
Received: from mail.openrapids.net ([64.15.138.104]:57151 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752675Ab1AUSKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:10:54 -0500
Date: Fri, 21 Jan 2011 13:10:51 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Christoph Lameter <cl@linux.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
	this_cpu_cmpxchg_double
Message-ID: <20110121181051.GC12150@Krystal>
References: <4D393636.4040607@cs.helsinki.fi> <20110121092649.GA2832@htj.dyndns.org> <4D39A6EB.70705@zytor.com> <20110121154831.GE2832@htj.dyndns.org> <20110121165425.GB11687@Krystal> <20110121170847.GH2832@htj.dyndns.org> <1da7491b-6e7d-4453-9c6f-0e7767421ec4@email.android.com> <alpine.DEB.2.00.1101211121350.15692@router.home> <20110121174236.GA12150@Krystal> <alpine.DEB.2.00.1101211146320.15692@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101211146320.15692@router.home>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:54:11 up 58 days, 22:57,  4 users,  load average: 0.01, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> On Fri, 21 Jan 2011, Mathieu Desnoyers wrote:
> 
> > > this_cpu_cmpxchg_double(percpu_dd, oldword1, oldword2, newword1, newword2)
> > >
> > > with the problem of type checking
> >
> > What is the problem with type checking here ?
> 
> You need to know the fields in the struct to do the type checking with
> each of the other parameters.

Isn't that a bit much to try to match the type of each oldword/newword
parameter to the structure fields ? Having separated word 1-2 parameter is just
an artefact caused by the inability of some gcc to deal with int128; were we to
use int128, we would have none of this type-checking whatsoever.

We could simply check that the first parameter alignment is >= 2 * sizeof(long)
and that its size == 2 * sizeof(long), so that the layout in memory fits the
cmpxchg_double requirements. This should work both for structure and array
parameters.

Now if the user needs to map "oldword1, oldword2" to the actual percpu_dd
fields, we could ensure that the order of these two parameters actually match
the structure field or array index order. This would, of course, be documented
above this_cpu_cmpxchg_double().

> 
> > We could use a gcc builtin like the following to check if the alignment of
> > "percpu_dd" meets the double-cas requirements:
> >
> > #define testmacro(a, b) \
> >         __builtin_choose_expr(__alignof__(a) >= 2 * sizeof(unsigned long), \
> >                               ((a).low) = (b), \    /* success */
> >                               ((a).low) = (void) 0) /* compile-error */
> >
> > > or
> > >
> > > this_cpu_cmpxchg_double(percpu_dd, old_dd, new_dd)
> > >
> > > with the problem of 128 bit constants/structs passed by value.
> >
> > Yeah, I guess trying to deal with 128-bit value might be a bit tricky. But
> > having something sane and with compile-time-checked alignment for the percpu_dd
> > type is not to be looked over.
> 
> The existing implementation could be equipped to do a compile time check
> for the proper alignment if the pointer passed is constant.

"if the pointer passed is constant" -> if you use the actual type of percpu_dd
to check the alignment, then you can do an alignment check at compile-time even
for a non-const parameter. The requirement imposed on typing will take care to
make sure that even a non-const pointer will have the proper alignment.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
