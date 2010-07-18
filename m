Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab0GRO2T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 10:28:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449Ab0GRO2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 10:28:18 -0400
Message-ID: <4C430F80.9020100@redhat.com>
Date: Sun, 18 Jul 2010 17:28:16 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: KVM <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/18] Make TSC offset writes non-preemptible
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com> <1278987938-23873-2-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278987938-23873-2-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 05:25 AM, Zachary Amsden wrote:
> Ensure that the storing of the offset and the reading of the TSC
> are never preempted by taking a spinlock.  While the lock is overkill
> now, it is useful later in this patch series.
>
>
>    

This patch has both code movement and semantic changes.  Please split 
into two so it's easier to understand which are which.

>   /*
> - * writes 'guest_tsc' into guest's timestamp counter "register"
> - * guest_tsc = host_tsc + tsc_offset ==>  tsc_offset = guest_tsc - host_tsc
> + * writes 'offset' into guest's timestamp counter offset register
>    */
> -static void guest_write_tsc(u64 guest_tsc, u64 host_tsc)
> +static void vmx_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
>    

Shouldn't offset be an s64?  Doesn't matter in practice, of course, but 
offset would usually be negative, not some huge number that happens to 
roll the guest tsc around.

>   {
> -	vmcs_write64(TSC_OFFSET, guest_tsc - host_tsc);
> +	vmcs_write64(TSC_OFFSET, offset);
>   }
>
>
>    

>
> +void guest_write_tsc(struct kvm_vcpu *vcpu, u64 data)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	u64 offset;
> +
> +	spin_lock(&kvm->arch.tsc_write_lock);
> +	offset = data - native_read_tsc();
> +	kvm_x86_ops->write_tsc_offset(vcpu, offset);
> +	spin_unlock(&kvm->arch.tsc_write_lock);
> +
> +	/* Reset of TSC must disable overshoot protection below */
> +	vcpu->arch.hv_clock.tsc_timestamp = 0;
> +}
> +EXPORT_SYMBOL_GPL(guest_write_tsc);
> +
>    

Exported symbols should start with kvm_.


-- 
error compiling committee.c: too many arguments to function

