Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab1JYPlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 11:41:07 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3261 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab1JYPlF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 11:41:05 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Mark Mendelsohn" <mendelso@broadcom.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 25 Oct 2011 08:40:05 -0700
Subject: H5 Line Discipline for Bluetooth
Thread-Topic: H5 Line Discipline for Bluetooth
Thread-Index: AQHMkyxdB7W4GyUIiUuXWm9KZ73i/g==
Message-ID: <C27F8246C663564A84BB7AB34397724266D8EE3FB1@IRVEXCHCCR01.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 62B805AF5IS22557814-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ab30529d2c1d32dd397e4e5c165572a2ab43f597 Mon Sep 17 00:00:00 2001
From: Mark P. Mendelsohn <mpm>
Date: Wed, 10 Aug 2011 14:26:34 -0700
Subject: [PATCH 01/10] adding H5

---
 drivers/bluetooth/1           |  812 ++++++++++++++++++++++++++++++++++++++++
 drivers/bluetooth/Kconfig     |   11 +
 drivers/bluetooth/Makefile    |    1 +
 drivers/bluetooth/hci_h5.c    |  817 +++++++++++++++++++++++++++++++++++++++++
 drivers/bluetooth/hci_ldisc.c |   32 +-
 drivers/bluetooth/hci_uart.h  |    8 +-
 6 files changed, 1669 insertions(+), 12 deletions(-)
 create mode 100644 drivers/bluetooth/1
 create mode 100644 drivers/bluetooth/hci_h5.c

