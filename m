Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab0E1DMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 23:12:34 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30327 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758317Ab0E1DMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 23:12:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,5995"; a="42664047"
X-IronPort-AV: E=Sophos;i="4.53,315,1272870000"; 
   d="scan'208";a="72693480"
From: Ron Shaffer <rshaffer@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: Ron Shaffer <rshaffer@codeaurora.org>
Subject: [PATCH 3/3] Bluetooth: Synchronize SCO/eSCO connection requests to ACL state
Date: Thu, 27 May 2010 23:12:06 -0400
Message-Id: <1275016326-15795-4-git-send-email-rshaffer@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1275016326-15795-1-git-send-email-rshaffer@codeaurora.org>
References: <1275016326-15795-1-git-send-email-rshaffer@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain headsets such as the Motorola H350 will reject SCO and eSCO
connection requests while the ACL is transitioning from sniff mode
to active mode. Add synchronization so that SCO and eSCO connection
requests will wait until the ACL has fully transitioned to active mode.

Signed-off-by: Ron Shaffer <rshaffer@codeaurora.org>
---
 include/net/bluetooth/hci_core.h |    1 +
 net/bluetooth/hci_conn.c         |   18 ++++++++++++++++++
 net/bluetooth/hci_event.c        |   23 ++++++++++++++++++++++-
 3 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index fd53323..c4a37fc 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -250,6 +250,7 @@ enum {
 	HCI_CONN_ENCRYPT_PEND,
 	HCI_CONN_RSWITCH_PEND,
 	HCI_CONN_MODE_CHANGE_PEND,
+	HCI_CONN_SCO_PEND,
 };
 
 static inline void hci_conn_hash_init(struct hci_dev *hdev)
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 9bf4308..e900f85 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -117,9 +117,18 @@ void hci_add_sco(struct hci_conn *conn, __u16 handle)
 {
 	struct hci_dev *hdev = conn->hdev;
 	struct hci_cp_add_sco cp;
+	struct hci_conn *acl = conn->link;
 
 	BT_DBG("%p", conn);
 
+	if (acl->mode == HCI_CM_SNIFF &&
+			test_bit(HCI_CONN_MODE_CHANGE_PEND, &acl->pend)) {
+		set_bit(HCI_CONN_SCO_PEND, &conn->pend);
+		return;
+	}
+
+	clear_bit(HCI_CONN_SCO_PEND, &conn->pend);
+
 	conn->state = BT_CONNECT;
 	conn->out = 1;
 
@@ -135,9 +144,18 @@ void hci_setup_sync(struct hci_conn *conn, __u16 handle)
 {
 	struct hci_dev *hdev = conn->hdev;
 	struct hci_cp_setup_sync_conn cp;
+	struct hci_conn *acl = conn->link;
 
 	BT_DBG("%p", conn);
 
+	if (acl->mode == HCI_CM_SNIFF &&
+			test_bit(HCI_CONN_MODE_CHANGE_PEND, &acl->pend)) {
+		set_bit(HCI_CONN_SCO_PEND, &conn->pend);
+		return;
+	}
+
+	clear_bit(HCI_CONN_SCO_PEND, &conn->pend);
+
 	conn->state = BT_CONNECT;
 	conn->out = 1;
 
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 3af537a..7692db6 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -615,6 +615,7 @@ static void hci_cs_add_sco(struct hci_dev *hdev, __u8 status)
 	acl = hci_conn_hash_lookup_handle(hdev, handle);
 	if (acl && (sco = acl->link)) {
 		sco->state = BT_CLOSED;
+		clear_bit(HCI_CONN_SCO_PEND, &sco->pend);
 
 		hci_proto_connect_cfm(sco, status);
 		hci_conn_del(sco);
@@ -760,6 +761,7 @@ static void hci_cs_setup_sync_conn(struct hci_dev *hdev, __u8 status)
 	acl = hci_conn_hash_lookup_handle(hdev, handle);
 	if (acl && (sco = acl->link)) {
 		sco->state = BT_CLOSED;
+		clear_bit(HCI_CONN_SCO_PEND, &sco->pend);
 
 		hci_proto_connect_cfm(sco, status);
 		hci_conn_del(sco);
@@ -795,6 +797,7 @@ static void hci_cs_exit_sniff_mode(struct hci_dev *hdev, __u8 status)
 {
 	struct hci_cp_exit_sniff_mode *cp;
 	struct hci_conn *conn;
+	struct hci_conn *sco;
 
 	BT_DBG("%s status 0x%x", hdev->name, status);
 
@@ -808,9 +811,17 @@ static void hci_cs_exit_sniff_mode(struct hci_dev *hdev, __u8 status)
 	hci_dev_lock(hdev);
 
 	conn = hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(cp->handle));
-	if (conn)
+	if (conn) {
 		clear_bit(HCI_CONN_MODE_CHANGE_PEND, &conn->pend);
 
+		sco = conn->link;
+		if (sco && test_and_clear_bit(HCI_CONN_SCO_PEND, &sco->pend)) {
+				hci_proto_connect_cfm(sco, status);
+				hci_conn_del(sco);
+			}
+		}
+	}
+
 	hci_dev_unlock(hdev);
 }
 
@@ -1463,6 +1474,7 @@ static inline void hci_mode_change_evt(struct hci_dev *hdev, struct sk_buff *skb
 {
 	struct hci_ev_mode_change *ev = (void *) skb->data;
 	struct hci_conn *conn;
+	struct hci_conn *sco;
 
 	BT_DBG("%s status %d", hdev->name, ev->status);
 
@@ -1478,6 +1490,15 @@ static inline void hci_mode_change_evt(struct hci_dev *hdev, struct sk_buff *skb
 				conn->power_save = 1;
 			else
 				conn->power_save = 0;
+		} else {
+			sco = conn->link;
+			if (sco && test_and_clear_bit(HCI_CONN_SCO_PEND,
+					&sco->pend)) {
+				if (lmp_esco_capable(hdev))
+					hci_setup_sync(sco, conn->handle);
+				else
+					hci_add_sco(sco, conn->handle);
+			}
 		}
 	}
 
-- 
1.7.0.2

--
Ron Shaffer
Qualcomm Innocation Center, Inc.
Qualcomm Innocation Center, Inc. is a member of Code Aurora Forum
