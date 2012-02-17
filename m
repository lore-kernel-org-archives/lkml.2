Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab2BQDtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 22:49:43 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:43902 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab2BQDtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 22:49:42 -0500
Message-ID: <1329450573.2373.11.camel@js-netbook>
Subject: Re: [PATCH 2/2] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and
 _NONVOLATILE flags
From: John Stultz <john.stultz@linaro.org>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>
Date: Thu, 16 Feb 2012 19:49:33 -0800
In-Reply-To: <CAO6Zf6C5RfrK9x6Pq35O208zzF+0LDDAWTNUF-p4VD=FcdNY3A@mail.gmail.com>
References: <1328832993-23228-1-git-send-email-john.stultz@linaro.org>
	 <1328832993-23228-2-git-send-email-john.stultz@linaro.org>
	 <CAO6Zf6C5RfrK9x6Pq35O208zzF+0LDDAWTNUF-p4VD=FcdNY3A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021703-6148-0000-0000-000003846336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-02-12 at 15:08 +0100, Dmitry Adamushko wrote:
> On 10 February 2012 01:16, John Stultz <john.stultz@linaro.org> wrote:
> Also, I have a question about mapping_range_volatile().
[snip]
> +       new->mapping = mapping;
> +       new->range_node.start = start;
> +       new->range_node.end = end;
> +       new->purged = purged;
> 
> I'm wondering whether this 'inheritance' is always desirable.
> 
> Say,
> 
> mapping_range_volatile(mapping, X, X + 1);
> ...
> time goes by and volatile_shrink() has been called for this region.
> 
> now, a user does the following (is it considered bad user-behavior?)
> 
> mapping_range_volatile(mapping, Y = X - big_value, Z = X + big_value);
> 
> This new range will 'inherit' purged=1 from the old one and won't be
> on the lru_list. Yet, it's much bigger than the old one and so many
> pages are not really 'volatile'.

Yea, I think this is a interesting point, and we can probably be a
little smarter then what is done here. We could only coalesce ranges
that haven't been purged, for instance. Although, the coalescing of
neighboring ranges in of itself is sort of questionable, as if they were
marked volatile independently, they may be marked nonvolatile
independently as well, so merging them together mucks up the lru
ordering.

Robert/Brian: Is there strong rational for the coalescing of neighboring
ranges in ashmem?

thanks
-john