diff --git a/drivers/bluetooth/1 b/drivers/bluetooth/1
new file mode 100644
index 0000000..0d6eb8a
--- /dev/null
+++ b/drivers/bluetooth/1
@@ -0,0 +1,812 @@
+/*
+ *
+ *  Bluetooth HCI UART driver
+ *
+ *  Copyright (C) 2002-2003  Fabrizio Gennari <fabrizio.gennari@philips.com>
+ *  Copyright (C) 2004-2005  Marcel Holtmann <marcel@holtmann.org>
+ *
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/module.h>
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/fcntl.h>
+#include <linux/interrupt.h>
+#include <linux/ptrace.h>
+#include <linux/poll.h>
+
+#include <linux/slab.h>
+#include <linux/tty.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/signal.h>
+#include <linux/ioctl.h>
+#include <linux/skbuff.h>
+#include <linux/bitrev.h>
+#include <asm/unaligned.h>
+
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci_core.h>
+
+#include "hci_uart.h"
+
+#define VERSION "0.3"
+#undef BT_DBG
+#define BT_DBG printk
+
+static int h5txcrc = 1;
+static int h5extn = 1;
+
+#define H5_TXWINSIZE   4
+
+#define H5_ACK_PKT     0x05
+#define H5_LE_PKT      0x06
+
+struct h5_struct {
+       struct sk_buff_head unack;      /* Unack'ed packets queue */
+       struct sk_buff_head rel;        /* Reliable packets queue */
+       struct sk_buff_head unrel;      /* Unreliable packets queue */
+
+       unsigned long rx_count;
+       struct  sk_buff *rx_skb;
+       u8      rxseq_txack;            /* rxseq == txack. */
+       u8      rxack;                  /* Last packet sent by us that the peer ack'ed */
+       struct  timer_list th5;
+
+       enum {
+               H5_W4_PKT_DELIMITER,
+               H5_W4_PKT_START,
+               H5_W4_H5_HDR,
+               H5_W4_DATA,
+               H5_W4_CRC
+       } rx_state;
+
+       enum {
+               H5_ESCSTATE_NOESC,
+               H5_ESCSTATE_ESC
+       } rx_esc_state;
+
+       u8      use_crc;
+       u16     message_crc;
+       u8      txack_req;              /* Do we need to send ack's to the peer? */
+
+       /* Reliable packet sequence number - used to assign seq to each rel pkt. */
+       u8      msgq_txseq;
+};
+
+/* ---- H5 CRC calculation ---- */
+
+/* Table for calculating CRC for polynomial 0x1021, LSB processed first,
+initial value 0xffff, bits shifted in reverse order. */
+
+static const u16 crc_table[] = {
+       0x0000, 0x1081, 0x2102, 0x3183,
+       0x4204, 0x5285, 0x6306, 0x7387,
+       0x8408, 0x9489, 0xa50a, 0xb58b,
+       0xc60c, 0xd68d, 0xe70e, 0xf78f
+};
+
+/* Initialise the crc calculator */
+#define H5_CRC_INIT(x) x = 0xffff
+
+/*
+   Update crc with next data byte
+
+   Implementation note
+        The data byte is treated as two nibbles.  The crc is generated
+        in reverse, i.e., bits are fed into the register from the top.
+*/
+static void h5_crc_update(u16 *crc, u8 d)
+{
+       u16 reg = *crc;
+
+       printk("%s\n", __func__);
+
+       reg = (reg >> 4) ^ crc_table[(reg ^ d) & 0x000f];
+       reg = (reg >> 4) ^ crc_table[(reg ^ (d >> 4)) & 0x000f];
+
+       *crc = reg;
+}
+
+/* ---- H5 core ---- */
+
+static void h5_slip_msgdelim(struct sk_buff *skb)
+{
+       const char pkt_delim = 0xc0;
+
+       printk("%s\n", __func__);
+
+       memcpy(skb_put(skb, 1), &pkt_delim, 1);
+}
+
+static void h5_slip_one_byte(struct sk_buff *skb, u8 c)
+{
+       const char esc_c0[2] = { 0xdb, 0xdc };
+       const char esc_db[2] = { 0xdb, 0xdd };
+
+       printk("%s\n", __func__);
+
+       switch (c) {
+       case 0xc0:
+               memcpy(skb_put(skb, 2), &esc_c0, 2);
+               break;
+       case 0xdb:
+               memcpy(skb_put(skb, 2), &esc_db, 2);
+               break;
+       default:
+               memcpy(skb_put(skb, 1), &c, 1);
+       }
+}
+
+static int h5_enqueue(struct hci_uart *hu, struct sk_buff *skb)
+{
+       struct h5_struct *h5 = hu->priv;
+
+       printk("%s\n", __func__);
+
+       if (skb->len > 0xFFF) {
+               BT_ERR("Packet too long");
+               kfree_skb(skb);
+               return 0;
+       }
+
+       switch (bt_cb(skb)->pkt_type) {
+       case HCI_ACLDATA_PKT:
+       case HCI_COMMAND_PKT:
+               skb_queue_tail(&h5->rel, skb);
+               break;
+
+       case HCI_SCODATA_PKT:
+               skb_queue_tail(&h5->unrel, skb);
+               break;
+
+       default:
+               BT_ERR("Unknown packet type");
+               kfree_skb(skb);
+               break;
+       }
+
+       return 0;
+}
+
+static struct sk_buff *h5_prepare_pkt(struct h5_struct *h5, u8 *data,
+               int len, int pkt_type)
+{
+       struct sk_buff *nskb;
+       u8 hdr[4], chan;
+       u16 H5_CRC_INIT(h5_txmsg_crc);
+       int rel, i;
+
+       printk("%s\n", __func__);
+       printk("packet type %d\n", pkt_type);
+
+       switch (pkt_type) {
+       case HCI_ACLDATA_PKT:
+               chan = 2;       /* H5 ACL channel */
+               rel = 1;        /* reliable channel */
+               break;
+       case HCI_COMMAND_PKT:
+               chan = 1;       /* H5 cmd/evt channel */
+               rel = 1;        /* reliable channel */
+               break;
+       case HCI_SCODATA_PKT:
+               chan = 3;       /* H5 SCO channel */
+               rel = 0;        /* unreliable channel */
+               break;
+       case H5_LE_PKT:
+               chan = 15;      /* H5 LE channel */
+               rel = 0;        /* unreliable channel */
+               break;
+       case H5_ACK_PKT:
+               chan = 0;       /* H5 internal channel */
+               rel = 0;        /* unreliable channel */
+               break;
+       default:
+               BT_ERR("Unknown packet type");
+               return NULL;
+       }
+
+       printk("chan %d\n", chan);
+
+       if (h5extn && chan == 14) {
+               __le16 opcode = ((struct hci_command_hdr *)data)->opcode;
+
+               /* Vendor specific commands */
+               if (hci_opcode_ogf(__le16_to_cpu(opcode)) == 0x3f) {
+                       u8 desc = *(data + HCI_COMMAND_HDR_SIZE);
+                       if ((desc & 0xf0) == 0xc0) {
+                               data += HCI_COMMAND_HDR_SIZE + 1;
+                               len  -= HCI_COMMAND_HDR_SIZE + 1;
+                               chan = desc & 0x0f;
+                       }
+               }
+       }
+
+       /* Max len of packet: (original len +4(h5 hdr) +2(crc))*2
+          (because bytes 0xc0 and 0xdb are escaped, worst case is
+          when the packet is all made of 0xc0 and 0xdb :) )
+          + 2 (0xc0 delimiters at start and end). */
+
+       nskb = alloc_skb((len + 6) * 2 + 2, GFP_ATOMIC);
+       if (!nskb)
+               return NULL;
+
+       bt_cb(nskb)->pkt_type = pkt_type;
+
+       printk("starting delim\n");
+       h5_slip_msgdelim(nskb);
+
+       hdr[0] = h5->rxseq_txack << 2;
+       h5->txack_req = 0;
+       BT_DBG("We request packet no %u to card\n", h5->rxseq_txack);
+
+       if (rel) {
+               hdr[0] |= 0x01 + (h5->msgq_txseq << 5);
+               BT_DBG("Sending packet with seqno %u\n", h5->msgq_txseq);
+               h5->msgq_txseq = (h5->msgq_txseq + 1) & 0x07;
+       }
+
+       if (h5->use_crc)
+               hdr[0] |= 0x02;
+
+       hdr[1] = (len >> 4) | chan << 4;
+       hdr[2] = (len & 0xff) << 4;
+       hdr[3] = ~(hdr[0] + hdr[1] + hdr[2]);
+
+       /* Put H5 header */
+       for (i = 0; i < 4; i++) {
+               h5_slip_one_byte(nskb, hdr[i]);
+
+               if (h5->use_crc)
+                       h5_crc_update(&h5_txmsg_crc, hdr[i]);
+       }
+
+       /* Put payload */
+       for (i = 0; i < len; i++) {
+               h5_slip_one_byte(nskb, data[i]);
+
+               if (h5->use_crc)
+                       h5_crc_update(&h5_txmsg_crc, data[i]);
+       }
+
+       /* Put CRC */
+       if (h5->use_crc) {
+               h5_txmsg_crc = bitrev16(h5_txmsg_crc);
+               h5_slip_one_byte(nskb, (u8) ((h5_txmsg_crc >> 8) & 0x00ff));
+               h5_slip_one_byte(nskb, (u8) (h5_txmsg_crc & 0x00ff));
+       }
+
+       printk("ending delim\n");
+       h5_slip_msgdelim(nskb);
+       return nskb;
+}
+
+/* This is a rewrite of pkt_avail in AH5 */
+static struct sk_buff *h5_dequeue(struct hci_uart *hu)
+{
+       struct h5_struct *h5 = hu->priv;
+       unsigned long flags;
+       struct sk_buff *skb;
+
+       printk("%s\n", __func__);
+
+       /* First of all, check for unreliable messages in the queue,
+          since they have priority */
+
+       if ((skb = skb_dequeue(&h5->unrel)) != NULL) {
+               printk("got skb\n");
+
+               struct sk_buff *nskb = h5_prepare_pkt(h5, skb->data, skb->len, bt_cb(skb)->pkt_type);
+               if (nskb) {
+                       kfree_skb(skb);
+                       return nskb;
+               } else {
+                       skb_queue_head(&h5->unrel, skb);
+                       BT_ERR("Could not dequeue pkt because alloc_skb failed");
+               }
+       }
+
+       printk("after skb\n");
+
+       /* Now, try to send a reliable pkt. We can only send a
+          reliable packet if the number of packets sent but not yet ack'ed
+          is < than the winsize */
+
+       spin_lock_irqsave_nested(&h5->unack.lock, flags, SINGLE_DEPTH_NESTING);
+
+       if (h5->unack.qlen < H5_TXWINSIZE && (skb = skb_dequeue(&h5->rel)) != NULL) {
+               struct sk_buff *nskb = h5_prepare_pkt(h5, skb->data, skb->len, bt_cb(skb)->pkt_type);
+               if (nskb) {
+                       __skb_queue_tail(&h5->unack, skb);
+                       mod_timer(&h5->th5, jiffies + HZ / 4);
+                       spin_unlock_irqrestore(&h5->unack.lock, flags);
+                       return nskb;
+               } else {
+                       skb_queue_head(&h5->rel, skb);
+                       BT_ERR("Could not dequeue pkt because alloc_skb failed");
+               }
+       }
+
+       spin_unlock_irqrestore(&h5->unack.lock, flags);
+
+       printk("after spin_unlock\n");
+
+       /* We could not send a reliable packet, either because there are
+          none or because there are too many unack'ed pkts. Did we receive
+          any packets we have not acknowledged yet ? */
+
+       if (h5->txack_req) {
+               /* if so, craft an empty ACK pkt and send it on H5 unreliable
+                  channel 0 */
+               struct sk_buff *nskb = h5_prepare_pkt(h5, NULL, 0, H5_ACK_PKT);
+               return nskb;
+       }
+
+       printk("we have nothing to send\n");
+       /* We have nothing to send */
+       return NULL;
+}
+
+static int h5_flush(struct hci_uart *hu)
+{
+       BT_DBG("hu %p", hu);
+       printk("%s\n", __func__);
+       return 0;
+}
+
+/* Remove ack'ed packets */
+static void h5_pkt_cull(struct h5_struct *h5)
+{
+       struct sk_buff *skb, *tmp;
+       unsigned long flags;
+       int i, pkts_to_be_removed;
+       u8 seqno;
+
+       printk("%s\n", __func__);
+
+       spin_lock_irqsave(&h5->unack.lock, flags);
+
+       pkts_to_be_removed = skb_queue_len(&h5->unack);
+       seqno = h5->msgq_txseq;
+
+       while (pkts_to_be_removed) {
+               if (h5->rxack == seqno)
+                       break;
+               pkts_to_be_removed--;
+               seqno = (seqno - 1) & 0x07;
+       }
+
+       if (h5->rxack != seqno)
+               BT_ERR("Peer acked invalid packet");
+
+       BT_DBG("Removing %u pkts out of %u, up to seqno %u",
+              pkts_to_be_removed, skb_queue_len(&h5->unack),
+              (seqno - 1) & 0x07);
+
+       i = 0;
+       skb_queue_walk_safe(&h5->unack, skb, tmp) {
+               if (i >= pkts_to_be_removed)
+                       break;
+               i++;
+
+               __skb_unlink(skb, &h5->unack);
+               kfree_skb(skb);
+       }
+
+       if (skb_queue_empty(&h5->unack))
+               del_timer(&h5->th5);
+
+       spin_unlock_irqrestore(&h5->unack.lock, flags);
+
+       if (i != pkts_to_be_removed)
+               BT_ERR("Removed only %u out of %u pkts", i, pkts_to_be_removed);
+}
+
+/* Handle H5 link-establishment packets. When we
+   detect a "sync" packet, symptom that the BT module has reset,
+   we do nothing :) (yet) */
+static void h5_handle_le_pkt(struct hci_uart *hu)
+{
+       struct h5_struct *h5 = hu->priv;
+       u8 conf_pkt[4]     = { 0xad, 0xef, 0xac, 0xed };
+       u8 conf_rsp_pkt[4] = { 0xde, 0xad, 0xd0, 0xd0 };
+       u8 sync_pkt[4]     = { 0x00, 0xd0, 0x01, 0x7e };
+
+       printk("%s\n", __func__);
+
+       /* spot "conf" pkts and reply with a "conf rsp" pkt */
+       if (h5->rx_skb->data[1] >> 4 == 4 && h5->rx_skb->data[2] == 0 &&
+                       !memcmp(&h5->rx_skb->data[4], conf_pkt, 4)) {
+               struct sk_buff *nskb = alloc_skb(4, GFP_ATOMIC);
+
+               BT_DBG("Found a LE conf pkt");
+               if (!nskb)
+                       return;
+               memcpy(skb_put(nskb, 4), conf_rsp_pkt, 4);
+               bt_cb(nskb)->pkt_type = H5_LE_PKT;
+
+               skb_queue_head(&h5->unrel, nskb);
+               hci_uart_tx_wakeup(hu);
+       }
+       /* Spot "sync" pkts. If we find one...disaster! */
+       else if (h5->rx_skb->data[1] >> 4 == 4 && h5->rx_skb->data[2] == 0 &&
+                       !memcmp(&h5->rx_skb->data[4], sync_pkt, 4)) {
+               BT_ERR("Found a LE sync pkt, card has reset");
+       }
+}
+
+static inline void h5_unslip_one_byte(struct h5_struct *h5, unsigned char byte)
+{
+       const u8 c0 = 0xc0, db = 0xdb;
+
+       printk("%s\n", __func__);
+
+       switch (h5->rx_esc_state) {
+       case H5_ESCSTATE_NOESC:
+               switch (byte) {
+               case 0xdb:
+                       h5->rx_esc_state = H5_ESCSTATE_ESC;
+                       break;
+               default:
+                       memcpy(skb_put(h5->rx_skb, 1), &byte, 1);
+                       if ((h5->rx_skb-> data[0] & 0x40) != 0 &&
+                                       h5->rx_state != H5_W4_CRC)
+                               h5_crc_update(&h5->message_crc, byte);
+                       h5->rx_count--;
+               }
+               break;
+
+       case H5_ESCSTATE_ESC:
+               switch (byte) {
+               case 0xdc:
+                       memcpy(skb_put(h5->rx_skb, 1), &c0, 1);
+                       if ((h5->rx_skb-> data[0] & 0x40) != 0 &&
+                                       h5->rx_state != H5_W4_CRC)
+                               h5_crc_update(&h5-> message_crc, 0xc0);
+                       h5->rx_esc_state = H5_ESCSTATE_NOESC;
+                       h5->rx_count--;
+                       break;
+
+               case 0xdd:
+                       memcpy(skb_put(h5->rx_skb, 1), &db, 1);
+                       if ((h5->rx_skb-> data[0] & 0x40) != 0 &&
+                                       h5->rx_state != H5_W4_CRC)
+                               h5_crc_update(&h5-> message_crc, 0xdb);
+                       h5->rx_esc_state = H5_ESCSTATE_NOESC;
+                       h5->rx_count--;
+                       break;
+
+               default:
+                       BT_ERR ("Invalid byte %02x after esc byte", byte);
+                       kfree_skb(h5->rx_skb);
+                       h5->rx_skb = NULL;
+                       h5->rx_state = H5_W4_PKT_DELIMITER;
+                       h5->rx_count = 0;
+               }
+       }
+}
+
+static void h5_complete_rx_pkt(struct hci_uart *hu)
+{
+       struct h5_struct *h5 = hu->priv;
+       int pass_up;
+
+       printk("%s\n", __func__);
+
+       if (h5->rx_skb->data[0] & 0x80) {       /* reliable pkt */
+               BT_DBG("Received seqno %u from card", h5->rxseq_txack);
+               h5->rxseq_txack++;
+               h5->rxseq_txack %= 0x8;
+               h5->txack_req    = 1;
+
+               /* If needed, transmit an ack pkt */
+               hci_uart_tx_wakeup(hu);
+       }
+
+       h5->rxack = (h5->rx_skb->data[0] >> 3) & 0x07;
+       BT_DBG("Request for pkt %u from card", h5->rxack);
+
+       h5_pkt_cull(h5);
+       if ((h5->rx_skb->data[1] & 0x0f) == 2 &&
+                       h5->rx_skb->data[0] & 0x80) {
+               bt_cb(h5->rx_skb)->pkt_type = HCI_ACLDATA_PKT;
+               pass_up = 1;
+       } else if ((h5->rx_skb->data[1] & 0x0f) == 4 &&
+                       h5->rx_skb->data[0] & 0x80) {
+               bt_cb(h5->rx_skb)->pkt_type = HCI_EVENT_PKT;
+               pass_up = 1;
+       } else if ((h5->rx_skb->data[1] & 0x0f) == 3) {
+               bt_cb(h5->rx_skb)->pkt_type = HCI_SCODATA_PKT;
+               pass_up = 1;
+       } else if ((h5->rx_skb->data[1] & 0x0f) == 15 &&
+                       !(h5->rx_skb->data[0] & 0x80)) {
+               h5_handle_le_pkt(hu);
+               pass_up = 0;
+       } else
+               pass_up = 0;
+
+       if (!pass_up) {
+               struct hci_event_hdr hdr;
+               u8 desc = (h5->rx_skb->data[1] & 0x0f);
+
+               if (desc != 0 && desc != 1) {
+                       if (h5extn) {
+                               desc |= 0xc0;
+                               skb_pull(h5->rx_skb, 4);
+                               memcpy(skb_push(h5->rx_skb, 1), &desc, 1);
+
+                               hdr.evt = 0xff;
+                               hdr.plen = h5->rx_skb->len;
+                               memcpy(skb_push(h5->rx_skb, HCI_EVENT_HDR_SIZE), &hdr, HCI_EVENT_HDR_SIZE);
+                               bt_cb(h5->rx_skb)->pkt_type = HCI_EVENT_PKT;
+
+                               hci_recv_frame(h5->rx_skb);
+                       } else {
+                               BT_ERR ("Packet for unknown channel (%u %s)",
+                                       h5->rx_skb->data[1] & 0x0f,
+                                       h5->rx_skb->data[0] & 0x80 ?
+                                       "reliable" : "unreliable");
+                               kfree_skb(h5->rx_skb);
+                       }
+               } else
+                       kfree_skb(h5->rx_skb);
+       } else {
+               /* Pull out H5 hdr */
+               skb_pull(h5->rx_skb, 4);
+
+               hci_recv_frame(h5->rx_skb);
+       }
+
+       h5->rx_state = H5_W4_PKT_DELIMITER;
+       h5->rx_skb = NULL;
+}
+
+static u16 h5_get_crc(struct h5_struct *h5)
+{
+       printk("%s\n", __func__);
+
+       return get_unaligned_be16(&h5->rx_skb->data[h5->rx_skb->len - 2]);
+}
+
+/* Recv data */
+static int h5_recv(struct hci_uart *hu, void *data, int count)
+{
+       struct h5_struct *h5 = hu->priv;
+       register unsigned char *ptr;
+
+       printk("%s\n", __func__);
+
+       BT_DBG("hu %p count %d rx_state %d rx_count %ld",
+               hu, count, h5->rx_state, h5->rx_count);
+
+       ptr = data;
+       while (count) {
+               if (h5->rx_count) {
+                       if (*ptr == 0xc0) {
+                               BT_ERR("Short H5 packet");
+                               kfree_skb(h5->rx_skb);
+                               h5->rx_state = H5_W4_PKT_START;
+                               h5->rx_count = 0;
+                       } else
+                               h5_unslip_one_byte(h5, *ptr);
+
+                       ptr++; count--;
+                       continue;
+               }
+
+               switch (h5->rx_state) {
+               case H5_W4_H5_HDR:
+                       if ((0xff & (u8) ~ (h5->rx_skb->data[0] + h5->rx_skb->data[1] +
+                                       h5->rx_skb->data[2])) != h5->rx_skb->data[3]) {
+                               BT_ERR("Error in H5 hdr checksum");
+                               kfree_skb(h5->rx_skb);
+                               h5->rx_state = H5_W4_PKT_DELIMITER;
+                               h5->rx_count = 0;
+                               continue;
+                       }
+                       if (h5->rx_skb->data[0] & 0x80  /* reliable pkt */
+                                       && (h5->rx_skb->data[0] & 0x07) != h5->rxseq_txack) {
+                               BT_ERR ("Out-of-order packet arrived, got %u expected %u",
+                                       h5->rx_skb->data[0] & 0x07, h5->rxseq_txack);
+
+                               kfree_skb(h5->rx_skb);
+                               h5->rx_state = H5_W4_PKT_DELIMITER;
+                               h5->rx_count = 0;
+                               continue;
+                       }
+                       h5->rx_state = H5_W4_DATA;
+                       h5->rx_count = (h5->rx_skb->data[1] >> 4) +
+                                       (h5->rx_skb->data[2] << 4);     /* May be 0 */
+                       continue;
+
+               case H5_W4_DATA:
+                       if (h5->rx_skb->data[0] & 0x40) {       /* pkt with crc */
+                               h5->rx_state = H5_W4_CRC;
+                               h5->rx_count = 2;
+                       } else
+                               h5_complete_rx_pkt(hu);
+                       continue;
+
+               case H5_W4_CRC:
+                       if (bitrev16(h5->message_crc) != h5_get_crc(h5)) {
+                               BT_ERR ("Checksum failed: computed %04x received %04x",
+                                       bitrev16(h5->message_crc),
+                                       h5_get_crc(h5));
+
+                               kfree_skb(h5->rx_skb);
+                               h5->rx_state = H5_W4_PKT_DELIMITER;
+                               h5->rx_count = 0;
+                               continue;
+                       }
+                       skb_trim(h5->rx_skb, h5->rx_skb->len - 2);
+                       h5_complete_rx_pkt(hu);
+                       continue;
+
+               case H5_W4_PKT_DELIMITER:
+                       switch (*ptr) {
+                       case 0xc0:
+                               h5->rx_state = H5_W4_PKT_START;
+                               break;
+                       default:
+                               /*BT_ERR("Ignoring byte %02x", *ptr);*/
+                               break;
+                       }
+                       ptr++; count--;
+                       break;
+
+               case H5_W4_PKT_START:
+                       switch (*ptr) {
+                       case 0xc0:
+                               ptr++; count--;
+                               break;
+
+                       default:
+                               h5->rx_state = H5_W4_H5_HDR;
+                               h5->rx_count = 4;
+                               h5->rx_esc_state = H5_ESCSTATE_NOESC;
+                               H5_CRC_INIT(h5->message_crc);
+
+                               /* Do not increment ptr or decrement count
+                                * Allocate packet. Max len of a H5 pkt=
+                                * 0xFFF (payload) +4 (header) +2 (crc) */
+
+                               h5->rx_skb = bt_skb_alloc(0x1005, GFP_ATOMIC);
+                               if (!h5->rx_skb) {
+                                       BT_ERR("Can't allocate mem for new packet");
+                                       h5->rx_state = H5_W4_PKT_DELIMITER;
+                                       h5->rx_count = 0;
+                                       return 0;
+                               }
+                               h5->rx_skb->dev = (void *) hu->hdev;
+                               break;
+                       }
+                       break;
+               }
+       }
+       return count;
+}
+
+       /* Arrange to retransmit all messages in the relq. */
+static void h5_timed_event(unsigned long arg)
+{
+       struct hci_uart *hu = (struct hci_uart *) arg;
+       struct h5_struct *h5 = hu->priv;
+       struct sk_buff *skb;
+       unsigned long flags;
+
+       printk("%s\n", __func__);
+
+       BT_DBG("hu %p retransmitting %u pkts", hu, h5->unack.qlen);
+
+       spin_lock_irqsave_nested(&h5->unack.lock, flags, SINGLE_DEPTH_NESTING);
+
+       while ((skb = __skb_dequeue_tail(&h5->unack)) != NULL) {
+               h5->msgq_txseq = (h5->msgq_txseq - 1) & 0x07;
+               skb_queue_head(&h5->rel, skb);
+       }
+
+       spin_unlock_irqrestore(&h5->unack.lock, flags);
+
+       hci_uart_tx_wakeup(hu);
+}
+
+static int h5_open(struct hci_uart *hu)
+{
+       struct h5_struct *h5;
+
+       printk("%s\n", __func__);
+
+       BT_DBG("hu %p", hu);
+
+       h5 = kzalloc(sizeof(*h5), GFP_ATOMIC);
+       if (!h5)
+               return -ENOMEM;
+
+       hu->priv = h5;
+       skb_queue_head_init(&h5->unack);
+       skb_queue_head_init(&h5->rel);
+       skb_queue_head_init(&h5->unrel);
+
+       init_timer(&h5->th5);
+       h5->th5.function = h5_timed_event;
+       h5->th5.data     = (u_long) hu;
+
+       h5->rx_state = H5_W4_PKT_DELIMITER;
+
+       if (h5txcrc)
+               h5->use_crc = 1;
+
+       return 0;
+}
+
+static int h5_close(struct hci_uart *hu)
+{
+       struct h5_struct *h5 = hu->priv;
+       hu->priv = NULL;
+
+       printk("%s\n", __func__);
+
+       BT_DBG("hu %p", hu);
+
+       skb_queue_purge(&h5->unack);
+       skb_queue_purge(&h5->rel);
+       skb_queue_purge(&h5->unrel);
+       del_timer(&h5->th5);
+
+       kfree(h5);
+       return 0;
+}
+
+static struct hci_uart_proto h5 = {
+       .id             = HCI_UART_H5,
+       .open           = h5_open,
+       .close          = h5_close,
+       .enqueue        = h5_enqueue,
+       .dequeue        = h5_dequeue,
+       .recv           = h5_recv,
+       .flush          = h5_flush
+};
+
+int h5_init(void)
+{
+       int err = hci_uart_register_proto(&h5);
+
+       printk("%s\n", __func__);
+
+       if (!err)
+               BT_INFO("HCI H5 protocol initialized");
+       else
+               BT_ERR("HCI H5 protocol registration failed");
+
+       return err;
+}
+
+int h5_deinit(void)
+{
+       printk("%s\n", __func__);
+
+       return hci_uart_unregister_proto(&h5);
+}
+
+module_param(h5txcrc, bool, 0644);
+MODULE_PARM_DESC(h5txcrc, "Transmit CRC with every H5 packet");
+
+module_param(h5extn, bool, 0644);
+MODULE_PARM_DESC(h5extn, "Convert HCI Extensions into H5 packets");
diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index 058fbcc..28daf2d 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -58,6 +58,17 @@ config BT_HCIUART_BCSP

          Say Y here to compile support for HCI BCSP protocol.

