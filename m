Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab2CTATl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 20:19:41 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33805 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932169Ab2CTATk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 20:19:40 -0400
Message-ID: <4F67CCDB.1040003@linaro.org>
Date: Mon, 19 Mar 2012 17:18:35 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and _NONVOLATILE
 flags
References: <1331938267-13583-1-git-send-email-john.stultz@linaro.org> <1331938267-13583-3-git-send-email-john.stultz@linaro.org> <CAO6Zf6D4bgQrpLhT3nzwim_PFzhiB0wzH77Coj04APgHfkSMCQ@mail.gmail.com>
In-Reply-To: <CAO6Zf6D4bgQrpLhT3nzwim_PFzhiB0wzH77Coj04APgHfkSMCQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032000-3534-0000-0000-000006BDE708
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2012 09:21 AM, Dmitry Adamushko wrote:
> Hi John,
>
> [ ... ]
>
>> +/*
>> + * Mark a region as volatile, allowing dirty pages to be purged
>> + * under memory pressure
>> + */
>> +long mapping_range_volatile(struct address_space *mapping,
>> +                               pgoff_t start_index, pgoff_t end_index)
>> +{
>> +       struct volatile_range *new;
>> +       struct range_tree_node *node;
>> +
>> +       u64 start, end;
>> +       int purged = 0;
>> +       start = (u64)start_index;
>> +       end = (u64)end_index;
>> +
>> +       new = vrange_alloc();
>> +       if (!new)
>> +               return -ENOMEM;
>> +
>> +       mutex_lock(&volatile_mutex);
>> +
>> +       node = range_tree_in_range_adjacent(&mapping->volatile_root,
>> +                                               start, end);
>> +       while (node) {
>> +               struct volatile_range *vrange;
>> +
>> +               /* Already entirely marked volatile, so we're done */
>> +               if (node->start<  start&&  node->end>  end) {
>> +                       /* don't need the allocated value */
>> +                       kfree(new);
>> +                       goto out;
>> +               }
>> +
>> +               /* Grab containing volatile range */
>> +               vrange = container_of(node, struct volatile_range, range_node);
>> +
>> +               /* resize range */
>> +               start = min_t(u64, start, node->start);
>> +               end = max_t(u64, end, node->end);
>> +               purged |= vrange->purged;
>> +
>> +
>> +               vrange_del(vrange);
>> +
>> +               /* get the next possible overlap */
>> +               node = range_tree_in_range(&mapping->volatile_root, start, end);
> I guess range_tree_in_range_adjacent() should be used here again.
> There can be 2 adjacent regions (left and right), and we'll miss one
> of them with range_tree_in_range().
Good catch, thank you!

> Also (as I had already mentioned before), I think that new ranges must
> not be merged with the existing "vrange->purged == 1" ranges.
> Otherwise, for some use cases, the whole idea of 'volatility' gets
> broken. For example, when an application is processing a big buffer in
> small consequent chunks (marking a chunk as volatile when done with
> it), and the range gets 'purged' by the kernel early in this process
> (when it's still small).
>
I agree that this seems like a much more intelligent way coalesce 
regions.   I hadn't yet implemented it, as I was hoping for some comment 
from the Android folks if there was a specific use for the design they 
selected for ashmem, but I suspect there isn't.

I'll go ahead and integrate this for the next revision.

Thanks again for the feedback!
-john

