Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab2JaBdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 21:33:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756075Ab2JaBdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 21:33:06 -0400
Date: Tue, 30 Oct 2012 22:18:22 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: x86@kernel.org, kexec@lists.infradead.org, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86/kexec: VMCLEAR vmcss on all cpus if necessary
Message-ID: <20121031001822.GA21986@amt.cnet>
References: <5080E813.7030302@cn.fujitsu.com>
 <5080E8BF.3020506@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5080E8BF.3020506@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 01:44:31PM +0800, Zhang Yanfei wrote:
> This patch provides a way to VMCLEAR vmcss related to guests
> on all cpus before executing the VMXOFF when doing kdump. This
> is used to ensure the VMCSs in the vmcore updated and
> non-corrupted.
> 
> Signed-off-by: zhangyanfei <zhangyanfei@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/kexec.h |    2 ++
>  arch/x86/kernel/crash.c      |   27 +++++++++++++++++++++++++++
>  2 files changed, 29 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
> index 317ff17..fc05440 100644
> --- a/arch/x86/include/asm/kexec.h
> +++ b/arch/x86/include/asm/kexec.h
> @@ -163,6 +163,8 @@ struct kimage_arch {
>  };
>  #endif
>  
> +extern void (*crash_clear_loaded_vmcss)(void);
> +
>  #endif /* __ASSEMBLY__ */
>  
>  #endif /* _ASM_X86_KEXEC_H */
> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> index 13ad899..7289976 100644
> --- a/arch/x86/kernel/crash.c
> +++ b/arch/x86/kernel/crash.c
> @@ -16,6 +16,7 @@
>  #include <linux/delay.h>
>  #include <linux/elf.h>
>  #include <linux/elfcore.h>
> +#include <linux/module.h>
>  
>  #include <asm/processor.h>
>  #include <asm/hardirq.h>
> @@ -30,6 +31,22 @@
>  
>  int in_crash_kexec;
>  
> +/*
> + * This is used to VMCLEAR vmcss loaded on all
> + * cpus. And when loading kvm_intel module, the
> + * function pointer will be made valid.
> + */
> +void (*crash_clear_loaded_vmcss)(void) = NULL;
> +EXPORT_SYMBOL_GPL(crash_clear_loaded_vmcss);
> +
> +static void cpu_emergency_clear_loaded_vmcss(void)
> +{
> +	if (crash_clear_loaded_vmcss &&
> +	    cpu_has_vmx() && cpu_vmx_enabled()) {
> +		crash_clear_loaded_vmcss();
> +	}
> +}
> +

Are all this checks necessary? 

if (crash_clear_loaded_vmcss)
	crash_clear_loaded_vmcss();

Should be enough ? (callback only set if kvm-vmx module loaded).

>  #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
>  
>  static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
> @@ -46,6 +63,11 @@ static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
>  #endif
>  	crash_save_cpu(regs, cpu);
>  
> +	/*
> +	 * VMCLEAR vmcss loaded on all cpus if needed.
> +	 */
> +	cpu_emergency_clear_loaded_vmcss();
> +
>  	/* Disable VMX or SVM if needed.
>  	 *
>  	 * We need to disable virtualization on all CPUs.
> @@ -88,6 +110,11 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
>  
>  	kdump_nmi_shootdown_cpus();
>  
> +	/*
> +	 * VMCLEAR vmcss loaded on this cpu if needed.
> +	 */
> +	cpu_emergency_clear_loaded_vmcss();
> +
>  	/* Booting kdump kernel with VMX or SVM enabled won't work,
>  	 * because (among other limitations) we can't disable paging
>  	 * with the virt flags.
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
