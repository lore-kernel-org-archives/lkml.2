Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab0HSUnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 16:43:06 -0400
Received: from relay2.sgi.com ([192.48.179.30]:36370 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752331Ab0HSUnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 16:43:04 -0400
Date: Thu, 19 Aug 2010 15:42:56 -0500
From: Robin Holt <holt@sgi.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Stable Maintainers <stable@kernel.org>
Subject: Re: [Patch] numa:x86_64: Cacheline aliasing makes
 for_each_populated_zone extremely expensive -V2.
Message-ID: <20100819204256.GH3043@sgi.com>
References: <20100818165653.GX3043@sgi.com>
 <20100818183024.GZ3043@sgi.com>
 <20100819173013.GG19773@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100819173013.GG19773@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I hope my tone in this email comes across as measured as I feel.  I am
not completely confident I have not missed some thing which may have
had an effect, but I can not see what that would be.  I believe I am
correct, but am willing to be shown to be wrong.

On Thu, Aug 19, 2010 at 07:30:13PM +0200, Roedel, Joerg wrote:
> On Wed, Aug 18, 2010 at 02:30:24PM -0400, Robin Holt wrote:
> > When I investigated, I noticed that all the zone_data[] structures are
> > allocated precisely at the beginning of the individual node's physical
> > memory.  By simply staggering based upon nodeid, I reduced the average
> > down to 0.0006% of every second.
> 
> Interesting. Have you measured cache misses for both cases?

Not directly.  The change made such a compelling difference and was in
such a method as to strongly suggest it was cache aliasing.

As a result of your question, I did some back of the envelope
calculations.  The shared L3 cache is 12,288 cachelines in a set, 24
ways for an 18MB cache.  The sizeof(struct zone) is 1792 bytes or 28
cache lines.  That means a zone would not overflow an entire set and
a single set, without the stride value, would hold one zone's info and
we would exhaust the L3 at 24 nodes.  With the single line stride, we
increase that to 28 nodes per set, 24 ways, or 672 nodes before we
exhaust the L3 cache.

This seems like a plausible explanation for the problem and I do not see
any benefit to further testing unless you have a concern that I have done
something significantly wrong in my calculation above or you can see some
assumption I am making which is wrong.

> > With this patch, the max value did not change.  I believe that is a
> > combination of cacheline contention updating the zone's vmstat information
> > combined with round_jiffies_common spattering unrelated cpus onto the same
> > jiffie for their next update.  I will investigate those issues seperately.
> 
> The max value probably the case where none of the data the code accesses
> is actually in the cache. Cache aliasing does not help then so I would
> not expect a change in the maximum amount here.

The only reason I look at the other possible causes is a very weak
data point I have.  My trace code that I was using to narrow down the
slowdown area within refresh_cpu_vm_stats captured a couple data points
where a single cpu had discovered a node with pages present, the scan
of the per-cpu values and the addition of those values back into the
node_data's zone took a very long time for the two values which were
being transferred in each instance.  That seems more likely to have been
seperate sockets contending for exclusive access to the same cacheline
on the node_data's zone than a cache refill issue.

I do not disagree that the time to fully refill all node_data's zone
information would take time, but I would expect that to be a very
infrequent occurrance since the round_jiffies_common() ends up scheduling
one thread on each socket to do this calculation on each tick.

> > I had no idea whether to ask stable@kernel.org to pull this back to the
> > stable releases.  My reading of the stable_kernel_rules.txt criteria is
> > only fuzzy as to whether this meets the "oh, that's not good" standard.
> > I personally think this meets that criteria, but I am unwilling to defend
> > that position too stridently.  In the end, I punted and added them to
> > the Cc list.  We will be asking both SuSE and RedHat to add this to
> > their upcoming update releases as we expect it to affect their customers.
> 
> I don't think this is stable material. It improves performance and does
> not fix a bug. But I am not the one to decide this :-)

The only reason I think it qualifies is we are talking about 0.8% of each
cpus time.  That means that on the 4096 cpu system, we are dedicating
the equivalent of 32 cpus to just vmstat_update.  That feels like it
meets the "oh, that's not good" standard to me.  Compare the relatively
minor chance for negative impact to the known positive impact and it
becomes slightly more compelling.

Thanks,
Robin
