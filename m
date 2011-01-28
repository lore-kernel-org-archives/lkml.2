Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1A1HVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 02:21:14 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:60031 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1A1HVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 02:21:13 -0500
Date: Fri, 28 Jan 2011 15:17:31 +0800
From: Xiaowei Yang <xiaowei.yang@huawei.com>
Subject: Re: One (possible) x86 get_user_pages bug
In-reply-to: <AANLkTikhoG4fgXjD9hS9yB+BVqeF3GXtTHiQVMn0n5TS@mail.gmail.com>
To: Nick Piggin <npiggin@gmail.com>
Cc: Jan Beulich <JBeulich@novell.com>, Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, fanhenglong@huawei.com,
        Kaushik Barde <kbarde@huawei.com>, Kenneth Lee <liguozhu@huawei.com>,
        linqaingmin <linqiangmin@huawei.com>, wangzhenguo@huawei.com,
        Wu Fengguang <fengguang.wu@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        linux-kernel@vger.kernel.org
Message-id: <4D426D8B.3050708@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9)
 Gecko/20100317 Thunderbird/3.0.4
References: <4D416D9A.9010603@huawei.com>
 <4D41A651020000780002ED36@vpn.id2.novell.com>
 <AANLkTikhoG4fgXjD9hS9yB+BVqeF3GXtTHiQVMn0n5TS@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-1-28 5:24, Nick Piggin wrote:
> On Fri, Jan 28, 2011 at 3:07 AM, Jan Beulich<JBeulich@novell.com>  wrote:
>>>>> On 27.01.11 at 14:05, Xiaowei Yang<xiaowei.yang@huawei.com>  wrote:
>>> We created a scenario to reproduce the bug:
>>> ----------------------------------------------------------------
>>> // proc1/proc1.2 are 2 threads sharing one page table.
>>> // proc1 is the parent of proc2.
>>>
>>> proc1               proc2          proc1.2
>>> ...                 ...            // in gup_pte_range()
>>> ...                 ...            pte = gup_get_pte()
>>> ...                 ...            page1 = pte_page(pte)  // (1)
>>> do_wp_page(page1)   ...            ...
>>> ...                 exit_map()     ...
>>> ...                 ...            get_page(page1)        // (2)
>>> -----------------------------------------------------------------
>>>
>>> do_wp_page() and exit_map() cause page1 to be released into free list
>>> before get_page() in proc1.2 is called. The longer the delay between
>>> (1)&(2), the easier the BUG_ON shows.
>>
>> Other than responded initially, I don't this can happen outside
>> of Xen: do_wp_page() won't reach page_cache_release() when
>> gup_pte_range() is running for the same mm on another CPU,
>> since it can't get past ptep_clear_flush() (waiting for the CPU
>> in get_user_pages_fast() to re-enable interrupts).
>
> Yeah, this cannot happen on native.
>
>
>>> An experimental patch is made to prevent the PTE being modified in the
>>> middle of gup_pte_range(). The BUG_ON disappears afterward.
>>>
>>> However, from the comments embedded in gup.c, it seems deliberate to
>>> avoid the lock in the fast path. The question is: if so, how to avoid
>>> the above scenario?
>>
>> Nick, based on your doing of the initial implementation, would
>> you be able to estimate whether disabling get_user_pages_fast()
>> altogether for Xen would be performing measurably worse than
>> adding the locks (but continuing to avoid acquiring mm->mmap_sem)
>> as suggested by Xiaowei? That's of course only if the latter is correct
>> at all, of which I haven't fully convinced myself yet.
>
> You must have some way to guarantee existence of Linux page
> tables when you walk them in order to resolve a TLB refill.
>
> x86 does this with IPI and hardware fill that is atomic WRT interrupts.
> So fast gup can disable interrupts to walk page tables, I don't think it
> is fragile it is absolutely tied to the system ISA (of course that can
> change, but as Peter said, other things will have to change).
>
> Other architectures use RCU for this, so fast gup uses a lockless-
> pagecache-alike protcol for that.
>
> If Xen is not using IPIs for flush, it should use whatever locks or
> synchronization its TLB refill is using.

Thanks everyone! It's very clear now that the problem only occurs on Xen 
PV kernel which doesn't use IPI to flush TLB so lacks the implicit sync 
mechanism. For now we can disable the fast path as a temp solution until 
a better one comes up -- comparing to adding extra locks, the slow path 
may not be bad, and actually get_user_pages_fast() is not called that 
much in our environment.

However, this issue may raise another concern: could there be other 
places inside Xen PV kernel which has the same sync problem?

Thanks,
Xiaowei
