Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab1J1CYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 22:24:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab1J1CYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 22:24:45 -0400
Date: Thu, 27 Oct 2011 23:52:48 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: avi@redhat.com, mingo@redhat.com, x86@kernel.org, hpa@zytor.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com
Subject: Re: [PATCH 3/6] Add ioctl for KVM_GUEST_STOPPED
Message-ID: <20111028015248.GA13000@amt.cnet>
References: <1319570779-8907-1-git-send-email-emunson@mgebm.net>
 <1319570779-8907-4-git-send-email-emunson@mgebm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319570779-8907-4-git-send-email-emunson@mgebm.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 03:26:16PM -0400, Eric B Munson wrote:
> Now that we have a flag that will tell the guest it was suspended, create an
> interface for that communication using a KVM ioctl.
> 
> Signed-off-by: Eric B Munson <emunson@mgebm.net>
> ---
>  arch/x86/include/asm/pvclock.h |    3 +++
>  arch/x86/kernel/kvmclock.c     |   12 ++++++++++++
>  arch/x86/kvm/x86.c             |    5 +++++
>  include/linux/kvm.h            |    2 ++
>  4 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclock.h
> index 7d3ba41..9312814 100644
> --- a/arch/x86/include/asm/pvclock.h
> +++ b/arch/x86/include/asm/pvclock.h
> @@ -3,6 +3,7 @@
>  
>  #include <linux/clocksource.h>
>  #include <asm/pvclock-abi.h>
> +#include <linux/kvm_host.h>
>  
>  /* some helper functions for xen and kvm pv clock sources */
>  cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src);
> @@ -13,6 +14,8 @@ void pvclock_read_wallclock(struct pvclock_wall_clock *wall,
>  			    struct timespec *ts);
>  void pvclock_resume(void);
>  
> +void kvm_set_host_stopped(struct kvm_vcpu *vcpu);
> +
>  bool kvm_check_and_clear_host_stopped(int cpu);
>  
>  /*
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index 8ddcfaf..f4fff3d 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -22,6 +22,7 @@
>  #include <asm/msr.h>
>  #include <asm/apic.h>
>  #include <linux/percpu.h>
> +#include <linux/kvm_host.h>
>  
>  #include <asm/x86_init.h>
>  #include <asm/reboot.h>
> @@ -113,6 +114,17 @@ static void kvm_get_preset_lpj(void)
>  	preset_lpj = lpj;
>  }
>  
> +/*
> + * kvm_set_host_stopped() indicates to the guest kernel that it has been
> + * stopped by the hypervisor.  This function will be called from the host only.
> + */
> +void kvm_set_host_stopped(struct kvm_vcpu *vcpu)
> +{
> +	struct pvclock_vcpu_time_info *src = &vcpu->arch.hv_clock;
> +	src->flags |= PVCLOCK_GUEST_STOPPED;
> +}
> +EXPORT_SYMBOL_GPL(kvm_set_host_stopped);
> +
>  bool kvm_check_and_clear_host_stopped(int cpu)
>  {
>  	bool ret = false;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 84a28ea..16e029e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3264,6 +3264,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  
>  		goto out;
>  	}
> +	case KVM_PAUSE_GUEST: {

Pause guest?? :)

> +		r = 0;
> +		kvm_set_host_stopped(vcpu);
> +		break;
> +	}
>  	default:
>  		r = -EINVAL;
>  	}
