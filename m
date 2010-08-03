Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab0HCDN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 23:13:57 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59750 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab0HCDN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 23:13:56 -0400
To: Yinghai Lu <yinghai@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: oops in ioapic_write_entry
References: <AANLkTimeFuABgQHJzq38uJ-4gTQbfSRfQBb91P+NPwCS@mail.gmail.com>
	<AANLkTimqDPvTqOZiBgUn7t4JJhgQU4ShVTsCJEzV=8fR@mail.gmail.com>
	<AANLkTi=sNRwxmv8aKN_jo7tAx6SQ-AOFfAXJxcPnNZQp@mail.gmail.com>
	<4C577197.9020003@kernel.org> <4C57723C.1060400@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 02 Aug 2010 20:13:51 -0700
In-Reply-To: <4C57723C.1060400@kernel.org> (Yinghai Lu's message of "Mon\, 02 Aug 2010 18\:34\:52 -0700")
Message-ID: <m1bp9k2xsg.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On 08/02/2010 06:32 PM, Yinghai Lu wrote:
>> On 08/02/2010 04:17 PM, Dave Airlie wrote:
>>>>
>>>> the kernel is using mptable, and the  system have mcp55, so how come
>>>> with irq 35?
>>>> assume we should only have ioapic irq 0 - 23 ...
>>>>
>>>> Can you send out boot log with "debug apic=debug pci=routeirq" with
>>>> 2.6.32 and 2.6.35?
>>>
>>> Okay el6log is from a RHEL6 2.6.32 kernel, but it should give a good
>>> baseline, the 2.6.35 oops even earlier with all those options and is
>>> in the second attachment.
>> 
>

This patch is wrong and there is no reason to even suspect it will
affect this problem.  At best this patch will trade one set of bugs
for another because at least on some platforms we always did something
like this.  Having an irq 35 is odd and certainly a result of recent
changes, but in this case it doesn't look like it has anything to do
with the problem.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

> please use this one instead..., forget to run quilt refresh before sending it.
>
> [PATCH -v2] x86: fix pin_2_irq mapping
>
> We should not twist gsi to irq mapping if acpi is not used.
>
> -v2 remove not used irq_to_gsi()
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> ---
>  arch/x86/include/asm/io_apic.h |   10 ++++++++++
>  arch/x86/kernel/acpi/boot.c    |    4 ++--
>  arch/x86/kernel/apic/io_apic.c |    5 +----
>  3 files changed, 13 insertions(+), 6 deletions(-)
>
> Index: linux-2.6/arch/x86/include/asm/io_apic.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/io_apic.h
> +++ linux-2.6/arch/x86/include/asm/io_apic.h
> @@ -185,6 +185,16 @@ int mp_find_ioapic_pin(int ioapic, u32 g
>  void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
>  extern void __init pre_init_apic_IRQ0(void);
>  
> +#ifdef CONFIG_ACPI
> +unsigned int gsi_to_irq(unsigned int gsi);
> +u32 irq_to_gsi(int irq);
> +#else
> +static inline unsigned int gsi_to_irq(unsigned int gsi)
> +{
> +	return gsi;
> +}
> +#endif
> +
>  #else  /* !CONFIG_X86_IO_APIC */
>  
>  #define io_apic_assign_pci_irqs 0
> Index: linux-2.6/arch/x86/kernel/acpi/boot.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
> +++ linux-2.6/arch/x86/kernel/acpi/boot.c
> @@ -100,7 +100,7 @@ static u32 isa_irq_to_gsi[NR_IRQS_LEGACY
>  	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
>  };
>  
> -static unsigned int gsi_to_irq(unsigned int gsi)
> +unsigned int gsi_to_irq(unsigned int gsi)
>  {
>  	unsigned int irq = gsi + NR_IRQS_LEGACY;
>  	unsigned int i;
> @@ -123,7 +123,7 @@ static unsigned int gsi_to_irq(unsigned
>  	return irq;
>  }
>  
> -static u32 irq_to_gsi(int irq)
> +u32 irq_to_gsi(int irq)
>  {
>  	unsigned int gsi;
>  
> Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
> +++ linux-2.6/arch/x86/kernel/apic/io_apic.c
> @@ -1029,10 +1029,7 @@ static int pin_2_irq(int idx, int apic,
>  	} else {
>  		u32 gsi = mp_gsi_routing[apic].gsi_base + pin;
>  
> -		if (gsi >= NR_IRQS_LEGACY)
> -			irq = gsi;
> -		else
> -			irq = gsi_top + gsi;
> +		irq = gsi_to_irq(gsi);
>  	}
>  
>  #ifdef CONFIG_X86_32
