Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab2BLMyg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 07:54:36 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45424 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab2BLMyf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 07:54:35 -0500
MIME-Version: 1.0
In-Reply-To: <CAO6Zf6B6nGqsz5zpT3ixbO-+JWxMsScABasnwo-CVHuMKPqpLQ@mail.gmail.com>
References: <1328832993-23228-1-git-send-email-john.stultz@linaro.org>
	<1328832993-23228-2-git-send-email-john.stultz@linaro.org>
	<CAO6Zf6B6nGqsz5zpT3ixbO-+JWxMsScABasnwo-CVHuMKPqpLQ@mail.gmail.com>
Date: Sun, 12 Feb 2012 13:54:35 +0100
Message-ID: <CAO6Zf6D11ZiZtNs8ksRAGeNBGwb4QLXu8_F___mYAeNtNvKapw@mail.gmail.com>
Subject: Fwd: [PATCH 2/2] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and
 _NONVOLATILE flags
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ resent to lkml in 'plain-text' format ]

On 10 February 2012 01:16, John Stultz <john.stultz@linaro.org> wrote:

[ ... ]

> --- /dev/null
> +++ b/mm/volatile.c
> @@ -0,0 +1,314 @@
> +/* mm/volatile.c
> + *
> [ ... ]
>
> +
> +#define range_on_lru(range) (!(range)->purged)
> +
> +
> +static inline void volatile_range_shrink(struct volatile_range *range,
> +                               pgoff_t start_index, pgoff_t end_index)
> +{
> +       size_t pre = range_size(range);
> +
> +       range->range_node.start = start_index;
> +       range->range_node.end = end_index;
> +


I guess, here we get a whole range of races with volatile_shrink(),
which may see inconsistent (in-the-middle-of-update) ranges (e.g.
.start and .end).


>
> +       if (range_on_lru(range)) {


here volatile_shrink() runs and sets range->purge to 1, then calls
__lru_del() => lru_count gets updated.

>
> +               mutex_lock(&volatile_lru_mutex);
> +               lru_count -= pre - range_size(range);
> +               mutex_unlock(&volatile_lru_mutex);


and then lru_count gets updated once more - for the same 'range' object.


>
> +       }
> +}


>
> [ ... ]


>
>
> +static int volatile_shrink(struct shrinker *ignored, struct shrink_control *sc)
> +{
> +       struct volatile_range *range, *next;
> +       unsigned long nr_to_scan = sc->nr_to_scan;
> +       const gfp_t gfp_mask = sc->gfp_mask;
> +
> +       /* We might recurse into filesystem code, so bail out if necessary */
> +       if (nr_to_scan && !(gfp_mask & __GFP_FS))
> +               return -1;
> +       if (!nr_to_scan)
> +               return lru_count;


So it's u64 -> int here, which is possibly 32 bits and signed. Can't
it lead to inconsistent results on 32bit platforms?

>
> +
> +       mutex_lock(&volatile_lru_mutex);
> +       list_for_each_entry_safe(range, next, &volatile_lru_list, lru) {
> +               struct inode *inode = range->mapping->host;
> +               loff_t start, end;
> +
> +
> +               start = range->range_node.start * PAGE_SIZE;
> +               end = (range->range_node.end + 1) * PAGE_SIZE - 1;


PAGE_CACHE_SHIFT was used in fadvise() to calculate .start and .end
indexes, and here we use PAGE_SIZE to get back to 'normal' addresses.
Isn't it inconsistent at the very least?

>
> +
> +               /*
> +                * XXX - calling vmtruncate_range from a shrinker causes
> +                * lockdep warnings. Revisit this!
> +                */
> +               vmtruncate_range(inode, start, end);
> +               range->purged = 1;
> +               __lru_del(range);
> +
> +               nr_to_scan -= range_size(range);


hmm, unsigned long -= u64

>
> +               if (nr_to_scan <= 0)


nr_to_scan is "unsigned long" :-))

[ ... ]

> +arch_initcall(volatile_init);
> --
> 1.7.3.2.146.gca209
>

--

-- Dmitry
