Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab0JLTO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 15:14:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40535 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab0JLTO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 15:14:56 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH] drivers:misc: ti-st: fix review comments
Date: Tue, 12 Oct 2010 16:27:38 -0400
Message-Id: <1286915258-17983-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Based on comments from Jiri Slaby, drop the register
storage specifier, remove the unused code, cleanup
the const to non-const type casting.
Also make the line discipline ops structure static, since
its a singleton, unmodified structure which need not be
in heap.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/ti-st/st_core.c |   73 ++++++++++--------------------------------
 drivers/misc/ti-st/st_kim.c  |   15 ++++----
 include/linux/ti_wilink_st.h |    2 -
 3 files changed, 25 insertions(+), 65 deletions(-)

diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index 9bae0eb..f9aad06 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -31,15 +31,6 @@
 #include <net/bluetooth/hci.h>
 #include <linux/ti_wilink_st.h>
 
-/* strings to be used for rfkill entries and by
- * ST Core to be used for sysfs debug entry
- */
-#define PROTO_ENTRY(type, name)	name
-const unsigned char *protocol_strngs[] = {
-	PROTO_ENTRY(ST_BT, "Bluetooth"),
-	PROTO_ENTRY(ST_FM, "FM"),
-	PROTO_ENTRY(ST_GPS, "GPS"),
-};
 /* function pointer pointing to either,
  * st_kim_recv during registration to receive fw download responses
  * st_int_recv after registration to receive proto stack responses
@@ -144,7 +135,7 @@ void st_reg_complete(struct st_data_s *st_gdata, char err)
 static inline int st_check_data_len(struct st_data_s *st_gdata,
 	int protoid, int len)
 {
-	register int room = skb_tailroom(st_gdata->rx_skb);
+	int room = skb_tailroom(st_gdata->rx_skb);
 
 	pr_debug("len %d room %d", len, room);
 
@@ -187,7 +178,7 @@ static inline int st_check_data_len(struct st_data_s *st_gdata,
 static inline void st_wakeup_ack(struct st_data_s *st_gdata,
 	unsigned char cmd)
 {
-	register struct sk_buff *waiting_skb;
+	struct sk_buff *waiting_skb;
 	unsigned long flags = 0;
 
 	spin_lock_irqsave(&st_gdata->lock, flags);
@@ -216,13 +207,13 @@ static inline void st_wakeup_ack(struct st_data_s *st_gdata,
 void st_int_recv(void *disc_data,
 	const unsigned char *data, long count)
 {
-	register char *ptr;
+	char *ptr;
 	struct hci_event_hdr *eh;
 	struct hci_acl_hdr *ah;
 	struct hci_sco_hdr *sh;
 	struct fm_event_hdr *fm;
 	struct gps_event_hdr *gps;
-	register int len = 0, type = 0, dlen = 0;
+	int len = 0, type = 0, dlen = 0;
 	static enum proto_type protoid = ST_MAX;
 	struct st_data_s *st_gdata = (struct st_data_s *)disc_data;
 
@@ -918,34 +909,27 @@ static void st_tty_flush_buffer(struct tty_struct *tty)
 	return;
 }
 
+static struct tty_ldisc_ops st_ldisc_ops = {
+	.magic = TTY_LDISC_MAGIC,
+	.name = "n_st",
+	.open = st_tty_open,
+	.close = st_tty_close,
+	.receive_buf = st_tty_receive,
+	.write_wakeup = st_tty_wakeup,
+	.flush_buffer = st_tty_flush_buffer,
+	.owner = THIS_MODULE
+};
+
 /********************************************************************/
 int st_core_init(struct st_data_s **core_data)
 {
 	struct st_data_s *st_gdata;
 	long err;
-	static struct tty_ldisc_ops *st_ldisc_ops;
-
-	/* populate and register to TTY line discipline */
-	st_ldisc_ops = kzalloc(sizeof(*st_ldisc_ops), GFP_KERNEL);
-	if (!st_ldisc_ops) {
-		pr_err("no mem to allocate");
-		return -ENOMEM;
-	}
 
-	st_ldisc_ops->magic = TTY_LDISC_MAGIC;
-	st_ldisc_ops->name = "n_st";	/*"n_hci"; */
-	st_ldisc_ops->open = st_tty_open;
-	st_ldisc_ops->close = st_tty_close;
-	st_ldisc_ops->receive_buf = st_tty_receive;
-	st_ldisc_ops->write_wakeup = st_tty_wakeup;
-	st_ldisc_ops->flush_buffer = st_tty_flush_buffer;
-	st_ldisc_ops->owner = THIS_MODULE;
-
-	err = tty_register_ldisc(N_TI_WL, st_ldisc_ops);
+	err = tty_register_ldisc(N_TI_WL, &st_ldisc_ops);
 	if (err) {
 		pr_err("error registering %d line discipline %ld",
 			   N_TI_WL, err);
-		kfree(st_ldisc_ops);
 		return err;
 	}
 	pr_debug("registered n_shared line discipline");
@@ -956,7 +940,6 @@ int st_core_init(struct st_data_s **core_data)
 		err = tty_unregister_ldisc(N_TI_WL);
 		if (err)
 			pr_err("unable to un-register ldisc %ld", err);
-		kfree(st_ldisc_ops);
 		err = -ENOMEM;
 		return err;
 	}
