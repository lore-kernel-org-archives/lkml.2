Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117Ab0G3SJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:09:23 -0400
Received: from kroah.org ([198.145.64.141]:59194 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932589Ab0G3R5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:37 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:50 2010
Message-Id: <20100730175150.095735025@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:53:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Chan <mchan@broadcom.com>, Benjamin Li <benli@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [178/205] bnx2: Fix hang during rmmod bnx2.
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Chan <mchan@broadcom.com>

commit f048fa9c8686119c3858a463cab6121dced7c0bf upstream.

The regression is caused by:

commit 4327ba435a56ada13eedf3eb332e583c7a0586a9
    bnx2: Fix netpoll crash.

If ->open() and ->close() are called multiple times, the same napi structs
will be added to dev->napi_list multiple times, corrupting the dev->napi_list.
This causes free_netdev() to hang during rmmod.

We fix this by calling netif_napi_del() during ->close().

Also, bnx2_init_napi() must not be in the __devinit section since it is
called by ->open().

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: Benjamin Li <benli@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bnx2.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/net/bnx2.c
+++ b/drivers/net/bnx2.c
@@ -247,6 +247,7 @@ static const struct flash_spec flash_570
 MODULE_DEVICE_TABLE(pci, bnx2_pci_tbl);
 
 static void bnx2_init_napi(struct bnx2 *bp);
+static void bnx2_del_napi(struct bnx2 *bp);
 
 static inline u32 bnx2_tx_avail(struct bnx2 *bp, struct bnx2_tx_ring_info *txr)
 {
@@ -6265,6 +6266,7 @@ open_err:
 	bnx2_free_skbs(bp);
 	bnx2_free_irq(bp);
 	bnx2_free_mem(bp);
+	bnx2_del_napi(bp);
 	return rc;
 }
 
@@ -6523,6 +6525,7 @@ bnx2_close(struct net_device *dev)
 	bnx2_free_irq(bp);
 	bnx2_free_skbs(bp);
 	bnx2_free_mem(bp);
+	bnx2_del_napi(bp);
 	bp->link_up = 0;
 	netif_carrier_off(bp->dev);
 	bnx2_set_power_state(bp, PCI_D3hot);
@@ -8213,7 +8216,16 @@ bnx2_bus_string(struct bnx2 *bp, char *s
 	return str;
 }
 
-static void __devinit
+static void
+bnx2_del_napi(struct bnx2 *bp)
+{
+	int i;
+
+	for (i = 0; i < bp->irq_nvecs; i++)
+		netif_napi_del(&bp->bnx2_napi[i].napi);
+}
+
+static void
 bnx2_init_napi(struct bnx2 *bp)
 {
 	int i;


