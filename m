Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab1BIIrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 03:47:14 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:36332 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab1BIIrM convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:2>);
	Wed, 9 Feb 2011 03:47:12 -0500
Message-Id: <4D5262C30200007800030F9C@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 09 Feb 2011 08:47:47 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <linux-kbuild@vger.kernel.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, "Jesse Barnes" <jbarnes@virtuousgeek.org>,
        <hpa@zytor.com>
Subject: [PATCH] move some .pci_fixup_* sections into .init
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.pci_fixup_final is only used from .init.text, and hence can (along
with the respective handler functions) reside in .init.*.

Several other .pci_fixup_* sections are needed only during boot and
suspend/resume, and can therefore be moved into .init.* if
!CONFIG_PM_OPS.

While generally section mismatch checking is being turned on by this
patch for all of .pci_fixup_*, for .pci_fixup_header it is being
suppressed for the moment as it caused way too much fallout.
Theoretically, all respective handlers must get their __init/__devinit
removed, as this gets processed from a non-__init, non-__devinit
function.

This also adds a previously missing comma in the definition of
ALL_INIT_DATA_SECTIONS.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>

---
 arch/x86/kernel/pci-dma.c         |    2 
 arch/x86/kernel/quirks.c          |    2 
 arch/x86/pci/fixup.c              |    6 +-
 drivers/clocksource/acpi_pm.c     |    6 +-
 drivers/pci/quirks.c              |   97 ++++++++++++++++++--------------------
 drivers/usb/host/pci-quirks.c     |    2 
 include/asm-generic/vmlinux.lds.h |   46 +++++++++---------
 scripts/mod/modpost.c             |   13 +++--
 8 files changed, 90 insertions(+), 84 deletions(-)

--- 2.6.38-rc4/arch/x86/kernel/pci-dma.c
+++ 2.6.38-rc4-pci-fixup-sections/arch/x86/kernel/pci-dma.c
@@ -312,7 +312,7 @@ rootfs_initcall(pci_iommu_init);
 #ifdef CONFIG_PCI
 /* Many VIA bridges seem to corrupt data for DAC. Disable it here */
 
