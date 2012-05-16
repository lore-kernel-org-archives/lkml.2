Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760537Ab2EPTg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:36:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760492Ab2EPTgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:36:24 -0400
Message-ID: <1337196962.6954.254.camel@bling.home>
Subject: Re: [PATCH 05/13] pci: New pci_acs_enabled()
From: Alex Williamson <alex.williamson@redhat.com>
To: Don Dutile <ddutile@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, kvm@vger.kernel.org,
        B07421@freescale.com, aik@ozlabs.ru, benh@kernel.crashing.org,
        linux-pci@vger.kernel.org, agraf@suse.de, qemu-devel@nongnu.org,
        chrisw@sous-sol.org, B08248@freescale.com,
        iommu@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        avi@redhat.com, benve@cisco.com, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, david@gibson.dropbear.id.au
Date: Wed, 16 May 2012 13:36:02 -0600
In-Reply-To: <1337185318.6954.243.camel@bling.home>
References: <20120511222148.30496.68571.stgit@bling.home>
	 <20120511225602.30496.80438.stgit@bling.home>
	 <CAErSpo58hKPFb5duOi64sWuR5AJDTVp0rRHkQLotYE3CMXRRhA@mail.gmail.com>
	 <1337035766.6954.74.camel@bling.home>
	 <CAErSpo48ES5iLDCh1WzmHezSEYhPjhtgD5uxoY-TCTKgUBab2g@mail.gmail.com>
	 <1337116157.6954.212.camel@bling.home> <4FB3ABCF.4030708@redhat.com>
	 <1337185318.6954.243.camel@bling.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 10:21 -0600, Alex Williamson wrote:
> On Wed, 2012-05-16 at 09:29 -0400, Don Dutile wrote:
> > On 05/15/2012 05:09 PM, Alex Williamson wrote:
> > > On Tue, 2012-05-15 at 13:56 -0600, Bjorn Helgaas wrote:
> > >> pci_acs_enabled(02:00.0) = 00:02.0 (acs_dev = 00:02.0, 02:00.0 has no ACS cap)
> > >> pci_acs_enabled(03:00.0) = 00:02.0 (acs_dev = 00:02.0)
> > >> pci_acs_enabled(02:01.0) = 02:01.0 (acs_dev = 00:02.0, 02:01.0 has ACS enabled)
> > >> pci_acs_enabled(04:00.0) = 04:00.0 (acs_dev = 02:01.0, 04:00.0 is not
> > >> a bridge; seems wrong if 04:00 is a multi-function device)
> > >
> > > AIUI, ACS is not an endpoint property, so this is what should happen.  I
> > > don't think multifunction plays a role other than how much do we trust
> > > the implementation to not allow back channels between functions (the
> > > answer should probably be not at all).
> > >
> > correct. ACS is a *bridge* property.
> > The unknown wrt multifunction devices is that such devices *could* be implemented
> > by a hidden (not responding to PCI cfg accesses from downstream port) PCI bridge
> > btwn the functions within a device.
> > Such a bridge could allow peer-to-peer xactions and there is no way for OS's to
> > force ACS.  So, one has to ask the hw vendors if such a hidden device exists
> > in the implementation, and whether peer-to-peer is enabled/allowed -- a hidden PCI
> > bridge/PCIe-switch could just be hardwired to push all IO to upstream port,
> > and allow parent bridge re-route it back down if peer-to-peer is desired.
> > Debate exists whether multifunction devices are 'secure' b/c of this unknown.
> > Maybe a PCIe (min., SRIOV) spec change is needed in this area to
> > determine this status about a device (via pci cfg/cap space).
> 
> Well, there is actually a section of the ACS part of the spec
> identifying valid flags for multifunction devices.  Secretly I'd like to
> use this as justification for blacklisting all multifunction devices
> that don't explicitly support ACS, but that makes for pretty course
> granularity.  For instance, all these devices end up in a group:
> 
>    +-14.0  ATI Technologies Inc SBx00 SMBus Controller
>    +-14.2  ATI Technologies Inc SBx00 Azalia (Intel HDA)
>    +-14.3  ATI Technologies Inc SB7x0/SB8x0/SB9x0 LPC host controller
>    +-14.4-[05]----0e.0  VIA Technologies, Inc. VT6306/7/8 [Fire II(M)] IEEE 1394 OHCI Controller
> 
>   00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (rev 40)
> 
> And these in another:
> 
>    +-15.0-[06]----00.0  Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller
>    +-15.1-[07]----00.0  Etron Technology, Inc. EJ168 USB 3.0 Host Controller
>    +-15.2-[08]--
>    +-15.3-[09]--
> 
>   00:15.0 PCI bridge: ATI Technologies Inc SB700/SB800/SB900 PCI to PCI bridge (PCIE port 0)
>   00:15.1 PCI bridge: ATI Technologies Inc SB700/SB800/SB900 PCI to PCI bridge (PCIE port 1)
>   00:15.2 PCI bridge: ATI Technologies Inc SB900 PCI to PCI bridge (PCIE port 2)
>   00:15.3 PCI bridge: ATI Technologies Inc SB900 PCI to PCI bridge (PCIE port 3)
> 
> Am I misinterpreting the spec or is this the correct, if strict,
> interpretation?

