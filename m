Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930Ab0GVKcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 06:32:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34179 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476Ab0GVKcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 06:32:23 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        pavan_savoy@sify.com, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 2/3] drivers:staging:ti-st: cleanup code comments
Date: Thu, 22 Jul 2010 05:32:06 -0500
Message-Id: <1279794727-7669-3-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1279794727-7669-2-git-send-email-pavan_savoy@ti.com>
References: <1279794727-7669-1-git-send-email-pavan_savoy@ti.com>
 <1279794727-7669-2-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

cleanup the code commenting in the headers/structures,
also cleanup few inline commenting in the function

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/staging/ti-st/st.h      |   44 +++++++++++------------
 drivers/staging/ti-st/st_core.c |   54 ++++++++++++++-------------
 drivers/staging/ti-st/st_core.h |   74 ++++++++++++++++++++++++++------------
 drivers/staging/ti-st/st_kim.c  |   52 ++++++++++++++++++---------
 drivers/staging/ti-st/st_kim.h  |   77 +++++++++++++++++++++++++--------------
 drivers/staging/ti-st/st_ll.h   |    9 ++++-
 6 files changed, 193 insertions(+), 117 deletions(-)

diff --git a/drivers/staging/ti-st/st.h b/drivers/staging/ti-st/st.h
index c4288aa..c96c01e 100644
--- a/drivers/staging/ti-st/st.h
+++ b/drivers/staging/ti-st/st.h
@@ -24,24 +24,24 @@
 #define ST_H
 
 #include <linux/skbuff.h>
-/*
- * st.h
- */
 
 /* TODO:
  * Move the following to tty.h upon acceptance
  */
 #define N_TI_WL	20	/* Ldisc for TI's WL BT, FM, GPS combo chips */
 
-/* some gpios have active high, others like fm have
- * active low
+/**
+ * enum kim_gpio_state - Few protocols such as FM have ACTIVE LOW
+ *	gpio states for their chip/core enable gpios
  */
 enum kim_gpio_state {
 	KIM_GPIO_INACTIVE,
 	KIM_GPIO_ACTIVE,
 };
-/*
- * the list of protocols on chip
+
+/**
+ * enum proto-type - The protocol on WiLink chips which share a
+ *	common physical interface like UART.
  */
 enum proto_type {
 	ST_BT,
@@ -50,28 +50,26 @@ enum proto_type {
 	ST_MAX,
 };
 
-/* per protocol structure
- * for BT/FM and GPS
+/**
+ * struct st_proto_s - Per Protocol structure from BT/FM/GPS to ST
+ * @type: type of the protocol being registered among the
+ *	available proto_type(BT, FM, GPS the protocol which share TTY).
+ * @recv: the receiver callback pointing to a function in the
+ *	protocol drivers called by the ST driver upon receiving
+ *	relevant data.
+ * @match_packet: reserved for future use, to make ST more generic
+ * @reg_complete_cb: callback handler pointing to a function in protocol
+ *	handler called by ST when the pending registrations are complete.
+ *	The registrations are marked pending, in situations when fw
+ *	download is in progress.
+ * @write: pointer to function in ST provided to protocol drivers from ST,
+ *	to be made use when protocol drivers have data to send to TTY.
  */
 struct st_proto_s {
 	enum proto_type type;
-/*
- * to be called by ST when data arrives
- */
 	long (*recv) (struct sk_buff *);
-/*
- * for future use, logic now to be in ST
- */
 	unsigned char (*match_packet) (const unsigned char *data);
-/*
- * subsequent registration return PENDING,
- * signalled complete by this callback function
- */
 	void (*reg_complete_cb) (char data);
-/*
- * write function, sent in as NULL and to be returned to
- * protocol drivers
- */
 	long (*write) (struct sk_buff *skb);
 };
 
diff --git a/drivers/staging/ti-st/st_core.c b/drivers/staging/ti-st/st_core.c
index 7806843..b20ab73 100644
--- a/drivers/staging/ti-st/st_core.c
+++ b/drivers/staging/ti-st/st_core.c
@@ -72,6 +72,7 @@ bool is_protocol_list_empty(void)
 	return ST_EMPTY;
 }
 #endif
+
 /* can be called in from
  * -- KIM (during fw download)
  * -- ST Core (during st_write)
@@ -131,7 +132,8 @@ void st_send_frame(enum proto_type protoid, struct st_data_s *st_gdata)
 	return;
 }
 
-/*
+/**
+ * st_reg_complete -
  * to call registration complete callbacks
  * of all protocol stack drivers
  */
