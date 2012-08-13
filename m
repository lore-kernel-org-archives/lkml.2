Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab2HMWJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:09:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876Ab2HMWJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:09:21 -0400
Date: Mon, 13 Aug 2012 18:52:31 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: kvm@vger.kernel.org, avi@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: disable stealtime via reboot notifier to avoid mem
 corruption
Message-ID: <20120813215231.GA19294@amt.cnet>
References: <1344594982-8516-1-git-send-email-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344594982-8516-1-git-send-email-fw@strlen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 12:36:22PM +0200, Florian Westphal wrote:
> else, we get memory corruption on reboot; found when tracking down
> initramfs unpack error on initial reboot (with qemu-kvm -smp 2,
> no problem with single-core).
> 
> problem with doing it via kvm_shutdown() is that this file
> depends on CONFIG_KVM_CLOCK, also its not enough to call it for one
> cpu only.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  not subscribed, please CC on replies.
>  Also, I don't know much about kvm or kexec, so its possible
>  that i missed something.
> 
>  In any case, this seems to fix the initramfs corruption for me.
>  patch is against virt/kvm/kvm.git.
> 
>  arch/x86/kernel/kvm.c      |    1 +
>  arch/x86/kernel/kvmclock.c |    1 -
>  2 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index c1d61ee..1596cc8 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -354,6 +354,7 @@ static void kvm_pv_guest_cpu_reboot(void *unused)
>  	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
>  		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
>  	kvm_pv_disable_apf();
> +	kvm_disable_steal_time();
>  }
>  
>  static int kvm_pv_reboot_notify(struct notifier_block *nb,

This part below will introduce a bug for shutdown. Can you retest with
the addition of kvm_disable_steal_time to kvm_pv_guest_cpu_reboot only,
retest and resend please?

Thanks

> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index f1b42b3..5a2fa7d 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -191,7 +191,6 @@ static void kvm_crash_shutdown(struct pt_regs *regs)
>  static void kvm_shutdown(void)
>  {
>  	native_write_msr(msr_kvm_system_time, 0, 0);
> -	kvm_disable_steal_time();
>  	native_machine_shutdown();
>  }
>  
> -- 
> 1.7.8.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
