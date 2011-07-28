Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab1G1Xom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:44:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:29705 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756177Ab1G1XoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="33352022"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: stern@rowland.harvard.edu, Larry.Finger@lwfinger.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [20/50] USB: OHCI: fix another regression for NVIDIA controllers
Message-Id: <20110728234424.A5EAD2403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

[ upstream commit 6ea12a04d295235ed67010a09fdea58c949e3eb0 ]

The NVIDIA series of OHCI controllers continues to be troublesome.  A
few people using the MCP67 chipset have reported that even with the
most recent kernels, the OHCI controller fails to handle new
connections and spams the system log with "unable to enumerate USB
port" messages.  This is different from the other problems previously
reported for NVIDIA OHCI controllers, although it is probably related.

It turns out that the MCP67 controller does not like to be kept in the
RESET state very long.  After only a few seconds, it decides not to
work any more.  This patch (as1479) changes the PCI initialization
quirk code so that NVIDIA controllers are switched into the SUSPEND
state after 50 ms of RESET.  With no interrupts enabled and all the
downstream devices reset, and thus unable to send wakeup requests,
this should be perfectly safe (even for non-NVIDIA hardware).

The removal code in ohci-hcd hasn't been changed; it will still leave
the controller in the RESET state.  As a result, if someone unloads
ohci-hcd and then reloads it, the controller won't work again until
the system is rebooted.  If anybody complains about this, the removal
code can be updated similarly.

This fixes Bugzilla #22052.

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: stable <stable@kernel.org>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/usb/host/pci-quirks.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/pci-quirks.c
+++ linux-2.6.35.y/drivers/usb/host/pci-quirks.c
@@ -34,6 +34,8 @@
 #define OHCI_INTRSTATUS		0x0c
 #define OHCI_INTRENABLE		0x10
 #define OHCI_INTRDISABLE	0x14
+#define OHCI_FMINTERVAL		0x34
+#define OHCI_HCR		(1 << 0)	/* host controller reset */
 #define OHCI_OCR		(1 << 3)	/* ownership change request */
 #define OHCI_CTRL_RWC		(1 << 9)	/* remote wakeup connected */
 #define OHCI_CTRL_IR		(1 << 8)	/* interrupt routing */
@@ -204,6 +206,32 @@ static void __devinit quirk_usb_handoff_
 
 	/* reset controller, preserving RWC (and possibly IR) */
 	writel(control & OHCI_CTRL_MASK, base + OHCI_CONTROL);
+	readl(base + OHCI_CONTROL);
+
+	/* Some NVIDIA controllers stop working if kept in RESET for too long */
+	if (pdev->vendor == PCI_VENDOR_ID_NVIDIA) {
+		u32 fminterval;
+		int cnt;
+
+		/* drive reset for at least 50 ms (7.1.7.5) */
+		msleep(50);
+
+		/* software reset of the controller, preserving HcFmInterval */
+		fminterval = readl(base + OHCI_FMINTERVAL);
+		writel(OHCI_HCR, base + OHCI_CMDSTATUS);
+
+		/* reset requires max 10 us delay */
+		for (cnt = 30; cnt > 0; --cnt) {	/* ... allow extra time */
+			if ((readl(base + OHCI_CMDSTATUS) & OHCI_HCR) == 0)
+				break;
+			udelay(1);
+		}
+		writel(fminterval, base + OHCI_FMINTERVAL);
+
+		/* Now we're in the SUSPEND state with all devices reset
+		 * and wakeups and interrupts disabled
+		 */
+	}
 
 	/*
 	 * disable interrupts
