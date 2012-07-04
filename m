Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab2GDGzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 02:55:49 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61389 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2GDGzr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 02:55:47 -0400
MIME-Version: 1.0
Date: Wed, 4 Jul 2012 14:55:47 +0800
Message-ID: <CANuKePntggbPrY7=eq-+AHzqcPG4Y6UGnP+9B57Gs2xNLeCR_A@mail.gmail.com>
Subject: why Linux kernel will update BIOS's interrupt remapping table base
 address ? why does Linux Kernel create a new table instead of the one that
 BIOS provided ?
From: Lin-Bao Zhang <2004.zhang@gmail.com>
To: flyboy@gmail.com, yinghai@kernel.org, suresh.b.siddha@intel.com
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,


my questions are :
1, Linux kernel will create a new interrupt remapping table to replace
BIOS' table ?
we guys used ITP to know that BIOS' interrupt remapping table pointer
has been changed . I am tracing related code to see how linux kernel
creates interrupt remapping table.

2, why ? why linux kernel doesn't directly use BIOS' table ?   our
bios has enabled x2apic mode ,and also export interrupt remapping
table

3, what is the relationship between interrupt remapping table with
"virtual wire mode B" , now , if firmware disabled "virtual wire mode
B" , linux kernel won't panic , otherwise , linux kernel will panic .

thanks for your replies .

from following commit messages , I have known that BIOS should provide
a interrupt remapping table and export to OS.
-------------------------------------------------------------------------------
commit fb209bd891645bb87b9618b724f0b4928e0df3de
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Wed Dec 21 17:45:17 2011 -0800

    x86, x2apic: Fallback to xapic when BIOS doesn't setup interrupt-remapping

    On some of the recent Intel SNB platforms, by default bios is pre-enabling
    x2apic mode in the cpu with out setting up interrupt-remapping.
    This case was resulting in the kernel to panic as the cpu is already in
    x2apic mode but the OS was not able to enable interrupt-remapping (which
    is a pre-req for using x2apic capability).

    On these platforms all the apic-ids are < 255 and the kernel can fallback to
    xapic mode if the bios has not enabled interrupt-remapping (which is
    mostly the case if the bios has not exported interrupt-remapping
tables to the
    OS).
    -------------------------------------------------------------------------------------

But now , I am carefully checking apic.c code to trace how interrupt
remapping table is enabled again by linux kernel.


struct smp_ops smp_ops  define native_smp_prepare_cpus() functions ->
native_smp_prepare_cpus() -> default_setup_apic_routing() ->
enable_IR_x2apic() -> enable_IR() -> enable_intr_remapping() ->
setup_intr_remapping() -> iommu_set_intr_remapping()
I check iommu_set_intr_remapping() function , it seems that it indeed
modify INTR remapping base addr.

FYI:
This function indeed follow “Intel VT for direct IO.pdf” ‘s P109
static void iommu_set_intr_remapping(struct intel_iommu *iommu, int mode)
{
   u64 addr;
   u32 sts;
   unsigned long flags;

   addr = virt_to_phys((void *)iommu->ir_table->base);

   raw_spin_lock_irqsave(&iommu->register_lock, flags);

   dmar_writeq(iommu->reg + DMAR_IRTA_REG,   // #define DMAR_IRTA_REG
0xb8 /* Interrupt remapping table addr register */
          (addr) | IR_X2APIC_MODE(mode) | INTR_REMAP_TABLE_REG_SIZE);

   /* Set interrupt-remapping table pointer */
   iommu->gcmd |= DMA_GCMD_SIRTP;     //P109 in Intel VT-d for direct
IO.pdf  from ftp://download.intel.com/technology/computing/vptech/Intel(r)_VT_for_Direct_IO.pdf
   writel(iommu->gcmd, iommu->reg + DMAR_GCMD_REG);

   IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
            readl, (sts & DMA_GSTS_IRTPS), sts);
   raw_spin_unlock_irqrestore(&iommu->register_lock, flags);

   /*
   * global invalidation of interrupt entry cache before enabling
   * interrupt-remapping.
   */
   qi_global_iec(iommu);

   raw_spin_lock_irqsave(&iommu->register_lock, flags);

   /* Enable interrupt-remapping */
   iommu->gcmd |= DMA_GCMD_IRE;
   writel(iommu->gcmd, iommu->reg + DMAR_GCMD_REG);

   IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
            readl, (sts & DMA_GSTS_IRES), sts);

   raw_spin_unlock_irqrestore(&iommu->register_lock, flags);
}
