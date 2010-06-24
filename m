Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab0FXQA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 12:00:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab0FXQA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 12:00:57 -0400
Date: Fri, 25 Jun 2010 02:00:52 +1000
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, John Stultz <johnstul@us.ibm.com>,
       Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 50/52] mm: implement per-zone shrinker
Message-ID: <20100624160052.GL10441@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030733.676440935@suse.de>
 <87aaqkagn9.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aaqkagn9.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 12:06:50PM +0200, Andi Kleen wrote:
> npiggin@suse.de writes:
> 
> > Allow the shrinker to do per-zone shrinking. This means it is called for
> > each zone scanned. The shrinker is now completely responsible for calculating
> > and batching (given helpers), which provides better flexibility.
> 
> Beyond the scope of this patch, but at some point this probably needs
> to be even more fine grained. With large number of cores/threads in 
> each socket a "zone" is actually shared by quite a large number 
> of CPUs now and this can cause problems.

Yes, possibly. At least it is a much better step than the big dumb
global list.

 
> > +void shrinker_add_scan(unsigned long *dst,
> > +			unsigned long scanned, unsigned long total,
> > +			unsigned long objects, unsigned int ratio)
> > +{
> > +	unsigned long long delta;
> > +
> > +	delta = (unsigned long long)scanned * objects * ratio;
> > +	do_div(delta, total + 1);
> > +	delta /= (128ULL / 4ULL);
> 
> Again I object to the magic numbers ...
> 
> > +		nr += shrink_slab(zone, 1, 1, 1, GFP_KERNEL);
> > +	if (nr >= 10)
> > +		goto again;
> 
> And here.

I don't like them either -- problem is they were inherited from the
old code (actually 128 is the fixed point scale, I do have a define
for it just forgot to use it).

I don't know where 4 came from. And 10 is just a random number someone
picked out of a hat :P

 
> Overall it seems good, but I have not read all the shrinker callback
> changes in all subsystems.

Thanks for looking over it Andi.

