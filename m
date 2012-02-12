Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab2BLOIa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 09:08:30 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36503 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab2BLOI3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 09:08:29 -0500
MIME-Version: 1.0
In-Reply-To: <1328832993-23228-2-git-send-email-john.stultz@linaro.org>
References: <1328832993-23228-1-git-send-email-john.stultz@linaro.org>
	<1328832993-23228-2-git-send-email-john.stultz@linaro.org>
Date: Sun, 12 Feb 2012 15:08:28 +0100
Message-ID: <CAO6Zf6C5RfrK9x6Pq35O208zzF+0LDDAWTNUF-p4VD=FcdNY3A@mail.gmail.com>
Subject: Re: [PATCH 2/2] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and
 _NONVOLATILE flags
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 February 2012 01:16, John Stultz <john.stultz@linaro.org> wrote:

[ ... ]

> +/*
> + * Mark a region as nonvolatile, returns 1 if any pages in the region
> + * were purged.
> + */
> +long mapping_range_nonvolatile(struct address_space *mapping,
> +                               pgoff_t start_index, pgoff_t end_index)
> +{
> +       struct volatile_range *new;
> +       struct range_tree_node *node;
> +       int ret  = 0;
> +       u64 start, end;
> +       start = (u64)start_index;
> +       end = (u64)end_index;
> +
> +       mutex_lock(&mapping->vlist_mutex);
> +       node = range_tree_in_range(mapping->volatile_root, start, end);
> +       while (node) {
> +               struct volatile_range *vrange;
> +               vrange = container_of(node, struct volatile_range, range_node);
> +
> +               ret |= vrange->purged;

again, racing with volatile_shrink() here, so we can return a stale state.

> +
> +               if (start <= node->start && end >= node->end) {
> +                       vrange_del(vrange);
> +               } else if (node->start >= start) {
> +                       volatile_range_shrink(vrange, end+1, node->end);
> +               } else if (node->end <= end) {
> +                       volatile_range_shrink(vrange, node->start, start-1);
> +               } else {
> +                       /* create new node */
> +                       new = vrange_alloc(); /* XXX ENOMEM HERE? */
> +
> +                       new->mapping = mapping;
> +                       new->range_node.start = end + 1;
> +                       new->range_node.end = node->end;

new->purged = vrange->purged ?

> +                       volatile_range_shrink(vrange, node->start, start-1);
> +                       mapping->volatile_root =
> +                               range_tree_add(mapping->volatile_root,
> +                                               &new->range_node);
> +                       if (range_on_lru(new))
> +                               lru_add(new);
> +                       break;
> +               }
> +               node = range_tree_in_range(mapping->volatile_root, start, end);
> +       }
> +       mutex_unlock(&mapping->vlist_mutex);
> +
> +       return ret;
> +}
> +

Also, I have a question about mapping_range_volatile().

+long mapping_range_volatile(struct address_space *mapping,
+                               pgoff_t start_index, pgoff_t end_index)
+{
+       struct volatile_range *new;
+       struct range_tree_node *node;
+
+       u64 start, end;
+       int purged = 0;
+       start = (u64)start_index;
+       end = (u64)end_index;
+
+       new = vrange_alloc();
+       if (!new)
+               return -ENOMEM;
+
+       mutex_lock(&mapping->vlist_mutex);
+
+       node = range_tree_in_range_adjacent(mapping->volatile_root, start, end);
+       while (node) {
+               struct volatile_range *vrange;
+
+               /* Already entirely marked volatile, so we're done */
+               if (node->start < start && node->end > end) {
+                       /* don't need the allocated value */
+                       kfree(new);
+                       return 0;
+               }
+
+               /* Grab containing volatile range */
+               vrange = container_of(node, struct volatile_range, range_node);
+
+               /* resize range */
+               start = min_t(u64, start, node->start);
+               end = max_t(u64, end, node->end);
+               purged |= vrange->purged;
+
+               vrange_del(vrange);
+
+               /* get the next possible overlap */
+               node = range_tree_in_range(mapping->volatile_root, start, end);
+       }
+
+       new->mapping = mapping;
+       new->range_node.start = start;
+       new->range_node.end = end;
+       new->purged = purged;

I'm wondering whether this 'inheritance' is always desirable.

Say,

mapping_range_volatile(mapping, X, X + 1);
...
time goes by and volatile_shrink() has been called for this region.

now, a user does the following (is it considered bad user-behavior?)

mapping_range_volatile(mapping, Y = X - big_value, Z = X + big_value);

This new range will 'inherit' purged=1 from the old one and won't be
on the lru_list. Yet, it's much bigger than the old one and so many
pages are not really 'volatile'.


-- Dmitry
