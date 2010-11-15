Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933570Ab0KOTPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:15:46 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46358 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932900Ab0KOTPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:15:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Lp0yy08pxzFTU1QAStJYUA4Q/ukrTkYGqDHCGNr1zsy+xSnfQREijHeSylv38RaJfQ
         ARCM9j/IaTnOdkf4AZkBrydnJeLS1sOuV0vKs3NR+QiIhnhWr/wxOVjGeXbABKj5mVNL
         TB7tJmGL4elUumAXfb7conSwGegScuZaDtGPg=
MIME-Version: 1.0
In-Reply-To: <AANLkTikRh4CPY8pdCA=MvXmXgyS-LPk1y2QYrNBQvLuf@mail.gmail.com>
References: <AANLkTikLJyr6PREZX-OwOBwMK8uTC2YEu-KHHy0MYFJJ@mail.gmail.com>
	<19F8576C6E063C45BE387C64729E739404A9F4CF11@dbde02.ent.ti.com>
	<AANLkTikRh4CPY8pdCA=MvXmXgyS-LPk1y2QYrNBQvLuf@mail.gmail.com>
Date: Mon, 15 Nov 2010 20:15:43 +0100
Message-ID: <AANLkTim=dnUD40oHZKj2aA9SQno1zAx6rcJVnK-dCDe+@mail.gmail.com>
Subject: Re: shared transport: only for TI chips?
From: Vitaly Wool <vitalywool@gmail.com>
To: "Savoy, Pavan" <pavan_savoy@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavan,

>> So, yes, I welcome ideas and let's see how best we can implement them... shoot them away...

this is something I've been thinking of. Please note that the naming
has not been sorted out, also I'd like to move rfkill stuff up to the
core at some point. But anyway, this is what this patch does on a high
level:

- moves TI-specific Bluetooth low power protocol out of st_core
- introduces structure for low-level operations
- makes st_ll.c provide the implementation of this operations structure
- merges st_kim.c and st_ll.c and considers this file to be
chip-specific platform driver
- hopefully makes it possible for other vendor's solutions to use this
framework (e. g. ST Ericsson that has recently posted patches
addressing the same problem)

TODO:
- move rfkill stuff to st_core
- move GPIO stuff to platform code (doesn't really belong here IMHO)
- make st_core work with several instances of platform driver and/or
several platform drivers at the same time

 drivers/misc/ti-st/Makefile  |    2
 drivers/misc/ti-st/st_core.c |  174 ++++++++++++++------------------
 drivers/misc/ti-st/st_kim.c  |  233 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/misc/ti-st/st_ll.c   |  150 ---------------------------
 include/linux/ti_wilink_st.h |   96 ++++-------------
 5 files changed, 332 insertions(+), 323 deletions(-)

Signed-off-by: Vitaly Wool <vitaly.wool@sonyericsson.com>

diff --git a/drivers/misc/ti-st/Makefile b/drivers/misc/ti-st/Makefile
index 78d7ebb..c7e32aa 100644
--- a/drivers/misc/ti-st/Makefile
+++ b/drivers/misc/ti-st/Makefile
@@ -3,4 +3,4 @@
 # and its protocol drivers (BT, FM, GPS)
 #
 obj-$(CONFIG_TI_ST) 		+= st_drv.o
-st_drv-objs			:= st_core.o st_kim.o st_ll.o
+st_drv-objs			:= st_core.o st_kim.o
diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index f9aad06..3e070ec 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -54,6 +54,34 @@ bool is_protocol_list_empty(void)
 }
 #endif