@@ -185,8 +187,9 @@ static inline int st_check_data_len(struct st_data_s *st_gdata,
 	return 0;
 }
 
-/* internal function for action when wake-up ack
- * received
+/**
+ * st_wakeup_ack - internal function for action when wake-up ack
+ *	received
  */
 static inline void st_wakeup_ack(struct st_data_s *st_gdata,
 	unsigned char cmd)
@@ -209,9 +212,13 @@ static inline void st_wakeup_ack(struct st_data_s *st_gdata,
 	st_tx_wakeup(st_gdata);
 }
 
-/* Decodes received RAW data and forwards to corresponding
- * client drivers (Bluetooth,FM,GPS..etc).
- *
+/**
+ * st_int_recv - ST's internal receive function.
+ *	Decodes received RAW data and forwards to corresponding
+ *	client drivers (Bluetooth,FM,GPS..etc).
+ *	This can receive various types of packets,
+ *	HCI-Events, ACL, SCO, 4 types of HCI-LL PM packets
+ *	CH-8 packets from FM, CH-9 packets from GPS cores.
  */
 void st_int_recv(void *disc_data,
 	const unsigned char *data, long count)
@@ -438,41 +445,39 @@ void st_int_recv(void *disc_data,
 	return;
 }
 
-/* internal de-Q function
- * -- return previous in-completely written skb
- *  or return the skb in the txQ
+/**
+ * st_int_dequeue - internal de-Q function.
+ *	If the previous data set was not written
+ *	completely, return that skb which has the pending data.
+ *	In normal cases, return top of txq.
  */
 struct sk_buff *st_int_dequeue(struct st_data_s *st_gdata)
 {
 	struct sk_buff *returning_skb;
 
 	pr_debug("%s", __func__);
-	/* if the previous skb wasn't written completely
-	 */
 	if (st_gdata->tx_skb != NULL) {
 		returning_skb = st_gdata->tx_skb;
 		st_gdata->tx_skb = NULL;
 		return returning_skb;
 	}
-
-	/* de-Q from the txQ always if previous write is complete */
 	return skb_dequeue(&st_gdata->txq);
 }
 
