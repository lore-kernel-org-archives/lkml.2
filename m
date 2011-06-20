Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab1FTSwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 14:52:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62844 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab1FTSw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 14:52:28 -0400
Message-ID: <4DFF9766.3080505@cn.fujitsu.com>
Date: Tue, 21 Jun 2011 02:54:30 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 10/15] KVM: MMU: lockless walking shadow page table
References: <4DEE205E.8000601@cn.fujitsu.com> <4DEE21E2.8000301@cn.fujitsu.com> <20110620163704.GD17130@amt.cnet>
In-Reply-To: <20110620163704.GD17130@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-21 02:52:04,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-21 02:52:04,
	Serialize complete at 2011-06-21 02:52:04
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2011 12:37 AM, Marcelo Tosatti wrote:

>> +	if (atomic_read(&kvm->arch.reader_counter)) {
>> +		free_mmu_pages_unlock_parts(invalid_list);
>> +		sp = list_first_entry(invalid_list, struct kvm_mmu_page, link);
>> +		list_del_init(invalid_list);
>> +		call_rcu(&sp->rcu, free_invalid_pages_rcu);
>> +		return;
>> +	}
> 
> This is probably wrong, the caller wants the page to be zapped by the 
> time the function returns, not scheduled sometime in the future.
> 

It can be freed soon and KVM does not reuse these pages anymore...
it is not too bad, no?

>> +
>>  	do {
>>  		sp = list_first_entry(invalid_list, struct kvm_mmu_page, link);
>>  		WARN_ON(!sp->role.invalid || sp->root_count);
>> @@ -2601,6 +2633,35 @@ static gpa_t nonpaging_gva_to_gpa_nested(struct kvm_vcpu *vcpu, gva_t vaddr,
>>  	return vcpu->arch.nested_mmu.translate_gpa(vcpu, vaddr, access);
>>  }
>>  
>> +int kvm_mmu_walk_shadow_page_lockless(struct kvm_vcpu *vcpu, u64 addr,
>> +				      u64 sptes[4])
>> +{
>> +	struct kvm_shadow_walk_iterator iterator;
>> +	int nr_sptes = 0;
>> +
>> +	rcu_read_lock();
>> +
>> +	atomic_inc(&vcpu->kvm->arch.reader_counter);
>> +	/* Increase the counter before walking shadow page table */
>> +	smp_mb__after_atomic_inc();
>> +
>> +	for_each_shadow_entry(vcpu, addr, iterator) {
>> +		sptes[iterator.level-1] = *iterator.sptep;
>> +		nr_sptes++;
>> +		if (!is_shadow_present_pte(*iterator.sptep))
>> +			break;
>> +	}
> 
> Why is lockless access needed for the MMIO optimization? Note the spte 
> contents are copied to the array here are used for debugging purposes
> only, their contents are potentially stale.
> 

Um, we can use it to check the mmio page fault if it is the real mmio access or the
bug of KVM, i discussed it with Avi:

===============================================
>
> Yes, it is, i just want to detect BUG for KVM, it helps us to know if "ept misconfig" is the
> real MMIO or the BUG. I noticed some "ept misconfig" BUGs is reported before, so i think doing
> this is necessary, and i think it is not too bad, since walking spte hierarchy is lockless,
> it really fast.

Okay.  We can later see if it show up on profiles. 
===============================================

And it is really fast, i will attach the 'perf result' when the v2 is posted.

Yes, their contents are potentially stale, we just use it to check mmio, after all, if we get the
stale spte, we will call page fault path to fix it.
 


