Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab0CRLcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 07:32:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59277 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab0CRLcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 07:32:16 -0400
Message-ID: <4BA20EC7.5070508@cn.fujitsu.com>
Date: Thu, 18 Mar 2010 19:30:15 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
       KVM list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] KVM MMU: check reserved bits only when CR4.PSE=1 or
 CR4.PAE=1
References: <4BA04FCA.40308@cn.fujitsu.com> <20100318024948.GB23995@amt.cnet>
In-Reply-To: <20100318024948.GB23995@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcelo,

Thanks for your review.

Marcelo Tosatti wrote:
> On Wed, Mar 17, 2010 at 11:43:06AM +0800, Xiao Guangrong wrote:
>> - The RSV bit is possibility set in error code when #PF occurred
>>   only if CR4.PSE=1 or CR4.PAE=1
>>   
>> - context->rsvd_bits_mask[1][0] is always 0
>>
>> Changlog:
>> Move this operation to reset_rsvds_bits_mask() address Avi Kivity's suggestion
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>> ---
>>  arch/x86/kvm/mmu.c |   12 +++++++++---
>>  1 files changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index b137515..c49f8ec 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -2288,18 +2288,26 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu, int level)
>>  
>>  	if (!is_nx(vcpu))
>>  		exb_bit_rsvd = rsvd_bits(63, 63);
>> +
>> +	context->rsvd_bits_mask[1][0] = 0;
> 
> So if the guest enables PAT at PTE level you completly disable reserved
> bit checking? You should only disable checking for [1][1] if !PSE.

Sorry, i make a mistake here because i see the current code is redundant:
	context->rsvd_bits_mask[1][0] = context->rsvd_bits_mask[1][0];
in every case.

This code is imported by commit fd2e987d, i think this is Avi Kivity's typo :-)
i think the correct way is:
	ontext->rsvd_bits_mask[1][0] = context->rsvd_bits_mask[0][0];

I'll send a new version patch to fix it if you not object. 

Xiao


