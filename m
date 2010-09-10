Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab0IJSsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 14:48:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50617 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab0IJSr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 14:47:56 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [RFC 1/3] drivers:staging:ti-st: mv headers to ti_wilink_st
Date: Fri, 10 Sep 2010 15:58:56 -0400
Message-Id: <1284148738-21643-3-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1284148738-21643-2-git-send-email-pavan_savoy@ti.com>
References: <1284148738-21643-1-git-send-email-pavan_savoy@ti.com>
 <1284148738-21643-2-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Move all headers to st.h and rename st.h to be ti_wilink_st.h,
prepare the file to be moved to include/linux/ directory.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/staging/ti-st/fm.h      |   13 --
 drivers/staging/ti-st/st.h      |  318 +++++++++++++++++++++++++++++++++++++++
 drivers/staging/ti-st/st_core.c |    8 -
 drivers/staging/ti-st/st_core.h |  128 ----------------
 drivers/staging/ti-st/st_kim.c  |    6 +-
 drivers/staging/ti-st/st_kim.h  |  180 ----------------------
 drivers/staging/ti-st/st_ll.c   |    2 +-
 drivers/staging/ti-st/st_ll.h   |   69 ---------
 8 files changed, 321 insertions(+), 403 deletions(-)
 delete mode 100644 drivers/staging/ti-st/fm.h
 delete mode 100644 drivers/staging/ti-st/st_core.h
 delete mode 100644 drivers/staging/ti-st/st_kim.h
 delete mode 100644 drivers/staging/ti-st/st_ll.h

