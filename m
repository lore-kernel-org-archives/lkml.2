Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab0LOREr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 12:04:47 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:32836 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753221Ab0LOREq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 12:04:46 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: nOUFbXoVM1mW.G00o.mDRM97diTzryTjKG_mjV8KaSbitOY
 A.1HJJuyFcqfUzrfqCFQhTlCxhL9DSgJF1BRkBhfGWNWFM2iRXoLEE0h3NiJ
 .Cl8vSrUgqk2zdUMihoJrP8JXRpxOTCORcD7vp5qdPeJuytzZBxLhaguEnEj
 C7wNNf0EPp14FhETo1RzHn1fT..Hl30bwpNllDv9LTHU27AeYoBeQ8OiQwe3
 PBNT6fl_6nit2eBoWnTPwZJ.Sg.H2ocG7IOHWHVi31FBxhn7phUEXv569tEx
 en.xZ6JBivd3qpQOjlMWON4.84ZoufUNiMIMAlEWOdvKC9L4-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 15 Dec 2010 11:04:42 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg V2 3/5] irq_work: Use per cpu atomics instead
 of regular atomics
In-Reply-To: <1292431839.2708.30.camel@laptop>
Message-ID: <alpine.DEB.2.00.1012151059430.13049@router.home>
References: <20101214162842.542421046@linux.com>  <20101214162854.218751478@linux.com>  <4D08EDA9.3090801@kernel.org> <1292431839.2708.30.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010, Peter Zijlstra wrote:

> On Wed, 2010-12-15 at 17:32 +0100, Tejun Heo wrote:
> > On 12/14/2010 05:28 PM, Christoph Lameter wrote:
> > > The irq work queue is a per cpu object and it is sufficient for
> > > synchronization if per cpu atomics are used. Doing so simplifies
> > > the code and reduces the overhead of the code.
> > >
> > > Before:
> > >
> > > christoph@linux-2.6$ size kernel/irq_work.o
> > >    text	   data	    bss	    dec	    hex	filename
> > >     451	      8	      1	    460	    1cc	kernel/irq_work.o
> > >
> > > After:
> > >
> > > christoph@linux-2.6$ size kernel/irq_work.o
> > >    text	   data	    bss	    dec	    hex	filename
> > >     438	      8	      1	    447	    1bf	kernel/irq_work.o
> > >
> > > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >
> > Peter, can you please ack this one?
>
> I guess so, I don't much like the bare preempt_disable/enable there, and
> I'm wondering, aren't %fs prefixed insn slower than regular insn? Does
> it really pay to avoid this one address computation if there's multiple
> users in a function. %fs prefixes do take another byte, so it will also
> result in larger code at some point.

Prefixes are faster than explicit address calculations. A prefix allows
you to integrate the per cpu address calculation into an arithmetic
operation.

A prefix is one byte which is less that multiple arithmetic operations to
calculate an address.

I am not sure that the preempt_disable/enable is needed. They are just
there because you had a get/put_cpu there.

If the code is run from hardirq context then preempt is already disabled.
We can just drop those then.





