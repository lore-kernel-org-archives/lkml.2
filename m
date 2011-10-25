Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab1JZBIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:08:38 -0400
Received: from claw.goop.org ([74.207.240.146]:46955 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395Ab1JZBIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:08:37 -0400
Message-ID: <4EA7017B.5000903@goop.org>
Date: Tue, 25 Oct 2011 11:35:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        "x86@kernel.org" <x86@kernel.org>, KVM <kvm@vger.kernel.org>,
        Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Yinghai Lu <yinghai@kernel.org>, Sedat Dilek <sedat.dilek@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xen <xen-devel@lists.xensource.com>, Avi Kivity <avi@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC V2 5/5] kvm guest : pv-ticketlocks support for linux
 guests running on KVM hypervisor
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com> <20111023190753.16364.31164.sendpatchset@oc5400248562.ibm.com>
In-Reply-To: <20111023190753.16364.31164.sendpatchset@oc5400248562.ibm.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2011 12:07 PM, Raghavendra K T wrote:
> This patch extends Linux guests running on KVM hypervisor to support
> pv-ticketlocks. Very early during bootup, paravirtualied KVM guest detects if 
> the hypervisor has required feature (KVM_FEATURE_WAIT_FOR_KICK) to support 
> pv-ticketlocks. If so, support for pv-ticketlocks is registered via pv_lock_ops.
>
> Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 2874c19..c7f34b7 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -195,10 +195,18 @@ void kvm_async_pf_task_wait(u32 token);
>  void kvm_async_pf_task_wake(u32 token);
>  u32 kvm_read_and_reset_pf_reason(void);
>  extern void kvm_disable_steal_time(void);
> -#else
> +
> +#ifdef CONFIG_PARAVIRT_SPINLOCKS
> +void __init kvm_guest_early_init(void);
> +#else /* CONFIG_PARAVIRT_SPINLOCKS */
> +#define kvm_guest_early_init() do { } while (0)
> +#endif /* CONFIG_PARAVIRT_SPINLOCKS */
> +
> +#else /* CONFIG_KVM_GUEST */
>  #define kvm_guest_init() do { } while (0)
>  #define kvm_async_pf_task_wait(T) do {} while(0)
>  #define kvm_async_pf_task_wake(T) do {} while(0)
> +#define kvm_guest_early_init() do { } while (0)
>  static inline u32 kvm_read_and_reset_pf_reason(void)
>  {
>  	return 0;
> diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
> index 3bb0850..fb25bca 100644
> --- a/arch/x86/kernel/head32.c
> +++ b/arch/x86/kernel/head32.c
> @@ -9,6 +9,7 @@
>  #include <linux/start_kernel.h>
>  #include <linux/mm.h>
>  #include <linux/memblock.h>
> +#include <linux/kvm_para.h>
>  
>  #include <asm/setup.h>
>  #include <asm/sections.h>
> @@ -59,6 +60,8 @@ void __init i386_start_kernel(void)
>  		break;
>  	}
>  
> +	 kvm_guest_early_init();
> +
>  	/*
>  	 * At this point everything still needed from the boot loader
>  	 * or BIOS or kernel text should be early reserved or marked not
> diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
> index 5655c22..cabf8ec 100644
> --- a/arch/x86/kernel/head64.c
> +++ b/arch/x86/kernel/head64.c
> @@ -13,6 +13,7 @@
>  #include <linux/start_kernel.h>
>  #include <linux/io.h>
>  #include <linux/memblock.h>
> +#include <linux/kvm_para.h>
>  
>  #include <asm/processor.h>
>  #include <asm/proto.h>
> @@ -115,6 +116,8 @@ void __init x86_64_start_reservations(char *real_mode_data)
>  
>  	reserve_ebda_region();
>  
> +	kvm_guest_early_init();
> +
>  	/*
>  	 * At this point everything still needed from the boot loader
>  	 * or BIOS or kernel text should be early reserved or marked not
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index a9c2116..f4f341f 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -39,6 +39,16 @@
>  #include <asm/desc.h>
>  #include <asm/tlbflush.h>
>  
> +#ifdef CONFIG_PARAVIRT_SPINLOCKS
> +
> +#ifdef CONFIG_KVM_DEBUG_FS
> +
> +#include <linux/debugfs.h>
> +
> +#endif /* CONFIG_KVM_DEBUG_FS */
> +
> +#endif /* CONFIG_PARAVIRT_SPINLOCKS */

This is a big mess.  Is there any problem with including linux/debugfs.h
unconditionally?  Or at least using "#if
defined(CONFIG_PARAVIRT_SPINLOCKS) && defined(CONFIG_KVM_DEBUG_FS)"?

    J
