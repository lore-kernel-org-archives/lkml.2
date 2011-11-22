Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab1KVC6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 21:58:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791Ab1KVC6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 21:58:23 -0500
Message-ID: <4ECB104C.3040801@redhat.com>
Date: Tue, 22 Nov 2011 11:00:28 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: WANG Cong <xiyou.wangcong@gmail.com>, kexec@lists.infradead.org,
        tim@edgecast.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: fix chunk range calculation
References: <4EC47FCA.5090908@redhat.com> <CAOS58YMOuJrvGxE1VxsU=ZPTLgY60HDJoLFjTowx9ZApUQ3tTw@mail.gmail.com> <4EC491B3.705@redhat.com> <CAMMEr5k_ynqg5-7Looar2DxXTGZcMqi5Lo+jtETn9awO_bsaGg@mail.gmail.com> <4EC4B60C.3030706@redhat.com> <1321548033.12208.12.camel@boudreau> <4EC61AB6.4090808@redhat.com> <4EC61B2A.7010000@redhat.com> <20111118185535.GA27152@google.com> <4EC9AD4F.3050404@redhat.com> <20111121170146.GD15314@google.com>
In-Reply-To: <20111121170146.GD15314@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2011 01:01 AM, Tejun Heo wrote:

> Hello, Dave.
> 
> On Mon, Nov 21, 2011 at 09:45:51AM +0800, Dave Young wrote:
>> On 11/19/2011 02:55 AM, Tejun Heo wrote:
>>
>>> Percpu allocator recorded the cpus which map to the first and last
>>> units in pcpu_first/last_unit_cpu respectively and used them to
>>> determine the address range of a chunk - e.g. it assumed that the
>>> first unit has the lowest address in a chunk while the last unit has
>>> the highest address.
>>>
>>> This simply isn't true.  Groups in a chunk can have arbitrary positive
>>> or negative offsets from the previous one and there is no guarantee
>>> that the first unit occupies the lowest offset while the last one the
>>> highest.
>>>
>>> Fix it by actually comparing unit offsets to determine cpus occupying
>>> the lowest and highest offsets.  Also, rename pcu_first/last_unit_cpu
>>> to pcpu_low/high_unit_cpu to avoid confusion.
>>>
>>> The chunk address range is used to flush cache on vmalloc area
>>> map/unmap and decide whether a given address is in the first chunk by
>>> per_cpu_ptr_to_phys() and the bug was discovered by invalid
>>> per_cpu_ptr_to_phys() translation for crash_note.
>>>
>>> Kudos to Dave Young for tracking down the problem.
>>
>> Tejun, thanks
>>
>> Now that if addr is not in first trunk it must be in vmalloc area, below
>> logic should be right:
>> 	if (in_first_chunk) {
>> 		if (!is_vmalloc_addr(addr))
>> 			return __pa(addr);
>> 		else
>> 			return page_to_phys(vmalloc_to_page(addr));
>> 	} else
>> 		if (!is_vmalloc_addr(addr)) /* not possible */
>> 			return __pa(addr);
>> 		else
>> 			return page_to_phys(pcpu_addr_to_page(addr));
>>
>> So how about just simply remove in first chunk checking to simplify the
>> code as followging:
>>
>> phys_addr_t per_cpu_ptr_to_phys(void *addr)
>> {
>> 	if (!is_vmalloc_addr(addr))
>> 		return __pa(addr);
>> 	else
>> 		return page_to_phys(pcpu_addr_to_page(addr));
>> }
> 
> Yes, that's much simpler.  Hmmm... I'm still slightly reluctant
> because the current code reflects better how percpu allocator actually
> works.  It has special setup for the first chunk, which currently
> supports either embedding in linear address space or vmalloc mapping,
> and, from the second one, the backing allocator (currently either vm
> or km) provides translation.
> 
> per_cpu_ptr_to_phys() has been pretty good at exposing wrong
> assumptions in address translation mostly because this is one of few
> points where the assumptions are visible in a verifiable way (I think
> this is the second bug it has discovered).
> 
> This forces the verification that "if it isn't in one of the explicit
> first chunk areas, it MUST follow backing allocator mapping" which can
> discover both bugs in percpu allocator itself and
> per_cpu_ptr_to_phys() callers.  e.g. with the proposed change, if the
> caller passes in usual kernel address on percpu-vm which is not in the
> first chunk, it will return __pa for the address even though that
> address can't possibly be a percpu address, but the current code will
> trip VIRTUAL_BUG_ON() in vmalloc_to_page().
> 
> Maybe we can add comment there how it can be further simplified and
> why things look more complicated than necessary?


I wonder if it's good to add something like CONFIG_PER_CPU_DEBUG?
Anyway I have no strong opinion with this. I'm fine to either of adding
comment and put it into debug around.

Thank you for your fix.

-- 
Thanks
Dave
