Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab2JGXdn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:33:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38519 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753122Ab2JGXWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:55 -0400
Message-Id: <20121007225842.863675485@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:33 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vinicius Costa Gomes <vinicius.gomes@openbossa.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 059/108] Bluetooth: Change signature of smp_conn_security()
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>

commit cc110922da7e902b62d18641a370fec01a9fa794 upstream.

To make it clear that it may be called from contexts that may not have
any knowledge of L2CAP, we change the connection parameter, to receive
a hci_conn.

This also makes it clear that it is checking the security of the link.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/bluetooth/smp.h |    2 +-
 net/bluetooth/l2cap_core.c  |   11 ++++++-----
 net/bluetooth/l2cap_sock.c  |    2 +-
 net/bluetooth/smp.c         |    4 ++--
 4 files changed, 10 insertions(+), 9 deletions(-)

--- a/include/net/bluetooth/smp.h
+++ b/include/net/bluetooth/smp.h
@@ -131,7 +131,7 @@ struct smp_chan {
 };
 
 /* SMP Commands */
-int smp_conn_security(struct l2cap_conn *conn, __u8 sec_level);
+int smp_conn_security(struct hci_conn *hcon, __u8 sec_level);
 int smp_sig_channel(struct l2cap_conn *conn, struct sk_buff *skb);
 int smp_distribute_keys(struct l2cap_conn *conn, __u8 force);
 
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -902,14 +902,15 @@ static void l2cap_chan_ready(struct sock
 static void l2cap_conn_ready(struct l2cap_conn *conn)
 {
 	struct l2cap_chan *chan;
+	struct hci_conn *hcon = conn->hcon;
 
 	BT_DBG("conn %p", conn);
 
-	if (!conn->hcon->out && conn->hcon->type == LE_LINK)
+	if (!hcon->out && hcon->type == LE_LINK)
 		l2cap_le_conn_ready(conn);
 
-	if (conn->hcon->out && conn->hcon->type == LE_LINK)
-		smp_conn_security(conn, conn->hcon->pending_sec_level);
+	if (hcon->out && hcon->type == LE_LINK)
+		smp_conn_security(hcon, hcon->pending_sec_level);
 
 	read_lock(&conn->chan_lock);
 
@@ -918,8 +919,8 @@ static void l2cap_conn_ready(struct l2ca
 
 		bh_lock_sock(sk);
 
-		if (conn->hcon->type == LE_LINK) {
-			if (smp_conn_security(conn, chan->sec_level))
+		if (hcon->type == LE_LINK) {
+			if (smp_conn_security(hcon, chan->sec_level))
 				l2cap_chan_ready(sk);
 
 		} else if (chan->chan_type != L2CAP_CHAN_CONN_ORIENTED) {
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -616,7 +616,7 @@ static int l2cap_sock_setsockopt(struct
 				break;
 			}
 
-			if (smp_conn_security(conn, sec.level))
+			if (smp_conn_security(conn->hcon, sec.level))
 				break;
 
 			err = 0;
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -554,9 +554,9 @@ static u8 smp_cmd_security_req(struct l2
 	return 0;
 }
 
-int smp_conn_security(struct l2cap_conn *conn, __u8 sec_level)
+int smp_conn_security(struct hci_conn *hcon, __u8 sec_level)
 {
-	struct hci_conn *hcon = conn->hcon;
+	struct l2cap_conn *conn = hcon->l2cap_data;
 	struct smp_chan *smp = conn->smp_chan;
 
 	BT_DBG("conn %p hcon %p level 0x%2.2x", conn, hcon, sec_level);