diff --git a/drivers/staging/ti-st/fm.h b/drivers/staging/ti-st/fm.h
deleted file mode 100644
index be41453..0000000
--- a/drivers/staging/ti-st/fm.h
+++ /dev/null
@@ -1,13 +0,0 @@
-struct fm_event_hdr {
-	unsigned char plen;
-} __attribute__ ((packed));
-
-#define FM_MAX_FRAME_SIZE 0xFF	/* TODO: */
-#define FM_EVENT_HDR_SIZE 1	/* size of fm_event_hdr */
-#define ST_FM_CH8_PKT 0x8
-
-/* gps stuff */
-struct gps_event_hdr {
-unsigned char opcode;
-unsigned short plen;
-} __attribute__ ((packed));
diff --git a/drivers/staging/ti-st/st.h b/drivers/staging/ti-st/st.h
index 1b3060e..c651903 100644
--- a/drivers/staging/ti-st/st.h
+++ b/drivers/staging/ti-st/st.h
@@ -80,4 +80,322 @@ struct st_proto_s {
 extern long st_register(struct st_proto_s *);
 extern long st_unregister(enum proto_type);
 
+/**
+ * structures and declarations used by the st_core.c
+ */
+/* states of protocol list */
+#define ST_NOTEMPTY	1
+#define ST_EMPTY	0
+
+/*
+ * possible st_states
+ */
+#define ST_INITIALIZING		1
+#define ST_REG_IN_PROGRESS	2
+#define ST_REG_PENDING		3
+#define ST_WAITING_FOR_RESP	4
+
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
+ */
+struct st_data_s {
+	unsigned long st_state;
+	struct tty_struct *tty;
+	struct tty_ldisc_ops *ldisc_ops;
+	struct sk_buff *tx_skb;
+#define ST_TX_SENDING	1
+#define ST_TX_WAKEUP	2
+	unsigned long tx_state;
+	struct st_proto_s *list[ST_MAX];
+	unsigned long rx_state;
+	unsigned long rx_count;
+	struct sk_buff *rx_skb;
+	struct sk_buff_head txq, tx_waitq;
+	spinlock_t lock;
+	unsigned char	protos_registered;
+	unsigned long ll_state;
+	void *kim_data;
+};
+
+/**
+ * st_int_write -
+ * point this to tty->driver->write or tty->ops->write
+ * depending upon the kernel version
+ */
+int st_int_write(struct st_data_s*, const unsigned char*, int);
+
+/**
+ * st_write -
+ * internal write function, passed onto protocol drivers
+ * via the write function ptr of protocol struct
+ */
+long st_write(struct sk_buff *);
+
+/* function to be called from ST-LL */
+void st_ll_send_frame(enum proto_type, struct sk_buff *);
+
+/* internal wake up function */
+void st_tx_wakeup(struct st_data_s *st_data);
+
+/* init, exit entry funcs called from KIM */
+int st_core_init(struct st_data_s **);
+void st_core_exit(struct st_data_s *);
+
+/* ask for reference from KIM */
+void st_kim_ref(struct st_data_s **, int);
+
+#define GPS_STUB_TEST
+#ifdef GPS_STUB_TEST
+int gps_chrdrv_stub_write(const unsigned char*, int);
+void gps_chrdrv_stub_init(void);
+#endif
+
+/**
+ * structures and declarations used by the st_kim.c
+ */
+
+/* time in msec to wait for
+ * line discipline to be installed
+ */
+#define LDISC_TIME	500
+#define CMD_RESP_TIME	500
+#define MAKEWORD(a, b)  ((unsigned short)(((unsigned char)(a)) \
+	| ((unsigned short)((unsigned char)(b))) << 8))
+
+#define GPIO_HIGH 1
+#define GPIO_LOW  0
+
+/* the Power-On-Reset logic, requires to attempt
+ * to download firmware onto chip more than once
+ * since the self-test for chip takes a while
+ */
+#define POR_RETRY_COUNT 5
+
+/**
+ * struct chip_version - save the chip version
+ */
+struct chip_version {
+	unsigned short full;
+	unsigned short chip;
+	unsigned short min_ver;
+	unsigned short maj_ver;
+};
+
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
+};
+
+/**
+ * functions called when 1 of the protocol drivers gets
+ * registered, these need to communicate with UIM to request
+ * ldisc installed, read chip_version, download relevant fw
+ */
+long st_kim_start(void *);
+long st_kim_stop(void *);
+
+void st_kim_recv(void *, const unsigned char *, long count);
+void st_kim_chip_toggle(enum proto_type, enum kim_gpio_state);
+void st_kim_complete(void *);
+void kim_st_list_protocols(struct st_data_s *, void *);
+
+/*
+ * BTS headers
+ */
+#define ACTION_SEND_COMMAND     1
+#define ACTION_WAIT_EVENT       2
+#define ACTION_SERIAL           3
+#define ACTION_DELAY            4
+#define ACTION_RUN_SCRIPT       5
+#define ACTION_REMARKS          6
+
+/**
+ * struct bts_header - the fw file is NOT binary which can
+ *	be sent onto TTY as is. The .bts is more a script
+ *	file which has different types of actions.
+ *	Each such action needs to be parsed by the KIM and
+ *	relevant procedure to be called.
+ */
+struct bts_header {
+	uint32_t magic;
+	uint32_t version;
+	uint8_t future[24];
+	uint8_t actions[0];
+} __attribute__ ((packed));
+
+/**
+ * struct bts_action - Each .bts action has its own type of
+ *	data.
+ */
+struct bts_action {
+	uint16_t type;
+	uint16_t size;
+	uint8_t data[0];
+} __attribute__ ((packed));
+
+struct bts_action_send {
+	uint8_t data[0];
+} __attribute__ ((packed));
+
+struct bts_action_wait {
+	uint32_t msec;
+	uint32_t size;
+	uint8_t data[0];
+} __attribute__ ((packed));
+
+struct bts_action_delay {
+	uint32_t msec;
+} __attribute__ ((packed));
+
+struct bts_action_serial {
+	uint32_t baud;
+	uint32_t flow_control;
+} __attribute__ ((packed));
+
+/**
+ * struct hci_command - the HCI-VS for intrepreting
+ *	the change baud rate of host-side UART, which
+ *	needs to be ignored, since UIM would do that
+ *	when it receives request from KIM for ldisc installation.
+ */
+struct hci_command {
+	uint8_t prefix;
+	uint16_t opcode;
+	uint8_t plen;
+	uint32_t speed;
+} __attribute__ ((packed));
+
+/**
+ * structure and declarations used by st_ll.c
+ */
+/* ST LL receiver states */
+#define ST_W4_PACKET_TYPE       0
+#define ST_BT_W4_EVENT_HDR      1
+#define ST_BT_W4_ACL_HDR        2
+#define ST_BT_W4_SCO_HDR        3
+#define ST_BT_W4_DATA           4
+#define ST_FM_W4_EVENT_HDR      5
+#define ST_GPS_W4_EVENT_HDR	6
+
+/* ST LL state machines */
+#define ST_LL_ASLEEP               0
+#define ST_LL_ASLEEP_TO_AWAKE      1
+#define ST_LL_AWAKE                2
+#define ST_LL_AWAKE_TO_ASLEEP      3
+#define ST_LL_INVALID		   4
+
+/* different PM notifications coming from chip */
+#define LL_SLEEP_IND	0x30
+#define LL_SLEEP_ACK	0x31
+#define LL_WAKE_UP_IND	0x32
+#define LL_WAKE_UP_ACK	0x33
+
+/* initialize and de-init ST LL */
+long st_ll_init(struct st_data_s *);
+long st_ll_deinit(struct st_data_s *);
+
+/**
+ * enable/disable ST LL along with KIM start/stop
+ * called by ST Core
+ */
+void st_ll_enable(struct st_data_s *);
+void st_ll_disable(struct st_data_s *);
+
+/**
+ * various funcs used by ST core to set/get the various PM states
+ * of the chip.
+ */
+unsigned long st_ll_getstate(struct st_data_s *);
+unsigned long st_ll_sleep_state(struct st_data_s *, unsigned char);
+void st_ll_wakeup(struct st_data_s *);
+
+/**
+ * structures and declarations used by the st_core for FM packets
+ */
+struct fm_event_hdr {
+	unsigned char plen;
+} __attribute__ ((packed));
+
+#define FM_MAX_FRAME_SIZE 0xFF	/* TODO: */
+#define FM_EVENT_HDR_SIZE 1	/* size of fm_event_hdr */
+#define ST_FM_CH8_PKT 0x8
+
+/* gps stuff */
+struct gps_event_hdr {
+unsigned char opcode;
+unsigned short plen;
+} __attribute__ ((packed));
+
 #endif /* ST_H */
