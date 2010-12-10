Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab0LJUd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:33:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:36995 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757070Ab0LJUd0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:33:26 -0500
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>
In-Reply-To: <alpine.DEB.2.00.1012101410571.13986@router.home>
References: <20101208142814.GE9777@n2100.arm.linux.org.uk>
	 <1291851079-27061-1-git-send-email-venki@google.com>
	 <1291899120.29292.7.camel@twins>
	 <AANLkTikd3X4pLs5De-LO6=XD+JqUz3-Ku7YM8+0-oK8t@mail.gmail.com>
	 <1291917330.6803.7.camel@twins>
	 <AANLkTin+eO_jPceSOHL4e7vqd+tf0ZCMHJ-USoz8aZL1@mail.gmail.com>
	 <1291920939.6803.38.camel@twins>
	 <AANLkTim+v21RpWobdw6exEbazDJwm4JjemPVB2+3PuRJ@mail.gmail.com>
	 <1291936593.13513.3.camel@laptop>
	 <AANLkTi=_qf8NAgj2HHMP0qG-ibnH-726NzoXbxd-bS1N@mail.gmail.com>
	 <1291975704.6803.59.camel@twins>  <1291987065.6803.151.camel@twins>
	 <1291987635.6803.161.camel@twins>  <1291988866.6803.171.camel@twins>
	 <1292001500.3580.268.camel@edumazet-laptop>
	 <1292003346.13513.30.camel@laptop>
	 <1292004859.3580.387.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1012101236300.13986@router.home>
	 <1292006788.13513.43.camel@laptop>
	 <alpine.DEB.2.00.1012101344570.13986@router.home>
	 <1292011644.13513.61.camel@laptop>
	 <alpine.DEB.2.00.1012101410571.13986@router.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Dec 2010 21:32:37 +0100
Message-ID: <1292013157.13513.69.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-10 at 14:23 -0600, Christoph Lameter wrote:
> On Fri, 10 Dec 2010, Peter Zijlstra wrote:
> 
> > Its not about passing per-cpu pointers, its about passing long pointers.
> >
> > When I write:
> >
> > void foo(u64 *bla)
> > {
> > 	*bla++;
> > }
> >
> > DEFINE_PER_CPU(u64, plop);
> >
> > void bar(void)
> > {
> > 	foo(__this_cpu_ptr(plop));
> > }
> >
> > I want gcc to emit the equivalent to:
> >
> > __this_cpu_inc(plop); /* incq %fs:(%0) */
> >
> > Now I guess the C type system will get in the way of this ever working,
> > since a long pointer would have a distinct type from a regular
> > pointer :/
> >
> > The idea is to use 'regular' functions with the per-cpu data in a
> > transparent manner so as not to have to replicate all logic.
> 
> That would mean you would have to pass information in the pointer at
> runtime indicating that this particular pointer is a per cpu pointer.
> 
> Code for the Itanium arch can do that because it has per cpu virtual
> mappings. So you define a virtual area for per cpu data and then map it
> differently for each processor. If we would have a different page table
> for each processor then we could avoid using segment register and do the
> same on x86.

I don't think its a runtime issue, its a compile time issue. At compile
time the compiler can see the argument is a long pointer:
%fs:(addr,idx,size), and could propagate this into the caller.

The above example will compute the effective address by doing something
like:

  lea %fs:(addr,idx,size),%ebx

and will then do something like

  inc (%ebx)

Where it could easily have optimized this into:

  inc %fs:(addr,idx,size)

esp when foo would be inlined. If its an actual call-site you need
function overloading because a long pointer has a different signature
from a regular pointer, and that is something C doesn't do.

> > > Seems that you do not have that use case in mind. So a seqlock restricted
> > > to a single processor? If so then you wont need any of those smp write
> > > barriers mentioned earlier. A simple compiler barrier() is sufficient.
> >
> > The seqcount is sometimes read by different CPUs, but I don't see why we
> > couldn't do what Eric suggested.
> 
> But you would have to define a per cpu seqlock. Each cpu would have
> its own seqlock. Then you could have this_cpu_read_seqcount_begin and
> friends:
> 

> Then you can do
> 
> this_cpu_read_seqcount_begin(&bla)
> 

Which to me seems to be exactly what Eric proposed..

> But then this seemed to be a discussion related to ARM. ARM does not have
> optimized per cpu accesses.

Nah, there's multiple issues all nicely mangled into one thread ;-)


