Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab1KDBmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 21:42:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15202 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab1KDBl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 21:41:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:in-reply-to:references:organization:x-system-of-record;
	b=q466FFq6M4Bewuj4V6yDxYOwJ7ePg8ktlL9wjh7CTUxxdo30Cb8NId6Y0bjYAl/8K
	6nxHXl9BTQ9NOcynPdmfw==
From: David Decotigny <david.decotigny@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Mandeep Baines <msb@google.com>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH net v2 1/8] forcedeth: Improve stats counters
Date: Thu,  3 Nov 2011 18:41:16 -0700
Message-Id: <f005f434ebc4922bbcc1b7bf6949bb3b7c45fbe8.1320369398.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1320369398.git.david.decotigny@google.com>
References: <cover.1320369398.git.david.decotigny@google.com>
In-Reply-To: <cover.1320369398.git.david.decotigny@google.com>
References: <cover.1320369398.git.david.decotigny@google.com>
Organization: Google, Inc.
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mandeep Baines <msb@google.com>

Rx byte count was off; instead use the hardware's count.  Tx packet
count was counting pre-TSO packets; instead count on-the-wire packets.
Report hardware dropped frame count as rx_fifo_errors.

- The count of transmitted packets reported by the forcedeth driver
  reports pre-TSO (TCP Segmentation Offload) packet counts and not the
  count of the number of packets sent on the wire. This change fixes
  the forcedeth driver to report the correct count. Fixed the code by
  copying the count stored in the NIC H/W to the value reported by the
  driver.

- Count rx_drop_frame errors as rx_fifo_errors:
  We see a lot of rx_drop_frame errors if we disable the rx bottom-halves
  for too long.  Normally, rx_fifo_errors would be counted in this case.
  The rx_drop_frame error count is private to forcedeth and is not
  reported by ifconfig or sysfs.  The rx_fifo_errors count is currently
  unused in the forcedeth driver.  It is reported by ifconfig as overruns.
  This change reports rx_drop_frame errors as rx_fifo_errors.



Signed-off-by: David Decotigny <david.decotigny@google.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 1e37eb9..64b1c7c 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -1682,6 +1682,7 @@ static void nv_get_hw_stats(struct net_device *dev)
 		np->estats.tx_pause += readl(base + NvRegTxPause);
 		np->estats.rx_pause += readl(base + NvRegRxPause);
 		np->estats.rx_drop_frame += readl(base + NvRegRxDropFrame);
+		np->estats.rx_errors_total += np->estats.rx_drop_frame;
 	}
 
 	if (np->driver_data & DEV_HAS_STATISTICS_V3) {
@@ -1706,11 +1707,14 @@ static struct net_device_stats *nv_get_stats(struct net_device *dev)
 		nv_get_hw_stats(dev);
 
 		/* copy to net_device stats */
+		dev->stats.tx_packets = np->estats.tx_packets;
+		dev->stats.rx_bytes = np->estats.rx_bytes;
 		dev->stats.tx_bytes = np->estats.tx_bytes;
 		dev->stats.tx_fifo_errors = np->estats.tx_fifo_errors;
 		dev->stats.tx_carrier_errors = np->estats.tx_carrier_errors;
 		dev->stats.rx_crc_errors = np->estats.rx_crc_errors;
 		dev->stats.rx_over_errors = np->estats.rx_over_errors;
+		dev->stats.rx_fifo_errors = np->estats.rx_drop_frame;
 		dev->stats.rx_errors = np->estats.rx_errors_total;
 		dev->stats.tx_errors = np->estats.tx_errors_total;
 	}
-- 
1.7.3.1

