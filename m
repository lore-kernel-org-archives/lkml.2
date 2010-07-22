Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841Ab0GVKco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 06:32:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34181 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177Ab0GVKcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 06:32:24 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        pavan_savoy@sify.com, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 1/3] drivers:staging:ti-st: smarten, reduce logs
Date: Thu, 22 Jul 2010 05:32:05 -0500
Message-Id: <1279794727-7669-2-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1279794727-7669-1-git-send-email-pavan_savoy@ti.com>
References: <1279794727-7669-1-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Replace looping on the data buffers and printk-ing by
print_hex_dump.
Also replace most of the pr_info by pr_debug to reduce logging at
default loglevels (7 in our case..)

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/staging/ti-st/st_core.c |   56 ++++++++++++++++----------------------
 drivers/staging/ti-st/st_kim.c  |   21 ++++++--------
 drivers/staging/ti-st/st_ll.c   |    4 +-
 3 files changed, 35 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/ti-st/st_core.c b/drivers/staging/ti-st/st_core.c
index 0ad8cec..7806843 100644
--- a/drivers/staging/ti-st/st_core.c
+++ b/drivers/staging/ti-st/st_core.c
@@ -38,6 +38,7 @@
 #include "st_ll.h"
 #include "st.h"
 
+#define VERBOSE
 #ifdef DEBUG
 /* strings to be used for rfkill entries and by
  * ST Core to be used for sysfs debug entry
@@ -61,7 +62,7 @@ void (*st_recv) (void*, const unsigned char*, long);
 bool is_protocol_list_empty(void)
 {
 	unsigned char i = 0;
-	pr_info(" %s ", __func__);
+	pr_debug(" %s ", __func__);
 	for (i = 0; i < ST_MAX; i++) {
 		if (st_gdata->list[i] != NULL)
 			return ST_NOTEMPTY;
@@ -81,9 +82,6 @@ bool is_protocol_list_empty(void)
 int st_int_write(struct st_data_s *st_gdata,
 	const unsigned char *data, int count)
 {
-#ifdef VERBOSE			/* for debug */
-	int i;
-#endif
 	struct tty_struct *tty;
 	if (unlikely(st_gdata == NULL || st_gdata->tty == NULL)) {
 		pr_err("tty unavailable to perform write");
@@ -91,10 +89,8 @@ int st_int_write(struct st_data_s *st_gdata,
 	}
 	tty = st_gdata->tty;
 #ifdef VERBOSE
-	printk(KERN_ERR "start data..\n");
-	for (i = 0; i < count; i++)	/* no newlines for each datum */
-		printk(" %x", data[i]);
-	printk(KERN_ERR "\n ..end data\n");
+	print_hex_dump(KERN_DEBUG, "<out<", DUMP_PREFIX_NONE,
+		16, 1, data, count, 0);
 #endif
 	return tty->ops->write(tty, data, count);
 
@@ -132,7 +128,6 @@ void st_send_frame(enum proto_type protoid, struct st_data_s *st_gdata)
 		pr_err(" proto stack %d's ->recv null", protoid);
 		kfree_skb(st_gdata->rx_skb);
 	}
-	pr_info(" done %s", __func__);
 	return;
 }
 
