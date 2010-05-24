Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab0EXCex (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 22:34:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54751 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754251Ab0EXCev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 22:34:51 -0400
Message-ID: <4BF9E50B.6010205@cn.fujitsu.com>
Date: Mon, 24 May 2010 10:31:39 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: MMU: allow more page become unsync at getting
 sp time
References: <4BF91C34.6020904@cn.fujitsu.com> <4BF91C82.8050308@cn.fujitsu.com> <4BF9378B.4080703@redhat.com>
In-Reply-To: <4BF9378B.4080703@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 05/23/2010 03:16 PM, Xiao Guangrong wrote:
>> Allow more page become asynchronous at getting sp time, if need create
>> new
>> shadow page for gfn but it not allow unsync(level>  1), we should
>> unsync all
>> gfn's unsync page
>>
>>
>>
>> +/* @gfn should be write-protected at the call site */
>> +static void kvm_sync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
>> +{
>> +    struct hlist_head *bucket;
>> +    struct kvm_mmu_page *s;
>> +    struct hlist_node *node, *n;
>> +    unsigned index;
>> +    bool flush = false;
>> +
>> +    index = kvm_page_table_hashfn(gfn);
>> +    bucket =&vcpu->kvm->arch.mmu_page_hash[index];
>> +    hlist_for_each_entry_safe(s, node, n, bucket, hash_link) {
>>    
> 
> role.direct, role.invalid?

We only handle unsync pages here, and 'role.direct' or 'role.invalid'
pages can't become unsync.

> 
> Well, role.direct cannot be unsync.  But that's not something we want to
> rely on.

While we mark the unsync page, we have filtered out the 'role.direct' pages,
so, i think we not need worry 'role.direct' here. :-)

> 
> This patch looks good too.
> 
> Some completely unrelated ideas:
> 
> - replace mmu_zap_page() calls in __kvm_sync_page() by setting
> role.invalid instead.  This reduces problems with the hash list being
> modified while we manipulate it.
> - add a for_each_shadow_page_direct() { ... } and
> for_each_shadow_page_indirect() { ... } to replace the
> hlist_for_each_entry_safe()s.

Actually, i have introduced for_each_gfn_sp() to cleanup it in my private
development. :-)

> - add kvm_tlb_gather() to reduce IPIs from kvm_mmu_zap_page()
> - clear spte.accessed on speculative sptes (for example from invlpg) so
> the swapper won't keep them in ram unnecessarily

I also noticed this problem

> 
> Again, completely unrelated to this patch set, just wrong them down so I
> don't forget them and to get your opinion.
> 

Your ideas are very valuable, and i'll do those if you are not free :-)

Thanks,
Xiao


