Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab1LVKLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 05:11:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374Ab1LVKLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 05:11:16 -0500
Message-ID: <4EF30236.1040204@redhat.com>
Date: Thu, 22 Dec 2011 12:11:02 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Eric B Munson <emunson@mgebm.net>
CC: mingo@redhat.com, hpa@zytor.com, arnd@arndb.de, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, mtosatti@redhat.com,
        jeremy.fitzhardinge@citrix.com, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 V7] Add ioctl for KVMCLOCK_GUEST_STOPPED
References: <1323978126-13222-1-git-send-email-emunson@mgebm.net> <1323978126-13222-4-git-send-email-emunson@mgebm.net>
In-Reply-To: <1323978126-13222-4-git-send-email-emunson@mgebm.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2011 09:42 PM, Eric B Munson wrote:
> Now that we have a flag that will tell the guest it was suspended, create an
> interface for that communication using a KVM ioctl.
>
>  
> +int kvm_set_guest_paused(struct kvm_vcpu *vcpu);

Please avoid the needless forward declaration.

> +
>  extern bool tdp_enabled;
>  
>  u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c38efd7..1dab5fd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3295,6 +3295,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  
>  		goto out;
>  	}
> +	case KVMCLOCK_GUEST_PAUSED: {
> +		r = kvm_set_guest_paused(vcpu);
> +		break;
> +	}
>  	default:
>  		r = -EINVAL;
>  	}
> @@ -6117,6 +6121,22 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int reason,
>  }
>  EXPORT_SYMBOL_GPL(kvm_task_switch);
>  
> +/*
> + * kvm_set_guest_paused() indicates to the guest kernel that it has been
> + * stopped by the hypervisor.  This function will be called from the host only.
> + * EINVAL is returned when the host attempts to set the flag for a guest that
> + * does not support pv clocks.
> + */
> +int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
> +{
> +	struct pvclock_vcpu_time_info *src = &vcpu->arch.hv_clock;
> +	if (!vcpu->arch.time_page)
> +		return -EINVAL;
> +	src->flags |= PVCLOCK_GUEST_STOPPED;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kvm_set_guest_paused);
> +
>

You're writing to a page without mark_page_dirty(), this breaks live
migration.

-- 
error compiling committee.c: too many arguments to function

