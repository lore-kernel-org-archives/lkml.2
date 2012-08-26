Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab2HZSwh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 14:52:37 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60944 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753518Ab2HZSwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 14:52:36 -0400
Date: Sun, 26 Aug 2012 20:52:33 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, joro@8bytes.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 18/19] x86, io_apic: Introduce eoi_ioapic_pin call-back
Message-ID: <20120826185233.GJ3690@breakpoint.cc>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-19-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345470965-24410-19-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 03:56:04PM +0200, Joerg Roedel wrote:
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index aac3f62..d4db390 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -557,19 +557,10 @@ static void unmask_ioapic_irq(struct irq_data *data)
>   * Otherwise, we simulate the EOI message manually by changing the trigger
>   * mode to edge and then back to level, with RTE being masked during this.
>   */
> -static void __eoi_ioapic_pin(int apic, int pin, int vector, struct irq_cfg *cfg)
> +void native_eoi_ioapic_pin(int apic, int pin, int vector)
>  {
>  	if (mpc_ioapic_ver(apic) >= 0x20) {
> -		/*
> -		 * Intr-remapping uses pin number as the virtual vector
> -		 * in the RTE. Actual vector is programmed in
> -		 * intr-remapping table entry. Hence for the io-apic
> -		 * EOI we use the pin number.
> -		 */
> -		if (cfg && irq_remapped(cfg))
> -			io_apic_eoi(apic, pin);
> -		else
> -			io_apic_eoi(apic, vector);
> +		io_apic_eoi(apic, vector);
>  	} else {
>  		struct IO_APIC_route_entry entry, entry1;
>  
> diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
> index e61a174..d62e757 100644
> --- a/drivers/iommu/irq_remapping.c
> +++ b/drivers/iommu/irq_remapping.c
> @@ -94,12 +94,24 @@ static void __init irq_remapping_setup_timer_pin(unsigned int ioapic_idx,
>  	/* Not needed with interrupt remapping */
>  }
>  
> +void eoi_ioapic_pin_remapped(int apic, int pin, int vector)
> +{
> +	/*
> +	 * Intr-remapping uses pin number as the virtual vector
> +	 * in the RTE. Actual vector is programmed in
> +	 * intr-remapping table entry. Hence for the io-apic
> +	 * EOI we use the pin number.
> +	 */
> +	io_apic_eoi(apic, pin);
> +}
> +

Basically you shuffle the code from up there, down there and call from behind
a function pointer. There are two things different this time:
- no version check >= 0x20
  I belive this is obsolete since this runs only on x86-64 with x(2)apic
  support and assumes more or less version 0x20+ or we wouldn't be here at
  all.
- the irq_remapped(cfg) check is gone. The cfg thing is per-interrupt basis
  created so you _now_ you act like the interrupt is remapped even if it is
  not. Or am I wrong here?

> @@ -316,3 +328,4 @@ bool setup_remapped_irq(int irq, struct irq_cfg *cfg, struct irq_chip *chip)
>  		return false;
>  	}
>  }
> +
New line and the end? Why would that be?

Sebastian
