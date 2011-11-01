Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab1KATdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 15:33:35 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48293 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab1KATdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 15:33:33 -0400
Message-ID: <4EB04940.2030506@us.ibm.com>
Date: Tue, 01 Nov 2011 14:32:16 -0500
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: Eric B Munson <emunson@mgebm.net>
CC: avi@redhat.com, mingo@redhat.com, x86@kernel.org, hpa@zytor.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, ryanh@linux.vnet.ibm.com
Subject: Re: [PATCH 3/6 V2] Add ioctl for KVM_GUEST_STOPPED
References: <1320091650-24682-1-git-send-email-emunson@mgebm.net> <1320091650-24682-4-git-send-email-emunson@mgebm.net>
In-Reply-To: <1320091650-24682-4-git-send-email-emunson@mgebm.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11110119-2398-0000-0000-0000018F5368
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2011 03:07 PM, Eric B Munson wrote:
> Now that we have a flag that will tell the guest it was suspended, create an
> interface for that communication using a KVM ioctl.
>
> Signed-off-by: Eric B Munson<emunson@mgebm.net>
> ---
> Changes from V1:
>   Add kvm_set_host_stopped to arch/x86/jvm/x86.c instead of kvmclock.c
>   Rename KVM_PAUSE_GUEST to KVM_GUEST_PAUSED
>
>   arch/x86/include/asm/pvclock.h |    3 +++
>   arch/x86/kvm/x86.c             |   16 ++++++++++++++++
>   include/linux/kvm.h            |    2 ++
>   3 files changed, 21 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclock.h
> index 7d3ba41..9312814 100644
> --- a/arch/x86/include/asm/pvclock.h
> +++ b/arch/x86/include/asm/pvclock.h
> @@ -3,6 +3,7 @@
>
>   #include<linux/clocksource.h>
>   #include<asm/pvclock-abi.h>
> +#include<linux/kvm_host.h>
>
>   /* some helper functions for xen and kvm pv clock sources */
>   cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src);
> @@ -13,6 +14,8 @@ void pvclock_read_wallclock(struct pvclock_wall_clock *wall,
>   			    struct timespec *ts);
>   void pvclock_resume(void);
>
> +void kvm_set_host_stopped(struct kvm_vcpu *vcpu);

This can't go in pvclock.h.

> +
>   bool kvm_check_and_clear_host_stopped(int cpu);
>
>   /*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c38efd7..592ac3b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3295,6 +3295,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>
>   		goto out;
>   	}
> +	case KVM_GUEST_PAUSED: {
> +		r = 0;
> +		kvm_set_host_stopped(vcpu);
> +		break;
> +	}
>   	default:
>   		r = -EINVAL;
>   	}
> @@ -6117,6 +6122,17 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int reason,
>   }
>   EXPORT_SYMBOL_GPL(kvm_task_switch);
>
> +/*
> + * kvm_set_host_stopped() indicates to the guest kernel that it has been
> + * stopped by the hypervisor.  This function will be called from the host only.
> + */
> +void kvm_set_host_stopped(struct kvm_vcpu *vcpu)
> +{
> +	struct pvclock_vcpu_time_info *src =&vcpu->arch.hv_clock;
> +	src->flags |= PVCLOCK_GUEST_STOPPED;

Shouldn't we throw some sort of error if you're trying to set a flag and 
kvmclock isn't enabled?

Regards,

Anthony Liguori

> +}
> +EXPORT_SYMBOL_GPL(kvm_set_host_stopped);
> +
>   int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
>   				  struct kvm_sregs *sregs)
>   {
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index f47fcd3..87cab0d 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -763,6 +763,8 @@ struct kvm_clock_data {
>   #define KVM_CREATE_SPAPR_TCE	  _IOW(KVMIO,  0xa8, struct kvm_create_spapr_tce)
>   /* Available with KVM_CAP_RMA */
>   #define KVM_ALLOCATE_RMA	  _IOR(KVMIO,  0xa9, struct kvm_allocate_rma)
> +/* VM is being stopped by host */
> +#define KVM_GUEST_PAUSED	  _IO(KVMIO,   0xaa)
>
>   #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1<<  0)
>

