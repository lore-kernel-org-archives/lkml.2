Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab1BRBU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 20:20:29 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:32850 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581Ab1BRBUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 20:20:22 -0500
Date: Fri, 18 Feb 2011 12:20:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: linux-next: manual merge of the net tree with the net-current tree
Message-Id: <20110218122016.bc3d6470.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
drivers/net/e1000e/netdev.c between commit
713b3c9e4c1a6da6b45da6474ed554ed0a48de69 ("e1000e: flush all writebacks
before unload") from the net-current tree and commit
67fd4fcb78a7ced369a6bd8a131ec8c65ebd2bbb ("e1000e: convert to stats64")
from the net tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/e1000e/netdev.c
index 3fa110d,7cedfeb..0000000
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@@ -3344,21 -3335,8 +3341,23 @@@ int e1000e_up(struct e1000_adapter *ada
  	return 0;
  }
  
 +static void e1000e_flush_descriptors(struct e1000_adapter *adapter)
 +{
 +	struct e1000_hw *hw = &adapter->hw;
 +
 +	if (!(adapter->flags2 & FLAG2_DMA_BURST))
 +		return;
 +
 +	/* flush pending descriptor writebacks to memory */
 +	ew32(TIDV, adapter->tx_int_delay | E1000_TIDV_FPD);
 +	ew32(RDTR, adapter->rx_int_delay | E1000_RDTR_FPD);
 +
 +	/* execute the writes immediately */
 +	e1e_flush();
 +}
 +
+ static void e1000e_update_stats(struct e1000_adapter *adapter);
+ 
  void e1000e_down(struct e1000_adapter *adapter)
  {
  	struct net_device *netdev = adapter->netdev;
@@@ -4179,11 -4154,7 +4186,10 @@@ static void e1000_watchdog_task(struct 
  	struct e1000_ring *tx_ring = adapter->tx_ring;
  	struct e1000_hw *hw = &adapter->hw;
  	u32 link, tctl;
- 	int tx_pending = 0;
  
 +	if (test_bit(__E1000_DOWN, &adapter->state))
 +		return;
 +
  	link = e1000e_has_link(adapter);
  	if ((netif_carrier_ok(netdev)) && link) {
  		/* Cancel scheduled suspend requests. */
