Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab0GASaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:30:08 -0400
Received: from kroah.org ([198.145.64.141]:40809 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758140Ab0GASYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:24:21 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:17 2010
Message-Id: <20100701173217.608401755@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 128/149] ucc_geth: Fix netdev watchdog triggering on link changes
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Vorontsov <avorontsov@ru.mvista.com>

commit 08b5e1c91ce95793c59a59529a362a1bcc81faae upstream.

Since commit 864fdf884e82bacbe8ca5e93bd43393a61d2e2b4 ("ucc_geth:
Fix hangs after switching from full to half duplex") ucc_geth driver
disables the controller during MAC configuration changes. Though,
disabling the controller might take quite awhile, and so the netdev
watchdog might get upset:

 NETDEV WATCHDOG: eth2 (ucc_geth): transmit queue 0 timed out
 ------------[ cut here ]------------
 Badness at c02729a8 [verbose debug info unavailable]
 NIP: c02729a8 LR: c02729a8 CTR: c01b6088
 REGS: c0451c40 TRAP: 0700   Not tainted  (2.6.32-trunk-8360e)
 [...]
 NIP [c02729a8] dev_watchdog+0x280/0x290
 LR [c02729a8] dev_watchdog+0x280/0x290
 Call Trace:
 [c0451cf0] [c02729a8] dev_watchdog+0x280/0x290 (unreliable)
 [c0451d50] [c00377c4] run_timer_softirq+0x164/0x224
 [c0451da0] [c0032a38] __do_softirq+0xb8/0x13c
 [c0451df0] [c00065cc] do_softirq+0xa0/0xac
 [c0451e00] [c003280c] irq_exit+0x7c/0x9c
 [c0451e10] [c00640c4] __ipipe_sync_stage+0x248/0x24c
 [...]

This patch fixes the issue by detaching the netdev during the
time we change the configuration.

Reported-by: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Tested-by: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ucc_geth.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/ucc_geth.c
+++ b/drivers/net/ucc_geth.c
@@ -1563,7 +1563,10 @@ static int ugeth_disable(struct ucc_geth
 
 static void ugeth_quiesce(struct ucc_geth_private *ugeth)
 {
-	/* Wait for and prevent any further xmits. */
+	/* Prevent any further xmits, plus detach the device. */
+	netif_device_detach(ugeth->ndev);
+
+	/* Wait for any current xmits to finish. */
 	netif_tx_disable(ugeth->ndev);
 
 	/* Disable the interrupt to avoid NAPI rescheduling. */
@@ -1577,7 +1580,7 @@ static void ugeth_activate(struct ucc_ge
 {
 	napi_enable(&ugeth->napi);
 	enable_irq(ugeth->ug_info->uf_info.irq);
-	netif_tx_wake_all_queues(ugeth->ndev);
+	netif_device_attach(ugeth->ndev);
 }
 
 /* Called every time the controller might need to be made


