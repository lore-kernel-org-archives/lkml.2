Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab0JISIF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 14:08:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43805 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab0JISID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 14:08:03 -0400
Message-ID: <4CB0AF2A.2010605@kernel.org>
Date: Sat, 09 Oct 2010 11:06:34 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: Russ Anderson <rja@sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        tglx@linutronix.de, "H. Peter Anvin" <h.peter.anvin@intel.com>,
        Jack Steiner <steiner@sgi.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] x86: bootmem broken on SGI UV
References: <20101008213429.GB7223@sgi.com> <4CAFA1DB.6010802@kernel.org> <20101009125944.GA18248@sgi.com> <20101009163908.GX14068@sgi.com>
In-Reply-To: <20101009163908.GX14068@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2010 09:39 AM, Robin Holt wrote:
> On Sat, Oct 09, 2010 at 07:59:45AM -0500, Russ Anderson wrote:
>> Yes, Yinghai's patch fixes the problem.
>> Thank you very much.
> 
> Will this be included in 2.6.36?  It is needed for boot in order for UV
> systems to boot.
> 

yes, it is needed for 2.6.33 .34 .35 .36

It is too late for put in 2.6.36. Linus already had -rc7, and assume he will have final .36 this week.

Yinghai

>>
>> On Fri, Oct 08, 2010 at 03:57:31PM -0700, Yinghai Lu wrote:
>>> On 10/08/2010 02:34 PM, Russ Anderson wrote:
>>>
>>> After looking at the changelog, it turns out it is broken for a while by
>>> following commit
>>>
>>> |commit 8716273caef7f55f39fe4fc6c69c5f9f197f41f1
>>> |Author: David Rientjes <rientjes@google.com>
>>> |Date:   Fri Sep 25 15:20:04 2009 -0700
>>> |
>>> |    x86: Export srat physical topology
>>>
>>> before that commit, register_active_regions() is called SRAT memory entries.
>>>
>>> Try to use nodememblk_range[] instead of nodes[].
>>>
>>> For stable tree: from 2.6.33 to 2.3.36 need this patch by
>>> changing memblock_x86_register_active_regions() with e820_register_active_regions()
>>>
>>> Reported-by: Russ Anderson <rja@sgi.com>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>> Cc: stable@kernel.org
>>>
>>> ---
>>>  arch/x86/mm/srat_64.c |    8 +++++---
>>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>>
>>> Index: linux-2.6/arch/x86/mm/srat_64.c
>>> ===================================================================
>>> --- linux-2.6.orig/arch/x86/mm/srat_64.c
>>> +++ linux-2.6/arch/x86/mm/srat_64.c
>>> @@ -421,9 +421,11 @@ int __init acpi_scan_nodes(unsigned long
>>>  		return -1;
>>>  	}
>>>  
>>> -	for_each_node_mask(i, nodes_parsed)
>>> -		memblock_x86_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
>>> -						nodes[i].end >> PAGE_SHIFT);
>>> +	for (i = 0; i < num_node_memblks; i++)
>>> +		memblock_x86_register_active_regions(memblk_nodeid[i],
>>> +						node_memblk_range[i].start >> PAGE_SHIFT,
>>> +						node_memblk_range[i].end >> PAGE_SHIFT);
>>> +
>>>  	/* for out of order entries in SRAT */
>>>  	sort_node_map();
>>>  	if (!nodes_cover_memory(nodes)) {
>>
>> -- 
>> Russ Anderson, OS RAS/Partitioning Project Lead  
>> SGI - Silicon Graphics Inc          rja@sgi.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

