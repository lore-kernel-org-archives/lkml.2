Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab0IXQff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:35:35 -0400
Received: from kroah.org ([198.145.64.141]:37281 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933015Ab0IXQfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:32 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:47 2010
Message-Id: <20100924163347.749989109@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:32:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Benjamin Li <benli@broadcom.com>, Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [42/68] bnx2: Fix netpoll crash.
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Benjamin Li <benli@broadcom.com>

commit 4327ba435a56ada13eedf3eb332e583c7a0586a9 upstream.

The bnx2 driver calls netif_napi_add() for all the NAPI structs during
->probe() time but not all of them will be used if we're not in MSI-X
mode.  This creates a problem for netpoll since it will poll all the
NAPI structs in the dev_list whether or not they are scheduled, resulting
in a crash when we access structure fields not initialized for that vector.

We fix it by moving the netif_napi_add() call to ->open() after the number
of IRQ vectors has been determined.

Signed-off-by: Benjamin Li <benli@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bnx2.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/bnx2.c
+++ b/drivers/net/bnx2.c
@@ -247,6 +247,8 @@ static const struct flash_spec flash_570
 
 MODULE_DEVICE_TABLE(pci, bnx2_pci_tbl);
 
+static void bnx2_init_napi(struct bnx2 *bp);
+
 static inline u32 bnx2_tx_avail(struct bnx2 *bp, struct bnx2_tx_ring_info *txr)
 {
 	u32 diff;
@@ -6173,6 +6175,7 @@ bnx2_open(struct net_device *dev)
 	bnx2_disable_int(bp);
 
 	bnx2_setup_int_mode(bp, disable_msi);
+	bnx2_init_napi(bp);
 	bnx2_napi_enable(bp);
 	rc = bnx2_alloc_mem(bp);
 	if (rc)
@@ -8021,7 +8024,7 @@ bnx2_init_napi(struct bnx2 *bp)
 {
 	int i;
 
-	for (i = 0; i < BNX2_MAX_MSIX_VEC; i++) {
+	for (i = 0; i < bp->irq_nvecs; i++) {
 		struct bnx2_napi *bnapi = &bp->bnx2_napi[i];
 		int (*poll)(struct napi_struct *, int);
 
@@ -8090,7 +8093,6 @@ bnx2_init_one(struct pci_dev *pdev, cons
 	dev->ethtool_ops = &bnx2_ethtool_ops;
 
 	bp = netdev_priv(dev);
-	bnx2_init_napi(bp);
 
 	pci_set_drvdata(pdev, dev);
 


