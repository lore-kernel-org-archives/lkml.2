Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab1KJEdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:33:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964958Ab1KJDhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:37:20 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:47 2011
Message-Id: <20111109213147.323392353@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:31:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matthew Garrett <mjg@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [052/264] USB: Fix runtime wakeup on OHCI
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Garrett <mjg@redhat.com>

commit a8b43c00ef06aec49b9fe0a5bad8a6a320e4d27b upstream.

At least some OHCI hardware (such as the MCP89) fails to flag any change
in the host status register or the port status registers when receiving
a remote wakeup while in D3 state. This results in the controller being
resumed but no device state change being noticed, at which point the
controller is put back to sleep again. Since there doesn't seem to be any
reliable way to identify the state change, just unconditionally resume the
hub. It'll be put back to sleep in the near future anyway if there are no
active devices attached to it.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ohci-hub.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/usb/host/ohci-hub.c
+++ b/drivers/usb/host/ohci-hub.c
@@ -356,10 +356,7 @@ static void ohci_finish_controller_resum
 		msleep(20);
 	}
 
-	/* Does the root hub have a port wakeup pending? */
-	if (ohci_readl(ohci, &ohci->regs->intrstatus) &
-			(OHCI_INTR_RD | OHCI_INTR_RHSC))
-		usb_hcd_resume_root_hub(hcd);
+	usb_hcd_resume_root_hub(hcd);
 }
 
 /* Carry out polling-, autostop-, and autoresume-related state changes */


