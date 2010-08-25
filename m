Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab0HYNu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 09:50:58 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:39340 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752894Ab0HYNu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 09:50:56 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: XtQTpSgVM1mdjoKAFHHevAX6jGJH3vSGqzOcSRyT9Mv8sum
 E.TrZQJwtxi9Lm.blFwR5jG2r5_3PeJKqL.ZdRadJP01cRnX1VwW4TdRdyAF
 U2AZ_EBUATROY.NavHXkZn2pc2o3D3ob1I5sK2viGAxR6IaUNTxXz287ea4D
 i7Wcy2lT.YytceJR3ROaHd7gHEK55W26cSwLjRNtZMLujLt7mVFh2t4.B0e.
 VTaLiEDkMMWJ2dfB4lV7loU0FrKf0
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 25 Aug 2010 08:50:52 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Tejun Heo <tj@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (slab
 tree related)
In-Reply-To: <4C74DB05.7000101@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.1008250846590.13026@router.home>
References: <20100824120714.8918f8de.sfr@canb.auug.org.au> <4C740450.3030000@cs.helsinki.fi> <alpine.DEB.2.00.1008241256280.4763@router.home> <4C741029.7090300@cs.helsinki.fi> <alpine.DEB.2.00.1008241352240.5388@router.home> <4C74D1D7.4080608@kernel.org>
 <4C74DB05.7000101@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010, Pekka Enberg wrote:

> On 8/25/10 11:18 AM, Tejun Heo wrote:
> > Hello,
> >
> > On 08/24/2010 08:53 PM, Christoph Lameter wrote:
> > > > [    0.000000] Kernel panic - not syncing: Cannot create slab kmem_cache
> > > > size=232 realsize=256 order=0 offset=0 flags=42000
> > >
> > > alloc per cpu result in kmalloc which fails.
> > >
> > > Tejon: Is there some way we could get a reserved per cpu area under UP
> > > instead of fallback to slab allocations during bootup?
> >
> > Eh... nasty.  Maybe we can create a alloc_percpu_early() function
> > which doesn't allow freeing of allocate memory and just redirect to
> > bootmem on UP?
>
> Yeah, I was thinking about that too.

Another solution is to allocate an order 1 (compound) page for each early
cache. Then resize the kmalloc array after everything is up. kfree() will
then redirect to the page allocator.

But this is a slab allocator specific solution.

We now have the situation that alloc_percpu can only be used on early boot
on SMP machines. A general solution would be better I think.

If the early alloc_percpu stuff would work consistently then it could also
be used to avoid the boot_pageset in the page allocator f.e.

Can we just get rid of the special UP case and just run the percpu
subsystem even for UP?

