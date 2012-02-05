Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab2BEW0N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:26:13 -0500
Received: from 1wt.eu ([62.212.114.60]:61789 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab2BEW0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:05 -0500
Message-Id: <20120205220949.749606496@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:09:56 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Chris Ball <cjb@laptop.org>, Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 07/91] mmc: sdhci-pci: Fix error case in sdhci_pci_probe_slot()
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 9fdcdbb0d84922e7ccda2f717a04ea62629f7e18 upstream.

If pci_ioremap_bar() fails during probe, we "goto release;" and free the
host, but then we return 0 -- which tells sdhci_pci_probe() that the probe
succeeded.  Since we think the probe succeeded, when we unload sdhci we'll
go to sdhci_pci_remove_slot() and it will try to dereference slot->host,
which is now NULL because we freed it in the error path earlier.

The patch simply sets ret appropriately, so that sdhci_pci_probe() will
detect the failure immediately and bail out.

Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/mmc/host/sdhci-pci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/drivers/mmc/host/sdhci-pci.c
===================================================================
--- longterm-2.6.27.orig/drivers/mmc/host/sdhci-pci.c	2012-02-05 22:34:34.824917273 +0100
+++ longterm-2.6.27/drivers/mmc/host/sdhci-pci.c	2012-02-05 22:34:35.914915549 +0100
@@ -547,6 +547,7 @@
 	host->ioaddr = ioremap_nocache(addr, pci_resource_len(pdev, bar));
 	if (!host->ioaddr) {
 		dev_err(&pdev->dev, "failed to remap registers\n");
+		ret = -ENOMEM;
 		goto release;
 	}
 


