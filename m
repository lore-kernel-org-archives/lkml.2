Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab1GBS75 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 14:59:57 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:35309 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303Ab1GBS7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 14:59:55 -0400
From: Matthieu CASTET <castet.matthieu@free.fr>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Cc: Matthieu CASTET <castet.matthieu@free.fr>
Subject: [PATCH 1/2] EHCI : introduce a common ehci_setup
Date: Sat,  2 Jul 2011 20:59:45 +0200
Message-Id: <1309633186-31693-1-git-send-email-castet.matthieu@free.fr>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allow to clean duplicated code in most of SOC driver.

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
---
 drivers/usb/host/ehci-hcd.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index f8030ee..f990b0f 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -763,6 +763,35 @@ static int ehci_run (struct usb_hcd *hcd)
 	return 0;
 }
 
+static int __maybe_unused ehci_setup (struct usb_hcd *hcd)
+{
+	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
+	int retval;
+
+	ehci->regs = (void __iomem *)ehci->caps +
+	    HC_LENGTH(ehci, ehci_readl(ehci, &ehci->caps->hc_capbase));
+	dbg_hcs_params(ehci, "reset");
+	dbg_hcc_params(ehci, "reset");
+
+	/* cache this readonly data; minimize chip reads */
+	ehci->hcs_params = ehci_readl(ehci, &ehci->caps->hcs_params);
+
+	ehci->sbrn = HCD_USB2;
+
+	retval = ehci_halt(ehci);
+	if (retval)
+		return retval;
+
+	/* data structure init */
+	retval = ehci_init(hcd);
+	if (retval)
+		return retval;
+
+	ehci_reset(ehci);
+
+	return 0;
+}
+
 /*-------------------------------------------------------------------------*/
 
 static irqreturn_t ehci_irq (struct usb_hcd *hcd)
-- 
1.7.5.4

