Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965333Ab2CMA3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:29:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:48979 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965267Ab2CMAZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:25:02 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Thomas Jarosch <thomas.jarosch@intra2net.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 187/196] vmxnet3: Fix inconsistent LRO state after initialization
Date: Mon, 12 Mar 2012 20:21:40 -0400
Message-Id: <1331598109-31424-142-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Jarosch <thomas.jarosch@intra2net.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit ebde6f8acba92abfc203585198a54f47e83e2cd0 upstream.

During initialization of vmxnet3, the state of LRO
gets out of sync with netdev->features.

This leads to very poor TCP performance in a IP forwarding
setup and is hitting many VMware users.

Simplified call sequence:
1. vmxnet3_declare_features() initializes "adapter->lro" to true.

2. The kernel automatically disables LRO if IP forwarding is enabled,
so vmxnet3_set_flags() gets called. This also updates netdev->features.

3. Now vmxnet3_setup_driver_shared() is called. "adapter->lro" is still
set to true and LRO gets enabled again, even though
netdev->features shows it's disabled.

Fix it by updating "adapter->lro", too.

The private vmxnet3 adapter flags are scheduled for removal
in net-next, see commit a0d2730c9571aeba793cb5d3009094ee1d8fda35
"net: vmxnet3: convert to hw_features".

Patch applies to 2.6.37 / 2.6.38 and 2.6.39-rc6.

Please CC: comments.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/vmxnet3/vmxnet3_ethtool.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 3935c44..df7cddd 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -290,6 +290,9 @@ vmxnet3_set_flags(struct net_device *netdev, u32 data) {
 		/* toggle the LRO feature*/
 		netdev->features ^= NETIF_F_LRO;
 
+		/* Update private LRO flag */
+		adapter->lro = lro_requested;
+
 		/* update harware LRO capability accordingly */
 		if (lro_requested)
 			adapter->shared->devRead.misc.uptFeatures &= UPT1_F_LRO;
-- 
1.7.9.3

