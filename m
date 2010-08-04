Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab0HDVv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:51:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16465 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab0HDVvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:51:11 -0400
Message-ID: <4C59E074.1080400@kernel.org>
Date: Wed, 04 Aug 2010 14:49:40 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Renninger <trenn@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        David Hill <hilld@binarystorm.net>
Subject: Re: [PATCH] x86/apic: Map the local apic when parsing the MP table.
References: <201008031028.57263.tvrtko.ursulin@sophos.com>	<20100804093623.GE10499@redhat.com> <m1fwyuacjs.fsf@fess.ebiederm.org>	<201008041146.56406.tvrtko.ursulin@sophos.com> <m1eiee86jg.fsf_-_@fess.ebiederm.org>
In-Reply-To: <m1eiee86jg.fsf_-_@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C59E09B.01FB,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2010 01:30 PM, Eric W. Biederman wrote:
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
> Cc: stable@kernel.org
> Reported-by: David Hill <hilld@binarystorm.net>
> Reported-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
> Tested-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
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
> diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
> index d86dbf7..d7b6f7f 100644
> --- a/arch/x86/kernel/mpparse.c
> +++ b/arch/x86/kernel/mpparse.c
> @@ -274,6 +274,18 @@ static void __init smp_dump_mptable(struct mpc_table *mpc, unsigned char *mpt)
>  
>  void __init default_smp_read_mpc_oem(struct mpc_table *mpc) { }
>  
> +static void __init smp_register_lapic_address(unsigned long address)
> +{
> +	mp_lapic_addr = address;
> +
> +	set_fixmap_nocache(FIX_APIC_BASE, address);
> +	if (boot_cpu_physical_apicid == -1U) {
> +		boot_cpu_physical_apicid  = read_apic_id();
> +		apic_version[boot_cpu_physical_apicid] =
> +			 GET_APIC_VERSION(apic_read(APIC_LVR));
> +	}
> +}
> +
>  static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
>  {
>  	char str[16];
> @@ -295,6 +307,10 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
>  	if (early)
>  		return 1;
>  
> +	/* Initialize the lapic mapping */
> +	if (!acpi_lapic)
> +		smp_register_lapic_address(mpc->lapic);
> +
>  	if (mpc->oemptr)
>  		x86_init.mpparse.smp_read_mpc_oem(mpc);
>  

Acked-by: Yinghai Lu <yinghai@kernel.org>

will send out another two patches on top this one for cleanup.

Yinghai
