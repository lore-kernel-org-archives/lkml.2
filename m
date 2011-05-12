Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab1ELNUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 09:20:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38807 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219Ab1ELNUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 09:20:06 -0400
Date: Thu, 12 May 2011 14:19:59 +0100
From: Mel Gorman <mgorman@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 0/3] Reduce impact to overall system of SLUB using
 high-order allocations
Message-ID: <20110512131924.GB8477@suse.de>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>
 <1305149960.2606.53.camel@mulgrave.site>
 <alpine.DEB.2.00.1105111527490.24003@chino.kir.corp.google.com>
 <1305153267.2606.57.camel@mulgrave.site>
 <4DCBC0E8.5020609@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4DCBC0E8.5020609@cs.helsinki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 02:13:44PM +0300, Pekka Enberg wrote:
> On 5/12/11 1:34 AM, James Bottomley wrote:
> >On Wed, 2011-05-11 at 15:28 -0700, David Rientjes wrote:
> >>On Wed, 11 May 2011, James Bottomley wrote:
> >>
> >>>OK, I confirm that I can't seem to break this one.  No hangs visible,
> >>>even when loading up the system with firefox, evolution, the usual
> >>>massive untar, X and even a distribution upgrade.
> >>>
> >>>You can add my tested-by
> >>>
> >>Your system still hangs with patches 1 and 2 only?
> >Yes, but only once in all the testing.  With patches 1 and 2 the hang is
> >much harder to reproduce, but it still seems to be present if I hit it
> >hard enough.
> 
> Patches 1-2 look reasonable to me. I'm not completely convinced of
> patch 3, though. Why are we seeing these problems now?

I'm not certain and testing so far as only being able to point to changing
from SLAB to SLUB between 2.6.37 and 2.6.38. This probably boils down to
distributions changing their allocator from slab to slub as recommended by
Kconfig and SLUB being tested heavily on desktop workloads in a variety of
settings for the first time. It's worth noting that only a few users have
been able to reproduce this. I don't see the severe hangs for example during
tests meaning it might also be down to newer hardware. What may be required
to reproduce this is many CPUs (4 on the test machines) with relatively
low memory for a 4-CPU machine (2G) and a slower disk than people might
have tested with up until now.

There are other new considerations as well that weren't much of a factor
when SLUB came along. The first reproduction case showed involved ext4 for
example which does delayed block allocation. It's possible there is some
problem wherby all the dirty pages to be written to disk need blocks to
be allocated and GFP_NOFS is not being used properly. Instead of failing
the high-order allocation, we then block instead hanging direct reclaimers
and kswapd. The filesystem people looked at this bug but didn't mention if
something like this was a possibility.
