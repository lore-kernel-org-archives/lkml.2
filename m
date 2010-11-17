Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934886Ab0KQP5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:57:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934749Ab0KQP5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:57:39 -0500
Message-ID: <4CE3FB74.8050705@redhat.com>
Date: Wed, 17 Nov 2010 17:57:40 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 2/6] KVM: MMU: don't drop spte if overwrite it from
 W to RO
References: <4CE355A0.6020907@cn.fujitsu.com> <4CE355CA.80106@cn.fujitsu.com> <20101117154241.GB18959@amt.cnet>
In-Reply-To: <20101117154241.GB18959@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 05:42 PM, Marcelo Tosatti wrote:
> On Wed, Nov 17, 2010 at 12:10:50PM +0800, Xiao Guangrong wrote:
>> We just need flush tlb if overwrite a writable spte with a read-only
>> one.
>>
>> And we should move this operation to set_spte() for sync_page path
>>
>> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
>> ---
>>   arch/x86/kvm/mmu.c |   20 +++++++++-----------
>>   1 files changed, 9 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index e008ae7..9bad960 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -1966,7 +1966,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>>   		    gfn_t gfn, pfn_t pfn, bool speculative,
>>   		    bool can_unsync, bool reset_host_protection)
>>   {
>> -	u64 spte;
>> +	u64 spte, entry = *sptep;
>>   	int ret = 0;
>>
>>   	/*
>> @@ -2039,6 +2039,14 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>>
>>   set_pte:
>>   	update_spte(sptep, spte);
>> +	/*
>> +	 * If we overwrite a writable spte with a read-only one we
>> +	 * should flush remote TLBs. Otherwise rmap_write_protect
>> +	 * will find a read-only spte, even though the writable spte
>> +	 * might be cached on a CPU's TLB.
>> +	 */
>> +	if (is_writable_pte(entry)&&  !is_writable_pte(*sptep))
>> +		kvm_flush_remote_tlbs(vcpu->kvm);
> There is no need to flush on sync_page path since the guest is
> responsible for it.
>

  If we don't, the next rmap_write_protect() will incorrectly decide 
that there's no need to flush tlbs.