-static __devinit void via_no_dac(struct pci_dev *dev)
+static __init void via_no_dac(struct pci_dev *dev)
 {
 	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI && forbid_dac == 0) {
 		dev_info(&dev->dev, "disabling DAC on VIA PCI bridge\n");
--- 2.6.38-rc4/arch/x86/kernel/quirks.c
+++ 2.6.38-rc4-pci-fixup-sections/arch/x86/kernel/quirks.c
@@ -8,7 +8,7 @@
 
 #if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_SMP) && defined(CONFIG_PCI)
 
-static void __devinit quirk_intel_irqbalance(struct pci_dev *dev)
+static void __init quirk_intel_irqbalance(struct pci_dev *dev)
 {
 	u8 config, rev;
 	u16 word;
--- 2.6.38-rc4/arch/x86/pci/fixup.c
+++ 2.6.38-rc4-pci-fixup-sections/arch/x86/pci/fixup.c
@@ -249,7 +249,7 @@ static struct pci_ops quirk_pcie_aspm_op
  * the root port in an array for fast indexing. Replace the bus ops
  * with the modified one.
  */
-static void pcie_rootport_aspm_quirk(struct pci_dev *pdev)
+static void __init pcie_rootport_aspm_quirk(struct pci_dev *pdev)
 {
 	int cap_base, i;
 	struct pci_bus  *pbus;
@@ -413,7 +413,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_V
  */
 static u16 toshiba_line_size;
 
-static const struct dmi_system_id __devinitconst toshiba_ohci1394_dmi_table[] = {
+static const struct dmi_system_id toshiba_ohci1394_dmi_table[] = {
 	{
 		.ident = "Toshiba PS5 based laptop",
 		.matches = {
@@ -449,7 +449,7 @@ static void __devinit pci_pre_fixup_tosh
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_TI, 0x8032,
 			 pci_pre_fixup_toshiba_ohci1394);
 
-static void __devinit pci_post_fixup_toshiba_ohci1394(struct pci_dev *dev)
+static void pci_post_fixup_toshiba_ohci1394(struct pci_dev *dev)
 {
 	if (!dmi_check_system(toshiba_ohci1394_dmi_table))
 		return; /* only applies to certain Toshibas (so far) */
--- 2.6.38-rc4/drivers/clocksource/acpi_pm.c
+++ 2.6.38-rc4-pci-fixup-sections/drivers/clocksource/acpi_pm.c
@@ -73,7 +73,7 @@ static struct clocksource clocksource_ac
 
 
 #ifdef CONFIG_PCI
-static int __devinitdata acpi_pm_good;
+static int acpi_pm_good;
 static int __init acpi_pm_good_setup(char *__str)
 {
 	acpi_pm_good = 1;
@@ -102,7 +102,7 @@ static inline void acpi_pm_need_workarou
  * incorrect when read). As a result, the ACPI free running count up
  * timer specification is violated due to erroneous reads.
  */
-static void __devinit acpi_pm_check_blacklist(struct pci_dev *dev)
+static void acpi_pm_check_blacklist(struct pci_dev *dev)
 {
 	if (acpi_pm_good)
 		return;
@@ -120,7 +120,7 @@ static void __devinit acpi_pm_check_blac
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82371AB_3,
 			acpi_pm_check_blacklist);
 
-static void __devinit acpi_pm_check_graylist(struct pci_dev *dev)
+static void acpi_pm_check_graylist(struct pci_dev *dev)
 {
 	if (acpi_pm_good)
 		return;
--- 2.6.38-rc4/drivers/pci/quirks.c
+++ 2.6.38-rc4-pci-fixup-sections/drivers/pci/quirks.c
@@ -97,7 +97,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI
  * key system devices. For devices that need to have mmio decoding always-on,
  * we need to set the dev->mmio_always_on bit.
  */
-static void __devinit quirk_mmio_always_on(struct pci_dev *dev)
+static void quirk_mmio_always_on(struct pci_dev *dev)
 {
 	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_HOST)
 		dev->mmio_always_on = 1;
@@ -108,7 +108,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_ANY_ID, PCI_
  * Mark this device with a broken_parity_status, to allow
  * PCI scanning code to "skip" this now blacklisted device.
  */
-static void __devinit quirk_mellanox_tavor(struct pci_dev *dev)
+static void __init quirk_mellanox_tavor(struct pci_dev *dev)
 {
 	dev->broken_parity_status = 1;	/* This device gives false positives */
 }
@@ -117,7 +117,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ME
 
 /* Deal with broken BIOS'es that neglect to enable passive release,
    which can cause problems in combination with the 82441FX/PPro MTRRs */
-static void quirk_passive_release(struct pci_dev *dev)
+static void __devinit quirk_passive_release(struct pci_dev *dev)
 {
 	struct pci_dev *d = NULL;
 	unsigned char dlc;
@@ -143,7 +143,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_I
     This appears to be BIOS not version dependent. So presumably there is a 
     chipset level fix */
     
-static void __devinit quirk_isa_dma_hangs(struct pci_dev *dev)
+static void __init quirk_isa_dma_hangs(struct pci_dev *dev)
 {
 	if (!isa_dma_bridge_buggy) {
 		isa_dma_bridge_buggy=1;
@@ -185,7 +185,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 /*
  *	Chipsets where PCI->PCI transfers vanish or hang
  */
-static void __devinit quirk_nopcipci(struct pci_dev *dev)
+static void __init quirk_nopcipci(struct pci_dev *dev)
 {
 	if ((pci_pci_problems & PCIPCI_FAIL)==0) {
 		dev_info(&dev->dev, "Disabling direct PCI/PCI transfers\n");
@@ -195,7 +195,7 @@ static void __devinit quirk_nopcipci(str
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SI,	PCI_DEVICE_ID_SI_5597,		quirk_nopcipci);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SI,	PCI_DEVICE_ID_SI_496,		quirk_nopcipci);
 
-static void __devinit quirk_nopciamd(struct pci_dev *dev)
+static void __init quirk_nopciamd(struct pci_dev *dev)
 {
 	u8 rev;
 	pci_read_config_byte(dev, 0x08, &rev);
@@ -210,7 +210,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AM
 /*
  *	Triton requires workarounds to be used by the drivers
  */
-static void __devinit quirk_triton(struct pci_dev *dev)
+static void __init quirk_triton(struct pci_dev *dev)
 {
 	if ((pci_pci_problems&PCIPCI_TRITON)==0) {
 		dev_info(&dev->dev, "Limiting direct PCI/PCI transfers\n");
@@ -233,7 +233,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
  *	Updated based on further information from the site and also on
  *	information provided by VIA 
  */
-static void quirk_vialatency(struct pci_dev *dev)
+static void __devinit quirk_vialatency(struct pci_dev *dev)
 {
 	struct pci_dev *p;
 	u8 busarb;
@@ -289,7 +289,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_V
 /*
  *	VIA Apollo VP3 needs ETBF on BT848/878
  */
-static void __devinit quirk_viaetbf(struct pci_dev *dev)
+static void __init quirk_viaetbf(struct pci_dev *dev)
 {
 	if ((pci_pci_problems&PCIPCI_VIAETBF)==0) {
 		dev_info(&dev->dev, "Limiting direct PCI/PCI transfers\n");
@@ -298,7 +298,7 @@ static void __devinit quirk_viaetbf(stru
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_82C597_0,	quirk_viaetbf);
 
-static void __devinit quirk_vsfx(struct pci_dev *dev)
+static void __init quirk_vsfx(struct pci_dev *dev)
 {
 	if ((pci_pci_problems&PCIPCI_VSFX)==0) {
 		dev_info(&dev->dev, "Limiting direct PCI/PCI transfers\n");
@@ -327,7 +327,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AL
  *	Natoma has some interesting boundary conditions with Zoran stuff
  *	at least
  */
-static void __devinit quirk_natoma(struct pci_dev *dev)
+static void __init quirk_natoma(struct pci_dev *dev)
 {
 	if ((pci_pci_problems&PCIPCI_NATOMA)==0) {
 		dev_info(&dev->dev, "Limiting direct PCI/PCI transfers\n");
@@ -412,7 +412,7 @@ static void __devinit quirk_io_region(st
  *	ATI Northbridge setups MCE the processor if you even
  *	read somewhere between 0x3b0->0x3bb or read 0x3d3
  */
-static void __devinit quirk_ati_exploding_mce(struct pci_dev *dev)
+static void __init quirk_ati_exploding_mce(struct pci_dev *dev)
 {
 	dev_info(&dev->dev, "ATI Northbridge, reserving I/O ports 0x3b0 to 0x3bb\n");
 	/* Mae rhaid i ni beidio ag edrych ar y lleoliadiau I/O hyn */
@@ -721,7 +721,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_V
  * TI XIO2000a PCIe-PCI Bridge erroneously reports it supports fast back-to-back:
  *	Disable fast back-to-back on the secondary bus segment
  */
-static void __devinit quirk_xio2000a(struct pci_dev *dev)
+static void __init quirk_xio2000a(struct pci_dev *dev)
 {
 	struct pci_dev *pdev;
 	u16 command;
@@ -748,7 +748,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_TI
  * TODO: When we have device-specific interrupt routers,
  * this code will go away from quirks.
  */
-static void quirk_via_ioapic(struct pci_dev *dev)
+static void __devinit quirk_via_ioapic(struct pci_dev *dev)
 {
 	u8 tmp;
 	
@@ -772,7 +772,7 @@ DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDO
  * Set this bit to get rid of cycle wastage.
  * Otherwise uncritical.
  */
-static void quirk_via_vt8237_bypass_apic_deassert(struct pci_dev *dev)
+static void __devinit quirk_via_vt8237_bypass_apic_deassert(struct pci_dev *dev)
 {
 	u8 misc_control2;
 #define BYPASS_APIC_DEASSERT 8
@@ -795,7 +795,7 @@ DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDO
  * noapic specified. For the moment we assume it's the erratum. We may be wrong
  * of course. However the advice is demonstrably good even if so..
  */
-static void __devinit quirk_amd_ioapic(struct pci_dev *dev)
+static void __init quirk_amd_ioapic(struct pci_dev *dev)
 {
 	if (dev->revision >= 0x02) {
 		dev_warn(&dev->dev, "I/O APIC: AMD Erratum #22 may be present. In the event of instability try\n");
@@ -954,7 +954,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_V
  * do this even if the Linux CardBus driver is not loaded, because
  * the Linux i82365 driver does not (and should not) handle CardBus.
  */
-static void quirk_cardbus_legacy(struct pci_dev *dev)
+static void __devinit quirk_cardbus_legacy(struct pci_dev *dev)
 {
 	if ((PCI_CLASS_BRIDGE_CARDBUS << 8) ^ dev->class)
 		return;
@@ -970,7 +970,7 @@ DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_ANY_I
  * To be fair to AMD, it follows the spec by default, its BIOS people
  * who turn it off!
  */
-static void quirk_amd_ordering(struct pci_dev *dev)
+static void __devinit quirk_amd_ordering(struct pci_dev *dev)
 {
 	u32 pcic;
 	pci_read_config_dword(dev, 0x4C, &pcic);
@@ -1020,7 +1020,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_T
  * datasheets found at http://www.national.com/analog for info on what
  * these bits do.  <christer@weinigel.se>
  */
-static void quirk_mediagx_master(struct pci_dev *dev)
+static void __devinit quirk_mediagx_master(struct pci_dev *dev)
 {
 	u8 reg;
 	pci_read_config_byte(dev, 0x41, &reg);
@@ -1038,7 +1038,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_C
  *	the BIOS but in the odd case it is not the results are corruption
  *	hence the presence of a Linux check
  */
-static void quirk_disable_pxb(struct pci_dev *pdev)
+static void __devinit quirk_disable_pxb(struct pci_dev *pdev)
 {
 	u16 config;
 	
@@ -1081,7 +1081,7 @@ DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDO
 /*
  *	Serverworks CSB5 IDE does not fully support native mode
  */
-static void __devinit quirk_svwks_csb5ide(struct pci_dev *pdev)
+static void quirk_svwks_csb5ide(struct pci_dev *pdev)
 {
 	u8 prog;
 	pci_read_config_byte(pdev, PCI_CLASS_PROG, &prog);
@@ -1097,7 +1097,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SE
 /*
  *	Intel 82801CAM ICH3-M datasheet says IDE modes must be the same
  */
-static void __init quirk_ide_samemode(struct pci_dev *pdev)
+static void quirk_ide_samemode(struct pci_dev *pdev)
 {
 	u8 prog;
 
@@ -1116,7 +1116,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_IN
  * Some ATA devices break if put into D3
  */
 
-static void __devinit quirk_no_ata_d3(struct pci_dev *pdev)
+static void quirk_no_ata_d3(struct pci_dev *pdev)
 {
 	/* Quirk the legacy ATA devices only. The AHCI ones are ok */
 	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE)
@@ -1573,7 +1573,7 @@ static void __init quirk_alder_ioapic(st
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_EESSC,	quirk_alder_ioapic);
 #endif
 
-static void __devinit quirk_pcie_mch(struct pci_dev *pdev)
+static void __init quirk_pcie_mch(struct pci_dev *pdev)
 {
 	pci_msi_off(pdev);
 	pdev->no_msi = 1;
@@ -1587,7 +1587,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
  * It's possible for the MSI to get corrupted if shpc and acpi
  * are used together on certain PXH-based systems.
  */
-static void __devinit quirk_pcie_pxh(struct pci_dev *dev)
+static void quirk_pcie_pxh(struct pci_dev *dev)
 {
 	pci_msi_off(dev);
 	dev->no_msi = 1;
@@ -1603,7 +1603,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_IN
  * Some Intel PCI Express chipsets have trouble with downstream
  * device power management.
  */
-static void quirk_intel_pcie_pm(struct pci_dev * dev)
+static void __init quirk_intel_pcie_pm(struct pci_dev * dev)
 {
 	pci_pm_d3_delay = 120;
 	dev->no_d1d2 = 1;
@@ -1638,7 +1638,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
  * that a PCI device's interrupt handler is installed on the boot interrupt
  * line instead.
  */
-static void quirk_reroute_to_boot_interrupts_intel(struct pci_dev *dev)
+static void __devinit quirk_reroute_to_boot_interrupts_intel(struct pci_dev *dev)
 {
 	if (noioapicquirk || noioapicreroute)
 		return;
@@ -1676,7 +1676,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_I
 #define INTEL_6300_IOAPIC_ABAR		0x40
 #define INTEL_6300_DISABLE_BOOT_IRQ	(1<<14)
 
-static void quirk_disable_intel_boot_interrupt(struct pci_dev *dev)
+static void __devinit quirk_disable_intel_boot_interrupt(struct pci_dev *dev)
 {
 	u16 pci_config_word;
 
@@ -1701,7 +1701,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_I
 #define BC_HT1000_MAP_IDX		0xC00
 #define BC_HT1000_MAP_DATA		0xC01
 
-static void quirk_disable_broadcom_boot_interrupt(struct pci_dev *dev)
+static void __devinit quirk_disable_broadcom_boot_interrupt(struct pci_dev *dev)
 {
 	u32 pci_config_dword;
 	u8 irq;
@@ -1739,7 +1739,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_S
 #define AMD_813X_REV_B1			0x12
 #define AMD_813X_REV_B2			0x13
 
-static void quirk_disable_amd_813x_boot_interrupt(struct pci_dev *dev)
+static void __devinit quirk_disable_amd_813x_boot_interrupt(struct pci_dev *dev)
 {
 	u32 pci_config_dword;
 
@@ -1763,7 +1763,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_A
 
 #define AMD_8111_PCI_IRQ_ROUTING	0x56
 
-static void quirk_disable_amd_8111_boot_interrupt(struct pci_dev *dev)
+static void __devinit quirk_disable_amd_8111_boot_interrupt(struct pci_dev *dev)
 {
 	u16 pci_config_word;
 
@@ -1840,7 +1840,7 @@ static void __devinit quirk_netmos(struc
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NETMOS, PCI_ANY_ID, quirk_netmos);
 
-static void __devinit quirk_e100_interrupt(struct pci_dev *dev)
+static void __init quirk_e100_interrupt(struct pci_dev *dev)
 {
 	u16 command, pmcsr;
 	u8 __iomem *csr;
@@ -1912,7 +1912,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
  * The 82575 and 82598 may experience data corruption issues when transitioning
  * out of L0S.  To prevent this we need to disable L0S on the pci-e link
  */
-static void __devinit quirk_disable_aspm_l0s(struct pci_dev *dev)
+static void __init quirk_disable_aspm_l0s(struct pci_dev *dev)
 {
 	dev_info(&dev->dev, "Disabling L0s\n");
 	pci_disable_link_state(dev, PCIE_LINK_STATE_L0S);
@@ -1975,7 +1975,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
  * The IOBL_ADR gets re-written to 4k boundaries in pci_setup_bridge()
  * in drivers/pci/setup-bus.c
  */
-static void __devinit quirk_p64h2_1k_io_fix_iobl(struct pci_dev *dev)
+static void __init quirk_p64h2_1k_io_fix_iobl(struct pci_dev *dev)
 {
 	u16 en1k, iobl_adr, iobl_adr_1k;
 	struct resource *res = dev->resource + PCI_BRIDGE_RESOURCES;
@@ -2000,7 +2000,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
  * Force it to be linked by setting the corresponding control bit in the
  * config space.
  */
-static void quirk_nvidia_ck804_pcie_aer_ext_cap(struct pci_dev *dev)
+static void __devinit quirk_nvidia_ck804_pcie_aer_ext_cap(struct pci_dev *dev)
 {
 	uint8_t b;
 	if (pci_read_config_byte(dev, 0xf41, &b) == 0) {
@@ -2016,7 +2016,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NV
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_NVIDIA,  PCI_DEVICE_ID_NVIDIA_CK804_PCIE,
 			quirk_nvidia_ck804_pcie_aer_ext_cap);
 
-static void __devinit quirk_via_cx700_pci_parking_caching(struct pci_dev *dev)
+static void __init quirk_via_cx700_pci_parking_caching(struct pci_dev *dev)
 {
 	/*
 	 * Disable PCI Bus Parking and PCI Master read caching on CX700
@@ -2079,7 +2079,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VI
  * We believe that it is legal to read beyond the end tag and
  * therefore the solution is to limit the read/write length.
  */
-static void __devinit quirk_brcm_570x_limit_vpd(struct pci_dev *dev)
+static void __init quirk_brcm_570x_limit_vpd(struct pci_dev *dev)
 {
 	/*
 	 * Only disable the VPD capability for 5706, 5706S, 5708,
@@ -2121,7 +2121,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BR
  * the DRBs - this is where we expose device 6.
  * http://www.x86-secret.com/articles/tweak/pat/patsecrets-2.htm 
  */
-static void __devinit quirk_unhide_mch_dev6(struct pci_dev *dev)
+static void quirk_unhide_mch_dev6(struct pci_dev *dev)
 {
 	u8 reg;
 
@@ -2145,7 +2145,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_IN
  * supports link speed auto negotiation, but falsely sets
  * the link speed to 5GT/s.
  */
-static void __devinit quirk_tile_plx_gen1(struct pci_dev *dev)
+static void quirk_tile_plx_gen1(struct pci_dev *dev)
 {
 	if (tile_plx_gen1) {
 		pci_write_config_dword(dev, 0x98, 0x1);
@@ -2176,7 +2176,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VI
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8380_0, quirk_disable_all_msi);
 
 /* Disable MSI on chipsets that are known to not support it */
-static void __devinit quirk_disable_msi(struct pci_dev *dev)
+static void __init quirk_disable_msi(struct pci_dev *dev)
 {
 	if (dev->subordinate) {
 		dev_warn(&dev->dev, "MSI quirk detected; "
@@ -2194,7 +2194,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AT
  * we use the possible vendor/device IDs of the host bridge for the
  * declared quirk, and search for the APC bridge by slot number.
  */
-static void __devinit quirk_amd_780_apc_msi(struct pci_dev *host_bridge)
+static void __init quirk_amd_780_apc_msi(struct pci_dev *host_bridge)
 {
 	struct pci_dev *apc_bridge;
 
@@ -2234,7 +2234,7 @@ static int __devinit msi_ht_cap_enabled(
 }
 
 /* Check the hypertransport MSI mapping to know whether MSI is enabled or not */
-static void __devinit quirk_msi_ht_cap(struct pci_dev *dev)
+static void __init quirk_msi_ht_cap(struct pci_dev *dev)
 {
 	if (dev->subordinate && !msi_ht_cap_enabled(dev)) {
 		dev_warn(&dev->dev, "MSI quirk detected; "
@@ -2248,7 +2248,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SE
 /* The nVidia CK804 chipset may have 2 HT MSI mappings.
  * MSI are supported if the MSI capability set in any of these mappings.
  */
-static void __devinit quirk_nvidia_ck804_msi_ht_cap(struct pci_dev *dev)
+static void __init quirk_nvidia_ck804_msi_ht_cap(struct pci_dev *dev)
 {
 	struct pci_dev *pdev;
 
@@ -2302,7 +2302,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_A
  * for the MCP55 NIC. It is not yet determined whether the msi problem
  * also affects other devices. As for now, turn off msi for this device.
  */
-static void __devinit nvenet_msi_disable(struct pci_dev *dev)
+static void nvenet_msi_disable(struct pci_dev *dev)
 {
 	if (dmi_name_in_vendors("P5N32-SLI PREMIUM") ||
 	    dmi_name_in_vendors("P5N32-E SLI")) {
@@ -2325,7 +2325,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NV
  * we have it set correctly.
  * Note this is an undocumented register.
  */
-static void __devinit nvbridge_check_legacy_irq_routing(struct pci_dev *dev)
+static void nvbridge_check_legacy_irq_routing(struct pci_dev *dev)
 {
 	u32 cfg;
 
@@ -2558,11 +2558,11 @@ DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDO
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AL, PCI_ANY_ID, nv_msi_ht_cap_quirk_all);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_AL, PCI_ANY_ID, nv_msi_ht_cap_quirk_all);
 
-static void __devinit quirk_msi_intx_disable_bug(struct pci_dev *dev)
+static void __init quirk_msi_intx_disable_bug(struct pci_dev *dev)
 {
 	dev->dev_flags |= PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
 }
-static void __devinit quirk_msi_intx_disable_ati_bug(struct pci_dev *dev)
+static void __init quirk_msi_intx_disable_ati_bug(struct pci_dev *dev)
 {
 	struct pci_dev *p;
 
@@ -2820,7 +2820,7 @@ extern struct pci_fixup __start_pci_fixu
 extern struct pci_fixup __end_pci_fixups_suspend[];
 
 
-void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev)
+void __ref pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev)
 {
 	struct pci_fixup *start, *end;
 
@@ -2866,7 +2866,6 @@ void pci_fixup_device(enum pci_fixup_pas
 	}
 	pci_do_fixups(dev, start, end);
 }
-EXPORT_SYMBOL(pci_fixup_device);
 
 static int __init pci_apply_final_quirks(void)
 {
--- 2.6.38-rc4/drivers/usb/host/pci-quirks.c
+++ 2.6.38-rc4-pci-fixup-sections/drivers/usb/host/pci-quirks.c
@@ -466,7 +466,7 @@ hc_init:
 	iounmap(base);
 }
 
-static void __devinit quirk_usb_early_handoff(struct pci_dev *pdev)
+static void __init quirk_usb_early_handoff(struct pci_dev *pdev)
 {
 	if (pdev->class == PCI_CLASS_SERIAL_USB_UHCI)
 		quirk_usb_handoff_uhci(pdev);
--- 2.6.38-rc4/include/asm-generic/vmlinux.lds.h
+++ 2.6.38-rc4-pci-fixup-sections/include/asm-generic/vmlinux.lds.h
@@ -98,6 +98,19 @@
 #define MEM_DISCARD(sec) *(.mem##sec)
 #endif
 
+#define PCI_FIXUPS(what)				\
+	VMLINUX_SYMBOL(__start_pci_fixups_##what) = .;	\
+	*(.pci_fixup_##what)				\
+	VMLINUX_SYMBOL(__end_pci_fixups_##what) = .;
+
+#ifdef CONFIG_PM_OPS
+#define PCI_FIXUPS_PM_KEEP PCI_FIXUPS
+#define PCI_FIXUPS_PM_DISCARD(what)
+#else
+#define PCI_FIXUPS_PM_KEEP(what)
+#define PCI_FIXUPS_PM_DISCARD PCI_FIXUPS
+#endif
+
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 #define MCOUNT_REC()	. = ALIGN(8);				\
 			VMLINUX_SYMBOL(__start_mcount_loc) = .; \
@@ -232,27 +245,12 @@
 									\
 	/* PCI quirks */						\
 	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
-		VMLINUX_SYMBOL(__start_pci_fixups_early) = .;		\
-		*(.pci_fixup_early)					\
-		VMLINUX_SYMBOL(__end_pci_fixups_early) = .;		\
-		VMLINUX_SYMBOL(__start_pci_fixups_header) = .;		\
-		*(.pci_fixup_header)					\
-		VMLINUX_SYMBOL(__end_pci_fixups_header) = .;		\
-		VMLINUX_SYMBOL(__start_pci_fixups_final) = .;		\
-		*(.pci_fixup_final)					\
-		VMLINUX_SYMBOL(__end_pci_fixups_final) = .;		\
-		VMLINUX_SYMBOL(__start_pci_fixups_enable) = .;		\
-		*(.pci_fixup_enable)					\
-		VMLINUX_SYMBOL(__end_pci_fixups_enable) = .;		\
-		VMLINUX_SYMBOL(__start_pci_fixups_resume) = .;		\
-		*(.pci_fixup_resume)					\
-		VMLINUX_SYMBOL(__end_pci_fixups_resume) = .;		\
-		VMLINUX_SYMBOL(__start_pci_fixups_resume_early) = .;	\
-		*(.pci_fixup_resume_early)				\
-		VMLINUX_SYMBOL(__end_pci_fixups_resume_early) = .;	\
-		VMLINUX_SYMBOL(__start_pci_fixups_suspend) = .;		\
-		*(.pci_fixup_suspend)					\
-		VMLINUX_SYMBOL(__end_pci_fixups_suspend) = .;		\
+		PCI_FIXUPS(early)					\
+		PCI_FIXUPS(header)					\
+		PCI_FIXUPS(enable)					\
+		PCI_FIXUPS_PM_KEEP(resume)				\
+		PCI_FIXUPS_PM_KEEP(resume_early)			\
+		PCI_FIXUPS_PM_KEEP(suspend)				\
 	}								\
 									\
 	/* Built-in firmware blobs */					\
@@ -478,6 +476,11 @@
 	CPU_DISCARD(init.data)						\
 	MEM_DISCARD(init.data)						\
 	KERNEL_CTORS()							\
+	. = ALIGN(16);							\
+	PCI_FIXUPS(final)						\
+	PCI_FIXUPS_PM_DISCARD(resume)					\
+	PCI_FIXUPS_PM_DISCARD(resume_early)				\
+	PCI_FIXUPS_PM_DISCARD(suspend)					\
 	*(.init.rodata)							\
 	MCOUNT_REC()							\
 	FTRACE_EVENTS()							\
--- 2.6.38-rc4/scripts/mod/modpost.c
+++ 2.6.38-rc4-pci-fixup-sections/scripts/mod/modpost.c
@@ -826,8 +826,9 @@ static void check_section(const char *mo
 
 #define ALL_INIT_DATA_SECTIONS \
 	".init.setup$", ".init.rodata$", \
-	".devinit.rodata$", ".cpuinit.rodata$", ".meminit.rodata$" \
-	".init.data$", ".devinit.data$", ".cpuinit.data$", ".meminit.data$"
+	".devinit.rodata$", ".cpuinit.rodata$", ".meminit.rodata$", \
+	".init.data$", ".devinit.data$", ".cpuinit.data$", ".meminit.data$", \
+	".pci_fixup_final$", ".pci_fixup_suspend*", ".pci_fixup_resume*"
 #define ALL_EXIT_DATA_SECTIONS \
 	".exit.data$", ".devexit.data$", ".cpuexit.data$", ".memexit.data$"
 
@@ -844,11 +845,13 @@ static void check_section(const char *mo
 #define ALL_INIT_SECTIONS INIT_SECTIONS, ALL_XXXINIT_SECTIONS
 #define ALL_EXIT_SECTIONS EXIT_SECTIONS, ALL_XXXEXIT_SECTIONS
 
-#define DATA_SECTIONS ".data$", ".data.rel$"
+#define DATA_SECTIONS ".data$", ".data.rel$", ".pci_fixup$", \
+	".pci_fixup_early$", ".pci_fixup_enable$"/*, ".pci_fixup_header$"*/
 #define TEXT_SECTIONS ".text$"
 
-#define INIT_SECTIONS      ".init.*"
-#define DEV_INIT_SECTIONS  ".devinit.*"
+#define INIT_SECTIONS      ".init.*", ".pci_fixup_final$"
+#define DEV_INIT_SECTIONS  ".devinit.*", \
+	".pci_fixup_suspend*", ".pci_fixup_resume*"
 #define CPU_INIT_SECTIONS  ".cpuinit.*"
 #define MEM_INIT_SECTIONS  ".meminit.*"
 


