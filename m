Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab0GGB1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 21:27:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49254 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab0GGB1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 21:27:08 -0400
Message-ID: <4C33D703.4090208@cn.fujitsu.com>
Date: Wed, 07 Jul 2010 09:23:15 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 8/9] KVM: MMU: combine guest pte read between fetch
 and pte prefetch
References: <4C330918.6040709@cn.fujitsu.com> <4C330A9A.9030106@cn.fujitsu.com> <20100706195254.GA4311@amt.cnet>
In-Reply-To: <20100706195254.GA4311@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Marcelo Tosatti wrote:

>> -
>> -	first_pte_gpa = gfn_to_gpa(sp->gfn) +
>> -				(offset + i) * sizeof(pt_element_t);
>> -
>> -	if (kvm_read_guest_atomic(vcpu->kvm, first_pte_gpa, gptep,
>> -					sizeof(gptep)) < 0)
>> -		return;
>> +	gptep = gw->prefetch_ptes;
> 
> Where do you reread the gpte in the prefetch path?
> 

Marcelo,

Thanks for your review.

Below codes read gptes in the prefetch path:

	index = sptep - sp->spt;
	i = index & ~(PTE_PREFETCH_NUM - 1);
	max = index | (PTE_PREFETCH_NUM - 1);

	if (PTTYPE == 32)
		offset = sp->role.quadrant << PT64_LEVEL_BITS;

	first_pte_gpa = gfn_to_gpa(sp->gfn) +
				(offset + i) * sizeof(pt_element_t);

	if (kvm_read_guest_atomic(vcpu->kvm, first_pte_gpa, gptep,
					sizeof(gptep)) < 0)
		return;

It reads the 16 aligned items around sptep's corresponding gpte and this gpte
is also in this area. :-)
