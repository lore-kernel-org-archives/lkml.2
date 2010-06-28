Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab0F1Joa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 05:44:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53929 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab0F1Jo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 05:44:28 -0400
Message-ID: <4C286E1A.7070003@cn.fujitsu.com>
Date: Mon, 28 Jun 2010 17:40:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/10] KVM: MMU: fix writable sync sp mapping
References: <4C249B84.4080703@cn.fujitsu.com> <4C2704CF.6040401@cn.fujitsu.com> <4C2868C9.8040302@redhat.com>
In-Reply-To: <4C2868C9.8040302@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:

>>
>>       for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node) {
>> +        if (!can_unsync)
>> +            return 1;
>> +
>>    
> 
> What if the page is already unsync?  We don't need write protection in
> this case.

Avi,

The reason is when we sync children sps, we write-protected for all sps first,
list relevant code:

| static void mmu_sync_children(...)
| {
|	......
|		for_each_sp(pages, sp, parents, i)
|			protected |= rmap_write_protect(vcpu->kvm, sp->gfn); <==== A
|
|		if (protected)
|			kvm_flush_remote_tlbs(vcpu->kvm);
|
|		for_each_sp(pages, sp, parents, i) {
|			kvm_sync_page(vcpu, sp, &invalid_list);  <==== B
|			mmu_pages_clear_parents(&parents);
|		}
|	......
|}

For example:

SP1.pte[0] = P
SP2.gfn's pfn = P
[SP1.pte[0] = SP2.gfn's pfn]

At A point, SP1.gfn and SP2.gfn are write-protected.

At B point, if sync SP1 first, while it's synced. it will detect SP1.pte[0].gfn only has one unsync-sp,
that is SP2, so it will mapping it writable, then we sync SP2, we will set SP2 to sync page.

The final result is: SP2 is the sync page but SP2.gfn is writable.
Note: we not do write-protected in kvm_sync_page() anymore after commit: 95b4b26cfc
