Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab2FTJLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:11:18 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:44473 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab2FTJLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:11:16 -0400
Message-ID: <4FE193AA.8010801@linux.vnet.ibm.com>
Date: Wed, 20 Jun 2012 17:11:06 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v7 02/10] KVM: MMU: abstract spte write-protect
References: <4FE1822D.8010002@linux.vnet.ibm.com> <4FE1825B.1030402@linux.vnet.ibm.com> <20120620180254.8b3a42f8.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120620180254.8b3a42f8.yoshikawa.takuya@oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12062009-5564-0000-0000-00000344AA11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 05:02 PM, Takuya Yoshikawa wrote:

> On Wed, 20 Jun 2012 15:57:15 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> Introduce a common function to abstract spte write-protect to
>> cleanup the code
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> 
> ...
> 
>> +/* Return true if the spte is dropped. */
>> +static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush)
>> +{
>> +	u64 spte = *sptep;
>> +
>> +	if (!is_writable_pte(spte))
>> +		return false;
>> +
>> +	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);
> 
> ...
> 
>> @@ -3902,16 +3915,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
>>  			      !is_last_spte(pt[i], sp->role.level))
>>  				continue;
>>
>> -			if (is_large_pte(pt[i])) {
>> -				drop_spte(kvm, &pt[i]);
>> -				--kvm->stat.lpages;
>> -				continue;
>> -			}
>> -
>> -			/* avoid RMW */
>> -			if (is_writable_pte(pt[i]))
>> -				mmu_spte_update(&pt[i],
>> -						pt[i] & ~PT_WRITABLE_MASK);
>> +			spte_write_protect(kvm, &pt[i], &flush);
> 
> Adding rmap_printk() here seems wrong.
> 


Strange! Why do you think it is wrong? It is just debug code.

> If you think it is not a problem, please explain why you think so in
> the changelog.


It is a from the first place and it is used to debug and not compiled at all.

