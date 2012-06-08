Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab2FHBHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 21:07:05 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:30338 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759472Ab2FHBHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 21:07:02 -0400
Message-ID: <4FD15020.7090709@oracle.com>
Date: Fri, 08 Jun 2012 09:06:40 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Guru Anbalagane <guru.anbalagane@oracle.com>,
        Adnan Misherfi <adnan.misherfi@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
CC: e1000-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH] e1000e: disable rxhash when try to enable jumbo frame also
 rxhash and rxcsum have enabled
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upstream commit 70495a5 check if both rxhash and rxcsum enabled when enabling
jumbo frames and disallowed all of them enabled at the same time.

Since jumbo frame widely be used in real world, so when try to enable jumbo
frames but rxhash and rxcsum have enabled, change the default behavior to
disable receive hashing.

Signed-off-by: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Guru Anbalagane <guru.anbalagane@oracle.com>
Acked-by: Adnan Misherfi <adnan.misherfi@oracle.com>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/intel/e1000e/netdev.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index a4b0435..b9f0857 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -66,6 +66,8 @@ module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
 
 static void e1000e_disable_aspm(struct pci_dev *pdev, u16 state);
+static int e1000_set_features(struct net_device *netdev,
+			      netdev_features_t features);
 
 static const struct e1000_info *e1000_info_tbl[] = {
 	[board_82571]		= &e1000_82571_info,
@@ -5254,8 +5256,15 @@ static int e1000_change_mtu(struct net_device *netdev, int new_mtu)
 		 */
 		if ((netdev->features & NETIF_F_RXCSUM) &&
 		    (netdev->features & NETIF_F_RXHASH)) {
-			e_err("Jumbo frames cannot be enabled when both receive checksum offload and receive hashing are enabled.  Disable one of the receive offload features before enabling jumbos.\n");
-			return -EINVAL;
+			netdev_features_t features;
+
+			/* Disable receive hashing if conflicted */
+			features = netdev->features & (~NETIF_F_RXHASH);
+			if (e1000_set_features(netdev, features)) {
+				e_err("Jumbo frames cannot be enabled when both receive checksum offload and receive hashing are enabled.  Disable one of the receive offload features before enabling jumbos.\n");
+				return -EINVAL;
+			}
+			e_info("Jumbo frames cannot be enabled when both receive checksum offload and receive hashing are enabled. Disabling Receive Hashing.\n");
 		}
 	}
 
-- 
1.7.10.2