+config BT_HCIUART_H5
+       bool "H5 protocol support"
+       depends on BT_HCIUART
+       select BITREVERSE
+       help
+         H5, also called 3 Wire or SLIP, is serial protocol for communication
+         between Bluetooth device and host. This protocol can be used when
+         no CTS/RTS, hardware flow control lines, are available.
+
+         Say Y here to compile support for HCI H5 protocol.
+
 config BT_HCIUART_LL
        bool "HCILL protocol support"
        depends on BT_HCIUART
diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
index 7e5aed5..452fc24 100644
--- a/drivers/bluetooth/Makefile
+++ b/drivers/bluetooth/Makefile
@@ -26,4 +26,5 @@ hci_uart-y                            := hci_ldisc.o
 hci_uart-$(CONFIG_BT_HCIUART_H4)       += hci_h4.o
 hci_uart-$(CONFIG_BT_HCIUART_BCSP)     += hci_bcsp.o
 hci_uart-$(CONFIG_BT_HCIUART_LL)       += hci_ll.o
+hci_uart-$(CONFIG_BT_HCIUART_H5)       += hci_h5.o
 hci_uart-objs                          := $(hci_uart-y)
diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
new file mode 100644
index 0000000..e2a1f69
--- /dev/null
+++ b/drivers/bluetooth/hci_h5.c
@@ -0,0 +1,817 @@
+/*
+ *
+ *  Bluetooth HCI UART driver
+ *
+ *  Copyright (C) 2002-2003  Fabrizio Gennari <fabrizio.gennari@philips.com>
+ *  Copyright (C) 2004-2005  Marcel Holtmann <marcel@holtmann.org>
+ *
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/module.h>
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/fcntl.h>
+#include <linux/interrupt.h>
+#include <linux/ptrace.h>
+#include <linux/poll.h>
+
+#include <linux/slab.h>
+#include <linux/tty.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/signal.h>
+#include <linux/ioctl.h>
+#include <linux/skbuff.h>
+#include <linux/bitrev.h>
+#include <asm/unaligned.h>
+
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci_core.h>
+
+#include <linux/crc16.h>
+
+#include "hci_uart.h"
+
+#define VERSION "0.3"
+#undef BT_DBG
+#define BT_DBG printk
+
+static int h5txcrc = 1;
+static int h5extn = 1;
+
+#define H5_TXWINSIZE   4
+
+#define H5_ACK_PKT     0x00
+#define H5_LE_PKT      0x0f
+
+struct h5_struct {
+       struct sk_buff_head unack;      /* Unack'ed packets queue */
+       struct sk_buff_head rel;        /* Reliable packets queue */
+       struct sk_buff_head unrel;      /* Unreliable packets queue */
+
+       unsigned long rx_count;
+       struct  sk_buff *rx_skb;
+       u8      rxseq_txack;            /* rxseq == txack. */
+       u8      rxack;                  /* Last packet sent by us that the peer ack'ed */
+       struct  timer_list th5;
+
+       enum {
+               H5_W4_PKT_DELIMITER,
+               H5_W4_PKT_START,
+               H5_W4_H5_HDR,
+               H5_W4_DATA,
+               H5_W4_CRC1,
+               H5_W4_CRC
+       } rx_state;
+
+       enum {
+               H5_ESCSTATE_NOESC,
+               H5_ESCSTATE_ESC
+       } rx_esc_state;
+
+       u8      use_crc;
+       u16     message_crc;
+       u8      txack_req;              /* Do we need to send ack's to the peer? */
+
+       /* Reliable packet sequence number - used to assign seq to each rel pkt. */
+       u8      msgq_txseq;
+};
+
+/* ---- H5 CRC calculation ---- */
+
+/* Table for calculating CRC for polynomial 0x1021, LSB processed first,
+initial value 0xffff, bits shifted in reverse order. */
+
+static const u16 crc_table[] = {
+       0x0000, 0x1081, 0x2102, 0x3183,
+       0x4204, 0x5285, 0x6306, 0x7387,
+       0x8408, 0x9489, 0xa50a, 0xb58b,
+       0xc60c, 0xd68d, 0xe70e, 0xf78f
+};
+
+/* Initialise the crc calculator */
+#define H5_CRC_INIT(x) x = 0xffff
+
+/*
+   Update crc with next data byte
+
+   Implementation note
+        The data byte is treated as two nibbles.  The crc is generated
+        in reverse, i.e., bits are fed into the register from the top.
+*/
+static void h5_crc_update(u16 *crc, u8 d)
+{
+       u16 reg = *crc;
+
+       reg = (reg >> 4) ^ crc_table[(reg ^ d) & 0x000f];
+       reg = (reg >> 4) ^ crc_table[(reg ^ (d >> 4)) & 0x000f];
+
+       *crc = reg;
+}
+
+/* ---- H5 core ---- */
+
+static void h5_slip_msgdelim(struct sk_buff *skb)
+{
+       const char pkt_delim = 0xc0;
+
+       memcpy(skb_put(skb, 1), &pkt_delim, 1);
+}
+
+static void h5_slip_one_byte(struct sk_buff *skb, u8 c)
+{
+       const char esc_c0[2] = { 0xdb, 0xdc };
+       const char esc_db[2] = { 0xdb, 0xdd };
+
+       switch (c) {
+       case 0xc0:
+               memcpy(skb_put(skb, 2), &esc_c0, 2);
+               break;
+       case 0xdb:
+               memcpy(skb_put(skb, 2), &esc_db, 2);
+               break;
+       default:
+               memcpy(skb_put(skb, 1), &c, 1);
+       }
+}
+
+static int h5_enqueue(struct hci_uart *hu, struct sk_buff *skb)
+{
+       struct h5_struct *h5 = hu->priv;
+
+       if (skb->len > 0xFFF) {
+               BT_ERR("Packet too long");
+               kfree_skb(skb);
+               return 0;
+       }
+
+       switch (bt_cb(skb)->pkt_type) {
+       case HCI_ACLDATA_PKT:
+       case HCI_COMMAND_PKT:
+               skb_queue_tail(&h5->rel, skb);
+               break;
+
+       case HCI_SCODATA_PKT:
+               skb_queue_tail(&h5->unrel, skb);
+               break;
+
+       default:
+               BT_ERR("Unknown packet type");
+               kfree_skb(skb);
+               break;
+       }
+
+       return 0;
+}
+
+static struct sk_buff *h5_prepare_pkt(struct h5_struct *h5, u8 *data,
+               int len, int pkt_type)
+{
+       struct sk_buff *nskb;
+       u8 hdr[4], chan;
+       u16 H5_CRC_INIT(h5_txmsg_crc);
+       int rel, i;
+
+       print_hex_dump_bytes("h5_prepare_pkt ", DUMP_PREFIX_NONE, data, len);
+
+       switch (pkt_type) {
+       case HCI_ACLDATA_PKT:
+               chan = 2;       /* H5 ACL channel */
+               rel = 1;        /* reliable channel */
+               break;
+       case HCI_COMMAND_PKT:
+               chan = 1;       /* H5 cmd/evt channel */
+               rel = 1;        /* reliable channel */
+               break;
+       case HCI_SCODATA_PKT:
+               chan = 3;       /* H5 SCO channel */
+               rel = 0;        /* unreliable channel */
+               break;
+       case H5_LE_PKT:
+               chan = 15;      /* H5 LE channel */
+               rel = 0;        /* unreliable channel */
+               break;
+       case H5_ACK_PKT:
+               chan = 0;       /* H5 internal channel */
+               rel = 0;        /* unreliable channel */
+               break;
+       default:
+               BT_ERR("Unknown packet type");
+               return NULL;
+       }
+
+       if (h5extn && chan == 14) {
+               __le16 opcode = ((struct hci_command_hdr *)data)->opcode;
+
+               /* Vendor specific commands */
+               if (hci_opcode_ogf(__le16_to_cpu(opcode)) == 0x3f) {
+                       u8 desc = *(data + HCI_COMMAND_HDR_SIZE);
+                       if ((desc & 0xf0) == 0xc0) {
+                               data += HCI_COMMAND_HDR_SIZE + 1;
+                               len  -= HCI_COMMAND_HDR_SIZE + 1;
+                               chan = desc & 0x0f;
+                       }
+               }
+       }
+
+       /* Max len of packet: (original len +4(h5 hdr) +2(crc))*2
+          (because bytes 0xc0 and 0xdb are escaped, worst case is
+          when the packet is all made of 0xc0 and 0xdb :) )
+          + 2 (0xc0 delimiters at start and end). */
+
+       nskb = alloc_skb((len + 6) * 2 + 2, GFP_ATOMIC);
+       if (!nskb)
+               return NULL;
+
+       bt_cb(nskb)->pkt_type = pkt_type;
+
+       h5_slip_msgdelim(nskb);
+
+       hdr[0] = h5->rxseq_txack << 3;
+       h5->txack_req = 0;
+
+       if (rel) {
+               hdr[0] |= 0x80 + h5->msgq_txseq;
+               BT_DBG("Sending packet with seqno %u\n", h5->msgq_txseq);
+       }
+
+       if (h5->use_crc)
+               hdr[0] |= 0x40;
+
+       hdr[1] = ((len << 4) & 0xff) | chan;
+       hdr[2] = len >> 4;
+       hdr[3] = ~(hdr[0] + hdr[1] + hdr[2]);
+
+       /* Put H5 header */
+       for (i = 0; i < 4; i++) {
+               h5_slip_one_byte(nskb, hdr[i]);
+
+               if (h5->use_crc) {
+                       h5_crc_update(&h5_txmsg_crc, hdr[i]);
+               }
+       }
+
+       /* Put payload */
+       for (i = 0; i < len; i++) {
+               h5_slip_one_byte(nskb, data[i]);
+
+               if (h5->use_crc) {
+                       h5_crc_update(&h5_txmsg_crc, data[i]);
+               }
+       }
+
+       /* Put CRC */
+       if (h5->use_crc) {
+               h5_txmsg_crc = bitrev16(h5_txmsg_crc);
+               h5_slip_one_byte(nskb, (u8) ((h5_txmsg_crc >> 8) & 0x00ff));
+               h5_slip_one_byte(nskb, (u8) (h5_txmsg_crc & 0x00ff));
+       }
+
+       h5_slip_msgdelim(nskb);
+
+       print_hex_dump_bytes("h5_tx ", DUMP_PREFIX_NONE, nskb->data, nskb->len);
+       return nskb;
+}
+
+/* This is a rewrite of pkt_avail in AH5 */
+static struct sk_buff *h5_dequeue(struct hci_uart *hu)
+{
+       struct h5_struct *h5 = hu->priv;
+       unsigned long flags;
+       struct sk_buff *skb;
+
+       /* First of all, check for unreliable messages in the queue,
+          since they have priority */
+
+       if ((skb = skb_dequeue(&h5->unrel)) != NULL) {
+               struct sk_buff *nskb = h5_prepare_pkt(h5, skb->data, skb->len, bt_cb(skb)->pkt_type);
+               if (nskb) {
+                       return nskb;
+               } else {
+                       skb_queue_head(&h5->unrel, skb);
+                       BT_ERR("Could not dequeue pkt because alloc_skb failed");
+               }
+       }
+
+       /* Now, try to send a reliable pkt. We can only send a
+          reliable packet if the number of packets sent but not yet ack'ed
+          is < than the winsize */
+
+       spin_lock_irqsave_nested(&h5->unack.lock, flags, SINGLE_DEPTH_NESTING);
+
+       if (h5->unack.qlen < H5_TXWINSIZE && (skb = skb_dequeue(&h5->rel)) != NULL) {
+               struct sk_buff *nskb = h5_prepare_pkt(h5, skb->data, skb->len, bt_cb(skb)->pkt_type);
+               if (nskb) {
+                       __skb_queue_tail(&h5->unack, skb);
+                       mod_timer(&h5->th5, jiffies + HZ / 4);
+                       spin_unlock_irqrestore(&h5->unack.lock, flags);
+                       return nskb;
+               } else {
+                       skb_queue_head(&h5->rel, skb);
+                       BT_ERR("Could not dequeue pkt because alloc_skb failed");
+               }
+       }
+
+       spin_unlock_irqrestore(&h5->unack.lock, flags);
+
+       /* We could not send a reliable packet, either because there are
+          none or because there are too many unack'ed pkts. Did we receive
+          any packets we have not acknowledged yet ? */
+
+       if (h5->txack_req) {
+               /* if so, craft an empty ACK pkt and send it on H5 unreliable
+                  channel 0 */
+               struct sk_buff *nskb = h5_prepare_pkt(h5, NULL, 0, H5_ACK_PKT);
+               return nskb;
+       }
+
+       /* We have nothing to send */
+       return NULL;
+}
+
+static int h5_flush(struct hci_uart *hu)
+{
+       BT_DBG("hu %p\n", hu);
+       return 0;
+}
+
+/* Remove ack'ed packets */
+static void h5_pkt_cull(struct h5_struct *h5)
+{
+       struct sk_buff *skb, *tmp;
+       unsigned long flags;
+       int i, pkts_to_be_removed;
+       u8 seqno;
+
+       spin_lock_irqsave(&h5->unack.lock, flags);
+
+       pkts_to_be_removed = skb_queue_len(&h5->unack);
+
+       seqno = h5->msgq_txseq;
+
+       while (pkts_to_be_removed) {
+               if (((h5->rxack - 1) & 0x07) == seqno)
+                       break;
+
+               pkts_to_be_removed--;
+               seqno = (seqno + 1) & 0x07;
+       }
+
+/*
+       if (h5->rxack != seqno)
+               BT_ERR("Peer acked invalid packet");
+*/
+
+       BT_DBG("Removing %u pkts out of %u, up to seqno %u\n",
+              pkts_to_be_removed, skb_queue_len(&h5->unack),
+              (seqno - 1) & 0x07);
+
+       i = 0;
+       skb_queue_walk_safe(&h5->unack, skb, tmp) {
+               if (i >= pkts_to_be_removed)
+                       break;
+               i++;
+
+               __skb_unlink(skb, &h5->unack);
+               kfree_skb(skb);
+       }
+
+       if (skb_queue_empty(&h5->unack))
+               del_timer(&h5->th5);
+
+       spin_unlock_irqrestore(&h5->unack.lock, flags);
+
+       if (i != pkts_to_be_removed)
+               BT_ERR("Removed only %u out of %u pkts", i, pkts_to_be_removed);
+}
+
+/* Handle H5 link-establishment packets. When we
+   detect a "sync" packet, symptom that the BT module has reset,
+   we do nothing :) (yet) */
+
+static void h5_handle_le_pkt(struct hci_uart *hu)
+{
+       struct h5_struct *h5 = hu->priv;
+       u8 conf_pkt[4]     = { 0xad, 0xef, 0xac, 0xed };
+       u8 conf_rsp_pkt[4] = { 0xde, 0xad, 0xd0, 0xd0 };
+       u8 sync_pkt[4]     = { 0x00, 0xd0, 0x01, 0x7e };
+
+       /* spot "conf" pkts and reply with a "conf rsp" pkt */
+       if (h5->rx_skb->data[1] >> 4 == 4 && h5->rx_skb->data[2] == 0 &&
+                       !memcmp(&h5->rx_skb->data[4], conf_pkt, 4)) {
+               struct sk_buff *nskb = alloc_skb(4, GFP_ATOMIC);
+
+               BT_DBG("Found a LE conf pkt\n");
+               if (!nskb)
+                       return;
+               memcpy(skb_put(nskb, 4), conf_rsp_pkt, 4);
+               bt_cb(nskb)->pkt_type = H5_LE_PKT;
+
+               skb_queue_head(&h5->unrel, nskb);
+               hci_uart_tx_wakeup(hu);
+       }
+       /* Spot "sync" pkts. If we find one...disaster! */
+       else if (h5->rx_skb->data[1] >> 4 == 4 && h5->rx_skb->data[2] == 0 &&
+                       !memcmp(&h5->rx_skb->data[4], sync_pkt, 4)) {
+               BT_ERR("Found a LE sync pkt, card has reset");
+       }
+}
+
+static inline void h5_unslip_one_byte(struct h5_struct *h5, unsigned char byte)
+{
+       const u8 c0 = 0xc0, db = 0xdb;
+
+       switch (h5->rx_esc_state) {
+       case H5_ESCSTATE_NOESC:
+               switch (byte) {
+               case 0xdb:
+                       h5->rx_esc_state = H5_ESCSTATE_ESC;
+                       break;
+               default:
+                       memcpy(skb_put(h5->rx_skb, 1), &byte, 1);
+                       if ((h5->rx_skb-> data[0] & 0x40) != 0 &&
+                                       h5->rx_state != H5_W4_CRC)
+                               h5_crc_update(&h5->message_crc, byte);
+                       h5->rx_count--;
+               }
+               break;
+
+       case H5_ESCSTATE_ESC:
+               switch (byte) {
+               case 0xdc:
+                       memcpy(skb_put(h5->rx_skb, 1), &c0, 1);
+                       if ((h5->rx_skb-> data[0] & 0x40) != 0 &&
+                                       h5->rx_state != H5_W4_CRC)
+                               h5_crc_update(&h5-> message_crc, 0xc0);
+                       h5->rx_esc_state = H5_ESCSTATE_NOESC;
+                       h5->rx_count--;
+                       break;
+
+               case 0xdd:
+                       memcpy(skb_put(h5->rx_skb, 1), &db, 1);
+                       if ((h5->rx_skb-> data[0] & 0x40) != 0 &&
+                                       h5->rx_state != H5_W4_CRC)
+                               h5_crc_update(&h5-> message_crc, 0xdb);
+                       h5->rx_esc_state = H5_ESCSTATE_NOESC;
+                       h5->rx_count--;
+                       break;
+
+               case 0xdf:
+                       memcpy(skb_put(h5->rx_skb, 1), &db, 1);
+                       if ((h5->rx_skb-> data[0] & 0x40) != 0 &&
+                                       h5->rx_state != H5_W4_CRC)
+                               h5_crc_update(&h5-> message_crc, 0x13);
+                       h5->rx_esc_state = H5_ESCSTATE_NOESC;
+                       h5->rx_count--;
+                       break;
+
+               case 0xde:
+                       memcpy(skb_put(h5->rx_skb, 1), &db, 1);
+                       if ((h5->rx_skb-> data[0] & 0x40) != 0 &&
+                                       h5->rx_state != H5_W4_CRC)
+                               h5_crc_update(&h5-> message_crc, 0x11);
+                       h5->rx_esc_state = H5_ESCSTATE_NOESC;
+                       h5->rx_count--;
+                       break;
+
+               default:
+                       BT_ERR ("Invalid byte %02x after esc byte", byte);
+                       kfree_skb(h5->rx_skb);
+                       h5->rx_skb = NULL;
+                       h5->rx_state = H5_W4_PKT_DELIMITER;
+                       h5->rx_count = 0;
+               }
+       }
+}
+
+static void h5_complete_rx_pkt(struct hci_uart *hu)
+{
+       struct h5_struct *h5 = hu->priv;
+       int pass_up;
+
+       if (h5->rx_skb->data[0] & 0x80) {       /* reliable pkt */
+               BT_DBG("Received seqno %u from card\n", h5->rxseq_txack);
+               h5->rxseq_txack++;
+               h5->rxseq_txack %= 0x8;
+               h5->txack_req    = 1;
+
+               /* If needed, transmit an ack pkt */
+               hci_uart_tx_wakeup(hu);
+       }
+
+       h5->rxack = (h5->rx_skb->data[0] >> 3) & 0x07;
+       BT_DBG("Request for pkt %u from card\n", h5->rxack);
+
+       h5_pkt_cull(h5);
+
+       if ((h5->rx_skb->data[1] & 0x0f) == 2 &&
+                       h5->rx_skb->data[0] & 0x80) {
+               bt_cb(h5->rx_skb)->pkt_type = HCI_ACLDATA_PKT;
+               pass_up = 1;
+       } else if ((h5->rx_skb->data[1] & 0x0f) == 4 &&
+                       h5->rx_skb->data[0] & 0x80) {
+               bt_cb(h5->rx_skb)->pkt_type = HCI_EVENT_PKT;
+               pass_up = 1;
+       } else if ((h5->rx_skb->data[1] & 0x0f) == 3) {
+               bt_cb(h5->rx_skb)->pkt_type = HCI_SCODATA_PKT;
+               pass_up = 1;
+       } else if ((h5->rx_skb->data[1] & 0x0f) == 15 &&
+                       !(h5->rx_skb->data[0] & 0x80)) {
+               h5_handle_le_pkt(hu);
+               pass_up = 0;
+       } else
+               pass_up = 0;
+
+       if (!pass_up) {
+               struct hci_event_hdr hdr;
+               u8 desc = (h5->rx_skb->data[1] & 0x0f);
+
+               if (desc != 0 && desc != 1) {
+                       if (h5extn) {
+                               desc |= 0xc0;
+                               skb_pull(h5->rx_skb, 4);
+                               memcpy(skb_push(h5->rx_skb, 1), &desc, 1);
+
+                               hdr.evt = 0xff;
+                               hdr.plen = h5->rx_skb->len;
+                               memcpy(skb_push(h5->rx_skb, HCI_EVENT_HDR_SIZE), &hdr, HCI_EVENT_HDR_SIZE);
+                               bt_cb(h5->rx_skb)->pkt_type = HCI_EVENT_PKT;
+
+                               hci_recv_frame(h5->rx_skb);
+                       } else {
+                               BT_ERR ("Packet for unknown channel (%u %s)",
+                                       h5->rx_skb->data[1] & 0x0f,
+                                       h5->rx_skb->data[0] & 0x80 ?
+                                       "reliable" : "unreliable");
+                               kfree_skb(h5->rx_skb);
+                       }
+               } else
+                       kfree_skb(h5->rx_skb);
+       } else {
+               /* Pull out H5 hdr */
+               skb_pull(h5->rx_skb, 4);
+
+               hci_recv_frame(h5->rx_skb);
+       }
+
+       h5->rx_state = H5_W4_PKT_DELIMITER;
+       h5->rx_skb = NULL;
+}
+
+static u16 h5_get_crc(struct h5_struct *h5)
+{
+       return get_unaligned_be16(&h5->rx_skb->data[h5->rx_skb->len - 2]);
+}
+
+/* Recv data */
+static int h5_recv(struct hci_uart *hu, void *data, int count)
+{
+       struct h5_struct *h5 = hu->priv;
+       register unsigned char *ptr;
+       int i;
+
+       BT_DBG("hu %p count %d rx_state %d rx_count %ld\n",
+               hu, count, h5->rx_state, h5->rx_count);
+
+       print_hex_dump_bytes("h5_recv ", DUMP_PREFIX_NONE, data, count);
+
+       ptr = data;
+
+       while (count) {
+               if (h5->rx_count) {
+                       if (*ptr == 0xc0) {
+                               BT_ERR("Short H5 packet");
+                               kfree_skb(h5->rx_skb);
+                               h5->rx_state = H5_W4_PKT_START;
+                               h5->rx_count = 0;
+                       } else
+                               h5_unslip_one_byte(h5, *ptr);
+
+                       ptr++; count--;
+                       continue;
+               }
+
+               switch (h5->rx_state) {
+               case H5_W4_H5_HDR:
+                       if ((0xff & (u8) ~ (h5->rx_skb->data[0] + h5->rx_skb->data[1] +
+                                       h5->rx_skb->data[2])) != h5->rx_skb->data[3]) {
+                               BT_ERR("Error in H5 hdr checksum");
+                               kfree_skb(h5->rx_skb);
+                               h5->rx_state = H5_W4_PKT_DELIMITER;
+                               h5->rx_count = 0;
+                               continue;
+                       }
+
+
+                       if (h5->rx_skb->data[0] & 0x80) {       /* reliable pkt */
+                               printk("%0x != %0x ? %d\n", h5->rx_skb->data[0] & 0x07,
+                                       h5->rxseq_txack,
+                                       (h5->rx_skb->data[0] & 0x07) != h5->rxseq_txack);
+
+                               if ((h5->rx_skb->data[0] & 0x07) != h5->rxseq_txack) {
+                                       BT_ERR ("Out-of-order packet arrived, got %u expected %u",
+                                               h5->rx_skb->data[0] & 0x07, h5->rxseq_txack);
+
+                                       kfree_skb(h5->rx_skb);
+                                       h5->rx_state = H5_W4_PKT_DELIMITER;
+                                       h5->rx_count = 0;
+                                       continue;
+                               }
+                       }
+
+                       h5->rx_state = H5_W4_DATA;
+                       h5->rx_count = (h5->rx_skb->data[1] >> 4) +
+                                       (h5->rx_skb->data[2] << 4);     /* May be 0 */
+                       continue;
+
+               case H5_W4_DATA:
+                       if (h5->rx_skb->data[0] & 0x40) {       /* pkt with crc */
+                               // h5->rx_state = H5_W4_CRC1;
+                               h5->rx_state = H5_W4_CRC;
+                               h5->rx_count = 2;
+                       } else {
+                               h5_complete_rx_pkt(hu);
+                       }
+
+                       continue;
+
+               case H5_W4_CRC1:
+                       h5->rx_state = H5_W4_CRC;
+                       count--;
+                       continue;
+
+               case H5_W4_CRC:
+                       if (bitrev16(h5->message_crc) != h5_get_crc(h5)) {
+                               BT_ERR ("Checksum failed: computed %04x received %04x",
+                                       bitrev16(h5->message_crc),
+                                       h5_get_crc(h5));
+
+                               kfree_skb(h5->rx_skb);
+                               h5->rx_state = H5_W4_PKT_DELIMITER;
+                               h5->rx_count = 0;
+                               continue;
+                       }
+
+                       skb_trim(h5->rx_skb, h5->rx_skb->len - 2);
+                       h5_complete_rx_pkt(hu);
+                       h5->rx_state = H5_W4_PKT_DELIMITER;
+                       count--;
+                       continue;
+
+               case H5_W4_PKT_DELIMITER:
+                       switch (*ptr) {
+                       case 0xc0:
+                               h5->rx_state = H5_W4_PKT_START;
+                               break;
+                       default:
+                               /*BT_ERR("Ignoring byte %02x", *ptr);*/
+                               break;
+                       }
+                       ptr++; count--;
+                       break;
+
+               case H5_W4_PKT_START:
+                       switch (*ptr) {
+                       case 0xc0:
+                               ptr++; count--;
+                               break;
+
+                       default:
+                               h5->rx_state = H5_W4_H5_HDR;
+                               h5->rx_count = 4;
+                               h5->rx_esc_state = H5_ESCSTATE_NOESC;
+                               H5_CRC_INIT(h5->message_crc);
+
+                               /* Do not increment ptr or decrement count
+                                * Allocate packet. Max len of a H5 pkt=
+                                * 0xFFF (payload) +4 (header) +2 (crc) */
+
+                               h5->rx_skb = bt_skb_alloc(0x1005, GFP_ATOMIC);
+                               if (!h5->rx_skb) {
+                                       BT_ERR("Can't allocate mem for new packet");
+                                       h5->rx_state = H5_W4_PKT_DELIMITER;
+                                       h5->rx_count = 0;
+                                       return 0;
+                               }
+                               h5->rx_skb->dev = (void *) hu->hdev;
+                               break;
+                       }
+                       break;
+               }
+       }
+       return count;
+}
+
+static int h5_timed_event(unsigned long arg)
+{
+       struct hci_uart *hu = (struct hci_uart *) arg;
+       struct h5_struct *h5 = hu->priv;
+       struct sk_buff *skb;
+       unsigned long flags;
+
+       BT_DBG("hu %p retransmitting %u pkts\n", hu, h5->unack.qlen);
+
+       spin_lock_irqsave_nested(&h5->unack.lock, flags, SINGLE_DEPTH_NESTING);
+
+       while ((skb = __skb_dequeue_tail(&h5->unack)) != NULL) {
+               h5->msgq_txseq = (h5->msgq_txseq - 1) & 0x07;
+               skb_queue_head(&h5->rel, skb);
+       }
+
+       spin_unlock_irqrestore(&h5->unack.lock, flags);
+
+       hci_uart_tx_wakeup(hu);
+}
+
+static int h5_open(struct hci_uart *hu)
+{
+       struct h5_struct *h5;
+
+       BT_DBG("hu %p\n", hu);
+
+       h5 = kzalloc(sizeof(*h5), GFP_ATOMIC);
+       if (!h5)
+               return -ENOMEM;
+
+       hu->priv = h5;
+       skb_queue_head_init(&h5->unack);
+       skb_queue_head_init(&h5->rel);
+       skb_queue_head_init(&h5->unrel);
+
+       init_timer(&h5->th5);
+       h5->th5.function = h5_timed_event;
+       h5->th5.data     = (u_long) hu;
+
+       h5->rx_state = H5_W4_PKT_DELIMITER;
+
+       if (h5txcrc)
+               h5->use_crc = 1;
+
+       return 0;
+}
+
+static int h5_close(struct hci_uart *hu)
+{
+       struct h5_struct *h5 = hu->priv;
+       hu->priv = NULL;
+
+       BT_DBG("hu %p\n", hu);
+
+       skb_queue_purge(&h5->unack);
+       skb_queue_purge(&h5->rel);
+       skb_queue_purge(&h5->unrel);
+       del_timer(&h5->th5);
+
+       kfree(h5);
+       return 0;
+}
+
+static struct hci_uart_proto h5 = {
+       .id             = HCI_UART_H5,
+       .open           = h5_open,
+       .close          = h5_close,
+       .enqueue        = h5_enqueue,
+       .dequeue        = h5_dequeue,
+       .recv           = h5_recv,
+       .flush          = h5_flush
+};
+
+int h5_init(void)
+{
+       int err = hci_uart_register_proto(&h5);
+
+       if (!err)
+               BT_INFO("HCI H5 protocol initialized");
+       else
+               BT_ERR("HCI H5 protocol registration failed");
+
+       return err;
+}
+
+int h5_deinit(void)
+{
+       return hci_uart_unregister_proto(&h5);
+}
+
+module_param(h5txcrc, bool, 0644);
+MODULE_PARM_DESC(h5txcrc, "Transmit CRC with every H5 packet");
+
+module_param(h5extn, bool, 0644);
+MODULE_PARM_DESC(h5extn, "Convert HCI Extensions into H5 packets");
diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 283b127..8099d9e 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -47,6 +47,8 @@
 #include "hci_uart.h"

 #define VERSION "2.2"