-/* internal Q-ing function
- * will either Q the skb to txq or the tx_waitq
- * depending on the ST LL state
- *
- * lock the whole func - since ll_getstate and Q-ing should happen
- * in one-shot
+/**
+ * st_int_enqueue - internal Q-ing function.
+ *	Will either Q the skb to txq or the tx_waitq
+ *	depending on the ST LL state.
+ *	If the chip is asleep, then Q it onto waitq and
+ *	wakeup the chip.
+ *	txq and waitq needs protection since the other contexts
+ *	may be sending data, waking up chip.
  */
 void st_int_enqueue(struct st_data_s *st_gdata, struct sk_buff *skb)
 {
 	unsigned long flags = 0;
 
 	pr_debug("%s", __func__);
-	/* this function can be invoked in more then one context.
-	 * so have a lock */
 	spin_lock_irqsave(&st_gdata->lock, flags);
 
 	switch (st_ll_getstate(st_gdata)) {
@@ -483,16 +488,12 @@ void st_int_enqueue(struct st_data_s *st_gdata, struct sk_buff *skb)
 	case ST_LL_ASLEEP_TO_AWAKE:
 		skb_queue_tail(&st_gdata->tx_waitq, skb);
 		break;
-	case ST_LL_AWAKE_TO_ASLEEP:	/* host cannot be in this state */
+	case ST_LL_AWAKE_TO_ASLEEP:
 		pr_err("ST LL is illegal state(%ld),"
 			   "purging received skb.", st_ll_getstate(st_gdata));
 		kfree_skb(skb);
 		break;
-
 	case ST_LL_ASLEEP:
-		/* call a function of ST LL to put data
-		 * in tx_waitQ and wake_ind in txQ
-		 */
 		skb_queue_tail(&st_gdata->tx_waitq, skb);
 		st_ll_wakeup(st_gdata);
 		break;
@@ -502,6 +503,7 @@ void st_int_enqueue(struct st_data_s *st_gdata, struct sk_buff *skb)
 		kfree_skb(skb);
 		break;
 	}
+
 	spin_unlock_irqrestore(&st_gdata->lock, flags);
 	pr_debug("done %s", __func__);
 	return;
diff --git a/drivers/staging/ti-st/st_core.h b/drivers/staging/ti-st/st_core.h
index 53369f2..e0c32d1 100644
--- a/drivers/staging/ti-st/st_core.h
+++ b/drivers/staging/ti-st/st_core.h
@@ -36,59 +36,87 @@
 #define ST_REG_PENDING		3
 #define ST_WAITING_FOR_RESP	4
 
-/*
- * local data required for ST/KIM/ST-HCI-LL
+/**
+ * struct st_data_s - ST core internal structure
+ * @st_state: different states of ST like initializing, registration
+ *	in progress, this is mainly used to return relevant err codes
+ *	when protocol drivers are registering. It is also used to track
+ *	the recv function, as in during fw download only HCI events
+ *	can occur , where as during other times other events CH8, CH9
+ *	can occur.
+ * @tty: tty provided by the TTY core for line disciplines.
+ * @ldisc_ops: the procedures that this line discipline registers with TTY.
+ * @tx_skb: If for some reason the tty's write returns lesser bytes written
+ *	then to maintain the rest of data to be written on next instance.
+ *	This needs to be protected, hence the lock inside wakeup func.
+ * @tx_state: if the data is being written onto the TTY and protocol driver
+ *	wants to send more, queue up data and mark that there is
+ *	more data to send.
+ * @list: the list of protocols registered, only MAX can exist, one protocol
+ *	can register only once.
+ * @rx_state: states to be maintained inside st's tty receive
+ * @rx_count: count to be maintained inside st's tty receieve
+ * @rx_skb: the skb where all data for a protocol gets accumulated,
+ *	since tty might not call receive when a complete event packet
+ *	is received, the states, count and the skb needs to be maintained.
+ * @txq: the list of skbs which needs to be sent onto the TTY.
+ * @tx_waitq: if the chip is not in AWAKE state, the skbs needs to be queued
+ *	up in here, PM(WAKEUP_IND) data needs to be sent and then the skbs
+ *	from waitq can be moved onto the txq.
+ *	Needs locking too.
+ * @lock: the lock to protect skbs, queues, and ST states.
+ * @protos_registered: count of the protocols registered, also when 0 the
+ *	chip enable gpio can be toggled, and when it changes to 1 the fw
+ *	needs to be downloaded to initialize chip side ST.
+ * @ll_state: the various PM states the chip can be, the states are notified
+ *	to us, when the chip sends relevant PM packets(SLEEP_IND, WAKE_IND).
+ * @kim_data: reference to the parent encapsulating structure.
+ *
  */
 struct st_data_s {
 	unsigned long st_state;
-/*
- * an instance of tty_struct & ldisc ops to move around
- */
 	struct tty_struct *tty;
 	struct tty_ldisc_ops *ldisc_ops;
-/*
- * the tx skb -
- * if the skb is already dequeued and the tty failed to write the same
- * maintain the skb to write in the next transaction
- */
 	struct sk_buff *tx_skb;
 #define ST_TX_SENDING	1
 #define ST_TX_WAKEUP	2
 	unsigned long tx_state;
-/*
- * list of protocol registered
- */
 	struct st_proto_s *list[ST_MAX];
-/*
- * lock
- */
 	unsigned long rx_state;
 	unsigned long rx_count;
 	struct sk_buff *rx_skb;
 	struct sk_buff_head txq, tx_waitq;
-	spinlock_t lock;	/* ST LL state lock  */
+	spinlock_t lock;
 	unsigned char	protos_registered;
-	unsigned long ll_state;	/* ST LL power state */
-/* device reference to kim data */
+	unsigned long ll_state;
 	void *kim_data;
 };
 
-/* point this to tty->driver->write or tty->ops->write
+/**
+ * st_int_write -
+ * point this to tty->driver->write or tty->ops->write
  * depending upon the kernel version
  */
 int st_int_write(struct st_data_s*, const unsigned char*, int);
-/* internal write function, passed onto protocol drivers
+
+/**
+ * st_write -
+ * internal write function, passed onto protocol drivers
  * via the write function ptr of protocol struct
  */
 long st_write(struct sk_buff *);
-/* function to be called from ST-LL
- */
+
+/* function to be called from ST-LL */
 void st_ll_send_frame(enum proto_type, struct sk_buff *);
+
 /* internal wake up function */
 void st_tx_wakeup(struct st_data_s *st_data);
 
+/* init, exit entry funcs called from KIM */
 int st_core_init(struct st_data_s **);
 void st_core_exit(struct st_data_s *);
+
+/* ask for reference from KIM */
 void st_kim_ref(struct st_data_s **);
 
 #define GPS_STUB_TEST
diff --git a/drivers/staging/ti-st/st_kim.c b/drivers/staging/ti-st/st_kim.c
index 5ab69d1..7e34e4d 100644
--- a/drivers/staging/ti-st/st_kim.c
+++ b/drivers/staging/ti-st/st_kim.c
@@ -104,10 +104,11 @@ const unsigned char *protocol_names[] = {
 /**********************************************************************/
 /* internal functions */
 
-/*
- * function to return whether the firmware response was proper
- * in case of error don't complete so that waiting for proper
- * response times out
+/**
+ * validate_firmware_response -
+ *	function to return whether the firmware response was proper
+ *	in case of error don't complete so that waiting for proper
+ *	response times out
  */
 void validate_firmware_response(struct kim_data_s *kim_gdata)
 {
@@ -158,10 +159,11 @@ static inline int kim_check_data_len(struct kim_data_s *kim_gdata, int len)
 	return 0;
 }
 
-/* receive function called during firmware download
- * - firmware download responses on different UART drivers
- *   have been observed to come in bursts of different
- *   tty_receive and hence the logic
+/**
+ * kim_int_recv - receive function called during firmware download
+ *	firmware download responses on different UART drivers
+ *	have been observed to come in bursts of different
+ *	tty_receive and hence the logic
  */
 void kim_int_recv(struct kim_data_s *kim_gdata,
 	const unsigned char *data, long count)
@@ -220,7 +222,7 @@ void kim_int_recv(struct kim_data_s *kim_gdata,
 			ptr++;
 			count--;
 			continue;
-		}		/* end of switch *ptr */
+		}
 		ptr++;
 		count--;
 		kim_gdata->rx_skb =
@@ -230,9 +232,9 @@ void kim_int_recv(struct kim_data_s *kim_gdata,
 			kim_gdata->rx_state = ST_W4_PACKET_TYPE;
 			kim_gdata->rx_count = 0;
 			return;
-		} /* not necessary in this case */
+		}
 		bt_cb(kim_gdata->rx_skb)->pkt_type = type;
