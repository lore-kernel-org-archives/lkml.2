Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab0JXJsc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 05:48:32 -0400
Received: from www.tglx.de ([62.245.132.106]:52781 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152Ab0JXJsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 05:48:31 -0400
Date: Sun, 24 Oct 2010 11:47:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/15] x86, apic: Fix lapic mapping with construct ISA
 and visws mptable path
In-Reply-To: <1287882149-29275-3-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.LFD.2.00.1010241146210.2466@localhost6.localdomain6>
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org> <1287882149-29275-3-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Oct 2010, Yinghai Lu wrote:

> Do need to set lapic mapping for them
> 
> in arch/x86/kernel/visws_quirks.c:
> we only have visws_find_smp_config() to set mp_lapic_addr to APIC_DEFAULT_PHYS_BASE
> visws_get_smp_config() is nop call.
> default_get_smp_config/check_physptr/smp_read_mpc is not called in the path.
> So smp_register_lapic_address() is not called, and lapic is not mapped.

-ENOPARSE. visws maps the APIC itself already in cobalt_init()

> in arch/x86/kernel/mpparse.c
> if mpf->feature1 != 0, it will go through contruct_default_ISA_mptable instead
> of check_phystr path, so smp_register_lapic_address is not called.
> 
> Those pathes all have smp_found_config set.
> 
> So need to remove !smp_found_config checking

Need ? You can, because the check is redundant if I understand the
above correctly.

Thanks,

	tglx

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/kernel/apic/apic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 4638396..193e407 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -1677,7 +1677,7 @@ void __init init_apic_mappings(void)
>  		 * acpi lapic path already maps that address in
>  		 * acpi_register_lapic_address()
>  		 */
> -		if (!acpi_lapic && !smp_found_config)
> +		if (!acpi_lapic)
>  			set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
>  
>  		apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
> -- 
> 1.7.1
> 
