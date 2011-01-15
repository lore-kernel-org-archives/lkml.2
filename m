Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab1AOA7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 19:59:37 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:4718 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752410Ab1AOA7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 19:59:35 -0500
Subject: [PATCH net-next 3/8] vmxnet3: Enable HW Rx VLAN stripping by default
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From: Shreyas N Bhatewara <sbhatewara@vmware.com>
Cc: pv-drivers@vmware.com, Guolin Yang <gyang@vmware.com>
Date: Fri, 14 Jan 2011 16:59:36 -0800
Message-ID: <20110115005936.1064.46582.stgit@sbhatewara-dev1.eng.vmware.com>
In-Reply-To: <20110115005701.1064.67435.stgit@sbhatewara-dev1.eng.vmware.com>
References: <20110115005701.1064.67435.stgit@sbhatewara-dev1.eng.vmware.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make hw vlan tag stripping as enabled by default. Thereby remove
the code to conditionally enable it later.

Signed-off-by: Guolin Yang <gyang@vmware.com>
Signed-off-by: Shreyas N Bhatewara <sbhatewara@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 89bcee8..f47db1c 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1867,13 +1867,8 @@ vmxnet3_vlan_rx_register(struct net_device *netdev, struct vlan_group *grp)
 		/* add vlan rx stripping. */
 		if (adapter->netdev->features & NETIF_F_HW_VLAN_RX) {
 			int i;
-			struct Vmxnet3_DSDevRead *devRead = &shared->devRead;
 			adapter->vlan_grp = grp;
 
-			/* update FEATURES to device */
-			devRead->misc.uptFeatures |= UPT1_F_RXVLAN;
-			VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD,
-					       VMXNET3_CMD_UPDATE_FEATURE);
 			/*
 			 *  Clear entire vfTable; then enable untagged pkts.
 			 *  Note: setting one entry in vfTable to non-zero turns
@@ -1905,11 +1900,6 @@ vmxnet3_vlan_rx_register(struct net_device *netdev, struct vlan_group *grp)
 			}
 			VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD,
 					       VMXNET3_CMD_UPDATE_VLAN_FILTERS);
-
-			/* update FEATURES to device */
-			devRead->misc.uptFeatures &= ~UPT1_F_RXVLAN;
-			VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD,
-					       VMXNET3_CMD_UPDATE_FEATURE);
 		}
 	}
 }
@@ -2083,10 +2073,8 @@ vmxnet3_setup_driver_shared(struct vmxnet3_adapter *adapter)
 		devRead->misc.uptFeatures |= UPT1_F_LRO;
 		devRead->misc.maxNumRxSG = cpu_to_le16(1 + MAX_SKB_FRAGS);
 	}
-	if ((adapter->netdev->features & NETIF_F_HW_VLAN_RX) &&
-	    adapter->vlan_grp) {
+	if (adapter->netdev->features & NETIF_F_HW_VLAN_RX)
 		devRead->misc.uptFeatures |= UPT1_F_RXVLAN;
-	}
 
 	devRead->misc.mtu = cpu_to_le32(adapter->netdev->mtu);
 	devRead->misc.queueDescPA = cpu_to_le64(adapter->queue_desc_pa);

