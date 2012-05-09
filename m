Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897Ab2EIJBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:01:15 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:40495 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758887Ab2EIJBK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:1:1>);
	Wed, 9 May 2012 05:01:10 -0400
Message-Id: <4FAA4A5A0200007800082702@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 09 May 2012 09:43:38 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: [PATCH 1/5, resend] PCI: adjust quirk handler section
 annotations
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation to adjust modpost to check section mismatches
on most of the .pci_fixup* sections:

.pci_fixup_final is only used from .init.text, and hence can (along
with the respective handler functions) reside in .init.*.

Several other .pci_fixup_* sections are needed only during boot and
suspend/resume, and can therefore be moved into .init.* if
!CONFIG_PM.

Handler (and eventual static data) section annotations need to/can be
changed accordingly.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 drivers/pci/quirks.c              |  103 ++++++++++++++++++--------------------
 1 file changed, 51 insertions(+), 52 deletions(-)

--- 3.4-rc6/drivers/pci/quirks.c
+++ 3.4-rc6-pci-fixup-sections/drivers/pci/quirks.c
@@ -37,7 +37,7 @@
  * key system devices. For devices that need to have mmio decoding always-on,
  * we need to set the dev->mmio_always_on bit.
  */
-static void __devinit quirk_mmio_always_on(struct pci_dev *dev)
+static void quirk_mmio_always_on(struct pci_dev *dev)
 {
 	dev->mmio_always_on = 1;
 }
@@ -48,7 +48,7 @@ DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_ANY_ID
  * Mark this device with a broken_parity_status, to allow
  * PCI scanning code to "skip" this now blacklisted device.
  */
-static void __devinit quirk_mellanox_tavor(struct pci_dev *dev)
+static void __init quirk_mellanox_tavor(struct pci_dev *dev)
 {
 	dev->broken_parity_status = 1;	/* This device gives false positives */
 }
@@ -57,7 +57,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ME
 
 /* Deal with broken BIOS'es that neglect to enable passive release,
    which can cause problems in combination with the 82441FX/PPro MTRRs */
