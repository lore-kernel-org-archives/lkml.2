Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab1FWRWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:22:17 -0400
Received: from mail.windriver.com ([147.11.1.11]:62924 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759864Ab1FWRWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:11 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 016/247] USB: EHCI: fix DMA deallocation bug
Date: Thu, 23 Jun 2011 13:17:39 -0400
Message-Id: <1308849690-14530-17-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/ehci-hcd.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 8b6b270..5a32023 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -545,6 +545,8 @@ static int ehci_init(struct usb_hcd *hcd)
 	ehci->iaa_watchdog.function = ehci_iaa_watchdog;
 	ehci->iaa_watchdog.data = (unsigned long) ehci;
 
+	hcc_params = ehci_readl(ehci, &ehci->caps->hcc_params);
+
 	/*
 	 * hw default: 1K periodic list heads, one per frame.
 	 * periodic_size can shrink by USBCMD update if hcc_params allows.
@@ -552,11 +554,20 @@ static int ehci_init(struct usb_hcd *hcd)
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
@@ -605,12 +616,6 @@ static int ehci_init(struct usb_hcd *hcd)
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
 
-- 
1.7.4.4