+#undef BT_DBG
+#define BT_DBG printk

 static int reset = 0;

@@ -123,13 +125,14 @@ int hci_uart_tx_wakeup(struct hci_uart *hu)
        struct tty_struct *tty = hu->tty;
        struct hci_dev *hdev = hu->hdev;
        struct sk_buff *skb;
+       int i;

        if (test_and_set_bit(HCI_UART_SENDING, &hu->tx_state)) {
                set_bit(HCI_UART_TX_WAKEUP, &hu->tx_state);
                return 0;
        }

-       BT_DBG("");
+       BT_DBG("\n");

 restart:
        clear_bit(HCI_UART_TX_WAKEUP, &hu->tx_state);
@@ -138,6 +141,7 @@ restart:
                int len;

                set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
+
                len = tty->ops->write(tty, skb->data, skb->len);
                hdev->stat.byte_tx += len;

@@ -162,7 +166,7 @@ restart:
 /* Initialize device */
 static int hci_uart_open(struct hci_dev *hdev)
 {
-       BT_DBG("%s %p", hdev->name, hdev);
+       BT_DBG("%s %p\n", hdev->name, hdev);

        /* Nothing to do for UART driver */

@@ -177,7 +181,7 @@ static int hci_uart_flush(struct hci_dev *hdev)
        struct hci_uart *hu  = (struct hci_uart *) hdev->driver_data;
        struct tty_struct *tty = hu->tty;

-       BT_DBG("hdev %p tty %p", hdev, tty);
+       BT_DBG("hdev %p tty %p\n", hdev, tty);

        if (hu->tx_skb) {
                kfree_skb(hu->tx_skb); hu->tx_skb = NULL;
@@ -196,7 +200,7 @@ static int hci_uart_flush(struct hci_dev *hdev)
 /* Close device */
 static int hci_uart_close(struct hci_dev *hdev)
 {
-       BT_DBG("hdev %p", hdev);
+       BT_DBG("hdev %p\n", hdev);

        if (!test_and_clear_bit(HCI_RUNNING, &hdev->flags))
                return 0;
@@ -224,7 +228,7 @@ static int hci_uart_send_frame(struct sk_buff *skb)
        hu = (struct hci_uart *) hdev->driver_data;
        tty = hu->tty;

-       BT_DBG("%s: type %d len %d", hdev->name, bt_cb(skb)->pkt_type, skb->len);
+       BT_DBG("%s: type %d len %d\n", hdev->name, bt_cb(skb)->pkt_type, skb->len);

        hu->proto->enqueue(hu, skb);

@@ -238,7 +242,7 @@ static void hci_uart_destruct(struct hci_dev *hdev)
        if (!hdev)
                return;

-       BT_DBG("%s", hdev->name);
+       BT_DBG("%s\n", hdev->name);
        kfree(hdev->driver_data);
 }

@@ -256,7 +260,7 @@ static int hci_uart_tty_open(struct tty_struct *tty)
 {
        struct hci_uart *hu = (void *) tty->disc_data;

-       BT_DBG("tty %p", tty);
+       BT_DBG("tty %p\n", tty);

        /* FIXME: This btw is bogus, nothing requires the old ldisc to clear
           the pointer */
@@ -300,7 +304,7 @@ static void hci_uart_tty_close(struct tty_struct *tty)
 {
        struct hci_uart *hu = (void *)tty->disc_data;

-       BT_DBG("tty %p", tty);
+       BT_DBG("tty %p\n", tty);

        /* Detach from the tty */
        tty->disc_data = NULL;
@@ -331,7 +335,7 @@ static void hci_uart_tty_wakeup(struct tty_struct *tty)
 {
        struct hci_uart *hu = (void *)tty->disc_data;

-       BT_DBG("");
+       BT_DBG("\n");

        if (!hu)
                return;
@@ -379,7 +383,7 @@ static int hci_uart_register_dev(struct hci_uart *hu)
 {
        struct hci_dev *hdev;

-       BT_DBG("");
+       BT_DBG("\n");

        /* Initialize and register HCI device */
        hdev = hci_alloc_dev();
@@ -456,7 +460,7 @@ static int hci_uart_tty_ioctl(struct tty_struct *tty, struct file * file,
        struct hci_uart *hu = (void *)tty->disc_data;
        int err = 0;

-       BT_DBG("");
+       BT_DBG("\n");

        /* Verify the status of the device */
        if (!hu)
@@ -549,6 +553,9 @@ static int __init hci_uart_init(void)
 #ifdef CONFIG_BT_HCIUART_LL
        ll_init();
 #endif
+#ifdef CONFIG_BT_HCIUART_H5
+       h5_init();
+#endif

        return 0;
 }
@@ -566,6 +573,9 @@ static void __exit hci_uart_exit(void)
 #ifdef CONFIG_BT_HCIUART_LL
        ll_deinit();
 #endif
+#ifdef CONFIG_BT_HCIUART_H5
+       h5_deinit();
+#endif

        /* Release tty registration of line discipline */
        if ((err = tty_unregister_ldisc(N_HCI)))
diff --git a/drivers/bluetooth/hci_uart.h b/drivers/bluetooth/hci_uart.h
index 50113db..0c40dab 100644
--- a/drivers/bluetooth/hci_uart.h
+++ b/drivers/bluetooth/hci_uart.h
@@ -33,13 +33,14 @@
 #define HCIUARTGETDEVICE       _IOR('U', 202, int)

 /* UART protocols */
-#define HCI_UART_MAX_PROTO     5
+#define HCI_UART_MAX_PROTO     6

 #define HCI_UART_H4    0
 #define HCI_UART_BCSP  1
 #define HCI_UART_3WIRE 2
 #define HCI_UART_H4DS  3
 #define HCI_UART_LL    4
+#define HCI_UART_H5    5

 struct hci_uart;

@@ -91,3 +92,8 @@ int bcsp_deinit(void);
 int ll_init(void);
 int ll_deinit(void);
 #endif
+
+#ifdef CONFIG_BT_HCIUART_H5
+int h5_init(void);
+int h5_deinit(void);
+#endif
--
1.7.1


>From d2d680c57f9e09cc574faf0c4153aacc007035bd Mon Sep 17 00:00:00 2001
From: Mark P. Mendelsohn <mpm>
Date: Thu, 11 Aug 2011 10:55:02 -0700
Subject: [PATCH 02/10] add flow control escape characters

---
 drivers/bluetooth/hci_h5.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index e2a1f69..a2a97cc 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -434,9 +434,10 @@ static void h5_handle_le_pkt(struct hci_uart *hu)
        }
 }

+
 static inline void h5_unslip_one_byte(struct h5_struct *h5, unsigned char byte)
 {
-       const u8 c0 = 0xc0, db = 0xdb;
+       const u8 c0 = 0xc0, db = 0xdb, oneone = 0x11, onethree = 0x13;

        switch (h5->rx_esc_state) {
        case H5_ESCSTATE_NOESC:
@@ -473,20 +474,20 @@ static inline void h5_unslip_one_byte(struct h5_struct *h5, unsigned char byte)
                        h5->rx_count--;
                        break;

-               case 0xdf:
-                       memcpy(skb_put(h5->rx_skb, 1), &db, 1);
+               case 0xde:
+                       memcpy(skb_put(h5->rx_skb, 1), &oneone, 1);
                        if ((h5->rx_skb-> data[0] & 0x40) != 0 &&
                                        h5->rx_state != H5_W4_CRC)
-                               h5_crc_update(&h5-> message_crc, 0x13);
+                               h5_crc_update(&h5-> message_crc, 0x11);
                        h5->rx_esc_state = H5_ESCSTATE_NOESC;
                        h5->rx_count--;
                        break;

-               case 0xde:
-                       memcpy(skb_put(h5->rx_skb, 1), &db, 1);
+               case 0xdf:
+                       memcpy(skb_put(h5->rx_skb, 1), &onethree, 1);
                        if ((h5->rx_skb-> data[0] & 0x40) != 0 &&
                                        h5->rx_state != H5_W4_CRC)
-                               h5_crc_update(&h5-> message_crc, 0x11);
+                               h5_crc_update(&h5-> message_crc, 0x13);
                        h5->rx_esc_state = H5_ESCSTATE_NOESC;
                        h5->rx_count--;
                        break;
@@ -577,7 +578,7 @@ static void h5_complete_rx_pkt(struct hci_uart *hu)

 static u16 h5_get_crc(struct h5_struct *h5)
 {
-       return get_unaligned_be16(&h5->rx_skb->data[h5->rx_skb->len - 2]);
+       return(get_unaligned_be16(&h5->rx_skb->data[h5->rx_skb->len - 2]));
 }

 /* Recv data */
@@ -668,7 +669,6 @@ static int h5_recv(struct hci_uart *hu, void *data, int count)
                                h5->rx_count = 0;
                                continue;
                        }
-
                        skb_trim(h5->rx_skb, h5->rx_skb->len - 2);
                        h5_complete_rx_pkt(hu);
                        h5->rx_state = H5_W4_PKT_DELIMITER;
--
1.7.1


>From 07e40bafb21cc61c59dac90a308639f18487d00f Mon Sep 17 00:00:00 2001
From: Mark P. Mendelsohn <mpm>
Date: Thu, 11 Aug 2011 11:12:03 -0700
Subject: [PATCH 03/10] add flow control escape characters for tx

---
 drivers/bluetooth/hci_h5.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index a2a97cc..0168269 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -139,6 +139,8 @@ static void h5_slip_one_byte(struct sk_buff *skb, u8 c)
 {
        const char esc_c0[2] = { 0xdb, 0xdc };
        const char esc_db[2] = { 0xdb, 0xdd };
+       const char esc_oneone[2] = { 0xdb, 0xde };
+       const char esc_onethree[2] = { 0xdb, 0xdf };

        switch (c) {
        case 0xc0:
@@ -147,6 +149,12 @@ static void h5_slip_one_byte(struct sk_buff *skb, u8 c)
        case 0xdb:
                memcpy(skb_put(skb, 2), &esc_db, 2);
                break;
+       case 0x11:
+               memcpy(skb_put(skb, 2), &esc_oneone, 2);
+               break;
+       case 0x13:
+               memcpy(skb_put(skb, 2), &esc_onethree, 2);
+               break;
        default:
                memcpy(skb_put(skb, 1), &c, 1);
        }
--
1.7.1


>From c42f8bb513986054504e5c122a0f7597066dc15b Mon Sep 17 00:00:00 2001
From: Mark P. Mendelsohn <mpm>
Date: Wed, 17 Aug 2011 15:12:17 -0700
Subject: [PATCH 04/10] added sleep mode

---
 drivers/bluetooth/hci_h5.c |  101 +++++++++++++++++++++++++++++++++++---------
 1 files changed, 81 insertions(+), 20 deletions(-)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index 0168269..265a9c5 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -61,6 +61,10 @@ static int h5extn = 1;
 #define H5_ACK_PKT     0x00
 #define H5_LE_PKT      0x0f

+static u8 h5_wakeup_msg[] = { 0x05, 0xfa };
+static u8 h5_woken_msg[] = { 0x06, 0xf9 };
+static u8 h5_sleep_msg[] = { 0x07, 0x78 };
+
 struct h5_struct {
        struct sk_buff_head unack;      /* Unack'ed packets queue */
        struct sk_buff_head rel;        /* Reliable packets queue */
@@ -92,8 +96,53 @@ struct h5_struct {

        /* Reliable packet sequence number - used to assign seq to each rel pkt. */
        u8      msgq_txseq;
+
+       u8 sleep_state;
+       u8 is_there_activity;
+       u16 inactive_period;
+};
+
+enum sleep_states {
+       H5_ASLEEP,
+       H5_ASLEEP_TO_AWAKE,
+       H5_AWAKE,
+       H5_AWAKE_TO_ASLEEP
 };

+#define TIMER_PERIOD 100
+#define HOST_CONTROLLER_IDLE_THRSH 4000
+
+static struct timer_list sleep_timer;
+
+extern struct sk_buff *h5_prepare_pkt(struct h5_struct *h5, u8 *data,
+               int len, int pkt_type);
+
+//
+//     Timeout Handler
+//
+
+void sleep_timer_function(unsigned long data)
+{
+       struct h5_struct *lh5 = (struct h5_struct *)data;
+
+       if (lh5->is_there_activity) {
+               lh5->is_there_activity = 0;
+               lh5->inactive_period = 0;
+       } else if (lh5->sleep_state != H5_ASLEEP) {
+               lh5->inactive_period += TIMER_PERIOD;
+
+               if (lh5->inactive_period >= HOST_CONTROLLER_IDLE_THRSH) {
+                       BT_DBG("moves to ASLEEP");
+                       lh5->sleep_state = H5_ASLEEP;
+                       lh5->inactive_period = 0;
+                       struct sk_buff *nskb = h5_prepare_pkt(lh5, h5_sleep_msg, sizeof(h5_sleep_msg), 15);
+                       skb_queue_tail(&lh5->unrel, nskb);
+               }
+       }
+
+       mod_timer(&sleep_timer, jiffies + TIMER_PERIOD * HZ / 1000);
+}
+
 /* ---- H5 CRC calculation ---- */

 /* Table for calculating CRC for polynomial 0x1021, LSB processed first,
@@ -170,6 +219,14 @@ static int h5_enqueue(struct hci_uart *hu, struct sk_buff *skb)
                return 0;
        }

+       h5->is_there_activity = 1;
+
+       if (h5->sleep_state == H5_ASLEEP) {
+               struct sk_buff *nskb = h5_prepare_pkt(h5, h5_wakeup_msg, sizeof(h5_wakeup_msg), 15);
+               skb_queue_tail(&h5->unrel, skb);
+               h5->sleep_state = H5_AWAKE;
+       }
+
        switch (bt_cb(skb)->pkt_type) {
        case HCI_ACLDATA_PKT:
        case HCI_COMMAND_PKT:
@@ -189,7 +246,7 @@ static int h5_enqueue(struct hci_uart *hu, struct sk_buff *skb)
        return 0;
 }

-static struct sk_buff *h5_prepare_pkt(struct h5_struct *h5, u8 *data,
+struct sk_buff *h5_prepare_pkt(struct h5_struct *h5, u8 *data,
                int len, int pkt_type)
 {
        struct sk_buff *nskb;
@@ -357,6 +414,7 @@ static struct sk_buff *h5_dequeue(struct hci_uart *hu)
 static int h5_flush(struct hci_uart *hu)
 {
        BT_DBG("hu %p\n", hu);
+       del_timer_sync(&sleep_timer);
        return 0;
 }

@@ -417,28 +475,22 @@ static void h5_pkt_cull(struct h5_struct *h5)
 static void h5_handle_le_pkt(struct hci_uart *hu)
 {
        struct h5_struct *h5 = hu->priv;
-       u8 conf_pkt[4]     = { 0xad, 0xef, 0xac, 0xed };
-       u8 conf_rsp_pkt[4] = { 0xde, 0xad, 0xd0, 0xd0 };
-       u8 sync_pkt[4]     = { 0x00, 0xd0, 0x01, 0x7e };
-
-       /* spot "conf" pkts and reply with a "conf rsp" pkt */
-       if (h5->rx_skb->data[1] >> 4 == 4 && h5->rx_skb->data[2] == 0 &&
-                       !memcmp(&h5->rx_skb->data[4], conf_pkt, 4)) {
-               struct sk_buff *nskb = alloc_skb(4, GFP_ATOMIC);
-
-               BT_DBG("Found a LE conf pkt\n");
-               if (!nskb)
-                       return;
-               memcpy(skb_put(nskb, 4), conf_rsp_pkt, 4);
-               bt_cb(nskb)->pkt_type = H5_LE_PKT;
+       u8 wakeup_pkt[]     = { 0x05, 0xfa };
+       u8 woken_pkt[]     = { 0x06, 0xf9 };
+
+       struct sk_buff *nskb = alloc_skb(4, GFP_ATOMIC);
+
+       BT_DBG("Found a LE pkt\n");

+       if (!nskb)
+               return;
+
+       if (!memcmp(&h5->rx_skb->data[4], wakeup_pkt, 2)) {
+               memcpy(skb_put(nskb, 2), woken_pkt, 2);
+               bt_cb(nskb)->pkt_type = H5_LE_PKT;
                skb_queue_head(&h5->unrel, nskb);
                hci_uart_tx_wakeup(hu);
-       }
-       /* Spot "sync" pkts. If we find one...disaster! */
-       else if (h5->rx_skb->data[1] >> 4 == 4 && h5->rx_skb->data[2] == 0 &&
-                       !memcmp(&h5->rx_skb->data[4], sync_pkt, 4)) {
-               BT_ERR("Found a LE sync pkt, card has reset");
+       } else if (!memcmp(&h5->rx_skb->data[4], woken_pkt, 2)) {
        }
 }

@@ -772,6 +824,15 @@ static int h5_open(struct hci_uart *hu)
        if (h5txcrc)
                h5->use_crc = 1;

+       init_timer(&sleep_timer);
+
+       sleep_timer.expires = jiffies + TIMER_PERIOD * HZ / 1000;
+       sleep_timer.data = (unsigned long)h5;
+       sleep_timer.function = sleep_timer_function;
+
+       add_timer(&sleep_timer);
+       h5->is_there_activity = 0;
+
        return 0;
 }

--
1.7.1


>From f9915f77dfbcb703ca098a7a0ace91fab3f686e8 Mon Sep 17 00:00:00 2001
From: Mark P. Mendelsohn <mpm>
Date: Mon, 22 Aug 2011 11:42:10 -0700
Subject: [PATCH 05/10] fixed seqno issues

---
 drivers/bluetooth/hci_h5.c |  113 +++++++++++---------------------------------
 1 files changed, 28 insertions(+), 85 deletions(-)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index 265a9c5..88ad715 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -61,10 +61,6 @@ static int h5extn = 1;
 #define H5_ACK_PKT     0x00
 #define H5_LE_PKT      0x0f

-static u8 h5_wakeup_msg[] = { 0x05, 0xfa };
-static u8 h5_woken_msg[] = { 0x06, 0xf9 };
-static u8 h5_sleep_msg[] = { 0x07, 0x78 };
-
 struct h5_struct {
        struct sk_buff_head unack;      /* Unack'ed packets queue */
        struct sk_buff_head rel;        /* Reliable packets queue */
@@ -96,53 +92,8 @@ struct h5_struct {

        /* Reliable packet sequence number - used to assign seq to each rel pkt. */
        u8      msgq_txseq;
-
-       u8 sleep_state;
-       u8 is_there_activity;
-       u16 inactive_period;
-};
-
-enum sleep_states {
-       H5_ASLEEP,
-       H5_ASLEEP_TO_AWAKE,
-       H5_AWAKE,
-       H5_AWAKE_TO_ASLEEP
 };

-#define TIMER_PERIOD 100
-#define HOST_CONTROLLER_IDLE_THRSH 4000
-
-static struct timer_list sleep_timer;
-
-extern struct sk_buff *h5_prepare_pkt(struct h5_struct *h5, u8 *data,
-               int len, int pkt_type);
-
-//
-//     Timeout Handler
-//
-
-void sleep_timer_function(unsigned long data)
-{
-       struct h5_struct *lh5 = (struct h5_struct *)data;
-
-       if (lh5->is_there_activity) {
-               lh5->is_there_activity = 0;
-               lh5->inactive_period = 0;
-       } else if (lh5->sleep_state != H5_ASLEEP) {
-               lh5->inactive_period += TIMER_PERIOD;
-
-               if (lh5->inactive_period >= HOST_CONTROLLER_IDLE_THRSH) {
-                       BT_DBG("moves to ASLEEP");
-                       lh5->sleep_state = H5_ASLEEP;
-                       lh5->inactive_period = 0;
-                       struct sk_buff *nskb = h5_prepare_pkt(lh5, h5_sleep_msg, sizeof(h5_sleep_msg), 15);
-                       skb_queue_tail(&lh5->unrel, nskb);
-               }
-       }
-
-       mod_timer(&sleep_timer, jiffies + TIMER_PERIOD * HZ / 1000);
-}
-
 /* ---- H5 CRC calculation ---- */

 /* Table for calculating CRC for polynomial 0x1021, LSB processed first,
@@ -219,14 +170,6 @@ static int h5_enqueue(struct hci_uart *hu, struct sk_buff *skb)
                return 0;
        }

-       h5->is_there_activity = 1;
-
-       if (h5->sleep_state == H5_ASLEEP) {
-               struct sk_buff *nskb = h5_prepare_pkt(h5, h5_wakeup_msg, sizeof(h5_wakeup_msg), 15);
-               skb_queue_tail(&h5->unrel, skb);
-               h5->sleep_state = H5_AWAKE;
-       }
-
        switch (bt_cb(skb)->pkt_type) {
        case HCI_ACLDATA_PKT:
        case HCI_COMMAND_PKT:
@@ -246,7 +189,7 @@ static int h5_enqueue(struct hci_uart *hu, struct sk_buff *skb)
        return 0;
 }

-struct sk_buff *h5_prepare_pkt(struct h5_struct *h5, u8 *data,
+static struct sk_buff *h5_prepare_pkt(struct h5_struct *h5, u8 *data,
                int len, int pkt_type)
 {
        struct sk_buff *nskb;
@@ -315,6 +258,7 @@ struct sk_buff *h5_prepare_pkt(struct h5_struct *h5, u8 *data,
        if (rel) {
                hdr[0] |= 0x80 + h5->msgq_txseq;
                BT_DBG("Sending packet with seqno %u\n", h5->msgq_txseq);
+               h5->msgq_txseq = (h5->msgq_txseq + 1) & 0x07;
        }

        if (h5->use_crc)
@@ -414,7 +358,6 @@ static struct sk_buff *h5_dequeue(struct hci_uart *hu)
 static int h5_flush(struct hci_uart *hu)
 {
        BT_DBG("hu %p\n", hu);
-       del_timer_sync(&sleep_timer);
        return 0;
 }

@@ -430,20 +373,23 @@ static void h5_pkt_cull(struct h5_struct *h5)

        pkts_to_be_removed = skb_queue_len(&h5->unack);

+       printk("%s: unack len %d\n", pkts_to_be_removed);
+
        seqno = h5->msgq_txseq;

        while (pkts_to_be_removed) {
-               if (((h5->rxack - 1) & 0x07) == seqno)
+               printk("ack %d seq %d\n", h5->rxack, seqno);
+               if (h5->rxack == seqno)
                        break;

                pkts_to_be_removed--;
-               seqno = (seqno + 1) & 0x07;
+               seqno = (seqno - 1) & 0x07;
        }

-/*
+       printk("seqno now %d\n", seqno);
+
        if (h5->rxack != seqno)
                BT_ERR("Peer acked invalid packet");
-*/

        BT_DBG("Removing %u pkts out of %u, up to seqno %u\n",
               pkts_to_be_removed, skb_queue_len(&h5->unack),
@@ -475,22 +421,28 @@ static void h5_pkt_cull(struct h5_struct *h5)
 static void h5_handle_le_pkt(struct hci_uart *hu)
 {
        struct h5_struct *h5 = hu->priv;
-       u8 wakeup_pkt[]     = { 0x05, 0xfa };
-       u8 woken_pkt[]     = { 0x06, 0xf9 };
-
-       struct sk_buff *nskb = alloc_skb(4, GFP_ATOMIC);
-
-       BT_DBG("Found a LE pkt\n");
-
-       if (!nskb)
-               return;
-
-       if (!memcmp(&h5->rx_skb->data[4], wakeup_pkt, 2)) {
-               memcpy(skb_put(nskb, 2), woken_pkt, 2);
+       u8 conf_pkt[4]     = { 0xad, 0xef, 0xac, 0xed };
+       u8 conf_rsp_pkt[4] = { 0xde, 0xad, 0xd0, 0xd0 };
+       u8 sync_pkt[4]     = { 0x00, 0xd0, 0x01, 0x7e };
+
+       /* spot "conf" pkts and reply with a "conf rsp" pkt */
+       if (h5->rx_skb->data[1] >> 4 == 4 && h5->rx_skb->data[2] == 0 &&
+                       !memcmp(&h5->rx_skb->data[4], conf_pkt, 4)) {
+               struct sk_buff *nskb = alloc_skb(4, GFP_ATOMIC);
+
+               BT_DBG("Found a LE conf pkt\n");
+               if (!nskb)
+                       return;
+               memcpy(skb_put(nskb, 4), conf_rsp_pkt, 4);
                bt_cb(nskb)->pkt_type = H5_LE_PKT;
+
                skb_queue_head(&h5->unrel, nskb);
                hci_uart_tx_wakeup(hu);
-       } else if (!memcmp(&h5->rx_skb->data[4], woken_pkt, 2)) {
+       }
+       /* Spot "sync" pkts. If we find one...disaster! */
+       else if (h5->rx_skb->data[1] >> 4 == 4 && h5->rx_skb->data[2] == 0 &&
+                       !memcmp(&h5->rx_skb->data[4], sync_pkt, 4)) {
+               BT_ERR("Found a LE sync pkt, card has reset");
        }
 }

@@ -824,15 +776,6 @@ static int h5_open(struct hci_uart *hu)
        if (h5txcrc)
                h5->use_crc = 1;

-       init_timer(&sleep_timer);
-
-       sleep_timer.expires = jiffies + TIMER_PERIOD * HZ / 1000;
-       sleep_timer.data = (unsigned long)h5;
-       sleep_timer.function = sleep_timer_function;
-
-       add_timer(&sleep_timer);
-       h5->is_there_activity = 0;
-
        return 0;
 }

--
1.7.1


>From e0eae63d62db4365130df405bdc3ede6b153008b Mon Sep 17 00:00:00 2001
From: Mark P. Mendelsohn <mpm>
Date: Mon, 12 Sep 2011 11:05:15 -0700
Subject: [PATCH 06/10] send VSC over packet type 01 instead of packet type 14

---
 drivers/bluetooth/hci_h5.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index 88ad715..a661ff3 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -197,6 +197,7 @@ static struct sk_buff *h5_prepare_pkt(struct h5_struct *h5, u8 *data,
        u16 H5_CRC_INIT(h5_txmsg_crc);
        int rel, i;

+       printk("%s pkt_type %d\n", __func__, pkt_type);
        print_hex_dump_bytes("h5_prepare_pkt ", DUMP_PREFIX_NONE, data, len);

        switch (pkt_type) {
@@ -225,11 +226,13 @@ static struct sk_buff *h5_prepare_pkt(struct h5_struct *h5, u8 *data,
                return NULL;
        }

-       if (h5extn && chan == 14) {
+       if (h5extn && chan == 1) {
                __le16 opcode = ((struct hci_command_hdr *)data)->opcode;

                /* Vendor specific commands */
                if (hci_opcode_ogf(__le16_to_cpu(opcode)) == 0x3f) {
+                       chan = 1;
+
                        u8 desc = *(data + HCI_COMMAND_HDR_SIZE);
                        if ((desc & 0xf0) == 0xc0) {
                                data += HCI_COMMAND_HDR_SIZE + 1;
@@ -608,6 +611,8 @@ static int h5_recv(struct hci_uart *hu, void *data, int count)
        ptr = data;

        while (count) {
+               // printk("while count %d rx_count %d\n", count, h5->rx_count);
+
                if (h5->rx_count) {
                        if (*ptr == 0xc0) {
                                BT_ERR("Short H5 packet");
@@ -621,6 +626,8 @@ static int h5_recv(struct hci_uart *hu, void *data, int count)
                        continue;
                }

+               // printk("switch state %d\n", h5->rx_state);
+
                switch (h5->rx_state) {
                case H5_W4_H5_HDR:
                        if ((0xff & (u8) ~ (h5->rx_skb->data[0] + h5->rx_skb->data[1] +
--
1.7.1


>From 428d90aef9bca3d50fe273f5f3d8864605bf5e3b Mon Sep 17 00:00:00 2001
From: Mark P. Mendelsohn <mpm>
Date: Fri, 23 Sep 2011 13:01:30 -0700
Subject: [PATCH 07/10] remove DEBUG for open source release

---
 drivers/bluetooth/hci_h5.c |   49 +++++++++++++++++++++++++++++++++++---------
 1 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index a661ff3..7a40565 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -77,7 +77,6 @@ struct h5_struct {
                H5_W4_PKT_START,
                H5_W4_H5_HDR,
                H5_W4_DATA,
-               H5_W4_CRC1,
                H5_W4_CRC
        } rx_state;

@@ -197,8 +196,10 @@ static struct sk_buff *h5_prepare_pkt(struct h5_struct *h5, u8 *data,
        u16 H5_CRC_INIT(h5_txmsg_crc);
        int rel, i;

+#ifdef DEBUG
        printk("%s pkt_type %d\n", __func__, pkt_type);
        print_hex_dump_bytes("h5_prepare_pkt ", DUMP_PREFIX_NONE, data, len);
+#endif

        switch (pkt_type) {
        case HCI_ACLDATA_PKT:
@@ -376,12 +377,16 @@ static void h5_pkt_cull(struct h5_struct *h5)

        pkts_to_be_removed = skb_queue_len(&h5->unack);

+#ifdef DEBUG
        printk("%s: unack len %d\n", pkts_to_be_removed);
+#endif

        seqno = h5->msgq_txseq;

        while (pkts_to_be_removed) {
+#ifdef DEBUG
                printk("ack %d seq %d\n", h5->rxack, seqno);
+#endif
                if (h5->rxack == seqno)
                        break;

@@ -389,7 +394,9 @@ static void h5_pkt_cull(struct h5_struct *h5)
                seqno = (seqno - 1) & 0x07;
        }

+#ifdef DEBUG
        printk("seqno now %d\n", seqno);
+#endif

        if (h5->rxack != seqno)
                BT_ERR("Peer acked invalid packet");
@@ -529,7 +536,7 @@ static void h5_complete_rx_pkt(struct hci_uart *hu)
                h5->txack_req    = 1;

                /* If needed, transmit an ack pkt */
-               hci_uart_tx_wakeup(hu);
+               // hci_uart_tx_wakeup(hu); // wait till end of buffer
        }

        h5->rxack = (h5->rx_skb->data[0] >> 3) & 0x07;
@@ -611,11 +618,17 @@ static int h5_recv(struct hci_uart *hu, void *data, int count)
        ptr = data;

        while (count) {
-               // printk("while count %d rx_count %d\n", count, h5->rx_count);
+#ifdef DEBUG
+               printk("while count %d rx_count %d\n", count, h5->rx_count);
+#endif

                if (h5->rx_count) {
                        if (*ptr == 0xc0) {
                                BT_ERR("Short H5 packet");
+#ifdef DEBUG
+                               printk("Short H5 %02x count %d rx_count %d state %d\n",
+                                       *ptr, count, h5->rx_count, h5->rx_state);
+#endif
                                kfree_skb(h5->rx_skb);
                                h5->rx_state = H5_W4_PKT_START;
                                h5->rx_count = 0;
@@ -626,7 +639,9 @@ static int h5_recv(struct hci_uart *hu, void *data, int count)
                        continue;
                }

-               // printk("switch state %d\n", h5->rx_state);
+#ifdef DEBUG
+               printk("switch state %d\n", h5->rx_state);
+#endif

                switch (h5->rx_state) {
                case H5_W4_H5_HDR:
@@ -641,9 +656,11 @@ static int h5_recv(struct hci_uart *hu, void *data, int count)


                        if (h5->rx_skb->data[0] & 0x80) {       /* reliable pkt */
+#ifdef DEBUG
                                printk("%0x != %0x ? %d\n", h5->rx_skb->data[0] & 0x07,
                                        h5->rxseq_txack,
                                        (h5->rx_skb->data[0] & 0x07) != h5->rxseq_txack);
+#endif

                                if ((h5->rx_skb->data[0] & 0x07) != h5->rxseq_txack) {
                                        BT_ERR ("Out-of-order packet arrived, got %u expected %u",
@@ -672,11 +689,6 @@ static int h5_recv(struct hci_uart *hu, void *data, int count)

                        continue;

-               case H5_W4_CRC1:
-                       h5->rx_state = H5_W4_CRC;
-                       count--;
-                       continue;
-
                case H5_W4_CRC:
                        if (bitrev16(h5->message_crc) != h5_get_crc(h5)) {
                                BT_ERR ("Checksum failed: computed %04x received %04x",
@@ -689,6 +701,7 @@ static int h5_recv(struct hci_uart *hu, void *data, int count)
                                continue;
                        }
                        skb_trim(h5->rx_skb, h5->rx_skb->len - 2);
+
                        h5_complete_rx_pkt(hu);
                        h5->rx_state = H5_W4_PKT_DELIMITER;
                        count--;
@@ -699,8 +712,13 @@ static int h5_recv(struct hci_uart *hu, void *data, int count)
                        case 0xc0:
                                h5->rx_state = H5_W4_PKT_START;
                                break;
+
+                       case 0x11:
+                               // hci_uart_tx_wakeup(hu);
+                               break;
+
                        default:
-                               /*BT_ERR("Ignoring byte %02x", *ptr);*/
+                               BT_ERR("Ignoring byte %02x", *ptr);
                                break;
                        }
                        ptr++; count--;
@@ -712,6 +730,11 @@ static int h5_recv(struct hci_uart *hu, void *data, int count)
                                ptr++; count--;
                                break;

+                       case 0x11:
+                               // hci_uart_tx_wakeup(hu);
+                               ptr++; count--;
+                               break;
+
                        default:
                                h5->rx_state = H5_W4_H5_HDR;
                                h5->rx_count = 4;
@@ -735,6 +758,12 @@ static int h5_recv(struct hci_uart *hu, void *data, int count)
                        break;
                }
        }
+
+       if (h5->txack_req) {
+               /* If needed, transmit an ack pkt */
+               hci_uart_tx_wakeup(hu);
+       }
+
        return count;
 }

--
1.7.1


>From c408f919e96cc8ec51956377b1ed1777b21f5885 Mon Sep 17 00:00:00 2001
From: Mark P. Mendelsohn <mpm>
Date: Fri, 30 Sep 2011 13:42:25 -0700
Subject: [PATCH 08/10] change license per Matt Sant

---
 drivers/bluetooth/hci_h5.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index 7a40565..957dc3e 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -1,4 +1,22 @@
 /*
+ *  Copyright 2011 Broadcom Corporation
+ *
+ *  This software is licensed to you under the terms of the GNU General
+ *  Public License version 2 (the "GPL"), available at
+ *  http://www.broadcom.com/licenses/GPLv2.php.
+ *
+ *  This software is based upon Bluetooth HCI UART driver, which was developed
+ *  by Fabrizio Gennari <fabrizio.gennari@philips.com> (Copyright (C) 2002-2003)
+ *  and Marcel Holtmann <marcel@holtmann.org> (Copyright (C) 2004-2005).
+ *  The original Bluetooth HCI UART driver is available here: http://www.kernel.org
+ *
+ *  This software is distributed WITHOUT ANY WARRANTY; including the implied
+ *  warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ *
+ */
+
+/*
  *
  *  Bluetooth HCI UART driver
  *
--
1.7.1


>From 08a6798ee23088a66ec01befece7ec08b7bac14f Mon Sep 17 00:00:00 2001
From: Mark P. Mendelsohn <mpm>
Date: Mon, 3 Oct 2011 12:40:04 -0700
Subject: [PATCH 09/10] fix count error on multiple packets in one buffer

---
 drivers/bluetooth/hci_h5.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index 957dc3e..d629d2b 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -637,7 +637,8 @@ static int h5_recv(struct hci_uart *hu, void *data, int count)

        while (count) {
 #ifdef DEBUG
-               printk("while count %d rx_count %d\n", count, h5->rx_count);
+               printk("while count %d rx_count %d ptr %02x state %d\n", count,
+                       h5->rx_count, *ptr, h5->rx_state);
 #endif

                if (h5->rx_count) {
@@ -722,7 +723,6 @@ static int h5_recv(struct hci_uart *hu, void *data, int count)

                        h5_complete_rx_pkt(hu);
                        h5->rx_state = H5_W4_PKT_DELIMITER;
-                       count--;
                        continue;

                case H5_W4_PKT_DELIMITER:
@@ -777,6 +777,9 @@ static int h5_recv(struct hci_uart *hu, void *data, int count)
                }
        }

+       printk("leaving h5_recv rx_state %d rx_count %d ptr %02x\n", h5->rx_state,
+               h5->rx_count, *ptr);
+
        if (h5->txack_req) {
                /* If needed, transmit an ack pkt */
                hci_uart_tx_wakeup(hu);
--
1.7.1


>From 2658d101fd3925ed293b30b8f0910561ba12d21a Mon Sep 17 00:00:00 2001
From: Mark P. Mendelsohn <mpm>
Date: Mon, 24 Oct 2011 09:57:04 -0700
Subject: [PATCH 10/10] conditional compile debug statements

---
 drivers/bluetooth/hci_h5.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index d629d2b..2effe06 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -317,7 +317,10 @@ static struct sk_buff *h5_prepare_pkt(struct h5_struct *h5, u8 *data,

        h5_slip_msgdelim(nskb);

+#ifdef DEBUG
        print_hex_dump_bytes("h5_tx ", DUMP_PREFIX_NONE, nskb->data, nskb->len);
+#endif
+
        return nskb;
 }

@@ -631,7 +634,9 @@ static int h5_recv(struct hci_uart *hu, void *data, int count)
        BT_DBG("hu %p count %d rx_state %d rx_count %ld\n",
                hu, count, h5->rx_state, h5->rx_count);

+#ifdef DEBUG
        print_hex_dump_bytes("h5_recv ", DUMP_PREFIX_NONE, data, count);
+#endif

        ptr = data;

@@ -777,8 +782,10 @@ static int h5_recv(struct hci_uart *hu, void *data, int count)
                }
        }

+#ifdef DEBUG
        printk("leaving h5_recv rx_state %d rx_count %d ptr %02x\n", h5->rx_state,
                h5->rx_count, *ptr);
+#endif

        if (h5->txack_req) {
                /* If needed, transmit an ack pkt */
--
1.7.1