+static inline int st_ll_process_rx(struct st_data_s *st_data, char *p)
+{
+	return st_data->ll_ops->process_rx ?
+		st_data->ll_ops->process_rx(st_data->kim_data, p) : -EINVAL;
+}
+
+static inline int st_ll_is_awake(struct st_data_s *st_data)
+{
+	return st_data->ll_ops->is_awake ?
+		st_data->ll_ops->is_awake(st_data->kim_data) : 1;
+}
+
+static inline int st_ll_queue(struct st_data_s *st_data, struct sk_buff *skb)
+{
+	return st_data->ll_ops->enqueue ?
+		st_data->ll_ops->enqueue(st_data->kim_data, skb) : -EINVAL;
+}
+
+static inline void st_ll_enable(struct st_data_s *st_data)
+{
+	st_data->ll_ops->enable(st_data->kim_data);
+}
+
+static inline void st_ll_disable(struct st_data_s *st_data)
+{
+	st_data->ll_ops->disable(st_data->kim_data);
+}
+
 /* can be called in from
  * -- KIM (during fw download)
  * -- ST Core (during st_write)
@@ -172,31 +200,6 @@ static inline int st_check_data_len(struct
st_data_s *st_gdata,
 }

 /**
- * st_wakeup_ack - internal function for action when wake-up ack
- *	received
- */
-static inline void st_wakeup_ack(struct st_data_s *st_gdata,
-	unsigned char cmd)
-{
-	struct sk_buff *waiting_skb;
-	unsigned long flags = 0;
-
-	spin_lock_irqsave(&st_gdata->lock, flags);
-	/* de-Q from waitQ and Q in txQ now that the
-	 * chip is awake
-	 */
-	while ((waiting_skb = skb_dequeue(&st_gdata->tx_waitq)))
-		skb_queue_tail(&st_gdata->txq, waiting_skb);
-
-	/* state forwarded to ST LL */
-	st_ll_sleep_state(st_gdata, (unsigned long)cmd);
-	spin_unlock_irqrestore(&st_gdata->lock, flags);
-
-	/* wake up to send the recently copied skbs from waitQ */
-	st_tx_wakeup(st_gdata);
-}
-
-/**
  * st_int_recv - ST's internal receive function.
  *	Decodes received RAW data and forwards to corresponding
  *	client drivers (Bluetooth,FM,GPS..etc).
@@ -213,7 +216,7 @@ void st_int_recv(void *disc_data,
 	struct hci_sco_hdr *sh;
 	struct fm_event_hdr *fm;
 	struct gps_event_hdr *gps;
-	int len = 0, type = 0, dlen = 0;
+	int len = 0, type = 0, dlen = 0, shift = 0;
 	static enum proto_type protoid = ST_MAX;
 	struct st_data_s *st_gdata = (struct st_data_s *)disc_data;

@@ -353,29 +356,16 @@ void st_int_recv(void *disc_data,
 			st_gdata->rx_state = ST_GPS_W4_EVENT_HDR;
 			st_gdata->rx_count = 3;	/* GPS_EVENT_HDR_SIZE -1*/
 			break;
-		case LL_SLEEP_IND:
-		case LL_SLEEP_ACK:
-		case LL_WAKE_UP_IND:
-			pr_info("PM packet");
-			/* this takes appropriate action based on
-			 * sleep state received --
-			 */
-			st_ll_sleep_state(st_gdata, *ptr);
-			ptr++;
-			count--;
-			continue;
-		case LL_WAKE_UP_ACK:
-			pr_info("PM packet");
-			/* wake up ack received */
-			st_wakeup_ack(st_gdata, *ptr);
-			ptr++;
-			count--;
-			continue;
-			/* Unknow packet? */
 		default:
-			pr_err("Unknown packet type %2.2x", (__u8) *ptr);
-			ptr++;
-			count--;
+			shift = st_ll_process_rx(st_gdata, ptr);
+			if (shift < 0) {
+				/* Unknown packet? */
+				pr_err("Unknown packet type %2.2x",
+					(__u8) *ptr);
+				shift = 1;
+			}
+			ptr += shift;
+			count -= shift;
 			continue;
 		};
 		ptr++;
