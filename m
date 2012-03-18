Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab2CRJNQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 05:13:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64317 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab2CRJNK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 05:13:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAO6Zf6D4bgQrpLhT3nzwim_PFzhiB0wzH77Coj04APgHfkSMCQ@mail.gmail.com>
References: <1331938267-13583-1-git-send-email-john.stultz@linaro.org>
	<1331938267-13583-3-git-send-email-john.stultz@linaro.org>
	<CAO6Zf6D4bgQrpLhT3nzwim_PFzhiB0wzH77Coj04APgHfkSMCQ@mail.gmail.com>
Date: Sun, 18 Mar 2012 10:13:10 +0100
Message-ID: <CAO6Zf6CtufdNuS5Fk1qomQLBMM9s2qeCKCxYT4O8nHtYc4+oJA@mail.gmail.com>
Subject: Re: [PATCH 2/2] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and
 _NONVOLATILE flags
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 March 2012 17:21, Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> Hi John,
>
> [ ... ]
>
>> +/*
>> + * Mark a region as volatile, allowing dirty pages to be purged
>> + * under memory pressure
>> + */
>> +long mapping_range_volatile(struct address_space *mapping,
>> +                               pgoff_t start_index, pgoff_t end_index)
>> +{
>> +       struct volatile_range *new;
>> +       struct range_tree_node *node;
>> +
>> +       u64 start, end;
>> +       int purged = 0;
>> +       start = (u64)start_index;
>> +       end = (u64)end_index;
>> +
>> +       new = vrange_alloc();
>> +       if (!new)
>> +               return -ENOMEM;
>> +
>> +       mutex_lock(&volatile_mutex);
>> +
>> +       node = range_tree_in_range_adjacent(&mapping->volatile_root,
>> +                                               start, end);
>> +       while (node) {
>> +               struct volatile_range *vrange;
>> +
>> +               /* Already entirely marked volatile, so we're done */
>> +               if (node->start < start && node->end > end) {
>> +                       /* don't need the allocated value */
>> +                       kfree(new);
>> +                       goto out;
>> +               }
>> +
>> +               /* Grab containing volatile range */
>> +               vrange = container_of(node, struct volatile_range, range_node);
>> +
>> +               /* resize range */
>> +               start = min_t(u64, start, node->start);
>> +               end = max_t(u64, end, node->end);
>> +               purged |= vrange->purged;
>> +
>> +
>> +               vrange_del(vrange);
>> +
>> +               /* get the next possible overlap */
>> +               node = range_tree_in_range(&mapping->volatile_root, start, end);
>
> I guess range_tree_in_range_adjacent() should be used here again.
> There can be 2 adjacent regions (left and right), and we'll miss one
> of them with range_tree_in_range().
>
> Also (as I had already mentioned before), I think that new ranges must
> not be merged with the existing "vrange->purged == 1" ranges.
> Otherwise, for some use cases, the whole idea of 'volatility' gets
> broken. For example, when an application is processing a big buffer in
> small consequent chunks (marking a chunk as volatile when done with
> it), and the range gets 'purged' by the kernel early in this process
> (when it's still small).

Alternatively, we could immediately truncate purged==0 ranges
(including the one for which mapping_range_volatile() is called) when
merging them with purged==1 ranges. This would result in a more
consistent, but perhaps too aggressive behavior.

Let's consider the following use case:

[1, 10] is an existing purged==1 volatile region, and an application
declares [11, 12] as volatile.

1) current approach: [1, 12] a single purged==1 region, where [11, 12]
was not really truncated (and it could have been [11, 100]);

2) aggressive purge-it-all approach: a single [1, 12] purged==1 region.
The newly added region gets truncated even when there is no shortage
of memory at the moment of addition.

3) do-not-merge approach: [1, 10] purged==1 and [11, 12] purged==0
regions; the later is on the lru list.
it adds extra complexities though (e.g. the need to merge purged
ranges in the shrinker code).

But what's more important, do we have a model of application behavior
that is expected to be observed in, say, 90+% of cases? What patterns
are more common?

For example,

1) make_volatile [1, 10] ; ... ; make_volatile [5, 15]   //
overlapping volatile regions
2) make_volatile [1, 10] ; ... ; make_volatile [1, 15]   // explicit merge
3) make_volatile [1, 10] ; ... ; make_volatile [11, 15] // adjacent
volatile regions

I guess (2) and (3) would be more common, and (3) even more so with
independently used regions (say, by different threads). For (3), do we
really want to merge purged==0 regions when they are adjacent? What if
they are used independently? Let's consider this case:

(a) make_volatile [1, 100] ; ... ; (z) make_volatile [101, 102]

(z) region is used much more frequently by the application [
make_nonvolatile -> do-smth -> make_volatile ], and (a) is not used
often - it's volatile most of the time. If we merge both regions when
they are still purged==0, the whole [1, 102] will tend to be at the
end of the LRU list =>
- we miss an opportunity to truncate (a);
- other regions that are more frequently used than (a) get truncated.

In this light, (3) would be better off behaving as if (a) and (z) were
not adjacent, i.e. no merge...

-- Dmitry
