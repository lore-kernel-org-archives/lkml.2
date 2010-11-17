Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933959Ab0KQBij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:38:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64927 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933200Ab0KQBii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 20:38:38 -0500
Message-ID: <4CE33321.10207@cn.fujitsu.com>
Date: Wed, 17 Nov 2010 09:42:57 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/4] KVM: MMU: don't drop spte if overwrite it from W
 to RO
References: <4CDD173E.8010706@cn.fujitsu.com> <20101116202414.GA24156@amt.cnet>
In-Reply-To: <20101116202414.GA24156@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 09:39:00,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 09:39:01,
	Serialize complete at 2010-11-17 09:39:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 04:24 AM, Marcelo Tosatti wrote:
> On Fri, Nov 12, 2010 at 06:30:22PM +0800, Xiao Guangrong wrote:
>> We just need flush tlb if overwrite a writable spte with a read-only one
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>> ---
>>  arch/x86/kvm/mmu.c |   19 +++++++++----------
>>  1 files changed, 9 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 4b6d54c..1a93ab4 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -2044,6 +2044,15 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>>  	if (pte_access & ACC_WRITE_MASK)
>>  		mark_page_dirty(vcpu->kvm, gfn);
>>  
>> +	/*
>> +	 * If we overwrite a writable spte with a read-only one,
>> +	 * flush remote TLBs. Otherwise rmap_write_protect will
>> +	 * find a read-only spte, even though the writable spte
>> +	 * might be cached on a CPU's TLB.
>> +	 */
>> +	else if (is_writable_pte(*sptep))
>> +		ret = 1;
>> +
> 
> The return value of set_spte indicates whether the gfn being mapped to
> was write protected, not if a TLB flush is necessary.
> 

Yes, i also noticed this and have fixed in the v2 queue, thanks Marcelo!
