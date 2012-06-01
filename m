Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964902Ab2FAURn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 16:17:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38500 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759247Ab2FAURm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 16:17:42 -0400
Message-ID: <4FC9235F.5000402@gmail.com>
Date: Fri, 01 Jun 2012 16:17:35 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Taras Glek <tgek@mozilla.com>, Mike Hommey <mh@glandium.org>,
        Jan Kara <jack@suse.cz>, kosaki.motohiro@gmail.com
Subject: Re: [PATCH 3/3] [RFC] tmpfs: Add FALLOC_FL_MARK_VOLATILE/UNMARK_VOLATILE
 handlers
References: <1338575387-26972-1-git-send-email-john.stultz@linaro.org> <1338575387-26972-4-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1338575387-26972-4-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

(6/1/12 2:29 PM), John Stultz wrote:
> This patch enables FALLOC_FL_MARK_VOLATILE/UNMARK_VOLATILE
> functionality for tmpfs making use of the volatile range
> management code.
> 
> Conceptually, FALLOC_FL_MARK_VOLATILE is like a delayed
> FALLOC_FL_PUNCH_HOLE.  This allows applications that have
> data caches that can be re-created to tell the kernel that
> some memory contains data that is useful in the future, but
> can be recreated if needed, so if the kernel needs, it can
> zap the memory without having to swap it out.
> 
> In use, applications use FALLOC_FL_MARK_VOLATILE to mark
> page ranges as volatile when they are not in use. Then later
> if they wants to reuse the data, they use
> FALLOC_FL_UNMARK_VOLATILE, which will return an error if the
> data has been purged.
> 
> This is very much influenced by the Android Ashmem interface by
> Robert Love so credits to him and the Android developers.
> In many cases the code&  logic come directly from the ashmem patch.
> The intent of this patch is to allow for ashmem-like behavior, but
> embeds the idea a little deeper into the VM code.
> 
> This is a reworked version of the fadvise volatile idea submitted
> earlier to the list. Thanks to Dave Chinner for suggesting to
> rework the idea in this fashion. Also thanks to Dmitry Adamushko
> for continued review and bug reporting, and Dave Hansen for
> help with the original design and mentoring me in the VM code.

I like this patch concept. This is cleaner than userland 
notification quirk. But I don't like you use shrinker. Because of,
after applying this patch, normal page reclaim path can still make
swap out. this is undesirable.


(snip)

> +static
> +int shmem_volatile_shrink(struct shrinker *ignored, struct shrink_control *sc)
> +{
> +	s64 nr_to_scan = sc->nr_to_scan;
> +	const gfp_t gfp_mask = sc->gfp_mask;
> +	struct address_space *mapping;
> +	loff_t start, end;
> +	int ret;
> +	s64 page_count;
> +
> +	if (nr_to_scan&&  !(gfp_mask&  __GFP_FS))
> +		return -1;
> +
> +	volatile_range_lock(&shmem_volatile_head);
> +	page_count = volatile_range_lru_size(&shmem_volatile_head);
> +	if (!nr_to_scan)
> +		goto out;
> +
> +	do {
> +		ret = volatile_ranges_get_last_used(&shmem_volatile_head,
> +							&mapping,&start,&end);

Why drop last used region? Not recently used region is better?
 


> +		if (ret) {
> +			shmem_truncate_range(mapping->host,
> +						start<<PAGE_CACHE_SHIFT,
> +						(end<<PAGE_CACHE_SHIFT)-1);
> +			nr_to_scan -= end-start;
> +			page_count -= end-start;
> +		};
> +	} while (ret&&  (nr_to_scan>  0));
> +
> +out:
> +	volatile_range_unlock(&shmem_volatile_head);
> +
> +	return page_count;
> +}
> +


