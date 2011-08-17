Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab1HQSpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 14:45:25 -0400
Received: from mx2.parallels.com ([64.131.90.16]:38944 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177Ab1HQSpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 14:45:21 -0400
Message-ID: <4E4C0C25.3@parallels.com>
Date: Wed, 17 Aug 2011 11:44:53 -0700
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <containers@lists.linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@parallels.com>
Subject: Re: [PATCH v3 0/4] Per-container dcache limitation
References: <1313334832-1150-1-git-send-email-glommer@parallels.com> <20110817054343.GM26978@dastard>
In-Reply-To: <20110817054343.GM26978@dastard>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.191.100.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2011 10:43 PM, Dave Chinner wrote:
> On Sun, Aug 14, 2011 at 07:13:48PM +0400, Glauber Costa wrote:
>> Hello,
>>
>> This series is just like v2, except it addresses
>> Eric's comments regarding percpu variables.
>>
>> Let me know if there are further comments, and
>> I'll promply address them as well. Otherwise,
>> I feel this is ready for inclusion

Hi David,

I am not answering everything now, since I'm travelling, but let me get 
to this one:

> Just out of couriousity, one thing I've noticed about dentries is
> that in general at any given point in time most dentries are unused.
> Under the workloads I'm testing, even when I have a million cached
> dentries, I only have roughly 7,000 accounted as used.  That is, most
> of the dentries in the system are on a LRU and accounted in
> sb->s_nr_dentry_unused of their owner superblock.
>
> So rather than introduce a bunch of new infrastructure to track the
> number of dentries allocated, why not simply limit the number of
> dentries allowed on the LRU? We already track that, and the shrinker
> already operates on the LRU, so we don't really need any new
> infrastructure.
Because this only works well for cooperative workloads. And we can't 
really assume that in the virtualization world. One container can come 
up with a bogus workload - not even hard to write - that has the sole 
purpose of punishing every resource sharer of him.

That's why we're putting limits on pinnable kernel memory. Normal
workloads won't do.

>
> The limiting can be lazily - we don't need to limit the growth of
> dentries until we start to run out of memory. If the superblock
> shrinker is aware of the limits, then when it gets called by memory
> reclaim it can do all the work of reducing the number of items on
> the LRU down to the threshold at that time.

Well, this idea itself can be considered, independent of which path 
we're taking. We can, if we want, allow the dentry cache to grow 
indefinitely if we're out of memory pressure. But it kinda defies the
purpose of a hard limit...

If we allow the dcache to grow over the hard cap just because memory is 
plentiful, then when it is *not* plentiful, we might be full of pinned 
entries that we can't release - and screw up somebody else's container, 
that behaved well all the time.

>
> IOWs, the limit has no impact on performance until memory is scarce,
> at which time memory reclaim enforces the limits on LRU size and
> clean up happens automatically.
>
> This also avoids all the problems of setting a limit lower than the
> number of active dentries required for the workload (i.e. avoids
> spurious ENOMEM errors trying to allocate dentries), allows
> overcommitment when memory is plentiful (which will benefit
> performance) but it brings the caches back to defined limits when
> memory is not plentiful (which solves the problem you are having).
No, this is not really the problem we're having.
See above.

About ENOMEM, I don't really see what's wrong with them here. For a 
container, running out of his assigned kernel memory, should be exactly 
the same as running out of real physical memory. I do agree that it 
changes the feeling of the system a little bit, because it then happens 
more often. But it is still right in principle.

>
> That seems like a much better solution to me, because it doesn't
> impact the normal working of workloads in the containers and avoids
> having to work out what the correct minimum size of the cache for
> each workload is. It's much easier to work out how many extra cached
> dentries you want the container to be able to have when memory is
> scarce...
>
> What do you think?

I think that for the reasons I went through above, dcache limiting and 
LRU size capping are really not equivalent in terms of solving this problem.
