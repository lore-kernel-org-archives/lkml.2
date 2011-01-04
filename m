Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab1ADSVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 13:21:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab1ADSVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 13:21:06 -0500
Date: Tue, 4 Jan 2011 16:20:30 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM Clock Synchronization 4/4] Add master clock for KVM clock
Message-ID: <20110104182030.GA3220@amt.cnet>
References: <1293601100-32109-1-git-send-email-zamsden@redhat.com>
 <1293601100-32109-5-git-send-email-zamsden@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293601100-32109-5-git-send-email-zamsden@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 07:38:20PM -1000, Zachary Amsden wrote:
> On systems with synchronized TSCs, we still have VCPU individual
> KVM clocks, each with their own computed offset.  As this all happens
> at different times, the computed KVM clock offset can vary, causing a
> globally visible backwards clock.  Currently this is protected against
> by using an atomic compare to ensure it does not happen.
> 
> This change should remove that requirement.
> 
> Signed-off-by: Zachary Amsden <zamsden@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    1 +
>  arch/x86/kvm/x86.c              |   42 ++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 42 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 8d829b8..ff651b7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -445,6 +445,7 @@ struct kvm_arch {
>  	unsigned long irq_sources_bitmap;
>  	s64 kvmclock_offset;
>  	spinlock_t clock_lock;
> +	struct pvclock_vcpu_time_info master_clock;
>  	u64 last_tsc_nsec;
>  	u64 last_tsc_offset;
>  	u64 last_tsc_write;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 59d5999..a339e50 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1116,6 +1116,38 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  		return 0;
>  
>  	/*
> +	 * If there is a stable TSC, we use a master reference clock for
> +	 * the KVM clock; otherwise, individual computations for each VCPU
> +	 * would exhibit slight drift relative to each other, which could
> +	 * cause global time to go backwards.
> +	 *
> +	 * If the master clock has no TSC timestamp, that means we must
> +	 * recompute the clock as either some real time has elapsed during
> +	 * a suspend cycle, or we are measuring the clock for the first time
> +	 * during VM creation (or following a migration).  Since master clock
> +	 * changes should happen only at rare occasions, so we can ignore
> +	 * the precautions below.
> +	 */
> +	if (!check_tsc_unstable()) {
> +		struct pvclock_vcpu_time_info *master =
> +						&v->kvm->arch.master_clock;
> +		if (vcpu->hv_clock.version != master->version) {
> +			spin_lock(&v->kvm->arch.clock_lock);
> +			WARN_ON(master->version < vcpu->hv_clock.version);
> +			if (!master->tsc_timestamp) {
> +				pr_debug("KVM: computing new master clock\n");
> +				update_pvclock(v, master, tsc_timestamp,
> +						kernel_ns, tsc_khz);
> +			}
> +			memcpy(&vcpu->hv_clock, master, sizeof(*master));
> +			spin_unlock(&v->kvm->arch.clock_lock);
> +			update_user_kvmclock(v, &vcpu->hv_clock);
> +		} else
> +			pr_debug("ignoring spurious KVM clock update");
> +		return 0;
> +	}

This assumes guest TSC is synchronized across vcpus... Is this always
true?

Also, for stable TSC hosts, kvmclock update is performed only on VM
creation / host resume these days... Can you describe the problem in
more detail?

