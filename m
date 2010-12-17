Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab0LQLuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 06:50:40 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:51927 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721Ab0LQLuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 06:50:39 -0500
From: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
To: Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
Subject: [PATCH 07/11] Bluetooth: Add UART API functions to ldisc
Date: Fri, 17 Dec 2010 12:24:54 +0100
Message-ID: <1292585094-28544-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new functions to control break and flow
as well as changing UART baud rate directly through the ldisc API
rather then using the TTY API directly.
It also adds a boolean parameter so it is optional to register
to the Bluetooth stack (for drivers where a separate module
registers to the Bluetooth stack instead).

Signed-off-by: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
---
 drivers/bluetooth/hci_ath.c   |    1 +
 drivers/bluetooth/hci_bcsp.c  |    3 +-
 drivers/bluetooth/hci_h4.c    |    1 +
 drivers/bluetooth/hci_ldisc.c |  101 +++++++++++++++++++++++++++++++++++++---
 drivers/bluetooth/hci_ll.c    |    1 +
 drivers/bluetooth/hci_uart.h  |   16 +++++++
 6 files changed, 114 insertions(+), 9 deletions(-)

diff --git a/drivers/bluetooth/hci_ath.c b/drivers/bluetooth/hci_ath.c
index 6a160c1..a948be6 100644
--- a/drivers/bluetooth/hci_ath.c
+++ b/drivers/bluetooth/hci_ath.c
@@ -215,6 +215,7 @@ static struct hci_uart_proto athp = {
 	.enqueue = ath_enqueue,
 	.dequeue = ath_dequeue,
 	.flush = ath_flush,
+	.register_hci_dev = true,
 };
 
 int __init ath_init(void)
diff --git a/drivers/bluetooth/hci_bcsp.c b/drivers/bluetooth/hci_bcsp.c
index 9c5b2dc..fe66cab 100644
--- a/drivers/bluetooth/hci_bcsp.c
+++ b/drivers/bluetooth/hci_bcsp.c
@@ -736,7 +736,8 @@ static struct hci_uart_proto bcsp = {
 	.enqueue	= bcsp_enqueue,
 	.dequeue	= bcsp_dequeue,
 	.recv		= bcsp_recv,
-	.flush		= bcsp_flush
+	.flush		= bcsp_flush,
+	.register_hci_dev = true,
 };
 
 int __init bcsp_init(void)
diff --git a/drivers/bluetooth/hci_h4.c b/drivers/bluetooth/hci_h4.c
index 7b8ad93..3fd7e00 100644
--- a/drivers/bluetooth/hci_h4.c
+++ b/drivers/bluetooth/hci_h4.c
@@ -171,6 +171,7 @@ static struct hci_uart_proto h4p = {
 	.enqueue	= h4_enqueue,
 	.dequeue	= h4_dequeue,
 	.flush		= h4_flush,
+	.register_hci_dev = true,
 };
 
 int __init h4_init(void)
diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 7201482..b00597e 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -46,7 +46,10 @@
 
 #include "hci_uart.h"
 
-#define VERSION "2.2"
+#define VERSION "2.3"
+
+#define TTY_BREAK_ON		(-1)
+#define TTY_BREAK_OFF		(0)
 
 static int reset = 0;
 
