Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946240Ab2CPXyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:54:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49074 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946164Ab2CPXiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:38:50 -0400
Message-Id: <20120316233449.498699858@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:35:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Meyer <thomas@m3y3r.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 25/38] atl1c: dont use highprio tx queue
In-Reply-To: <20120316233422.GA5461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 11aad99af6ef629ff3b05d1c9f0936589b204316 ]

This driver attempts to use two TX rings but lacks proper support :

1) IRQ handler only takes care of TX completion on first TX ring
2) the stop/start logic uses the legacy functions (for non multiqueue
drivers)

This means all packets witk skb mark set to 1 are sent through high
queue but are never cleaned and queue eventualy fills and block the
device, triggering the infamous "NETDEV WATCHDOG" message.

Lets use a single TX ring to fix the problem, this driver is not a real
multiqueue one yet.

Minimal fix for stable kernels.

Reported-by: Thomas Meyer <thomas@m3y3r.de>
Tested-by: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jay Cliburn <jcliburn@gmail.com>
Cc: Chris Snook <chris.snook@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/atl1c/atl1c_main.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/net/atl1c/atl1c_main.c
+++ b/drivers/net/atl1c/atl1c_main.c
@@ -2223,10 +2223,6 @@ static netdev_tx_t atl1c_xmit_frame(stru
 			dev_info(&adapter->pdev->dev, "tx locked\n");
 		return NETDEV_TX_LOCKED;
 	}
-	if (skb->mark == 0x01)
-		type = atl1c_trans_high;
-	else
-		type = atl1c_trans_normal;
 
 	if (atl1c_tpd_avail(adapter, type) < tpd_req) {
 		/* no enough descriptor, just stop queue */


