Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab0ERLTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 07:19:43 -0400
Received: from smtp.nokia.com ([192.100.122.230]:32327 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab0ERLTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 07:19:41 -0400
Date: Tue, 18 May 2010 14:18:23 +0300
From: Imre Deak <imre.deak@nokia.com>
To: ext Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] idr: fix backtrack logic in idr_remove_all
Message-ID: <20100518111823.GB5261@localhost>
References: <319c869d40252c570a288166665635295d09108a.1273664539.git.imre.deak@nokia.com> <4BF26AD9.5070601@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF26AD9.5070601@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 18 May 2010 11:18:27.0274 (UTC) FILETIME=[D672D2A0:01CAF67B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 12:24:25PM +0200, ext Tejun Heo wrote:
> Hello,
> 
> On 05/12/2010 01:47 PM, imre.deak@nokia.com wrote:
> > The fix changes how we determine the number of levels to step back.
> > Instead of deducting this merely from the msb of the current ID, we
> > should really check if advancing the ID causes an overflow to a bit
> > position corresponding to a given layer. In the above example overflow
> > from bit 0 to bit 1 should mean stepping back 1 level. Overflow from
> > bit 1 to bit 2 should mean stepping back 2 level and so on.
> > 
> > The fix was tested with elements up to 1 << 20, which corresponds to
> > 4 layers on 32 bit systems.
> > 
> > Signed-off-by: Imre Deak <imre.deak@nokia.com>
> > ---
> >  lib/idr.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/lib/idr.c b/lib/idr.c
> > index 9042a56..931d9d0 100644
> > --- a/lib/idr.c
> > +++ b/lib/idr.c
> > @@ -445,6 +445,7 @@ EXPORT_SYMBOL(idr_remove);
> >  void idr_remove_all(struct idr *idp)
> >  {
> >  	int n, id, max;
> > +	int bt_mask;
> >  	struct idr_layer *p;
> >  	struct idr_layer *pa[MAX_LEVEL];
> >  	struct idr_layer **paa = &pa[0];
> > @@ -462,8 +463,9 @@ void idr_remove_all(struct idr *idp)
> >  			p = p->ary[(id >> n) & IDR_MASK];
> >  		}
> >  
> > +		bt_mask = id;
> >  		id += 1 << n;
> > -		while (n < fls(id)) {
> > +		while (n < fls(id & ~bt_mask)) {
> 
> Shouldn't this be id ^ bt_mask?  The above only detects 1 -> 0
> transitions not the other way around.

It works according to the following with n=1:

id            id+2            fls((id+2) & ~id)
0             2               2
2             4               3
4             6               2
6             8               4
8             10              2
10            12              3
12            14              2

I think this should work.

> I don't think it will free all the layers in the middle.  Have you counted
> the number of frees match the number of allocations?

Not that, but I checked with kmemleak for 1 << 20 entries. I haven't got
any leaks.

--Imre

