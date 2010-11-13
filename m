Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0KMLfs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 06:35:48 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:32809 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab0KMLfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 06:35:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BWp6Ov2vpPdXXJeSQZkNNf4T/AAQ9BpOOcFCyfQAZKQIv6c0SrCJztwIC4JeI4mUut
         bXJggINJmWzCvzpySKuQzeSMF9dOHJlaQ/TKZsGUwLU1xaHYa2govRlV4EGokm2cLZwc
         mLqWC1sGGQnQgNgcBVkOZwavOf0XFdxgE8p8M=
MIME-Version: 1.0
In-Reply-To: <19F8576C6E063C45BE387C64729E739404A9F4CF11@dbde02.ent.ti.com>
References: <AANLkTikLJyr6PREZX-OwOBwMK8uTC2YEu-KHHy0MYFJJ@mail.gmail.com>
	<19F8576C6E063C45BE387C64729E739404A9F4CF11@dbde02.ent.ti.com>
Date: Sat, 13 Nov 2010 12:35:46 +0100
Message-ID: <AANLkTikRh4CPY8pdCA=MvXmXgyS-LPk1y2QYrNBQvLuf@mail.gmail.com>
Subject: Re: shared transport: only for TI chips?
From: Vitaly Wool <vitalywool@gmail.com>
To: "Savoy, Pavan" <pavan_savoy@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavan,

On Sat, Nov 13, 2010 at 8:42 AM, Savoy, Pavan <pavan_savoy@ti.com> wrote:
> certainly Vitaly.
> I would welcome any ideas which can make it more generic, provided there is no drastic change in the way we do stuff currently (as in say firmware download from kernel space, LL handling etc..).
>
> I did see similar code for on such MFD device from ST-ericsson for a similar BT, FM GPS based device and wanted to somehow make work TI-ST work for it, unfortunately didn't hear encouraging words from developers from that driver.
>
> So, yes, I welcome ideas and let's see how best we can implement them... shoot them away...

how about this as a starter (it will move the LL specifics out of st_core):

diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index f9aad06..1cc41d4 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -54,6 +54,53 @@ bool is_protocol_list_empty(void)
 }
 #endif

+/*
+ * register low-level proto
+ */
+int st_register_ll_proto(struct st_data_s *st_gdata,
+			struct st_ll_ops *ll_ops,
+			void *ll_data)
+{
+	int rc = 0;
+
+	if (!st_gdata)
+		rc = -EINVAL;
+	else if (st_gdata->ll_ops)
+		rc = -EBUSY;
+	else {
+		st_gdata->ll_ops = ll_ops;
+		st_gdata->ll_data = ll_data;
+	}
+	return rc;
+}
+
+/*
+ * register low-level proto
+ */
+void st_unregister_ll_proto(struct st_data_s *st_gdata)
+{
+	st_gdata->ll_ops = NULL;
+	st_gdata->ll_data = NULL;
+}
+
+static inline int st_ll_process_rx(struct st_data_s *st_data, char *p)
+{
+	return st_data->ll_ops->process_rx ?
+		st_data->ll_ops->process_rx(st_data->ll_data, p) : -EINVAL;
+}
+
+static inline int st_ll_is_awake(struct st_data_s *st_data)
+{
+	return st_data->ll_ops->is_awake ?
+		st_data->ll_ops->is_awake(st_data->ll_data) : 1;
+}
+
+static inline int st_ll_queue(struct st_data_s *st_data, struct sk_buff *skb)
+{
+	return st_data->ll_ops->enqueue ?
+		st_data->ll_ops->enqueue(st_data->ll_data, skb) : -EINVAL;
+}
+
 /* can be called in from
  * -- KIM (during fw download)
  * -- ST Core (during st_write)
@@ -172,31 +219,6 @@ static inline int st_check_data_len(struct
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
@@ -213,7 +235,7 @@ void st_int_recv(void *disc_data,
 	struct hci_sco_hdr *sh;
 	struct fm_event_hdr *fm;
 	struct gps_event_hdr *gps;
-	int len = 0, type = 0, dlen = 0;
+	int len = 0, type = 0, dlen = 0, shift = 0;
 	static enum proto_type protoid = ST_MAX;
 	struct st_data_s *st_gdata = (struct st_data_s *)disc_data;

@@ -353,29 +375,16 @@ void st_int_recv(void *disc_data,
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
@@ -450,12 +459,9 @@ struct sk_buff *st_int_dequeue(struct st_data_s *st_gdata)

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
@@ -464,35 +470,41 @@ void st_int_enqueue(struct st_data_s *st_gdata,
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
@@ -606,7 +618,7 @@ long st_register(struct st_proto_s *new_proto)
 		spin_unlock_irqrestore(&st_gdata->lock, flags);

 		/* enable the ST LL - to set default chip state */
