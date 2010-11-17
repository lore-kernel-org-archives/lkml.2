Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935562Ab0KQWcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:32:04 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39072 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935070Ab0KQWcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:32:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XaSghaKspLUXkkKPIbBquJO0DVMDR7inTQT40Br5zAArgvIfsfYnqzMKoujOjfoWUj
         lvijtdmMzA2XP51B6G06wT02Nsn6p4UaTUaD4rP9pU3O3ym0z18tYTGbz//0Gs45MEPr
         bYeAo8KQCNRGOoi+HRYtF/AQVgaH0rBlA1YFI=
From: johan.hedberg@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Johan Hedberg <johan.hedberg@nokia.com>
Subject: [PATCH 2/2] Bluetooth: Automate remote name requests
Date: Thu, 18 Nov 2010 00:31:30 +0200
Message-Id: <1290033090-21100-2-git-send-email-johan.hedberg@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290033090-21100-1-git-send-email-johan.hedberg@gmail.com>
References: <1290033090-21100-1-git-send-email-johan.hedberg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hedberg <johan.hedberg@nokia.com>

In Bluetooth there are no automatic updates of remote device names when
they get changed on the remote side. Instead, it is a good idea to do a
manual name request when a new connection gets created (for whatever
reason) since at this point it is very cheap (no costly baseband
connection creation needed just for the sake of the name request).

So far userspace has been responsible for this extra name request but
tighter control is needed in order not to flood Bluetooth controllers
with two many commands during connection creation. It has been shown
that some controllers simply fail to function correctly if they get too
many (almost) simultaneous commands during connection creation. The
simplest way to acheive better control of these commands is to move
their sending completely to the kernel side.

This patch inserts name requests into the sequence of events that the
kernel performs during connection creation. It does this after the
remote features have been successfully requested and before any pending
authentication requests are performed. The code will work sub-optimally
with userspace versions that still do the name requesting themselves (it
shouldn't break anything though) so it is recommended to combine this
with a userspace software version that doesn't have automated name
requests.

Signed-off-by: Johan Hedberg <johan.hedberg@nokia.com>
---
 net/bluetooth/hci_event.c |   72 +++++++++++++++++++++++++++++++++-----------
 1 files changed, 54 insertions(+), 18 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 9c6d9bc..4165895 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -677,11 +677,9 @@ static void hci_cs_set_conn_encrypt(struct hci_dev *hdev, __u8 status)
 	hci_dev_unlock(hdev);
 }
 
-static int hci_request_outgoing_auth(struct hci_dev *hdev,
+static int hci_outgoing_auth_needed(struct hci_dev *hdev,
 						struct hci_conn *conn)
 {
-	struct hci_cp_auth_requested cp;
-
 	if (conn->state != BT_CONFIG || !conn->out)
 		return 0;
 
@@ -694,15 +692,35 @@ static int hci_request_outgoing_auth(struct hci_dev *hdev,
 					conn->sec_level != BT_SECURITY_HIGH)
 		return 0;
 
-	cp.handle = __cpu_to_le16(conn->handle);
-	hci_send_cmd(hdev, HCI_OP_AUTH_REQUESTED, sizeof(cp), &cp);
-
 	return 1;
 }
 
 static void hci_cs_remote_name_req(struct hci_dev *hdev, __u8 status)
 {
+	struct hci_cp_remote_name_req *cp;
+	struct hci_conn *conn;
+
 	BT_DBG("%s status 0x%x", hdev->name, status);
+
+	/* If successful wait for the name req complete event before
+	 * checking for the need to do authentication */
+	if (!status)
+		return;
+
+	cp = hci_sent_cmd_data(hdev, HCI_OP_REMOTE_NAME_REQ);
+	if (!cp)
+		return;
+
+	hci_dev_lock(hdev);
+
+	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &cp->bdaddr);
+	if (conn && hci_outgoing_auth_needed(hdev, conn)) {
+		struct hci_cp_auth_requested cp;
+		cp.handle = __cpu_to_le16(conn->handle);
+		hci_send_cmd(hdev, HCI_OP_AUTH_REQUESTED, sizeof(cp), &cp);
+	}
+
+	hci_dev_unlock(hdev);
 }
 
 static void hci_cs_read_remote_features(struct hci_dev *hdev, __u8 status)
