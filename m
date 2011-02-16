Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab1BPASi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:18:38 -0500
Received: from kroah.org ([198.145.64.141]:38675 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756672Ab1BPASf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:18:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:27 2011
Message-Id: <20110216001427.541190183@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>,
        David Brownell <david-b@pacbell.net>
Subject: [025/272] USB: EHCI: fix DMA deallocation bug
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit f75593ceaa08e6d27aec1a5de31cded19e850dd1 upstream.

This patch (as1440) fixes a bug in ehci-hcd.  ehci->periodic_size is
used to compute the size in a dma_alloc_coherent() call, but then it
gets changed later on.  As a result, the corresponding call to
dma_free_coherent() passes a different size from the original
allocation.  Fix the problem by adjusting ehci->periodic_size before
carrying out any of the memory allocations.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
CC: David Brownell <david-b@pacbell.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-hcd.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -572,6 +572,8 @@ static int ehci_init(struct usb_hcd *hcd
 	ehci->iaa_watchdog.function = ehci_iaa_watchdog;
 	ehci->iaa_watchdog.data = (unsigned long) ehci;
 
+	hcc_params = ehci_readl(ehci, &ehci->caps->hcc_params);
+
 	/*
 	 * hw default: 1K periodic list heads, one per frame.
 	 * periodic_size can shrink by USBCMD update if hcc_params allows.
@@ -579,11 +581,20 @@ static int ehci_init(struct usb_hcd *hcd
 	ehci->periodic_size = DEFAULT_I_TDPS;
 	INIT_LIST_HEAD(&ehci->cached_itd_list);
 	INIT_LIST_HEAD(&ehci->cached_sitd_list);
+
+	if (HCC_PGM_FRAMELISTLEN(hcc_params)) {
+		/* periodic schedule size can be smaller than default */
+		switch (EHCI_TUNE_FLS) {
+		case 0: ehci->periodic_size = 1024; break;
+		case 1: ehci->periodic_size = 512; break;
+		case 2: ehci->periodic_size = 256; break;
+		default:	BUG();
+		}
+	}
 	if ((retval = ehci_mem_init(ehci, GFP_KERNEL)) < 0)
 		return retval;
 
 	/* controllers may cache some of the periodic schedule ... */
-	hcc_params = ehci_readl(ehci, &ehci->caps->hcc_params);
 	if (HCC_ISOC_CACHE(hcc_params))		// full frame cache
 		ehci->i_thresh = 2 + 8;
 	else					// N microframes cached
@@ -637,12 +648,6 @@ static int ehci_init(struct usb_hcd *hcd
 		/* periodic schedule size can be smaller than default */
 		temp &= ~(3 << 2);
 		temp |= (EHCI_TUNE_FLS << 2);
-		switch (EHCI_TUNE_FLS) {
-		case 0: ehci->periodic_size = 1024; break;
-		case 1: ehci->periodic_size = 512; break;
-		case 2: ehci->periodic_size = 256; break;
-		default:	BUG();
-		}
 	}
 	if (HCC_LPM(hcc_params)) {
 		/* support link power management EHCI 1.1 addendum */


