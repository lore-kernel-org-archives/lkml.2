Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110Ab2HYDX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 23:23:59 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:53533 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab2HYDXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 23:23:22 -0400
From: David Decotigny <decot@googlers.com>
To: Ayaz Abdulla <aabdulla@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Joe Perches <joe@perches.com>,
        David Decotigny <decot@googlers.com>
Subject: [PATCH net-next v1 3/3] forcedeth: prevent TX timeouts after reboot
Date: Fri, 24 Aug 2012 20:22:53 -0700
Message-Id: <99df7d049cc0060a7a8bcdb6931a723cb2c172ed.1345864542.git.decot@googlers.com>
X-Mailer: git-send-email 1.7.10.2.5.g20d7bc9
In-Reply-To: <cover.1345864542.git.decot@googlers.com>
References: <cover.1345864542.git.decot@googlers.com>
In-Reply-To: <cover.1345864542.git.decot@googlers.com>
References: <cover.1345864542.git.decot@googlers.com>
Organization: Google, Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This complements patch "net-forcedeth: fix TX timeout caused by TX
pause on down link" which ensures that a lock-up sequence is not sent
to the NIC. Present patch ensures that if a NIC is already locked-up,
the driver will recover from it when initializing the device.

It does the equivalent of the following recovery sequence:
 - write NVREG_TX_PAUSEFRAME_ENABLE_V1 to eth1's register
   NvRegTxPauseFrame
 - write NVREG_XMITCTL_START to eth1's register
   NvRegTransmitterControl
 - write 0 to eth1's register NvRegTransmitterControl
(this is at the heart of the "unbricking" sequence mentioned in patch
 "net-forcedeth: fix TX timeout caused by TX pause on down link")

Tested:
 - hardware is MCP55 device id 10de:0373 (rev a3), dual-port
 - reboot a kernel without any of patches mentioned
 - freeze the NIC (details on description for commit "net-forcedeth:
   fix TX timeout caused by TX pause on down link")
 - wait 5mn until ping hangs & TX timeout in dmesg
 - reboot on kernel with present patch
 - host is immediatly operational, no TX timeout



Signed-off-by: David Decotigny <decot@googlers.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 8b82457..edd6221 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -5905,11 +5905,18 @@ static int __devinit nv_probe(struct pci_dev *pci_dev, const struct pci_device_i
 		goto out_error;
 	}
 
+	netif_carrier_off(dev);
+
+	/* Some NICs freeze when TX pause is enabled while NIC is
+	 * down, and this stays across warm reboots. The sequence
+	 * below should be enough to recover from that state. */
+	nv_update_pause(dev, 0);
+	nv_start_tx(dev);
+	nv_stop_tx(dev);
+
 	if (id->driver_data & DEV_HAS_VLAN)
 		nv_vlan_mode(dev, dev->features);
 
-	netif_carrier_off(dev);
-
 	dev_info(&pci_dev->dev, "ifname %s, PHY OUI 0x%x @ %d, addr %pM\n",
 		 dev->name, np->phy_oui, np->phyaddr, dev->dev_addr);
 
-- 
1.7.10.2.5.g20d7bc9

