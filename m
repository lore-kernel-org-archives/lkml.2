Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab1FVLUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 07:20:46 -0400
Received: from na3sys010aog105.obsmtp.com ([74.125.245.78]:44708 "HELO
	na3sys010aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756859Ab1FVLT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 07:19:57 -0400
Message-ID: <4E01CFD2.6000404@ravellosystems.com>
Date: Wed, 22 Jun 2011 14:19:46 +0300
From: Izik Eidus <izik.eidus@ravellosystems.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: nai.xia@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Chris Wright <chrisw@sous-sol.org>,
        Rik van Riel <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH] mmu_notifier, kvm: Introduce dirty bit tracking in spte
 and mmu notifier to help KSM dirty bit tracking
References: <201106212055.25400.nai.xia@gmail.com> <201106212132.39311.nai.xia@gmail.com> <4E01C752.10405@redhat.com> <4E01CC77.10607@ravellosystems.com> <4E01CDAD.3070202@redhat.com>
In-Reply-To: <4E01CDAD.3070202@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/22/2011 2:10 PM, Avi Kivity wrote:
> On 06/22/2011 02:05 PM, Izik Eidus wrote:
>>>> +    spte = rmap_next(kvm, rmapp, NULL);
>>>> +    while (spte) {
>>>> +        int _dirty;
>>>> +        u64 _spte = *spte;
>>>> +        BUG_ON(!(_spte&  PT_PRESENT_MASK));
>>>> +        _dirty = _spte&  PT_DIRTY_MASK;
>>>> +        if (_dirty) {
>>>> +            dirty = 1;
>>>> +            clear_bit(PT_DIRTY_SHIFT, (unsigned long *)spte);
>>>> +        }
>>>
>>> Racy.  Also, needs a tlb flush eventually.
>> +
>>
>> Hi, one of the issues is that the whole point of this patch is not do 
>> tlb flush eventually,
>> But I see your point, because other users will not expect such 
>> behavior, so maybe there is need into a parameter
>> flush_tlb=?, or add another mmu notifier call?
>>
>
> If you don't flush the tlb, a subsequent write will not see that 
> spte.d is clear and the write will happen.  So you'll see the page as 
> clean even though it's dirty.  That's not acceptable.
>

Yes, but this is exactly what we want from this use case:
Right now ksm calculate the page hash to see if it was changed, the idea 
behind this patch is to use the dirty bit instead,
however the guest might not really like the fact that we will flush its 
tlb over and over again, specially in periodically scan like ksm does.

So what we say here is: it is better to have little junk in the unstable 
tree that get flushed eventualy anyway, instead of make the guest slower....
this race is something that does not reflect accurate of ksm anyway due 
to the full memcmp that we will eventualy perform...

Ofcurse we trust that in most cases, beacuse it take ksm to get into a 
random virtual address in real systems few minutes, there will be 
already tlb flush performed.

What you think about having 2 calls: one that does the expected behivor 
and does flush the tlb, and one that clearly say it doesnt flush the tlb
and expline its use case for ksm?
