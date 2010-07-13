Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab0GMUxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 16:53:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649Ab0GMUxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 16:53:19 -0400
Date: Tue, 13 Jul 2010 17:34:18 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/18] Robust TSC compensation
Message-ID: <20100713203418.GA903@amt.cnet>
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com>
 <1278987938-23873-10-git-send-email-zamsden@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278987938-23873-10-git-send-email-zamsden@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 04:25:29PM -1000, Zachary Amsden wrote:
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
> index 79c4608..51d3f3e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -926,21 +926,27 @@ void guest_write_tsc(struct kvm_vcpu *vcpu, u64 data)
>  	struct kvm *kvm = vcpu->kvm;
>  	u64 offset, ns, elapsed;
>  	struct timespec ts;
> +	s64 sdiff;
>  
>  	spin_lock(&kvm->arch.tsc_write_lock);
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
>  			offset = kvm->arch.last_tsc_offset;
>  			pr_debug("kvm: matched tsc offset for %llu\n", data);

What prevents a vcpu from seeing its TSC go backwards, in case the first
write in the 5 second window is smaller than the victim vcpu's last
visible TSC value ?
