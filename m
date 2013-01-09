Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934085Ab3AIUu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:50:27 -0500
Received: from mail.kernel.org ([198.145.19.201]:43901 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934061Ab3AIUlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:41:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chan-yeol Park <chanyeol.park@gmail.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 111/123] Revert "Bluetooth: Fix possible deadlock in SCO code"
Date: Wed,  9 Jan 2013 12:35:50 -0800
Message-Id: <20130109201512.687114098@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo Padovan <gustavo.padovan@collabora.co.uk>

commit 0b27a4b97cb1874503c78453c0903df53c0c86b2 upstream.

This reverts commit 269c4845d5b3627b95b1934107251bacbe99bb68.

The commit was causing dead locks and NULL dereferences in the sco code:

 [28084.104013] BUG: soft lockup - CPU#0 stuck for 22s! [kworker/u:0H:7]
 [28084.104021] Modules linked in: btusb bluetooth <snip [last unloaded:
bluetooth]
...
 [28084.104021]  [<c160246d>] _raw_spin_lock+0xd/0x10
 [28084.104021]  [<f920e708>] sco_conn_del+0x58/0x1b0 [bluetooth]
 [28084.104021]  [<f920f1a9>] sco_connect_cfm+0xb9/0x2b0 [bluetooth]
 [28084.104021]  [<f91ef289>]
hci_sync_conn_complete_evt.isra.94+0x1c9/0x260 [bluetooth]
 [28084.104021]  [<f91f1a8d>] hci_event_packet+0x74d/0x2b40 [bluetooth]
 [28084.104021]  [<c1501abd>] ? __kfree_skb+0x3d/0x90
 [28084.104021]  [<c1501b46>] ? kfree_skb+0x36/0x90
 [28084.104021]  [<f91fcb4e>] ? hci_send_to_monitor+0x10e/0x190 [bluetooth]
 [28084.104021]  [<f91fcb4e>] ? hci_send_to_monitor+0x10e/0x190 [bluetooth]

Reported-by: Chan-yeol Park <chanyeol.park@gmail.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/sco.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -131,15 +131,6 @@ static int sco_conn_del(struct hci_conn
 		sco_sock_clear_timer(sk);
 		sco_chan_del(sk, err);
 		bh_unlock_sock(sk);
-
-		sco_conn_lock(conn);
-		conn->sk = NULL;
-		sco_pi(sk)->conn = NULL;
-		sco_conn_unlock(conn);
-
-		if (conn->hcon)
-			hci_conn_put(conn->hcon);
-
 		sco_sock_kill(sk);
 	}
 
@@ -830,6 +821,16 @@ static void sco_chan_del(struct sock *sk
 
 	BT_DBG("sk %p, conn %p, err %d", sk, conn, err);
 
+	if (conn) {
+		sco_conn_lock(conn);
+		conn->sk = NULL;
+		sco_pi(sk)->conn = NULL;
+		sco_conn_unlock(conn);
+
+		if (conn->hcon)
+			hci_conn_put(conn->hcon);
+	}
+
 	sk->sk_state = BT_CLOSED;
 	sk->sk_err   = err;
 	sk->sk_state_change(sk);


