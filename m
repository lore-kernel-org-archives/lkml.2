Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab2BQDn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 22:43:59 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:34149 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab2BQDn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 22:43:58 -0500
Message-ID: <1329450227.2373.6.camel@js-netbook>
Subject: Re: [PATCH 2/2] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and
 _NONVOLATILE flags
From: John Stultz <john.stultz@linaro.org>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>
Date: Thu, 16 Feb 2012 19:43:47 -0800
In-Reply-To: <CAO6Zf6B6nGqsz5zpT3ixbO-+JWxMsScABasnwo-CVHuMKPqpLQ@mail.gmail.com>
References: <1328832993-23228-1-git-send-email-john.stultz@linaro.org>
	 <1328832993-23228-2-git-send-email-john.stultz@linaro.org>
	 <CAO6Zf6B6nGqsz5zpT3ixbO-+JWxMsScABasnwo-CVHuMKPqpLQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021703-2398-0000-0000-0000044F2923
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-02-12 at 13:48 +0100, Dmitry Adamushko wrote:
> 
> On 10 February 2012 01:16, John Stultz <john.stultz@linaro.org> wrote:

>         +static inline void volatile_range_shrink(struct
>         volatile_range *range,
>         +                               pgoff_t start_index, pgoff_t
>         end_index)
>         +{
>         +       size_t pre = range_size(range);
>         +
>         +       range->range_node.start = start_index;
>         +       range->range_node.end = end_index;
>         +
> 
> I guess, here we get a whole range of races with volatile_shrink(),
> which may see inconsistent (in-the-middle-of-update) ranges
> (e.g. .start and .end).

We should be holding the vlist_mutex to avoid any such races. But you
also make clear that volatile_range_shrink() should really be called
volatile_range_resize(), since having two _shrink calls is terrible. My
apologies.
 

>         +       unsigned long nr_to_scan = sc->nr_to_scan;
>         +       const gfp_t gfp_mask = sc->gfp_mask;
>         +
>         +       /* We might recurse into filesystem code, so bail out
>         if necessary */
>         +       if (nr_to_scan && !(gfp_mask & __GFP_FS))
>         +               return -1;
>         +       if (!nr_to_scan)
>         +               return lru_count;
> 
> So it's u64 -> int here, which is possibly 32 bits and signed. Can't
> it lead to inconsistent results on 32bit platforms?

Good point. Thanks for pointing that out.

>         +               start = range->range_node.start * PAGE_SIZE;
>         +               end = (range->range_node.end + 1) * PAGE_SIZE
>         - 1;
> 
> PAGE_CACHE_SHIFT was used in fadvise() to calculate .start and .end
> indexes, and here we use PAGE_SIZE to get back to 'normal' addresses.
> Isn't it inconsistent at the very least?

Fair enough.

>         
>         +               nr_to_scan -= range_size(range);
> 
> hmm, unsigned long -= u64
>  
>         +               if (nr_to_scan <= 0)
> 
> nr_to_scan is "unsigned long" :-))

Good catch. 

Thanks for the feedback!
-john