-		st_ll_enable(st_gdata);
+		st_ll_enable(st_gdata->ll_data);
 		/* this may take a while to complete
 		 * since it involves BT fw download
 		 */
@@ -732,7 +744,7 @@ long st_unregister(enum proto_type type)
 		/* all protocols now unregistered */
 		st_kim_stop(st_gdata->kim_data);
 		/* disable ST LL */
-		st_ll_disable(st_gdata);
+		st_ll_disable(st_gdata->ll_data);
 	}
 	return err;
 }
@@ -853,9 +865,8 @@ static void st_tty_close(struct tty_struct *tty)
 	tty_driver_flush_buffer(tty);

 	spin_lock_irqsave(&st_gdata->lock, flags);
-	/* empty out txq and tx_waitq */
+	/* empty out txq */
 	skb_queue_purge(&st_gdata->txq);
-	skb_queue_purge(&st_gdata->tx_waitq);
 	/* reset the TTY Rx states of ST */
 	st_gdata->rx_count = 0;
 	st_gdata->rx_state = ST_W4_PACKET_TYPE;
@@ -944,11 +955,10 @@ int st_core_init(struct st_data_s **core_data)
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
@@ -977,7 +987,6 @@ void st_core_exit(struct st_data_s *st_gdata)
 	if (st_gdata != NULL) {
 		/* Free ST Tx Qs and skbs */
 		skb_queue_purge(&st_gdata->txq);
-		skb_queue_purge(&st_gdata->tx_waitq);
 		kfree_skb(st_gdata->rx_skb);
 		kfree_skb(st_gdata->tx_skb);
 		/* TTY ldisc cleanup */
diff --git a/drivers/misc/ti-st/st_ll.c b/drivers/misc/ti-st/st_ll.c
index 2bda8de..95d0b62 100644
--- a/drivers/misc/ti-st/st_ll.c
+++ b/drivers/misc/ti-st/st_ll.c
@@ -24,36 +24,42 @@
 #include <linux/module.h>
 #include <linux/ti_wilink_st.h>

+struct ti_ll_data {
+	struct sk_buff_head tx_waitq;
+	struct st_data_s *st_data;
+	long ll_state;
+};
+
+static struct ti_ll_data ti_ll_data;
+
 /**********************************************************************/
 /* internal functions */
-static void send_ll_cmd(struct st_data_s *st_data,
-	unsigned char cmd)
+static void send_ll_cmd(struct ti_ll_data *ll_data, unsigned char cmd)
 {
-
 	pr_info("%s: writing %x", __func__, cmd);
-	st_int_write(st_data, &cmd, 1);
+	st_int_write(ll_data->st_data, &cmd, 1);
 	return;
 }

-static void ll_device_want_to_sleep(struct st_data_s *st_data)
+static void ll_device_want_to_sleep(struct ti_ll_data *ll_data)
 {
 	pr_debug("%s", __func__);
 	/* sanity check */
-	if (st_data->ll_state != ST_LL_AWAKE)
-		pr_err("ERR hcill: ST_LL_GO_TO_SLEEP_IND"
-			  "in state %ld", st_data->ll_state);
+	if (ll_data->ll_state != ST_LL_AWAKE)
+		pr_err("ERR hcill: ST_LL_GO_TO_SLEEP_IND in state %ld",
+			ll_data->ll_state);

-	send_ll_cmd(st_data, LL_SLEEP_ACK);
+	send_ll_cmd(ll_data, LL_SLEEP_ACK);
 	/* update state */
-	st_data->ll_state = ST_LL_ASLEEP;
+	ll_data->ll_state = ST_LL_ASLEEP;
 }

-static void ll_device_want_to_wakeup(struct st_data_s *st_data)
+static void ll_device_want_to_wakeup(struct ti_ll_data *ll_data)
 {
 	/* diff actions in diff states */
-	switch (st_data->ll_state) {
+	switch (ll_data->ll_state) {
 	case ST_LL_ASLEEP:
-		send_ll_cmd(st_data, LL_WAKE_UP_ACK);	/* send wake_ack */
+		send_ll_cmd(ll_data, LL_WAKE_UP_ACK);	/* send wake_ack */
 		break;
 	case ST_LL_ASLEEP_TO_AWAKE:
 		/* duplicate wake_ind */
@@ -69,64 +75,38 @@ static void ll_device_want_to_wakeup(struct
st_data_s *st_data)
 		break;
 	}
 	/* update state */
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
+	ll_data->ll_state = ST_LL_AWAKE;
 }

-/* called when ST Core wants to update the state */
-void st_ll_wakeup(struct st_data_s *ll)
+static void st_ll_wakeup(struct ti_ll_data *ll_data)
 {
-	if (likely(ll->ll_state != ST_LL_AWAKE)) {
-		send_ll_cmd(ll, LL_WAKE_UP_IND);	/* WAKE_IND */
-		ll->ll_state = ST_LL_ASLEEP_TO_AWAKE;
+	if (likely(ll_data->ll_state != ST_LL_AWAKE)) {
+		send_ll_cmd(ll_data, LL_WAKE_UP_IND);	/* WAKE_IND */
+		ll_data->ll_state = ST_LL_ASLEEP_TO_AWAKE;
 	} else {
 		/* don't send the duplicate wake_indication */
 		pr_err(" Chip already AWAKE ");
 	}
 }

-/* called when ST Core wants the state */
-unsigned long st_ll_getstate(struct st_data_s *ll)
-{
-	pr_debug(" returning state %ld", ll->ll_state);
-	return ll->ll_state;
-}
-
-/* called from ST Core, when a PM related packet arrives */
-unsigned long st_ll_sleep_state(struct st_data_s *st_data,
+static unsigned long st_ll_sleep_state(struct ti_ll_data *ll_data,
 	unsigned char cmd)
 {
 	switch (cmd) {
 	case LL_SLEEP_IND:	/* sleep ind */
 		pr_info("sleep indication recvd");
-		ll_device_want_to_sleep(st_data);
+		ll_device_want_to_sleep(ll_data);
 		break;
 	case LL_SLEEP_ACK:	/* sleep ack */
 		pr_err("sleep ack rcvd: host shouldn't");
 		break;
 	case LL_WAKE_UP_IND:	/* wake ind */
 		pr_info("wake indication recvd");
-		ll_device_want_to_wakeup(st_data);
+		ll_device_want_to_wakeup(ll_data);
 		break;
 	case LL_WAKE_UP_ACK:	/* wake ack */
 		pr_info("wake ack rcvd");
-		st_data->ll_state = ST_LL_AWAKE;
+		ll_data->ll_state = ST_LL_AWAKE;
 		break;
 	default:
 		pr_err(" unknown input/state ");
@@ -135,16 +115,116 @@ unsigned long st_ll_sleep_state(struct
st_data_s *st_data,
 	return 0;
 }

+void st_int_enqueue_waiting(struct st_data_s *, struct sk_buff_head *);
+
+/**
+ * st_wakeup_ack - internal function for action when wake-up ack
+ *	received
+ */
+static inline void st_wakeup_ack(struct ti_ll_data *ll_data,
+	unsigned char cmd)
+{
+	st_int_enqueue_waiting(ll_data->st_data, &ll_data->tx_waitq);
+
+	st_ll_sleep_state(ll_data, (unsigned long)cmd);
+	/* wake up to send the recently copied skbs from waitQ */
+	st_tx_wakeup(ll_data->st_data);
+}
+
+/**********************************************************************/
+/* functions invoked by ST Core */
+
+/* called when ST Core wants to
+ * enable ST LL */
+void st_ll_enable(void *ll)
+{
+	struct ti_ll_data *ll_data = ll;
+	ll_data->ll_state = ST_LL_AWAKE;
+}
+
+/* called when ST Core /local module wants to
+ * disable ST LL */
+void st_ll_disable(void *ll)
+{
+	struct ti_ll_data *ll_data = ll;
+	ll_data->ll_state = ST_LL_INVALID;
+}
+
+/**********************************************************************/
+/* callbacks for ST Core */
+static int ll_process_rx(void *ll, char *ptr)
+{
+	struct ti_ll_data *ll_data = ll;
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
+	struct ti_ll_data *ll_data = ll;
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
+	struct ti_ll_data *ll_data = ll;
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
+	.process_rx = ll_process_rx,
+	.is_awake = ll_is_awake,
+	.enqueue = ll_enqueue,
+};
+
 /* Called from ST CORE to initialize ST LL */
-long st_ll_init(struct st_data_s *ll)
+long st_ll_init(struct st_data_s *st)
 {
+	skb_queue_head_init(&ti_ll_data.tx_waitq);
 	/* set state to invalid */
-	ll->ll_state = ST_LL_INVALID;
-	return 0;
+	ti_ll_data.ll_state = ST_LL_INVALID;
+	return st_register_ll_proto(st, &ti_ll_ops, &ti_ll_data);
 }

 /* Called from ST CORE to de-initialize ST LL */
-long st_ll_deinit(struct st_data_s *ll)
+long st_ll_deinit(struct st_data_s *st)
 {
+	skb_queue_purge(&ti_ll_data.tx_waitq);
+	st_unregister_ll_proto(st);
 	return 0;
 }
diff --git a/include/linux/ti_wilink_st.h b/include/linux/ti_wilink_st.h
index 4c7be22..fdfca11 100644
--- a/include/linux/ti_wilink_st.h
+++ b/include/linux/ti_wilink_st.h
@@ -93,6 +93,18 @@ extern long st_unregister(enum proto_type);
 #define ST_WAITING_FOR_RESP	4

 /**
+ * struct st_ll_ops - ST low-level power protocol operations
+ * @ll_process_rx: function to process received LL notification
+ * @ll_is_awake: function to get chip internal power state
+ * @ll_enqueue: function to enqueue a packed once chip is sleeping
+ */
+struct st_ll_ops {
+	int (*process_rx) (void *, char *);
+	int (*is_awake) (void *);
+	int (*enqueue) (void *, struct sk_buff *);
+};
+
+/**
  * struct st_data_s - ST core internal structure
  * @st_state: different states of ST like initializing, registration
  *	in progress, this is mainly used to return relevant err codes
@@ -115,16 +127,12 @@ extern long st_unregister(enum proto_type);
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
@@ -139,14 +147,29 @@ struct st_data_s {
 	unsigned long rx_state;
 	unsigned long rx_count;
 	struct sk_buff *rx_skb;
-	struct sk_buff_head txq, tx_waitq;
+	struct sk_buff_head txq;
 	spinlock_t lock;
 	unsigned char	protos_registered;
-	unsigned long ll_state;
+	struct st_ll_ops *ll_ops;
+	void *ll_data;
 	void *kim_data;
 };

 /**
+ * st_register_ll_proto -
+ *
+ * register the low level proto
+ */
+int st_register_ll_proto(struct st_data_s *, struct st_ll_ops *, void *);
+
+/**
+ * st_unregister_ll_proto -
+ *
+ * unregister the low level proto
+ */
+void st_unregister_ll_proto(struct st_data_s *);
+
+/**
  * st_int_write -
  * point this to tty->driver->write or tty->ops->write
  * depending upon the kernel version
@@ -160,9 +183,6 @@ int st_int_write(struct st_data_s*, const unsigned
char*, int);
  */
 long st_write(struct sk_buff *);

-/* function to be called from ST-LL */
-void st_ll_send_frame(enum proto_type, struct sk_buff *);
-
 /* internal wake up function */
 void st_tx_wakeup(struct st_data_s *st_data);

@@ -366,16 +386,8 @@ long st_ll_deinit(struct st_data_s *);
  * enable/disable ST LL along with KIM start/stop
  * called by ST Core
  */
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
+void st_ll_enable(void *);
+void st_ll_disable(void *);

 /*
  * header information used by st_core.c for FM and GPS
