Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab0HTRpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 13:45:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734Ab0HTRpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 13:45:36 -0400
Date: Fri, 20 Aug 2010 14:45:27 -0300
From: Glauber Costa <glommer@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 33/35] Indicate reliable TSC in kvmclock
Message-ID: <20100820174527.GH2937@mothafucka.localdomain>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
 <1282291669-25709-34-git-send-email-zamsden@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282291669-25709-34-git-send-email-zamsden@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 10:07:47PM -1000, Zachary Amsden wrote:
> When no platform bugs have been detected, no TSC warps have been
> detected, and the hardware guarantees to us TSC does not change
> rate or stop with P-state or C-state changes, we can consider it reliable.
> 
> Signed-off-by: Zachary Amsden <zamsden@redhat.com>
> ---
>  arch/x86/kvm/x86.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 86f182a..a7fa24e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -55,6 +55,7 @@
>  #include <asm/mce.h>
>  #include <asm/i387.h>
>  #include <asm/xcr.h>
> +#include <asm/pvclock-abi.h>
>  
>  #define MAX_IO_MSRS 256
>  #define CR0_RESERVED_BITS						\
> @@ -900,6 +901,13 @@ static void kvm_get_time_scale(uint32_t scaled_khz, uint32_t base_khz,
>  static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
>  unsigned long max_tsc_khz;
>  
> +static inline int kvm_tsc_reliable(void)
> +{
> +	return (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
> +		boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
> +		!check_tsc_unstable());
> +}
> +
>  static inline u64 nsec_to_cycles(struct kvm *kvm, u64 nsec)
>  {
>  	return pvclock_scale_delta(nsec, kvm->arch.virtual_tsc_mult,
> @@ -1151,7 +1159,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
>  	vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
>  	vcpu->last_kernel_ns = kernel_ns;
> -	vcpu->hv_clock.flags = 0;
> +	vcpu->hv_clock.flags = kvm_tsc_reliable() ? PVCLOCK_TSC_STABLE_BIT : 0;
This is not enough.

We still can have bugs arriving from the difference in resolution between the underlying
clock and the tsc. What we're doing here, is to pass a reliable flag, to a non-reliable
guest tsc. We can only trust the guest kvmclock to be tsc-stable if the host is using
tsc clocksource as well.

Since the stable bit have to be read from the guest at every clock read, we can just
use it, and drop it if the host changes its clocksource.

An alternative for the reliable tsc case, would be to just maintain our own parallel
tsc-based clock. But to be honest, I don't like this solution very much. It adds
complexity, and I kinda believe that if the sysadmin had the work to go there
and switch clocksources, he probably has a reason for that.