-static void quirk_passive_release(struct pci_dev *dev)
+static void __devinit quirk_passive_release(struct pci_dev *dev)
 {
 	struct pci_dev *d = NULL;
 	unsigned char dlc;
@@ -83,7 +83,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_I
     This appears to be BIOS not version dependent. So presumably there is a 
     chipset level fix */
     
-static void __devinit quirk_isa_dma_hangs(struct pci_dev *dev)
+static void __init quirk_isa_dma_hangs(struct pci_dev *dev)
 {
 	if (!isa_dma_bridge_buggy) {
 		isa_dma_bridge_buggy=1;
@@ -125,7 +125,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 /*
  *	Chipsets where PCI->PCI transfers vanish or hang
  */
-static void __devinit quirk_nopcipci(struct pci_dev *dev)
+static void __init quirk_nopcipci(struct pci_dev *dev)
 {
 	if ((pci_pci_problems & PCIPCI_FAIL)==0) {
 		dev_info(&dev->dev, "Disabling direct PCI/PCI transfers\n");
@@ -135,7 +135,7 @@ static void __devinit quirk_nopcipci(str
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SI,	PCI_DEVICE_ID_SI_5597,		quirk_nopcipci);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SI,	PCI_DEVICE_ID_SI_496,		quirk_nopcipci);
 
-static void __devinit quirk_nopciamd(struct pci_dev *dev)
+static void __init quirk_nopciamd(struct pci_dev *dev)
 {
 	u8 rev;
 	pci_read_config_byte(dev, 0x08, &rev);
@@ -150,7 +150,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AM
 /*
  *	Triton requires workarounds to be used by the drivers
  */
-static void __devinit quirk_triton(struct pci_dev *dev)
+static void __init quirk_triton(struct pci_dev *dev)
 {
 	if ((pci_pci_problems&PCIPCI_TRITON)==0) {
 		dev_info(&dev->dev, "Limiting direct PCI/PCI transfers\n");
@@ -173,7 +173,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
  *	Updated based on further information from the site and also on
  *	information provided by VIA 
  */
-static void quirk_vialatency(struct pci_dev *dev)
+static void __devinit quirk_vialatency(struct pci_dev *dev)
 {
 	struct pci_dev *p;
 	u8 busarb;
@@ -229,7 +229,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_V
 /*
  *	VIA Apollo VP3 needs ETBF on BT848/878
  */
-static void __devinit quirk_viaetbf(struct pci_dev *dev)
+static void __init quirk_viaetbf(struct pci_dev *dev)
 {
 	if ((pci_pci_problems&PCIPCI_VIAETBF)==0) {
 		dev_info(&dev->dev, "Limiting direct PCI/PCI transfers\n");
@@ -238,7 +238,7 @@ static void __devinit quirk_viaetbf(stru
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_82C597_0,	quirk_viaetbf);
 
-static void __devinit quirk_vsfx(struct pci_dev *dev)
+static void __init quirk_vsfx(struct pci_dev *dev)
 {
 	if ((pci_pci_problems&PCIPCI_VSFX)==0) {
 		dev_info(&dev->dev, "Limiting direct PCI/PCI transfers\n");
@@ -267,7 +267,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AL
  *	Natoma has some interesting boundary conditions with Zoran stuff
  *	at least
  */
-static void __devinit quirk_natoma(struct pci_dev *dev)
+static void __init quirk_natoma(struct pci_dev *dev)
 {
 	if ((pci_pci_problems&PCIPCI_NATOMA)==0) {
 		dev_info(&dev->dev, "Limiting direct PCI/PCI transfers\n");
@@ -352,7 +352,7 @@ static void __devinit quirk_io_region(st
  *	ATI Northbridge setups MCE the processor if you even
  *	read somewhere between 0x3b0->0x3bb or read 0x3d3
  */
-static void __devinit quirk_ati_exploding_mce(struct pci_dev *dev)
+static void __init quirk_ati_exploding_mce(struct pci_dev *dev)
 {
 	dev_info(&dev->dev, "ATI Northbridge, reserving I/O ports 0x3b0 to 0x3bb\n");
 	/* Mae rhaid i ni beidio ag edrych ar y lleoliadiau I/O hyn */
@@ -706,7 +706,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_V
  * TI XIO2000a PCIe-PCI Bridge erroneously reports it supports fast back-to-back:
  *	Disable fast back-to-back on the secondary bus segment
  */
-static void __devinit quirk_xio2000a(struct pci_dev *dev)
+static void __init quirk_xio2000a(struct pci_dev *dev)
 {
 	struct pci_dev *pdev;
 	u16 command;
@@ -733,7 +733,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_TI
  * TODO: When we have device-specific interrupt routers,
  * this code will go away from quirks.
  */
-static void quirk_via_ioapic(struct pci_dev *dev)
+static void __devinit quirk_via_ioapic(struct pci_dev *dev)
 {
 	u8 tmp;
 	
@@ -757,7 +757,7 @@ DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDO
  * Set this bit to get rid of cycle wastage.
  * Otherwise uncritical.
  */
-static void quirk_via_vt8237_bypass_apic_deassert(struct pci_dev *dev)
+static void __devinit quirk_via_vt8237_bypass_apic_deassert(struct pci_dev *dev)
 {
 	u8 misc_control2;
 #define BYPASS_APIC_DEASSERT 8
@@ -780,7 +780,7 @@ DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDO
  * noapic specified. For the moment we assume it's the erratum. We may be wrong
  * of course. However the advice is demonstrably good even if so..
  */
-static void __devinit quirk_amd_ioapic(struct pci_dev *dev)
+static void __init quirk_amd_ioapic(struct pci_dev *dev)
 {
 	if (dev->revision >= 0x02) {
 		dev_warn(&dev->dev, "I/O APIC: AMD Erratum #22 may be present. In the event of instability try\n");
@@ -939,7 +939,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_V
  * do this even if the Linux CardBus driver is not loaded, because
  * the Linux i82365 driver does not (and should not) handle CardBus.
  */
-static void quirk_cardbus_legacy(struct pci_dev *dev)
+static void __devinit quirk_cardbus_legacy(struct pci_dev *dev)
 {
 	pci_write_config_dword(dev, PCI_CB_LEGACY_MODE_BASE, 0);
 }
@@ -955,7 +955,7 @@ DECLARE_PCI_FIXUP_CLASS_RESUME_EARLY(PCI
  * To be fair to AMD, it follows the spec by default, its BIOS people
  * who turn it off!
  */
-static void quirk_amd_ordering(struct pci_dev *dev)
+static void __devinit quirk_amd_ordering(struct pci_dev *dev)
 {
 	u32 pcic;
 	pci_read_config_dword(dev, 0x4C, &pcic);
@@ -1005,7 +1005,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_T
  * datasheets found at http://www.national.com/analog for info on what
  * these bits do.  <christer@weinigel.se>
  */
-static void quirk_mediagx_master(struct pci_dev *dev)
+static void __devinit quirk_mediagx_master(struct pci_dev *dev)
 {
 	u8 reg;
 	pci_read_config_byte(dev, 0x41, &reg);
@@ -1023,7 +1023,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_C
  *	the BIOS but in the odd case it is not the results are corruption
  *	hence the presence of a Linux check
  */
-static void quirk_disable_pxb(struct pci_dev *pdev)
+static void __devinit quirk_disable_pxb(struct pci_dev *pdev)
 {
 	u16 config;
 	
@@ -1066,7 +1066,7 @@ DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDO
 /*
  *	Serverworks CSB5 IDE does not fully support native mode
  */
-static void __devinit quirk_svwks_csb5ide(struct pci_dev *pdev)
+static void quirk_svwks_csb5ide(struct pci_dev *pdev)
 {
 	u8 prog;
 	pci_read_config_byte(pdev, PCI_CLASS_PROG, &prog);
@@ -1082,7 +1082,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SE
 /*
  *	Intel 82801CAM ICH3-M datasheet says IDE modes must be the same
  */
-static void __init quirk_ide_samemode(struct pci_dev *pdev)
+static void quirk_ide_samemode(struct pci_dev *pdev)
 {
 	u8 prog;
 
@@ -1101,7 +1101,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_IN
  * Some ATA devices break if put into D3
  */
 
-static void __devinit quirk_no_ata_d3(struct pci_dev *pdev)
+static void quirk_no_ata_d3(struct pci_dev *pdev)
 {
 	pdev->dev_flags |= PCI_DEV_FLAGS_NO_D3;
 }
@@ -1561,7 +1561,7 @@ static void __init quirk_alder_ioapic(st
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_EESSC,	quirk_alder_ioapic);
 #endif
 
-static void __devinit quirk_pcie_mch(struct pci_dev *pdev)
+static void __init quirk_pcie_mch(struct pci_dev *pdev)
 {
 	pci_msi_off(pdev);
 	pdev->no_msi = 1;
@@ -1575,7 +1575,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
  * It's possible for the MSI to get corrupted if shpc and acpi
  * are used together on certain PXH-based systems.
  */
-static void __devinit quirk_pcie_pxh(struct pci_dev *dev)
+static void quirk_pcie_pxh(struct pci_dev *dev)
 {
 	pci_msi_off(dev);
 	dev->no_msi = 1;
@@ -1591,7 +1591,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_IN
  * Some Intel PCI Express chipsets have trouble with downstream
  * device power management.
  */
-static void quirk_intel_pcie_pm(struct pci_dev * dev)
+static void __init quirk_intel_pcie_pm(struct pci_dev * dev)
 {
 	pci_pm_d3_delay = 120;
 	dev->no_d1d2 = 1;
@@ -1626,7 +1626,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
  * that a PCI device's interrupt handler is installed on the boot interrupt
  * line instead.
  */
-static void quirk_reroute_to_boot_interrupts_intel(struct pci_dev *dev)
+static void __devinit quirk_reroute_to_boot_interrupts_intel(struct pci_dev *dev)
 {
 	if (noioapicquirk || noioapicreroute)
 		return;
@@ -1664,7 +1664,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_I
 #define INTEL_6300_IOAPIC_ABAR		0x40
 #define INTEL_6300_DISABLE_BOOT_IRQ	(1<<14)
 
-static void quirk_disable_intel_boot_interrupt(struct pci_dev *dev)
+static void __devinit quirk_disable_intel_boot_interrupt(struct pci_dev *dev)
 {
 	u16 pci_config_word;
 
@@ -1689,7 +1689,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_I
 #define BC_HT1000_MAP_IDX		0xC00
 #define BC_HT1000_MAP_DATA		0xC01
 
-static void quirk_disable_broadcom_boot_interrupt(struct pci_dev *dev)
+static void __devinit quirk_disable_broadcom_boot_interrupt(struct pci_dev *dev)
 {
 	u32 pci_config_dword;
 	u8 irq;
@@ -1727,7 +1727,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_S
 #define AMD_813X_REV_B1			0x12
 #define AMD_813X_REV_B2			0x13
 
-static void quirk_disable_amd_813x_boot_interrupt(struct pci_dev *dev)
+static void __devinit quirk_disable_amd_813x_boot_interrupt(struct pci_dev *dev)
 {
 	u32 pci_config_dword;
 
@@ -1751,7 +1751,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_A
 
 #define AMD_8111_PCI_IRQ_ROUTING	0x56
 
-static void quirk_disable_amd_8111_boot_interrupt(struct pci_dev *dev)
+static void __devinit quirk_disable_amd_8111_boot_interrupt(struct pci_dev *dev)
 {
 	u16 pci_config_word;
 
@@ -1828,7 +1828,7 @@ static void __devinit quirk_netmos(struc
 DECLARE_PCI_FIXUP_CLASS_HEADER(PCI_VENDOR_ID_NETMOS, PCI_ANY_ID,
 			 PCI_CLASS_COMMUNICATION_SERIAL, 8, quirk_netmos);
 
-static void __devinit quirk_e100_interrupt(struct pci_dev *dev)
+static void __init quirk_e100_interrupt(struct pci_dev *dev)
 {
 	u16 command, pmcsr;
 	u8 __iomem *csr;
@@ -1901,7 +1901,7 @@ DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR
  * The 82575 and 82598 may experience data corruption issues when transitioning
  * out of L0S.  To prevent this we need to disable L0S on the pci-e link
  */
-static void __devinit quirk_disable_aspm_l0s(struct pci_dev *dev)
+static void __init quirk_disable_aspm_l0s(struct pci_dev *dev)
 {
 	dev_info(&dev->dev, "Disabling L0s\n");
 	pci_disable_link_state(dev, PCIE_LINK_STATE_L0S);
@@ -1964,7 +1964,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
  * The IOBL_ADR gets re-written to 4k boundaries in pci_setup_bridge()
  * in drivers/pci/setup-bus.c
  */
-static void __devinit quirk_p64h2_1k_io_fix_iobl(struct pci_dev *dev)
+static void __init quirk_p64h2_1k_io_fix_iobl(struct pci_dev *dev)
 {
 	u16 en1k, iobl_adr, iobl_adr_1k;
 	struct resource *res = dev->resource + PCI_BRIDGE_RESOURCES;
@@ -1989,7 +1989,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
  * Force it to be linked by setting the corresponding control bit in the
  * config space.
  */
-static void quirk_nvidia_ck804_pcie_aer_ext_cap(struct pci_dev *dev)
+static void __devinit quirk_nvidia_ck804_pcie_aer_ext_cap(struct pci_dev *dev)
 {
 	uint8_t b;
 	if (pci_read_config_byte(dev, 0xf41, &b) == 0) {
@@ -2005,7 +2005,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NV
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_NVIDIA,  PCI_DEVICE_ID_NVIDIA_CK804_PCIE,
 			quirk_nvidia_ck804_pcie_aer_ext_cap);
 
-static void __devinit quirk_via_cx700_pci_parking_caching(struct pci_dev *dev)
+static void __init quirk_via_cx700_pci_parking_caching(struct pci_dev *dev)
 {
 	/*
 	 * Disable PCI Bus Parking and PCI Master read caching on CX700
@@ -2068,7 +2068,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VI
  * We believe that it is legal to read beyond the end tag and
  * therefore the solution is to limit the read/write length.
  */
-static void __devinit quirk_brcm_570x_limit_vpd(struct pci_dev *dev)
+static void __init quirk_brcm_570x_limit_vpd(struct pci_dev *dev)
 {
 	/*
 	 * Only disable the VPD capability for 5706, 5706S, 5708,
@@ -2104,7 +2104,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BR
 			PCI_DEVICE_ID_NX2_5709S,
 			quirk_brcm_570x_limit_vpd);
 
-static void __devinit quirk_brcm_5719_limit_mrrs(struct pci_dev *dev)
+static void quirk_brcm_5719_limit_mrrs(struct pci_dev *dev)
 {
 	u32 rev;
 
@@ -2128,7 +2128,7 @@ DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_B
  * the DRBs - this is where we expose device 6.
  * http://www.x86-secret.com/articles/tweak/pat/patsecrets-2.htm 
  */
-static void __devinit quirk_unhide_mch_dev6(struct pci_dev *dev)
+static void quirk_unhide_mch_dev6(struct pci_dev *dev)
 {
 	u8 reg;
 
@@ -2152,7 +2152,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_IN
  * supports link speed auto negotiation, but falsely sets
  * the link speed to 5GT/s.
  */
-static void __devinit quirk_tile_plx_gen1(struct pci_dev *dev)
+static void quirk_tile_plx_gen1(struct pci_dev *dev)
 {
 	if (tile_plx_gen1) {
 		pci_write_config_dword(dev, 0x98, 0x1);
@@ -2183,7 +2183,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VI
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8380_0, quirk_disable_all_msi);
 
 /* Disable MSI on chipsets that are known to not support it */
-static void __devinit quirk_disable_msi(struct pci_dev *dev)
+static void __init quirk_disable_msi(struct pci_dev *dev)
 {
 	if (dev->subordinate) {
 		dev_warn(&dev->dev, "MSI quirk detected; "
@@ -2201,7 +2201,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AT
  * we use the possible vendor/device IDs of the host bridge for the
  * declared quirk, and search for the APC bridge by slot number.
  */
-static void __devinit quirk_amd_780_apc_msi(struct pci_dev *host_bridge)
+static void __init quirk_amd_780_apc_msi(struct pci_dev *host_bridge)
 {
 	struct pci_dev *apc_bridge;
 
@@ -2241,7 +2241,7 @@ static int __devinit msi_ht_cap_enabled(
 }
 
 /* Check the hypertransport MSI mapping to know whether MSI is enabled or not */
-static void __devinit quirk_msi_ht_cap(struct pci_dev *dev)
+static void __init quirk_msi_ht_cap(struct pci_dev *dev)
 {
 	if (dev->subordinate && !msi_ht_cap_enabled(dev)) {
 		dev_warn(&dev->dev, "MSI quirk detected; "
@@ -2255,7 +2255,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SE
 /* The nVidia CK804 chipset may have 2 HT MSI mappings.
  * MSI are supported if the MSI capability set in any of these mappings.
  */
-static void __devinit quirk_nvidia_ck804_msi_ht_cap(struct pci_dev *dev)
+static void __init quirk_nvidia_ck804_msi_ht_cap(struct pci_dev *dev)
 {
 	struct pci_dev *pdev;
 
@@ -2309,7 +2309,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_A
  * for the MCP55 NIC. It is not yet determined whether the msi problem
  * also affects other devices. As for now, turn off msi for this device.
  */
-static void __devinit nvenet_msi_disable(struct pci_dev *dev)
+static void nvenet_msi_disable(struct pci_dev *dev)
 {
 	const char *board_name = dmi_get_system_info(DMI_BOARD_NAME);
 
@@ -2335,7 +2335,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NV
  * we have it set correctly.
  * Note this is an undocumented register.
  */
-static void __devinit nvbridge_check_legacy_irq_routing(struct pci_dev *dev)
+static void nvbridge_check_legacy_irq_routing(struct pci_dev *dev)
 {
 	u32 cfg;
 
@@ -2568,11 +2568,11 @@ DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDO
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
 
@@ -2774,7 +2774,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_IN
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x3c28, vtd_mask_spec_errors);
 #endif
 
-static void __devinit fixup_ti816x_class(struct pci_dev* dev)
+static void fixup_ti816x_class(struct pci_dev* dev)
 {
 	/* TI 816x devices do not have class code set when in PCIe boot mode */
 	dev_info(&dev->dev, "Setting PCI class for 816x PCIe device\n");
@@ -2896,7 +2896,7 @@ static void do_one_fixup_debug(void (*fn
  * This resolves crashes often seen on monitor unplug.
  */
 #define I915_DEIER_REG 0x4400c
-static void __devinit disable_igfx_irq(struct pci_dev *dev)
+static void __init disable_igfx_irq(struct pci_dev *dev)
 {
 	void __iomem *regs = pci_iomap(dev, 0, 0);
 	if (regs == NULL) {
@@ -2951,7 +2951,7 @@ extern struct pci_fixup __start_pci_fixu
 extern struct pci_fixup __end_pci_fixups_suspend[];
 
 
-void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev)
+void __ref pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev)
 {
 	struct pci_fixup *start, *end;
 
@@ -2997,7 +2997,6 @@ void pci_fixup_device(enum pci_fixup_pas
 	}
 	pci_do_fixups(dev, start, end);
 }
-EXPORT_SYMBOL(pci_fixup_device);
 
 static int __init pci_apply_final_quirks(void)
 {


