Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab1CGDFS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 22:05:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49441 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755047Ab1CGDFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 22:05:16 -0500
Message-ID: <4D744BA5.5020607@cn.fujitsu.com>
Date: Mon, 07 Mar 2011 11:06:13 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/10] KVM: MMU: fix kvm_mmu_get_spte_hierarchy
References: <4D70C569.1030107@cn.fujitsu.com> <4D70C597.4070105@cn.fujitsu.com> <20110305164805.GB4607@amt.cnet>
In-Reply-To: <20110305164805.GB4607@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-07 11:04:01,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-07 11:04:02,
	Serialize complete at 2011-03-07 11:04:02
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2011 12:48 AM, Marcelo Tosatti wrote:
> On Fri, Mar 04, 2011 at 06:57:27PM +0800, Xiao Guangrong wrote:
>> Don not walk to the next level if spte is mapping to the large page
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>> ---
>>  arch/x86/kvm/mmu.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index b9bf016..10e0982 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -3819,7 +3819,8 @@ int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4])
>>  	for_each_shadow_entry(vcpu, addr, iterator) {
>>  		sptes[iterator.level-1] = *iterator.sptep;
>>  		nr_sptes++;
>> -		if (!is_shadow_present_pte(*iterator.sptep))
>> +		if (!is_shadow_present_pte(*iterator.sptep) ||
>> +		      is_last_spte(*iterator.sptep, iterator.level))
>>  			break;
>>  	}
>>  	spin_unlock(&vcpu->kvm->mmu_lock);
> 
> shadow_walk_okay covers that case.
> 

We can get the large mapping pte in the loop:

static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
{
	if (iterator->level < PT_PAGE_TABLE_LEVEL)
		return false;

	if (iterator->level == PT_PAGE_TABLE_LEVEL)
		if (is_large_pte(*iterator->sptep))
			return false;

	......
}

if level > 1 and pte.pse is set, it will return true.

And, i think this judgment is useless:
	if (iterator->level == PT_PAGE_TABLE_LEVEL)
		if (is_large_pte(*iterator->sptep))
			return false;
since if level = 1, the pte bit7 is PAT.
