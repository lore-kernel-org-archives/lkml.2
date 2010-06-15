Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab0FOIL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 04:11:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576Ab0FOILy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 04:11:54 -0400
Message-ID: <4C1735C8.7020406@redhat.com>
Date: Tue, 15 Jun 2010 11:11:52 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: mtosatti@redhat.com, glommer@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/17] Keep SMP VMs more in sync on unstable TSC
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com> <1276587259-32319-6-git-send-email-zamsden@redhat.com>
In-Reply-To: <1276587259-32319-6-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 10:34 AM, Zachary Amsden wrote:
> SMP VMs on machines with unstable TSC have their TSC offset adjusted by the
> local offset delta from last measurement.  This does not take into account how
> long it has been since the measurement, leading to drift.  Minimize the drift
> by accounting for any time difference the kernel has observed.
>
> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
> ---
>   arch/x86/include/asm/kvm_host.h |    1 +
>   arch/x86/kvm/x86.c              |   20 +++++++++++++++++++-
>   2 files changed, 20 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 94f6ce8..1afecd7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -337,6 +337,7 @@ struct kvm_vcpu_arch {
>   	unsigned int time_offset;
>   	struct page *time_page;
>   	u64 last_host_tsc;
> +	u64 last_host_ns;
>
>   	bool nmi_pending;
>   	bool nmi_injected;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 618c435..b1bdf05 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1810,6 +1810,19 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   		/* Make sure TSC doesn't go backwards */
>   		s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :
>   				native_read_tsc() - vcpu->arch.last_host_tsc;
> +
> +		/* Subtract elapsed cycle time from the delta computation */
> +		if (check_tsc_unstable()&&  vcpu->arch.last_host_ns) {
> +			s64 delta;
> +			struct timespec ts;
> +			ktime_get_ts(&ts);
> +			monotonic_to_bootbased(&ts);
> +			delta = timespec_to_ns(&ts) - vcpu->arch.last_host_ns;
> +			delta = delta * per_cpu(cpu_tsc_khz, cpu);
> +			delta = delta / USEC_PER_SEC;
> +			tsc_delta -= delta;
> +		}
> +
>   		if (tsc_delta<  0 || check_tsc_unstable())
>   			kvm_x86_ops->adjust_tsc_offset(vcpu, -tsc_delta);
>   		kvm_migrate_timers(vcpu);
> @@ -1832,8 +1845,13 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>   	 * vcpu->cpu != cpu can not detect this condition.  So set
>   	 * vcpu->cpu = -1 to force the recalibration above.
>   	 */
> -	if (check_tsc_unstable())
> +	if (check_tsc_unstable()) {
> +		struct timespec ts;
> +		ktime_get_ts(&ts);
> +		monotonic_to_bootbased(&ts);
> +		vcpu->arch.last_host_ns = timespec_to_ns(&ts);
>   		vcpu->cpu = -1;
> +	}
>   }
>    

Is there no way to do this calculation entirely with ktime_ts?  struct 
timespec has nasty multiplies and divides.

-- 
error compiling committee.c: too many arguments to function

