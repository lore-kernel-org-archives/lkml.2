Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919Ab2CMAXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:23:22 -0400
Received: from mail.windriver.com ([147.11.1.11]:48116 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758643Ab2CMAXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Chris Ball <cjb@laptop.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 107/196] mmc: sdhci-pci: Fix error case in sdhci_pci_probe_slot()
Date: Mon, 12 Mar 2012 20:20:20 -0400
Message-Id: <1331598109-31424-62-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Ball <cjb@laptop.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 9fdcdbb0d84922e7ccda2f717a04ea62629f7e18 upstream.

If pci_ioremap_bar() fails during probe, we "goto release;" and free the
host, but then we return 0 -- which tells sdhci_pci_probe() that the probe
succeeded.  Since we think the probe succeeded, when we unload sdhci we'll
go to sdhci_pci_remove_slot() and it will try to dereference slot->host,
which is now NULL because we freed it in the error path earlier.

The patch simply sets ret appropriately, so that sdhci_pci_probe() will
detect the failure immediately and bail out.

Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/mmc/host/sdhci-pci.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 6701af6..e907447 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -653,6 +653,7 @@ static struct sdhci_pci_slot * __devinit sdhci_pci_probe_slot(
 	host->ioaddr = pci_ioremap_bar(pdev, bar);
 	if (!host->ioaddr) {
 		dev_err(&pdev->dev, "failed to remap registers\n");
+		ret = -ENOMEM;
 		goto release;
 	}
 
-- 
1.7.9.3

