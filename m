Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab1IAQdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 12:33:43 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:60271 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959Ab1IAQdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 12:33:42 -0400
Message-ID: <4E5FB3CF.3020703@linux.vnet.ibm.com>
Date: Thu, 01 Sep 2011 11:33:19 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: gregkh@suse.de, devel@driverdev.osuosl.org, ngupta@vflare.org,
        cascardo@holoscopio.com, rdunlap@xenotime.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] staging: zcache: xcfmalloc support
References: <1314801641-15059-1-git-send-email-sjenning@linux.vnet.ibm.com> <6e0e7950-0c91-4bb3-929b-3853fa95e63d@default 4E5EB066.6020007@linux.vnet.ibm.com> <36dad993-ea60-43f4-89f0-77831befd483@default>
In-Reply-To: <36dad993-ea60-43f4-89f0-77831befd483@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11090116-7282-0000-0000-0000010D90BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2011 10:17 AM, Dan Magenheimer wrote:
>>> Do you have any data comparing xcfmalloc vs xvmalloc for
>>> compression ratio and/or performance (cycles to compress
>>> or decompress different pages) on a wide(r) range of data?
>>> Assuming xcfmalloc isn't "always better", maybe it would
>>> be best to allow the algorithm to be selectable?  (And
>>> then we would also need to decide the default.)
>>>
>>
>> I can get you some results comparing the two tomorrow.
>>
>> You have to make the distinction between the
>> "compression ratio" and the "effective compression".
>> The compression ratio is the same since the compression
>> algorithm, LZO, was changed.  The effective compression,
> 
> changed -> NOT changed, correct? LZO is used in both?
> I had forgotten that, so the only issue might be the
> overhead.
> 

Yes, LZO is NOT changed. Typo on my part.

>> the ratio of stored compressed pages to allocator pool
>> pages, is different between the two, especially for
>> allocation sets > PAGE_SIZE/2.
>  
>> What the numbers will tell you is that for allocations sets
>> < PAGE_SIZE/2 xcfmalloc is a little worse (~2% greater
>> overhead).  But for allocation sets > PAGE_SIZE/2,
>> xcfmalloc has up to a 50% advantage over xvmalloc.
>>
>> As far as performance numbers, all I can see is that
>> the throughput is the same between the two.  I'm not
>> sure how to get, for example, and cycles delta
>> between the two.
> 
> IIRC, xvmalloc has O(1) overhead regardless of the number
> of chunks of data stored.  Some algorithms are O(N) or
> even O(N**2), i.e. might walk a potentially increasingly
> very long list of allocations/descriptors
> to find a slot, which would not be acceptable for
> zcache as, for a large data set, the overhead might
> be much worse than the cycles-to-compress.  Which is
> xcfmalloc, O(1) or O(N) or O(N**2)?

xcfmalloc is also 0(1) in that the number of freelists
at that have to be checked is constant and not increasing
with the number of allocations.  The constant hidden
in the O(1) for finding a suitable block is NUM_FREELISTS.

The performance on the block lookup could be improved by
using a freelist bitmap similar to xvmalloc.  However,
I don't think there would be a measurable change in 
performance, because this in not where the 
zcache_put_page() codepath is spending all its time.
The time eater in this codepath is the LZO compression,
as dictated by the large difference in throughput
depending on the compressibility of the page.
This is supported by the metrics I am about to send you.

> 
> (Also, since I think interrupts are still disabled,
> reading the tsc before/after should be safe to
> get the cycles delta.)
> 
>> I would be difficult to make it selectable because the
>> function signatures (and some concepts) aren't the same.
>> You can see the changes that were required in the patch
>> 2/3.
> 
> Then I definitely would like to see some review
> and discussion from Nitin.  Clearly xcfmalloc is better
> for poorly-compressible data; I would like to be confident
> that it is not "worse" for another large common set of
> data.
> 
> An even better implementation could be if both are
> active and the selection is made at runtime depending
> on the compressibility of the data, i.e. poorly-compressible
> data gets stored in xcfmalloc and other data in xvmalloc?
> Probably not worth the effort, but food for thought.
> 

In the metrics I am about to send, you'll see that xcfmalloc
only does <2% worse on zeroed pages (the worst case for xcfmalloc),
but does almost 22% better on pages that compress to 75% of their
original size.

> Thanks,
> Dan

