Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab0HTPDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 11:03:23 -0400
Received: from relay3.sgi.com ([192.48.152.1]:38687 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753113Ab0HTPDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 11:03:20 -0400
Date: Fri, 20 Aug 2010 10:03:19 -0500
From: Robin Holt <holt@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Stable Maintainers <stable@kernel.org>
Subject: Re: [Patch] numa:x86_64: Cacheline aliasing makes
 for_each_populated_zone extremely expensive -V2.
Message-ID: <20100820150319.GB3220@sgi.com>
References: <20100818183024.GZ3043@sgi.com>
 <4C6DB62C.9040105@zytor.com>
 <20100820135822.GA3220@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100820135822.GA3220@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 08:58:22AM -0500, Robin Holt wrote:
> On Thu, Aug 19, 2010 at 03:54:36PM -0700, H. Peter Anvin wrote:
> > On 08/18/2010 11:30 AM, Robin Holt wrote:
> > >  
> > > -	node_data[nodeid] = early_node_mem(nodeid, start, end, pgdat_size,
> > > +	/*
> > > +	 * Allocate an extra cacheline per node to reduce cacheline
> > > +	 * aliasing when scanning all node's node_data.
> > > +	 */
> > > +	cache_alias_offset = nodeid * SMP_CACHE_BYTES;
> > > +	node_data[nodeid] = cache_alias_offset +
> > > +			    early_node_mem(nodeid, start, end,
> > > +					   pgdat_size + cache_alias_offset,
> > >  					   SMP_CACHE_BYTES);
> > > -	if (node_data[nodeid] == NULL)
> > > +	if (node_data[nodeid] == (void *)cache_alias_offset)
> > >  		return;
> > >  	nodedata_phys = __pa(node_data[nodeid]);
> > >  	reserve_early(nodedata_phys, nodedata_phys + pgdat_size, "NODE_DATA");
> > 
> > I'm concerned about this, because it really seems to rely on subtleties
> > in the behavior of early_node_mem, as well as the direction of
> > find_e820_area -- which is pretty much intended to change anyway.  It's
> > the "action at a distance" effect.
> > 
> > What we really want, I think, is to push the offsetting into
> > find_early_area().  Right now we have an alignment parameter, but what
> > we need is an alignment and a color parameter (this is just a classic
> > case of cache coloring, after all) which indicates the desirable offset
> > from the alignment base.
> 
> That sounds reasonable.  Are there other examples you can think of which
> I can build upon?

I think this is more difficult than I would like.  The difficulty comes
in with determining "alignment base".  I decided to look at a machine
and see how I would manually determine color.  The first question I
ran into was "What is the color with respect to?"  Is it an L3 color, an
L2, L1?  I then decided to punt and assume it was L3 (as that is what I am
personally concerned with here).  I looked at cpu0's L3 and noticed I had
12,288 possible colors for the first line of my allocation.  I thought,
splendid, I now have both my alignment base and alignment offset.

Then, I looked around the machine.  This particular machine was not the
same as the one on which I had recorded the first statistics.  This one
has 1024 cpus (in its current configuration).  Some sockets have an 18MB
cache, others have a 24MB cache.  Likewise, some have 12,288 colors
while others have 16,384 colors.  In this case, which do I use for my
base and alignment calculation?

Lastly, If I were to use the L3 number_of_sets, I would need to hold off
on these allocation until after the init_intel() call is done which is
well after the point where we have done these allocations.  Alternatively,
I could use the cpuid() to calculate the L3 size, but that means putting
cpu specific knowledge into the e820 allocator.

In short, without the cpu information, I think we are heading back to
as much of a kludge as I had originally submitted.  We could assume
the number of sets will always be less than some large value like 16MB,
but that runs the risk of wasting a large amount of memory.

Alternatively, we could base the color value upon something very concrete.
For this particular allocation, we have an array of structures whose
elements are 1792 bytes long (28 cache lines).  If I specify an offset
of 29, it merely means the first element of my newly allocated array
is now going to collide with the first allocation's second element.
I really see no advantage to further allocating space.  The advantage
to this method is it entirely removes the processor configuration from
the question.  It allows me to keep the offset calculation from polluting
the e820 allocator as well.  Basically, the change remains localized.

Thanks,
Robin