@@ -1113,9 +1131,23 @@ static inline void hci_auth_complete_evt(struct hci_dev *hdev, struct sk_buff *s
 
 static inline void hci_remote_name_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
+	struct hci_ev_remote_name *ev = (void *) skb->data;
+	struct hci_conn *conn;
+
 	BT_DBG("%s", hdev->name);
 
 	hci_conn_check_pending(hdev);
+
+	hci_dev_lock(hdev);
+
+	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &ev->bdaddr);
+	if (conn && hci_outgoing_auth_needed(hdev, conn)) {
+		struct hci_cp_auth_requested cp;
+		cp.handle = __cpu_to_le16(conn->handle);
+		hci_send_cmd(hdev, HCI_OP_AUTH_REQUESTED, sizeof(cp), &cp);
+	}
+
+	hci_dev_unlock(hdev);
 }
 
 static inline void hci_encrypt_change_evt(struct hci_dev *hdev, struct sk_buff *skb)
@@ -1179,7 +1211,6 @@ static inline void hci_remote_features_evt(struct hci_dev *hdev, struct sk_buff
 {
 	struct hci_ev_remote_features *ev = (void *) skb->data;
 	struct hci_conn *conn;
-	int auth_requested;
 
 	BT_DBG("%s status %d", hdev->name, ev->status);
 
@@ -1204,12 +1235,15 @@ static inline void hci_remote_features_evt(struct hci_dev *hdev, struct sk_buff
 		goto unlock;
 	}
 
-	if (!ev->status)
-		auth_requested = hci_request_outgoing_auth(hdev, conn);
-	else
-		auth_requested = 0;
+	if (!ev->status) {
+		struct hci_cp_remote_name_req cp;
+		memset(&cp, 0, sizeof(cp));
+		bacpy(&cp.bdaddr, &conn->dst);
+		cp.pscan_rep_mode = 0x02;
+		hci_send_cmd(hdev, HCI_OP_REMOTE_NAME_REQ, sizeof(cp), &cp);
+	}
 
-	if (!auth_requested) {
+	if (!hci_outgoing_auth_needed(hdev, conn)) {
 		conn->state = BT_CONNECTED;
 		hci_proto_connect_cfm(conn, ev->status);
 		hci_conn_put(conn);
@@ -1667,7 +1701,6 @@ static inline void hci_remote_ext_features_evt(struct hci_dev *hdev, struct sk_b
 {
 	struct hci_ev_remote_ext_features *ev = (void *) skb->data;
 	struct hci_conn *conn;
-	int auth_requested;
 
 	BT_DBG("%s", hdev->name);
 
@@ -1689,12 +1722,15 @@ static inline void hci_remote_ext_features_evt(struct hci_dev *hdev, struct sk_b
 	if (conn->state != BT_CONFIG)
 		goto unlock;
 
-	if (!ev->status)
-		auth_requested = hci_request_outgoing_auth(hdev, conn);
-	else
-		auth_requested = 0;
+	if (!ev->status) {
+		struct hci_cp_remote_name_req cp;
+		memset(&cp, 0, sizeof(cp));
+		bacpy(&cp.bdaddr, &conn->dst);
+		cp.pscan_rep_mode = 0x02;
+		hci_send_cmd(hdev, HCI_OP_REMOTE_NAME_REQ, sizeof(cp), &cp);
+	}
 
-	if (!auth_requested) {
+	if (!hci_outgoing_auth_needed(hdev, conn)) {
 		conn->state = BT_CONNECTED;
 		hci_proto_connect_cfm(conn, ev->status);
 		hci_conn_put(conn);
-- 
1.7.2.3

