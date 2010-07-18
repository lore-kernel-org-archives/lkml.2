Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab0GROfG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 10:35:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517Ab0GROfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 10:35:01 -0400
Message-ID: <4C431113.10101@redhat.com>
Date: Sun, 18 Jul 2010 17:34:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: KVM <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/18] TSC reset compensation
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com> <1278987938-23873-4-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278987938-23873-4-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 05:25 AM, Zachary Amsden wrote:
> Attempt to synchronize TSCs which are reset to the same value.  In the
> case of a reliable hardware TSC, we can just re-use the same offset, but
> on non-reliable hardware, we can get closer by adjusting the offset to
> match the elapsed time.
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3b4efe2..4b42893 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -396,6 +396,9 @@ struct kvm_arch {
>   	unsigned long irq_sources_bitmap;
>   	s64 kvmclock_offset;
>   	spinlock_t tsc_write_lock;
> +	u64 last_tsc_nsec;
> +	u64 last_tsc_offset;
> +	u64 last_tsc_write;
>    

So that we know what the lock protects, let's have

    struct kvm_global_tsc {
          spinlock_t lock;
          ...
     } tsc;

> @@ -896,10 +896,39 @@ static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
>   void guest_write_tsc(struct kvm_vcpu *vcpu, u64 data)
>   {
>   	struct kvm *kvm = vcpu->kvm;
> -	u64 offset;
> +	u64 offset, ns, elapsed;
> +	struct timespec ts;
>
>   	spin_lock(&kvm->arch.tsc_write_lock);
>   	offset = data - native_read_tsc();
> +	ktime_get_ts(&ts);
> +	monotonic_to_bootbased(&ts);
> +	ns = timespec_to_ns(&ts);
> +	elapsed = ns - kvm->arch.last_tsc_nsec;
> +
> +	/*
> +	 * Special case: identical write to TSC within 5 seconds of
> +	 * another CPU is interpreted as an attempt to synchronize
> +	 * (the 5 seconds is to accomodate host load / swapping).
> +	 *
> +	 * In that case, for a reliable TSC, we can match TSC offsets,
> +	 * or make a best guest using kernel_ns value.
> +	 */
> +	if (data == kvm->arch.last_tsc_write&&  elapsed<  5ULL * NSEC_PER_SEC) {
> +		if (!check_tsc_unstable()) {
> +			offset = kvm->arch.last_tsc_offset;
> +			pr_debug("kvm: matched tsc offset for %llu\n", data);
> +		} else {
> +			u64 tsc_delta = elapsed * __get_cpu_var(cpu_tsc_khz);
> +			tsc_delta = tsc_delta / USEC_PER_SEC;
> +			offset += tsc_delta;
> +			pr_debug("kvm: adjusted tsc offset by %llu\n", tsc_delta);
> +		}
> +		ns = kvm->arch.last_tsc_nsec;
> +	}
> +	kvm->arch.last_tsc_nsec = ns;
> +	kvm->arch.last_tsc_write = data;
> +	kvm->arch.last_tsc_offset = offset;
>    

We'd have a false alarm here during a reset within 5 seconds of boot.  
Does it matter?  Easy to work around by forgetting the state during reset.

>   	kvm_x86_ops->write_tsc_offset(vcpu, offset);
>   	spin_unlock(&kvm->arch.tsc_write_lock);
>
>    


-- 
error compiling committee.c: too many arguments to function

