Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030320Ab2HPScG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:32:06 -0400
Received: from eng.riverbed.com ([208.70.196.45]:29309 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757011Ab2HPScD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:32:03 -0400
X-Greylist: delayed 590 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2012 14:32:02 EDT
From: Jiang Wang <Jiang.Wang@riverbed.com>
To: Michael Chan <mchan@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: clala@riverbed.com, Francis.St.Amant@riverbed.com,
        Jiang Wang <Jiang.Wang@riverbed.com>, Jiang Wang <jwang@riverbed.com>
Subject: [PATCH] bnx2: turn off the network statck during initialization
Date: Thu, 16 Aug 2012 11:21:35 -0700
Message-Id: <1345141295-7589-1-git-send-email-Jiang.Wang@riverbed.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initialization state of bnx2 driver is wrong. It does not turn
of the Linux network stack using netif_carrier_off. This may lead to
inconsistent report from ethtool as the link is up but speed is
unknown when the cable is not plugged in.

E.g.
        Speed: Unknown! (0)<--------------------------------------
        Duplex: Half       <--------------------------------------
        MDI: Unknown! (0)
        Port: Twisted Pair
        PHYAD: 1
        Transceiver: internal
        Auto-negotiation: on
        Supports Wake-on: g
        Wake-on: d
        Link detected: yes <---------------------------------------

This patches fixed the problem by turning off the network stack
during initialization.

Signed-off-by: Jiang Wang <jwang@riverbed.com>
---
 drivers/net/ethernet/broadcom/bnx2.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index ac7b744..ce4548d 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -8463,6 +8463,10 @@ bnx2_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->features |= dev->hw_features;
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
+	/* tell the stack to leave us alone until bnx2_open() is called */
+	netif_carrier_off(dev);
+	netif_stop_queue(dev);
+
 	if ((rc = register_netdev(dev))) {
 		dev_err(&pdev->dev, "Cannot register net device\n");
 		goto error;
-- 
1.7.1