@@ -156,7 +151,7 @@ static inline int st_check_data_len(struct st_data_s *st_gdata,
 {
 	register int room = skb_tailroom(st_gdata->rx_skb);
 
-	pr_info("len %d room %d", len, room);
+	pr_debug("len %d room %d", len, room);
 
 	if (!len) {
 		/* Received packet has only packet header and
@@ -259,7 +254,7 @@ void st_int_recv(void *disc_data,
 
 				/* Waiting for complete packet ? */
 			case ST_BT_W4_DATA:
-				pr_info("Complete pkt received");
+				pr_debug("Complete pkt received");
 
 				/* Ask ST CORE to forward
 				 * the packet to protocol driver */
@@ -275,7 +270,7 @@ void st_int_recv(void *disc_data,
 				eh = (struct hci_event_hdr *)st_gdata->rx_skb->
 				    data;
 
-				pr_info("Event header: evt 0x%2.2x"
+				pr_debug("Event header: evt 0x%2.2x"
 					   "plen %d", eh->evt, eh->plen);
 
 				st_check_data_len(st_gdata, protoid, eh->plen);
@@ -439,7 +434,7 @@ void st_int_recv(void *disc_data,
 			break;
 		}
 	}
-	pr_info("done %s", __func__);
+	pr_debug("done %s", __func__);
 	return;
 }
 
@@ -451,7 +446,7 @@ struct sk_buff *st_int_dequeue(struct st_data_s *st_gdata)
 {
 	struct sk_buff *returning_skb;
 
-	pr_info("%s", __func__);
+	pr_debug("%s", __func__);
 	/* if the previous skb wasn't written completely
 	 */
 	if (st_gdata->tx_skb != NULL) {
@@ -475,7 +470,7 @@ void st_int_enqueue(struct st_data_s *st_gdata, struct sk_buff *skb)
 {
 	unsigned long flags = 0;
 
-	pr_info("%s", __func__);
+	pr_debug("%s", __func__);
 	/* this function can be invoked in more then one context.
 	 * so have a lock */
 	spin_lock_irqsave(&st_gdata->lock, flags);
@@ -508,7 +503,7 @@ void st_int_enqueue(struct st_data_s *st_gdata, struct sk_buff *skb)
 		break;
 	}
 	spin_unlock_irqrestore(&st_gdata->lock, flags);
-	pr_info("done %s", __func__);
+	pr_debug("done %s", __func__);
 	return;
 }
 
@@ -522,7 +517,7 @@ void st_tx_wakeup(struct st_data_s *st_data)
 {
 	struct sk_buff *skb;
 	unsigned long flags;	/* for irq save flags */
-	pr_info("%s", __func__);
+	pr_debug("%s", __func__);
 	/* check for sending & set flag sending here */
 	if (test_and_set_bit(ST_TX_SENDING, &st_data->tx_state)) {
 		pr_info("ST already sending");
@@ -674,7 +669,7 @@ long st_register(struct st_proto_s *new_proto)
 		 */
 		if ((st_gdata->protos_registered != ST_EMPTY) &&
 		    (test_bit(ST_REG_PENDING, &st_gdata->st_state))) {
-			pr_info(" call reg complete callback ");
+			pr_debug(" call reg complete callback ");
 			st_reg_complete(st_gdata, 0);
 		}
 		clear_bit(ST_REG_PENDING, &st_gdata->st_state);
@@ -721,7 +716,7 @@ long st_register(struct st_proto_s *new_proto)
 		spin_unlock_irqrestore(&st_gdata->lock, flags);
 		return err;
 	}
-	pr_info("done %s(%d) ", __func__, new_proto->type);
+	pr_debug("done %s(%d) ", __func__, new_proto->type);
 }
 EXPORT_SYMBOL_GPL(st_register);
 
@@ -734,7 +729,7 @@ long st_unregister(enum proto_type type)
 	unsigned long flags = 0;
 	struct st_data_s	*st_gdata;
 
-	pr_info("%s: %d ", __func__, type);
+	pr_debug("%s: %d ", __func__, type);
 
 	st_kim_ref(&st_gdata);
 	if (type < ST_BT || type >= ST_MAX) {
@@ -816,7 +811,7 @@ long st_write(struct sk_buff *skb)
 		return -1;
 	}
 #endif
-	pr_info("%d to be written", skb->len);
+	pr_debug("%d to be written", skb->len);
 	len = skb->len;
 
 	/* st_ll to decide where to enqueue the skb */
@@ -859,7 +854,7 @@ static int st_tty_open(struct tty_struct *tty)
 	 * installation of N_TI_WL ldisc is complete
 	 */
 	st_kim_complete(st_gdata->kim_data);
-	pr_info("done %s", __func__);
+	pr_debug("done %s", __func__);
 	return err;
 }
 
@@ -903,7 +898,7 @@ static void st_tty_close(struct tty_struct *tty)
 	st_gdata->rx_skb = NULL;
 	spin_unlock_irqrestore(&st_gdata->lock, flags);
 
-	pr_info("%s: done ", __func__);
+	pr_debug("%s: done ", __func__);
 }
 
 static void st_tty_receive(struct tty_struct *tty, const unsigned char *data,
@@ -911,11 +906,8 @@ static void st_tty_receive(struct tty_struct *tty, const unsigned char *data,
 {
 
 #ifdef VERBOSE
-	long i;
-	printk(KERN_ERR "incoming data...\n");
-	for (i = 0; i < count; i++)
-		printk(" %x", data[i]);
-	printk(KERN_ERR "\n.. data end\n");
+	print_hex_dump(KERN_DEBUG, ">in>", DUMP_PREFIX_NONE,
+		16, 1, data, count, 0);
 #endif
 
 	/*
@@ -923,7 +915,7 @@ static void st_tty_receive(struct tty_struct *tty, const unsigned char *data,
 	 * to KIM for validation
 	 */
 	st_recv(tty->disc_data, data, count);
-	pr_info("done %s", __func__);
+	pr_debug("done %s", __func__);
 }
 
 /* wake-up function called in from the TTY layer
@@ -932,7 +924,7 @@ static void st_tty_receive(struct tty_struct *tty, const unsigned char *data,
 static void st_tty_wakeup(struct tty_struct *tty)
 {
 	struct	st_data_s *st_gdata = tty->disc_data;
-	pr_info("%s ", __func__);
+	pr_debug("%s ", __func__);
 	/* don't do an wakeup for now */
 	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
 
@@ -943,7 +935,7 @@ static void st_tty_wakeup(struct tty_struct *tty)
 static void st_tty_flush_buffer(struct tty_struct *tty)
 {
 	struct	st_data_s *st_gdata = tty->disc_data;
-	pr_info("%s ", __func__);
+	pr_debug("%s ", __func__);
 
 	kfree_skb(st_gdata->tx_skb);
 	st_gdata->tx_skb = NULL;
@@ -982,7 +974,7 @@ int st_core_init(struct st_data_s **core_data)
 		kfree(st_ldisc_ops);
 		return err;
 	}
-	pr_info("registered n_shared line discipline");
+	pr_debug("registered n_shared line discipline");
 
 	st_gdata = kzalloc(sizeof(struct st_data_s), GFP_KERNEL);
 	if (!st_gdata) {
diff --git a/drivers/staging/ti-st/st_kim.c b/drivers/staging/ti-st/st_kim.c
index 33fc4d0..5ab69d1 100644
--- a/drivers/staging/ti-st/st_kim.c
+++ b/drivers/staging/ti-st/st_kim.c
@@ -129,7 +129,7 @@ static inline int kim_check_data_len(struct kim_data_s *kim_gdata, int len)
 {
 	register int room = skb_tailroom(kim_gdata->rx_skb);
 
-	pr_info("len %d room %d", len, room);
+	pr_debug("len %d room %d", len, room);
 
 	if (!len) {
 		validate_firmware_response(kim_gdata);
@@ -170,7 +170,7 @@ void kim_int_recv(struct kim_data_s *kim_gdata,
 	struct hci_event_hdr *eh;
 	register int len = 0, type = 0;
 
-	pr_info("%s", __func__);
+	pr_debug("%s", __func__);
 	/* Decode received bytes here */
 	ptr = (char *)data;
 	if (unlikely(ptr == NULL)) {
@@ -192,7 +192,7 @@ void kim_int_recv(struct kim_data_s *kim_gdata,
 			switch (kim_gdata->rx_state) {
 				/* Waiting for complete packet ? */
 			case ST_BT_W4_DATA:
-				pr_info("Complete pkt received");
+				pr_debug("Complete pkt received");
 				validate_firmware_response(kim_gdata);
 				kim_gdata->rx_state = ST_W4_PACKET_TYPE;
 				kim_gdata->rx_skb = NULL;
@@ -201,7 +201,7 @@ void kim_int_recv(struct kim_data_s *kim_gdata,
 			case ST_BT_W4_EVENT_HDR:
 				eh = (struct hci_event_hdr *)kim_gdata->
 				    rx_skb->data;
-				pr_info("Event header: evt 0x%2.2x"
+				pr_debug("Event header: evt 0x%2.2x"
 					   "plen %d", eh->evt, eh->plen);
 				kim_check_data_len(kim_gdata, eh->plen);
 				continue;
@@ -242,7 +242,7 @@ static long read_local_version(struct kim_data_s *kim_gdata, char *bts_scr_name)
 	unsigned short version = 0, chip = 0, min_ver = 0, maj_ver = 0;
 	char read_ver_cmd[] = { 0x01, 0x01, 0x10, 0x00 };
 
-	pr_info("%s", __func__);
+	pr_debug("%s", __func__);
 
 	INIT_COMPLETION(kim_gdata->kim_rcvd);
 	if (4 != st_int_write(kim_gdata->core_data, read_ver_cmd, 4)) {
@@ -289,8 +289,6 @@ static long download_firmware(struct kim_data_s *kim_gdata)
 	register unsigned char *action_ptr = NULL;
 	unsigned char bts_scr_name[30] = { 0 };	/* 30 char long bts scr name? */
 
-	pr_info("%s", __func__);
-
 	err = read_local_version(kim_gdata, bts_scr_name);
 	if (err != 0) {
 		pr_err("kim: failed to read local ver");
@@ -314,7 +312,7 @@ static long download_firmware(struct kim_data_s *kim_gdata)
 	len -= sizeof(struct bts_header);
 
 	while (len > 0 && ptr) {
-		pr_info(" action size %d, type %d ",
+		pr_debug(" action size %d, type %d ",
 			   ((struct bts_action *)ptr)->size,
 			   ((struct bts_action *)ptr)->type);
 
@@ -327,8 +325,8 @@ static long download_firmware(struct kim_data_s *kim_gdata)
 				/* ignore remote change
 				 * baud rate HCI VS command */
 				pr_err
-				    (" change remote baud\
-				    rate command in firmware");
+				    (" change remote baud"
+				    " rate command in firmware");
 				break;
 			}
 
@@ -558,7 +556,6 @@ static ssize_t store_pid(struct device *dev, struct device_attribute
 			 *devattr, char *buf, size_t count)
 {
 	struct kim_data_s	*kim_gdata = dev_get_drvdata(dev);
-	pr_info("%s: pid %s ", __func__, buf);
 	sscanf(buf, "%ld", &kim_gdata->uim_pid);
 	/* to be made use by kim_start to signal SIGUSR2
 	 */
@@ -590,7 +587,7 @@ static ssize_t show_list(struct device *dev, struct device_attribute
 static int kim_toggle_radio(void *data, bool blocked)
 {
 	enum proto_type type = *((enum proto_type *)data);
-	pr_info(" %s: %d ", __func__, type);
+	pr_debug(" %s: %d ", __func__, type);
 
 	switch (type) {
 	case ST_BT:
diff --git a/drivers/staging/ti-st/st_ll.c b/drivers/staging/ti-st/st_ll.c
index 6bc0759..7a1fb6d 100644
--- a/drivers/staging/ti-st/st_ll.c
+++ b/drivers/staging/ti-st/st_ll.c
@@ -34,7 +34,7 @@ static void send_ll_cmd(struct st_data_s *st_data,
 
 static void ll_device_want_to_sleep(struct st_data_s *st_data)
 {
-	pr_info("%s", __func__);
+	pr_debug("%s", __func__);
 	/* sanity check */
 	if (st_data->ll_state != ST_LL_AWAKE)
 		pr_err("ERR hcill: ST_LL_GO_TO_SLEEP_IND"
@@ -101,7 +101,7 @@ void st_ll_wakeup(struct st_data_s *ll)
 /* called when ST Core wants the state */
 unsigned long st_ll_getstate(struct st_data_s *ll)
 {
-	pr_info(" returning state %ld", ll->ll_state);
+	pr_debug(" returning state %ld", ll->ll_state);
 	return ll->ll_state;
 }
 
-- 
1.5.6.3

