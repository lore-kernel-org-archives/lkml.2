Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252Ab2FUUZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 16:25:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760186Ab2FUUZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 16:25:20 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 8/9] PCI: move final fixup quirks from __init to __devinit
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux@arm.linux.org.uk, ralf@linux-mips.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Jun 2012 14:25:05 -0600
Message-ID: <20120621202504.16865.35445.stgit@amt.stowe>
In-Reply-To: <20120621202415.16865.6226.stgit@amt.stowe>
References: <20120621202415.16865.6226.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI subsystem's final fixups are executed once during boot, after the
pci-device is found.  As long as the system does not support hot-plug,
specifying __init is fine.

With hot-plug, either physically based hot-plug events or pseudo hot-plug
events such as "echo 1 > /sys/bus/pci/rescan", it is possible to remove a
PCI bus during run time and have it rediscovered which will require the
call of the fixups again in order for the device to function properly.

This patch prepares specific quirk(s) for use with hot-plug events.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/quirks.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 1a7effa..815c009 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -57,7 +57,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX,PCI_DEVICE_ID_MELLANOX_TAVOR_BRID
 
 /* Deal with broken BIOS'es that neglect to enable passive release,
    which can cause problems in combination with the 82441FX/PPro MTRRs */
-static void quirk_passive_release(struct pci_dev *dev)
+static void __devinit quirk_passive_release(struct pci_dev *dev)
 {
 	struct pci_dev *d = NULL;
 	unsigned char dlc;
@@ -173,7 +173,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 	PCI_DEVICE_ID_INTEL_82439TX, 	quir
  *	Updated based on further information from the site and also on
  *	information provided by VIA 
  */
-static void quirk_vialatency(struct pci_dev *dev)
+static void __devinit quirk_vialatency(struct pci_dev *dev)
 {
 	struct pci_dev *p;
 	u8 busarb;
@@ -733,7 +733,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_XIO2000A,
  * TODO: When we have device-specific interrupt routers,
  * this code will go away from quirks.
  */
-static void quirk_via_ioapic(struct pci_dev *dev)
+static void __devinit quirk_via_ioapic(struct pci_dev *dev)
 {
 	u8 tmp;
 	
@@ -757,7 +757,7 @@ DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_82C686,	quir
  * Set this bit to get rid of cycle wastage.
  * Otherwise uncritical.
  */
-static void quirk_via_vt8237_bypass_apic_deassert(struct pci_dev *dev)
+static void __devinit quirk_via_vt8237_bypass_apic_deassert(struct pci_dev *dev)
 {
 	u8 misc_control2;
 #define BYPASS_APIC_DEASSERT 8
@@ -939,7 +939,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_82C597_0,	quirk_vt
  * do this even if the Linux CardBus driver is not loaded, because
  * the Linux i82365 driver does not (and should not) handle CardBus.
  */
-static void quirk_cardbus_legacy(struct pci_dev *dev)
+static void __devinit quirk_cardbus_legacy(struct pci_dev *dev)
 {
 	pci_write_config_dword(dev, PCI_CB_LEGACY_MODE_BASE, 0);
 }
@@ -955,7 +955,7 @@ DECLARE_PCI_FIXUP_CLASS_RESUME_EARLY(PCI_ANY_ID, PCI_ANY_ID,
  * To be fair to AMD, it follows the spec by default, its BIOS people
  * who turn it off!
  */
-static void quirk_amd_ordering(struct pci_dev *dev)
+static void __devinit quirk_amd_ordering(struct pci_dev *dev)
 {
 	u32 pcic;
 	pci_read_config_dword(dev, 0x4C, &pcic);
@@ -1005,7 +1005,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_TOSHIBA,	0x605,	quirk_transparent_bridge)
  * datasheets found at http://www.national.com/analog for info on what
  * these bits do.  <christer@weinigel.se>
  */
-static void quirk_mediagx_master(struct pci_dev *dev)
+static void __devinit quirk_mediagx_master(struct pci_dev *dev)
 {
 	u8 reg;
 	pci_read_config_byte(dev, 0x41, &reg);
@@ -1023,7 +1023,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_CYRIX,	PCI_DEVICE_ID_CYRIX_PCI_MASTER, qu
  *	the BIOS but in the odd case it is not the results are corruption
  *	hence the presence of a Linux check
  */
-static void quirk_disable_pxb(struct pci_dev *pdev)
+static void __devinit quirk_disable_pxb(struct pci_dev *pdev)
 {
 	u16 config;
 	
@@ -1591,7 +1591,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_PXHV,	quirk_pci
  * Some Intel PCI Express chipsets have trouble with downstream
  * device power management.
  */
-static void quirk_intel_pcie_pm(struct pci_dev * dev)
+static void __devinit quirk_intel_pcie_pm(struct pci_dev *dev)
 {
 	pci_pm_d3_delay = 120;
 	dev->no_d1d2 = 1;
@@ -1626,7 +1626,8 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x260b, quirk_intel_pcie_pm);
  * that a PCI device's interrupt handler is installed on the boot interrupt
  * line instead.
  */
-static void quirk_reroute_to_boot_interrupts_intel(struct pci_dev *dev)
+static void __devinit
+quirk_reroute_to_boot_interrupts_intel(struct pci_dev *dev)
 {
 	if (noioapicquirk || noioapicreroute)
 		return;
@@ -1664,7 +1665,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_80332_1,	quirk
 #define INTEL_6300_IOAPIC_ABAR		0x40
 #define INTEL_6300_DISABLE_BOOT_IRQ	(1<<14)
 
-static void quirk_disable_intel_boot_interrupt(struct pci_dev *dev)
+static void __devinit quirk_disable_intel_boot_interrupt(struct pci_dev *dev)
 {
 	u16 pci_config_word;
 
@@ -1689,7 +1690,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_ESB_10, 	qui
 #define BC_HT1000_MAP_IDX		0xC00
 #define BC_HT1000_MAP_DATA		0xC01
 
-static void quirk_disable_broadcom_boot_interrupt(struct pci_dev *dev)
+static void __devinit quirk_disable_broadcom_boot_interrupt(struct pci_dev *dev)
 {
 	u32 pci_config_dword;
 	u8 irq;
@@ -1727,7 +1728,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_SERVERWORKS,   PCI_DEVICE_ID_SERVERWORKS_
 #define AMD_813X_REV_B1			0x12
 #define AMD_813X_REV_B2			0x13
 
-static void quirk_disable_amd_813x_boot_interrupt(struct pci_dev *dev)
+static void __devinit quirk_disable_amd_813x_boot_interrupt(struct pci_dev *dev)
 {
 	u32 pci_config_dword;
 
@@ -1751,7 +1752,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_8132_BRIDGE,	quirk
 
 #define AMD_8111_PCI_IRQ_ROUTING	0x56
 
-static void quirk_disable_amd_8111_boot_interrupt(struct pci_dev *dev)
+static void __devinit quirk_disable_amd_8111_boot_interrupt(struct pci_dev *dev)
 {
 	u16 pci_config_word;
 
@@ -1989,7 +1990,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x1460,		quirk_p64h2_1k_io_fix_iobl
  * Force it to be linked by setting the corresponding control bit in the
  * config space.
  */
-static void quirk_nvidia_ck804_pcie_aer_ext_cap(struct pci_dev *dev)
+static void __devinit quirk_nvidia_ck804_pcie_aer_ext_cap(struct pci_dev *dev)
 {
 	uint8_t b;
 	if (pci_read_config_byte(dev, 0xf41, &b) == 0) {

