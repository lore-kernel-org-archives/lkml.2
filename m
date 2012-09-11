Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab2IKLgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:36:36 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:55378 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759206Ab2IKLeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:34:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AscCAIAhT1BbdWObgWdsb2JhbABFhge1SSIBARYmJ4IhAQUjBAsBRhAlAiYCAlcGE4gUqGiTN4EhjwOBEgOVXYkziVI
X-IronPort-AV: E=Sophos;i="4.80,404,1344204000"; 
   d="scan'208";a="564505371"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH v2 11/20] Staging: ipack/bridges/tpci200: reorder the iounmap and pci_release_region
Date: Tue, 11 Sep 2012 13:35:04 +0200
Message-Id: <1347363313-17094-12-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347363313-17094-1-git-send-email-siglesias@igalia.com>
References: <1347363313-17094-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move iounmap and pci_release_region to tpci200_unregister(), as it is the place
where the clean-up of the device is done.

Also, renamed iounmap() to pci_iounmap() as the mapped region was requested
from PCI bus.

Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 22e3da1..383571c 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -64,10 +64,12 @@ static void tpci200_unregister(struct tpci200_board *tpci200)
 	pci_iounmap(tpci200->info->pdev, tpci200->info->interface_regs);
 	pci_iounmap(tpci200->info->pdev, tpci200->info->ioidint_space);
 	pci_iounmap(tpci200->info->pdev, tpci200->info->mem8_space);
+	pci_iounmap(tpci200->info->pdev, tpci200->info->cfg_regs);
 
 	pci_release_region(tpci200->info->pdev, TPCI200_IP_INTERFACE_BAR);
 	pci_release_region(tpci200->info->pdev, TPCI200_IO_ID_INT_SPACES_BAR);
 	pci_release_region(tpci200->info->pdev, TPCI200_MEM8_SPACE_BAR);
+	pci_release_region(tpci200->info->pdev, TPCI200_CFG_MEM_BAR);
 
 	pci_disable_device(tpci200->info->pdev);
 	pci_dev_put(tpci200->info->pdev);
@@ -750,9 +752,6 @@ static void __tpci200_pci_remove(struct tpci200_board *tpci200)
 	tpci200_uninstall(tpci200);
 	ipack_bus_unregister(tpci200->info->ipack_bus);
 
-	iounmap(tpci200->info->cfg_regs);
-	pci_release_region(tpci200->info->pdev, TPCI200_CFG_MEM_BAR);
-
 	kfree(tpci200->info);
 	kfree(tpci200);
 }
-- 
1.7.10.4

