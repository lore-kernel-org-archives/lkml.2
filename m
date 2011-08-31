Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab1HaWGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 18:06:46 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44987 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766Ab1HaWGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 18:06:45 -0400
Message-ID: <4E5EB066.6020007@linux.vnet.ibm.com>
Date: Wed, 31 Aug 2011 17:06:30 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: gregkh@suse.de, devel@driverdev.osuosl.org, ngupta@vflare.org,
        cascardo@holoscopio.com, rdunlap@xenotime.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] staging: zcache: xcfmalloc support
References: <1314801641-15059-1-git-send-email-sjenning@linux.vnet.ibm.com> <6e0e7950-0c91-4bb3-929b-3853fa95e63d@default>
In-Reply-To: <6e0e7950-0c91-4bb3-929b-3853fa95e63d@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2011 02:46 PM, Dan Magenheimer wrote:
>> This patchset introduces a new memory allocator for persistent
>> pages for zcache.  The current allocator is xvmalloc.  xvmalloc
>> has two notable limitations:
>> * High (up to 50%) external fragmentation on allocation sets > PAGE_SIZE/2
>> * No compaction support which reduces page reclaimation
>>
>> xcfmalloc seeks to fix these issues by using scatter-gather model that
>> allows for cross-page allocations and relocatable data blocks.
>>
>> In tests, with pages that only compress to 75% of their original
>> size, xvmalloc had an effective compression (pages stored / pages used by the
>> compressed memory pool) of ~95% (~20% lost to fragmentation). Almost nothing
>> was gained by the compression in this case. xcfmalloc had an effective
>> compression of ~77% (about ~2% lost to fragmentation and metadata overhead).
> 
> Hi Seth --
> 
> Do you have any data comparing xcfmalloc vs xvmalloc for
> compression ratio and/or performance (cycles to compress
> or decompress different pages) on a wide(r) range of data?
> Assuming xcfmalloc isn't "always better", maybe it would
> be best to allow the algorithm to be selectable?  (And
> then we would also need to decide the default.)
> 

I can get you some results comparing the two tomorrow.

You have to make the distinction between the
"compression ratio" and the "effective compression".
The compression ratio is the same since the compression
algorithm, LZO, was changed.  The effective compression,
the ratio of stored compressed pages to allocator pool
pages, is different between the two, especially for
allocation sets > PAGE_SIZE/2.

What the numbers will tell you is that for allocations sets
< PAGE_SIZE/2 xcfmalloc is a little worse (~2% greater
overhead).  But for allocation sets > PAGE_SIZE/2,
xcfmalloc has up to a 50% advantage over xvmalloc.

As far as performance numbers, all I can see is that
the throughput is the same between the two.  I'm not
sure how to get, for example, and cycles delta
between the two.

I would be difficult to make it selectable because the
function signatures (and some concepts) aren't the same.
You can see the changes that were required in the patch
2/3.

> (Hopefully Nitin will have a chance to comment, since he
> has much more expertise in compression than I do.)
> 
> Thanks,
> Dan

Thanks,
Seth

