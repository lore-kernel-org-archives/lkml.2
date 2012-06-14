Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab2FNCmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 22:42:09 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:35970 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab2FNCmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 22:42:08 -0400
Message-ID: <4FD94F76.9090508@linux.vnet.ibm.com>
Date: Thu, 14 Jun 2012 10:41:58 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 5/9] KVM: MMU: introduce SPTE_MMU_WRITEABLE bit
References: <4FC470C7.5040700@linux.vnet.ibm.com> <4FC4716A.8030304@linux.vnet.ibm.com>	<20120613213905.GD19290@amt.cnet> <20120614101328.c23ab94b.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120614101328.c23ab94b.yoshikawa.takuya@oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12061402-5564-0000-0000-00000331E5A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 09:13 AM, Takuya Yoshikawa wrote:

> On Wed, 13 Jun 2012 18:39:05 -0300
> Marcelo Tosatti <mtosatti@redhat.com> wrote:
> 
>>>  /* Return true if the spte is dropped. */
>>> -static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush)
>>> +static bool
>>> +spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush, bool pt_protect)
>>>  {
>>>  	u64 spte = *sptep;
>>>
>>> -	if (!is_writable_pte(spte))
>>> +	if (!is_writable_pte(spte) &&
>>> +	      !(pt_protect && spte_can_be_writable(spte)))
>>>  		return false;
>>>
>>>  	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);
>>>
>>> -	*flush |= true;
>>>  	if (is_large_pte(spte)) {
>>>  		WARN_ON(page_header(__pa(sptep))->role.level ==
>>>  		       PT_PAGE_TABLE_LEVEL);
>>> +
>>> +		*flush |= true;
>>>  		drop_spte(kvm, sptep);
>>>  		--kvm->stat.lpages;
>>>  		return true;
>>>  	}
>>>
>>> +	if (pt_protect)
>>> +		spte &= ~SPTE_MMU_WRITEABLE;
>>>  	spte = spte & ~PT_WRITABLE_MASK;
>>> -	mmu_spte_update(sptep, spte);
>>> +
>>> +	*flush = mmu_spte_update(sptep, spte);
>>
>> This clears previous flush value when looping over multiple sptes in 
>> a single rmapp.
>>
> 
> I'm sorry but I have to say that this function is hard to understand.
> 
> /* Return true if the spte is dropped. */
> static bool
> spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush, bool pt_protect)
> 
> Even with the comment above, can we guess what this function will do
> for us without reading the body?
> 
> My feeling is that separate roles have been put into this one without
> explaining each parameter.
> 
> I think there are two solutions:
> 	1. separate this into a few functions
> 	2. explain each parameter/role properly in the comment
>


Okay.

I will add more comments and use drop_large_spte to cleanup it.

