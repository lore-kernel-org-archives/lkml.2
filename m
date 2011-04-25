Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab1DYVBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 17:01:21 -0400
Received: from 1wt.eu ([62.212.114.60]:33742 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755730Ab1DYUXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:23:24 -0400
Message-Id: <20110425200233.257938264@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:02:38 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
        David Brownell <david-b@pacbell.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 006/173] USB: EHCI: fix DMA deallocation bug
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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

Index: longterm-2.6.27/drivers/usb/host/ehci-hcd.c
===================================================================
--- longterm-2.6.27.orig/drivers/usb/host/ehci-hcd.c	2011-04-25 11:14:47.000000000 +0200
+++ longterm-2.6.27/drivers/usb/host/ehci-hcd.c	2011-04-25 11:43:03.837278216 +0200
@@ -488,17 +488,29 @@
 	ehci->iaa_watchdog.function = ehci_iaa_watchdog;
 	ehci->iaa_watchdog.data = (unsigned long) ehci;
 
+	hcc_params = ehci_readl(ehci, &ehci->caps->hcc_params);
+
 	/*
 	 * hw default: 1K periodic list heads, one per frame.
 	 * periodic_size can shrink by USBCMD update if hcc_params allows.
 	 */
 	ehci->periodic_size = DEFAULT_I_TDPS;
 	INIT_LIST_HEAD(&ehci->cached_itd_list);
+
+	if (HCC_PGM_FRAMELISTLEN(hcc_params)) {
+		/* periodic schedule size can be smaller than default */
+		switch (EHCI_TUNE_FLS) {
+		case 0: ehci->periodic_size = 1024; break;
+		case 1: ehci->periodic_size = 512; break;
+		case 2: ehci->periodic_size = 256; break;
+		default:        BUG();
+		}
+	}
+
 	if ((retval = ehci_mem_init(ehci, GFP_KERNEL)) < 0)
 		return retval;
 
 	/* controllers may cache some of the periodic schedule ... */
-	hcc_params = ehci_readl(ehci, &ehci->caps->hcc_params);
 	if (HCC_ISOC_CACHE(hcc_params))		// full frame cache
 		ehci->i_thresh = 8;
 	else					// N microframes cached
@@ -546,12 +558,6 @@
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
 	ehci->command = temp;
 


