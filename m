Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635Ab1KJDUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:20:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41561 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933598Ab1KJDT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:19:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:01 2011
Message-Id: <20111109212701.836443889@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:25:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matthieu CASTET <castet.matthieu@free.fr>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [015/262] EHCI : introduce a common ehci_setup
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu CASTET <castet.matthieu@free.fr>

commit 2093c6b49c8f1dc581d8953aca71297d4cace55e upstream.

This allow to clean duplicated code in most of SOC driver.

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-hcd.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -761,6 +761,35 @@ static int ehci_run (struct usb_hcd *hcd
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


