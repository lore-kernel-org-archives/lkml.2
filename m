Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab1CPV00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:26:26 -0400
Received: from kroah.org ([198.145.64.141]:42642 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab1CPVL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:11:56 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Pavan Savoy <pavan_savoy@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 24/50] drivers:misc: ti-st: set right debug levels for logs
Date: Wed, 16 Mar 2011 14:11:02 -0700
Message-Id: <1300309888-5028-24-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

pr_debug-ing few pr_infos from the data paths such as tty receive and
write so as to reduce debugs when we have higher logging levels enabled
undef VERBOSE in receive to avoid huge logs when log level 8 is set.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/ti-st/st_core.c |   19 +++++++++----------
 drivers/misc/ti-st/st_ll.c   |    8 ++++----
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index 79d2dc3..f7bb96f 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -82,7 +82,7 @@ int st_int_write(struct st_data_s *st_gdata,
  */
 void st_send_frame(unsigned char chnl_id, struct st_data_s *st_gdata)
 {
-	pr_info(" %s(prot:%d) ", __func__, chnl_id);
+	pr_debug(" %s(prot:%d) ", __func__, chnl_id);
 
 	if (unlikely
 	    (st_gdata == NULL || st_gdata->rx_skb == NULL
@@ -226,7 +226,7 @@ void st_int_recv(void *disc_data,
 		return;
 	}
 
-	pr_info("count %ld rx_state %ld"
+	pr_debug("count %ld rx_state %ld"
 		   "rx_count %ld", count, st_gdata->rx_state,
 		   st_gdata->rx_count);
 
@@ -260,7 +260,7 @@ void st_int_recv(void *disc_data,
 				plen =
 				&st_gdata->rx_skb->data
 				[proto->offset_len_in_hdr];
-				pr_info("plen pointing to %x\n", *plen);
+				pr_debug("plen pointing to %x\n", *plen);
 				if (proto->len_size == 1)/* 1 byte len field */
 					payload_len = *(unsigned char *)plen;
 				else if (proto->len_size == 2)
@@ -272,7 +272,7 @@ void st_int_recv(void *disc_data,
 					__func__, proto->chnl_id);
 				st_check_data_len(st_gdata, proto->chnl_id,
 						payload_len);
-				pr_info("off %d, pay len %d\n",
+				pr_debug("off %d, pay len %d\n",
 					proto->offset_len_in_hdr, payload_len);
 				continue;
 			}	/* end of switch rx_state */
@@ -285,7 +285,7 @@ void st_int_recv(void *disc_data,
 		case LL_SLEEP_IND:
 		case LL_SLEEP_ACK:
 		case LL_WAKE_UP_IND:
-			pr_info("PM packet");
+			pr_debug("PM packet");
 			/* this takes appropriate action based on
 			 * sleep state received --
 			 */
@@ -294,7 +294,7 @@ void st_int_recv(void *disc_data,
 			count--;
 			continue;
 		case LL_WAKE_UP_ACK:
-			pr_info("PM packet");
+			pr_debug("PM packet");
 			/* wake up ack received */
 			st_wakeup_ack(st_gdata, *ptr);
 			ptr++;
@@ -314,7 +314,7 @@ void st_int_recv(void *disc_data,
 			st_gdata->rx_chnl = *ptr;
 			st_gdata->rx_state = ST_W4_HEADER;
 			st_gdata->rx_count = st_gdata->list[type]->hdr_len;
-			pr_info("rx_count %ld\n", st_gdata->rx_count);
+			pr_debug("rx_count %ld\n", st_gdata->rx_count);
 		};
 		ptr++;
 		count--;
@@ -360,7 +360,7 @@ void st_int_enqueue(struct st_data_s *st_gdata, struct sk_buff *skb)
 
 	switch (st_ll_getstate(st_gdata)) {
 	case ST_LL_AWAKE:
-		pr_info("ST LL is AWAKE, sending normally");
+		pr_debug("ST LL is AWAKE, sending normally");
 		skb_queue_tail(&st_gdata->txq, skb);
 		break;
 	case ST_LL_ASLEEP_TO_AWAKE:
@@ -400,7 +400,7 @@ void st_tx_wakeup(struct st_data_s *st_data)
 	pr_debug("%s", __func__);
 	/* check for sending & set flag sending here */
 	if (test_and_set_bit(ST_TX_SENDING, &st_data->tx_state)) {
-		pr_info("ST already sending");
+		pr_debug("ST already sending");
 		/* keep sending */
 		set_bit(ST_TX_WAKEUP, &st_data->tx_state);
 		return;
@@ -735,7 +735,6 @@ static void st_tty_close(struct tty_struct *tty)
 static void st_tty_receive(struct tty_struct *tty, const unsigned char *data,
 			   char *tty_flags, int count)
 {
-#define VERBOSE
 #ifdef VERBOSE
 	print_hex_dump(KERN_DEBUG, ">in>", DUMP_PREFIX_NONE,
 		16, 1, data, count, 0);
diff --git a/drivers/misc/ti-st/st_ll.c b/drivers/misc/ti-st/st_ll.c
index f72de6b..3f24951 100644
--- a/drivers/misc/ti-st/st_ll.c
+++ b/drivers/misc/ti-st/st_ll.c
@@ -30,7 +30,7 @@ static void send_ll_cmd(struct st_data_s *st_data,
 	unsigned char cmd)
 {
 
-	pr_info("%s: writing %x", __func__, cmd);
+	pr_debug("%s: writing %x", __func__, cmd);
 	st_int_write(st_data, &cmd, 1);
 	return;
 }
@@ -114,18 +114,18 @@ unsigned long st_ll_sleep_state(struct st_data_s *st_data,
 {
 	switch (cmd) {
 	case LL_SLEEP_IND:	/* sleep ind */
-		pr_info("sleep indication recvd");
+		pr_debug("sleep indication recvd");
 		ll_device_want_to_sleep(st_data);
 		break;
 	case LL_SLEEP_ACK:	/* sleep ack */
 		pr_err("sleep ack rcvd: host shouldn't");
 		break;
 	case LL_WAKE_UP_IND:	/* wake ind */
-		pr_info("wake indication recvd");
+		pr_debug("wake indication recvd");
 		ll_device_want_to_wakeup(st_data);
 		break;
 	case LL_WAKE_UP_ACK:	/* wake ack */
-		pr_info("wake ack rcvd");
+		pr_debug("wake ack rcvd");
 		st_data->ll_state = ST_LL_AWAKE;
 		break;
 	default:
-- 
1.7.4.1

