Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab0HWPWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 11:22:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083Ab0HWPWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 11:22:32 -0400
Message-ID: <4C72921A.8000308@redhat.com>
Date: Mon, 23 Aug 2010 18:22:02 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v5 02/12] Add PV MSR to enable asynchronous page faults
 delivery.
References: <1279553462-7036-1-git-send-email-gleb@redhat.com> <1279553462-7036-3-git-send-email-gleb@redhat.com>
In-Reply-To: <1279553462-7036-3-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/19/2010 06:30 PM, Gleb Natapov wrote:
> Guess enables async PF vcpu functionality using this MSR.
>
>
>
> +static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
> +{
> +	u64 gpa = data&  ~0x3f;
> +	int offset = offset_in_page(gpa);
> +	unsigned long addr;
> +
> +	/* Bits 1:5 are resrved, Should be zero */
> +	if (data&  0x3e)
> +		return 1;
> +
> +	vcpu->arch.apf_msr_val = data;
> +
> +	if (!(data&  KVM_ASYNC_PF_ENABLED)) {
> +		vcpu->arch.apf_data = NULL;
> +		return 0;
> +	}
> +
> +	addr = gfn_to_hva(vcpu->kvm, gpa>>  PAGE_SHIFT);
> +	if (kvm_is_error_hva(addr))
> +		return 1;
> +
> +	vcpu->arch.apf_data = (u32 __user*)(addr + offset);

This can be invalidated by host userspace playing with memory regions.  
It needs to be recalculated on memory map changes, and it may disappear 
from under the guest's feet (in which case we're allowed to 
KVM_REQ_TRIPLE_FAULT it).

(note: this is a much better approach than kvmclock's and vapic's, we 
should copy it there)

> +
> +	/* check if address is mapped */
> +	if (get_user(offset, vcpu->arch.apf_data)) {
> +		vcpu->arch.apf_data = NULL;
> +		return 1;
> +	}

So, this check can succeed today but fail tomorrow.

> +	return 0;
> +}
> +

-- 
error compiling committee.c: too many arguments to function

