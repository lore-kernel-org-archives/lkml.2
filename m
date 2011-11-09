Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934773Ab1KJFDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:03:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42561 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935002Ab1KJD2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:28:50 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:17 2011
Message-Id: <20111109212717.083630733@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Boris Todorov <boris.st.todorov@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [164/262] USB: EHCI: Fix test mode sequence
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Todorov <boris.st.todorov@gmail.com>

commit 77636c86a600b83de01719efad83567e46d7e8ce upstream.

The sequence to put port in test mode is not complete.
According EHCI specification all enabled ports must be
put in suspend.

Signed-off-by: Boris Todorov <boris.st.todorov@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-hub.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -1120,7 +1120,19 @@ static int ehci_hub_control (
 			if (!selector || selector > 5)
 				goto error;
 			ehci_quiesce(ehci);
+
+			/* Put all enabled ports into suspend */
+			while (ports--) {
+				u32 __iomem *sreg =
+						&ehci->regs->port_status[ports];
+
+				temp = ehci_readl(ehci, sreg) & ~PORT_RWC_BITS;
+				if (temp & PORT_PE)
+					ehci_writel(ehci, temp | PORT_SUSPEND,
+							sreg);
+			}
 			ehci_halt(ehci);
+			temp = ehci_readl(ehci, status_reg);
 			temp |= selector << 16;
 			ehci_writel(ehci, temp, status_reg);
 			break;


