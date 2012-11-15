Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993187Ab2KOEey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:34:54 -0500
Received: from mail.kernel.org ([198.145.19.201]:49093 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933390Ab2KOEL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:11:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Marek Lindner <lindner_marek@yahoo.de>
Subject: =?UTF-8?q?=5B=2033/66=5D=20batman-adv=3A=20Fix=20broadcast=20packet=20CRC=20calculation?=
Date: Wed, 14 Nov 2012 20:10:38 -0800
Message-Id: <20121115040941.394047398@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Lüssing <linus.luessing@web.de>

commit 7f112af40fecf5399b61e69ffc6b55a9d82789f7 upstream.

So far the crc16 checksum for a batman-adv broadcast data packet, received
on a batman-adv hard interface, was calculated over zero bytes of its
content leading to many incoming broadcast data packets wrongly being
dropped (60-80% packet loss).

This patch fixes this issue by calculating the crc16 over the actual,
complete broadcast payload.

The issue is a regression introduced by
("batman-adv: add broadcast duplicate check").

Signed-off-by: Linus Lüssing <linus.luessing@web.de>
Acked-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Marek Lindner <lindner_marek@yahoo.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/batman-adv/bridge_loop_avoidance.c |    8 ++++----
 net/batman-adv/routing.c               |    8 +++++++-
 2 files changed, 11 insertions(+), 5 deletions(-)

--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -1205,8 +1205,8 @@ int batadv_bla_init(struct batadv_priv *
 /**
  * batadv_bla_check_bcast_duplist
  * @bat_priv: the bat priv with all the soft interface information
- * @bcast_packet: originator mac address
- * @hdr_size: maximum length of the frame
+ * @bcast_packet: encapsulated broadcast frame plus batman header
+ * @bcast_packet_len: length of encapsulated broadcast frame plus batman header
  *
  * check if it is on our broadcast list. Another gateway might
  * have sent the same packet because it is connected to the same backbone,
@@ -1219,14 +1219,14 @@ int batadv_bla_init(struct batadv_priv *
  */
 int batadv_bla_check_bcast_duplist(struct batadv_priv *bat_priv,
 				   struct batadv_bcast_packet *bcast_packet,
-				   int hdr_size)
+				   int bcast_packet_len)
 {
 	int i, length, curr;
 	uint8_t *content;
 	uint16_t crc;
 	struct batadv_bcast_duplist_entry *entry;
 
-	length = hdr_size - sizeof(*bcast_packet);
+	length = bcast_packet_len - sizeof(*bcast_packet);
 	content = (uint8_t *)bcast_packet;
 	content += sizeof(*bcast_packet);
 
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -1136,8 +1136,14 @@ int batadv_recv_bcast_packet(struct sk_b
 
 	spin_unlock_bh(&orig_node->bcast_seqno_lock);
 
+	/* keep skb linear for crc calculation */
+	if (skb_linearize(skb) < 0)
+		goto out;
+
+	bcast_packet = (struct batadv_bcast_packet *)skb->data;
+
 	/* check whether this has been sent by another originator before */
-	if (batadv_bla_check_bcast_duplist(bat_priv, bcast_packet, hdr_size))
+	if (batadv_bla_check_bcast_duplist(bat_priv, bcast_packet, skb->len))
 		goto out;
 
 	/* rebroadcast packet */