@@ -970,22 +953,6 @@ int st_core_init(struct st_data_s **core_data)
 	/* Locking used in st_int_enqueue() to avoid multiple execution */
 	spin_lock_init(&st_gdata->lock);
 
-	/* ldisc_ops ref to be only used in __exit of module */
-	st_gdata->ldisc_ops = st_ldisc_ops;
-
-#if 0
-	err = st_kim_init();
-	if (err) {
-		pr_err("error during kim initialization(%ld)", err);
-		kfree(st_gdata);
-		err = tty_unregister_ldisc(N_TI_WL);
-		if (err)
-			pr_err("unable to un-register ldisc");
-		kfree(st_ldisc_ops);
-		return -1;
-	}
-#endif
-
 	err = st_ll_init(st_gdata);
 	if (err) {
 		pr_err("error during st_ll initialization(%ld)", err);
@@ -993,7 +960,6 @@ int st_core_init(struct st_data_s **core_data)
 		err = tty_unregister_ldisc(N_TI_WL);
 		if (err)
 			pr_err("unable to un-register ldisc");
-		kfree(st_ldisc_ops);
 		return -1;
 	}
 	*core_data = st_gdata;
@@ -1007,11 +973,7 @@ void st_core_exit(struct st_data_s *st_gdata)
 	err = st_ll_deinit(st_gdata);
 	if (err)
 		pr_err("error during deinit of ST LL %ld", err);
-#if 0
-	err = st_kim_deinit();
-	if (err)
-		pr_err("error during deinit of ST KIM %ld", err);
-#endif
+
 	if (st_gdata != NULL) {
 		/* Free ST Tx Qs and skbs */
 		skb_queue_purge(&st_gdata->txq);
@@ -1022,7 +984,6 @@ void st_core_exit(struct st_data_s *st_gdata)
 		err = tty_unregister_ldisc(N_TI_WL);
 		if (err)
 			pr_err("unable to un-register ldisc %ld", err);
-		kfree(st_gdata->ldisc_ops);
 		/* free the global data pointer */
 		kfree(st_gdata);
 	}
diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index 6d23a72..73b6c8b 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -75,7 +75,7 @@ const unsigned char *protocol_names[] = {
 };
 
 #define MAX_ST_DEVICES	3	/* Imagine 1 on each UART for now */
-struct platform_device *st_kim_devices[MAX_ST_DEVICES];
+static struct platform_device *st_kim_devices[MAX_ST_DEVICES];
 
 /**********************************************************************/
 /* internal functions */
@@ -157,17 +157,18 @@ static inline int kim_check_data_len(struct kim_data_s *kim_gdata, int len)
 void kim_int_recv(struct kim_data_s *kim_gdata,
 	const unsigned char *data, long count)
 {
-	register char *ptr;
+	const unsigned char *ptr;
 	struct hci_event_hdr *eh;
-	register int len = 0, type = 0;
+	int len = 0, type = 0;
 
 	pr_debug("%s", __func__);
 	/* Decode received bytes here */
-	ptr = (char *)data;
+	ptr = data;
 	if (unlikely(ptr == NULL)) {
 		pr_err(" received null from TTY ");
 		return;
 	}
+
 	while (count) {
 		if (kim_gdata->rx_count) {
 			len = min_t(unsigned int, kim_gdata->rx_count, count);
@@ -231,7 +232,7 @@ void kim_int_recv(struct kim_data_s *kim_gdata,
 static long read_local_version(struct kim_data_s *kim_gdata, char *bts_scr_name)
 {
 	unsigned short version = 0, chip = 0, min_ver = 0, maj_ver = 0;
-	char read_ver_cmd[] = { 0x01, 0x01, 0x10, 0x00 };
+	const char read_ver_cmd[] = { 0x01, 0x01, 0x10, 0x00 };
 
 	pr_debug("%s", __func__);
 
@@ -278,8 +279,8 @@ static long download_firmware(struct kim_data_s *kim_gdata)
 {
 	long err = 0;
 	long len = 0;
-	register unsigned char *ptr = NULL;
-	register unsigned char *action_ptr = NULL;
+	unsigned char *ptr = NULL;
+	unsigned char *action_ptr = NULL;
 	unsigned char bts_scr_name[30] = { 0 };	/* 30 char long bts scr name? */
 
 	err = read_local_version(kim_gdata, bts_scr_name);
diff --git a/include/linux/ti_wilink_st.h b/include/linux/ti_wilink_st.h
index 2a5acf5..4c7be22 100644
--- a/include/linux/ti_wilink_st.h
+++ b/include/linux/ti_wilink_st.h
@@ -101,7 +101,6 @@ extern long st_unregister(enum proto_type);
  *	can occur , where as during other times other events CH8, CH9
  *	can occur.
  * @tty: tty provided by the TTY core for line disciplines.
- * @ldisc_ops: the procedures that this line discipline registers with TTY.
  * @tx_skb: If for some reason the tty's write returns lesser bytes written
  *	then to maintain the rest of data to be written on next instance.
  *	This needs to be protected, hence the lock inside wakeup func.
@@ -132,7 +131,6 @@ extern long st_unregister(enum proto_type);
 struct st_data_s {
 	unsigned long st_state;
 	struct tty_struct *tty;
-	struct tty_ldisc_ops *ldisc_ops;
 	struct sk_buff *tx_skb;
 #define ST_TX_SENDING	1
 #define ST_TX_WAKEUP	2
-- 
1.6.5

