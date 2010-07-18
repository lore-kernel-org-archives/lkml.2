Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab0GROw6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 10:52:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060Ab0GROwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 10:52:55 -0400
Message-ID: <4C431546.9030906@redhat.com>
Date: Sun, 18 Jul 2010 17:52:54 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: KVM <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/18] Robust TSC compensation
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com> <1278987938-23873-10-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278987938-23873-10-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 05:25 AM, Zachary Amsden wrote:
> Make the match of TSC find TSC writes that are close to each other
> instead of perfectly identical; this allows the compensator to also
> work in migration / suspend scenarios.
>
>    

What scenario exactly?

> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -926,21 +926,27 @@ void guest_write_tsc(struct kvm_vcpu *vcpu, u64 data)
>   	struct kvm *kvm = vcpu->kvm;
>   	u64 offset, ns, elapsed;
>   	struct timespec ts;
> +	s64 sdiff;
>
>   	spin_lock(&kvm->arch.tsc_write_lock);
>   	offset = data - native_read_tsc();
>   	ns = get_kernel_ns();
>   	elapsed = ns - kvm->arch.last_tsc_nsec;
> +	sdiff = data - kvm->arch.last_tsc_write;
> +	if (sdiff<  0)
> +		sdiff = -sdiff;
>
>   	/*
> -	 * Special case: identical write to TSC within 5 seconds of
> +	 * Special case: close write to TSC within 5 seconds of
>   	 * another CPU is interpreted as an attempt to synchronize
> -	 * (the 5 seconds is to accomodate host load / swapping).
> +	 * The 5 seconds is to accomodate host load / swapping as
> +	 * well as any reset of TSC during the boot process.
>   	 *
>   	 * In that case, for a reliable TSC, we can match TSC offsets,
> -	 * or make a best guest using kernel_ns value.
> +	 * or make a best guest using elapsed value.
>   	 */
> -	if (data == kvm->arch.last_tsc_write&&  elapsed<  5ULL * NSEC_PER_SEC) {
> +	if (sdiff<  nsec_to_cycles(5ULL * NSEC_PER_SEC)&&
> +	    elapsed<  5ULL * NSEC_PER_SEC) {
>   		if (!check_tsc_unstable()) {
>   			offset = kvm->arch.last_tsc_offset;
>   			pr_debug("kvm: matched tsc offset for %llu\n", data);
>    

Don't we have to adjust offset to the required different between tsc?  
Or do we assume, that if the guest wrote close enough values, it is 
trying to cleverly compensate for IPI latency?

-- 
error compiling committee.c: too many arguments to function

