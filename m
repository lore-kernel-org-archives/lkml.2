Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab0HXMd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 08:33:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472Ab0HXMd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 08:33:57 -0400
Message-ID: <4C73BC02.7090606@redhat.com>
Date: Tue, 24 Aug 2010 15:33:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v5 08/12] Inject asynchronous page fault into a guest
 if page is swapped out.
References: <1279553462-7036-1-git-send-email-gleb@redhat.com> <1279553462-7036-9-git-send-email-gleb@redhat.com> <4C729F10.40005@redhat.com> <20100824122844.GA10499@redhat.com>
In-Reply-To: <20100824122844.GA10499@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/24/2010 03:28 PM, Gleb Natapov wrote:
> On Mon, Aug 23, 2010 at 07:17:20PM +0300, Avi Kivity wrote:
>>> +static int apf_put_user(struct kvm_vcpu *vcpu, u32 val)
>>> +{
>>> +	if (unlikely(vcpu->arch.apf_memslot_ver !=
>>> +		     vcpu->kvm->memslot_version)) {
>>> +		u64 gpa = vcpu->arch.apf_msr_val&   ~0x3f;
>>> +		unsigned long addr;
>>> +		int offset = offset_in_page(gpa);
>>> +
>>> +		addr = gfn_to_hva(vcpu->kvm, gpa>>   PAGE_SHIFT);
>>> +		vcpu->arch.apf_data = (u32 __user *)(addr + offset);
>>> +		if (kvm_is_error_hva(addr)) {
>>> +			vcpu->arch.apf_data = NULL;
>>> +			return -EFAULT;
>>> +		}
>>> +	}
>>> +
>>> +	return put_user(val, vcpu->arch.apf_data);
>>> +}
>> This nice cache needs to be outside apf to reduce complexity for
>> reviewers and since it is useful for others.
>>
>> Would be good to have memslot-cached kvm_put_guest() and kvm_get_guest().
>>
> Something like this? (only compile tested)

Yes, exactly.

-- 
error compiling committee.c: too many arguments to function

