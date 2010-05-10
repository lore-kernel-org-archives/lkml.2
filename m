Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab0EJC2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 22:28:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:62210 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982Ab0EJC22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 22:28:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,358,1270450800"; 
   d="scan'208";a="796872634"
Date: Mon, 10 May 2010 10:25:57 +0800
From: "Du, Alek" <alek.du@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Du, Alek" <alek.du@intel.com>, Ondrej Zary <linux@rainbow-software.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH v2] [RFC] ehci: Disable wake on overcurrent
 (WKOC_E) and disconnect (WKDISC_E)
Message-ID: <20100510102557.0c30f15d@dxy2>
In-Reply-To: <6C44CD31806DCD4BB88546DAB7AFC9A201EB5A39FA@shsmsx502.ccr.corp.intel.com>
References: <20100507093200.28ecd63c@dxy2>
	<Pine.LNX.4.44L0.1005071106570.1804-100000@iolanthe.rowland.org>
	<6C44CD31806DCD4BB88546DAB7AFC9A201EB5A39FA@shsmsx502.ccr.corp.intel.com>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 May 2010 10:00:59 +0800
"Du, Alek" <alek.du@intel.com> wrote:

> >On Fri, 7 May 2010, Du, Alek wrote:
> >
> >> Alan,
> >>
> >> As I tested, with the second patch, after entering phy low power mode, the
> >port cannot detect any USB devices that plugged in.
> >
> >Ooh, that's not good.  It almost violates the EHCI spec (see the last
> >line on p.60 in table 4.4).
> 

Alan,

The following patch (based on your previous two patches) works for me, could you
help to review and test on your machine? Basically, this will only affect those
"has_hostpc" HCDs.

Thanks,
Alek


diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 004379b..a2d2fbe 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -116,6 +116,17 @@ static void ehci_set_wakeup_flags(struct ehci_hcd *ehci)
                u32 __iomem     *reg = &ehci->regs->port_status[port];
                u32             t1 = ehci_readl(ehci, reg) & ~PORT_RWC_BITS;
                u32             t2 = t1 & ~PORT_WAKE_BITS;
+               u32 __iomem     *hostpc_reg;
+               u32             temp;
+
+               /* clear phy low power mode first*/
+               if (ehci->has_hostpc) {
+                       hostpc_reg = (u32 __iomem *)((u8 *)ehci->regs
+                                       + HOSTPC0 + 4 * (port & 0xff));
+                       temp = ehci_readl(ehci, hostpc_reg);
+                       ehci_writel(ehci, temp & ~HOSTPC_PHCD, hostpc_reg);
+                       mdelay(5);
+               }
 
                /* only enable appropriate wake bits, otherwise the
                 * hardware can not go phy low power mode. If a race
@@ -131,6 +142,16 @@ static void ehci_set_wakeup_flags(struct ehci_hcd *ehci)
                                        port + 1, t1, t2);
                }
                ehci_writel(ehci, t2, reg);
+
+               /* enable phy low power mode again */
+               if (ehci->has_hostpc) {
+                       temp = ehci_readl(ehci, hostpc_reg);
+                       ehci_writel(ehci, temp | HOSTPC_PHCD, hostpc_reg);
+                       temp = ehci_readl(ehci, hostpc_reg);
+                       ehci_dbg(ehci, "Port%d phy low pwr mode %s\n",
+                                       port, (temp & HOSTPC_PHCD) ?
+                                       "succeeded" : "failed");
+               }
        }
 }
 
@@ -217,6 +238,14 @@ static int ehci_bus_suspend (struct usb_hcd *hcd)
                                u32 __iomem     *hostpc_reg;
                                u32             t3;
 
+                               if (t1 & PORT_CONNECT) {
+                                       t2 |= PORT_WKOC_E | PORT_WKDISC_E;
+                                       t2 &= ~PORT_WKCONN_E;
+                               } else {
+                                       t2 |= PORT_WKOC_E | PORT_WKCONN_E;
+                                       t2 &= ~PORT_WKDISC_E;
+                               }
+                               ehci_writel(ehci, t2, reg);
                                hostpc_reg = (u32 __iomem *)((u8 *)ehci->regs
                                        + HOSTPC0 + 4 * (port & 0xff));
                                spin_unlock_irq(&ehci->lock);
