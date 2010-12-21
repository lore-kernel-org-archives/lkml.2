Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213Ab0LURPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 12:15:51 -0500
Received: from claw.goop.org ([74.207.240.146]:56985 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab0LURPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 12:15:50 -0500
Message-ID: <4D10E0C2.3020000@goop.org>
Date: Tue, 21 Dec 2010 09:15:46 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 1/2] apic: Move hypervisor detection of x2apic to hypervisor.h
References: <1292912329-12451-1-git-send-email-sheng@linux.intel.com>
In-Reply-To: <1292912329-12451-1-git-send-email-sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2010 10:18 PM, Sheng Yang wrote:
> Then we can reuse it for Xen later.

You should probably get someone kvm-ish to ack this too.

    J

> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Signed-off-by: Sheng Yang <sheng@linux.intel.com>
> ---
>  arch/x86/include/asm/hypervisor.h |    9 +++++++++
>  arch/x86/kernel/apic/apic.c       |    5 +++--
>  2 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
> index ff2546c..0c6f7af 100644
> --- a/arch/x86/include/asm/hypervisor.h
> +++ b/arch/x86/include/asm/hypervisor.h
> @@ -20,6 +20,8 @@
>  #ifndef _ASM_X86_HYPERVISOR_H
>  #define _ASM_X86_HYPERVISOR_H
>  
> +#include <asm/kvm_para.h>
> +
>  extern void init_hypervisor(struct cpuinfo_x86 *c);
>  extern void init_hypervisor_platform(void);
>  
> @@ -47,4 +49,11 @@ extern const struct hypervisor_x86 x86_hyper_vmware;
>  extern const struct hypervisor_x86 x86_hyper_ms_hyperv;
>  extern const struct hypervisor_x86 x86_hyper_xen_hvm;
>  
> +static inline bool hypervisor_x2apic_available(void)
> +{
> +	if (kvm_para_available())
> +		return true;
> +	return false;
> +}
> +
>  #endif
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 3f838d5..8408f2d 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -50,8 +50,8 @@
>  #include <asm/mtrr.h>
>  #include <asm/smp.h>
>  #include <asm/mce.h>
> -#include <asm/kvm_para.h>
>  #include <asm/tsc.h>
> +#include <asm/hypervisor.h>
>  
>  unsigned int num_processors;
>  
> @@ -1476,7 +1476,8 @@ void __init enable_IR_x2apic(void)
>  		/* IR is required if there is APIC ID > 255 even when running
>  		 * under KVM
>  		 */
> -		if (max_physical_apicid > 255 || !kvm_para_available())
> +		if (max_physical_apicid > 255 ||
> +		    !hypervisor_x2apic_available())
>  			goto nox2apic;
>  		/*
>  		 * without IR all CPUs can be addressed by IOAPIC/MSI

