Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab1JZGVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 02:21:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12958 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab1JZGVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 02:21:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=hrYsgxcaKd4pwW7RTjbfsjWCD7llt/ZEEY/JvApw/dDjlU1uMjnz2HD2WpFY5DjWC
	1HU9t0iA2RiVwAhexQ3Mw==
Date: Tue, 25 Oct 2011 23:21:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eial Czerwacki <eial@scalemp.com>
cc: linux-kernel@vger.kernel.org,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Subject: Re: [PATCH] APICID: Avoid false sharing on the read mostly
 x86_cpu_to_apicid
In-Reply-To: <4EA6A265.1080506@scalemp.com>
Message-ID: <alpine.DEB.2.00.1110252318090.20273@chino.kir.corp.google.com>
References: <4EA66960.7050907@scalemp.com> <9B14D1490DDECA4E974F6B9FC9EBAB3140CD274367@VMBX108.ihostexchange.net> <4EA6A265.1080506@scalemp.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Oct 2011, Eial Czerwacki wrote:

> Avoid false sharing on the read mostly x86_cpu_to_apicid by moving it to
> __read_mostly section.

x86_cpu_to_apicid used to be in .init.data and now it's never freed after 
boot?

> The per-cpu area is write and read and this symbol shows up high on ipi
> intensive/x86_cpu_to_apicid load.
> 
> Signed-off-by: Eial Czerwacki<eial@scalemp.com>
> Signed-off-by: Shai Fultheim<shai@scalemp.com>
> Author: Ravikiran Thirumalai<kiran@scalex86.org>

If the author isn't you, then the patch should start with a single line 
that says "From: name <email>" of the author followed by a blank line.  
It's also strange that the author doesn't have a sign-off line.

Your email client also has corrupted the inline patch, please see 
Documentation/email-clients.txt.

And, finally, please send this to the x86 maintainers once fixed.  See 
./scripts/get_maintainers.pl <your patch>.

> Index: b/arch/x86/include/asm/smp.h
> ===================================================================
> --- a/arch/x86/include/asm/smp.h	2010-06-01 09:56:03.000000000 -0700
> +++ b/arch/x86/include/asm/smp.h	2010-06-02 15:59:21.000000000 -0700
> @@ -36,7 +36,8 @@ static inline struct cpumask *cpu_core_m
>   	return per_cpu(cpu_core_map, cpu);
>   }
> 
> -DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
> +extern u16 x86_cpu_to_apicid[NR_CPUS];
> +
>   DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
> 
>   /* Static state in head.S used to set up a CPU */
> @@ -142,7 +143,7 @@ void native_send_call_func_ipi(const str
>   void native_send_call_func_single_ipi(int cpu);
> 
>   void smp_store_cpu_info(int id);
> -#define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
> +#define cpu_physical_id(cpu)	x86_cpu_to_apicid[cpu]
> 
>   /* We don't mark CPUs online until __cpu_up(), so we need another measure */
>   static inline int num_booting_cpus(void)
> Index: b/arch/x86/kernel/acpi/boot.c
> ===================================================================
> --- a/arch/x86/kernel/acpi/boot.c	2010-06-01 09:56:03.000000000 -0700
> +++ b/arch/x86/kernel/acpi/boot.c	2010-06-02 15:59:21.000000000 -0700
> @@ -568,7 +568,7 @@ EXPORT_SYMBOL(acpi_map_lsapic);
> 
>   int acpi_unmap_lsapic(int cpu)
>   {
> -	per_cpu(x86_cpu_to_apicid, cpu) = -1;
> +	x86_cpu_to_apicid[cpu] = -1;
>   	set_cpu_present(cpu, false);
>   	num_processors--;
> 

Shouldn't this be BAD_APICID?  Not sure where we check for -1.
