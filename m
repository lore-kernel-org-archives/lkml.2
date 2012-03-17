Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab2CQQVy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 12:21:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43965 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab2CQQVt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 12:21:49 -0400
MIME-Version: 1.0
In-Reply-To: <1331938267-13583-3-git-send-email-john.stultz@linaro.org>
References: <1331938267-13583-1-git-send-email-john.stultz@linaro.org>
	<1331938267-13583-3-git-send-email-john.stultz@linaro.org>
Date: Sat, 17 Mar 2012 17:21:48 +0100
Message-ID: <CAO6Zf6D4bgQrpLhT3nzwim_PFzhiB0wzH77Coj04APgHfkSMCQ@mail.gmail.com>
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

Hi John,

[ ... ]

> +/*
> + * Mark a region as volatile, allowing dirty pages to be purged
> + * under memory pressure
> + */
> +long mapping_range_volatile(struct address_space *mapping,
> +                               pgoff_t start_index, pgoff_t end_index)
> +{
> +       struct volatile_range *new;
> +       struct range_tree_node *node;
> +
> +       u64 start, end;
> +       int purged = 0;
> +       start = (u64)start_index;
> +       end = (u64)end_index;
> +
> +       new = vrange_alloc();
> +       if (!new)
> +               return -ENOMEM;
> +
> +       mutex_lock(&volatile_mutex);
> +
> +       node = range_tree_in_range_adjacent(&mapping->volatile_root,
> +                                               start, end);
> +       while (node) {
> +               struct volatile_range *vrange;
> +
> +               /* Already entirely marked volatile, so we're done */
> +               if (node->start < start && node->end > end) {
> +                       /* don't need the allocated value */
> +                       kfree(new);
> +                       goto out;
> +               }
> +
> +               /* Grab containing volatile range */
> +               vrange = container_of(node, struct volatile_range, range_node);
> +
> +               /* resize range */
> +               start = min_t(u64, start, node->start);
> +               end = max_t(u64, end, node->end);
> +               purged |= vrange->purged;
> +
> +
> +               vrange_del(vrange);
> +
> +               /* get the next possible overlap */
> +               node = range_tree_in_range(&mapping->volatile_root, start, end);

I guess range_tree_in_range_adjacent() should be used here again.
There can be 2 adjacent regions (left and right), and we'll miss one
of them with range_tree_in_range().

Also (as I had already mentioned before), I think that new ranges must
not be merged with the existing "vrange->purged == 1" ranges.
Otherwise, for some use cases, the whole idea of 'volatility' gets
broken. For example, when an application is processing a big buffer in
small consequent chunks (marking a chunk as volatile when done with
it), and the range gets 'purged' by the kernel early in this process
(when it's still small).

-- Dmitry
