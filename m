Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab1IAWmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 18:42:12 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34340 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202Ab1IAWmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 18:42:09 -0400
Message-ID: <4E600A3B.2090609@linux.vnet.ibm.com>
Date: Thu, 01 Sep 2011 17:42:03 -0500
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

Ok, so I was able to get some numbers and I said I'd send them out
today, so... here they are. 32-bit system.  I create a cgroup with a 
memory.limit_in_bytes of 256MB.  Then I ran a program that allocates
512MB, one 4k page a time.  The pages can be filled with zeros
or text depending on the command arguments.  The text is english
text that has an average compression ratio, using lzo1x, of 75%
with little deviation.  zv_max_mean_zsize and zv_max_zsize are
both set to 3584 (7 * PAGE_SIZE / 8).

xvmalloc
		curr_pages	zv_page_count	effective compression
zero filled	65859		1269		1.93%
text (75%)	65925		65892		99.95%

xcfmalloc (descriptors are 24 bytes, 170 per 4k page)
		curr_pages	zv_page_count	zv_desc_count	effective compression
zero filled	65845		2068		65858		3.72% (+1.79)
text (75%)	65965		50848		114980		78.11% (-21.84)

This shows that xvmalloc is 1.79 points better on zero filled pages.
This is because xcfmalloc has higher internal fragmentation because
the block sizes aren't as granular as xvmalloc.  This contributes
to 1.21 points of the delta. xcfmalloc also has block descriptors,
which contributes to the remaining 0.58 points.

It also shows that xcfmalloc is 21.84 points better on text filled 
pages. This is because of xcfmalloc allocations can span different
pages which greatly reduces external fragmentation compared to xvmalloc.

I did some quick tests with "time" using the same program and the
timings are very close (3 run average, little deviation):

xvmalloc:
zero filled	0m0.852s
text (75%)	0m14.415s

xcfmalloc:
zero filled	0m0.870s
text (75%)	0m15.089s

I suspect that the small decrease in throughput is due to the
extra memcpy in xcfmalloc.  However, these timing, more than 
anything, demonstrate that the throughput is GREATLY effected
by the compressibility of the data.

In all cases, all swapped pages where captured by frontswap with
no put failures.

> (Hopefully Nitin will have a chance to comment, since he
> has much more expertise in compression than I do.)
> 
> Thanks,
> Dan

