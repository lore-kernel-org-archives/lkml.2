Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab2DXTvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 15:51:06 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49919 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757121Ab2DXTvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 15:51:04 -0400
Message-ID: <4F97041D.1050304@linaro.org>
Date: Tue, 24 Apr 2012 12:50:53 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] fadvise: Add _VOLATILE,_ISVOLATILE, and _NONVOLATILE
 flags
References: <1335289787-11089-1-git-send-email-john.stultz@linaro.org> <1335289787-11089-3-git-send-email-john.stultz@linaro.org> <1335295211.28150.221.camel@twins>
In-Reply-To: <1335295211.28150.221.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042419-9360-0000-0000-000005B6E77F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 12:20 PM, Peter Zijlstra wrote:
> On Tue, 2012-04-24 at 10:49 -0700, John Stultz wrote:
>> +/*
>> + * Purges volatile ranges when under memory pressure
>> + */
>> +static int volatile_shrink(struct shrinker *ignored, struct shrink_control *sc)
>> +{
> Hmm, I would have expected regular page reclaim to know about this
> instead of using a shrinker interface. Is this done specifically to
> avoid growing small holes in all ranges and instead dump entire ranges
> thereby keeping other ranges usable?
>
So yes. We don't want to have single pages purged from the ranges.  My 
first attempt used the standard writeout method to do the purging. 
However, since the ranges in their entirety should be purged at once 
(since if any single page is purged, the entire range must be 
reconstructed), keeping track of the least-recently-unpinned range is 
more useful then the least-recently-used page.

Now, Dave Chinner suggested using tags to mark pages as part of a 
volatile range, as well as tracking their purged status, then iterating 
over adjacent pages on writeout to also purge the entire range, which 
could be done, but seemed more costly to iterate over each page updating 
the tags when marking or unmarking a range as volatile.  This suggestion 
was also (as I understood) mainly to address the memory overhead of 
early implementation adding a pointer to each address_space structure. 
That issue was resolved by using the hash table for address_space -> 
range_tree mappings.

thanks
-john

