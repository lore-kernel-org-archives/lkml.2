Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab2B2Pnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 10:43:47 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:38819 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758122Ab2B2PnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 10:43:18 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Danny Kukawka <dkukawka@suse.de>, Jiri Pirko <jpirko@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] octeon: use dev_set_mac_address() instead of octeon_mgmt_set_mac_address()
Date: Wed, 29 Feb 2012 16:42:56 +0100
Message-Id: <1330530176-24952-9-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1330530176-24952-1-git-send-email-danny.kukawka@bisect.de>
References: <1330530176-24952-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1330530198;532884fb;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_set_mac_address() instead of octeon_mgmt_set_mac_address() directly
to get validation checks for free.

Add .ndo_validate_addr = eth_validate_addr to enable validation.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/ethernet/octeon/octeon_mgmt.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/octeon/octeon_mgmt.c b/drivers/net/ethernet/octeon/octeon_mgmt.c
index cd827ff..fb6553d 100644
--- a/drivers/net/ethernet/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/octeon/octeon_mgmt.c
@@ -551,9 +551,6 @@ static int octeon_mgmt_set_mac_address(struct net_device *netdev, void *addr)
 {
 	struct sockaddr *sa = addr;
 
-	if (!is_valid_ether_addr(sa->sa_data))
-		return -EADDRNOTAVAIL;
-
 	memcpy(netdev->dev_addr, sa->sa_data, ETH_ALEN);
 
 	octeon_mgmt_set_rx_filtering(netdev);
@@ -768,7 +765,7 @@ static int octeon_mgmt_open(struct net_device *netdev)
 	cvmx_write_csr(CVMX_AGL_GMX_PRTX_CFG(port), prtx_cfg.u64);
 
 	memcpy(sa.sa_data, netdev->dev_addr, ETH_ALEN);
-	octeon_mgmt_set_mac_address(netdev, &sa);
+	dev_set_mac_address(netdev, &sa);
 
 	octeon_mgmt_change_mtu(netdev, netdev->mtu);
 
@@ -1064,6 +1061,7 @@ static const struct net_device_ops octeon_mgmt_ops = {
 	.ndo_set_mac_address =		octeon_mgmt_set_mac_address,
 	.ndo_do_ioctl = 		octeon_mgmt_ioctl,
 	.ndo_change_mtu =		octeon_mgmt_change_mtu,
+	.ndo_validate_addr = 		eth_validate_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller =		octeon_mgmt_poll_controller,
 #endif
-- 
1.7.8.3

