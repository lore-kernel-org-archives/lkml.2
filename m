Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762237Ab0HGAJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 20:09:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39245 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762200Ab0HGAJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 20:09:08 -0400
Message-ID: <4C5CA3E4.1080908@kernel.org>
Date: Fri, 06 Aug 2010 17:08:04 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, tvrtko.ursulin@sophos.com,
        hilld@binarystorm.net, tglx@linutronix.de, hpa@linux.intel.com
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, apic: Map the local apic when parsing the
 MP table.
References: <m1eiee86jg.fsf_-_@fess.ebiederm.org> <tip-5989cd6a1cbf86587edcc856791f960978087311@git.kernel.org>
In-Reply-To: <tip-5989cd6a1cbf86587edcc856791f960978087311@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2010 05:15 PM, tip-bot for Eric W. Biederman wrote:
> Commit-ID:  5989cd6a1cbf86587edcc856791f960978087311
> Gitweb:     http://git.kernel.org/tip/5989cd6a1cbf86587edcc856791f960978087311
> Author:     Eric W. Biederman <ebiederm@xmission.com>
> AuthorDate: Wed, 4 Aug 2010 13:30:27 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Thu, 5 Aug 2010 16:26:42 -0700
> 
> x86, apic: Map the local apic when parsing the MP table.
> 
> This fixes a regression in 2.6.35 from 2.6.34, that is
> present for select models of Intel cpus when people are
> using an MP table.
> 
> The commit cf7500c0ea133d66f8449d86392d83f840102632
> "x86, ioapic: In mpparse use mp_register_ioapic" started
> calling mp_register_ioapic from MP_ioapic_info.  An extremely
> simple change that was obviously correct.  Unfortunately
> mp_register_ioapic did just a little more than the previous
> hand crafted code and so we gained this call path.
> 
> The problem call path is:
> MP_ioapic_info()
>   mp_register_ioapic()
>    io_apic_unique_id()
>      io_apic_get_unique_id()
>        get_physical_broadcast()
>          modern_apic()
>            lapic_get_version()
>              apic_read(APIC_LVR)
> 
> Which turned out to be a problem because the local apic
> was not mapped, at that point, unlike the similar point
> in the ACPI parsing code.
> 
> This problem is fixed by mapping the local apic when
> parsing the mptable as soon as we reasonably can.
> 
> Looking at the number of places we setup the fixmap for
> the local apic, I see some serious simplification opportunities.
> For the moment except for not duplicating the setting up of the
> fixmap in init_apic_mappings, I have not acted on them.
> 
> The regression from 2.6.34 is tracked in bug
> https://bugzilla.kernel.org/show_bug.cgi?id=16173
> 
> Cc: <stable@kernel.org> 2.6.35
> Reported-by: David Hill <hilld@binarystorm.net>
> Reported-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
> Tested-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> LKML-Reference: <m1eiee86jg.fsf_-_@fess.ebiederm.org>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/kernel/apic/apic.c |    2 +-
>  arch/x86/kernel/mpparse.c   |   16 ++++++++++++++++
>  2 files changed, 17 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index a96489e..c07e513 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -1606,7 +1606,7 @@ void __init init_apic_mappings(void)
>  		 * acpi lapic path already maps that address in
>  		 * acpi_register_lapic_address()
>  		 */
> -		if (!acpi_lapic)
> +		if (!acpi_lapic && !smp_found_config)
>  			set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
>  
>  		apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
this change is not needed, it will break:
1. found mptable, but is using default contruct path.
2. visws path, found found mptable, but get_smp_conf is not called.

YH
