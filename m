Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1FOU3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 16:29:09 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62718 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab1FOU3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:29:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=btkoQNW/Yil/fhAsmpo3aBQNwJqG6W+lTNoUesDaf57G21oheOHDI5chyZsH7gTv+w
         BcM/1IvKmzuiYI5zxXZes536NbMaMkO7UKTl7CHXRpLQ/WmcVjJ1Ytps+eMItqsa116R
         WXN4MBtRp6txZPnC/fYdGJbdmhzrSRsYB0lq4=
Message-ID: <4DF9160D.8090109@gmail.com>
Date: Wed, 15 Jun 2011 22:29:01 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] xhci: Add reset on resume quirk for asrock p67 host
References: <4DF85A1F.1080001@gmail.com> <20110615165842.GB5382@xanatos> <4DF8EE62.3060407@gmail.com> <20110615195928.GD5382@xanatos>
In-Reply-To: <20110615195928.GD5382@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The asrock p67 xhci controller completely dies on resume,
add a quirk for this, to bring the host back online after a suspend.

This should be backported to stable kernels as far back as 2.6.34.

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: stable@kernel.org
---
I have no idea if the vendor name is correct. lspci didn't list it.

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 17541d0..cb16de2 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -29,6 +29,9 @@
 #define PCI_VENDOR_ID_FRESCO_LOGIC	0x1b73
 #define PCI_DEVICE_ID_FRESCO_LOGIC_PDK	0x1000
 
+#define PCI_VENDOR_ID_ETRON		0x1b6f
+#define PCI_DEVICE_ID_ASROCK_P67	0x7023
+
 static const char hcd_name[] = "xhci_hcd";
 
 /* called after powerup, by probe or system-pm "wakeup" */
@@ -134,6 +137,11 @@ static int xhci_pci_setup(struct usb_hcd *hcd)
 		xhci->quirks |= XHCI_EP_LIMIT_QUIRK;
 		xhci->limit_active_eps = 64;
 	}
+	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
+			pdev->device == PCI_DEVICE_ID_ASROCK_P67) {
+		xhci->quirks |= XHCI_RESET_ON_RESUME;
+		xhci_dbg(xhci, "QUIRK: Resetting on resume\n");
+	}
 
 	/* Make sure the HC is halted. */
 	retval = xhci_halt(xhci);
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 06e7023..42fd032 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -759,6 +759,8 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 		msleep(100);
 
 	spin_lock_irq(&xhci->lock);
+	if (xhci->quirks & XHCI_RESET_ON_RESUME)
+		hibernated = 0;
 
 	if (!hibernated) {
 		/* step 1: restore register */
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 7d1ea3b..b769a75 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1308,6 +1308,7 @@ struct xhci_hcd {
  */
 #define XHCI_EP_LIMIT_QUIRK	(1 << 5)
 #define XHCI_BROKEN_MSI		(1 << 6)
+#define XHCI_RESET_ON_RESUME	(1 << 7)
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
 	/* There are two roothubs to keep track of bus suspend info for */