@@ -90,6 +93,9 @@ static inline void hci_uart_tx_complete(struct hci_uart *hu, int pkt_type)
 {
 	struct hci_dev *hdev = hu->hdev;
 
+	if (!hdev)
+		return;
+
 	/* Update HCI stat counters */
 	switch (pkt_type) {
 	case HCI_COMMAND_PKT:
@@ -139,7 +145,8 @@ restart:
 
 		set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
 		len = tty->ops->write(tty, skb->data, skb->len);
-		hdev->stat.byte_tx += len;
+		if (hdev)
+			hdev->stat.byte_tx += len;
 
 		skb_pull(skb, len);
 		if (skb->len) {
@@ -158,6 +165,65 @@ restart:
 	return 0;
 }
 
+int hci_uart_set_break(struct hci_uart *hu, bool break_on)
+{
+	struct tty_struct *tty = hu->tty;
+	int state = TTY_BREAK_OFF;
+
+	if (break_on)
+		state = TTY_BREAK_ON;
+
+	if (tty->ops->break_ctl)
+		return tty->ops->break_ctl(tty, state);
+	else
+		return -EOPNOTSUPP;
+}
+
+void hci_uart_flow_ctrl(struct hci_uart *hu, bool flow_on)
+{
+	if (flow_on)
+		tty_unthrottle(hu->tty);
+	else
+		tty_throttle(hu->tty);
+}
+
+int hci_uart_set_baudrate(struct hci_uart *hu, int baud)
+{
+	struct ktermios old_termios;
+	struct tty_struct *tty = hu->tty;
+
+	if (!tty->ops->set_termios)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&(tty->termios_mutex));
+	/* Start by storing the old termios. */
+	memcpy(&old_termios, tty->termios, sizeof(old_termios));
+
+	tty_encode_baud_rate(tty, baud, baud);
+
+	/* Finally inform the driver */
+	tty->ops->set_termios(tty, &old_termios);
+
+	mutex_unlock(&(tty->termios_mutex));
+
+	return 0;
+}
+
+int hci_uart_tiocmget(struct hci_uart *hu)
+{
+	struct tty_struct *tty = hu->tty;
+
+	if (!tty->ops->tiocmget ||  !hu->fd)
+		return -EOPNOTSUPP;
+
+	return tty->ops->tiocmget(tty, hu->fd);
+}
+
+void hci_uart_flush_buffer(struct hci_uart *hu)
+{
+	tty_driver_flush_buffer(hu->tty);
+}
+
 /* ------- Interface to HCI layer ------ */
 /* Initialize device */
 static int hci_uart_open(struct hci_dev *hdev)
@@ -210,6 +276,7 @@ static int hci_uart_close(struct hci_dev *hdev)
 static int hci_uart_send_frame(struct sk_buff *skb)
 {
 	struct hci_dev* hdev = (struct hci_dev *) skb->dev;
+	struct tty_struct *tty;
 	struct hci_uart *hu;
 
 	if (!hdev) {
@@ -221,6 +288,7 @@ static int hci_uart_send_frame(struct sk_buff *skb)
 		return -EBUSY;
 
 	hu = (struct hci_uart *) hdev->driver_data;
+	tty = hu->tty;
 
 	BT_DBG("%s: type %d len %d", hdev->name, bt_cb(skb)->pkt_type, skb->len);
 
@@ -311,8 +379,11 @@ static void hci_uart_tty_close(struct tty_struct *tty)
 
 		if (test_and_clear_bit(HCI_UART_PROTO_SET, &hu->flags)) {
 			hu->proto->close(hu);
-			hci_unregister_dev(hdev);
-			hci_free_dev(hdev);
+
+			if (hdev) {
+				hci_unregister_dev(hdev);
+				hci_free_dev(hdev);
+			}
 		}
 	}
 }
@@ -367,7 +438,8 @@ static void hci_uart_tty_receive(struct tty_struct *tty, const u8 *data, char *f
 
 	spin_lock(&hu->rx_lock);
 	hu->proto->recv(hu, (void *) data, count);
-	hu->hdev->stat.byte_rx += count;
+	if (hu->hdev)
+		hu->hdev->stat.byte_rx += count;
 	spin_unlock(&hu->rx_lock);
 
 	tty_unthrottle(tty);
@@ -423,11 +495,18 @@ static int hci_uart_set_proto(struct hci_uart *hu, int id)
 	if (!p)
 		return -EPROTONOSUPPORT;
 
+	hu->proto = p;
+
 	err = p->open(hu);
 	if (err)
 		return err;
 
-	hu->proto = p;
+	/*
+	 * Protocol might register hdev by itself.
+	 * In that case, there is no need to register it here.
+	 */
+	if (!hu->proto->register_hci_dev)
+		return 0;
 
 	err = hci_uart_register_dev(hu);
 	if (err) {
@@ -471,6 +550,8 @@ static int hci_uart_tty_ioctl(struct tty_struct *tty, struct file * file,
 				clear_bit(HCI_UART_PROTO_SET, &hu->flags);
 				return err;
 			}
+			/* Keep file descriptor.*/
+			hu->fd = file;
 		} else
 			return -EBUSY;
 		break;
@@ -481,8 +562,12 @@ static int hci_uart_tty_ioctl(struct tty_struct *tty, struct file * file,
 		return -EUNATCH;
 
 	case HCIUARTGETDEVICE:
-		if (test_bit(HCI_UART_PROTO_SET, &hu->flags))
-			return hu->hdev->id;
+		if (test_bit(HCI_UART_PROTO_SET, &hu->flags)) {
+			if (hu->hdev)
+				return hu->hdev->id;
+			else
+				return -ENOMSG;
+		}
 		return -EUNATCH;
 
 	case HCIUARTSETFLAGS:
diff --git a/drivers/bluetooth/hci_ll.c b/drivers/bluetooth/hci_ll.c
index 38595e7..085656c 100644
--- a/drivers/bluetooth/hci_ll.c
+++ b/drivers/bluetooth/hci_ll.c
@@ -515,6 +515,7 @@ static struct hci_uart_proto llp = {
 	.enqueue	= ll_enqueue,
 	.dequeue	= ll_dequeue,
 	.flush		= ll_flush,
+	.register_hci_dev = true,
 };
 
 int __init ll_init(void)
diff --git a/drivers/bluetooth/hci_uart.h b/drivers/bluetooth/hci_uart.h
index 99fb352..ab195fb 100644
--- a/drivers/bluetooth/hci_uart.h
+++ b/drivers/bluetooth/hci_uart.h
@@ -43,9 +43,16 @@
 #define HCI_UART_H4DS	3
 #define HCI_UART_LL	4
 #define HCI_UART_ATH3K	5
+#define HCI_UART_STE	6
 
 #define HCI_UART_RAW_DEVICE	0
 
+/* UART break and flow control parameters */
+#define BREAK_ON		true
+#define BREAK_OFF		false
+#define FLOW_ON			true
+#define FLOW_OFF		false
+
 struct hci_uart;
 
 struct hci_uart_proto {
@@ -56,6 +63,8 @@ struct hci_uart_proto {
 	int (*recv)(struct hci_uart *hu, void *data, int len);
 	int (*enqueue)(struct hci_uart *hu, struct sk_buff *skb);
 	struct sk_buff *(*dequeue)(struct hci_uart *hu);
+	bool register_hci_dev;
+	struct device *dev;
 };
 
 struct hci_uart {
@@ -70,6 +79,8 @@ struct hci_uart {
 	struct sk_buff		*tx_skb;
 	unsigned long		tx_state;
 	spinlock_t		rx_lock;
+
+	struct file		*fd;
 };
 
 /* HCI_UART proto flag bits */
@@ -82,6 +93,11 @@ struct hci_uart {
 int hci_uart_register_proto(struct hci_uart_proto *p);
 int hci_uart_unregister_proto(struct hci_uart_proto *p);
 int hci_uart_tx_wakeup(struct hci_uart *hu);
+int hci_uart_set_baudrate(struct hci_uart *hu, int baud);
+int hci_uart_set_break(struct hci_uart *hu, bool break_on);
+int hci_uart_tiocmget(struct hci_uart *hu);
+void hci_uart_flush_buffer(struct hci_uart *hu);
+void hci_uart_flow_ctrl(struct hci_uart *hu, bool flow_on);
 
 #ifdef CONFIG_BT_HCIUART_H4
 int h4_init(void);
-- 
1.7.3.2

