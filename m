Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab1DYUXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:23:09 -0400
Received: from 1wt.eu ([62.212.114.60]:33698 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab1DYUXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:23:06 -0400
Message-Id: <20110425200233.042141055@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:02:33 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Alex He <alex.he@amd.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 001/173] USB: EHCI: ASPM quirk of ISOC on AMD SB800
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex He <alex.he@amd.com>

commit 05570297ecbe834b1756b522412b68eaffb9ab11 upstream.

When ASPM PM Feature is enabled on UMI link, devices that use ISOC stream of
data transfer may be exposed to longer latency causing less than optimal per-
formance of the device. The longer latencies are normal and are due to link
wake time coming out of low power state which happens frequently to save
power when the link is not active.
The following code will make exception for certain features of ASPM to be by
passed and keep the logic normal state only when the ISOC device is connected
and active. This change will allow the device to run at optimal performance
yet minimize the impact on overall power savings.

Signed-off-by: Alex He <alex.he@amd.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-hcd.c   |    8 ++++
 drivers/usb/host/ehci-pci.c   |   32 +++++++++++++++++
 drivers/usb/host/ehci-sched.c |   79 ++++++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/ehci.h       |    1 
 4 files changed, 120 insertions(+)

Index: longterm-2.6.27/drivers/usb/host/ehci-hcd.c
===================================================================
--- longterm-2.6.27.orig/drivers/usb/host/ehci-hcd.c	2011-01-29 11:22:46.000000000 +0100
+++ longterm-2.6.27/drivers/usb/host/ehci-hcd.c	2011-04-25 11:14:47.042278735 +0200
@@ -103,6 +103,9 @@
 
 #define	INTR_MASK (STS_IAA | STS_FATAL | STS_PCD | STS_ERR | STS_INT)
 
+/* for ASPM quirk of ISOC on AMD SB800 */
+static struct pci_dev *amd_nb_dev;
+
 /*-------------------------------------------------------------------------*/
 
 #include "ehci.h"
@@ -450,6 +453,11 @@
 	spin_unlock_irq (&ehci->lock);
 	ehci_mem_cleanup (ehci);
 
+	if (amd_nb_dev) {
+		pci_dev_put(amd_nb_dev);
+		amd_nb_dev = NULL;
+	}
+
 #ifdef	EHCI_STATS
 	ehci_dbg (ehci, "irq normal %ld err %ld reclaim %ld (lost %ld)\n",
 		ehci->stats.normal, ehci->stats.error, ehci->stats.reclaim,
Index: longterm-2.6.27/drivers/usb/host/ehci-pci.c
===================================================================
--- longterm-2.6.27.orig/drivers/usb/host/ehci-pci.c	2011-01-23 10:52:26.000000000 +0100
+++ longterm-2.6.27/drivers/usb/host/ehci-pci.c	2011-04-25 11:14:47.046278205 +0200
@@ -61,6 +61,35 @@
 	return 0;
 }
 
+static int ehci_quirk_amd_SB800(struct ehci_hcd *ehci)
+{
+	struct pci_dev *amd_smbus_dev;
+	u8 rev = 0;
+
+	amd_smbus_dev = pci_get_device(PCI_VENDOR_ID_ATI, 0x4385, NULL);
+	if (!amd_smbus_dev)
+		return 0;
+
+	pci_read_config_byte(amd_smbus_dev, PCI_REVISION_ID, &rev);
+	if (rev < 0x40) {
+		pci_dev_put(amd_smbus_dev);
+		amd_smbus_dev = NULL;
+		return 0;
+	}
+
+	if (!amd_nb_dev)
+		amd_nb_dev = pci_get_device(PCI_VENDOR_ID_AMD, 0x1510, NULL);
+	if (!amd_nb_dev)
+		ehci_err(ehci, "QUIRK: unable to get AMD NB device\n");
+
+	ehci_info(ehci, "QUIRK: Enable AMD SB800 L1 fix\n");
+
+	pci_dev_put(amd_smbus_dev);
+	amd_smbus_dev = NULL;
+
+	return 1;
+}
+
 /* called during probe() after chip reset completes */
 static int ehci_pci_setup(struct usb_hcd *hcd)
 {
@@ -119,6 +148,9 @@
 	/* cache this readonly data; minimize chip reads */
 	ehci->hcs_params = ehci_readl(ehci, &ehci->caps->hcs_params);
 
+	if (ehci_quirk_amd_SB800(ehci))
+		ehci->amd_l1_fix = 1;
+
 	retval = ehci_halt(ehci);
 	if (retval)
 		return retval;
Index: longterm-2.6.27/drivers/usb/host/ehci-sched.c
===================================================================
--- longterm-2.6.27.orig/drivers/usb/host/ehci-sched.c	2011-01-23 10:52:26.000000000 +0100
+++ longterm-2.6.27/drivers/usb/host/ehci-sched.c	2011-04-25 11:14:47.052279777 +0200
@@ -1496,6 +1496,63 @@
 	ehci->periodic[frame] = cpu_to_hc32(ehci, itd->itd_dma | Q_TYPE_ITD);
 }
 
