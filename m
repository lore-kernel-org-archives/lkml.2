Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab0GABP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 21:15:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57027 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab0GABPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 21:15:24 -0400
Message-ID: <4C2BEB48.3080705@cn.fujitsu.com>
Date: Thu, 01 Jul 2010 09:11:36 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 9/11] KVM: MMU: prefetch ptes when intercepted guest
 #PF
References: <4C2AF9FA.9020601@cn.fujitsu.com> <4C2AFB65.2030807@cn.fujitsu.com> <20100630204324.GA5366@amt.cnet>
In-Reply-To: <20100630204324.GA5366@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Marcelo Tosatti wrote:

>> +
>> +		addr = gfn_to_hva_many(vcpu->kvm, gfn, &entry);
>> +		if (kvm_is_error_hva(addr))
>> +			return -1;
>> +
>> +		entry = min(entry, (int)(end - start));
>> +		ret = __get_user_pages_fast(addr, entry, 1, pages);
>> +		if (ret <= 0)
>> +			return -1;
> 
> Why can't you use gfn_to_pfn_atomic() here, one page at a time? Is 
> the overhead significant that this is worthwhile?
> 
> You're bypassing the centralized interface.

I think it's worthwhile to do since we can reduce gup overhead, no reason
to traverse process's page table again and again for the consecutive pages.

> 
>> +
>> +		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
>> +		mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
>> +			     is_dirty_gpte(gpte), NULL, sp->role.level, gfn,
>> +			     pfn, true, false);
> 
> reset_host_protection should be true, see commit 1403283acca (also for
> direct case to be consistent).
> 

Ah, i forgot it, thanks, Marcelo!

I'll post a small fix patch base on this patchset to change 'false' to 'true' if no
other places no to be improved. :-)
