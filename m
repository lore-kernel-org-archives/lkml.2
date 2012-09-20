Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab2ITWXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 18:23:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:57620 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756238Ab2ITWW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 18:22:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,455,1344236400"; 
   d="scan'208";a="195223794"
Subject: Re: [PATCH] fix x2apic defect that Linux kernel doesn't mask 8259A
 interrupt during the time window between changing VT-d table base address
 and initializing these VT-d entries
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Zhang, Lin-Bao (ESSN-MCXS-Linux Kernel R&D)" <linbao.zhang@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Croxon, Nigel" <nigel.croxon@hp.com>
Date: Thu, 20 Sep 2012 15:22:49 -0700
In-Reply-To: <92645B27BF79D04FBD2B0F8494FFD0F9095637@G1W3648.americas.hpqcorp.net>
References: <92645B27BF79D04FBD2B0F8494FFD0F9095637@G1W3648.americas.hpqcorp.net>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1348179770.26695.351.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 07:02 +0000, Zhang, Lin-Bao (ESSN-MCXS-Linux
Kernel R&D) wrote:
> Hi all, 
> This defect can be observed when the x2apic setting in BIOS is set to
> "auto" and the BIOS has virtual wire mode enabled on a power up. This
> defect was found on a 2.6.32 based kernel.

I assume you are able to reproduce the issue with the latest kernel
aswell?

What virtual wire mode is it?

Virtual wire mode-A (where the PIC output is connected to LINT0 of the
Local APIC) doesn't go through interrupt-remapping and virtual wire
mode-B (where the PIC output is routed through the IO-APIC RTE) will be
completely disabled as all the BIOS setup IO-APIC RTE's are masked by
the Linux kernel from the time we enable interrupt-remapping to the time
IO-APIC RTE's are properly re-configured by the Linux kernel again.

So I am at a loss to understand what is causing this.

> 
> The kernel code (smpboot.c, apic.c) does not mask 8259A interrupts
> before changing and initializing the new VT-d table when x2apic
> virtual wire mode is enable on power up. The Linux Kernel expects
> virtual wire mode to be disabled when booting and enables it when
> interrupts are masked.
> 
> The BIOS code builds a simple VT-d table on power up. While the Linux
> Kernel boots, it first builds an empty VT-d table and use it. After
> some time, the Linux Kernel then initializes the IO-APIC redirect
> table, and then initializes the VT-d entries. The window between
> initializing the redirect table and the VT-d entries, the 8259A
> interrupts are not masked. If an interrupt occurs in this window, the
> Linux Kernel will not find a valid entry for this interrupt. The
> kernel treats it to be a fatal error and panics. If the error never
> gets cleared, the Linux kernel continuously print this error:
> "NMI: IOCK error (debug interrupt?) for reason"

Not sure why we get a NMI instead of a vt-d fault? Perhaps the vt-d
fault is also getting reported via NMI in this platform?

Does your tested kernel has this fix?
commit 254e42006c893f45bca48f313536fcba12206418
Author: Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Mon Dec 6 12:26:30 2010 -0800

    x86, vt-d: Quirk for masking vtd spec errors to platform error handling logic

Will you be able to provide the failing kernel log so that I can better
understand the issue?

thanks,
suresh

> The fix to this defect, the code change is to mask 8259A interrupts
> before changing VT-d table and initializing VT-d entries. Then unmask
> interrupts after completing the redirect table entries.
> 
> 
> Signed-off-by: Zhang, Lin-Bao <linbao.zhang@hp.com>
> Tested-by: Nigel Croxon <nigel.croxon@hp.com>
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c index 24deb30..299172c 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -1556,7 +1556,6 @@ void __init enable_IR_x2apic(void)
>         }
> 
>         local_irq_save(flags);
> -       legacy_pic->mask_all();
>         mask_ioapic_entries();
> 
>         if (x2apic_preenabled && nox2apic) @@ -1603,7 +1602,6 @@ void __init enable_IR_x2apic(void)
>  skip_x2apic:
>         if (ret < 0) /* IR enabling failed */
>                 restore_ioapic_entries();
> -       legacy_pic->restore_mask();
>         local_irq_restore(flags);
>  }
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c index 7c5a8c3..95fee01 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1000,7 +1000,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
>                 zalloc_cpumask_var(&per_cpu(cpu_llc_shared_map, i), GFP_KERNEL);
>         }
>         set_cpu_sibling_map(0);
> -
> +       mask_8259A();
> 
>         if (smp_sanity_check(max_cpus) < 0) {
>                 pr_info("SMP disabled\n"); @@ -1037,6 +1037,8 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
>                 apic->setup_portio_remap();
> 
>         smpboot_setup_io_apic();
> +       unmask_8259A();
> +
>         /*
>          * Set up local APIC timer on boot CPU.
>          */
> 
> 
> 
> -- Bob(Zhang LinBao)
> 子曰：”不患人知不己知,患不知人也”
> "If not us, who ? if not now, when ?"
> ESSN-MCBS linux kernel enginner
> 
> 
> NР骒rybX肚v^?藓{.n?伐{赙zXФ≤}财z?j:+v?赙zZ+?zf＂h~iz?wア?ㄨ??撷f^j谦ym@Aa囤0鹅h?i


