Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab0FOIY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 04:24:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089Ab0FOIYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 04:24:53 -0400
Message-ID: <4C1738D4.3070008@redhat.com>
Date: Tue, 15 Jun 2010 11:24:52 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: mtosatti@redhat.com, glommer@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/17] Add clock sync request to hardware enable
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com> <1276587259-32319-9-git-send-email-zamsden@redhat.com>
In-Reply-To: <1276587259-32319-9-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 10:34 AM, Zachary Amsden wrote:
> If there are active VCPUs which are marked as belonging to
> a particular hardware CPU, request a clock sync for them when
> enabling hardware; the TSC could be desynchronized on a newly
> arriving CPU, and we need to recompute guests system time
> relative to boot after a suspend event.
>
> This covers both cases.
>
> Note that it is acceptable to take the spinlock, as either
> no other tasks will be running and no locks held (BSP after
> resume), or other tasks will be guaranteed to drop the lock
> relatively quickly (AP on CPU_STARTING).
>
> Noting we now get clock synchronization requests for VCPUs
> which are starting up (or restarting), it is tempting to
> attempt to remove the arch/x86/kvm/x86.c CPU hot-notifiers
> at this time, however it is not correct to do so; they are
> required for systems with non-constant TSC as the frequency
> may not be known immediately after the processor has started
> until the cpufreq driver has had a chance to run and query
> the chipset.
>
> Updated: implement better locking semantics for hardware_enable
>
> Removed the hack of dropping and retaking the lock by adding the
> semantic that we always hold kvm_lock when hardware_enable is
> called.  The one place that doesn't need to worry about it is
> resume, as resuming a frozen CPU, the spinlock won't be taken.
>
> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
> ---
>   arch/x86/kvm/x86.c  |    8 ++++++++
>   virt/kvm/kvm_main.c |    6 +++++-
>   2 files changed, 13 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4b15d03..05c559d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5442,7 +5442,15 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
>
>   int kvm_arch_hardware_enable(void *garbage)
>   {
> +	struct kvm *kvm;
> +	struct kvm_vcpu *vcpu;
> +	int i;
> +
>   	kvm_shared_msr_cpu_online();
> +	list_for_each_entry(kvm,&vm_list, vm_list)
> +		kvm_for_each_vcpu(i, vcpu, kvm)
> +			if (vcpu->cpu == smp_processor_id())
> +				kvm_request_guest_time_update(vcpu);
>   	return kvm_x86_ops->hardware_enable(garbage);
>   }
>
>    

An alternative to this loop (and a similar one in the cpu frequency 
notifier earlier) is to have a per-cpu cpu_freq_generation_counter, 
which is checked on every entry against a snapshot of the counter in the 
vcpu.  This would replace the loop with an O(1) mechanism, at the cost 
of another compare.

I don't think it's worthwhile at this point though, just something to 
keep in mind.

-- 
error compiling committee.c: too many arguments to function

