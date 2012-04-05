Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab2DEPLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:11:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49393 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab2DEPLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 11:11:30 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Alex Duyck <alexander.h.duyck@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Emil Tantilov <emil.s.tantilov@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        John Ronciak <john.ronciak@intel.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: [PATCH 1/2] igb: fix rtnl race in PM resume path
Date: Thu,  5 Apr 2012 11:11:03 -0400
Message-Id: <1333638664-17062-1-git-send-email-bpoirier@suse.de>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the caller (PM resume code) is not the one holding rtnl, when taking the
'else' branch rtnl may be released at any moment, thereby defeating the whole
purpose of this code block.

Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
---
 drivers/net/ethernet/intel/igb/igb_main.c |   20 ++++++--------------
 1 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index f022ff7..4854ab6 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -1083,9 +1083,12 @@ msi_only:
 		adapter->flags |= IGB_FLAG_HAS_MSI;
 out:
 	/* Notify the stack of the (possibly) reduced queue counts. */
+	rtnl_lock();
 	netif_set_real_num_tx_queues(adapter->netdev, adapter->num_tx_queues);
-	return netif_set_real_num_rx_queues(adapter->netdev,
-					    adapter->num_rx_queues);
+	err = netif_set_real_num_rx_queues(adapter->netdev,
+		adapter->num_rx_queues);
+	rtnl_unlock();
+	return err;
 }
 
 /**
@@ -6646,18 +6649,7 @@ static int igb_resume(struct device *dev)
 	pci_enable_wake(pdev, PCI_D3hot, 0);
 	pci_enable_wake(pdev, PCI_D3cold, 0);
 
-	if (!rtnl_is_locked()) {
-		/*
-		 * shut up ASSERT_RTNL() warning in
-		 * netif_set_real_num_tx/rx_queues.
-		 */
-		rtnl_lock();
-		err = igb_init_interrupt_scheme(adapter);
-		rtnl_unlock();
-	} else {
-		err = igb_init_interrupt_scheme(adapter);
-	}
-	if (err) {
+	if (igb_init_interrupt_scheme(adapter)) {
 		dev_err(&pdev->dev, "Unable to allocate memory for queues\n");
 		return -ENOMEM;
 	}
-- 
1.7.7

