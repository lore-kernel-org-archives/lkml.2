Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab1J1CYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 22:24:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378Ab1J1CYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 22:24:45 -0400
Date: Fri, 28 Oct 2011 00:14:58 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: avi@redhat.com, mingo@redhat.com, x86@kernel.org, hpa@zytor.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com
Subject: Re: [PATCH 6/6] Add age out of guest paused flag
Message-ID: <20111028021458.GB13000@amt.cnet>
References: <1319570779-8907-1-git-send-email-emunson@mgebm.net>
 <1319570779-8907-7-git-send-email-emunson@mgebm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319570779-8907-7-git-send-email-emunson@mgebm.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 03:26:19PM -0400, Eric B Munson wrote:
> The KVM_GUEST_PAUSED flag will prevent a guest from compaining about a soft
> lockup but it can mask real soft lockups if the flag isn't cleared when it is
> no longer relevant.  This patch adds a kvm ioctl that the hypervisor will use
> when it resumes a guest to start a timer for aging out the flag.  The time out
> will be specified by the hypervisor in the ioctl call.
> 
> Signed-off-by: Eric B Munson <emunson@mgebm.net>
> ---
>  arch/x86/include/asm/pvclock.h |    2 ++
>  arch/x86/kernel/kvmclock.c     |   24 ++++++++++++++++++++++++
>  arch/x86/kvm/x86.c             |    9 +++++++++
>  include/linux/kvm.h            |    2 ++
>  include/linux/kvm_host.h       |    2 ++
>  5 files changed, 39 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclock.h
> index 9312814..e8460b9 100644
> --- a/arch/x86/include/asm/pvclock.h
> +++ b/arch/x86/include/asm/pvclock.h
> @@ -18,6 +18,8 @@ void kvm_set_host_stopped(struct kvm_vcpu *vcpu);
>  
>  bool kvm_check_and_clear_host_stopped(int cpu);
>  
> +void kvm_clear_guest_paused(struct kvm_vcpu *vcpu, unsigned int length);
> +
>  /*
>   * Scale a 64-bit delta by scaling and multiplying by a 32-bit fraction,
>   * yielding a 64-bit result.
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index f4fff3d..f3f3935 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -23,6 +23,8 @@
>  #include <asm/apic.h>
>  #include <linux/percpu.h>
>  #include <linux/kvm_host.h>
> +#include <linux/kobject.h>
> +#include <linux/sysfs.h>
>  
>  #include <asm/x86_init.h>
>  #include <asm/reboot.h>
> @@ -144,6 +146,28 @@ bool kvm_check_and_clear_host_stopped(int cpu)
>  	return ret;
>  }
>  
> +static void kvm_timer_clear_guest_paused(unsigned long vcpu_addr)
> +{
> +	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)vcpu_addr;
> +	struct pvclock_vcpu_time_info *src = &vcpu->arch.hv_clock;
> +	src->flags = src->flags & (!PVCLOCK_GUEST_STOPPED);
> +}
> +
> +/*
> + * Host has resumed the guest, we need to clear the guest paused flag so we
> + * don't mask any real soft lockups.
> + */
> +void kvm_clear_guest_paused(struct kvm_vcpu *vcpu, unsigned int length)
> +{
> +	if (!timer_pending(&vcpu->flag_timer))
> +		setup_timer(&vcpu->flag_timer,
> +			    kvm_timer_clear_guest_paused,
> +			    (unsigned long)vcpu);
> +	mod_timer(&vcpu->flag_timer,
> +		  jiffies + (length * HZ));
> +}
> +EXPORT_SYMBOL_GPL(kvm_clear_guest_paused);

So this is why the scheme could become awkward. You can't determine a   
value for length that will guarantee that _no_ genuine softlockup is    
omitted.                                                                

Can you think of a way to achieve this?

Also note, all host code is located in arch/x86/kvm, guest 
code in arch/x86/kernel/kvmclock.c.

