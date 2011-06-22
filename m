Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab1FVLFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 07:05:39 -0400
Received: from na3sys010aog110.obsmtp.com ([74.125.245.88]:44492 "HELO
	na3sys010aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754668Ab1FVLFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 07:05:38 -0400
Message-ID: <4E01CC77.10607@ravellosystems.com>
Date: Wed, 22 Jun 2011 14:05:27 +0300
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
References: <201106212055.25400.nai.xia@gmail.com> <201106212132.39311.nai.xia@gmail.com> <4E01C752.10405@redhat.com>
In-Reply-To: <4E01C752.10405@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/22/2011 1:43 PM, Avi Kivity wrote:
> On 06/21/2011 04:32 PM, Nai Xia wrote:
>> Introduced kvm_mmu_notifier_test_and_clear_dirty(), 
>> kvm_mmu_notifier_dirty_update()
>> and their mmu_notifier interfaces to support KSM dirty bit tracking, 
>> which brings
>> significant performance gain in volatile pages scanning in KSM.
>> Currently, kvm_mmu_notifier_dirty_update() returns 0 if and only if 
>> intel EPT is
>> enabled to indicate that the dirty bits of underlying sptes are not 
>> updated by
>> hardware.
>>
>
>
> Can you quantify the performance gains?
>
>> +int kvm_test_and_clear_dirty_rmapp(struct kvm *kvm, unsigned long 
>> *rmapp,
>> +                   unsigned long data)
>> +{
>> +    u64 *spte;
>> +    int dirty = 0;
>> +
>> +    if (!shadow_dirty_mask) {
>> +        WARN(1, "KVM: do NOT try to test dirty bit in EPT\n");
>> +        goto out;
>> +    }
>> +
>> +    spte = rmap_next(kvm, rmapp, NULL);
>> +    while (spte) {
>> +        int _dirty;
>> +        u64 _spte = *spte;
>> +        BUG_ON(!(_spte&  PT_PRESENT_MASK));
>> +        _dirty = _spte&  PT_DIRTY_MASK;
>> +        if (_dirty) {
>> +            dirty = 1;
>> +            clear_bit(PT_DIRTY_SHIFT, (unsigned long *)spte);
>> +        }
>
> Racy.  Also, needs a tlb flush eventually.

Hi, one of the issues is that the whole point of this patch is not do 
tlb flush eventually,
But I see your point, because other users will not expect such behavior, 
so maybe there is need into a parameter
flush_tlb=?, or add another mmu notifier call?

