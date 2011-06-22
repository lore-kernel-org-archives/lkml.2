Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab1FVLKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 07:10:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372Ab1FVLKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 07:10:52 -0400
Message-ID: <4E01CDAD.3070202@redhat.com>
Date: Wed, 22 Jun 2011 14:10:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Izik Eidus <izik.eidus@ravellosystems.com>
CC: nai.xia@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Chris Wright <chrisw@sous-sol.org>,
        Rik van Riel <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH] mmu_notifier, kvm: Introduce dirty bit tracking in spte
 and mmu notifier to help KSM dirty bit tracking
References: <201106212055.25400.nai.xia@gmail.com> <201106212132.39311.nai.xia@gmail.com> <4E01C752.10405@redhat.com> <4E01CC77.10607@ravellosystems.com>
In-Reply-To: <4E01CC77.10607@ravellosystems.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 02:05 PM, Izik Eidus wrote:
>>> +    spte = rmap_next(kvm, rmapp, NULL);
>>> +    while (spte) {
>>> +        int _dirty;
>>> +        u64 _spte = *spte;
>>> +        BUG_ON(!(_spte&  PT_PRESENT_MASK));
>>> +        _dirty = _spte&  PT_DIRTY_MASK;
>>> +        if (_dirty) {
>>> +            dirty = 1;
>>> +            clear_bit(PT_DIRTY_SHIFT, (unsigned long *)spte);
>>> +        }
>>
>> Racy.  Also, needs a tlb flush eventually.
> +
>
> Hi, one of the issues is that the whole point of this patch is not do 
> tlb flush eventually,
> But I see your point, because other users will not expect such 
> behavior, so maybe there is need into a parameter
> flush_tlb=?, or add another mmu notifier call?
>

If you don't flush the tlb, a subsequent write will not see that spte.d 
is clear and the write will happen.  So you'll see the page as clean 
even though it's dirty.  That's not acceptable.

-- 
error compiling committee.c: too many arguments to function

