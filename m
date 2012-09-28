Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030921Ab2I1UdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:33:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47839 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab2I1UbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:31:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Vinicius Costa Gomes <vinicius.gomes@openbossa.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 175/218] Bluetooth: Change signature of smp_conn_security()
Date: Fri, 28 Sep 2012 13:16:32 -0700
Message-Id: <20120928201521.596818330@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>

commit cc110922da7e902b62d18641a370fec01a9fa794 upstream.

To make it clear that it may be called from contexts that may not have
any knowledge of L2CAP, we change the connection parameter, to receive
a hci_conn.

This also makes it clear that it is checking the security of the link.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/bluetooth/smp.h |    2 +-
 net/bluetooth/l2cap_core.c  |   11 ++++++-----
 net/bluetooth/l2cap_sock.c  |    2 +-
 net/bluetooth/smp.c         |    4 ++--
 4 files changed, 10 insertions(+), 9 deletions(-)

--- a/include/net/bluetooth/smp.h
+++ b/include/net/bluetooth/smp.h
@@ -136,7 +136,7 @@ struct smp_chan {
 };
 
 /* SMP Commands */
-int smp_conn_security(struct l2cap_conn *conn, __u8 sec_level);
+int smp_conn_security(struct hci_conn *hcon, __u8 sec_level);
 int smp_sig_channel(struct l2cap_conn *conn, struct sk_buff *skb);
 int smp_distribute_keys(struct l2cap_conn *conn, __u8 force);
 int smp_user_confirm_reply(struct hci_conn *conn, u16 mgmt_op, __le32 passkey);
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -937,14 +937,15 @@ static void l2cap_chan_ready(struct l2ca
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
 
 	mutex_lock(&conn->chan_lock);
 
@@ -952,8 +953,8 @@ static void l2cap_conn_ready(struct l2ca
 
 		l2cap_chan_lock(chan);
 
-		if (conn->hcon->type == LE_LINK) {
-			if (smp_conn_security(conn, chan->sec_level))
+		if (hcon->type == LE_LINK) {
+			if (smp_conn_security(hcon, chan->sec_level))
 				l2cap_chan_ready(chan);
 
 		} else if (chan->chan_type != L2CAP_CHAN_CONN_ORIENTED) {
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -588,7 +588,7 @@ static int l2cap_sock_setsockopt(struct
 				break;
 			}
 
-			if (smp_conn_security(conn, sec.level))
+			if (smp_conn_security(conn->hcon, sec.level))
 				break;
 			sk->sk_state = BT_CONFIG;
 			chan->state = BT_CONFIG;
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -753,9 +753,9 @@ static u8 smp_cmd_security_req(struct l2
 	return 0;
 }
 
-int smp_conn_security(struct l2cap_conn *conn, __u8 sec_level)
+int smp_conn_security(struct hci_conn *hcon, __u8 sec_level)
 {
-	struct hci_conn *hcon = conn->hcon;
+	struct l2cap_conn *conn = hcon->l2cap_data;
 	struct smp_chan *smp = conn->smp_chan;
 	__u8 authreq;
 


