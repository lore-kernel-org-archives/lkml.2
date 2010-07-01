Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338Ab0GASay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:30:54 -0400
Received: from kroah.org ([198.145.64.141]:40804 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758136Ab0GASYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:24:20 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:17 2010
Message-Id: <20100701173217.527844817@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 127/149] ucc_geth: Fix empty TX queue processing
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Vorontsov <avorontsov@ru.mvista.com>

commit 7583605b6d29f1f7f6fc505b883328089f3485ad upstream.

Following oops was seen with the ucc_geth driver:

 Unable to handle kernel paging request for data at address 0x00000058
 Faulting instruction address: 0xc024f2fc
 Oops: Kernel access of bad area, sig: 11 [#1]
 [...]
 NIP [c024f2fc] skb_recycle_check+0x14/0x100
 LR [e30aa0a4] ucc_geth_poll+0xd8/0x4e0 [ucc_geth_driver]
 Call Trace:
 [df857d50] [c000b03c] __ipipe_grab_irq+0x3c/0xa4 (unreliable)
 [df857d60] [e30aa0a4] ucc_geth_poll+0xd8/0x4e0 [ucc_geth_driver]
 [df857dd0] [c0258cf8] net_rx_action+0xf8/0x1b8
 [df857e10] [c0032a38] __do_softirq+0xb8/0x13c
 [df857e60] [c00065cc] do_softirq+0xa0/0xac
 [...]

This is because ucc_geth_tx() tries to process an empty queue when
queues are logically stopped. Stopping the queues doesn't disable
polling, and since nowadays ucc_geth_tx() is actually called from
the polling routine, the oops above might pop up.

Fix this by removing 'netif_queue_stopped() == 0' check.

Reported-by: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Tested-by: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ucc_geth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ucc_geth.c
+++ b/drivers/net/ucc_geth.c
@@ -3273,7 +3273,7 @@ static int ucc_geth_tx(struct net_device
 		/* Handle the transmitted buffer and release */
 		/* the BD to be used with the current frame  */
 
-		if ((bd == ugeth->txBd[txQ]) && (netif_queue_stopped(dev) == 0))
+		if (bd == ugeth->txBd[txQ]) /* queue empty? */
 			break;
 
 		dev->stats.tx_packets++;