Here's what I'm currently thinking.  This is a much more simple
interface, but I don't know if I'm correctly accounting for
multifunciton devices.  Callers use something like:

+       if (dma_pdev->multifunction &&
+           !pci_acs_enabled(dma_pdev, PCI_ACS_ENABLED))
+               dma_pdev = pci_get_slot(dma_pdev->bus,
+                                       PCI_DEVFN(PCI_SLOT(dma_pdev->devfn),
+                                       0));
+
+       while (!pci_is_root_bus(dma_pdev->bus)) {
+               if (pci_acs_path_enabled(dma_pdev->bus->self,
+                                        NULL, PCI_ACS_ENABLED))
+                       break;
+
+               dma_pdev = dma_pdev->bus->self;
+       }

Where the first test is where we have the option to make a very strict
ACS check for multifunction.  Does this start to make more sense?
Interested in opinions on multifunction strict-ness.  Thanks,

Alex

Author: Alex Williamson <alex.williamson@redhat.com>
Date:   Wed May 16 13:17:24 2012 -0600

    pci: Add ACS validation utility
    
    In a PCIe environment, transactions aren't always required to
    reach the root bus before being re-routed.  Intermediate
    switches between an endpoint and the root bus can redirect
    DMA back downstream before things like IOMMU have a chance
    to intervene.  This utility function allows us to determine
    the closest device for which ACS is enabled back to the root
    bus for use in determining the boundaries of an iommu group.
    Logic for this extracted from libvirt.
    
    Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 111569c..0300e7a 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2359,6 +2359,79 @@ void pci_enable_acs(struct pci_dev *dev)
 }
 
 /**
+ * pci_acs_enable - test ACS against required flags for a given device
+ * @pdev: device to test
+ * @acs_flags: required PCI ACS flags
+ *
+ * Return true if the device supports the provided flags.  Automatically
+ * filters out flags that are not implemented on multifunction devices.
+ */
+bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags)
+{
+	int pos;
+	u16 ctrl;
+
+	if (!pci_is_pcie(pdev))
+		return false;
+
+	if (pdev->pcie_type == PCI_EXP_TYPE_DOWNSTREAM ||
+	    pdev->pcie_type == PCI_EXP_TYPE_ROOT_PORT) {
+		pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ACS);
+		if (!pos)
+			return false;
+
+		pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
+		if ((ctrl & acs_flags) != acs_flags)
+			return false;
+	} else if (pdev->multifunction) {
+		/* Filter out flags not applicable to multifunction */
+		acs_flags &= (PCI_ACS_RR | PCI_ACS_CR |
+			      PCI_ACS_EC | PCI_ACS_DT);
+
+		pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ACS);
+		if (!pos)
+			return false;
+
+		pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
+		if ((ctrl & acs_flags) != acs_flags)
+			return false;
+	}
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(pci_acs_enabled);
+	
+/**
+ * pci_acs_path_enable - test ACS flags from start to end in a hierarchy
+ * @start: starting downstream device
+ * @end: ending upstream device or NULL to search to the root bus
+ * @acs_flags: required flags
+ *
+ * Walk up a device tree from start to end testing PCI ACS support.  If
+ * any step along the way does not support the required flags, return false.
+ */
+bool pci_acs_path_enabled(struct pci_dev *start,
+			  struct pci_dev *end, u16 acs_flags)
+{
+	struct pci_dev *pdev, *parent = start;
+
+	do {
+		pdev = parent;
+
+		if (!pci_acs_enabled(pdev, acs_flags))
+			return false;
+
+		if (pci_is_root_bus(pdev->bus))
+			return (end == NULL);
+
+		parent = pdev->bus->self;
+	} while (pdev != end);
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(pci_acs_path_enabled);
+
+/**
  * pci_swizzle_interrupt_pin - swizzle INTx for device behind bridge
  * @dev: the PCI device
  * @pin: the INTx pin (1=INTA, 2=INTB, 3=INTD, 4=INTD)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 9910b5c..83c1711 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1586,7 +1586,9 @@ static inline bool pci_is_pcie(struct pci_dev *dev)
 }
 
 void pci_request_acs(void);
-
+bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags);
+bool pci_acs_path_enabled(struct pci_dev *start,
+			  struct pci_dev *end, u16 acs_flags);
 
 #define PCI_VPD_LRDT			0x80	/* Large Resource Data Type */
 #define PCI_VPD_LRDT_ID(x)		(x | PCI_VPD_LRDT)



