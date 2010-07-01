Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab0GAWQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:16:32 -0400
Received: from kroah.org ([198.145.64.141]:47272 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932578Ab0GAUtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:49:52 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:30 2010
Message-Id: <20100701173430.055965587@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:33:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alek Du <alek.du@intel.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 038/164] USB: EHCI: clear PHCD before resuming
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alek Du <alek.du@intel.com>

commit eab80de01cb398419ef3305f35abcb367c647c8b upstream.

This is a bug fix for PHCD (phy clock disable) low power feature:
After PHCD is set, any write to PORTSC register is illegal, so when
resume ports, clear PHCD bit first.

Signed-off-by: Alek Du <alek.du@intel.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-hub.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -294,6 +294,16 @@ static int ehci_bus_resume (struct usb_h
 	/* manually resume the ports we suspended during bus_suspend() */
 	i = HCS_N_PORTS (ehci->hcs_params);
 	while (i--) {
+		/* clear phy low power mode before resume */
+		if (ehci->has_hostpc) {
+			u32 __iomem	*hostpc_reg =
+				(u32 __iomem *)((u8 *)ehci->regs
+				+ HOSTPC0 + 4 * (i & 0xff));
+			temp = ehci_readl(ehci, hostpc_reg);
+			ehci_writel(ehci, temp & ~HOSTPC_PHCD,
+				hostpc_reg);
+			mdelay(5);
+		}
 		temp = ehci_readl(ehci, &ehci->regs->port_status [i]);
 		temp &= ~(PORT_RWC_BITS | PORT_WAKE_BITS);
 		if (test_bit(i, &ehci->bus_suspended) &&
@@ -678,6 +688,13 @@ static int ehci_hub_control (
 			if (temp & PORT_SUSPEND) {
 				if ((temp & PORT_PE) == 0)
 					goto error;
+				/* clear phy low power mode before resume */
+				if (hostpc_reg) {
+					temp1 = ehci_readl(ehci, hostpc_reg);
+					ehci_writel(ehci, temp1 & ~HOSTPC_PHCD,
+						hostpc_reg);
+					mdelay(5);
+				}
 				/* resume signaling for 20 msec */
 				temp &= ~(PORT_RWC_BITS | PORT_WAKE_BITS);
 				ehci_writel(ehci, temp | PORT_RESUME,


