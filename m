Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab0EaS12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 14:27:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54124 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab0EaS11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 14:27:27 -0400
Date: Mon, 31 May 2010 20:27:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Milan Broz <mbroz@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       device-mapper development <dm-devel@redhat.com>,
       herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
       agk@redhat.com, ak@linux.intel.com
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
Message-ID: <20100531182724.GG10766@basil.fritz.box>
References: <20100531160425.GA20344@basil.fritz.box> <4C03F04D.4040200@redhat.com> <20100531174225.GE10766@basil.fritz.box> <4C03FB8E.1060109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C03FB8E.1060109@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 08:10:22PM +0200, Milan Broz wrote:
> On 05/31/2010 07:42 PM, Andi Kleen wrote:
> > On Mon, May 31, 2010 at 07:22:21PM +0200, Milan Broz wrote:
> >> On 05/31/2010 06:04 PM, Andi Kleen wrote:
> >>> DM-CRYPT: Scale to multiple CPUs
> >>>
> >>> Currently dm-crypt does all encryption work per dmcrypt mapping in a
> >>> single workqueue. This does not scale well when multiple CPUs
> >>> are submitting IO at a high rate. The single CPU running the single
> >>> thread cannot keep up with the encryption and encrypted IO performance
> >>> tanks.
> >>
> >> This is true only if encryption run on the CPU synchronously.
> > 
> > That's the common case isn't it?
> 
> Maybe now, but I think not in the near future.

Why? 

> >> 1) How this scale together with asynchronous
> >> crypto which run in parallel in crypto API layer (and have limited
> >> resources)? (AES-NI for example)
> > 
> > AES-NI is not asynchronous and doesn't have limited resources.
> 
> AES-NI used asynchronous crypto interface, was using asynchronous
> crypto API cryptd daemon IIRC. So this changed?

AFAIK all ciphers use the asynchronous interface,  but that 
doesn't mean they are actually asynchronous. AES-NI certainly
does not require running in a special thread. The only
thing it doesn't support is running from interrupt context.

> 
> >> 2) Per volume threads and mempools were added to solve low memory
> >> problems (exhausted mempools), isn't now possible deadlock here again?
> > 
> > Increasing the number of parallel submitters does not increase deadlocks
> > with mempool as long as they don't nest.  They would just
> > block each other, but eventually make progress as one finishes. 
> 
> I mean if they nest of course, sorry for confusion.

No change to that, it's the same as it always worked.

Anyways, Right now you would need to nest more than 16 times I think
to exhaust the mempool (or 8, but the pages are less critical I think)

For me that seems like a "don't do that if hurts" situation.

> 
> > This only matters when you're low on memory anyways, 
> > in the common case with enough memory there is full parallelism.
> 
> If it breaks not-so-common case, it is wrong approach:-)
> It must not deadlock. We had already similar design before and it
> was broken, that's why I am asking.

There's no new deadlock possibility to my knowledge.


> 
> >> (Like one CPU, many dm-crypt volumes - thread waiting for allocating
> >> page from exhausted mempool, blocking another request (another volume)
> > 
> > As long as they are not dependent that is not a deadlock
> > (and they are not) 
> 
> Please try truecrupt, select AES-Twofish-Serpent mode and see how it is
> nested... This is common case. (not that I like it :-)

Nesting a few times is fine, you should just not nest
more times than your mempool is big.

Again also this is a red herring here because my patch
does not change the situation.

I guess if there was a way to determine the global nesting
one could also increase the mempool allocation to match it.
I don't think it has anything to do with my patch though.

And if you will ever have any user who wants to nest more than 8/16
times is also quite doubtful.

> 
> >> Anyway, I still think that proper solution to this problem is run
> >> parallel requests in cryptoAPI using async crypt interface,
> >> IOW paralelize this on cryptoAPI layer which know best which resources
> >> it can use for crypto work.
> > 
> > I discussed this with Herbert before and he suggested that it's better
> > done in the submitter for the common case. There is a parallel crypt
> > manager now (pcrypt), but it has more overhead than simply doing it directly.
> 
> Yes, I meant pcrypt extension.
> Asynchronous crypto has big overhead, but that can be optimized eventually, no?
Maybe it can be optimized, but for a fast CPU it will never
be as fast as just doing it directly.

Communication between CPUs is slow.

> 
> So we now run parallel crypt over parallel crypt in some case...
> This is not good. And dm-crypt have no way to check if crypto
> request will be processed synchronously or asynchronously.

It doesn't need to know.

Also even if there's asynchronous crypto it's more efficient
to submit to it from multiple CPUs than to funnel everything
through a single CPU bottleneck.


> > It can be still used when it is instantiated, but it's likely
> > only a win with very slow CPUs. For the case of reasonably fast
> > CPUs all that matters is that it scales.
> 
> I know this is problem and parallel processing is needed here,
> but it must not cause problems or slow  down that AES-NI case,
> most of new cpu will support these extensions...

My patch is the best way to make use of AES-NI.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
