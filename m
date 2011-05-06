Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab1EFASa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:18:30 -0400
Received: from kroah.org ([198.145.64.141]:32856 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631Ab1EFANX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:13:23 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:12:08 2011
Message-Id: <20110506001208.853975850@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:10:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Ball <cjb@laptop.org>
Subject: [patch 16/38] mmc: sdhci-pci: Fix error case in sdhci_pci_probe_slot()
In-Reply-To: <20110506001225.GA10547@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/mmc/host/sdhci-pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -961,6 +961,7 @@ static struct sdhci_pci_slot * __devinit
 	host->ioaddr = pci_ioremap_bar(pdev, bar);
 	if (!host->ioaddr) {
 		dev_err(&pdev->dev, "failed to remap registers\n");
+		ret = -ENOMEM;
 		goto release;
 	}
 