@@ -450,12 +440,9 @@ struct sk_buff *st_int_dequeue(struct st_data_s *st_gdata)

 /**
  * st_int_enqueue - internal Q-ing function.
- *	Will either Q the skb to txq or the tx_waitq
- *	depending on the ST LL state.
- *	If the chip is asleep, then Q it onto waitq and
- *	wakeup the chip.
- *	txq and waitq needs protection since the other contexts
- *	may be sending data, waking up chip.
+ *	Will either Q the skb to txq or pass it over
+ *	to the LL driver for queueing if the chip is
+ *	asleep.
  */
 void st_int_enqueue(struct st_data_s *st_gdata, struct sk_buff *skb)
 {
@@ -464,35 +451,41 @@ void st_int_enqueue(struct st_data_s *st_gdata,
struct sk_buff *skb)
 	pr_debug("%s", __func__);
 	spin_lock_irqsave(&st_gdata->lock, flags);

-	switch (st_ll_getstate(st_gdata)) {
-	case ST_LL_AWAKE:
+	if (st_ll_is_awake(st_gdata)) {
 		pr_info("ST LL is AWAKE, sending normally");
 		skb_queue_tail(&st_gdata->txq, skb);
-		break;
-	case ST_LL_ASLEEP_TO_AWAKE:
-		skb_queue_tail(&st_gdata->tx_waitq, skb);
-		break;
-	case ST_LL_AWAKE_TO_ASLEEP:
-		pr_err("ST LL is illegal state(%ld),"
-			   "purging received skb.", st_ll_getstate(st_gdata));
-		kfree_skb(skb);
-		break;
-	case ST_LL_ASLEEP:
-		skb_queue_tail(&st_gdata->tx_waitq, skb);
-		st_ll_wakeup(st_gdata);
-		break;
-	default:
-		pr_err("ST LL is illegal state(%ld),"
-			   "purging received skb.", st_ll_getstate(st_gdata));
-		kfree_skb(skb);
-		break;
+	} else {
+		int rc = st_ll_queue(st_gdata, skb);
+		if (rc < 0) {
+			pr_err("ST LL refused to queue packet, error %d", rc);
+			kfree_skb(skb);
+		}
 	}
-
 	spin_unlock_irqrestore(&st_gdata->lock, flags);
 	pr_debug("done %s", __func__);
 	return;
 }

+/**
+ * st_int_enqueue_waiting -
+ *	requeue waiting packets for sending
+ */
+void st_int_enqueue_waiting(struct st_data_s *st_gdata,
+			struct sk_buff_head *waitq)
+{
+	struct sk_buff *waiting_skb;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&st_gdata->lock, flags);
+	/* de-Q from waitQ and Q in txQ now that the
+	 * chip is awake
+	 */
+	while ((waiting_skb = skb_dequeue(waitq)))
+		skb_queue_tail(&st_gdata->txq, waiting_skb);
+
+	spin_unlock_irqrestore(&st_gdata->lock, flags);
+}
+
 /*
  * internal wakeup function
  * called from either
@@ -732,7 +725,7 @@ long st_unregister(enum proto_type type)
 		/* all protocols now unregistered */
 		st_kim_stop(st_gdata->kim_data);
 		/* disable ST LL */
-		st_ll_disable(st_gdata);
+		st_ll_disable(st_gdata->kim_data);
 	}
 	return err;
 }
@@ -853,9 +846,8 @@ static void st_tty_close(struct tty_struct *tty)
 	tty_driver_flush_buffer(tty);

 	spin_lock_irqsave(&st_gdata->lock, flags);
-	/* empty out txq and tx_waitq */
+	/* empty out txq */
 	skb_queue_purge(&st_gdata->txq);
-	skb_queue_purge(&st_gdata->tx_waitq);
 	/* reset the TTY Rx states of ST */
 	st_gdata->rx_count = 0;
 	st_gdata->rx_state = ST_W4_PACKET_TYPE;
@@ -921,11 +913,18 @@ static struct tty_ldisc_ops st_ldisc_ops = {
 };

 /********************************************************************/
