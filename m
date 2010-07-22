Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741Ab0GVKcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 06:32:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33593 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335Ab0GVKcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 06:32:25 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        pavan_savoy@sify.com, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 3/3] drivers:staging:ti-st: give proto drivers context
Date: Thu, 22 Jul 2010 05:32:07 -0500
Message-Id: <1279794727-7669-4-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1279794727-7669-3-git-send-email-pavan_savoy@ti.com>
References: <1279794727-7669-1-git-send-email-pavan_savoy@ti.com>
 <1279794727-7669-2-git-send-email-pavan_savoy@ti.com>
 <1279794727-7669-3-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

protocol drivers such as BT, FM and GPS when registering
to ST now provide their own private data which they expect
when their functions namely registration completed & receive
are called.
Also upon tty_close, set protos_registered count to 0, although
all protocols are marked un-registered.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/staging/ti-st/bt_drv.c  |   23 +++++++++++++++--------
 drivers/staging/ti-st/st.h      |    8 ++++++--
 drivers/staging/ti-st/st_core.c |    8 ++++++--
 3 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/ti-st/bt_drv.c b/drivers/staging/ti-st/bt_drv.c
index d70aea1..61ae988 100644
--- a/drivers/staging/ti-st/bt_drv.c
+++ b/drivers/staging/ti-st/bt_drv.c
@@ -80,31 +80,33 @@ static inline void hci_st_tx_complete(struct hci_st *hst, int pkt_type)
  * status.hci_st_open() function will wait for signal from this
  * API when st_register() function returns ST_PENDING.
  */
-static void hci_st_registration_completion_cb(char data)
+static void hci_st_registration_completion_cb(void *priv_data, char data)
 {
+	struct hci_st *lhst = (struct hci_st *)priv_data;
 	BTDRV_API_START();
 
 	/* hci_st_open() function needs value of 'data' to know
 	 * the registration status(success/fail),So have a back
 	 * up of it.
 	 */
-	hst->streg_cbdata = data;
+	lhst->streg_cbdata = data;
 
 	/* Got a feedback from ST for BT driver registration
 	 * request.Wackup hci_st_open() function to continue
 	 * it's open operation.
 	 */
-	complete(&hst->wait_for_btdrv_reg_completion);
+	complete(&lhst->wait_for_btdrv_reg_completion);
 
 	BTDRV_API_EXIT(0);
 }
 
 /* Called by Shared Transport layer when receive data is
  * available */
-static long hci_st_receive(struct sk_buff *skb)
+static long hci_st_receive(void *priv_data, struct sk_buff *skb)
 {
 	int err;
 	int len;
+	struct hci_st *lhst = (struct hci_st *)priv_data;
 
 	BTDRV_API_START();
 
@@ -116,13 +118,13 @@ static long hci_st_receive(struct sk_buff *skb)
 		BTDRV_API_EXIT(-EFAULT);
 		return -EFAULT;
 	}
-	if (!hst) {
+	if (!lhst) {
 		kfree_skb(skb);
 		BT_DRV_ERR("Invalid hci_st memory,freeing SKB");
 		BTDRV_API_EXIT(-EFAULT);
 		return -EFAULT;
 	}
-	if (!test_bit(BT_DRV_RUNNING, &hst->flags)) {
+	if (!test_bit(BT_DRV_RUNNING, &lhst->flags)) {
 		kfree_skb(skb);
 		BT_DRV_ERR("Device is not running,freeing SKB");
 		BTDRV_API_EXIT(-EINVAL);
@@ -130,7 +132,7 @@ static long hci_st_receive(struct sk_buff *skb)
 	}
 
 	len = skb->len;
-	skb->dev = (struct net_device *)hst->hdev;
+	skb->dev = (struct net_device *)lhst->hdev;
 
 	/* Forward skb to HCI CORE layer */
 	err = hci_recv_frame(skb);
@@ -141,7 +143,7 @@ static long hci_st_receive(struct sk_buff *skb)
 		BTDRV_API_EXIT(err);
 		return err;
 	}
-	hst->hdev->stat.byte_rx += len;
+	lhst->hdev->stat.byte_rx += len;
 
 	BTDRV_API_EXIT(0);
 	return 0;
@@ -189,6 +191,11 @@ static int hci_st_open(struct hci_dev *hdev)
 	 * make it as NULL */
 	hci_st_proto.write = NULL;
 
+	/* send in the hst to be received at registration complete callback
+	 * and during st's receive
+	 */
+	hci_st_proto.priv_data = hst;
+
 	/* Register with ST layer */
 	err = st_register(&hci_st_proto);
 	if (err == -EINPROGRESS) {
diff --git a/drivers/staging/ti-st/st.h b/drivers/staging/ti-st/st.h
index c96c01e..9952579 100644
--- a/drivers/staging/ti-st/st.h
+++ b/drivers/staging/ti-st/st.h
@@ -64,13 +64,17 @@ enum proto_type {
  *	download is in progress.
  * @write: pointer to function in ST provided to protocol drivers from ST,
  *	to be made use when protocol drivers have data to send to TTY.
+ * @priv_data: privdate data holder for the protocol drivers, sent
+ *	from the protocol drivers during registration, and sent back on
+ *	reg_complete_cb and recv.
  */
 struct st_proto_s {
 	enum proto_type type;
-	long (*recv) (struct sk_buff *);
+	long (*recv) (void *, struct sk_buff *);
 	unsigned char (*match_packet) (const unsigned char *data);
-	void (*reg_complete_cb) (char data);
+	void (*reg_complete_cb) (void *, char data);
 	long (*write) (struct sk_buff *skb);
+	void *priv_data;
 };
 
 extern long st_register(struct st_proto_s *);
diff --git a/drivers/staging/ti-st/st_core.c b/drivers/staging/ti-st/st_core.c
index b20ab73..fc6de63 100644
--- a/drivers/staging/ti-st/st_core.c
+++ b/drivers/staging/ti-st/st_core.c
@@ -119,7 +119,9 @@ void st_send_frame(enum proto_type protoid, struct st_data_s *st_gdata)
 	 *   protocol stack driver
 	 */
 	if (likely(st_gdata->list[protoid]->recv != NULL)) {
-		if (unlikely(st_gdata->list[protoid]->recv(st_gdata->rx_skb)
+		if (unlikely
+			(st_gdata->list[protoid]->recv
+			(st_gdata->list[protoid]->priv_data, st_gdata->rx_skb)
 			     != 0)) {
 			pr_err(" proto stack %d's ->recv failed", protoid);
 			kfree_skb(st_gdata->rx_skb);
@@ -144,7 +146,8 @@ void st_reg_complete(struct st_data_s *st_gdata, char err)
 	for (i = 0; i < ST_MAX; i++) {
 		if (likely(st_gdata != NULL && st_gdata->list[i] != NULL &&
 			   st_gdata->list[i]->reg_complete_cb != NULL))
-			st_gdata->list[i]->reg_complete_cb(err);
+			st_gdata->list[i]->reg_complete_cb
+				(st_gdata->list[i]->priv_data, err);
 	}
 }
 
@@ -878,6 +881,7 @@ static void st_tty_close(struct tty_struct *tty)
 			pr_err("%d not un-registered", i);
 		st_gdata->list[i] = NULL;
 	}
+	st_gdata->protos_registered = 0;
 	spin_unlock_irqrestore(&st_gdata->lock, flags);
 	/*
 	 * signal to UIM via KIM that -
-- 
1.5.6.3

