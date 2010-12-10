Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab0LJUHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:07:39 -0500
Received: from canuck.infradead.org ([134.117.69.58]:50390 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab0LJUHi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:07:38 -0500
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>
In-Reply-To: <alpine.DEB.2.00.1012101344570.13986@router.home>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Dec 2010 21:07:24 +0100
Message-ID: <1292011644.13513.61.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-10 at 13:51 -0600, Christoph Lameter wrote:
> On Fri, 10 Dec 2010, Peter Zijlstra wrote:
> 
> > > > gcc wont be able to do this yet (%fs/%gs selectors)
> > >
> > > The kernel can do that using the __percpu annotation.
> >
> > That's not true:
> >
> > # define __percpu
> >
> > Its a complete NOP.
> 
> The annotation serves for sparse checking. .... If you do not care about
> those checks then you can simply pass a percpu pointer in the same form as
> a regular pointer.

Its not about passing per-cpu pointers, its about passing long pointers.

When I write:

void foo(u64 *bla)
{
	*bla++;
}

DEFINE_PER_CPU(u64, plop);

void bar(void)
{
	foo(__this_cpu_ptr(plop));
}

I want gcc to emit the equivalent to:

__this_cpu_inc(plop); /* incq %fs:(%0) */

Now I guess the C type system will get in the way of this ever working,
since a long pointer would have a distinct type from a regular
pointer :/

The idea is to use 'regular' functions with the per-cpu data in a
transparent manner so as not to have to replicate all logic.

> > > > But we can provide this_cpu_write_seqcount_{begin|end}()
> > >
> > > No we cannot do hat. this_cpu ops are for per cpu data and not for locking
> > > values shared between processors. We have a mechanism for passing per cpu
> > > pointers with a corresponding annotation.
> >
> > -enoparse, its not locking anything, is a per-cpu sequence count.
> 
> seqlocks are for synchronization of objects on different processors.
> 
> Seems that you do not have that use case in mind. So a seqlock restricted
> to a single processor? If so then you wont need any of those smp write
> barriers mentioned earlier. A simple compiler barrier() is sufficient.

The seqcount is sometimes read by different CPUs, but I don't see why we
couldn't do what Eric suggested.
