Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934027Ab0GOSRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:17:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:29641 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933979Ab0GOSRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:17:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,209,1278313200"; 
   d="scan'208";a="818502557"
Subject: Re: [PATCH] x86: fix x2apic preenabled system with kexec
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@kernel.org>
In-Reply-To: <4C3EB22B.3000701@kernel.org>
References: <4C3BD6AA.3070908@kernel.org> <4C3CE210.2030902@zytor.com>
	 <4C3CF650.30905@kernel.org> <4C3E1FA0.9000107@kernel.org>
	 <4C3E2AE6.30406@kernel.org>  <4C3E40EC.5060607@kernel.org>
	 <1279152189.2849.260.camel@sbs-t61.sc.intel.com>
	 <4C3EB22B.3000701@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 15 Jul 2010 11:16:24 -0700
Message-Id: <1279217784.2751.7.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-15 at 00:00 -0700, Yinghai Lu wrote:
> Found one x2apic system kexec loop test failed 
> when CONFIG_NMI_WATCHDOG=y (old) or CONFIG_LOCKUP_DETECTOR=y (current tip)
> 
> first kernel can kexec second kernel, but second kernel can not kexec third one.
> 
> it can be duplicated on another system with BIOS preenabled x2apic.
> First kernel can not kexec second kernel.
> 
> It turns out, when kernel boot with pre-enabled x2apic, it will not execute
> disable_local_APIC on shutdown path.
> 
> when init_apic_mappings() is called in setup_arch, it will skip setting of
> apic_phys when x2apic_mode is set. ( x2apic_mode is much early check_x2apic())
> Then later, disable_local_APIC() will bail out early because !apic_phys.
> 
> So check !x2apic_mode in x2apic_mode in disable_local_APIC with !apic_phys.

Thanks for the nice debug work! As we still have NMI enabled, it looks
like we get a NMI during kexec and as we reset gdt/idt before kexec
launch, we might get a triple fault causing the system to reboot.

> another solution could be updating init_apic_mappings() to set apic_phys even
> for preenabled x2apic system. Actually even for x2apic system, that lapic
> address is mapped already in early stage.

Below patch is the right one. We should probably unmap apic_phys mapping
when x2apic is enabled by the OS.


> BTW: is there any x2apic preenabled system with apicid of boot cpu > 255?

I am not sure. There might be one. Is there any bug which can't handle
this condition?

> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: stable@kernel.org

For this patch:

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

> ---
>  arch/x86/kernel/apic/apic.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/arch/x86/kernel/apic/apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/apic.c
> +++ linux-2.6/arch/x86/kernel/apic/apic.c
> @@ -921,7 +921,7 @@ void disable_local_APIC(void)
>  	unsigned int value;
>  
>  	/* APIC hasn't been mapped yet */
> -	if (!apic_phys)
> +	if (!x2apic_mode && !apic_phys)
>  		return;
>  
>  	clear_local_APIC();