diff --git a/drivers/staging/ti-st/st_core.c b/drivers/staging/ti-st/st_core.c
index fad97d7..cd54dfb 100644
--- a/drivers/staging/ti-st/st_core.c
+++ b/drivers/staging/ti-st/st_core.c
@@ -28,14 +28,6 @@
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
 #include <net/bluetooth/hci.h>
-#include "fm.h"
-/*
- * packet formats for fm and gps
- * #include "gps.h"
- */
-#include "st_core.h"
-#include "st_kim.h"
-#include "st_ll.h"
 #include "st.h"
 
 /* strings to be used for rfkill entries and by
diff --git a/drivers/staging/ti-st/st_core.h b/drivers/staging/ti-st/st_core.h
deleted file mode 100644
index 8601320..0000000
--- a/drivers/staging/ti-st/st_core.h
+++ /dev/null
@@ -1,128 +0,0 @@
-/*
- *  Shared Transport Core header file
- *
- *  Copyright (C) 2009 Texas Instruments
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
-#ifndef ST_CORE_H
-#define ST_CORE_H
-
-#include <linux/skbuff.h>
-#include "st.h"
-
-/* states of protocol list */
-#define ST_NOTEMPTY	1
-#define ST_EMPTY	0
-
-/*
- * possible st_states
- */
-#define ST_INITIALIZING		1
-#define ST_REG_IN_PROGRESS	2
-#define ST_REG_PENDING		3
-#define ST_WAITING_FOR_RESP	4
-
-/**
- * struct st_data_s - ST core internal structure
- * @st_state: different states of ST like initializing, registration
- *	in progress, this is mainly used to return relevant err codes
- *	when protocol drivers are registering. It is also used to track
- *	the recv function, as in during fw download only HCI events
- *	can occur , where as during other times other events CH8, CH9
- *	can occur.
- * @tty: tty provided by the TTY core for line disciplines.
- * @ldisc_ops: the procedures that this line discipline registers with TTY.
- * @tx_skb: If for some reason the tty's write returns lesser bytes written
- *	then to maintain the rest of data to be written on next instance.
- *	This needs to be protected, hence the lock inside wakeup func.
- * @tx_state: if the data is being written onto the TTY and protocol driver
- *	wants to send more, queue up data and mark that there is
- *	more data to send.
- * @list: the list of protocols registered, only MAX can exist, one protocol
- *	can register only once.
- * @rx_state: states to be maintained inside st's tty receive
- * @rx_count: count to be maintained inside st's tty receieve
- * @rx_skb: the skb where all data for a protocol gets accumulated,
- *	since tty might not call receive when a complete event packet
- *	is received, the states, count and the skb needs to be maintained.
- * @txq: the list of skbs which needs to be sent onto the TTY.
- * @tx_waitq: if the chip is not in AWAKE state, the skbs needs to be queued
- *	up in here, PM(WAKEUP_IND) data needs to be sent and then the skbs
- *	from waitq can be moved onto the txq.
- *	Needs locking too.
- * @lock: the lock to protect skbs, queues, and ST states.
- * @protos_registered: count of the protocols registered, also when 0 the
- *	chip enable gpio can be toggled, and when it changes to 1 the fw
- *	needs to be downloaded to initialize chip side ST.
- * @ll_state: the various PM states the chip can be, the states are notified
- *	to us, when the chip sends relevant PM packets(SLEEP_IND, WAKE_IND).
- * @kim_data: reference to the parent encapsulating structure.
- *
- */
-struct st_data_s {
-	unsigned long st_state;
-	struct tty_struct *tty;
-	struct tty_ldisc_ops *ldisc_ops;
-	struct sk_buff *tx_skb;
-#define ST_TX_SENDING	1
-#define ST_TX_WAKEUP	2
-	unsigned long tx_state;
-	struct st_proto_s *list[ST_MAX];
-	unsigned long rx_state;
-	unsigned long rx_count;
-	struct sk_buff *rx_skb;
-	struct sk_buff_head txq, tx_waitq;
-	spinlock_t lock;
-	unsigned char	protos_registered;
-	unsigned long ll_state;
-	void *kim_data;
-};
-
-/**
- * st_int_write -
- * point this to tty->driver->write or tty->ops->write
- * depending upon the kernel version
- */
-int st_int_write(struct st_data_s*, const unsigned char*, int);
-
-/**
- * st_write -
- * internal write function, passed onto protocol drivers
- * via the write function ptr of protocol struct
- */
-long st_write(struct sk_buff *);
-
-/* function to be called from ST-LL */
-void st_ll_send_frame(enum proto_type, struct sk_buff *);
-
-/* internal wake up function */
-void st_tx_wakeup(struct st_data_s *st_data);
-
-/* init, exit entry funcs called from KIM */
-int st_core_init(struct st_data_s **);
-void st_core_exit(struct st_data_s *);
-
-/* ask for reference from KIM */
-void st_kim_ref(struct st_data_s **, int);
-
-#define GPS_STUB_TEST
-#ifdef GPS_STUB_TEST
-int gps_chrdrv_stub_write(const unsigned char*, int);
-void gps_chrdrv_stub_init(void);
-#endif
-
-#endif /*ST_CORE_H */
diff --git a/drivers/staging/ti-st/st_kim.c b/drivers/staging/ti-st/st_kim.c
index be18c7a..6a2e48c 100644
--- a/drivers/staging/ti-st/st_kim.c
+++ b/drivers/staging/ti-st/st_kim.c
@@ -28,15 +28,13 @@
 #include <linux/gpio.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
