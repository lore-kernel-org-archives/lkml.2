Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab0HCIzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:55:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51974 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab0HCIzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:55:22 -0400
Message-ID: <4C57DA5D.9060700@cn.fujitsu.com>
Date: Tue, 03 Aug 2010 16:59:09 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] kvm cleanup: Introduce sibling_pte and do cleanup for
 reverse map and parent_pte
References: <4C577F45.9030208@cn.fujitsu.com> <4C57BC6D.8060306@redhat.com>
In-Reply-To: <4C57BC6D.8060306@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2010 02:51 PM, Avi Kivity wrote:
>  On 08/03/2010 05:30 AM, Lai Jiangshan wrote:
>> This patch is just a big cleanup. it reduces 220 lines of code.
>>
>> It introduces sibling_pte array for tracking identical sptes, so the
>> identical sptes can be linked as a single linked list by their
>> corresponding sibling_pte. A reverse map or a parent_pte points at
>> the head of this single linked list. So we can do cleanup for
>> reverse map and parent_pte VERY LARGELY.
>>
>> BAD:
>>    If most rmap have only one entry or most sp have only one parent,
>>    this patch may use more memory than before.
> 
> That is the case with NPT and EPT.  Each page has exactly one spte
> (except a few vga pages), and each sp has exactly one parent_pte (except
> the root pages).
> 
>> GOOD:
>>    1) Reduce a lot of code, The functions which are in hot path becomes
>>       very very simple and terrifically fast.
>>    2) rmap_next(): O(N) ->  O(1). traveling a ramp: O(N*N) ->  O(N)
> 
> The existing rmap_next() is not O(N), it's O(RMAP_EXT), which is 4.  The
> data structure was chosen over a simple linked list to avoid extra cache
> misses.
> 
>>    3) Remove the ugly interlayer: struct kvm_rmap_desc, struct
>> kvm_pte_chain
> 
> kvm_rmap_desc and kvm_pte_chain are indeed ugly, but they do save a lot
> of memory and cache misses.
> 
>>    4) We don't need to allocate any thing when we change the mappings.
>>       So we can avoid allocation when we have held kvm mmu spin lock.
>>       (this feature is very helpful in future).
>>    5) better readability.
> 
> I agree the new code is more readable.  Unfortunately it uses more
> memory and is likely to be slower.  You add a cache miss for every spte,
> while kvm_rmap_desc amortizes the cache miss among 4 sptes, and special
> cases 1 spte to have no cache misses (or extra memory requirements).
> 

You are right, please omit this patch

thanks, lai.
