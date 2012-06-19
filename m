Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab2FSWC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 18:02:29 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:10185 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab2FSWC2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 18:02:28 -0400
From: "Pearson, Greg" <greg.pearson@hp.com>
To: Tejun Heo <tj@kernel.org>
CC: "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "shangw@linux.vnet.ibm.com" <shangw@linux.vnet.ibm.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] mm/memblock: fix overlapping allocation when
 doubling reserved array
Thread-Topic: [PATCH v4] mm/memblock: fix overlapping allocation when
 doubling reserved array
Thread-Index: AQHNTazT7gA1rM+IWEu4nQq9TARp25cCKuuAgAAHkoA=
Date: Tue, 19 Jun 2012 22:00:22 +0000
Message-ID: <4FE0F675.3050201@hp.com>
References: <1340063278-31601-1-git-send-email-greg.pearson@hp.com>
 <20120619213315.GL32733@google.com>
In-Reply-To: <20120619213315.GL32733@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120618
 Thunderbird/14.0
x-originating-ip: [16.210.48.13]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <8613882F5EF552468CE6D260E66434F3@Compaq.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 03:33 PM, Tejun Heo wrote:
> On Mon, Jun 18, 2012 at 05:47:58PM -0600, Greg Pearson wrote:
>> The __alloc_memory_core_early() routine will ask memblock for a range
>> of memory then try to reserve it. If the reserved region array lacks
>> space for the new range, memblock_double_array() is called to allocate
>> more space for the array. If memblock is used to allocate memory for
>> the new array it can end up using a range that overlaps with the range
>> originally allocated in __alloc_memory_core_early(), leading to possible
>> data corruption.
>>
>> With this patch memblock_double_array() now calls memblock_find_in_range()
>> with a narrowed candidate range (in cases where the reserved.regions array
>> is being doubled) so any memory allocated will not overlap with the original
>> range that was being reserved. The range is narrowed by passing in the
>> starting address and size of the previously allocated range. Then the
>> range above the ending address is searched and if a candidate is not
>> found, the range below the starting address is searched.
>>
>> Changes from v1 to v2 (based on comments from Yinghai Lu):
>> - use obase instead of base in memblock_add_region() for excluding start address
>> - pass in both the starting and ending address of the exclude range to
>>    memblock_double_array()
>> - have memblock_double_array() search above the exclude ending address
>>    and below the exclude starting address for a free range
>>
>> Changes from v2 to v3 (based on comments from Yinghai Lu):
>> - pass in exclude_start and exclude_size to memblock_double_array()
>> - only exclude a range if doubling the reserved.regions array
>> - make sure narrowed range passed to memblock_find_in_range() is accessible
>> - to make the code less confusing, change memblock_isolate_range() to
>>    pass in exclude_start and exclude_size
>> - remove unneeded comment in memblock_add_region() between while and
>>    one line loop body
>>
>> Changes from v3 to v4 (based on comments from Tejun Heo):
>> - change parameter names passed to memblock_double_array() so they
>>    are not misleading and better signify the reason why the array is
>>    being doubled
>> - add function comment block to memblock_double_arry() to ensure
>>    the details of the possible overlap are explained
>>
>> Signed-off-by: Greg Pearson <greg.pearson@hp.com>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Acked-by: Tejun Heo <tj@kernel.org>
>
> The SOB tag from Yinghai is a bit weird tho.  SOB indicates the chain
> of custody for the patch, so the above SOBs indicate that the patch is
> originally from Greg and then routed (rolled into series or branch) by
> Yinghai which isn't the case here.  I suppose it's either Reviewed-by:
> or Acked-by:?
>
> Thanks.
>

Tejun,

I wasn't quite sure what to do about that at first either, I read 
"Documentation/SubmittingPatches" and it says:

"The Signed-off-by: tag indicates that the signer was involved in the
development of the patch, or that he/she was in the patch's delivery path."

Since Yinghai contributed some code that is in the current version of 
the patch I thought the "Signed-off-by" tag would be ok, but if 
something else is more appropriate I have no problem re-cutting the 
patch to make the chain of custody more clear.

Thanks

--
Greg