-
 #include <linux/sched.h>
-
-#include "st_kim.h"
+#include <linux/rfkill.h>
 /* understand BT events for fw response */
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
 #include <net/bluetooth/hci.h>
-
+#include "st.h"
 
 static int kim_probe(struct platform_device *pdev);
 static int kim_remove(struct platform_device *pdev);
diff --git a/drivers/staging/ti-st/st_kim.h b/drivers/staging/ti-st/st_kim.h
deleted file mode 100644
index 7de2541..0000000
--- a/drivers/staging/ti-st/st_kim.h
+++ /dev/null
@@ -1,180 +0,0 @@
-/*
- *  Shared Transport Line discipline driver Core
- *	Init Manager Module header file
- *  Copyright (C) 2009 Texas Instruments
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
-#ifndef ST_KIM_H
-#define ST_KIM_H
-
-#include <linux/types.h>
-#include "st.h"
-#include "st_core.h"
-#include "st_ll.h"
-#include <linux/rfkill.h>
-
-/* time in msec to wait for
- * line discipline to be installed
- */
-#define LDISC_TIME	500
-#define CMD_RESP_TIME	500
-#define MAKEWORD(a, b)  ((unsigned short)(((unsigned char)(a)) \
-	| ((unsigned short)((unsigned char)(b))) << 8))
-
-#define GPIO_HIGH 1
-#define GPIO_LOW  0
-
-/* the Power-On-Reset logic, requires to attempt
- * to download firmware onto chip more than once
- * since the self-test for chip takes a while
- */
-#define POR_RETRY_COUNT 5
-
-/**
- * struct chip_version - save the chip version
- */
-struct chip_version {
-	unsigned short full;
-	unsigned short chip;
-	unsigned short min_ver;
-	unsigned short maj_ver;
-};
-
-/**
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
- * functions called when 1 of the protocol drivers gets
- * registered, these need to communicate with UIM to request
- * ldisc installed, read chip_version, download relevant fw
- */
-long st_kim_start(void *);
-long st_kim_stop(void *);
-
-void st_kim_recv(void *, const unsigned char *, long count);
-void st_kim_chip_toggle(enum proto_type, enum kim_gpio_state);
-void st_kim_complete(void *);
-void kim_st_list_protocols(struct st_data_s *, void *);
-
-/*
- * BTS headers
- */
-#define ACTION_SEND_COMMAND     1
-#define ACTION_WAIT_EVENT       2
-#define ACTION_SERIAL           3
-#define ACTION_DELAY            4
-#define ACTION_RUN_SCRIPT       5
-#define ACTION_REMARKS          6
-
-/**
- * struct bts_header - the fw file is NOT binary which can
- *	be sent onto TTY as is. The .bts is more a script
- *	file which has different types of actions.
- *	Each such action needs to be parsed by the KIM and
- *	relevant procedure to be called.
- */
-struct bts_header {
-	uint32_t magic;
-	uint32_t version;
-	uint8_t future[24];
-	uint8_t actions[0];
-} __attribute__ ((packed));
-
-/**
- * struct bts_action - Each .bts action has its own type of
- *	data.
- */
-struct bts_action {
-	uint16_t type;
-	uint16_t size;
-	uint8_t data[0];
-} __attribute__ ((packed));
-
-struct bts_action_send {
-	uint8_t data[0];
-} __attribute__ ((packed));
-
-struct bts_action_wait {
-	uint32_t msec;
-	uint32_t size;
-	uint8_t data[0];
-} __attribute__ ((packed));
-
-struct bts_action_delay {
-	uint32_t msec;
-} __attribute__ ((packed));
-
-struct bts_action_serial {
-	uint32_t baud;
-	uint32_t flow_control;
-} __attribute__ ((packed));
-
-/**
- * struct hci_command - the HCI-VS for intrepreting
- *	the change baud rate of host-side UART, which
- *	needs to be ignored, since UIM would do that
- *	when it receives request from KIM for ldisc installation.
- */
-struct hci_command {
-	uint8_t prefix;
-	uint16_t opcode;
-	uint8_t plen;
-	uint32_t speed;
-} __attribute__ ((packed));
-
-
-#endif /* ST_KIM_H */
diff --git a/drivers/staging/ti-st/st_ll.c b/drivers/staging/ti-st/st_ll.c
index 7a1fb6d..9bf56ab 100644
--- a/drivers/staging/ti-st/st_ll.c
+++ b/drivers/staging/ti-st/st_ll.c
@@ -19,7 +19,7 @@
  */
 
 #define pr_fmt(fmt) "(stll) :" fmt
