Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab1GPPgh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 11:36:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57467 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab1GPPgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 11:36:33 -0400
Message-ID: <4E21AFF3.20607@gmail.com>
Date: Sat, 16 Jul 2011 11:36:19 -0400
From: Shan Hai <haishan.bai@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: benh@kernel.crashing.org, paulus@samba.org, tglx@linutronix.de,
        walken@google.com, dhowells@redhat.com, cmetcalf@tilera.com,
        tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fixup write permission of TLB on powerpc e500 core
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>	 <1310725418.2586.309.camel@twins>  <4E205A63.90401@gmail.com> <1310743477.2586.358.camel@twins>
In-Reply-To: <1310743477.2586.358.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2011 11:24 AM, Peter Zijlstra wrote:
> On Fri, 2011-07-15 at 11:18 -0400, Shan Hai wrote:
>
>>>> +	vma = find_vma(mm, address);
>>> Uhm, find_vma() needs mmap_sem, and futex_atomic_cmpxchg_inatomic() is
>>> most certainly not called with that lock held.
>>>
>> My fault, that will be fixed in the V2 patch.
> But you cannot, the function isn't called _atomic_ just for kicks, its
> used while holding spinlocks.
>

Yes we can do that, _atomic_ here is just atomic for cmpxchg
implemented by the combination of 'lwarx' and 'stwcx.' instructions
as done in the spin lock implementation, so even we hold the
mmap_sem that has no impact on the _atomic_ feature of the
futex_atomic_cmpxchg_inatomic().

>>>> +	if (likely(vma)) {
>>>> +		/* only fixup present page */
>>>> +		if (follow_page(vma, address, FOLL_WRITE)) {
>>>> +			handle_mm_fault(mm, vma, address, FAULT_FLAG_WRITE);
>>> So how can this toggle your sw dirty/young tracking, that's pretty much
>>> what gup(.write=1) does too!
>>>
>> because of the kernel read only permission of the page is transparent
>> to the follow_page(),  the handle_mm_fault() is not to be activated
>> in the __get_use_pages(), so the gup(.write=1) could not help to fixup
>> the write permission.
> So why do you need the vma? Is it like I wrote earlier that you don't
> have spare PTE bits and need the vma flags to see if it may become
> writable?
>

Need vma for the reason to call handle_mm_fault(), that's all.

> gup(.write=1) not triggering this is a serious problem though, not
> something you can just paper over. I wouldn't be at all surprised to
> find there's more things broken because of that.

In my opinion another solution might be check the read only for kernel
feature of a page in the follow_page() on gup(.write=1) to avoid this
problem on all architectures.

Thanks
Shan Hai