-	}			/* end of while count */
+	}
 	pr_info("done %s", __func__);
 	return;
 }
@@ -278,8 +280,10 @@ static long read_local_version(struct kim_data_s *kim_gdata, char *bts_scr_name)
 	return 0;
 }
 
-/* internal function which parses through the .bts firmware script file
- * intreprets SEND, DELAY actions only as of now
+/**
+ * download_firmware -
+ *	internal function which parses through the .bts firmware
+ *	script file intreprets SEND, DELAY actions only as of now
  */
 static long download_firmware(struct kim_data_s *kim_gdata)
 {
@@ -445,8 +449,13 @@ void st_kim_complete(void *kim_data)
 	complete(&kim_gdata->ldisc_installed);
 }
 
-/* called from ST Core upon 1st registration
-*/
+/**
+ * st_kim_start - called from ST Core upon 1st registration
+ *	This involves toggling the chip enable gpio, reading
+ *	the firmware version from chip, forming the fw file name
+ *	based on the chip version, requesting the fw, parsing it
+ *	and perform download(send/recv).
+ */
 long st_kim_start(void *kim_data)
 {
 	long err = 0;
@@ -501,8 +510,10 @@ long st_kim_start(void *kim_data)
 	return err;
 }
 
-/* called from ST Core, on the last un-registration
-*/
+/**
+ * st_kim_stop - called from ST Core, on the last un-registration
+ *	toggle low the chip enable gpio
+ */
 long st_kim_stop(void *kim_data)
 {
 	long err = 0;
@@ -607,6 +618,13 @@ static int kim_toggle_radio(void *data, bool blocked)
 	return 0;
 }
 
