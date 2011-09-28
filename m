Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933376Ab1I1WtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:49:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54889 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933365Ab1I1WtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:49:04 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:48 2011
Message-Id: <20110928220148.020135900@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eddie Wai <eddie.wai@broadcom.com>, Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [215/244] cnic: Randomize initial TCP port for iSCSI connections
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eddie Wai <eddie.wai@broadcom.com>

commit 11f23aa8ccd56786f0a6f04211cf59b3fab2ce08 upstream.

This reduces the likelihood of port re-use when re-loading the driver.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/cnic.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/net/cnic.c
+++ b/drivers/net/cnic.c
@@ -605,11 +605,12 @@ static int cnic_unregister_device(struct
 }
 EXPORT_SYMBOL(cnic_unregister_driver);
 
-static int cnic_init_id_tbl(struct cnic_id_tbl *id_tbl, u32 size, u32 start_id)
+static int cnic_init_id_tbl(struct cnic_id_tbl *id_tbl, u32 size, u32 start_id,
+			    u32 next)
 {
 	id_tbl->start = start_id;
 	id_tbl->max = size;
-	id_tbl->next = 0;
+	id_tbl->next = next;
 	spin_lock_init(&id_tbl->lock);
 	id_tbl->table = kzalloc(DIV_ROUND_UP(size, 32) * 4, GFP_KERNEL);
 	if (!id_tbl->table)
@@ -3804,14 +3805,17 @@ static void cnic_cm_free_mem(struct cnic
 static int cnic_cm_alloc_mem(struct cnic_dev *dev)
 {
 	struct cnic_local *cp = dev->cnic_priv;
+	u32 port_id;
 
 	cp->csk_tbl = kzalloc(sizeof(struct cnic_sock) * MAX_CM_SK_TBL_SZ,
 			      GFP_KERNEL);
 	if (!cp->csk_tbl)
 		return -ENOMEM;
 
+	get_random_bytes(&port_id, sizeof(port_id));
+	port_id %= CNIC_LOCAL_PORT_RANGE;
 	if (cnic_init_id_tbl(&cp->csk_port_tbl, CNIC_LOCAL_PORT_RANGE,
-			     CNIC_LOCAL_PORT_MIN)) {
+			     CNIC_LOCAL_PORT_MIN, port_id)) {
 		cnic_cm_free_mem(dev);
 		return -ENOMEM;
 	}
@@ -4829,7 +4833,7 @@ static int cnic_start_bnx2x_hw(struct cn
 	pfid = cp->pfid;
 
 	ret = cnic_init_id_tbl(&cp->cid_tbl, MAX_ISCSI_TBL_SZ,
-			       cp->iscsi_start_cid);
+			       cp->iscsi_start_cid, 0);
 
 	if (ret)
 		return -ENOMEM;
@@ -4837,7 +4841,7 @@ static int cnic_start_bnx2x_hw(struct cn
 	if (BNX2X_CHIP_IS_E2(cp->chip_id)) {
 		ret = cnic_init_id_tbl(&cp->fcoe_cid_tbl,
 					BNX2X_FCOE_NUM_CONNECTIONS,
-					cp->fcoe_start_cid);
+					cp->fcoe_start_cid, 0);
 
 		if (ret)
 			return -ENOMEM;


