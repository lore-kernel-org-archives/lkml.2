Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab0EQGJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 02:09:00 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61319 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab0EQGI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 02:08:57 -0400
Message-ID: <4BF0DD00.6020804@oracle.com>
Date: Sun, 16 May 2010 23:06:56 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: David Miller <davem@davemloft.net>, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: lmb type features.
References: <1273804238.21352.389.camel@pasglop>	 <4BECF00D.6080800@oracle.com>	<1273825187.21352.590.camel@pasglop>	 <20100514.013012.13730149.davem@davemloft.net>	 <4BED7DFE.2090108@oracle.com> <1273876488.21352.643.camel@pasglop>	 <4BEDE1EA.8030103@oracle.com> <1274057196.21352.707.camel@pasglop>
In-Reply-To: <1274057196.21352.707.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090209.4BF0DD5F.006F:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2010 05:46 PM, Benjamin Herrenschmidt wrote:
> On Fri, 2010-05-14 at 16:51 -0700, Yinghai wrote:
> 
>  .../...
> 
>> #define LMB_ADD_MERGE (1<<0) 
>> #define LMB_ARRAY_DOUBLE (1<<1)
>>
>> so before call double_lmb_array(), should check the features to bit is set or not.
>> otherwise should emit PANIC with clear message.
>>
>> Usage:
>>
>> for range replacement,
>>
>> 1. early stage before lmb.reserved, lmb.memory is there.
>> so can not use lmb_find_base yet.
> 
> Let me make sure I understand: You mean when doing all the memory
> lmb_add() early during boot, we haven't done the various lmb_reserve()
> for all potentially reserved areas and thus cannot rely on
> double_lmb_array() doing the right thing ?

yes, 

thinking to use lmb_type to replace struct for mtrr trimming

> 
> I think this is a good point. However, a better way to do that would
> be to set the default alloc limit to 0 instead of LMB_ALLOC_ANYWHERE.
> 
> I haven't done that yet though I certainly intend to, but I'll need
> to ensure all the archs using LMB set a decent limit at some stage. You
> can in the meantime do it explicitely in x86.
> 
> Additionally, it should be possible in most cases to do all the critical
> lmb_reserve() early, before lmb_add()'s, and thus remove the problem,
> though that is indeed not the case today.

need the initial array size is big enough to use lmb_reserve() early.

in my patchset, for x86, already call lmb_reserve() early, and later all lmb_add_memory()
to fill lmb.


> 
> It would be nice to be able to extend the array for memory addition
> since that would allow us to have much smaller static arrays in the
> first place.

not on x86, we could to put them in __init with them.

hotplug mem should use resource tree instead of lmb?


> 
>> 2. for bootmem replacement, when do range set subtraction for final free range list,
>> don't want to change lmb.reserved in the middle.  callee should make sure to have big
>> enough temperately lmb_regions in lmb_type. 
> 
> Sorry, I'm not sure I grasped your explanation above. You mean when
> transitioning from LMB to the page allocator, the page freeing needs to
> be done after substracting the reserved array from the memory, and that
> substraction might cause the arrays to increase in size, thus affecting
> the reserved array ?

right. 

> 
> That could be solved by not doing the substraction and doing things a
> bit differently. You could have a single function that walks both arrays
> at the same time, and calls a callback for all memory ranges it finds
> that aren't reserved. Not -that- tricky to code.

but need to make sure lmb.reserved doesn't have overlapped eentries.

will check that later.

Thanks

Yinghai