+/**
+ * st_kim_ref - reference the core's data
+ *	This references the per-ST platform device in the arch/xx/
+ *	board-xx.c file.
+ *	This would enable multiple such platform devices to exist
+ *	on a given platform
+ */
 void st_kim_ref(struct st_data_s **core_data)
 {
 	struct platform_device	*pdev;
diff --git a/drivers/staging/ti-st/st_kim.h b/drivers/staging/ti-st/st_kim.h
index d5685f4..225cacd 100644
--- a/drivers/staging/ti-st/st_kim.h
+++ b/drivers/staging/ti-st/st_kim.h
@@ -43,13 +43,9 @@
  * since the self-test for chip takes a while
  */
 #define POR_RETRY_COUNT 5
-/*
- * legacy rfkill support where-in 3 rfkill
- * devices are created for the 3 gpios
- * that ST has requested
- */
 
-/* chip version storage
+/**
+ * struct chip_version - save the chip version
  */
 struct chip_version {
 	unsigned short full;
@@ -58,18 +54,40 @@ struct chip_version {
 	unsigned short maj_ver;
 };
 
-/*
- * header file for ST provided by KIM
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
+ *
  */
 struct kim_data_s {
 	long uim_pid;
 	struct platform_device *kim_pdev;
 	struct completion kim_rcvd, ldisc_installed;
-	/* MAX len of the .bts firmware script name */
 	char resp_buffer[30];
 	const struct firmware *fw_entry;
 	long gpios[ST_MAX];
-/* used by kim_int_recv to validate fw response */
 	unsigned long rx_state;
 	unsigned long rx_count;
 	struct sk_buff *rx_skb;
@@ -79,20 +97,17 @@ struct kim_data_s {
 	struct chip_version version;
 };
 
+/**
+ * functions called when 1 of the protocol drivers gets
+ * registered, these need to communicate with UIM to request
+ * ldisc installed, read chip_version, download relevant fw
+ */
 long st_kim_start(void *);
 long st_kim_stop(void *);
-/*
- * called from st_tty_receive to authenticate fw_download
- */
-void st_kim_recv(void *, const unsigned char *, long count);
 
+void st_kim_recv(void *, const unsigned char *, long count);
 void st_kim_chip_toggle(enum proto_type, enum kim_gpio_state);
-
 void st_kim_complete(void *);
-
-/* function called from ST KIM to ST Core, to
- * list out the protocols registered
- */
 void kim_st_list_protocols(struct st_data_s *, char *);
 
 /*
@@ -105,9 +120,13 @@ void kim_st_list_protocols(struct st_data_s *, char *);
 #define ACTION_RUN_SCRIPT       5
 #define ACTION_REMARKS          6
 
-/*
- *  * BRF Firmware header
- *   */
+/**
+ * struct bts_header - the fw file is NOT binary which can
+ *	be sent onto TTY as is. The .bts is more a script
+ *	file which has different types of actions.
+ *	Each such action needs to be parsed by the KIM and
+ *	relevant procedure to be called.
+ */
 struct bts_header {
 	uint32_t magic;
 	uint32_t version;
@@ -115,9 +134,10 @@ struct bts_header {
 	uint8_t actions[0];
 } __attribute__ ((packed));
 
-/*
- *  * BRF Actions structure
- *   */
+/**
+ * struct bts_action - Each .bts action has its own type of
+ *	data.
+ */
 struct bts_action {
 	uint16_t type;
 	uint16_t size;
@@ -143,8 +163,11 @@ struct bts_action_serial {
 	uint32_t flow_control;
 } __attribute__ ((packed));
 
-/* for identifying the change speed HCI VS
- * command
+/**
+ * struct hci_command - the HCI-VS for intrepreting
+ *	the change baud rate of host-side UART, which
+ *	needs to be ignored, since UIM would do that
+ *	when it receives request from KIM for ldisc installation.
  */
 struct hci_command {
 	uint8_t prefix;
diff --git a/drivers/staging/ti-st/st_ll.h b/drivers/staging/ti-st/st_ll.h
index 77dfbf0..e4dfacd 100644
--- a/drivers/staging/ti-st/st_ll.h
+++ b/drivers/staging/ti-st/st_ll.h
@@ -41,6 +41,7 @@
 #define ST_LL_AWAKE_TO_ASLEEP      3
 #define ST_LL_INVALID		   4
 
+/* different PM notifications coming from chip */
 #define LL_SLEEP_IND	0x30
 #define LL_SLEEP_ACK	0x31
 #define LL_WAKE_UP_IND	0x32
@@ -50,13 +51,19 @@
 long st_ll_init(struct st_data_s *);
 long st_ll_deinit(struct st_data_s *);
 
-/* enable/disable ST LL along with KIM start/stop
+/**
+ * enable/disable ST LL along with KIM start/stop
  * called by ST Core
  */
 void st_ll_enable(struct st_data_s *);
 void st_ll_disable(struct st_data_s *);
 
+/**
+ * various funcs used by ST core to set/get the various PM states
+ * of the chip.
+ */
 unsigned long st_ll_getstate(struct st_data_s *);
 unsigned long st_ll_sleep_state(struct st_data_s *, unsigned char);
 void st_ll_wakeup(struct st_data_s *);
+
 #endif /* ST_LL_H */
-- 
1.5.6.3