+#define AB_REG_BAR_LOW 0xe0
+#define AB_REG_BAR_HIGH 0xe1
+#define AB_INDX(addr) ((addr) + 0x00)
+#define AB_DATA(addr) ((addr) + 0x04)
+#define NB_PCIE_INDX_ADDR 0xe0
+#define NB_PCIE_INDX_DATA 0xe4
+#define NB_PIF0_PWRDOWN_0 0x01100012
+#define NB_PIF0_PWRDOWN_1 0x01100013
+
+static void ehci_quirk_amd_L1(struct ehci_hcd *ehci, int disable)
+{
+	u32 addr, addr_low, addr_high, val;
+
+	outb_p(AB_REG_BAR_LOW, 0xcd6);
+	addr_low = inb_p(0xcd7);
+	outb_p(AB_REG_BAR_HIGH, 0xcd6);
+	addr_high = inb_p(0xcd7);
+	addr = addr_high << 8 | addr_low;
+	outl_p(0x30, AB_INDX(addr));
+	outl_p(0x40, AB_DATA(addr));
+	outl_p(0x34, AB_INDX(addr));
+	val = inl_p(AB_DATA(addr));
+
+	if (disable) {
+		val &= ~0x8;
+		val |= (1 << 4) | (1 << 9);
+	} else {
+		val |= 0x8;
+		val &= ~((1 << 4) | (1 << 9));
+	}
+	outl_p(val, AB_DATA(addr));
+
+	if (amd_nb_dev) {
+		addr = NB_PIF0_PWRDOWN_0;
+		pci_write_config_dword(amd_nb_dev, NB_PCIE_INDX_ADDR, addr);
+		pci_read_config_dword(amd_nb_dev, NB_PCIE_INDX_DATA, &val);
+		if (disable)
+			val &= ~(0x3f << 7);
+		else
+			val |= 0x3f << 7;
+
+		pci_write_config_dword(amd_nb_dev, NB_PCIE_INDX_DATA, val);
+
+		addr = NB_PIF0_PWRDOWN_1;
+		pci_write_config_dword(amd_nb_dev, NB_PCIE_INDX_ADDR, addr);
+		pci_read_config_dword(amd_nb_dev, NB_PCIE_INDX_DATA, &val);
+		if (disable)
+			val &= ~(0x3f << 7);
+		else
+			val |= 0x3f << 7;
+
+		pci_write_config_dword(amd_nb_dev, NB_PCIE_INDX_DATA, val);
+	}
+
+	return;
+}
+
 /* fit urb's itds into the selected schedule slot; activate as needed */
 static int
 itd_link_urb (
@@ -1523,6 +1580,12 @@
 			next_uframe >> 3, next_uframe & 0x7);
 		stream->start = jiffies;
 	}
+
+	if (ehci_to_hcd(ehci)->self.bandwidth_isoc_reqs == 0) {
+		if (ehci->amd_l1_fix == 1)
+			ehci_quirk_amd_L1(ehci, 1);
+	}
+
 	ehci_to_hcd(ehci)->self.bandwidth_isoc_reqs++;
 
 	/* fill iTDs uframe by uframe */
@@ -1649,6 +1712,11 @@
 	(void) disable_periodic(ehci);
 	ehci_to_hcd(ehci)->self.bandwidth_isoc_reqs--;
 
+	if (ehci_to_hcd(ehci)->self.bandwidth_isoc_reqs == 0) {
+		if (ehci->amd_l1_fix == 1)
+			ehci_quirk_amd_L1(ehci, 0);
+	}
+
 	if (unlikely(list_is_singular(&stream->td_list))) {
 		ehci_to_hcd(ehci)->self.bandwidth_allocated
 				-= stream->bandwidth;
@@ -1936,6 +2004,12 @@
 			stream->interval, hc32_to_cpu(ehci, stream->splits));
 		stream->start = jiffies;
 	}
+
+	if (ehci_to_hcd(ehci)->self.bandwidth_isoc_reqs == 0) {
+		if (ehci->amd_l1_fix == 1)
+			ehci_quirk_amd_L1(ehci, 1);
+	}
+
 	ehci_to_hcd(ehci)->self.bandwidth_isoc_reqs++;
 
 	/* fill sITDs frame by frame */
@@ -2038,6 +2112,11 @@
 	(void) disable_periodic(ehci);
 	ehci_to_hcd(ehci)->self.bandwidth_isoc_reqs--;
 
+	if (ehci_to_hcd(ehci)->self.bandwidth_isoc_reqs == 0) {
+		if (ehci->amd_l1_fix == 1)
+			ehci_quirk_amd_L1(ehci, 0);
+	}
+
 	if (list_is_singular(&stream->td_list)) {
 		ehci_to_hcd(ehci)->self.bandwidth_allocated
 				-= stream->bandwidth;
Index: longterm-2.6.27/drivers/usb/host/ehci.h
===================================================================
--- longterm-2.6.27.orig/drivers/usb/host/ehci.h	2011-01-23 10:52:26.000000000 +0100
+++ longterm-2.6.27/drivers/usb/host/ehci.h	2011-04-25 11:15:22.138279941 +0200
@@ -122,6 +122,7 @@
 	unsigned		has_fsl_port_bug:1; /* FreeScale */
 	unsigned		big_endian_mmio:1;
 	unsigned		big_endian_desc:1;
+	unsigned		amd_l1_fix:1;
 
 	u8			sbrn;		/* packed release number */
 


