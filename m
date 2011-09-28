Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab1I1W6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:58:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933365Ab1I1WtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:49:11 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:48 2011
Message-Id: <20110928220148.246489564@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:03:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Chan <mchan@broadcom.com>, Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [217/244] cnic, bnx2: Check iSCSI support early in bnx2_init_one()
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Chan <mchan@broadcom.com>

commit 7625eb2f2fff7bfae41d3119b472c20b48874895 upstream.

Based on earlier patch from Neil Horman <nhorman@tuxdriver.com>

If iSCSI is not supported on a bnx2 device, bnx2_cnic_probe() will
return NULL and the cnic device will not be visible to bnx2i.  This
will prevent bnx2i from registering and then unregistering during
cnic_start() and cause the warning message:

bnx2 0003:01:00.1: eth1: Failed waiting for ULP up call to complete

Signed-off-by: Michael Chan <mchan@broadcom.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bnx2.c |    7 +++++++
 drivers/net/cnic.c |   12 ++----------
 2 files changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/net/bnx2.c
+++ b/drivers/net/bnx2.c
@@ -416,6 +416,9 @@ struct cnic_eth_dev *bnx2_cnic_probe(str
 	struct bnx2 *bp = netdev_priv(dev);
 	struct cnic_eth_dev *cp = &bp->cnic_eth_dev;
 
+	if (!cp->max_iscsi_conn)
+		return NULL;
+
 	cp->drv_owner = THIS_MODULE;
 	cp->chip_id = bp->chip_id;
 	cp->pdev = bp->pdev;
@@ -8177,6 +8180,10 @@ bnx2_init_board(struct pci_dev *pdev, st
 	bp->timer.data = (unsigned long) bp;
 	bp->timer.function = bnx2_timer;
 
+#ifdef BCM_CNIC
+	bp->cnic_eth_dev.max_iscsi_conn =
+		bnx2_reg_rd_ind(bp, BNX2_FW_MAX_ISCSI_CONN);
+#endif
 	pci_save_state(pdev);
 
 	return 0;
--- a/drivers/net/cnic.c
+++ b/drivers/net/cnic.c
@@ -4225,14 +4225,6 @@ static void cnic_enable_bnx2_int(struct
 		BNX2_PCICFG_INT_ACK_CMD_INDEX_VALID | cp->last_status_idx);
 }
 
-static void cnic_get_bnx2_iscsi_info(struct cnic_dev *dev)
-{
-	u32 max_conn;
-
-	max_conn = cnic_reg_rd_ind(dev, BNX2_FW_MAX_ISCSI_CONN);
-	dev->max_iscsi_conn = max_conn;
-}
-
 static void cnic_disable_bnx2_int_sync(struct cnic_dev *dev)
 {
 	struct cnic_local *cp = dev->cnic_priv;
@@ -4557,8 +4549,6 @@ static int cnic_start_bnx2_hw(struct cni
 		return err;
 	}
 
-	cnic_get_bnx2_iscsi_info(dev);
-
 	return 0;
 }
 
@@ -5224,6 +5214,8 @@ static struct cnic_dev *init_bnx2_cnic(s
 	cdev->pcidev = pdev;
 	cp->chip_id = ethdev->chip_id;
 
+	cdev->max_iscsi_conn = ethdev->max_iscsi_conn;
+
 	cp->cnic_ops = &cnic_bnx2_ops;
 	cp->start_hw = cnic_start_bnx2_hw;
 	cp->stop_hw = cnic_stop_bnx2_hw;


