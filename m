Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab1AURu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:50:58 -0500
Received: from mail.openrapids.net ([64.15.138.104]:42798 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754386Ab1AURu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:50:57 -0500
Date: Fri, 21 Jan 2011 12:50:54 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
	this_cpu_cmpxchg_double
Message-ID: <20110121175054.GB12150@Krystal>
References: <alpine.DEB.2.00.1101070907060.3014@router.home> <20110107180419.GB23082@Krystal> <alpine.DEB.2.00.1101071227450.3014@router.home> <20110108172453.GF13269@mtj.dyndns.org> <4D393636.4040607@cs.helsinki.fi> <20110121092649.GA2832@htj.dyndns.org> <4D39A6EB.70705@zytor.com> <20110121154831.GE2832@htj.dyndns.org> <20110121165425.GB11687@Krystal> <alpine.DEB.2.00.1101211101510.15418@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101211101510.15418@router.home>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:44:01 up 58 days, 22:47,  4 users,  load average: 0.00, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> On Fri, 21 Jan 2011, Mathieu Desnoyers wrote:
> 
> > I'm again probably missing something, but what is "clumsy" about defining a
> > structure like the following to ensure proper alignment of the target
> > pointer (instead of adding a runtime test) ?
> >
> > struct cmpxchg_double {
> > #if __BYTE_ORDER == __LITTLE_ENDIAN
> >         unsigned long low, high;
> > #else
> >         unsigned long high, low;
> > #endif
> > } __attribute__((packed, aligned(2 * sizeof(unsigned long))));
> >
> > (note: packed here along with "aligned" does _not_ generate ugly bytewise
> > read/write memory ops like "packed" alone. The use of "packed" is to let the
> > compiler down-align the structure to the value requested, instead of uselessly
> > aligning it on 32-byte if it chooses to.)
> >
> > The prototype could then look like:
> >
> > bool __this_cpu_generic_cmpxchg_double(pcp, oval_low, oval_high, nval_low, nval_high);
> >
> > With:
> >   struct cmpxchg_double *pcp
> 
> That does not conform to the parameter conventions in other this_cpu_ops.
> The first parameter is a variable because the notion of a pointer is
> problematic given that percpu operations use a segment prefix to relocate
> pointers.

So the first argument could be along the lines of:

struct cmpxchg_double pcp

then.

> You would be implicitly passing a 128 bit argument although the
> compiler may not need to generate code for that.

Sorry, I don't understand this last statement. Does it still apply if we pass
pcp as I just proposed ? (without the pointer, with a __builtin_choose_expr
check on __alignof__ of the pcp parameter)

> 
> > I think Christoph's point is that he wants to alias this with a pointer. Well,
> > this can be done cleanly with:
> >
> > union {
> >         struct cmpxchg_double casdbl;
> >         struct {
> >                 void *ptr;
> >                 unsigned long cpuid_tid;
> >         } t;
> > }
> 
> There is no need for aliases with the existing implementation.
>
> How will the macro check the parameters now?

Well, my last proposal to check __alignof__ within a __builtin_choose_expr
check wouldn't need this union actually, which would be much better I think.

> 
> > Thoughts ?
> 
> Could you actually try to write a patch instead running through points
> that we have discussed earlier?

I'm going back to the points that have been previously dismissed with a rather
large degree of handwaving. ;) I'm OK with looking into the API and providing
code snippets to show the basic implementation behind the ideas, but I
unfortunately don't have the bandwidth to stop everything I'm currently working
on and start working on double-cas patches. Sorry, I wish I could do more.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
