Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab2C3FCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 01:02:03 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:60463 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab2C3FB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 01:01:56 -0400
Message-ID: <4F753E3B.4040308@linux.vnet.ibm.com>
Date: Fri, 30 Mar 2012 13:01:47 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 04/13] KVM: MMU: introduce FNAME(get_sp_gpa)
References: <4F742951.7080003@linux.vnet.ibm.com> <4F7429E7.3010801@linux.vnet.ibm.com> <4F745E7D.5080102@redhat.com>
In-Reply-To: <4F745E7D.5080102@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12032918-1618-0000-0000-0000013074C9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 09:07 PM, Avi Kivity wrote:

> On 03/29/2012 11:22 AM, Xiao Guangrong wrote:
>> It can calculate the base gpa of the specified shadow page on any level,
>> let it instead of FNAME(get_level1_sp_gpa)
>>
>>
>> +static gpa_t FNAME(get_sp_gpa)(struct kvm_mmu_page *sp)
>> +{
> 
> Maybe worth adding a pte index and calling it get_spte_gpa(), depends on
> the next patches I guess.
> 


Yes.

But FNAME(get_sp_gpa) is still needed by FNAME(sync_page) path which sync
all sptes. I will introduce get_spte_gpa() as you mentioned which will be
used in invlpg path and in the later patch.


>> +	int offset, shift;
>> +
>> +	shift = PAGE_SHIFT - (PT_LEVEL_BITS - PT64_LEVEL_BITS) * sp->role.level;
>> +	offset = sp->role.quadrant << shift;
> 
> if you add '& ~PAGE_MASK' the compiler may be smart enough to drop the
> whole thing for 64-bit ptes.
> 


Sorry. how to do that?

But if you want to remove the unnecessary workload, i will change it
like this:

static gpa_t FNAME(get_sp_gpa)(struct kvm_mmu_page *sp)
{
	int offset = 0;

#if PTTYPE == 32
	int shift;

	shift = PAGE_SHIFT - (PT_LEVEL_BITS - PT64_LEVEL_BITS) * sp->role.level;
	offset = sp->role.quadrant << shift;
#endif
	return gfn_to_gpa(sp->gfn) + offset;
}

