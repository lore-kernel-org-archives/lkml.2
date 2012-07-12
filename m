Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162490Ab2GLX13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:27:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46447 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161986Ab2GLWmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:42:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Ahern <daahern@cisco.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 113/187] igbvf: fix divide by zero
Date: Thu, 12 Jul 2012 15:34:29 -0700
Message-Id: <20120712191532.840404579@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mitch A Williams <mitch.a.williams@intel.com>

commit 0e90b49ca4b891f085b57559a3071a4feefb496c upstream.

Using ethtool -C ethX rx-usecs 0 crashes with a divide by zero.
Refactor this function to fix this issue and make it more clear
what the intent of each conditional is. Add comment regarding
using a setting of zero.

CC: David Ahern <daahern@cisco.com>
Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/igbvf/ethtool.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

--- a/drivers/net/ethernet/intel/igbvf/ethtool.c
+++ b/drivers/net/ethernet/intel/igbvf/ethtool.c
@@ -357,21 +357,28 @@ static int igbvf_set_coalesce(struct net
 	struct igbvf_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
 
-	if ((ec->rx_coalesce_usecs > IGBVF_MAX_ITR_USECS) ||
-	    ((ec->rx_coalesce_usecs > 3) &&
-	     (ec->rx_coalesce_usecs < IGBVF_MIN_ITR_USECS)) ||
-	    (ec->rx_coalesce_usecs == 2))
-		return -EINVAL;
-
-	/* convert to rate of irq's per second */
-	if (ec->rx_coalesce_usecs && ec->rx_coalesce_usecs <= 3) {
+	if ((ec->rx_coalesce_usecs >= IGBVF_MIN_ITR_USECS) &&
+	     (ec->rx_coalesce_usecs <= IGBVF_MAX_ITR_USECS)) {
+		adapter->current_itr = ec->rx_coalesce_usecs << 2;
+		adapter->requested_itr = 1000000000 /
+					(adapter->current_itr * 256);
+	} else if ((ec->rx_coalesce_usecs == 3) ||
+		   (ec->rx_coalesce_usecs == 2)) {
 		adapter->current_itr = IGBVF_START_ITR;
 		adapter->requested_itr = ec->rx_coalesce_usecs;
-	} else {
-		adapter->current_itr = ec->rx_coalesce_usecs << 2;
+	} else if (ec->rx_coalesce_usecs == 0) {
+		/*
+		 * The user's desire is to turn off interrupt throttling
+		 * altogether, but due to HW limitations, we can't do that.
+		 * Instead we set a very small value in EITR, which would
+		 * allow ~967k interrupts per second, but allow the adapter's
+		 * internal clocking to still function properly.
+		 */
+		adapter->current_itr = 4;
 		adapter->requested_itr = 1000000000 /
 					(adapter->current_itr * 256);
-	}
+	} else
+		return -EINVAL;
 
 	writel(adapter->current_itr,
 	       hw->hw_addr + adapter->rx_ring->itr_register);


