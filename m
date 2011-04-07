Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab1DGB0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 21:26:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:9026 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887Ab1DGB0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 21:26:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,313,1299484800"; 
   d="scan'208";a="676182375"
Date: Thu, 7 Apr 2011 09:30:21 +0800
From: Feng Tang <feng.tang@intel.com>
To: <jacob.jun.pan@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>, <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        <arjan@linux.intel.com>, <alan@linux.intel.com>
Subject: Re: [PATCH] x86/mrst: move sfi timer irqs after gsi_top
Message-ID: <20110407093021.1a778324@feng-i7>
In-Reply-To: <BANLkTi=VZCtNnx2dK9hgWmUVGb8ntMrxuw@mail.gmail.com>
References: <1301962175-4336-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<BANLkTi=VZCtNnx2dK9hgWmUVGb8ntMrxuw@mail.gmail.com>
Organization: intel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacob,

The mrst vrtc driver has the similar irq number problem in 2.6.39-rc2,
how about the following patch to solve it in ioapic code.

Also I saw NR_IRQS_LEGACY are used in several other places of io_apic code,
it may has some potential issue for mrst which I'm not sure.

Thanks,
Feng
---------------------

>From 9bfe95ca6b1737a0418c6403f9684da9fb844cbf Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Thu, 7 Apr 2011 09:08:00 +0800
Subject: [PATCH] x86: ioapic: use legacy_pic->nr_legacy_irqs instead of NR_IRQS_LEGACY for pin_2_irq()

legacy_pic->nr_legacy_irqs has the correct number of legacy irqs for
a x86 platform (legacy PC, Moorestown etc).

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 68df09b..2dcad66 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -954,7 +954,7 @@ static int pin_2_irq(int idx, int apic, int pin)
 	} else {
 		u32 gsi = mp_gsi_routing[apic].gsi_base + pin;
 
-		if (gsi >= NR_IRQS_LEGACY)
+		if (gsi >= legacy_pic->nr_legacy_irqs)
 			irq = gsi;
 		else
 			irq = gsi_top + gsi;
-- 
1.7.0.4

> From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Date: 2011/4/5
> Subject: [PATCH] x86/mrst: move sfi timer irqs after gsi_top
> To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin"
> <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>, Thomas Gleixner
> <tglx@linutronix.de>, Arjan van de Ven <arjan@linux.intel.com>, Alan
> Cox <alan@linux.intel.com>
> ³­ËÍ£º Jacob Pan <jacob.jun.pan@linux.intel.com>
> 
> 
> Moorestown borrows mp_irqs for its early SFI device IRQs, it used
> to be 1:1 mapped between irq # and ioapic pin#. After gsi_top is
> introduced, we have to allocate irqs on top of gsi_top since below
> that irqs are not set to ioapic chip whereas Moorestown SFI device
> irqs are all routed via ioapic chip.
> 
> Without this fix, Moorestown fails to boot at secondary clock setup
> since it cannot do request_irq on cpu 1 timer which does not have a
> valid irq_chip.
> 
> Also use correct MP configuration table entry type INTSRC, which is
> used for IO interrupt assignment.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  arch/x86/kernel/apb_timer.c   |    2 +-
>  arch/x86/platform/mrst/mrst.c |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
> index cd1ffed..f9f82cb 100644
> --- a/arch/x86/kernel/apb_timer.c
> +++ b/arch/x86/kernel/apb_timer.c
> @@ -630,7 +630,7 @@ void __init apbt_time_init(void)
>                p_mtmr = sfi_get_mtmr(i);
>                if (p_mtmr) {
>                        adev->tick = p_mtmr->freq_hz;
> -                       adev->irq = p_mtmr->irq;
> +                       adev->irq = p_mtmr->irq + gsi_top;
>                } else
>                        printk(KERN_ERR "Failed to get timer for cpu
> %d\n", i); adev->count = 0;
> diff --git a/arch/x86/platform/mrst/mrst.c
> b/arch/x86/platform/mrst/mrst.c index 5c0207b..448c20d 100644
> --- a/arch/x86/platform/mrst/mrst.c
> +++ b/arch/x86/platform/mrst/mrst.c
> @@ -97,12 +97,12 @@ static int __init sfi_parse_mtmr(struct
> sfi_table_header *table)
>                        pentry->freq_hz, pentry->irq);
>                        if (!pentry->irq)
>                                continue;
> -                       mp_irq.type = MP_IOAPIC;
> +                       mp_irq.type = MP_INTSRC;
>                        mp_irq.irqtype = mp_INT;
>  /* triggering mode edge bit 2-3, active high polarity bit 0-1 */
>                        mp_irq.irqflag = 5;
>                        mp_irq.srcbus = 0;
> -                       mp_irq.srcbusirq = pentry->irq; /* IRQ */
> +                       mp_irq.srcbusirq = pentry->irq + gsi_top; /*
> IRQ */ mp_irq.dstapic = MP_APIC_ALL;
>                        mp_irq.dstirq = pentry->irq;
>                        mp_save_irq(&mp_irq);
> --
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