-#include "st_ll.h"
+#include "st.h"
 
 /**********************************************************************/
 /* internal functions */
diff --git a/drivers/staging/ti-st/st_ll.h b/drivers/staging/ti-st/st_ll.h
deleted file mode 100644
index e4dfacd..0000000
--- a/drivers/staging/ti-st/st_ll.h
+++ /dev/null
@@ -1,69 +0,0 @@
-/*
- *  Shared Transport Low Level (ST LL)
- *
- *  Copyright (C) 2009 Texas Instruments
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
-#ifndef ST_LL_H
-#define ST_LL_H
-
-#include <linux/skbuff.h>
-#include "st.h"
-#include "st_core.h"
-
-/* ST LL receiver states */
-#define ST_W4_PACKET_TYPE       0
-#define ST_BT_W4_EVENT_HDR      1
-#define ST_BT_W4_ACL_HDR        2
-#define ST_BT_W4_SCO_HDR        3
-#define ST_BT_W4_DATA           4
-#define ST_FM_W4_EVENT_HDR      5
-#define ST_GPS_W4_EVENT_HDR	6
-
-/* ST LL state machines */
-#define ST_LL_ASLEEP               0
-#define ST_LL_ASLEEP_TO_AWAKE      1
-#define ST_LL_AWAKE                2
-#define ST_LL_AWAKE_TO_ASLEEP      3
-#define ST_LL_INVALID		   4
-
-/* different PM notifications coming from chip */
-#define LL_SLEEP_IND	0x30
-#define LL_SLEEP_ACK	0x31
-#define LL_WAKE_UP_IND	0x32
-#define LL_WAKE_UP_ACK	0x33
-
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
-#endif /* ST_LL_H */
-- 
1.6.5

