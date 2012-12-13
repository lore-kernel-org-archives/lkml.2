Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203Ab2LMOMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:12:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44920 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933157Ab2LMOM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:12:29 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>,
        Marek Lindner <lindner_marek@yahoo.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 189/241] batman-adv: Fix broadcast packet CRC calculation
Date: Thu, 13 Dec 2012 11:59:14 -0200
Message-Id: <1355407206-17100-190-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>

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
[ herton: use backported version provided on stable mailing list, but
  drop unrelated comment change ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/batman-adv/bridge_loop_avoidance.c |    8 ++++----
 net/batman-adv/routing.c               |    8 +++++++-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index c5863f4..2531044 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -1172,8 +1172,8 @@ int bla_init(struct bat_priv *bat_priv)
 
 /**
  * @bat_priv: the bat priv with all the soft interface information
- * @bcast_packet: originator mac address
- * @hdr_size: maximum length of the frame
+ * @bcast_packet: encapsulated broadcast frame plus batman header
+ * @bcast_packet_len: length of encapsulated broadcast frame plus batman header
  *
  * check if it is on our broadcast list. Another gateway might
  * have sent the same packet because it is connected to the same backbone,
@@ -1188,14 +1188,14 @@ int bla_init(struct bat_priv *bat_priv)
 
 int bla_check_bcast_duplist(struct bat_priv *bat_priv,
 			    struct bcast_packet *bcast_packet,
-			    int hdr_size)
+			    int bcast_packet_len)
 {
 	int i, length, curr;
 	uint8_t *content;
 	uint16_t crc;
 	struct bcast_duplist_entry *entry;
 
-	length = hdr_size - sizeof(*bcast_packet);
+	length = bcast_packet_len - sizeof(*bcast_packet);
 	content = (uint8_t *)bcast_packet;
 	content += sizeof(*bcast_packet);
 
diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index 015471d..af40ca3 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -1081,8 +1081,14 @@ int recv_bcast_packet(struct sk_buff *skb, struct hard_iface *recv_if)
 
 	spin_unlock_bh(&orig_node->bcast_seqno_lock);
 
+	/* keep skb linear for crc calculation */
+	if (skb_linearize(skb) < 0)
+		goto out;
+
+	bcast_packet = (struct bcast_packet *)skb->data;
+
 	/* check whether this has been sent by another originator before */
-	if (bla_check_bcast_duplist(bat_priv, bcast_packet, hdr_size))
+	if (bla_check_bcast_duplist(bat_priv, bcast_packet, skb->len))
 		goto out;
 
 	/* rebroadcast packet */
-- 
1.7.9.5

