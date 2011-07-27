Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab1G0AjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:39:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:52724 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816Ab1G0AfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="30471142"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: cjb@laptop.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] [21/98] mmc: sdhci-pci: Fix error case in sdhci_pci_probe_slot()
Message-Id: <20110727003513.581E72403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Chris Ball <cjb@laptop.org>

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/mmc/host/sdhci-pci.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/mmc/host/sdhci-pci.c
===================================================================
--- linux-2.6.35.y.orig/drivers/mmc/host/sdhci-pci.c
+++ linux-2.6.35.y/drivers/mmc/host/sdhci-pci.c
@@ -653,6 +653,7 @@ static struct sdhci_pci_slot * __devinit
 	host->ioaddr = pci_ioremap_bar(pdev, bar);
 	if (!host->ioaddr) {
 		dev_err(&pdev->dev, "failed to remap registers\n");
+		ret = -ENOMEM;
 		goto release;
 	}
 
