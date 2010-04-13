Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab0DMFpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 01:45:39 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:42131 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab0DMFpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 01:45:36 -0400
Message-ID: <4BC4043A.5080404@oracle.com>
Date: Mon, 12 Apr 2010 22:42:18 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 26/39] nobootmem: use lmb.default_alloc_limit in alloc_bootmem
 path
References: <1270793048-23796-1-git-send-email-yinghai@kernel.org>	 <1270793048-23796-27-git-send-email-yinghai@kernel.org>	 <1271132589.13059.67.camel@pasglop>  <4BC3F82A.20400@oracle.com> <1271135622.13059.75.camel@pasglop>
In-Reply-To: <1271135622.13059.75.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BC404E9.0099:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 10:13 PM, Benjamin Herrenschmidt wrote:
> On Mon, 2010-04-12 at 21:50 -0700, Yinghai wrote:
>> On 04/12/2010 09:23 PM, Benjamin Herrenschmidt wrote:
>>> On Thu, 2010-04-08 at 23:03 -0700, Yinghai Lu wrote:
>>>> Generic version __lmb_find_area() is going from high to low, and for 32bit
>>>> active_region for 32bit does include high pages
>>>>
>>>> need to replace the limit with lmb.default_alloc_limit, aka get_max_mapped()
>>>>
>>>> with this patch, x86 32bit could use generic version of __lmb_find_area()
>>>
>>> So you unconditionally add access to some lmb specific data structure to
>>> generic code ? That isn't going to work very well on archs that don't
>>> use lmb.
>>
>> the whole function
>>
>> #ifdef CONFIG_HAVE_LMB
>> u64 __init find_memory_core_early(int nid, u64 size, u64 align,
>>                                         u64 goal, u64 limit)
>> {
>>         int i;
>>
>>         /* Need to go over early_node_map to find out good range for node */
>>         for_each_active_range_index_in_nid(i, nid) {
>>                 u64 addr;
>>                 u64 ei_start, ei_last;
>>
>>                 ei_last = early_node_map[i].end_pfn;
>>                 ei_last <<= PAGE_SHIFT;
>>                 ei_start = early_node_map[i].start_pfn;
>>                 ei_start <<= PAGE_SHIFT;
>>                 addr = __lmb_find_area(ei_start, ei_last,
>>                                          goal, limit, size, align);
>>
>>                 if (addr == -1ULL)
>>                         continue;
>>
>>                 return addr;
>>         }
>>
>>         return -1ULL;
>> }
>> #endif
>>
>> need to access early_node_map[], so leave the function here.
> 
> Hrm... find_memory_core_early() is a broken API anyways. Did you add
> that ? Again, you insist on pushing all over the place that crakpot
> find/reserve API instead of doing a proper allocation, and it's now
> leaking with ifdef's & all into the generic code.
> 
__alloc_memory_core_early() already include that find_memory_core_early() lines
it is merged for CONFIG_NO_BOOTMEM support.

I split it out, so lmb_find_area_node() could reuse those lines.

YH
