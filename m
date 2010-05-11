Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab0EKArV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 20:47:21 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:47963 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754266Ab0EKArT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 20:47:19 -0400
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [stable-2.6.32 PATCH] ixgbe: backport bug fix for tx panic
To: stable@kernel.org, greg@kroah.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
       Brandon <brandon@ifup.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Date: Mon, 10 May 2010 17:46:57 -0700
Message-ID: <20100511004655.30590.74584.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

backporting this commit:

commit fdd3d631cddad20ad9d3e1eb7dbf26825a8a121f
Author: Krishna Kumar <krkumar2@in.ibm.com>
Date:   Wed Feb 3 13:13:10 2010 +0000

    ixgbe: Fix return of invalid txq

    a developer had complained of getting lots of warnings:

    "eth16 selects TX queue 98, but real number of TX queues is 64"

    http://www.mail-archive.com/e1000-devel@lists.sourceforge.net/msg02200.html

    As there was no follow up on that bug, I am submitting this
    patch assuming that the other return points will not return
    invalid txq's, and also that this fixes the bug (not tested).

    Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
    Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
    Acked-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
    Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

CC: Brandon <brandon@ifup.org>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---

 drivers/net/ixgbe/ixgbe_main.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
index 6339d65..a873c5d 100644
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -5241,9 +5241,13 @@ static int ixgbe_maybe_stop_tx(struct net_device *netdev,
 static u16 ixgbe_select_queue(struct net_device *dev, struct sk_buff *skb)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(dev);
+	int txq = smp_processor_id();
 
-	if (adapter->flags & IXGBE_FLAG_FDIR_HASH_CAPABLE)
-		return smp_processor_id();
+	if (adapter->flags & IXGBE_FLAG_FDIR_HASH_CAPABLE) {
+		while (unlikely(txq >= dev->real_num_tx_queues))
+			txq -= dev->real_num_tx_queues;
+		return txq;
+	}
 
 	if (adapter->flags & IXGBE_FLAG_DCB_ENABLED)
 		return (skb->vlan_tci & IXGBE_TX_FLAGS_VLAN_PRIO_MASK) >> 13;

