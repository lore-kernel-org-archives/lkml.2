Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965742Ab2EOCmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:42:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:49761 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964884Ab2EOCRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:39 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 122/179] USB: OHCI: fix another regression for NVIDIA controllers
Date: Mon, 14 May 2012 22:13:38 -0400
Message-ID: <1337048075-6132-123-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6ea12a04d295235ed67010a09fdea58c949e3eb0 upstream.

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
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/pci-quirks.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 464ed97..bcf7a88 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -34,6 +34,8 @@
 #define OHCI_INTRSTATUS		0x0c
 #define OHCI_INTRENABLE		0x10
 #define OHCI_INTRDISABLE	0x14
+#define OHCI_FMINTERVAL		0x34
+#define OHCI_HCR		(1 << 0)	/* host controller reset */
 #define OHCI_OCR		(1 << 3)	/* ownership change request */
 #define OHCI_CTRL_RWC		(1 << 9)	/* remote wakeup connected */
 #define OHCI_CTRL_IR		(1 << 8)	/* interrupt routing */
@@ -204,6 +206,32 @@ static void __devinit quirk_usb_handoff_ohci(struct pci_dev *pdev)
 
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
-- 
1.7.9.6

