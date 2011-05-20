Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab1ETALc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:11:32 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43132 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934039Ab1ETAL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:29 -0400
X-Sasl-enc: CMaOa+YGLM3cem0+NcVLrnOJaza2KS/aXkkMRGIsS4Lc 1305850288
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Pavan Savoy <pavan_savoy@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 14/44] drivers:misc:ti-st: handle delayed tty receive
Date: Thu, 19 May 2011 17:10:32 -0700
Message-Id: <1305850262-9575-14-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

When certain technologies shutdown their interface without waiting for
the acknowledgement from the chip. The receive_buf from the TTY would be
invoked a while after the relevant technology is unregistered.

This patch introduces a new flag "is_registered" which maintains the
state of protocols BT, FM or GPS and thereby removes the need to clear
the protocol data from ST when protocols gets unregistered.

This fixes corner cases when HCI RESET is sent down from bluetooth stack
and the receive_buf is called from tty after 250ms before which
bluetooth would have unregistered from the system.
OR - when FM application decides to close down the device without
sending a power-off FM command resulting in some RDS data or interrupt
data coming in after the driver is unregistered.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/ti-st/st_core.c |   23 +++++++++++++----------
 include/linux/ti_wilink_st.h |    3 ++-
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index 486117f..f91f82e 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -43,13 +43,15 @@ static void add_channel_to_table(struct st_data_s *st_gdata,
 	pr_info("%s: id %d\n", __func__, new_proto->chnl_id);
 	/* list now has the channel id as index itself */
 	st_gdata->list[new_proto->chnl_id] = new_proto;
+	st_gdata->is_registered[new_proto->chnl_id] = true;
 }
 
 static void remove_channel_from_table(struct st_data_s *st_gdata,
 		struct st_proto_s *proto)
 {
 	pr_info("%s: id %d\n", __func__, proto->chnl_id);
-	st_gdata->list[proto->chnl_id] = NULL;
+/*	st_gdata->list[proto->chnl_id] = NULL; */
+	st_gdata->is_registered[proto->chnl_id] = false;
 }
 
 /*
@@ -104,7 +106,7 @@ void st_send_frame(unsigned char chnl_id, struct st_data_s *st_gdata)
 
 	if (unlikely
 	    (st_gdata == NULL || st_gdata->rx_skb == NULL
-	     || st_gdata->list[chnl_id] == NULL)) {
+	     || st_gdata->is_registered[chnl_id] == false)) {
 		pr_err("chnl_id %d not registered, no data to send?",
 			   chnl_id);
 		kfree_skb(st_gdata->rx_skb);
@@ -141,14 +143,15 @@ void st_reg_complete(struct st_data_s *st_gdata, char err)
 	unsigned char i = 0;
 	pr_info(" %s ", __func__);
 	for (i = 0; i < ST_MAX_CHANNELS; i++) {
-		if (likely(st_gdata != NULL && st_gdata->list[i] != NULL &&
-			   st_gdata->list[i]->reg_complete_cb != NULL)) {
+		if (likely(st_gdata != NULL &&
+			st_gdata->is_registered[i] == true &&
+				st_gdata->list[i]->reg_complete_cb != NULL)) {
 			st_gdata->list[i]->reg_complete_cb
 				(st_gdata->list[i]->priv_data, err);
 			pr_info("protocol %d's cb sent %d\n", i, err);
 			if (err) { /* cleanup registered protocol */
 				st_gdata->protos_registered--;
-				st_gdata->list[i] = NULL;
+				st_gdata->is_registered[i] = false;
 			}
 		}
 	}
@@ -475,9 +478,9 @@ void kim_st_list_protocols(struct st_data_s *st_gdata, void *buf)
 {
 	seq_printf(buf, "[%d]\nBT=%c\nFM=%c\nGPS=%c\n",
 			st_gdata->protos_registered,
-			st_gdata->list[0x04] != NULL ? 'R' : 'U',
-			st_gdata->list[0x08] != NULL ? 'R' : 'U',
-			st_gdata->list[0x09] != NULL ? 'R' : 'U');
+			st_gdata->is_registered[0x04] == true ? 'R' : 'U',
+			st_gdata->is_registered[0x08] == true ? 'R' : 'U',
+			st_gdata->is_registered[0x09] == true ? 'R' : 'U');
 }
 
 /********************************************************************/
@@ -504,7 +507,7 @@ long st_register(struct st_proto_s *new_proto)
 		return -EPROTONOSUPPORT;
 	}
 
-	if (st_gdata->list[new_proto->chnl_id] != NULL) {
+	if (st_gdata->is_registered[new_proto->chnl_id] == true) {
 		pr_err("chnl_id %d already registered", new_proto->chnl_id);
 		return -EALREADY;
 	}
@@ -563,7 +566,7 @@ long st_register(struct st_proto_s *new_proto)
 		/* check for already registered once more,
 		 * since the above check is old
 		 */
-		if (st_gdata->list[new_proto->chnl_id] != NULL) {
+		if (st_gdata->is_registered[new_proto->chnl_id] == true) {
 			pr_err(" proto %d already registered ",
 				   new_proto->chnl_id);
 			return -EALREADY;
diff --git a/include/linux/ti_wilink_st.h b/include/linux/ti_wilink_st.h
index 7071ec5..b004e55 100644
--- a/include/linux/ti_wilink_st.h
+++ b/include/linux/ti_wilink_st.h
@@ -140,12 +140,12 @@ extern long st_unregister(struct st_proto_s *);
  */
 struct st_data_s {
 	unsigned long st_state;
-	struct tty_struct *tty;
 	struct sk_buff *tx_skb;
 #define ST_TX_SENDING	1
 #define ST_TX_WAKEUP	2
 	unsigned long tx_state;
 	struct st_proto_s *list[ST_MAX_CHANNELS];
+	bool is_registered[ST_MAX_CHANNELS];
 	unsigned long rx_state;
 	unsigned long rx_count;
 	struct sk_buff *rx_skb;
@@ -155,6 +155,7 @@ struct st_data_s {
 	unsigned char	protos_registered;
 	unsigned long ll_state;
 	void *kim_data;
+	struct tty_struct *tty;
 };
 
 /*
-- 
1.7.4.2

