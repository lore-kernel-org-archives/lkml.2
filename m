Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085Ab0IXQfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:35:37 -0400
Received: from kroah.org ([198.145.64.141]:37311 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933066Ab0IXQfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:33 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:47 2010
Message-Id: <20100924163347.839575231@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:32:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Chan <mchan@broadcom.com>, Benjamin Li <benli@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [43/68] bnx2: Fix hang during rmmod bnx2.
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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
@@ -248,6 +248,7 @@ static const struct flash_spec flash_570
 MODULE_DEVICE_TABLE(pci, bnx2_pci_tbl);
 
 static void bnx2_init_napi(struct bnx2 *bp);
+static void bnx2_del_napi(struct bnx2 *bp);
 
 static inline u32 bnx2_tx_avail(struct bnx2 *bp, struct bnx2_tx_ring_info *txr)
 {
@@ -6237,6 +6238,7 @@ open_err:
 	bnx2_free_skbs(bp);
 	bnx2_free_irq(bp);
 	bnx2_free_mem(bp);
+	bnx2_del_napi(bp);
 	return rc;
 }
 
@@ -6444,6 +6446,7 @@ bnx2_close(struct net_device *dev)
 	bnx2_free_irq(bp);
 	bnx2_free_skbs(bp);
 	bnx2_free_mem(bp);
+	bnx2_del_napi(bp);
 	bp->link_up = 0;
 	netif_carrier_off(bp->dev);
 	bnx2_set_power_state(bp, PCI_D3hot);
@@ -8019,7 +8022,16 @@ bnx2_bus_string(struct bnx2 *bp, char *s
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


