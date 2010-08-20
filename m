Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab0HTRk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 13:40:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab0HTRky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 13:40:54 -0400
Date: Fri, 20 Aug 2010 14:40:44 -0300
From: Glauber Costa <glommer@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 12/35] Robust TSC compensation
Message-ID: <20100820174044.GG2937@mothafucka.localdomain>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
 <1282291669-25709-13-git-send-email-zamsden@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282291669-25709-13-git-send-email-zamsden@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 10:07:26PM -1000, Zachary Amsden wrote:
> Make the match of TSC find TSC writes that are close to each other
> instead of perfectly identical; this allows the compensator to also
> work in migration / suspend scenarios.
> 
> Signed-off-by: Zachary Amsden <zamsden@redhat.com>
> ---
>  arch/x86/kvm/x86.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 52680f6..0f3e5fb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -928,21 +928,27 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
>  	struct kvm *kvm = vcpu->kvm;
>  	u64 offset, ns, elapsed;
>  	unsigned long flags;
> +	s64 sdiff;
>  
>  	spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
>  	offset = data - native_read_tsc();
>  	ns = get_kernel_ns();
>  	elapsed = ns - kvm->arch.last_tsc_nsec;
> +	sdiff = data - kvm->arch.last_tsc_write;
> +	if (sdiff < 0)
> +		sdiff = -sdiff;
>  
>  	/*
> -	 * Special case: identical write to TSC within 5 seconds of
> +	 * Special case: close write to TSC within 5 seconds of
>  	 * another CPU is interpreted as an attempt to synchronize
> -	 * (the 5 seconds is to accomodate host load / swapping).
> +	 * The 5 seconds is to accomodate host load / swapping as
> +	 * well as any reset of TSC during the boot process.
>  	 *
>  	 * In that case, for a reliable TSC, we can match TSC offsets,
> -	 * or make a best guest using kernel_ns value.
> +	 * or make a best guest using elapsed value.
>  	 */
> -	if (data == kvm->arch.last_tsc_write && elapsed < 5ULL * NSEC_PER_SEC) {
> +	if (sdiff < nsec_to_cycles(5ULL * NSEC_PER_SEC) &&
> +	    elapsed < 5ULL * NSEC_PER_SEC) {
>  		if (!check_tsc_unstable()) {
Isn't 5 way too long for this case?