-int st_core_init(struct st_data_s **core_data)
+int st_core_init(struct st_data_s **core_data, struct st_ll_ops *ll_ops,
+		void *kim_data)
 {
 	struct st_data_s *st_gdata;
 	long err;

+	if (!ll_ops || !ll_ops->enable || !ll_ops->disable)
+		return -EINVAL;
+
+	st_gdata->ll_ops = ll_ops;
+	st_gdata->kim_data = kim_data;
+
 	err = tty_register_ldisc(N_TI_WL, &st_ldisc_ops);
 	if (err) {
 		pr_err("error registering %d line discipline %ld",
@@ -944,24 +943,14 @@ int st_core_init(struct st_data_s **core_data)
 		return err;
 	}

-	/* Initialize ST TxQ and Tx waitQ queue head. All BT/FM/GPS module skb's
+	/* Initialize ST TxQ queue head. All BT/FM/GPS module skb's
 	 * will be pushed in this queue for actual transmission.
 	 */
 	skb_queue_head_init(&st_gdata->txq);
-	skb_queue_head_init(&st_gdata->tx_waitq);

 	/* Locking used in st_int_enqueue() to avoid multiple execution */
 	spin_lock_init(&st_gdata->lock);

-	err = st_ll_init(st_gdata);
-	if (err) {
-		pr_err("error during st_ll initialization(%ld)", err);
-		kfree(st_gdata);
-		err = tty_unregister_ldisc(N_TI_WL);
-		if (err)
-			pr_err("unable to un-register ldisc");
-		return -1;
-	}
 	*core_data = st_gdata;
 	return 0;
 }
@@ -969,15 +958,10 @@ int st_core_init(struct st_data_s **core_data)
 void st_core_exit(struct st_data_s *st_gdata)
 {
 	long err;
-	/* internal module cleanup */
-	err = st_ll_deinit(st_gdata);
-	if (err)
-		pr_err("error during deinit of ST LL %ld", err);

 	if (st_gdata != NULL) {
 		/* Free ST Tx Qs and skbs */
 		skb_queue_purge(&st_gdata->txq);
-		skb_queue_purge(&st_gdata->tx_waitq);
 		kfree_skb(st_gdata->rx_skb);
 		kfree_skb(st_gdata->tx_skb);
 		/* TTY ldisc cleanup */
diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index 73b6c8b..1e46782 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -39,6 +39,53 @@

 #include <linux/ti_wilink_st.h>

+/**
+ * struct kim_data_s - the KIM internal data, embedded as the
+ *	platform's drv data. One for each ST device in the system.
+ * @uim_pid: KIM needs to communicate with UIM to request to install
+ *	the ldisc by opening UART when protocol drivers register.
+ * @kim_pdev: the platform device added in one of the board-XX.c file
+ *	in arch/XX/ directory, 1 for each ST device.
+ * @kim_rcvd: completion handler to notify when data was received,
+ *	mainly used during fw download, which involves multiple send/wait
+ *	for each of the HCI-VS commands.
+ * @ldisc_installed: completion handler to notify that the UIM accepted
+ *	the request to install ldisc, notify from tty_open which suggests
+ *	the ldisc was properly installed.
+ * @resp_buffer: data buffer for the .bts fw file name.
+ * @fw_entry: firmware class struct to request/release the fw.
+ * @gpios: the list of core/chip enable gpios for BT, FM and GPS cores.
+ * @rx_state: the rx state for kim's receive func during fw download.
+ * @rx_count: the rx count for the kim's receive func during fw download.
+ * @rx_skb: all of fw data might not come at once, and hence data storage for
+ *	whole of the fw response, only HCI_EVENTs and hence diff from ST's
+ *	response.
+ * @rfkill: rfkill data for each of the cores to be registered with rfkill.
+ * @rf_protos: proto types of the data registered with rfkill sub-system.
+ * @core_data: ST core's data, which mainly is the tty's disc_data
+ * @version: chip version available via a sysfs entry.
+ * @tx_waitq: wait queue for packets to be transmitted when the chip is
+ *	awake again
+ * @ll_state: low-level state of the chip
+ *
+ */
+struct kim_data_s {
+	long uim_pid;
+	struct platform_device *kim_pdev;
+	struct completion kim_rcvd, ldisc_installed;
+	char resp_buffer[30];
+	const struct firmware *fw_entry;
+	long gpios[ST_MAX];
+	unsigned long rx_state;
+	unsigned long rx_count;
+	struct sk_buff *rx_skb;
+	struct rfkill *rfkill[ST_MAX];
+	enum proto_type rf_protos[ST_MAX];
+	struct st_data_s *core_data;
+	struct chip_version version;
+	struct sk_buff_head tx_waitq;
+	long ll_state;
+};

 static int kim_probe(struct platform_device *pdev);
 static int kim_remove(struct platform_device *pdev);
@@ -628,6 +675,182 @@ static const struct file_operations list_debugfs_fops = {
 };

 /**********************************************************************/
+/* Low-level power saving protocol functions */
+static void send_ll_cmd(struct kim_data_s *ll_data, unsigned char cmd)
+{
+	pr_info("%s: writing %x", __func__, cmd);
+	st_int_write(ll_data->core_data, &cmd, 1);
+	return;
+}
+
+static void ll_device_want_to_sleep(struct kim_data_s *ll_data)
+{
+	pr_debug("%s", __func__);
+	/* sanity check */
+	if (ll_data->ll_state != ST_LL_AWAKE)
+		pr_err("ERR hcill: ST_LL_GO_TO_SLEEP_IND in state %ld",
+			ll_data->ll_state);
+
+	send_ll_cmd(ll_data, LL_SLEEP_ACK);
+	/* update state */
+	ll_data->ll_state = ST_LL_ASLEEP;
+}
+
+static void ll_device_want_to_wakeup(struct kim_data_s *ll_data)
+{
+	/* diff actions in diff states */
+	switch (ll_data->ll_state) {
+	case ST_LL_ASLEEP:
+		send_ll_cmd(ll_data, LL_WAKE_UP_ACK);	/* send wake_ack */
+		break;
+	case ST_LL_ASLEEP_TO_AWAKE:
+		/* duplicate wake_ind */
+		pr_err("duplicate wake_ind while waiting for Wake ack");
+		break;
+	case ST_LL_AWAKE:
+		/* duplicate wake_ind */
+		pr_err("duplicate wake_ind already AWAKE");
+		break;
+	case ST_LL_AWAKE_TO_ASLEEP:
+		/* duplicate wake_ind */
+		pr_err("duplicate wake_ind");
+		break;
+	}
+	/* update state */
+	ll_data->ll_state = ST_LL_AWAKE;
+}
+
+static void st_ll_wakeup(struct kim_data_s *ll_data)
+{
+	if (likely(ll_data->ll_state != ST_LL_AWAKE)) {
+		send_ll_cmd(ll_data, LL_WAKE_UP_IND);	/* WAKE_IND */
+		ll_data->ll_state = ST_LL_ASLEEP_TO_AWAKE;
+	} else {
+		/* don't send the duplicate wake_indication */
+		pr_err(" Chip already AWAKE ");
+	}
+}
+
+static unsigned long st_ll_sleep_state(struct kim_data_s *ll_data,
+	unsigned char cmd)
+{
+	switch (cmd) {
+	case LL_SLEEP_IND:	/* sleep ind */
+		pr_info("sleep indication recvd");
+		ll_device_want_to_sleep(ll_data);
+		break;
+	case LL_SLEEP_ACK:	/* sleep ack */
+		pr_err("sleep ack rcvd: host shouldn't");
+		break;
+	case LL_WAKE_UP_IND:	/* wake ind */
+		pr_info("wake indication recvd");
+		ll_device_want_to_wakeup(ll_data);
+		break;
+	case LL_WAKE_UP_ACK:	/* wake ack */
+		pr_info("wake ack rcvd");
+		ll_data->ll_state = ST_LL_AWAKE;
+		break;
+	default:
+		pr_err(" unknown input/state ");
+		return -1;
+	}
+	return 0;
+}
+
+void st_int_enqueue_waiting(struct st_data_s *, struct sk_buff_head *);
+
+/**
+ * st_wakeup_ack - internal function for action when wake-up ack
+ *	received
+ */
+static inline void st_wakeup_ack(struct kim_data_s *ll_data,
+	unsigned char cmd)
+{
+	st_int_enqueue_waiting(ll_data->core_data, &ll_data->tx_waitq);
+
+	st_ll_sleep_state(ll_data, (unsigned long)cmd);
+	/* wake up to send the recently copied skbs from waitQ */
+	st_tx_wakeup(ll_data->core_data);
+}
+
+/**********************************************************************/
+/* callbacks for ST Core */
+
+static void ll_enable(void *ll)
+{
+	struct kim_data_s *ll_data = ll;
+	ll_data->ll_state = ST_LL_AWAKE;
+}
+
+static void ll_disable(void *ll)
+{
+	struct kim_data_s *ll_data = ll;
+	ll_data->ll_state = ST_LL_INVALID;
+}
+
+static int ll_process_rx(void *ll, char *ptr)
+{
+	struct kim_data_s *ll_data = ll;
+	int ret = -EINVAL;
+
+	switch(*ptr) {
+	case LL_SLEEP_IND:
+	case LL_SLEEP_ACK:
+	case LL_WAKE_UP_IND:
+		pr_info("PM packet");
+		/* this takes appropriate action based on
+		 * sleep state received --
+		 */
+		st_ll_sleep_state(ll_data, *ptr);
+		ret = 1;
+		break;
+	case LL_WAKE_UP_ACK:
+		pr_info("PM packet");
+		/* wake up ack received */
+		st_wakeup_ack(ll_data, *ptr);
+		ret = 1;
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static int ll_is_awake(void *ll)
+{
+	struct kim_data_s *ll_data = ll;
+	int is_awake = 0;
+
+	if (ll_data->ll_state == ST_LL_AWAKE)
+		is_awake = 1;
+
+	return is_awake;
+}
+
+static int ll_enqueue(void *ll, struct sk_buff *skb)
+{
+	struct kim_data_s *ll_data = ll;
+	int rc = -EINVAL;
+
+	if (ll_data->ll_state != ST_LL_AWAKE_TO_ASLEEP) {
+		skb_queue_tail(&ll_data->tx_waitq, skb);
+		if (ll_data->ll_state == ST_LL_ASLEEP)
+			st_ll_wakeup(ll_data);
+		rc = 0;
+	}
+	return rc;
+}
+
+struct st_ll_ops ti_ll_ops = {
+	.enable = ll_enable,
+	.disable = ll_disable,
+	.process_rx = ll_process_rx,
+	.is_awake = ll_is_awake,
+	.enqueue = ll_enqueue,
+};
+
+/**********************************************************************/
 /* functions called from platform device driver subsystem
  * need to have a relevant platform device entry in the platform's
  * board-*.c file
@@ -656,13 +879,15 @@ static int kim_probe(struct platform_device *pdev)
 	}
 	dev_set_drvdata(&pdev->dev, kim_gdata);

-	status = st_core_init(&kim_gdata->core_data);
+	skb_queue_head_init(&kim_gdata->tx_waitq);
+	/* set state to invalid */
+	kim_gdata->ll_state = ST_LL_INVALID;
+
+	status = st_core_init(&kim_gdata->core_data, &ti_ll_ops, kim_gdata);
 	if (status != 0) {
 		pr_err(" ST core init failed");
 		return -1;
 	}
-	/* refer to itself */
-	kim_gdata->core_data->kim_data = kim_gdata;

 	for (proto = 0; proto < ST_MAX; proto++) {
 		kim_gdata->gpios[proto] = gpios[proto];
@@ -764,6 +989,8 @@ static int kim_remove(struct platform_device *pdev)
 	pr_info("kim: GPIO Freed");
 	debugfs_remove_recursive(kim_debugfs_dir);
 	kim_gdata->kim_pdev = NULL;
+
+	skb_queue_purge(&kim_gdata->tx_waitq);
 	st_core_exit(kim_gdata->core_data);

 	kfree(kim_gdata);
diff --git a/drivers/misc/ti-st/st_ll.c b/drivers/misc/ti-st/st_ll.c
deleted file mode 100644
index 2bda8de..0000000
--- a/drivers/misc/ti-st/st_ll.c
+++ /dev/null
@@ -1,150 +0,0 @@
-/*
- *  Shared Transport driver
- *	HCI-LL module responsible for TI proprietary HCI_LL protocol
- *  Copyright (C) 2009-2010 Texas Instruments
- *  Author: Pavan Savoy <pavan_savoy@ti.com>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 as
- *  published by the Free Software Foundation.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- */
-
-#define pr_fmt(fmt) "(stll) :" fmt
-#include <linux/skbuff.h>
-#include <linux/module.h>
-#include <linux/ti_wilink_st.h>
-
-/**********************************************************************/
-/* internal functions */
-static void send_ll_cmd(struct st_data_s *st_data,
-	unsigned char cmd)
-{
-
-	pr_info("%s: writing %x", __func__, cmd);
-	st_int_write(st_data, &cmd, 1);
-	return;
-}
-
-static void ll_device_want_to_sleep(struct st_data_s *st_data)
-{
-	pr_debug("%s", __func__);
-	/* sanity check */
-	if (st_data->ll_state != ST_LL_AWAKE)
-		pr_err("ERR hcill: ST_LL_GO_TO_SLEEP_IND"
-			  "in state %ld", st_data->ll_state);
-
-	send_ll_cmd(st_data, LL_SLEEP_ACK);
-	/* update state */
-	st_data->ll_state = ST_LL_ASLEEP;
-}
-
-static void ll_device_want_to_wakeup(struct st_data_s *st_data)
-{
-	/* diff actions in diff states */
-	switch (st_data->ll_state) {
-	case ST_LL_ASLEEP:
-		send_ll_cmd(st_data, LL_WAKE_UP_ACK);	/* send wake_ack */
-		break;
-	case ST_LL_ASLEEP_TO_AWAKE:
-		/* duplicate wake_ind */
-		pr_err("duplicate wake_ind while waiting for Wake ack");
-		break;
-	case ST_LL_AWAKE:
-		/* duplicate wake_ind */
-		pr_err("duplicate wake_ind already AWAKE");
-		break;
-	case ST_LL_AWAKE_TO_ASLEEP:
-		/* duplicate wake_ind */
-		pr_err("duplicate wake_ind");
-		break;
-	}
-	/* update state */
-	st_data->ll_state = ST_LL_AWAKE;
-}
-
-/**********************************************************************/
-/* functions invoked by ST Core */
-
-/* called when ST Core wants to
- * enable ST LL */
-void st_ll_enable(struct st_data_s *ll)
-{
-	ll->ll_state = ST_LL_AWAKE;
-}
-
-/* called when ST Core /local module wants to
- * disable ST LL */
-void st_ll_disable(struct st_data_s *ll)
-{
-	ll->ll_state = ST_LL_INVALID;
-}
-
-/* called when ST Core wants to update the state */
-void st_ll_wakeup(struct st_data_s *ll)
-{
-	if (likely(ll->ll_state != ST_LL_AWAKE)) {
-		send_ll_cmd(ll, LL_WAKE_UP_IND);	/* WAKE_IND */
-		ll->ll_state = ST_LL_ASLEEP_TO_AWAKE;
-	} else {
-		/* don't send the duplicate wake_indication */
-		pr_err(" Chip already AWAKE ");
-	}
-}
-
-/* called when ST Core wants the state */
-unsigned long st_ll_getstate(struct st_data_s *ll)
-{
-	pr_debug(" returning state %ld", ll->ll_state);
-	return ll->ll_state;
-}
-
-/* called from ST Core, when a PM related packet arrives */
-unsigned long st_ll_sleep_state(struct st_data_s *st_data,
-	unsigned char cmd)
-{
-	switch (cmd) {
-	case LL_SLEEP_IND:	/* sleep ind */
-		pr_info("sleep indication recvd");
-		ll_device_want_to_sleep(st_data);
-		break;
-	case LL_SLEEP_ACK:	/* sleep ack */
-		pr_err("sleep ack rcvd: host shouldn't");
-		break;
-	case LL_WAKE_UP_IND:	/* wake ind */
-		pr_info("wake indication recvd");
-		ll_device_want_to_wakeup(st_data);
-		break;
-	case LL_WAKE_UP_ACK:	/* wake ack */
-		pr_info("wake ack rcvd");
-		st_data->ll_state = ST_LL_AWAKE;
-		break;
-	default:
-		pr_err(" unknown input/state ");
-		return -1;
-	}
-	return 0;
-}
-
-/* Called from ST CORE to initialize ST LL */
-long st_ll_init(struct st_data_s *ll)
-{
-	/* set state to invalid */
-	ll->ll_state = ST_LL_INVALID;
-	return 0;
-}
-
-/* Called from ST CORE to de-initialize ST LL */
-long st_ll_deinit(struct st_data_s *ll)
-{
-	return 0;
-}
diff --git a/include/linux/ti_wilink_st.h b/include/linux/ti_wilink_st.h
index 4c7be22..4065c8c 100644
--- a/include/linux/ti_wilink_st.h
+++ b/include/linux/ti_wilink_st.h
@@ -93,6 +93,22 @@ extern long st_unregister(enum proto_type);
 #define ST_WAITING_FOR_RESP	4

 /**
+ * struct st_ll_ops - ST low-level power protocol operations
+ * @process_rx: function to process received LL notification
+ * @is_awake: function to get chip internal power state
+ * @enqueue: function to enqueue a packed if the chip is sleeping
+ * @enable: runs the low-level chip init and related actions
+ * disable: runs the low-level chip deinit and related actions
+ */
+struct st_ll_ops {
+	int (*process_rx) (void *, char *);
+	int (*is_awake) (void *);
+	int (*enqueue) (void *, struct sk_buff *);
+	void (*enable) (void *);
+	void (*disable) (void *);
+};
+
+/**
  * struct st_data_s - ST core internal structure
  * @st_state: different states of ST like initializing, registration
  *	in progress, this is mainly used to return relevant err codes
@@ -115,16 +131,12 @@ extern long st_unregister(enum proto_type);
  *	since tty might not call receive when a complete event packet
  *	is received, the states, count and the skb needs to be maintained.
  * @txq: the list of skbs which needs to be sent onto the TTY.
- * @tx_waitq: if the chip is not in AWAKE state, the skbs needs to be queued
- *	up in here, PM(WAKEUP_IND) data needs to be sent and then the skbs
- *	from waitq can be moved onto the txq.
- *	Needs locking too.
  * @lock: the lock to protect skbs, queues, and ST states.
  * @protos_registered: count of the protocols registered, also when 0 the
  *	chip enable gpio can be toggled, and when it changes to 1 the fw
  *	needs to be downloaded to initialize chip side ST.
- * @ll_state: the various PM states the chip can be, the states are notified
- *	to us, when the chip sends relevant PM packets(SLEEP_IND, WAKE_IND).
+ * @ll_ops: pointer to LL operations struct
+ * @ll_data: data provided by the LL implementation for calling back
  * @kim_data: reference to the parent encapsulating structure.
  *
  */
@@ -139,10 +151,10 @@ struct st_data_s {
 	unsigned long rx_state;
 	unsigned long rx_count;
 	struct sk_buff *rx_skb;
-	struct sk_buff_head txq, tx_waitq;
+	struct sk_buff_head txq;
 	spinlock_t lock;
 	unsigned char	protos_registered;
-	unsigned long ll_state;
+	struct st_ll_ops *ll_ops;
 	void *kim_data;
 };

@@ -160,14 +172,12 @@ int st_int_write(struct st_data_s*, const
unsigned char*, int);
  */
 long st_write(struct sk_buff *);

-/* function to be called from ST-LL */
-void st_ll_send_frame(enum proto_type, struct sk_buff *);
-
 /* internal wake up function */
 void st_tx_wakeup(struct st_data_s *st_data);

 /* init, exit entry funcs called from KIM */
-int st_core_init(struct st_data_s **);
+int st_core_init(struct st_data_s **core_data, struct st_ll_ops *ll_ops,
+		void *kim_data);
 void st_core_exit(struct st_data_s *);

 /* ask for reference from KIM */
@@ -211,49 +221,6 @@ struct chip_version {
 };

 /**
- * struct kim_data_s - the KIM internal data, embedded as the
- *	platform's drv data. One for each ST device in the system.
- * @uim_pid: KIM needs to communicate with UIM to request to install
- *	the ldisc by opening UART when protocol drivers register.
- * @kim_pdev: the platform device added in one of the board-XX.c file
- *	in arch/XX/ directory, 1 for each ST device.
- * @kim_rcvd: completion handler to notify when data was received,
- *	mainly used during fw download, which involves multiple send/wait
- *	for each of the HCI-VS commands.
- * @ldisc_installed: completion handler to notify that the UIM accepted
- *	the request to install ldisc, notify from tty_open which suggests
- *	the ldisc was properly installed.
- * @resp_buffer: data buffer for the .bts fw file name.
- * @fw_entry: firmware class struct to request/release the fw.
- * @gpios: the list of core/chip enable gpios for BT, FM and GPS cores.
- * @rx_state: the rx state for kim's receive func during fw download.
- * @rx_count: the rx count for the kim's receive func during fw download.
- * @rx_skb: all of fw data might not come at once, and hence data storage for
- *	whole of the fw response, only HCI_EVENTs and hence diff from ST's
- *	response.
- * @rfkill: rfkill data for each of the cores to be registered with rfkill.
- * @rf_protos: proto types of the data registered with rfkill sub-system.
- * @core_data: ST core's data, which mainly is the tty's disc_data
- * @version: chip version available via a sysfs entry.
- *
- */
-struct kim_data_s {
-	long uim_pid;
-	struct platform_device *kim_pdev;
-	struct completion kim_rcvd, ldisc_installed;
-	char resp_buffer[30];
-	const struct firmware *fw_entry;
-	long gpios[ST_MAX];
-	unsigned long rx_state;
-	unsigned long rx_count;
-	struct sk_buff *rx_skb;
-	struct rfkill *rfkill[ST_MAX];
-	enum proto_type rf_protos[ST_MAX];
-	struct st_data_s *core_data;
-	struct chip_version version;
-};
-
-/**
  * functions called when 1 of the protocol drivers gets
  * registered, these need to communicate with UIM to request
  * ldisc installed, read chip_version, download relevant fw
@@ -358,25 +325,6 @@ struct hci_command {
 #define LL_WAKE_UP_IND	0x32
 #define LL_WAKE_UP_ACK	0x33

-/* initialize and de-init ST LL */
-long st_ll_init(struct st_data_s *);
-long st_ll_deinit(struct st_data_s *);
-
-/**
- * enable/disable ST LL along with KIM start/stop
- * called by ST Core
- */
-void st_ll_enable(struct st_data_s *);
-void st_ll_disable(struct st_data_s *);
-
-/**
- * various funcs used by ST core to set/get the various PM states
- * of the chip.
- */
-unsigned long st_ll_getstate(struct st_data_s *);
-unsigned long st_ll_sleep_state(struct st_data_s *, unsigned char);
-void st_ll_wakeup(struct st_data_s *);
-
 /*
  * header information used by st_core.c for FM and GPS
  * packet parsing, the bluetooth headers are already available
