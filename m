Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933873Ab2C3VD5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:03:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37370 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761525Ab2C3VDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:03:51 -0400
Message-Id: <20120330195723.719813895@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:57:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shengzhou Liu <Shengzhou.Liu@freescale.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 011/108] powerpc/usb: fix bug of kernel hang when initializing usb
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengzhou Liu <Shengzhou.Liu@freescale.com>

commit 28c56ea1431421dec51b7b229369e991481453df upstream.

If USB UTMI PHY is not enable, writing to portsc register will lead to
kernel hang during boot up.

Signed-off-by: Shengzhou Liu <Shengzhou.Liu@freescale.com>
Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-fsl.c |    4 ++++
 drivers/usb/host/ehci-fsl.h |    1 +
 2 files changed, 5 insertions(+)

--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -216,6 +216,8 @@ static void ehci_fsl_setup_phy(struct eh
 			       unsigned int port_offset)
 {
 	u32 portsc;
+	struct usb_hcd *hcd = ehci_to_hcd(ehci);
+	void __iomem *non_ehci = hcd->regs;
 
 	portsc = ehci_readl(ehci, &ehci->regs->port_status[port_offset]);
 	portsc &= ~(PORT_PTS_MSK | PORT_PTS_PTW);
@@ -231,6 +233,8 @@ static void ehci_fsl_setup_phy(struct eh
 		portsc |= PORT_PTS_PTW;
 		/* fall through */
 	case FSL_USB2_PHY_UTMI:
+		/* enable UTMI PHY */
+		setbits32(non_ehci + FSL_SOC_USB_CTRL, CTRL_UTMI_PHY_EN);
 		portsc |= PORT_PTS_UTMI;
 		break;
 	case FSL_USB2_PHY_NONE:
--- a/drivers/usb/host/ehci-fsl.h
+++ b/drivers/usb/host/ehci-fsl.h
@@ -45,5 +45,6 @@
 #define FSL_SOC_USB_PRICTRL	0x40c	/* NOTE: big-endian */
 #define FSL_SOC_USB_SICTRL	0x410	/* NOTE: big-endian */
 #define FSL_SOC_USB_CTRL	0x500	/* NOTE: big-endian */
+#define CTRL_UTMI_PHY_EN	(1<<9)
 #define SNOOP_SIZE_2GB		0x1e
 #endif				/* _EHCI_FSL_H */


