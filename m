Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777Ab0EFPUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 11:20:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:15569 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524Ab0EFPUS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 11:20:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,341,1270450800"; 
   d="scan'208";a="515670504"
From: "Du, Alek" <alek.du@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Ondrej Zary <linux@rainbow-software.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Date: Thu, 6 May 2010 23:20:11 +0800
Subject: RE: [linux-pm] [PATCH v2] [RFC] ehci: Disable wake on overcurrent
 (WKOC_E) and disconnect (WKDISC_E)
Thread-Topic: [linux-pm] [PATCH v2] [RFC] ehci: Disable wake on overcurrent
 (WKOC_E) and disconnect (WKDISC_E)
Thread-Index: AcrtKvZ+Uuja7AaBQPK1OjbdDTkpEwAAfIWQ
Message-ID: <1865303E0DED764181A9D882DEF65FB61A82A6DAFD@shsmsx502.ccr.corp.intel.com>
References: <1865303E0DED764181A9D882DEF65FB61A82A6DA3B@shsmsx502.ccr.corp.intel.com>
 <Pine.LNX.4.44L0.1005061013510.1708-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1005061013510.1708-100000@iolanthe.rowland.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

>With this patch, _none_ of the wakeup bits are enabled.  That should
>work, right?
>
I guess so, but if no wakeup bits set, how to handle remote wakeup case? Seems you removed remote wakeup case?

>But it leads to another question: Later on, when the controller is put
>is put into low-power mode, I wanted to check with you about it.
>
>> I think the problem is: For the original code, once t2 != t1, the HCD
>> will try to put into phy low power mode. While after the patch, the
>> HCD will only enter phy low power mode if PORT_PE is set and
>> PORT_SUSPEND is not set.
>
>Okay, I understand.  Then consider _this_ patch on top of the first
>one.  It sets the hostpc register for every port that wasn't already
>suspended, so each phy should end up in low-power mode.
>
>Alan Stern

I will test this patch ...

Thanks,
Alek

>
>
>
>Index: usb-2.6/drivers/usb/host/ehci-hub.c
>===================================================================
>--- usb-2.6.orig/drivers/usb/host/ehci-hub.c
>+++ usb-2.6/drivers/usb/host/ehci-hub.c
>@@ -152,7 +152,6 @@ static int ehci_bus_suspend (struct usb_
> 	struct ehci_hcd		*ehci = hcd_to_ehci (hcd);
> 	int			port;
> 	int			mask;
>-	u32 __iomem		*hostpc_reg = NULL;
>
> 	ehci_dbg(ehci, "suspend root hub\n");
>
>@@ -200,23 +199,25 @@ static int ehci_bus_suspend (struct usb_
> 	while (port--) {
> 		u32 __iomem	*reg = &ehci->regs->port_status [port];
> 		u32		t1 = ehci_readl(ehci, reg) & ~PORT_RWC_BITS;
>-		u32		t2 = t1;
>+		u32		t2 = t1 & ~PORT_WAKE_BITS;
>
>-		if (ehci->has_hostpc)
>-			hostpc_reg = (u32 __iomem *)((u8 *)ehci->regs
>-				+ HOSTPC0 + 4 * (port & 0xff));
> 		/* keep track of which ports we suspend */
>-		if (t1 & PORT_OWNER)
>-			set_bit(port, &ehci->owned_ports);
>-		else if ((t1 & PORT_PE) && !(t1 & PORT_SUSPEND)) {
>-			t2 |= PORT_SUSPEND;
>-			set_bit(port, &ehci->bus_suspended);
>-			ehci_vdbg (ehci, "port %d, %08x -> %08x\n",
>-				port + 1, t1, t2);
>-			ehci_writel(ehci, t2, reg);
>-			if (hostpc_reg) {
>-				u32	t3;
>+		if (!(t1 & PORT_SUSPEND)) {
>+			if (t1 & PORT_OWNER) {
>+				set_bit(port, &ehci->owned_ports);
>+			} else if (t1 & PORT_PE) {
>+				t2 |= PORT_SUSPEND;
>+				set_bit(port, &ehci->bus_suspended);
>+				ehci_vdbg (ehci, "port %d, %08x -> %08x\n",
>+					port + 1, t1, t2);
>+				ehci_writel(ehci, t2, reg);
>+			}
>+			if (ehci->has_hostpc) {
>+				u32 __iomem	*hostpc_reg;
>+				u32		t3;
>
>+				hostpc_reg = (u32 __iomem *)((u8 *)ehci->regs
>+					+ HOSTPC0 + 4 * (port & 0xff));
> 				spin_unlock_irq(&ehci->lock);
> 				msleep(5);/* 5ms for HCD enter low pwr mode */
> 				spin_lock_irq(&ehci->lock);

