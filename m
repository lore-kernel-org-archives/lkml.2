Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab1GYH3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 03:29:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36000 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab1GYH30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 03:29:26 -0400
Date: Mon, 25 Jul 2011 09:28:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, ioapic: Print out irte  with right ioapic index
Message-ID: <20110725072831.GB22518@elte.hu>
References: <4E1F0BC9.1040102@kernel.org>
 <CAErSpo5CzU2j81moWLsHDoRxTs5107=AEAWYi3ezy3Xfw86qiQ@mail.gmail.com>
 <4E29BEEA.4020600@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E29BEEA.4020600@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> 
> While checking irte dump in dmesg, the print out is confused ioapic index
> and real io apic id.
> 
> IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:31 Dest:00000001 SID:00FF SQ:0 SVT:1)
> IOAPIC[0]: Set routing entry (1-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000001 SID:00FF SQ:0 SVT:1)
> 
> The system first ioapic id is 1.
> 
> Try to fix it with passing ioapic idx instead of phys apic id.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/apic/io_apic.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
> +++ linux-2.6/arch/x86/kernel/apic/io_apic.c
> @@ -1255,7 +1255,7 @@ static void ioapic_register_intr(unsigne
>  				      fasteoi ? "fasteoi" : "edge");
>  }
>  
> -static int setup_ioapic_entry(int apic_id, int irq,
> +static int setup_ioapic_entry(int ioapic, int irq,
>  			      struct IO_APIC_route_entry *entry,
>  			      unsigned int destination, int trigger,
>  			      int polarity, int vector, int pin)
> @@ -1266,6 +1266,7 @@ static int setup_ioapic_entry(int apic_i
>  	memset(entry,0,sizeof(*entry));
>  
>  	if (intr_remapping_enabled) {
> +		int apic_id = mpc_ioapic_id(ioapic);
>  		struct intel_iommu *iommu = map_ioapic_to_ir(apic_id);
>  		struct irte irte;
>  		struct IR_IO_APIC_route_entry *ir_entry =

Patch looks good to me in principle, but please clean up this code 
before we put more effort into it.

Firstly, your patch introduces an uncleanliness. I'm not telling you 
what it is because you made that mistake so many times in the past 
that i must assume that you are using me as a coding style compiler 
in essence - that's not very efficient for me, please avoid repeat 
mistakes and improve your patches.

Secondly, the code it modifies has a couple of easily visible 
uncleanlinesses and structure problems which should be fixed first in 
a separate patch, before the printout fix is applied. The function it 
modifies is too large (and has a few style errors in it), etc. etc.

Thanks,

	Ingo
