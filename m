Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab1AUSh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:37:56 -0500
Received: from mail.openrapids.net ([64.15.138.104]:45832 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752988Ab1AUShz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:37:55 -0500
Date: Fri, 21 Jan 2011 13:37:52 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
	this_cpu_cmpxchg_double
Message-ID: <20110121183752.GA12998@Krystal>
References: <alpine.DEB.2.00.1101071227450.3014@router.home> <20110108172453.GF13269@mtj.dyndns.org> <4D393636.4040607@cs.helsinki.fi> <20110121092649.GA2832@htj.dyndns.org> <4D39A6EB.70705@zytor.com> <20110121154831.GE2832@htj.dyndns.org> <20110121165425.GB11687@Krystal> <alpine.DEB.2.00.1101211101510.15418@router.home> <20110121175054.GB12150@Krystal> <alpine.DEB.2.00.1101211158090.15692@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101211158090.15692@router.home>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:26:52 up 58 days, 23:29,  4 users,  load average: 0.03, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> On Fri, 21 Jan 2011, Mathieu Desnoyers wrote:
> 
> > > > With:
> > > >   struct cmpxchg_double *pcp
> > >
> > > That does not conform to the parameter conventions in other this_cpu_ops.
> > > The first parameter is a variable because the notion of a pointer is
> > > problematic given that percpu operations use a segment prefix to relocate
> > > pointers.
> >
> > So the first argument could be along the lines of:
> >
> > struct cmpxchg_double pcp
> >
> > then.
> 
> Ok then you would pass a struct by value? Or use a non-scalar as a
> variable passed to a this_cpu_op? So far per cpu scalars have been the
> only variables allowed to be specified in this_cpu operations.

What I have in mind is that the struct passed would be non-scalar for this
specific operation. I'm not sure about the distinction between "pass a struct by
value" and "use a non-scalar as a variable passed to a this_cpu_op" -- I feel
I'm missing an important detail in what you say, because I see these as being
the same thing.

> 
> > > >         struct cmpxchg_double casdbl;
> > > >         struct {
> > > >                 void *ptr;
> > > >                 unsigned long cpuid_tid;
> > > >         } t;
> > > > }
> > >
> > > There is no need for aliases with the existing implementation.
> > >
> > > How will the macro check the parameters now?
> >
> > Well, my last proposal to check __alignof__ within a __builtin_choose_expr
> > check wouldn't need this union actually, which would be much better I think.
> 
> The existing implementation has a check for alignment. That is not the
> problem.

It's a dynamic check right ? (based on VM_BUG_ON() if I remember well) It adds
code and runtime conditions, which would go away if we let the alignment check
be done at compile-time.

> The typechecking would need to be addressed. I.e. if I pass a
> pointer for old and an ulong for the new value then I'd like to see the
> compiler complain. Or if the first parameter is a long but the type of the
> first word is a pointer etc etc.

Hrm. Then the only solution I see would be to require that the structure
used as percpu_dd parameter have fixed field names (yeah, that's a bit odd, but
could not come up with a more elegant solution at the moment):

struct mycustomdoublestruct {
        sometype word1;
        someothertype word2;
}

So we can access percpu_dd.word1 and percpu_dd.word2 within
this_cpu_cmpxchg_double for the type checking.

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
